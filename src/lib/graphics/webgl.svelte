<script>
  import { onMount } from 'svelte';

  import vertexShader from './shaders/vertexShader.glsl';
	import fragmentShader_aufbau from './shaders/fragmentShader-aufbau.glsl';
	import fragmentShader_niels from './shaders/fragmentShader-niels.glsl';
	import fragmentShader_sicovecas1 from './shaders/fragmentShader-sicovecas1.glsl';
	import fragmentShader_sicovecas2 from './shaders/fragmentShader-sicovecas2.glsl';

	let shaderMaterial_aufbau, shaderMaterial_niels, shaderMaterial_sicovecas1, shaderMaterial_sicovecas2;

  let canvas;

  onMount(() => {
    const gl = canvas.getContext('webgl');

    // Vertex Shader
    const vertexShaderSource = `
      attribute vec2 position;
      void main() {
        gl_Position = vec4(position, 0.0, 1.0);
      }
    `;
    const vertexShader = gl.createShader(gl.VERTEX_SHADER);
    gl.shaderSource(vertexShader, vertexShaderSource);
    gl.compileShader(vertexShader);

    // Fragment Shader
    const fragmentShaderSource = `
      precision mediump float;
      void main() {
        gl_FragColor = vec4(0.5, 0.5, 0.5, 1.0); // gray color
      }
    `;
    const fragmentShader = gl.createShader(gl.FRAGMENT_SHADER);
    gl.shaderSource(fragmentShader, fragmentShaderSource);
    gl.compileShader(fragmentShader);

    // Shader Program
    const program = gl.createProgram();
    gl.attachShader(program, vertexShader);
    gl.attachShader(program, fragmentShader);
    gl.linkProgram(program);
    gl.useProgram(program);

    // Buffer for square vertices
    const vertexBuffer = gl.createBuffer();
    gl.bindBuffer(gl.ARRAY_BUFFER, vertexBuffer);
    const vertices = new Float32Array([
      -1, -1,
      -1, 1,
      1, 1,
      -1, -1,
      1, 1,
      1, -1
    ]);
    gl.bufferData(gl.ARRAY_BUFFER, vertices, gl.STATIC_DRAW);

    const positionAttributeLocation = gl.getAttribLocation(program, "position");
    gl.enableVertexAttribArray(positionAttributeLocation);
    gl.vertexAttribPointer(positionAttributeLocation, 2, gl.FLOAT, false, 0, 0);

    // Draw
    gl.drawArrays(gl.TRIANGLES, 0, 6);

    // Cleanup
    return () => {
      gl.deleteBuffer(vertexBuffer);
      gl.deleteShader(vertexShader);
      gl.deleteShader(fragmentShader);
      gl.deleteProgram(program);
    };
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
