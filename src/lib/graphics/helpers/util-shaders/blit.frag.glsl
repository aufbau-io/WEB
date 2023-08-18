precision mediump float;

uniform sampler2D sourceTexture;
varying vec2 vUv;

void main() {
  gl_FragColor = texture2D(sourceTexture, vUv);
}
