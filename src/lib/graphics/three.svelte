<script>
	import { onMount } from 'svelte';
	import { page } from '$app/stores';
	import { currentTheme, hexToRgb } from '$lib/store/theme';
	import { isDarkMode } from '$lib/store/darkMode';

	import * as THREE from 'three';

	import vertexShader from './shaders/vertexShader-three.glsl';
	import fragmentShader_serene from './shaders/fragmentShader-serene.glsl';

	let container;
	let camera, scene, renderer;
	let unsubscribe;
	let pageUnsubscribe;
	let darkModeUnsubscribe;
	let animationFrameId;
	let isInitialized = false;
	let isTransitioning = false;
	let currentPath = '';

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
		skyColor: new THREE.Color(0xF5F5F0), // Warm stone background
		sunColor: new THREE.Color(0xFFE5D6), // Soft peachy glow
		seaColor: new THREE.Color(0xE6F3F0), // Gentle mint
		mountainColor: new THREE.Color(0xF0E6E6) // Soft rose
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
			try {
				init();
				animate();
				isInitialized = true;
				
				// Listen for route changes to trigger transitions
				pageUnsubscribe = page.subscribe(($page) => {
					try {
						// Only trigger transition if path actually changed
						if (currentPath !== $page.url.pathname) {
							currentPath = $page.url.pathname;
							isTransitioning = true;
							
							// Safely reset route transition
							if (scene?.children[0]?.material) {
								scene.children[0].material.uniforms.routeTransition.value = 0.0;
							}
						}
					} catch (error) {
						console.error("Error handling route change:", error);
					}
				});
				
				// Subscribe to dark mode changes
				darkModeUnsubscribe = isDarkMode.subscribe(isDarkMode => {
					try {
						console.log("Dark mode changed:", isDarkMode); // Debug log
						
						if (!scene?.children[0]) {
							console.log("Scene or mesh not ready"); // Debug log
							return;
						}
						
						const mesh = scene.children[0];
						
						if (isDarkMode) {
							// Hide the shader mesh in dark mode
							mesh.visible = false;
							// Set scene background to black
							scene.background = new THREE.Color(0x000000);
							// Add dark mode class to body
							document.body.classList.add('dark-mode');
						} else {
							// Show the shader mesh in light mode
							mesh.visible = true;
							// Reset scene background to transparent
							scene.background = null;
							// Remove dark mode class from body
							document.body.classList.remove('dark-mode');
						}
						
						// Force a render to immediately show the changes
						if (renderer && camera) {
							renderer.render(scene, camera);
						}
					} catch (error) {
						console.error("Error handling dark mode change:", error);
					}
				});
			} catch (error) {
				console.error("Error initializing Three.js:", error);
			}
		}
		
		return cleanup;
	});

	function updateShaderUniforms() {
		try {
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
			if (isTransitioning) {
				const rt = material.uniforms.routeTransition;
				if (rt.value < 1.0) {
					rt.value = Math.min(1.0, rt.value + 0.1);
					
					// Ensure uniforms are updated during transition
					material.uniformsNeedUpdate = true;
				} else {
					isTransitioning = false; // Transition complete
				}
			}
		} catch (error) {
			console.error("Error updating shader uniforms:", error);
		}
	}

	function init() {
		try {
			// Simple camera setup - doesn't need to be recreated
			camera = new THREE.OrthographicCamera(-1, 1, 1, -1, 0, 1);
			scene = new THREE.Scene();
			
			// Get initial theme color
			const initialTheme = $currentTheme;
			if (initialTheme) {
				scene.background = new THREE.Color(initialTheme.background);
			}

			// Set up the theme subscription first
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

			if (container) {
				container.appendChild(renderer.domElement);
			}

			// Add event listeners with throttling
			setupEventListeners();
			
			// Set initial path
			if (typeof window !== 'undefined') {
				currentPath = window.location.pathname;
			}
			
			// Apply dark mode if it's already enabled
			if ($isDarkMode) {
				document.body.classList.add('dark-mode');
			}

			// Force initial color update
			if (scene.children[0]?.material) {
				const material = scene.children[0].material;
				material.uniformsNeedUpdate = true;
				if (renderer && camera) {
					renderer.render(scene, camera);
				}
			}
		} catch (error) {
			console.error("Error in init function:", error);
		}
	}
	
	// Throttled mouse move handler
	function onMouseMove(event) {
		try {
			const now = performance.now();
			if (now - lastMouseMoveTime < MOUSE_THROTTLE_MS) return;
			
			lastMouseMoveTime = now;
			targetMouse.x = event.clientX / width;
			targetMouse.y = 1.0 - (event.clientY / height);
		} catch (error) {
			console.error("Error in mouse move handler:", error);
		}
	}
	
	function onMouseLeave() {
		targetMouse.x = 0.5;
		targetMouse.y = 0.5;
	}
	
	function onMouseEnter(event) {
		try {
			targetMouse.x = event.clientX / width;
			targetMouse.y = 1.0 - (event.clientY / height);
		} catch (error) {
			console.error("Error in mouse enter handler:", error);
		}
	}
	
	// Throttled resize handler
	let resizeTimeout;
	function onWindowResize() {
		try {
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
		} catch (error) {
			console.error("Error in resize handler:", error);
		}
	}
	
	function setupEventListeners() {
		try {
			// Add resize listener with debounce
			window.addEventListener('resize', onWindowResize, { passive: true });
			
			// Set up mouse listeners if not mobile
			updateEventListeners();
		} catch (error) {
			console.error("Error setting up event listeners:", error);
		}
	}
	
	function updateEventListeners() {
		try {
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
		} catch (error) {
			console.error("Error updating event listeners:", error);
		}
	}
	
	// Set up theme subscription
	function setupThemeSubscription() {
		try {
			// Subscribe to theme changes
			unsubscribe = currentTheme.subscribe(theme => {
				try {
					if (!theme || !scene) return;
					
					// Skip theme updates if in dark mode
					if ($isDarkMode) {
						console.log("Skipping theme update in dark mode"); // Debug log
						return;
					}
					
					console.log("Updating theme colors"); // Debug log
					
					// Update shader uniforms
					if (scene.children[0]?.material) {
						const material = scene.children[0].material;
						
						// Reset route transition for smooth color change
						material.uniforms.routeTransition.value = 0.0;
						isTransitioning = true;
						
						// Update theme colors - force immediate update
						material.uniforms.themeColor.value.copy(new THREE.Color(theme.background));
						material.uniforms.primaryColor.value.copy(new THREE.Color(theme.primary));
						
						// Create a softer, more ethereal color scheme based on the accent
						const accentRgb = hexToRgb(theme.accent);
						
						// Special handling for contact page
						if (currentPath === '/contact') {
							// Hardcode warm, sunny colors for contact page
							const sunColor = new THREE.Color(0xFFB74D);  // Warm orange
							material.uniforms.sunColor.value.copy(sunColor);
							
							// Warm, golden sea color
							const seaColor = new THREE.Color(0xFFA726);  // Deep orange
							material.uniforms.seaColor.value.copy(seaColor);
							
							// Warm mountain color with red tones
							const mountainColor = new THREE.Color(0xFF8A65);  // Coral red
							material.uniforms.mountainColor.value.copy(mountainColor);
							
							// Keep the warm stone background
							material.uniforms.skyColor.value.copy(colors.skyColor);
						} else {
							// Regular page colors - ensure consistent initial state
							const sunColor = new THREE.Color(
								Math.min(1, accentRgb.r * 1.2),
								Math.min(1, accentRgb.g * 1.1),
								Math.min(1, accentRgb.b * 0.9)
							);
							material.uniforms.sunColor.value.copy(sunColor);
							
							const seaColor = new THREE.Color(
								Math.min(1, accentRgb.r * 0.8),
								Math.min(1, accentRgb.g * 1.3),
								Math.min(1, accentRgb.b * 1.4)
							);
							material.uniforms.seaColor.value.copy(seaColor);
							
							const mountainColor = new THREE.Color(
								Math.min(1, accentRgb.r * 1.1),
								Math.min(1, accentRgb.g * 0.9),
								Math.min(1, accentRgb.b * 1.2)
							);
							material.uniforms.mountainColor.value.copy(mountainColor);
							
							// Keep the warm stone background
							material.uniforms.skyColor.value.copy(colors.skyColor);
						}
						
						// Force uniform update
						material.uniformsNeedUpdate = true;
						
						// Force a render to immediately show the changes
						if (renderer && camera) {
							renderer.render(scene, camera);
						}
					}
				} catch (error) {
					console.error("Error in theme subscription handler:", error);
				}
			});
		} catch (error) {
			console.error("Error setting up theme subscription:", error);
		}
	}

	function createFullScreenShader() {
		try {
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
		} catch (error) {
			console.error("Error creating full screen shader:", error);
		}
	}

	// Use requestAnimationFrame with optimized rendering
	function animate() {
		try {
			animationFrameId = requestAnimationFrame(animate);
			updateShaderUniforms();
			if (renderer && scene && camera) {
				renderer.render(scene, camera);
			}
		} catch (error) {
			console.error("Error in animation loop:", error);
		}
	}

	function cleanup() {
		try {
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
			if (darkModeUnsubscribe) {
				darkModeUnsubscribe();
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
		} catch (error) {
			console.error("Error in cleanup function:", error);
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
		opacity: 0.85;
		pointer-events: none;
	}
</style>
