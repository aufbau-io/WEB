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

	p {
		line-height: 1.5;
		background: var(--black);
		padding: 20px;
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
		padding:  20px;
	}


	@media only screen and (max-width: 768px) {
		.main {
			position: fixed;
			bottom: 5%;
			width: 90vw;
			gap: 24px;
			padding:  20px;
		}

		p {
			padding:  20px 20px;
		}
	}
</style>
