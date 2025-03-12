<script>
	import { onMount } from 'svelte';
	import { page } from '$app/stores';
	import { currentTheme, hexToRgb } from '$lib/store/theme';

	import * as THREE from 'three';

	import vertexShader from './shaders/vertexShader-three.glsl';
	import fragmentShader_serene from './shaders/fragmentShader-serene.glsl';

	let container;
	let camera, scene, renderer;
	let unsubscribe;
	let pageUnsubscribe;
	let animationFrameId;
	let isInitialized = false;

	// Cached values to avoid unnecessary updates
	let width = window.innerWidth;
	let height = window.innerHeight;
	let isMobile = window.innerWidth <= 768;

	// Mouse tracking with optimized update frequency
	let mouse = new THREE.Vector2(0.5, 0.5);
	let targetMouse = new THREE.Vector2(0.5, 0.5);
	let lastMouseMoveTime = 0;
	const MOUSE_THROTTLE_MS = 16; // ~60fps
	
	const clock = new THREE.Clock();

	// Base colors - defined once
	const colors = {
		skyColor: new THREE.Color(0xE6E6E6),
		sunColor: new THREE.Color(0xD6C2B0),
		seaColor: new THREE.Color(0xC2D6CF),
		mountainColor: new THREE.Color(0xBFC0C5)
	};

	// Uniforms for the shader - defined once
	const uniforms = {
		time: { value: 0 },
		resolution: { value: new THREE.Vector2(width, height) },
		mouse: { value: new THREE.Vector2(0.5, 0.5) },
		isMobile: { value: isMobile },
		skyColor: { value: colors.skyColor },
		sunColor: { value: colors.sunColor },
		seaColor: { value: colors.seaColor },
		mountainColor: { value: colors.mountainColor },
		themeColor: { value: new THREE.Color(0xF5F5F0) },
		primaryColor: { value: new THREE.Color(0x333333) },
		routeTransition: { value: 0.0 }
	};

	// Initialize only when component is mounted
	onMount(() => {
		if (!isInitialized) {
			init();
			animate();
			isInitialized = true;
			
			// Listen for route changes to trigger transitions
			pageUnsubscribe = page.subscribe(() => {
				if (scene?.children[0]?.material) {
					// Reset route transition to trigger animation
					scene.children[0].material.uniforms.routeTransition.value = 0.0;
				}
			});
		}
		
		return cleanup;
	});

	function updateShaderUniforms() {
		if (!scene?.children[0]?.material) return;
		
		const material = scene.children[0].material;
		
		// Update time - only calculation needed every frame
		material.uniforms.time.value = clock.getElapsedTime() * 0.5;
		
		// Smooth mouse movement with lerp - only if needed
		if (!isMobile) {
			mouse.x += (targetMouse.x - mouse.x) * 0.05;
			mouse.y += (targetMouse.y - mouse.y) * 0.05;
			material.uniforms.mouse.value.copy(mouse);
		}
		
		// Update route transition value - fast transition
		const rt = material.uniforms.routeTransition;
		if (rt.value < 1.0) {
			rt.value = Math.min(1.0, rt.value + 0.1);
		}
	}

	function init() {
		// Simple camera setup - doesn't need to be recreated
		camera = new THREE.OrthographicCamera(-1, 1, 1, -1, 0, 1);
		scene = new THREE.Scene();
		
		// Get initial theme color
		const initialTheme = $currentTheme;
		scene.background = new THREE.Color(initialTheme.background);

		// Set up the theme subscription
		setupThemeSubscription();

		// Create a single full-screen shader
		createFullScreenShader();

		// Optimized renderer settings
		renderer = new THREE.WebGLRenderer({ 
			antialias: false, // Disable antialiasing for better performance
			alpha: true,
			powerPreference: 'high-performance',
			precision: 'mediump' // Use medium precision for better performance
		});
		renderer.setPixelRatio(Math.min(window.devicePixelRatio, 1.5)); // Limit pixel ratio
		renderer.setSize(width, height);
		renderer.setClearColor(0x000000, 0);

		container.appendChild(renderer.domElement);

		// Add event listeners with throttling
		setupEventListeners();
	}
	
	// Throttled mouse move handler
	function onMouseMove(event) {
		const now = performance.now();
		if (now - lastMouseMoveTime < MOUSE_THROTTLE_MS) return;
		
		lastMouseMoveTime = now;
		targetMouse.x = event.clientX / width;
		targetMouse.y = 1.0 - (event.clientY / height);
	}
	
	function onMouseLeave() {
		targetMouse.x = 0.5;
		targetMouse.y = 0.5;
	}
	
	function onMouseEnter(event) {
		targetMouse.x = event.clientX / width;
		targetMouse.y = 1.0 - (event.clientY / height);
	}
	
	// Throttled resize handler
	let resizeTimeout;
	function onWindowResize() {
		if (resizeTimeout) clearTimeout(resizeTimeout);
		
		resizeTimeout = setTimeout(() => {
			width = window.innerWidth;
			height = window.innerHeight;
			
			const wasIsMobile = isMobile;
			isMobile = width <= 768;
			
			if (uniforms.isMobile) {
				uniforms.isMobile.value = isMobile;
			}
			
			if (renderer) {
				renderer.setSize(width, height);
			}
			
			if (scene?.children[0]?.material) {
				scene.children[0].material.uniforms.resolution.value.set(width, height);
			}
			
			// Only update event listeners if mobile status changed
			if (wasIsMobile !== isMobile) {
				updateEventListeners();
			}
		}, 100); // Debounce resize events
	}
	
	function setupEventListeners() {
		// Add resize listener with debounce
		window.addEventListener('resize', onWindowResize, { passive: true });
		
		// Set up mouse listeners if not mobile
		updateEventListeners();
	}
	
	function updateEventListeners() {
		// Remove existing listeners
		window.removeEventListener('mousemove', onMouseMove);
		window.removeEventListener('mouseleave', onMouseLeave);
		window.removeEventListener('mouseenter', onMouseEnter);
		
		// Add listeners only if not mobile
		if (!isMobile) {
			window.addEventListener('mousemove', onMouseMove, { passive: true });
			window.addEventListener('mouseleave', onMouseLeave, { passive: true });
			window.addEventListener('mouseenter', onMouseEnter, { passive: true });
		}
	}
	
	// Set up theme subscription
	function setupThemeSubscription() {
		// Subscribe to theme changes
		unsubscribe = currentTheme.subscribe(theme => {
			if (!theme || !scene) return;
			
			// Update background color
			const bgColor = new THREE.Color(theme.background);
			const primaryColor = new THREE.Color(theme.primary);
			const accentColor = new THREE.Color(theme.accent);
			
			// Update shader uniforms
			if (scene.children[0]?.material) {
				const material = scene.children[0].material;
				
				// Reset route transition for smooth color change
				material.uniforms.routeTransition.value = 0.0;
				
				// Update theme colors
				material.uniforms.themeColor.value.copy(bgColor);
				material.uniforms.primaryColor.value.copy(primaryColor);
				material.uniforms.sunColor.value.copy(accentColor);
				
				// Derive more dramatic and contrasting sea and mountain colors from the accent
				const accentRgb = hexToRgb(theme.accent);
				
				// Create complementary colors for more dramatic effect
				const seaColor = new THREE.Color(
					Math.max(0, accentRgb.r * 0.5),
					Math.min(1, accentRgb.g * 1.3),
					Math.min(1, accentRgb.b * 1.5)
				);
				
				const mountainColor = new THREE.Color(
					Math.min(1, accentRgb.r * 1.2),
					Math.max(0, accentRgb.g * 0.7),
					Math.max(0, accentRgb.b * 0.6)
				);
				
				material.uniforms.seaColor.value.copy(seaColor);
				material.uniforms.mountainColor.value.copy(mountainColor);
			}
		});
	}

	function createFullScreenShader() {
		// Create a single full-screen plane - reuse geometry
		const geometry = new THREE.PlaneGeometry(2, 2);
		
		// Create shader material with optimized settings
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

	// Use requestAnimationFrame with optimized rendering
	function animate() {
		animationFrameId = requestAnimationFrame(animate);
		updateShaderUniforms();
		renderer.render(scene, camera);
	}

	function cleanup() {
		// Cancel animation frame
		if (animationFrameId) {
			cancelAnimationFrame(animationFrameId);
		}
		
		// Clear timeout
		if (resizeTimeout) {
			clearTimeout(resizeTimeout);
		}
		
		// Remove event listeners
		window.removeEventListener('resize', onWindowResize);
		window.removeEventListener('mousemove', onMouseMove);
		window.removeEventListener('mouseleave', onMouseLeave);
		window.removeEventListener('mouseenter', onMouseEnter);

		// Unsubscribe from stores
		if (unsubscribe) {
			unsubscribe();
		}
		if (pageUnsubscribe) {
			pageUnsubscribe();
		}

		// Cleanup webgl resources
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
		/* opacity: 0.85; */
		pointer-events: none;
	}
</style>
