<script>
	import { onMount } from 'svelte';
	import { screenType } from '$lib/store/store';
	import { page } from '$app/stores';
	import { afterNavigate } from '$app/navigation';

	import * as THREE from 'three';

	let container;

	let camera, scene, renderer;

	let width = window.innerWidth;
	let height = window.innerHeight;

	let shaderMaterial, shaderMaterial2, shaderMaterial3;

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

		const color6 = new THREE.Color(0xd0d0d0);
		const color7 = new THREE.Color(0x0000ff);
		const color8 = new THREE.Color(0x00ff00);
		const color9 = new THREE.Color(0x232323);

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
				dist += sin(4.0 * atan(ripple.y, ripple.x + 0.1) - time * 0.1); // add circular distortion
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
					float wave = 0.5 * (tan(position.x + time * 0.1 + 10.0 ) + mouse.x + sin(position.y + time +  mouse.y));
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

		shaderMaterial3 = new THREE.ShaderMaterial({
			vertexShader: `
    varying vec2 vUv;
    void main() {
      vUv = uv;
      gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
    }
  `,
			fragmentShader: `
    varying vec2 vUv;
    uniform vec3 color1;
    uniform vec3 color2;
    uniform vec3 color3;
    uniform vec3 color4;
    uniform float time;
    uniform vec2 mouse;

    float noise(vec2 position) {
      return fract(sin(dot(position, vec2(0, 90))) * 2.5453 + (mouse.x * 0.5)) - fract(sin(dot(position, vec2(90, 90))) * 3.5453 + (mouse.y * 0.5));
    }

    void main() {
      float n = noise(vUv) + (sin(time) * 0.15);
      vec3 color = mix(color1, color2, n);
      color = mix(color, color3, n*n);
      color = mix(color, color4, n*n*n)  ;
      gl_FragColor = vec4(color, 1.0);
    }
  `,
			uniforms: {
				color1: { value: color6 },
				color2: { value: color7 },
				color3: { value: color8 },
				color4: { value: color9 },
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

	function setNiels () {
		let plane3 = new THREE.Mesh(new THREE.PlaneGeometry(600, 600), shaderMaterial3);
		plane3.position.z = -0.1;
		scene.add(plane3)
	}

	function setSicovecas () {
		let plane = new THREE.Mesh(new THREE.PlaneGeometry(1000, 1000), shaderMaterial);
		let plane2 = new THREE.Mesh(new THREE.PlaneGeometry(100, 100), shaderMaterial2);
		plane2.position.z = 200;
		scene.add(plane, plane2);
	}

	function setScene () {
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

		var mouse = new THREE.Vector2();
    mouse.x = (clientX / window.innerWidth) * 2 - 1;
		mouse.y = -(clientY / window.innerHeight) * 2 + 1;

		// console.log(mouse)
		shaderMaterial.uniforms.mouse.value = mouse;
		shaderMaterial2.uniforms.mouse.value = mouse;
		shaderMaterial3.uniforms.mouse.value = mouse;



	};

	function animate() {
		requestAnimationFrame(animate);
		render();
	}

	function render() {
		const elapsedTime = clock.getElapsedTime();
		shaderMaterial.uniforms.time.value = elapsedTime;
		shaderMaterial2.uniforms.time.value = elapsedTime;
		shaderMaterial3.uniforms.time.value = elapsedTime;

		if ($screenType == 1 && $page.url.pathname == '/niels') {
			// this.plane.rotateX(1);
			shaderMaterial3.uniforms.mouse.value = {
				x: clock.getElapsedTime() * 1,
				y: clock.getElapsedTime() * 0.1
			};
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
