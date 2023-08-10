<script>
	import { onMount } from 'svelte';
	import regl from 'regl';

	import vertexShader from './shaders/vertexShader.glsl';
	import fragmentShader_aufbau from './shaders/fragmentShader-aufbau.glsl';

	let canvas;
	let rgl;
	let shaderProgram;

	let mouse = [0, 0];
	let startTime = Date.now() * 0.001;
	let baseUniforms;

	function setupShaders() {
		const colors = {
			color1: [208 / 255, 208 / 255, 208 / 255],
			color5: [80 / 255, 153 / 255, 180 / 255],
			color9: [143 / 255, 189 / 255, 90 / 255]
		};

		baseUniforms = {
			time: 0.0,
			mouse,
			projectionMatrix: [
				1, 0, 0, 0,
				0, 1, 0, 0,
				0, 0, 1, 0,
				0, 0, 0, 1
			],
			modelViewMatrix: [
				1, 0, 0, 0,
				0, 1, 0, 0,
				0, 0, 1, 0,
				0, 0, 0, 1
			]
		};

		shaderProgram = createShader(fragmentShader_aufbau, {
			...baseUniforms,
			color1: colors.color1,
			color2: colors.color5,
			color3: colors.color9
		});
	}

	function createShader(fragShader, uniforms) {
		return rgl({
			frag: fragShader,
			vert: vertexShader,
			attributes: {
				position: [
					[-1, -1, 0],
					[-1, 1, 0],
					[1, 1, 0],
					[-1, -1, 0],
					[1, 1, 0],
					[1, -1, 0]
				],
				uv: [
					[0, 0],
					[0, 1],
					[1, 1],
					[0, 0],
					[1, 1],
					[1, 0]
				]
			},
			uniforms,
			count: 6
		});
	}

	function mouseMoveHandler(event) {
		mouse = [event.clientX / canvas.width, event.clientY / canvas.height];
	}

	function renderLoop() {
		const elapsedTime = (Date.now() - startTime) * 0.001;

		rgl.clear({
			color: [0.2, 0.4, 0.6, 1],
			depth: 1
		});

		shaderProgram({
			time: elapsedTime,
			mouse: mouse
		});

		requestAnimationFrame(renderLoop);
	}

	onMount(() => {
		rgl = regl({ canvas });

		canvas.addEventListener('mousemove', mouseMoveHandler);
		setupShaders();
		renderLoop();

		// Uncomment the return to handle cleanup during component destruction
		// return () => {
		// 	rgl.destroy();
		// 	canvas.removeEventListener('mousemove', mouseMoveHandler);
		// };
	});
</script>

<canvas bind:this={canvas} class:geometry={true}></canvas>

<style>
	.geometry {
		position: absolute;
		overflow: hidden;
		width: 100vw;
		height: 100vh;  /* Corrected typo "100dvh" to "100vh" */
		z-index: -1;
	}
</style>
