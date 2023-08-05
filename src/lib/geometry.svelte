<script>
	import { onMount } from 'svelte';
	import { screenType } from '$lib/store/store';

	import * as THREE from 'three';

	let container;

	let camera, scene, renderer;

	let width = window.innerWidth;
	let height = window.innerHeight;

	let shaderMaterial, shaderMaterial2;

	let windowHalfX = width / 2;
	let windowHalfY = height / 2;

	const clock = new THREE.Clock();

	init();
	animate();

	function init() {
		camera = new THREE.PerspectiveCamera(20, width / height, 1, 800);
		camera.position.z = 400;

		scene = new THREE.Scene();
		scene.background = new THREE.Color(0x232323); // 

		const color1 = new THREE.Color(0xd0d0d0);
		const color2 = new THREE.Color(0xbb4500);
		const color3 = new THREE.Color(0xdaaa55);
		const color4 = new THREE.Color(0x006994 );
		const color5 = new THREE.Color(0x5099b4 );

		// Mouse position
		let mouse = new THREE.Vector2();

		// Shader material
		shaderMaterial = new THREE.ShaderMaterial({
			vertexShader: `
				varying vec2 vUv;
				void main() {
					vUv = uv;
					gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 2.0);
				}
			`,
			fragmentShader: `
				varying vec2 vUv;
				uniform vec3 color1;
				uniform vec3 color2;
				uniform vec3 color3;
				uniform float time;
				uniform vec2 mouse;

				void main() {
					vec2 position = vUv * 4.0;
				vec2 ripple = position;
				float dist = sqrt(dot(ripple, ripple));
				dist += (0.01 * mouse.x) * sin(5.0 * atan(ripple.y, ripple.x + 0.5 * mouse.y) - time * 0.1); // add circular distortion
				float wave = 0.5 * (1.0 + sin(dist * 10.0 - time * 0.5));
				vec3 color = mix(color1, color2, wave);
				color = mix(color, color3, wave * wave);
				gl_FragColor = vec4(color, 1.0);
			}
			`,
			uniforms: {
				color1: { value: color4 },
				color2: { value: color4 },
				color3: { value: color5 },
				time: { value: 0 },
				mouse: { value: mouse }
			}
		});

		// Shader material
		shaderMaterial2 = new THREE.ShaderMaterial({
			vertexShader: `
				varying vec2 vUv;
				void main() {
					vUv = uv;
					gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 2.0);
				}
			`,
			fragmentShader: `
				varying vec2 vUv;
				uniform vec3 color1;
				uniform vec3 color2;
				uniform vec3 color3;
				uniform float time;
				uniform vec2 mouse;

				void main() {
					vec2 position = vUv * 4.0;
					float wave = 0.5 * (tan(position.x + time * 0.1 + 10.0 ) +  mouse.x + sin(position.y + time +  mouse.y));
					vec3 color = mix(color1, color2, wave);
					color = mix(color, color3, wave * wave);
					gl_FragColor = vec4(color, 1.0);
				}
			`,
			uniforms: {
				color1: { value: color1 },
				color2: { value: color2 },
				color3: { value: color3 },
				time: { value: 0 },
				mouse: { value: mouse }
			}
		});

		let plane = new THREE.Mesh(new THREE.PlaneGeometry(1000, 1000), shaderMaterial);
		let plane2 = new THREE.Mesh(new THREE.PlaneGeometry(100, 100), shaderMaterial2);
		plane2.position.z = 200;
		scene.add(plane, plane2);

		// -------------------------------------------------------------------------

		renderer = new THREE.WebGLRenderer({ antialias: false });
		renderer.setPixelRatio(window.devicePixelRatio);
		renderer.setSize(width, height);

		onMount(() => {
			container.appendChild(renderer.domElement);
		});

		window.addEventListener('mousemove', onDocumentMouseMove);
		window.addEventListener('resize', onWindowResize);
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
    var clientX = event.clientX || (event.touches && event.touches[0].clientX);
    var clientY = event.clientY || (event.touches && event.touches[0].clientY);

    var mouse = new THREE.Vector2();
    mouse.x = ((clientX +1 ) / window.innerWidth) * 2 - 1;
    mouse.y = -((clientY + 1) / window.innerHeight) * 2 + 1;
		shaderMaterial.uniforms.mouse.value = mouse;
		shaderMaterial2.uniforms.mouse.value = mouse;


	};

	function animate() {
		requestAnimationFrame(animate);
		render();
	}

	function render() {
		const elapsedTime = clock.getElapsedTime();
		shaderMaterial.uniforms.time.value = elapsedTime;
		shaderMaterial2.uniforms.time.value = elapsedTime;
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
