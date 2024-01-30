<script>
	import { page } from '$app/stores';
</script>

<header>

	<h1 style="padding-right:10px;">PRESS SPACEBAR</h1>
	
	{#if $page.url.pathname == '/'}
	<a href='/about'><h1 style="padding-left:10px;">ABOUT // CONTACT</h1></a>
	{:else }
	<a href='/'><h1 style="padding-left:10px;">HOME</h1></a>
	{/if}

</header>

<style>
	header {
		user-select: none;
		color: var(--primary);
		display: flex;
		justify-content: space-between;
	}

	h1 {
		font-size: 20px;
		padding: 2px;
		color:var(--primary);
		background: var(--background);
		min-width: 200px;
	}

	a:hover {
		text-underline-offset: 4px;
	}
</style>
