precision mediump float;
varying vec2 vUv;
uniform vec3 color1;
uniform vec3 color2;
uniform vec3 color3;
uniform float time;
uniform vec2 mouse;

void main() {
    vec2 position = vUv * 4.0;
    vec2 ripple = position;
    float dist = 0.1 * 3.0 + sin(0.1 * time) * sin(dot(ripple, ripple));
    dist += 0.25 * mouse.x + sin(10.0 * atan(ripple.y, ripple.x + 0.1)); // add circular distortion
    float wave = 0.25 * mouse.y  + 0.5 * (4.0 + tan(dist * 10.0));
    vec3 color = mix(color1, color2, wave);
    color = mix(color, color3, wave * wave);
    gl_FragColor = vec4(color, 1.0);
}
