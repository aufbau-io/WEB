<script>
	import Nav from './nav.svelte';
	import { darkMode } from '$lib/store/store';

	// import { page } from '$app/stores';
	// import { goto } from '$app/navigation';

	// stub data out
	// const navItems = [
	// 	{
	// 		name: 'AUFBAU',
	// 		href: '/'
	// 	},
	// 	{
	// 		name: 'RAUM',
	// 		href: '/raum'
	// 	},
	// 	{
	// 		name: 'NIELS',
	// 		href: '/niels'
	// 	},

	// ];

	// let toggleDarkMode = () => {
	// 	darkMode.set(!$darkMode);
	// 	document.querySelector(':root').classList.toggle('dark-mode');
	// 	};
</script>

<header>
	<main>

		<!-- <Nav {navItems} /> -->

	<!-- <div on:click={() => toggleDarkMode()} on:keydown={() => toggleDarkMode()} class="darkMode right">
		<p class:selected={$darkMode == false}>ONLINE</p>
		<p class="selected">/</p>
		<p class:selected={$darkMode == true}>OFFLINE</p>
	</div> -->

	<div class="icons">
    <a href="/dan_humphries_cv.pdf">
			{#if !$darkMode}
        <img src="/icons/cv-dark.svg" alt="cv" class="icon" />
			{:else}
				<img src="/icons/cv.svg" alt="cv" class="icon" />
			{/if}
    </a>
    <a href="mailto: dan@aufbau.io">
			{#if !$darkMode}
        <img src="/icons/mail-dark.svg" alt="mail" class="icon" />
			{:else}
				<img src="/icons/mail.svg" alt="cv" class="icon" />
			{/if}
    </a>
    <a href="https://www.instagram.com/dn.niels" target="_blank" rel="noreferrer">
			{#if !$darkMode}
        <img src="/icons/insta-dark.svg" alt="instagram" class="icon" />
			{:else}
				<img src="/icons/insta.svg" alt="cv" class="icon" />
			{/if}
    </a>
</div>

</main>
</header>

<style>
	header {
		user-select: none;
		color: var(--primary);
	}

	main {
		margin: auto;
		max-width: 100vw;
		display: flex;
		justify-content: flex-end;
		align-items: flex-start;

		padding: 20px;
		font-size: 12px;
		height: calc(2 * var(--margin));
	}

	.icons {
		display: flex;
		gap: 15px;
		padding: 6px 15px;
		justify-content: space-evenly;
		backdrop-filter: blur(10px);
		border: var(--border);
	}

	.icon {
		height: 20px;
		width: 20px;

		cursor: pointer;
		opacity: 1;
	}

	.icon:hover{
		opacity:.5;
		}
</style>
