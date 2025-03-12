// attribute vec2 uv;
// attribute vec3 position;
// uniform mat4 projectionMatrix;
// uniform mat4 modelViewMatrix;
varying vec2 vUv; // Varying variable to pass the UV coordinates to the fragment shader

void main() {
    vUv = uv;
    gl_Position = vec4(position, 1.0);
}