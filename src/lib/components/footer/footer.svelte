<script>
</script>

<footer>
	<!-- <a href="https://archive.aufbau.io"  rel="noreferrer">aufbau archive</a> -->
	<a href="https://www.websitecarbon.com/website/aufbau-io/" rel="noreferrer">0.05G CO2 / VISIT</a>
	<!-- <p class="">COPYRIGHT 2022</p> -->
</footer>

<style>
	footer {
		width: 100%;

		z-index: 10;
		gap: 10px;

		padding: 35px 20px;
		height: calc(2 * var(--margin));

		border-top: solid 1px var(--accent-50);
		text-transform: none;

		display: flex;
		flex-flow: row nowrap;
		align-items: center;
		justify-content: flex-end;
	}

	footer a,
	footer p {
		backdrop-filter: blur(10px);
		color: var(--background);
		border: var(--border);

		padding: 10px 15px;
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
