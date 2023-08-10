<script>
  import { onMount } from 'svelte';
  import regl from 'regl';

  import vertexShader from './shaders/vertexShader.glsl';
	import fragmentShader_aufbau from './shaders/fragmentShader-aufbau.glsl';
	import fragmentShader_niels from './shaders/fragmentShader-niels.glsl';
	import fragmentShader_sicovecas1 from './shaders/fragmentShader-sicovecas1.glsl';
	import fragmentShader_sicovecas2 from './shaders/fragmentShader-sicovecas2.glsl';

	let shaderMaterial_aufbau, shaderMaterial_niels, shaderMaterial_sicovecas1, shaderMaterial_sicovecas2;

  let canvas;

  onMount(() => {
    const rgl = regl({ canvas });

    // Define the command that draws a colored square
    const drawSquare = rgl({
      frag: `
        precision mediump float;
        uniform vec4 color;
        void main() {
          gl_FragColor = color;
        }
      `,
      vert: `
        precision mediump float;
        attribute vec2 position;
        void main() {
          gl_Position = vec4(position, 0, 1);
        }
      `,
      attributes: {
        position: [
          [-1, -1],
          [-1, 1],
          [1, 1],
          [-1, -1],
          [1, 1],
          [1, -1]
        ]
      },
      uniforms: {
        color: [0.5, 0.5, 0.5, 1]  // gray color
      },
      count: 6
    });

    // Render the square
    drawSquare();

    // Handle cleanup
    return () => rgl.destroy();
  });
</script>

<canvas bind:this={canvas} class:geometry={true}></canvas>

<style>
	.geometry {
		position: absolute;
		overflow: hidden;
		z-index: -1;
	}
</style>