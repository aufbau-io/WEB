<script>
	import { onMount } from 'svelte';

	let fonts = ['nb-television', 'martina-plantijn', 'nb-television-3d', 'nb-architekt']

	let lastChange = Date.now();
	let currentFont = 0;

	onMount(async () => {
	window.addEventListener('mousemove', () => {
		if (Date.now() - lastChange > 100) {
			lastChange = Date.now();
			currentFont = currentFont + 1 >= fonts.length ? 0 : currentFont + 1;
			document.querySelector('section h1').style.fontFamily = fonts[currentFont];
		}
	});
});
		

</script>

<h1>AUFBAU</h1>

<section>
	<h1>AUFBAU</h1>
</section>

<style>
	section {
		padding: 0 0;
		height: 100%;
		width: 100%;
		overflow: hidden;
		display: flex;
		flex-flow: column nowrap;
		justify-content: center;

		align-items: center;
		text-align: center;

		overflow: auto;
	}

	section h1 {
		font-size: 30rem;
	}
</style>
