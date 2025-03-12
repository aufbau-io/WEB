<script>
	import { page } from '$app/stores';
	import { theme } from '$lib/store/theme';

	// Menu items
	const menuItems = [
		{ path: '/', label: 'Home', flower: '✿' },
		{ path: '/about', label: 'About', flower: '❀' },
		{ path: '/exhibitions', label: 'Exhibitions', flower: '✿' },
		{ path: '/art', label: 'Art', flower: '❀' },
		{ path: '/murals', label: 'Murals', flower: '✿' },
		{ path: '/workshops', label: 'Workshops', flower: '❀' },
		{ path: '/shop', label: 'Shop', flower: '✿' },
		{ path: '/contact', label: 'Contact', flower: '❀' }
	];
</script>

<div class="menu-wrapper">
	<nav>
		<ul>
			{#each menuItems as { path, label, flower }, i}
				<li 
					class="menu-item" 
					class:active={$page.url.pathname === path} 
				>
					<a 
						href={path} 
						class:active={$page.url.pathname === path}
					>
						<span class="label">{label}</span> <span class="flower">{flower}</span>
					</a>
				</li>
			{/each}
		</ul>
	</nav>
</div>

<style>
	.menu-wrapper {
		position: fixed;
		top: var(--margin);
		left: var(--margin);
		z-index: 100;
		padding: 10px 0;
	}

	nav ul {
		list-style: none;
		padding: 0;
		margin: 0;
		display: flex;
		flex-wrap: wrap;
		gap: 12px 16px;
	}

	nav li {
		display: flex;
		align-items: center;
		transition: transform var(--transition-medium);
		position: relative;
	}
	
	nav li::before {
		content: '';
		position: absolute;
		top: 0;
		left: 0;
		width: 100%;
		height: 100%;
		background-color: var(--background);
		opacity: 0;
		border-radius: 20px;
		z-index: -1;
		transform: scale(0.8);
		transition: all var(--transition-fast);
	}
	
	nav li:hover::before {
		opacity: 0.2;
		transform: scale(1);
	}

	.flower {
		display: inline-block;
		font-size: 0.9em;
		margin-left: 2px;
		color: var(--accent);
	}

	nav a {
		color: var(--primary);
		text-decoration: none;
		font-size: 14px;
		transition: all var(--transition-fast);
		position: relative;
		padding: 2px 4px;
		border-radius: 10px;
		display: flex;
		align-items: center;
	}
	
	nav a::after {
		display: none;
	}

	nav a:hover {
		opacity: 0.8;
	}

	nav a.active {
		font-weight: bold;
	}
	
	nav a.active::before {
		content: '';
		position: absolute;
		top: 0;
		left: 0;
		width: 100%;
		height: 100%;
		background-color: var(--background);
		opacity: 0.2;
		border-radius: 10px;
		z-index: -1;
	}
	
	.label {
		position: relative;
		display: inline-block;
	}
	
	.label::after {
		content: '';
		position: absolute;
		width: 100%;
		height: 1px;
		bottom: -2px;
		left: 0;
		background-color: var(--primary);
		transform: scaleX(0);
		transform-origin: bottom right;
		transition: transform var(--transition-medium);
	}
	
	a:hover .label::after,
	a.active .label::after {
		transform: scaleX(1);
		transform-origin: bottom left;
	}
	
	/* Mobile styles */
	@media (max-width: 768px) {
		.menu-wrapper {
			position: fixed;
			top: 0;
			left: 0;
			width: 100%;
			background-color: var(--background);
			box-shadow: var(--shadow-light);
			padding: 8px var(--margin);
			z-index: 100;
		}
		
		nav ul {
			justify-content: center;
			gap: 8px 12px;
		}
		
		nav a {
			font-size: 12px;
			padding: 2px 3px;
		}
		
		.flower {
			font-size: 0.8em;
		}
	}
	
	@media (max-width: 480px) {
		.menu-wrapper {
			padding: 5px var(--margin);
		}
		
		nav ul {
			gap: 5px 8px;
		}
		
		nav a {
			font-size: 11px;
		}
	}
</style> 