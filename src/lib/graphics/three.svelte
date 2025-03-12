<script>
	import { onMount } from 'svelte';
	import { screenType } from '$lib/store/store';
	import { page } from '$app/stores';
	import { currentTheme } from '$lib/store/theme';
	// import { afterNavigate } from '$app/navigation';

	import * as THREE from 'three';

	import vertexShader from './shaders/vertexShader-three.glsl';
	import fragmentShader_serene from './shaders/fragmentShader-serene.glsl';

	let container;
	let camera, scene, renderer;
	let unsubscribe;

	let width = window.innerWidth;
	let height = window.innerHeight;

	let mouse = new THREE.Vector2();
	const clock = new THREE.Clock();

	// More vibrant colors for the shader
	const colors = {
		skyColor: new THREE.Color(0x6ECBFF),    // Brighter sky blue
		sunColor: new THREE.Color(0xFFB74D),    // Warmer sun (orange)
		seaColor: new THREE.Color(0x4DB6B6),    // Brighter teal sea
		mountainColor: new THREE.Color(0x5D9FD0) // Brighter blue mountains
	};

	// Uniforms for the shader
	const uniforms = {
		time: { value: 0 },
		resolution: { value: new THREE.Vector2(width, height) },
		mouse: { value: new THREE.Vector2(0.5, 0.5) },
		skyColor: { value: colors.skyColor },
		sunColor: { value: colors.sunColor },
		seaColor: { value: colors.seaColor },
		mountainColor: { value: colors.mountainColor },
		themeColor: { value: new THREE.Color(0xF5F5F0) },
		primaryColor: { value: new THREE.Color(0x333333) }
	};

	// Initialize only when component is mounted
	onMount(() => {
		init();
		animate();
		
		return cleanup;
	});

	function updateShaderUniforms() {
		const elapsedTime = clock.getElapsedTime();
		
		if (scene && scene.children[0] && scene.children[0].material) {
			scene.children[0].material.uniforms.time.value = elapsedTime;
		}
	}

	function init() {
		camera = new THREE.OrthographicCamera(-1, 1, 1, -1, 0, 1);
		scene = new THREE.Scene();
		
		// Get initial theme color
		const initialTheme = $currentTheme;
		scene.background = new THREE.Color(initialTheme.background);

		// Set up the theme subscription
		setupThemeSubscription();

		// Create a single full-screen shader
		createFullScreenShader();

		renderer = new THREE.WebGLRenderer({ 
			antialias: true, // Enable antialiasing for better quality
			alpha: true,
			powerPreference: 'default' // Use default power preference for better quality
		});
		renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2)); // Better quality
		renderer.setSize(width, height);
		renderer.setClearColor(0x000000, 0);

		container.appendChild(renderer.domElement);

		window.addEventListener('resize', onWindowResize, { passive: true });
	}
	
	// Set up theme subscription
	function setupThemeSubscription() {
		// Subscribe to theme changes
		unsubscribe = currentTheme.subscribe(theme => {
			if (theme && scene) {
				// Update background color
				const bgColor = new THREE.Color(theme.background);
				const primaryColor = new THREE.Color(theme.primary);
				
				// Update shader uniforms
				if (scene.children[0] && scene.children[0].material) {
					scene.children[0].material.uniforms.themeColor.value = bgColor;
					scene.children[0].material.uniforms.primaryColor.value = primaryColor;
					scene.children[0].material.uniforms.sunColor.value = new THREE.Color(theme.accent);
				}
			}
		});
	}

	function createFullScreenShader() {
		// Create a single full-screen plane
		const geometry = new THREE.PlaneGeometry(2, 2);
		
		// Create shader material
		const material = new THREE.ShaderMaterial({
			vertexShader: vertexShader,
			fragmentShader: fragmentShader_serene,
			uniforms: uniforms,
			transparent: true,
			depthWrite: false,
			depthTest: false
		});
		
		const plane = new THREE.Mesh(geometry, material);
		scene.add(plane);
	}

	function onWindowResize() {
		width = window.innerWidth;
		height = window.innerHeight;

		renderer.setSize(width, height);
		
		if (scene.children[0] && scene.children[0].material) {
			scene.children[0].material.uniforms.resolution.value.x = width;
			scene.children[0].material.uniforms.resolution.value.y = height;
		}
	}

	// Use requestAnimationFrame with higher framerate for smoother animation
	function animate() {
		requestAnimationFrame(animate);
		render();
	}

	function render() {
		updateShaderUniforms();
		renderer.render(scene, camera);
	}

	function cleanup() {
		window.removeEventListener('resize', onWindowResize);

		// Unsubscribe from theme store
		if (unsubscribe) {
			unsubscribe();
		}

		// Cleanup webgl
		if (renderer) {
			renderer.dispose();
		}
		if (scene) {
			scene.traverse(object => {
				if (object.geometry) object.geometry.dispose();
				if (object.material) {
					if (object.material.map) object.material.map.dispose();
					object.material.dispose();
				}
			});
			scene.dispose();
		}
	}
</script>

<div bind:this={container} class="geometry" />

<style>
	.geometry {
		position: fixed;
		top: 0;
		left: 0;
		width: 100vw;
		height: 100vh;
		display: block;
		padding: 0;
		margin: 0;
		border: none;
		z-index: -1;
		opacity: 1.0; /* Full opacity */
		pointer-events: none; /* Allow clicks to pass through */
	}
</style>
