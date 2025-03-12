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

	$: if (browser && data?.analyticsId) {
		webVitals({
			path: $page.url.pathname,
			params: $page.params,
			analyticsId: data.analyticsId
		});
	}

	// Apply theme colors to CSS variables
	$: if (browser && $theme) {
		document.documentElement.style.setProperty('--background', $theme.background);
		document.documentElement.style.setProperty('--primary', $theme.primary);
		document.documentElement.style.setProperty('--accent', $theme.accent);
		document.documentElement.style.setProperty('--background-50', $theme.primary + '50');
	}

	function handleScreen() {
		if (!browser) return;
		
		// screen size
		screenSize.set({
			width: window.innerWidth,
			height: window.innerHeight
		});

		// device type
		let deviceType = 3; // Default to desktop
		if (window.innerWidth <= 767) {
			deviceType = 1; // Mobile
		} else if (window.innerWidth <= 1024) {
			deviceType = 2; // Tablet
		}
		
		screenType.set(deviceType);
		
		if (window !== undefined && window.location !== undefined && window.parent !== undefined && window.parent.location !== undefined) {
			isIframe.set(window.location !== window.parent.location);
		}
	}

	onMount(async () => {
		// webgl - load for all screen sizes
		if (browser) {
			try {
				const module = await import('$lib/graphics/three.svelte');
				Geometry = module.default;
				geometryLoaded = true;
				console.log("Three.js component loaded successfully");
			} catch (error) {
				console.error("Error loading Three.js component:", error);
			}
		}

		handleScreen();
		if (browser) {
			window.addEventListener('resize', handleScreen);
		}

		// release opacity block once content is loaded
		if (browser) {
			const mainElement = document.querySelector('main');
			if (mainElement) {
				mainElement.style.opacity = 1;
			}
		}
	});

	onDestroy(() => {
		if (browser) {
			window.removeEventListener('resize', handleScreen);
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
