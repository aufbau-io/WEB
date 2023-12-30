<script>
	import { onMount } from 'svelte';
	import { lazyLoad } from '$lib/functions/lazyLoad.js';

	let imgElement;

	onMount(() => {
		lazyLoad(imgElement, '/system_diagram.png');
	});
</script>

<section>
	<div class="main">
		<!-- <p>WIP</p> -->
		<img bind:this={imgElement} alt="system-diagram" class="image" />
	</div>
</section>

<style>
	section {
		padding: 0 0;
		height: 100%;
		width: 100%;

		display: flex;
		flex-flow: column nowrap;
		justify-content: center;

		align-items: center;
		text-align: center;

		overflow: auto;
	}

	.main {
		/* max-width: 800px;
		min-width: 270px; */

		overflow: hidden;

		display: flex;
		flex-flow: column nowrap;
		justify-content: center;
		gap: 10px;

		color: var(--background);

		/* padding:  20px; */
	}

	.main a,
	.main p {
		padding: 10px;
		border: solid 1px var(--background);
		background: var(--background);
		color: var(--primary);
	}

	.image {
		border-left: solid 1px var(--primary);
		border-right: solid 1px var(--primary);
		opacity: 0;
		transition: opacity 0.5s ease-in-out;
		backdrop-filter: blur(10px);
		max-width: 100%;
		max-height: 100%;
		z-index: -1;
	}

	@media only screen and (max-width: 768px) {
		.main {
			position: absolute;
			bottom: 20px;
			width: calc(100% - 40px);
			padding: 10px;
			/* background:  var(--background); */
		}

		.main a {
			background: var(--background);
		}
	}
</style>
