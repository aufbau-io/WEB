precision mediump float;

attribute vec2 position;
varying vec2 vUv;

void main() {
  gl_Position = vec4(position, 0, 1);
  
  // This assumes that the position is in the range [-1, 1]
  // And maps it to [0, 1] for UV coordinates.
  vUv = position * 0.5 + 0.5;
}