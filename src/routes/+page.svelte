<script>
</script>

<section>
	<div class="main">
		<!-- <h1>AUFBAU<br>-</h1> -->
		<p>make web fun again</p>
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

		/* background: var(--primary-50); */
		overflow: auto;
	}


	.main {
		max-width: 800px;

		display: flex;
		flex-flow: column nowrap;
		justify-content: center;
		gap: 10px;

		background: var(--background);
		color: var(--primary);
		border: var(--border);
		padding:  40px;
	}

	@media only screen and (max-width: 768px) {
		.main {
			position: absolute;
			bottom: 20px;
			width: calc(100% - 40px);
		}


	}
</style>
