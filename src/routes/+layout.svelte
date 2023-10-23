<script>
	import './app.css';

	import { onMount } from 'svelte';
	import { screenType, isIframe, darkMode, DARK_PAGES } from '$lib/store/store';
	import { page } from '$app/stores';

	import Header from '$lib/components/header/header.svelte';
	import Sidebar from '$lib/components/sidebar/sidebar.svelte';
	import Footer from '$lib/components/footer/footer.svelte';

	let Geometry;

	onMount(async () => {

		const module = await import('$lib/graphics/three.svelte');
		Geometry = module.default;

		function getDeviceType() {
			const width = window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth;

			console.log($page.url.pathname)
			if (DARK_PAGES.includes($page.url.pathname)) {
        darkMode.set(true);
				document.querySelector(':root').classList.add('dark-mode');
			}

			if ('ontouchstart' in window || navigator.maxTouchPoints > 0 || navigator.msMaxTouchPoints > 0) {
				// This is a device which supports touch
				if (width <= 767) {
					// Mobile
					return 1;
				} else {
					// Tablet
					return 2;
				}
			} else {
				// This is likely a laptop or desktop
				return 3;
			}
		}

		screenType.set(getDeviceType());
		isIframe.set(window.location !== window.parent.location);
	});
</script>

<svelte:head>
	<title>MAKE WEB FUN AGAIN</title>
	<meta name="description" content="AUFBAU // Creative Website Development from London to the World // MAKE WEB FUN AGAIN" />

	<link
	rel="preload"
	href="/fonts/Dahlia-bold.woff2"
	as="font"
	type="font/woff2"
	crossorigin="anonymous"
/>

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

	<link rel="preload" href="/icons/cv.svg" as="image">
	<link rel="preload" href="/icons/insta.svg" as="image">
	<link rel="preload" href="/icons/mail.svg" as="image">

	<link rel="preload" href="/icons/cv-dark.svg" as="image">
	<link rel="preload" href="/icons/insta-dark.svg" as="image">
	<link rel="preload" href="/icons/mail-dark.svg" as="image">

	<link rel="preload" href="/system_diagram.png" as="image">

</svelte:head>

<svelte:component this={Geometry} />

{#if $screenType}
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
{/if}

<style>
	main {
		display: flex;
		flex-direction: column;
		height: 100dvh;
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
	}
</style>
