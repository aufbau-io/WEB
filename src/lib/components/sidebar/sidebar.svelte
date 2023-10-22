<script>
	import Nav from '../sidebar/nav.svelte';
	import { screenType, darkMode, DARK_PAGES } from '$lib/store/store';

	// import { page } from '$app/stores';
	// import { goto } from '$app/navigation';

	function setDarkModeBasedOnRoute(route) {
		console.log(route);
    if (DARK_PAGES.includes(route)) {
        darkMode.set(true);
				document.querySelector(':root').classList.add('dark-mode');
    } else {
        darkMode.set(false);
				document.querySelector(':root').classList.remove('dark-mode');
    }
		console.log($darkMode);
}

	// stub data out
	const navItemsBasic = [
		{
			name: '///AUFBAU/////////////',
			href: '/',
		},
		{
			name: '/////IOTA/////////////',
			href: '/iota',
		},
		{
			name: '/////RAUM/////////////',
			href: '/raum',
		},
		{
			name: '/////silicon//////////',
			href: '/silicon',
		},
		{
			name: '/////CLOSED-LOOP//////',
			href: '/closed-loop',
		},
		{
			name: '///////ML-NETWORK/////',
			href: '/ml-network',
		},
		{
			name: '//////////PERSONAL////',
			href: '/niels',
		},
	];

	let navItems = navItemsBasic;
	
	$: {
		if ($screenType === 1) { // Assuming 1 corresponds to mobile
			navItems = navItemsBasic.filter(item => item.href !== '/ml-network');
		} else {
			navItems = navItemsBasic;
		}
	}

	// let toggleDarkMode = () => {
	// 	darkMode.set(!$darkMode);
	// 	document.querySelector(':root').classList.toggle('dark-mode');
	// 	};
</script>

	<main>

		<div class="top">

			<a class="no-style" href='/'>
				<div class="title">
					<h1>aufbau</h1>
				</div>
			</a>

				<Nav {navItems} setMode={setDarkModeBasedOnRoute} />
		</div>-

		{#if $screenType == 3}
		<div class="end">
			<a href="https://archive.aufbau.io" target="_blank" rel="noreferrer">aufbau archive</a>
			<!-- <p>NO THOUGHTS ALL VIBES</p> -->
		</div>
		{/if}

	<!-- <div on:click={() => toggleDarkMode()} on:keydown={() => toggleDarkMode()} class="darkMode right">
		<p class:selected={$darkMode == false}>ONLINE</p>
		<p class="selected">/</p>
		<p class:selected={$darkMode == true}>OFFLINE</p>
	</div> -->


</main>

<style>
	main {
		position: absolute;
		left: 0;
		top: 0;
		width: 220px;
		height: 100%;

		margin: auto;

		display: flex;
		flex-flow: column nowrap;
		justify-content: space-between;
		/* align-items: flex-start; */


	
		font-size: 12px;

		/* background: var(--background); */
	}

	.top {
		display: flex;
		flex-flow: column nowrap;
		gap: 20px;
		padding: 20px;
	}

	.title {
		width: 100%;
		height: 180px;
		/* background: var(--primary); */
		border: solid 1px var(--background);
		display: flex;
		align-items: flex-end;
		justify-content: center;
	}

	h1 {
		font-family: dahlia;
		font-size: 46px;
		letter-spacing: 0px;
		padding-bottom: 30px;
		color: var(--background);
	}

	a.no-style {
		text-decoration: none !important;
	}

	.end {
		display: flex;
		width: calc(100% - 20px);
		flex-flow: column nowrap;
		align-self: flex-end;
		align-items: center;
		justify-content: flex-start;
		border: solid 1px var(--background);

		margin: 10px;
		padding: 5px 0;
	}

	.end p, .end a {
		color: var(--background);

		font-size: 12px;
		padding: 5px 10px;
		text-align: center;
	}

</style>
