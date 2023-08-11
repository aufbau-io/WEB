<script>
	import './app.css';

	import { onMount } from 'svelte';
	import { screenType, isIframe } from '$lib/store/store';

	import Header from '$lib/components/header/header.svelte';
	import Footer from '$lib/components/footer/footer.svelte';

	let Geometry;

	onMount(async () => {

		const module = await import('$lib/graphics/regl.svelte');
		Geometry = module.default;

		// ---------------------------------------------------------------------------
		// SCREEN
		// ---------------------------------------------------------------------------
		const ua = navigator.userAgent;
		if (
			/Mobile|Android|iP(hone|od)|IEMobile|BlackBerry|Kindle|Silk-Accelerated|(hpw|web)OS|Opera M(obi|ini)/.test(ua)
		) {
			// phone
			screenType.set(1);
		} else if (/(tablet|ipad|playbook|silk)|(android(?!.*mobi))/i.test(ua)) {
			// tablet
			screenType.set(2);
		} else {
			//laptop
			screenType.set(3);
		}	

		if (window.location !== window.parent.location) {
			// The page is in an iframe
			isIframe.set(true);
		}
	});
</script>

<svelte:head>
	<title>AUFBAU</title>
	<meta name="description" content="AUFBAU :: WEB 1.0 Re-Imagined" />

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

	<link rel="preload" href="icons/cv.svg" as="image">
	<link rel="preload" href="icons/insta.svg" as="image">
	<link rel="preload" href="icons/mail.svg" as="image">

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
