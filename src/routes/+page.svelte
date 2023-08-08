<script>
</script>

<section>
	<div class="main">
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
		min-width: 270px;

		display: flex;
		flex-flow: column nowrap;
		justify-content: center;
		gap: 10px;
		padding: 20px;

		color: var(--background);
		border: var(--border);

	}

	.main p {
		padding: 20px;
		color: var(--background);
	}

	@media only screen and (max-width: 768px) {
		.main {
			position: absolute;
			background: var(--background);
			bottom: 20px;
			width: calc(100% - 40px);
		}

		.main p {
			color: var(--primary);
			background: var(--black);
			border: solid 1px var(--primary);
		}
	}
</style>
