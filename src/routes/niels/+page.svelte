<script>
</script>

<section>
	<div class="main">
		<a href="https://niels.aufbau.io" target="_blank" rel="noreferrer">// visit niels</a>
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

		color: var(--background);
		border: var(--border);
		padding:  20px;
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
			background:  var(--background);
		}

		.main a {
			background:  var(--background);
		}
	}
</style>
