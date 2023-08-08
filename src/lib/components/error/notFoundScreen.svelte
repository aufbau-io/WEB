<script>
</script>

<svelte:head>
	<title>404 not found</title>
</svelte:head>
<section>
	<div class="message">
		<a href="/">404 ERROR</a>
	</div>
</section>

<style>
	section {
		position: fixed;
		top: 50%;
		left: 50%;
		transform: translate(-50%, -50%);
		z-index: 100;
	}

	a {
		cursor: pointer;
		color: var(--primary);
	}
</style>
