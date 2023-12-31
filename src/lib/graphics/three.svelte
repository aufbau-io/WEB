<script>
	import { onMount } from 'svelte';
	import { screenType } from '$lib/store/store';
	import { page } from '$app/stores';
	import { afterNavigate } from '$app/navigation';

	import * as THREE from 'three';

	import vertexShader from './shaders/vertexShader-three.glsl';
	import fragmentShader_aufbau from './shaders/fragmentShader-aufbau.glsl';
	import fragmentShader_niels from './shaders/fragmentShader-niels.glsl';
	import fragmentShader_raum from './shaders/fragmentShader-raum.glsl';
	import fragmentShader_iota from './shaders/fragmentShader-iota.glsl';
	import fragmentShader_garrett from './shaders/fragmentShader-garrett.glsl';
	import fragmentShader_closed_loop from './shaders/fragmentShader-closed-loop.glsl';

	let SIDEBAR_SIZE = 0;

	let shaderMaterial_aufbau,
		shaderMaterial_niels,
		shaderMaterial_raum,
		shaderMaterial_iota,
		shaderMaterial_closed_loop,
		shaderMaterial_garrett;

	let container;

	let camera, scene, renderer;

	let width = window.innerWidth - SIDEBAR_SIZE;
	let height = window.innerHeight;

	let mouse = new THREE.Vector2();
	const clock = new THREE.Clock();

	init();
	animate();

	function setupShaderMaterials() {
		const uniformsBase = {
			time: { value: 0 },
			mouse: { value: mouse }
		};

		const colors = {
			color1: new THREE.Color(0xd0d0d0),
			color2: new THREE.Color(0xbb4500),
			color3: new THREE.Color(0xdaaa55),
			color4: new THREE.Color(0x006994),
			color5: new THREE.Color(0x5099b4),
			color6: new THREE.Color(0x0000ff),
			color7: new THREE.Color(0x00ff00),
			color8: new THREE.Color(0x0b0b0b),
			color9: new THREE.Color(0x8fbd5a),
			color0: new THREE.Color(0x232323),
			color11: new THREE.Color(0xe0e0d0)
		};

		shaderMaterial_aufbau = new THREE.ShaderMaterial({
			vertexShader: vertexShader,
			fragmentShader: fragmentShader_aufbau,
			uniforms: {
				...uniformsBase,
				color1: { value: colors.color1 },
				color2: { value: colors.color5 },
				color3: { value: colors.color9 }
			}
		});

		shaderMaterial_raum = new THREE.ShaderMaterial({
			vertexShader: vertexShader,
			fragmentShader: fragmentShader_raum,
			uniforms: {
				...uniformsBase,
				color1: { value: colors.color4 },
				color2: { value: colors.color9 },
				color3: { value: colors.color9 }
			}
		});

		shaderMaterial_iota = new THREE.ShaderMaterial({
			vertexShader: vertexShader,
			fragmentShader: fragmentShader_iota,
			uniforms: {
				...uniformsBase,
				aspectRatio: { value: 1 }
			}
		});

		shaderMaterial_garrett = new THREE.ShaderMaterial({
			vertexShader: vertexShader,
			fragmentShader: fragmentShader_garrett,
			uniforms: {
				...uniformsBase,
				color1: { value: colors.color1 },
				color2: { value: colors.color11 },
				color3: { value: colors.color9 }
			}
		});

		shaderMaterial_niels = new THREE.ShaderMaterial({
			vertexShader: vertexShader,
			fragmentShader: fragmentShader_niels,
			uniforms: {
				...uniformsBase,
				color1: { value: colors.color3 },
				color2: { value: colors.color2 },
				color3: { value: colors.color3 }
			}
		});

		shaderMaterial_closed_loop = new THREE.ShaderMaterial({
			vertexShader: vertexShader,
			fragmentShader: fragmentShader_closed_loop,
			uniforms: {
				...uniformsBase,
				color1: { value: colors.color1 },
				color2: { value: colors.color9 },
				color3: { value: colors.color5 }
			}
		});
	}

	function updateShaderUniforms() {
		const elapsedTime = clock.getElapsedTime();

		if ($page.url.pathname == '/') {
			if ($screenType == 1) {
				shaderMaterial_aufbau.uniforms.time.value = elapsedTime;
				shaderMaterial_aufbau.uniforms.mouse.value = {
					x: 4 * Math.cos(elapsedTime * 0.1),
					y: 5 * Math.cos(elapsedTime * 0.1)
				};
			} else {
				shaderMaterial_aufbau.uniforms.mouse.value = mouse;
				shaderMaterial_aufbau.uniforms.time.value = elapsedTime;
			}
		}

		if ($page.url.pathname == '/raum' || $page.url.pathname == '/raum/') {
			shaderMaterial_raum.uniforms.mouse.value = mouse;
			shaderMaterial_raum.uniforms.time.value = elapsedTime;
		}

		if ($page.url.pathname == '/garrett' || $page.url.pathname == '/garrett/') {
			shaderMaterial_iota.uniforms.mouse.value = mouse;
			shaderMaterial_iota.uniforms.time.value = elapsedTime;
		}

		if ($page.url.pathname == '/iota' || $page.url.pathname == '/iota/') {
			// shaderMaterial_iota.uniforms.mouse.value = mouse;
			shaderMaterial_iota.uniforms.time.value = elapsedTime;
		}

		if ($page.url.pathname == '/niels' || $page.url.pathname == '/niels/') {
			shaderMaterial_niels.uniforms.mouse.value = mouse;
			shaderMaterial_niels.uniforms.time.value = elapsedTime;
		}

		if ($page.url.pathname == '/closed-loop' || $page.url.pathname == '/closed-loop/') {
			shaderMaterial_closed_loop.uniforms.mouse.value = mouse;
			shaderMaterial_closed_loop.uniforms.time.value = elapsedTime;
		}

	}

	function init() {
		camera = new THREE.PerspectiveCamera(20, width / height, 1, 800);
		camera.position.z = 400;

		scene = new THREE.Scene();
		scene.background = new THREE.Color(0x232323);

		setupShaderMaterials();
		setScene();

		renderer = new THREE.WebGLRenderer({ antialias: false });
		renderer.setPixelRatio(window.devicePixelRatio);
		renderer.setSize(width, height);

		onMount(() => {
			container.appendChild(renderer.domElement);
			return cleanup;
		});

		window.addEventListener('mousemove', onDocumentMouseMove);
		window.addEventListener('resize', onWindowResize);
		// window.addEventListener('navigate', onNavigate);
	}

	function setHome() {
		let plane4 = new THREE.Mesh(new THREE.PlaneGeometry(1000, 1000), shaderMaterial_aufbau);
		let plane5 = new THREE.Mesh(new THREE.PlaneGeometry(100, 100), shaderMaterial_aufbau);
		scene.add(plane4);

		if ($screenType != 1) {
			plane5.position.z = 200;
			scene.add(plane5);
		} else {
			plane5.position.z = 100;
			plane5.rotation.z = Math.PI / 2;
			scene.add(plane5);
		}
	}

	function setNiels () {
		let plane = new THREE.Mesh(new THREE.PlaneGeometry(1000, 1000), shaderMaterial_niels);
		let plane2 = new THREE.Mesh(new THREE.PlaneGeometry(100, 100), shaderMaterial_niels);
		plane2.position.z = 200;
		scene.add(plane, plane2);
	}

	function setRaum() {
		let plane = new THREE.Mesh(new THREE.PlaneGeometry(1000, 1000), shaderMaterial_raum);
		let plane2 = new THREE.Mesh(new THREE.PlaneGeometry(100, 100), shaderMaterial_raum);
		plane2.position.z = 200;
		scene.add(plane, plane2);
	}

	function setIOTA() {
		let plane = new THREE.Mesh(new THREE.PlaneGeometry(1000, 1000), shaderMaterial_iota);
		let plane2 = new THREE.Mesh(new THREE.PlaneGeometry(100, 100), shaderMaterial_iota);
		plane2.position.z = 200;
		scene.add(plane, plane2);
	}

	function setGarrett() {
		let plane = new THREE.Mesh(new THREE.PlaneGeometry(1000, 1000), shaderMaterial_garrett);
		let plane2 = new THREE.Mesh(new THREE.PlaneGeometry(100, 100), shaderMaterial_garrett);
		plane2.position.z = 200;
		scene.add(plane, plane2);
	}

	function setClosedLoop() {
		let plane = new THREE.Mesh(new THREE.PlaneGeometry(1000, 1000), shaderMaterial_closed_loop);
		let plane2 = new THREE.Mesh(new THREE.PlaneGeometry(100, 100), shaderMaterial_closed_loop);
		plane2.position.z = 200;
		scene.add(plane, plane2);
	}

	function setScene() {
		if ($page.url.pathname == '/') {
			setHome();
		}

		if ($page.url.pathname == '/niels' || $page.url.pathname == '/niels/' ) {
			setNiels();
		}

		if ($page.url.pathname == '/raum' || $page.url.pathname == '/raum/') {
			setRaum();
		}

		if ($page.url.pathname == '/garrett' || $page.url.pathname == '/garrett/') {
			setGarrett();
		}

		if ($page.url.pathname == '/iota' || $page.url.pathname == '/iota/') {
			setIOTA();
		}

		if ($page.url.pathname == '/closed-loop' || $page.url.pathname == '/closed-loop/') {
			setClosedLoop();
		}

	}

	afterNavigate(onNavigate);
	function onNavigate() {
		for (var i = scene.children.length - 1; i >= 0; i--) {
			let obj = scene.children[i];
			scene.remove(obj);
		}

		setScene();
	}

	function onWindowResize() {
		let width = window.innerWidth - SIDEBAR_SIZE;
		let height = window.innerHeight;

		camera.aspect = width / height;
		camera.updateProjectionMatrix();

		renderer.setSize(width, height);
	}

	function onDocumentMouseMove(event) {
		var clientX = event.clientX;
		var clientY = event.clientY;

		mouse.x = (clientX / window.innerWidth) * 2 - 1;
		mouse.y = -(clientY / window.innerHeight) * 2 + 1;
	}

	function animate() {
		requestAnimationFrame(animate);
		render();
	}

	function render() {
		updateShaderUniforms();
		renderer.render(scene, camera);
	}

	function cleanup() {
		window.removeEventListener('mousemove', onDocumentMouseMove);
		window.removeEventListener('resize', onWindowResize);
		window.removeEventListener('navigate', onNavigate);

		//cleanup webgl
		renderer.dispose();
		scene.dispose();
	}
</script>

<div bind:this={container} class:geometry={true} />

<style>
	.geometry {
		position: absolute;
		top: 0;
		left:0;
		width: 100%;
		height: 100%;
		display: block; /* Removes potential extra space below the canvas */
		padding: 0;
		margin: 0;
		border: none;
		z-index: -1;
	}
</style>
