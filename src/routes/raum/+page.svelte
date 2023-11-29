<script>
	import { onMount } from 'svelte';
	// import { darkMode } from '$lib/store/store';

	// onMount(async () => {
	// 	darkMode.set(false);
	// 	document.querySelector(':root').classList.remove('dark-mode');
	// });
</script>

<section>
	<div class="main">
		<p>rust webgpu volumteric renderer <br>custom component for c++ system</p>
		<a href="https://cubical-boi.netlify.app"  target="_blank" rel="noreferrer">// wip - webgl demo //</a>
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
			max-width: 800px;
			min-width: 270px;
	
			display: flex;
			flex-flow: column nowrap;
			justify-content: center;
			gap: 10px;
	
			backdrop-filter: blur(10px);
			color: var(--background);
			border: var(--border);
			padding:  20px;
		}

		.main p {
			color: var(--background);
		}
	
		.main a {
			padding: 10px;
			border: solid 1px var(--background);
			background:  var(--background);
			color: var(--primary);
		}
	
		@media only screen and (max-width: 768px) {
			.main {
				position: absolute;
				bottom: 20px;
				width: calc(100% - 40px);
				padding: 10px;
				/* background:  var(--background); */
				z-index: 10;
			}
	
			.main a {
				background:  var(--background);
			}
		}
	</style>
