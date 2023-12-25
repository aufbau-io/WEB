precision mediump float;
varying vec2 vUv;
uniform vec3 color1;
uniform vec3 color2;
uniform vec3 color3;
uniform float time;
uniform vec2 mouse;

float noise(vec2 uv) {
    return atan(fract(dot(uv * 1.7, vec2(60.987, 110.654))) * 43210.1234);
}

void main() {
    vec2 position = vUv * 1.5 - 1.0;
    vec2 hex = position * 2.0;
    hex.x *= 0.57735 * 2.0;
    hex = abs(hex);
    hex -= 1.0;
    float dist = length(position - mouse) * 0.9;
    float wave = noise(vUv + time * 0.2);
    wave = (step(0.25, -hex.x - hex.y * 0.5) + step(0.0, -hex.y)) * sin(dist * 4.0 - time + wave) * cos(step(0.1, fract(position.x * 10.0)));
    vec3 color = mix(color3, color1, wave);
    color = mix(color, color2, wave * wave);
    gl_FragColor = vec4(color, 1.0);
}
