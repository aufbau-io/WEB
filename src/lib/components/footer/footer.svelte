<script>
</script>

<footer>
	<a href="https://archive.aufbau.io" target="_blank" rel="noreferrer">aufbau archive</a>
	<a href="https://www.websitecarbon.com/website/aufbau-io/" target="_blank" rel="noreferrer">0.04G CO2 / VISIT</a>
	<!-- <p class="">COPYRIGHT 2022</p> -->
</footer>

<style>
	footer {
		width: 100%;

		z-index: 10;
		gap: 10px;

		padding: 30px 20px;
		height: calc(2 * var(--margin));

		border-top: solid 1px var(--accent-50);
		text-transform: none;


		display: flex;
		flex-flow: row nowrap;
		align-items: center;
		justify-content: space-between;
	}

	footer a,
	footer p {
		background: var(--background);
		color: var(--primary);
		border: var(--border);

		padding: 6px 10px;
		font-size: 12px;

		letter-spacing: 0.15em;
		font-family: var(--font-body);
	}

	@media only screen and (max-width: 768px) {
		footer {
			padding: 20px 24px;
		}
		footer a,
		footer p {
			font-size: 12px;
		}
	}
</style>
