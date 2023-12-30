<script>
	import { page } from '$app/stores';
	// import { screenType } from '$lib/store/store';

	export let navItems = [];
	export let setMode = () => {};
	export async function load() {
		return {
			props: {
				navItems
			}
		};
	}
</script>

<nav>
	{#each navItems as navItem}
		<a
			href={navItem.href}
			class=""
			class:active={navItem.href === ($page.url.pathname || `${page.url.pathname}/`)}
			on:click={() => setMode(navItem.href)}>{navItem.name}</a
		>
	{/each}

	<!-- <a href="https://aufbau.io" >EIN AUFBAU DING</a> -->
</nav>

<style>
	nav {
		align-self: baseline;
		display: flex;
		flex-flow: column wrap;
		/* gap: 20px; */
		color: var(--background);
		/* backdrop-filter: blur(1px); */
		width: 100%;
	}

	nav a,
	nav p {
		/* padding: 10px 10px; */
		font-size: inherit;
		/* font-weight: 600 !important; */
		cursor: pointer;
		color: inherit;
		width: 100%;
		border-bottom: 1px var(--background) solid;
		padding: 10px 0;
	}

	nav a:hover {
		opacity: 0.6;
		text-decoration: none;
	}

	nav a.active {
		font-weight: 600;
	}

	.active,
	.active:hover {
		opacity: 1;
	}

	@media only screen and (max-width: 768px) {
		nav {
			flex-flow: column wrap;
		}
	}
</style>
