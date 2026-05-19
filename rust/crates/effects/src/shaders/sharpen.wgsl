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
@fragment
fn fragment_main(input: VertexOutput) -> @location(0) vec4f {
    let color = textureSample(input_texture, input_sampler, input.tex_coord);
    let intensity = uniforms.scalars.x;
    let texel_size = 1.0 / uniforms.resolution;

    // Unsharp mask: sharpen = original + intensity * (original - blurred)
    let blur_offset = texel_size * 1.0;
    let blurred =
        textureSample(input_texture, input_sampler, input.tex_coord + vec2f(blur_offset.x, 0.0)).rgb +
        textureSample(input_texture, input_sampler, input.tex_coord - vec2f(blur_offset.x, 0.0)).rgb +
        textureSample(input_texture, input_sampler, input.tex_coord + vec2f(0.0, blur_offset.y)).rgb +
        textureSample(input_texture, input_sampler, input.tex_coord - vec2f(0.0, blur_offset.y)).rgb;
    let blurred_avg = blurred / 4.0;

    let sharpened = color.rgb + intensity * (color.rgb - blurred_avg);
    return vec4f(clamp(sharpened, vec3f(0.0), vec3f(1.0)), color.a);
}
