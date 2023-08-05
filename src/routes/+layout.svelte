<script>
	import './app.css';

	import { onMount } from 'svelte';
	import { screenType, isIframe, darkMode } from '$lib/store/store';

	import Header from '$lib/components/header/header.svelte';
	import Footer from '$lib/components/footer/footer.svelte';

	let Geometry;

	onMount(async () => {

		const module = await import('$lib/geometry.svelte');
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
	<meta name="description" content="AUFBAU DIGITAL" />
</svelte:head>

<svelte:component this={Geometry} />

<main>
	{#if $screenType}
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
	
	{/if}
</main>


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
