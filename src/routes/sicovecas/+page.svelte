<script>
</script>

<section>
	<div class="main">
		<a href="https://sicovecas-demo.netlify.app" target="_blank" rel="noreferrer">// visit sicovecas</a>
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

.main a {
		padding: 20px;
		border: solid 1px var(--background);
		background:  var(--background);
		color: var(--primary);
	}

	@media only screen and (max-width: 768px) {
		.main {
			position: absolute;
			bottom: 20px;
			width: calc(100% - 40px);
			background: var(--background);
			padding: 20px;
		}

		.main a {
			color: var(--primary);
			background: var(--black);
		}
	}
</style>
