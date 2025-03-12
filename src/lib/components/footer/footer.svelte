<script>
	// Footer component
	import { onMount } from 'svelte';
	import { theme } from '$lib/store/theme';
	
	export let showFooter = true;
	
	let year = new Date().getFullYear();
	let mounted = false;
	
	onMount(() => {
		mounted = true;
	});
</script>

{#if showFooter && mounted}
	<footer>
		<div class="footer-content">
			<div class="copyright">© {year} Sicovecas Studio</div>
			<div class="links">
				<a href="/privacy">Privacy</a>
				<a href="/terms">Terms</a>
			</div>
		</div>
	</footer>
{/if}

<style>
	footer {
		padding: var(--margin);
		border-top: var(--border);
		margin-top: auto;
	}
	
	/* Removing the unused footer p selector */
	
	.footer-content {
		display: flex;
		justify-content: space-between;
		align-items: center;
		max-width: var(--column-width);
		margin: 0 auto;
		font-size: 12px;
	}
	
	.links {
		display: flex;
		gap: 20px;
	}
	
	a {
		color: var(--primary);
		text-decoration: none;
	}
	
	a:hover {
		text-decoration: underline;
	}
</style>
