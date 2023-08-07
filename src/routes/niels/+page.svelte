<script>
</script>

<section>
	<div class="main">
		<a href="https://niels.aufbau.io" target="_blank" rel="noreferrer">visit niels</a>
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

		display: flex;
		flex-flow: column nowrap;
		justify-content: center;
		gap: 10px;

		background:  var(--background);
		color: var(--primary);
		border: var(--border);
		padding:  20px;
	}

	.main a {
		background: var(--black);
		padding: 20px;
	}

	@media only screen and (max-width: 768px) {
		.main {
			position: absolute;
			bottom: 20px;
			width: calc(100% - 40px);
		}
	}
</style>
