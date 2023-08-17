<script>
	import { onMount } from 'svelte';
  import regl from 'regl';

  import { screenType } from '$lib/store/store';
	import { page } from '$app/stores';

	import vertexShader from './shaders/vertexShader.glsl';
	import fragmentShader_aufbau from './shaders/fragmentShader-aufbau.glsl';
	import fragmentShader_niels from './shaders/fragmentShader-niels.glsl';
	import fragmentShader_sicovecas1 from './shaders/fragmentShader-sicovecas1.glsl';
	import fragmentShader_sicovecas2 from './shaders/fragmentShader-sicovecas2.glsl';

	// let canvas;
  // let rgl;
	// let drawSquare_aufbau, drawSquare_niels, drawSquare_sicovecas1, drawSquare_sicovecas2;
	// let color = [0.5, 0.5, 0.5, 1]; // default gray color

  let canvas;
  let rgl;
	let shaderPrograms = {};
	let shaderProgram;
	let mouse = [0, 0]; // assuming you have a way to update this
	let startTime = (Date.now()) * 0.001
	let elapsedTime = startTime;
	let baseUniforms;

	let projectionMatrix, modelViewMatrix;

	function setupProjection() {		
		// let canvasWidth =  window.innerWidth;  // assuming an initial value, update as necessary
		// let canvasHeight =  window.innerHeight; // assuming an initial value, update as necessary
		
		// let near = 0.1;
		// let far = 100.0;
		// let right = canvasWidth / 2;
		// let left = -right;
		// let top = canvasHeight / 2;
		// let bottom = -top;

		// projectionMatrix = [
		// 		2 / (right - left), 0, 0, -(right + left) / (right - left),
		// 		0, 2 / (top - bottom), 0, -(top + bottom) / (top - bottom),
		// 		0, 0, -2 / (far - near), -(far + near) / (far - near),
		// 		0, 0, 0, 1
		// ];

		// modelViewMatrix = [
		// 		1, 0, 0, 0,
		// 		0, 1, 0, 0,
		// 		0, 0, 1, 0,
		// 		0, 0, 0, 1
		// ];

		projectionMatrix = [
				1, 0, 0, 0,
				0, 1, 0, 0,
				0, 0, 1, 0,
				0, 0, 0, 1
			];
			modelViewMatrix = [
				1, 0, 0, 0,
				0, 1, 0, 0,
				0, 0, 1, 0,
				0, 0, 0, 1
			];
	}

  function setupShaders() {
		baseUniforms = {
			time: 0.0,
			mouse,
			projectionMatrix,
      modelViewMatrix
		};

		const colors = {
			color1: [208/255, 208/255, 208/255],
			color2: [187/255, 69/255, 0],
			color3: [218/255, 170/255, 85/255],
			color4: [0, 105/255, 148/255],
			color5: [80/255, 153/255, 180/255],
			color6: [0, 0, 255/255],
			color7: [0, 255/255, 0],
			color9: [143/255, 189/255, 90/255]
		};

		shaderProgram = createShader(fragmentShader_aufbau, {
			...baseUniforms,
			color1: colors.color1,
			color2: colors.color5,
			color3: colors.color9
		});

		// Create shaders with corresponding uniforms
		shaderPrograms['aufbau'] = createShader(fragmentShader_aufbau, {
			...baseUniforms,
			color1: colors.color1,
			color2: colors.color5,
			color3: colors.color9,
		});

		shaderPrograms['niels'] = createShader(fragmentShader_niels, {
			...baseUniforms,
			color1: colors.color1,
			color2: colors.color2,
			color3: colors.color6,
			color4: colors.color7
		});

		shaderPrograms['sicovecas1'] = createShader(fragmentShader_sicovecas1, {
			...baseUniforms,
			color1: colors.color4,
			color2: colors.color4,
			color3: colors.color5,
		});

		shaderPrograms['sicovecas2'] = createShader(fragmentShader_sicovecas2, {
			...baseUniforms,
			color1: colors.color1,
			color2: colors.color2,
			color3: colors.color3,
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

	function updateShaderUniforms() {
    const elapsedTime = (Date.now() - startTime) * 0.001; 

		//  shaderProgram({ 
    //             time: 100.0, 
    //             mouse: $screenType == 1 ? [4 * Math.cos(elapsedTime * 0.1), 5 * Math.cos(elapsedTime * 0.1)] : mouse 
    //         });

    switch ($page.url.pathname) {
        case '/':
            shaderPrograms['aufbau']({ 
                time: elapsedTime, 
                mouse: $screenType == 1 ? [4 * Math.cos(elapsedTime * 0.1), 5 * Math.cos(elapsedTime * 0.1)] : mouse 
            });
            break;
        case '/niels':
            shaderPrograms['niels']({
                time: elapsedTime,
                mouse: $screenType == 1 ? [elapsedTime, elapsedTime * 0.1] : mouse
            });
            break;
        case '/sicovecas':
            shaderPrograms['sicovecas1']({
                time: elapsedTime,
                mouse: mouse
            });
            shaderPrograms['sicovecas2']({
                time: elapsedTime,
                mouse: mouse
            });
            break;
			}
	}


	function mouseMoveHandler(event) {
    mouse = [event.clientX / canvas.width, event.clientY / canvas.height];
	}

	function renderLoop() {

		rgl.clear({
			color: [0.2, 0.4, 0.6, 1],
			depth: 1
		});

		rgl.poll();

    updateShaderUniforms();
    requestAnimationFrame(renderLoop);
	}


	onMount(() => {
    rgl = regl({ canvas });
		
		canvas.addEventListener('mousemove', mouseMoveHandler);

		// let dpr = window.devicePixelRatio || 1;
		canvas.width = window.innerWidth;
		canvas.height = window.innerHeight;


		setupProjection();
		setupShaders();
		renderLoop();

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
		/* width: 100vw;
		height: 100dvh; */
		z-index: -1;
	}
</style>
