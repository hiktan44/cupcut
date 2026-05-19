struct VertexOutput {
    @builtin(position) position: vec4f,
    @location(0) tex_coord: vec2f,
}

struct EffectUniforms {
    resolution: vec2f,
    direction: vec2f,
    scalars: vec4f,
}

@group(0) @binding(0) var input_texture: texture_2d<f32>;
@group(0) @binding(1) var input_sampler: sampler;
@group(1) @binding(0) var<uniform> uniforms: EffectUniforms;

// scalars.x = intensity (0.0 to 1.0)
// scalars.y = softness (0.0 to 1.0)
@fragment
fn fragment_main(input: VertexOutput) -> @location(0) vec4f {
    let color = textureSample(input_texture, input_sampler, input.tex_coord);
    let intensity = uniforms.scalars.x;
    let softness = uniforms.scalars.y;

    // Distance from center (0.0 at center, ~0.707 at corners)
    let uv = input.tex_coord - vec2f(0.5);
    let dist = length(uv);

    // Smooth vignette using smoothstep
    let inner = 0.3 + softness * 0.3;
    let outer = 0.6 + softness * 0.1;
    let vignette = 1.0 - smoothstep(inner, outer, dist) * intensity;

    return vec4f(color.rgb * vignette, color.a);
}
