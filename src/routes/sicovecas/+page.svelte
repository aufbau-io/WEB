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
		padding: 20px;
		border: solid 1px var(--background);
		background:  var(--background);
		color: var(--primary);
	}

	@media only screen and (max-width: 768px) {
		section {
			padding: 20px 0;
			justify-content: flex-end;
		}

    .main {
        position: absolute;

        width: calc(100% - 40px);
        background: transparent; /* Make sure it's transparent */
        padding: 20px;
        position: relative;
    }

    .main::before, .main::after, .main a::before, .main a::after {
        content: "";
        position: absolute;
        background: var(--background);
        z-index: -1;
    }

    /* Top and Bottom boxes for .main */
    .main::before {
        top: 0;
        left: 0;
        right: 0;
        height: 19px;
    }
    .main::after {
        bottom: 0;
        left: 0;
        right: 0;
        height: 19px;
    }

    /* Left and Right boxes for .main */
    .main a::before {
        top: 1px; /* leave a 1px gap */
        bottom: 1px; /* leave a 1px gap */
        left: 0;
        width: 19px;
    }
    .main a::after {
        top: 1px; /* leave a 1px gap */
        bottom: 1px; /* leave a 1px gap */
        right: 0;
        width: 19px;
    }

    .main a {
        color: var(--primary);
        border: none;
        width: 100%;
        height: 100%;
    }
}
</style>
