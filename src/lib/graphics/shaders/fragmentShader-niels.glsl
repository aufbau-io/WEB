precision mediump float;
varying vec2 vUv;
uniform vec3 color1;
uniform vec3 color2;
uniform vec3 color3;
uniform vec3 color4;
uniform float time;
uniform vec2 mouse;

float noise(vec2 position) {
    return fract(sin(dot(position, vec2(0, 90))) * 1.5453 + (mouse.x * 0.5)) - fract(sin(dot(position, vec2(90, 90))) * 2.5453 + (mouse.y * 0.5));
}

void main() {
    float n = noise(vUv) + 0.15;
    vec3 color = mix(color1, color2, n);
    color = mix(color, color3, n*n);
    color = mix(color, color4, n*n*n);
    gl_FragColor = vec4(color, 1.0);
}
