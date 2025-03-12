<script>
	import './styles.css';

	import { browser } from '$app/environment';
	import { page } from '$app/stores';
	import { webVitals } from '$lib/vitals';

	import { onMount, onDestroy } from 'svelte';
	import { screenType, isIframe, screenSize } from '$lib/store/store';
	import { theme } from '$lib/store/theme';
	import { getDeviceType, getScreenSize } from '$lib/functions/utils';

	import Footer from '$lib/components/footer/footer.svelte';
	import Menu from '$lib/components/Menu.svelte';

	export let data;
	let Geometry;
	let geometryLoaded = false;
	let resizeTimeout;

	$: if (browser && data?.analyticsId) {
		webVitals({
			path: $page.url.pathname,
			params: $page.params,
			analyticsId: data.analyticsId
		});
	}

	// Apply theme colors to CSS variables - only when theme changes
	$: if (browser && $theme) {
		document.documentElement.style.setProperty('--background', $theme.background);
		document.documentElement.style.setProperty('--primary', $theme.primary);
		document.documentElement.style.setProperty('--accent', $theme.accent);
		document.documentElement.style.setProperty('--background-50', $theme.primary + '50');
	}

	// Debounced screen size handler
	function handleScreen() {
		if (!browser) return;
		
		// Clear existing timeout
		if (resizeTimeout) clearTimeout(resizeTimeout);
		
		// Debounce resize events
		resizeTimeout = setTimeout(() => {
			// screen size
			screenSize.set({
				width: window.innerWidth,
				height: window.innerHeight
			});
	
			// device type - simplified calculation
			let deviceType = 3; // Default to desktop
			const width = window.innerWidth;
			if (width <= 767) {
				deviceType = 1; // Mobile
			} else if (width <= 1024) {
				deviceType = 2; // Tablet
			}
			
			screenType.set(deviceType);
			
			// Check iframe status only once
			if (!isIframe.isSet && window !== undefined && window.location !== undefined) {
				isIframe.set(window.location !== window.parent.location);
			}
		}, 100);
	}

	onMount(async () => {
		if (!browser) return;
		
		// Load Three.js component with dynamic import
		try {
			const module = await import('$lib/graphics/three.svelte');
			Geometry = module.default;
			geometryLoaded = true;
		} catch (error) {
			console.error("Error loading Three.js component:", error);
		}

		// Initial screen size calculation
		handleScreen();
		
		// Add resize listener with passive flag for better performance
		window.addEventListener('resize', handleScreen, { passive: true });

		// Release opacity block once content is loaded
		const mainElement = document.querySelector('main');
		if (mainElement) {
			mainElement.style.opacity = 1;
		}
	});

	onDestroy(() => {
		if (browser) {
			// Clean up event listeners and timeouts
			window.removeEventListener('resize', handleScreen);
			if (resizeTimeout) clearTimeout(resizeTimeout);
		}
	});
</script>

<svelte:head>
	<title>SICOVECAS</title>
	<meta
		name="description"
		content="Sicovecas - Graffiti and Visual Artist"
	/>
	<meta
		name="keywords"
		content="Sicovecas, Art, Graffiti, Visual Art, Murals, Exhibitions, Workshops, Artist, Indonesia, United Kingdom, Singapore, France"
	/>
	<meta name="author" content="Sicovecas" />
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=5" />
</svelte:head>

<div class="app">
	{#if browser && geometryLoaded}
		<svelte:component this={Geometry} />
	{/if}
	
	<Menu />

	<main>
		<slot />
	</main>

	<Footer />
</div>

<style>
	.app {
		display: flex;
		flex-direction: column;
		min-height: 100vh;
		background-color: transparent;
	}

	main {
		flex: 1;
		display: flex;
		flex-direction: column;
		width: 100%;
		margin: 0 auto;
		box-sizing: border-box;
		position: relative;
		opacity: 1;
		transition: opacity 0.5s ease;
	}

	@media (max-width: 768px) {
		main {
			padding: 0;
		}
	}
</style>
