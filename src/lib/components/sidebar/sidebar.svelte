<script>
	import Nav from '../sidebar/nav.svelte';
	import { screenType, darkMode, DARK_PAGES } from '$lib/store/store';

	// import { page } from '$app/stores';
	// import { goto } from '$app/navigation';

	// function setDarkModeBasedOnRoute(route) {
	// 	if (DARK_PAGES.includes(route)) {
	// 		darkMode.set(true);
	// 		document.querySelector(':root').classList.add('dark-mode');
	// 	} else {
	// 		darkMode.set(false);
	// 		document.querySelector(':root').classList.remove('dark-mode');
	// 	}
	// }
	

	// // stub data out
	// const navItemsBasic = [
	// 	{
	// 		name: '///AUFBAU/////////////',
	// 		href: '/'
	// 	},
	// 	// {
	// 	// 	name: '///silicon////////////',
	// 	// 	href: '/silicon',
	// 	// },
	// 	{
	// 		name: '///GARRETT////////////',
	// 		href: '/garrett'
	// 	},
	// 	{
	// 		name: '//////IOTA////////////',
	// 		href: '/iota'
	// 	},
	// 	{
	// 		name: '//////RAUM////////////',
	// 		href: '/raum'
	// 	},
	// 	{
	// 		name: '//////CLOSED-LOOP////',
	// 		href: '/closed-loop',
	// 	},
	// 	// {
	// 	// 	name: '////////ML-NETWORK////',
	// 	// 	href: '/ml-network'
	// 	// },
	// 	{
	// 		name: '//////////PERSONAL////',
	// 		href: '/niels'
	// 	}
	// ];

	// let navItems = navItemsBasic;

	// $: {
	// 	if ($screenType === 1) {
	// 		// Assuming 1 corresponds to mobile
	// 		navItems = navItemsBasic.filter((item) => (item.href !== '/ml-network' && item.href !== '/ml-network/'));
	// 	} else {
	// 		navItems = navItemsBasic;
	// 	}
	// }

	// let toggleDarkMode = () => {
	// 	darkMode.set(!$darkMode);
	// 	document.querySelector(':root').classList.toggle('dark-mode');
	// 	};
</script>

<!-- <div class="top">
			<img src="/aufbau.svg" alt="aufbau logo" width="200" />
	</div> -->


<style>
	.top {
		position: absolute;
		bottom: 20px;
		left: 0;
		display: flex;
		flex-flow: column nowrap;
		gap: 20px;
		padding: 20px;
		width: 220px;
		height: 220px;
		padding: 20px;
	}


	@media only screen and (max-width: 768px) {
		main {
			backdrop-filter: none;
		}
	}
</style>
