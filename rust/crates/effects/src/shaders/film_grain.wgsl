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
// scalars.y = grain size (1.0 to 5.0)
// scalars.z = time seed

fn hash(p: vec2f) -> f32 {
    var p2 = fract(p * vec2f(234.34, 435.345));
    p2 += dot(p2, p2 + 34.23);
    return fract(p2.x * p2.y);
}

@fragment
fn fragment_main(input: VertexOutput) -> @location(0) vec4f {
    let color = textureSample(input_texture, input_sampler, input.tex_coord);
    let intensity = uniforms.scalars.x;
    let grain_size = uniforms.scalars.y;
    let time = uniforms.scalars.z;

    // Generate animated grain
    let grain_uv = input.tex_coord * uniforms.resolution / grain_size;
    let noise = hash(grain_uv + vec2f(time, time * 0.7)) * 2.0 - 1.0;

    let grained = color.rgb + noise * intensity * 0.3;
    return vec4f(clamp(grained, vec3f(0.0), vec3f(1.0)), color.a);
}
