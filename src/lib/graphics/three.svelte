<script>
	import { onMount } from 'svelte';
	import { screenType } from '$lib/store/store';
	import { page } from '$app/stores';
	import { afterNavigate } from '$app/navigation';

	import * as THREE from 'three';

	import vertexShader from './shaders/vertexShader.glsl';
	import fragmentShader_aufbau from './shaders/fragmentShader-aufbau.glsl';
	import fragmentShader_niels from './shaders/fragmentShader-niels.glsl';
	import fragmentShader_sicovecas1 from './shaders/fragmentShader-sicovecas1.glsl';
	import fragmentShader_sicovecas2 from './shaders/fragmentShader-sicovecas2.glsl';

	let shaderMaterial_aufbau, shaderMaterial_niels, shaderMaterial_sicovecas1, shaderMaterial_sicovecas2;

	let container;

	let camera, scene, renderer;

	let width = window.innerWidth;
	let height = window.innerHeight;

	let windowHalfX = width / 2;
	let windowHalfY = height / 2;

	let mouse = new THREE.Vector2();
	const clock = new THREE.Clock();

	init();
	animate();

	function init() {
		camera = new THREE.PerspectiveCamera(20, width / height, 1, 800);
		camera.position.z = 400;

		scene = new THREE.Scene();
		scene.background = new THREE.Color(0x232323);

		const color1 = new THREE.Color(0xd0d0d0);
		const color2 = new THREE.Color(0xbb4500);
		const color3 = new THREE.Color(0xdaaa55);
		const color4 = new THREE.Color(0x006994 );
		const color5 = new THREE.Color(0x5099b4 );
		const color6 = new THREE.Color(0x0000ff);
		const color7 = new THREE.Color(0x00ff00);
		const color9 = new THREE.Color(0x8fbd5a);

		// Shaders
		shaderMaterial_aufbau = new THREE.ShaderMaterial({
			vertexShader: vertexShader,
			fragmentShader: fragmentShader_aufbau,
			uniforms: {
				color1: { value: color1 },
				color2: { value: color5 },
				color3: { value: color9 },
				time: { value: 0 },
				mouse: { value: mouse }
			}
		});

		shaderMaterial_niels = new THREE.ShaderMaterial({
			vertexShader: vertexShader,
			fragmentShader: fragmentShader_niels,
			uniforms: {
				color1: { value: color1 },
				color2: { value: color2 },
				color3: { value: color6 },
				color4: { value: color7 },
				time: { value: 0 },
				mouse: { value: mouse }
			}
		});

		shaderMaterial_sicovecas1 = new THREE.ShaderMaterial({
			vertexShader: vertexShader,
			fragmentShader: fragmentShader_sicovecas1,
			uniforms: {
				color1: { value: color4 },
				color2: { value: color4 },
				color3: { value: color5 },
				time: { value: 0 },
				mouse: { value: mouse }
			}
		});

		shaderMaterial_sicovecas2 = new THREE.ShaderMaterial({
			vertexShader: vertexShader,
			fragmentShader: fragmentShader_sicovecas2,
			uniforms: {
				color1: { value: color1 },
				color2: { value: color2 },
				color3: { value: color3 },
				time: { value: 0 },
				mouse: { value: mouse }
			}
		});

		setScene();

		// -------------------------------------------------------------------------

		renderer = new THREE.WebGLRenderer({ antialias: false });
		renderer.setPixelRatio(window.devicePixelRatio);
		renderer.setSize(width, height);

		onMount(() => {
			container.appendChild(renderer.domElement);
		});

		window.addEventListener('mousemove', onDocumentMouseMove);
		window.addEventListener('resize', onWindowResize);
		// window.addEventListener('navigate', onNavigate);
	}

	function setHome () {

		let plane4 = new THREE.Mesh(new THREE.PlaneGeometry(1000, 1000), shaderMaterial_aufbau);
		let plane5 = new THREE.Mesh(new THREE.PlaneGeometry(100, 100), shaderMaterial_aufbau);
		scene.add(plane4);

		if ($screenType != 1) {
			plane5.position.z = 200;
			scene.add(plane5);

		} else {
			plane5.position.z = 100;
			plane5.rotation.z = Math.PI / 2
			scene.add(plane5);
		}
	}

	function setNiels () {
		let plane3 = new THREE.Mesh(new THREE.PlaneGeometry(600, 600), shaderMaterial_niels);
		plane3.position.z = -0.1;
		scene.add(plane3)
	}

	function setSicovecas () {
		let plane = new THREE.Mesh(new THREE.PlaneGeometry(1000, 1000), shaderMaterial_sicovecas1);
		let plane2 = new THREE.Mesh(new THREE.PlaneGeometry(100, 100), shaderMaterial_sicovecas2);
		plane2.position.z = 200;
		scene.add(plane, plane2);
	}

	function setScene () {

		if ($page.url.pathname == '/') {
			setHome();
		}

		if ($page.url.pathname == '/niels') {
			setNiels();
		}

		if ($page.url.pathname == '/sicovecas') {
			setSicovecas();
		}
	}

	afterNavigate (onNavigate);
	function onNavigate() {

		for( var i = scene.children.length - 1; i >= 0; i--) { 
				let obj = scene.children[i];
				scene.remove(obj); 
		}

		setScene();

	}

	function onWindowResize() {
		let width = window.innerWidth;
		let height = window.innerHeight;

		windowHalfX = width / 2;
		windowHalfY = height / 2;

		camera.aspect = width / height;
		camera.updateProjectionMatrix();

		renderer.setSize(width, height);
	}

	function onDocumentMouseMove(event) {
		event.preventDefault();
    var clientX = event.clientX;
    var clientY = event.clientY;

    mouse.x = (clientX / window.innerWidth) * 2 - 1;
		mouse.y = -(clientY / window.innerHeight) * 2 + 1;

	};

	function animate() {
		requestAnimationFrame(animate);
		render();
	}

	function render() {
		const elapsedTime = clock.getElapsedTime();

		if ($page.url.pathname == '/') {
			if ($screenType == 1) {
				shaderMaterial_aufbau.uniforms.time.value = elapsedTime;
				shaderMaterial_aufbau.uniforms.mouse.value = {
					x: 4 * Math.cos(elapsedTime * 0.1),
					y: 5 * Math.cos(elapsedTime * 0.1)
				} 
			} else {
				shaderMaterial_aufbau.uniforms.mouse.value = mouse;
				shaderMaterial_aufbau.uniforms.time.value = elapsedTime;
			}
		}

		if ($page.url.pathname == '/niels') {
			if ($screenType == 1) {
				shaderMaterial_niels.uniforms.mouse.value = {
					x: clock.getElapsedTime() * 1,
					y: clock.getElapsedTime() * 0.1
				};
			} else {
				shaderMaterial_niels.uniforms.mouse.value = mouse;
			}
		}

		if ($page.url.pathname == '/sicovecas') {
			shaderMaterial_sicovecas1.uniforms.mouse.value = mouse;
			shaderMaterial_sicovecas2.uniforms.mouse.value = mouse;

			shaderMaterial_sicovecas1.uniforms.time.value = elapsedTime;
			shaderMaterial_sicovecas2.uniforms.time.value = elapsedTime;
		}

		renderer.render(scene, camera);
	}
</script>

<div bind:this={container} class:geometry={true} />

<style>
	.geometry {
		position: absolute;
		overflow: hidden;
		z-index: -1;
	}
</style>
