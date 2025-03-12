<script>
	// Art page
	import { onMount } from 'svelte';
	import { theme } from '$lib/store/theme';
	
	// Placeholder art items with different aspect ratios for visual interest
	const artItems = [
		{ title: 'Artwork Title 1', medium: 'Acrylic on Canvas, 2023', aspectRatio: '1/1', rotation: -2 },
		{ title: 'Artwork Title 2', medium: 'Mixed Media, 2022', aspectRatio: '4/5', rotation: 1 },
		{ title: 'Artwork Title 3', medium: 'Digital Print, 2023', aspectRatio: '3/4', rotation: -1.5 },
		{ title: 'Artwork Title 4', medium: 'Oil on Canvas, 2021', aspectRatio: '1/1', rotation: 2 },
		{ title: 'Artwork Title 5', medium: 'Watercolor, 2022', aspectRatio: '5/6', rotation: -1 },
		{ title: 'Artwork Title 6', medium: 'Charcoal on Paper, 2023', aspectRatio: '1/1', rotation: 1.5 },
		{ title: 'Artwork Title 7', medium: 'Spray Paint, 2021', aspectRatio: '4/3', rotation: -2.5 },
		{ title: 'Artwork Title 8', medium: 'Collage, 2022', aspectRatio: '1/1', rotation: 1.2 }
	];
	
	// Flower symbols
	const flowers = ['✿', '❀', '✾', '❁', '✽'];
	
	// Random rotation for elements
	function getRandomRotation() {
		return (Math.random() * 4 - 2) + 'deg';
	}
	
	// Random shape for art items
	function getRandomShape(i) {
		const shapes = ['0%', '10px', '50%', '0 50% 50% 0', '50% 0 0 50%'];
		return shapes[i % shapes.length];
	}
</script>

<div class="container">
	<div class="flower-corner top-left">✿</div>
	<div class="flower-corner top-right">❀</div>
	
	<h1 style="--rotation: {getRandomRotation()}">Art <span class="flower">✿</span></h1>
	<div class="content">
		<p style="--rotation: {getRandomRotation()}">A collection of artworks and creative pieces exploring themes of interaction, community, and human connection. <span class="flower">❀</span></p>
		
		<div class="filters">
			<button class="filter-btn active" style="--rotation: {getRandomRotation()}">All <span class="flower">✿</span></button>
			<button class="filter-btn" style="--rotation: {getRandomRotation()}">Paintings <span class="flower">❀</span></button>
			<button class="filter-btn" style="--rotation: {getRandomRotation()}">Digital <span class="flower">✿</span></button>
			<button class="filter-btn" style="--rotation: {getRandomRotation()}">Mixed Media <span class="flower">❀</span></button>
		</div>
		
		<div class="art-grid">
			{#each artItems as item, i}
				<div class="art-item" style="--aspect: {item.aspectRatio}; --rotation: {item.rotation}deg">
					<div class="art-image" style="opacity: {0.7 + (i % 3) * 0.1}; border-radius: {getRandomShape(i)};">
						<img 
							src={i % 2 === 0 ? '/img-1.png' : '/img-2.png'} 
							alt={item.title}
							onerror="this.onerror=null; this.src='/img-1.png';"
						/>
					</div>
					<h2 style="--rotation: {getRandomRotation()}">{item.title} <span class="flower">{flowers[i % flowers.length]}</span></h2>
					<p style="--rotation: {getRandomRotation()}">{item.medium}</p>
				</div>
			{/each}
		</div>
	</div>
	
	<div class="flower-corner bottom-left">❀</div>
	<div class="flower-corner bottom-right">✿</div>
</div>

<style>
	.container {
		padding: var(--margin);
		margin-top: 60px;
		max-width: var(--column-width);
		margin-left: auto;
		margin-right: auto;
		position: relative;
	}

	h1 {
		margin-bottom: 30px;
		text-align: center;
		font-weight: 400;
		letter-spacing: 0.1em;
	}

	.content {
		margin-top: 20px;
	}
	
	.content > p {
		text-align: center;
		max-width: 80%;
		margin: 0 auto 30px;
		font-style: italic;
		line-height: 1.6;
	}
	
	.filters {
		display: flex;
		flex-wrap: wrap;
		justify-content: center;
		gap: 10px;
		margin: 30px 0;
	}
	
	.filter-btn {
		background: none;
		border: var(--border);
		padding: 6px 12px;
		cursor: pointer;
		transition: all var(--transition-medium);
		font-size: 12px;
		border-radius: 20px;
		transform: rotate(var(--rotation, -1deg));
	}
	
	.filter-btn:hover, .filter-btn.active {
		background-color: var(--background);
		color: var(--primary);
		transform: rotate(0deg) scale(1.05);
	}

	.art-grid {
		display: grid;
		grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
		gap: 30px;
		margin-top: 30px;
	}

	.art-item {
		cursor: pointer;
		transition: all var(--transition-medium);
		transform: rotate(var(--rotation, 0deg));
		position: relative;
		z-index: 1;
	}

	.art-item:hover {
		transform: translateY(-5px) rotate(0deg);
		z-index: 2;
	}

	.art-image {
		width: 100%;
		aspect-ratio: var(--aspect, 1);
		margin-bottom: 10px;
		box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
		transition: all var(--transition-medium);
		overflow: hidden;
	}
	
	.art-image img {
		width: 100%;
		height: 100%;
		object-fit: cover;
		transition: transform var(--transition-medium);
	}
	
	.art-item:hover .art-image {
		transform: scale(1.05);
		box-shadow: 0 8px 16px rgba(0, 0, 0, 0.15);
	}
	
	.art-item:hover .art-image img {
		transform: scale(1.1);
	}

	h2 {
		font-size: 16px;
		margin-bottom: 5px;
		font-weight: 400;
		transform: rotate(var(--rotation, 0deg));
	}

	p {
		font-size: 12px;
		opacity: 0.8;
		transform: rotate(var(--rotation, 0deg));
	}
	
	.flower {
		display: inline-block;
		font-size: 0.9em;
		animation: sway 3s ease-in-out infinite alternate;
	}
	
	.flower-corner {
		position: absolute;
		font-size: 24px;
		opacity: 0.7;
		animation: sway 4s ease-in-out infinite alternate;
	}
	
	.top-left {
		top: 10px;
		left: 10px;
	}
	
	.top-right {
		top: 10px;
		right: 10px;
	}
	
	.bottom-left {
		bottom: 10px;
		left: 10px;
	}
	
	.bottom-right {
		bottom: 10px;
		right: 10px;
	}
	
	@keyframes sway {
		0% {
			transform: rotate(-5deg) translateY(0);
		}
		50% {
			transform: rotate(0deg) translateY(-2px);
		}
		100% {
			transform: rotate(5deg) translateY(0);
		}
	}

	@media (max-width: 768px) {
		.art-grid {
			grid-template-columns: repeat(2, 1fr);
		}
		
		.content > p {
			max-width: 100%;
		}
	}

	@media (max-width: 480px) {
		.art-grid {
			grid-template-columns: 1fr;
		}
	}
</style> 