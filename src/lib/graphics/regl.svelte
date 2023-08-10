<script>
  import { onMount } from 'svelte';
  import regl from 'regl';

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