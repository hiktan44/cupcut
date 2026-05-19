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

// scalars.x = hue shift (-1.0 to 1.0, maps to -180 to 180 degrees)
// scalars.y = saturation (-1.0 to 1.0)
// scalars.z = lightness (-1.0 to 1.0)

fn rgb_to_hsl(rgb: vec3f) -> vec3f {
    let max_c = max(max(rgb.r, rgb.g), rgb.b);
    let min_c = min(min(rgb.r, rgb.g), rgb.b);
    let delta = max_c - min_c;
    var h = 0.0;
    var s = 0.0;
    let l = (max_c + min_c) / 2.0;

    if delta > 0.001 {
        s = delta / (1.0 - abs(2.0 * l - 1.0));
        if max_c == rgb.r {
            h = ((rgb.g - rgb.b) / delta) % 6.0;
        } else if max_c == rgb.g {
            h = (rgb.b - rgb.r) / delta + 2.0;
        } else {
            h = (rgb.r - rgb.g) / delta + 4.0;
        }
        h = h / 6.0;
        if h < 0.0 { h = h + 1.0; }
    }
    return vec3f(h, s, l);
}

fn hsl_to_rgb(hsl: vec3f) -> vec3f {
    let h = hsl.x;
    let s = hsl.y;
    let l = hsl.z;
    let c = (1.0 - abs(2.0 * l - 1.0)) * s;
    let x = c * (1.0 - abs((h * 6.0) % 2.0 - 1.0));
    let m = l - c / 2.0;
    var rgb = vec3f(0.0);
    let sector = i32(h * 6.0);
    if sector == 0 { rgb = vec3f(c, x, 0.0); }
    else if sector == 1 { rgb = vec3f(x, c, 0.0); }
    else if sector == 2 { rgb = vec3f(0.0, c, x); }
    else if sector == 3 { rgb = vec3f(0.0, x, c); }
    else if sector == 4 { rgb = vec3f(x, 0.0, c); }
    else { rgb = vec3f(c, 0.0, x); }
    return clamp(rgb + vec3f(m), vec3f(0.0), vec3f(1.0));
}

@fragment
fn fragment_main(input: VertexOutput) -> @location(0) vec4f {
    let color = textureSample(input_texture, input_sampler, input.tex_coord);
    var hsl = rgb_to_hsl(color.rgb);

    hsl.x = fract(hsl.x + uniforms.scalars.x);
    hsl.y = clamp(hsl.y + uniforms.scalars.y * hsl.y, 0.0, 1.0);
    hsl.z = clamp(hsl.z + uniforms.scalars.z, 0.0, 1.0);

    return vec4f(hsl_to_rgb(hsl), color.a);
}
