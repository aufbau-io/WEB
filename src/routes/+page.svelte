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

    .main::before, .main::after, .main p::before, .main p::after {
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
    .main p::before {
        top: 1px; /* leave a 1px gap */
        bottom: 1px; /* leave a 1px gap */
        left: 0;
        width: 19px;
    }
    .main p::after {
        top: 1px; /* leave a 1px gap */
        bottom: 1px; /* leave a 1px gap */
        right: 0;
        width: 19px;
    }

    .main p {
        color: var(--primary);
				background: var(--background);
        border: none;
        width: 100%;
        height: 100%;
    }
}
</style>
