<script>
	import './styles.css';

	import { browser } from '$app/environment';
	import { page } from '$app/stores';
	import { webVitals } from '$lib/vitals';

	import { onMount } from 'svelte';
	import { screenType, isIframe, screenSize, darkMode, DARK_PAGES } from '$lib/store/store';
	import { getDeviceType, getScreenSize } from '$lib/functions/utils';

	import Header from '$lib/components/header/header.svelte';
	import Sidebar from '$lib/components/sidebar/sidebar.svelte';
	import Footer from '$lib/components/footer/footer.svelte';

	export let data;
	let Geometry;

	$: if (browser && data?.analyticsId) {
		webVitals({
			path: $page.url.pathname,
			params: $page.params,
			analyticsId: data.analyticsId
		});
	}

	function handleScreen() {
		// screen size
		screenSize.set(getScreenSize());

		if (DARK_PAGES.includes($page.url.pathname)) {
			darkMode.set(true);
			document.querySelector(':root').classList.add('dark-mode');
		}
		// device type
		screenType.set(getDeviceType());
		isIframe.set(window.location !== window.parent.location);
	}

	onMount(async () => {
		// webgl
		const module = await import('$lib/graphics/three.svelte');
		Geometry = module.default;

		handleScreen();
		window.addEventListener('resize', () => handleScreen());

		// releasr opacity block once geometry is loaded
		document.querySelector('main').style.opacity = 1;


		return () => {
			window.removeEventListener('resize', () => handleScreen());
		};
	});
</script>

<svelte:head>
	<title>MAKE WEB FUN AGAIN</title>
	<meta
		name="description"
		content="AUFBAU // Creative Website Development from London to the World"
	/>
	<meta
		name="keywords"
		content="AUFBAU, Creative, Website, Graphics, WebGL, WebGPU, Rust, Developer, Engineer, Engineering, Development, London, World"
	/>
	<meta name="author" content="AUFBAU" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	
	<link
		rel="preload"
		href="/fonts/NB-Architekt-Pro-Light.woff"
		as="font"
		type="font/woff"
		crossorigin="anonymous"
	/>

	<link
		rel="preload"
		href="/fonts/NB-Architekt-Pro-Bold.woff"
		as="font"
		type="font/woff"
		crossorigin="anonymous"
	/>

	<!-- <link rel="preload" href="/icons/cv.svg" as="image" />
	<link rel="preload" href="/icons/insta.svg" as="image" />
	<link rel="preload" href="/icons/mail.svg" as="image" />

	<link rel="prefetch" href="/icons/cv-dark.svg" as="image" />
	<link rel="prefetch" href="/icons/insta-dark.svg" as="image" />
	<link rel="prefetch" href="/icons/mail-dark.svg" as="image" />

	<link rel="prefetch" href="/system_diagram.png" as="image" /> -->
</svelte:head>

{#if Geometry}
    <svelte:component this={Geometry} />
{:else}
    <div class="loading">loading.</div>
{/if}

<main>
	<header>
		<Header />
	</header>

	<body>
		<slot />
	</body>

	{#if $screenType == 3}
		<footer>
			<Footer />
		</footer>
	{/if}

	<Sidebar />
</main>

<style>
	main {
		display: flex;
		flex-direction: column;
		height: 100dvh;
		max-height: 100vh;
		background: none;
		opacity: 0;
		overflow: hidden;
	}

	header {
		position: absolute;
		top: 0;
		width: 100%;
	}

	footer {
		position: absolute;
		bottom: 0;
		width: 100%;
	}

	body {
		display: flex;
		flex-direction: column;
		/* padding: calc(1 * var(--margin)); */
		width: 100%;
		height: 100%;
		background: none;
	}

	.loading {
		position: absolute;
		font-style: italic;
		font-family: serif;
		top: 50%;
		left: 50%;
		transform: translate(-50%, -50%);
		padding: 10px;
		font-size: 12px;
	}
</style>
