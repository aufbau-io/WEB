<script>
	// Murals page
	import { onMount } from 'svelte';
	import { theme } from '$lib/store/theme';
	
	// Placeholder mural items
	const muralItems = [
		{
			title: 'Community Connection',
			location: 'Downtown District, Jakarta',
			description: 'A large-scale mural celebrating the diversity and unity of the local community. Created in collaboration with neighborhood residents, this piece incorporates stories and symbols meaningful to the area.',
			rotation: -1.5
		},
		{
			title: 'Urban Nature',
			location: 'Arts District, London',
			description: 'Exploring the relationship between urban environments and natural elements, this mural brings vibrant plant life to concrete surroundings, reminding viewers of nature\'s resilience.',
			rotation: 1
		},
		{
			title: 'Shared Memories',
			location: 'Heritage Quarter, Singapore',
			description: 'A narrative mural depicting the shared history and cultural heritage of the neighborhood. This piece was created after weeks of conversations with local elders and community leaders.',
			rotation: -0.8
		},
		{
			title: 'Transition Spaces',
			location: 'Cultural Center, Paris',
			description: 'Commissioned for a public transit area, this mural explores the concept of movement and transition in urban life, creating a moment of reflection in a space usually passed through quickly.',
			rotation: 1.2
		}
	];
	
	// Flower symbols
	const flowers = ['✿', '❀', '✾', '❁', '✽'];
</script>

<div class="container">
	<div class="flower-corner top-left">✿</div>
	<div class="flower-corner top-right">❀</div>
	
	<h1>Murals <span class="flower">✿</span></h1>
	<div class="content">
		<p>Large-scale mural projects and public art installations around the world. <span class="flower">❀</span></p>
		
		<div class="featured-mural">
			<div class="featured-image">
				<img src="/abstract-art.jpg" alt="Featured mural by Sicovecas" />
			</div>
			<div class="featured-info">
				<h2>Featured: "Community Connections" <span class="flower">✿</span></h2>
				<p class="location">Jakarta, Indonesia</p>
				<p class="description">A landmark mural project spanning multiple buildings, created in collaboration with local residents and reflecting the spirit of the neighborhood.</p>
			</div>
		</div>
		
		<div class="murals-list">
			{#each muralItems as mural, i}
				<div class="mural-item" style="--rotation: {mural.rotation}deg">
					<div class="mural-image" style="background-color: var(--background); opacity: {0.6 + (i % 4) * 0.1}">
						<img src={i % 3 === 0 ? '/abstract-art.jpg' : (i % 3 === 1 ? '/img-1.png' : '/img-2.png')} alt={mural.title} />
					</div>
					<div class="mural-info">
						<h2>{mural.title} <span class="flower">{flowers[i % flowers.length]}</span></h2>
						<p class="location">{mural.location}</p>
						<p class="description">{mural.description}</p>
						<div class="mural-details">
							<span class="detail">Size: {100 + i * 50}m²</span>
							<span class="detail">Year: {2018 + i}</span>
							<span class="detail">Medium: Spray Paint & Acrylic</span>
						</div>
					</div>
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
	
	.featured-mural {
		margin: 40px 0;
		border: var(--border);
		padding: 20px;
		border-radius: 15px;
		transform: rotate(-0.5deg);
		transition: all 0.4s ease;
	}
	
	.featured-mural:hover {
		transform: translateY(-5px) rotate(0deg);
	}
	
	.featured-image {
		width: 100%;
		height: 350px;
		background-color: var(--background);
		opacity: 0.8;
		margin-bottom: 20px;
		border-radius: 10px;
		overflow: hidden;
	}
	
	.featured-image img {
		width: 100%;
		height: 100%;
		object-fit: cover;
		transition: transform var(--transition-medium);
	}
	
	.featured-mural:hover .featured-image img {
		transform: scale(1.05);
	}
	
	.featured-info {
		text-align: center;
	}
	
	.featured-info h2 {
		font-size: 22px;
		margin-bottom: 10px;
		font-weight: 400;
	}

	.murals-list {
		display: flex;
		flex-direction: column;
		gap: 40px;
		margin-top: 30px;
	}

	.mural-item {
		display: flex;
		flex-direction: column;
		gap: 20px;
		border-bottom: var(--border);
		padding-bottom: 40px;
		transform: rotate(var(--rotation, 0deg));
		transition: all 0.4s ease;
	}
	
	.mural-item:hover {
		transform: translateY(-5px) rotate(0deg);
	}

	.mural-item:last-child {
		border-bottom: none;
	}

	.mural-image {
		width: 100%;
		height: 300px;
		border-radius: 10px;
		overflow: hidden;
	}
	
	.mural-image img {
		width: 100%;
		height: 100%;
		object-fit: cover;
		transition: transform var(--transition-medium);
	}
	
	.mural-item:hover .mural-image img {
		transform: scale(1.1);
	}

	.mural-info {
		display: flex;
		flex-direction: column;
		gap: 10px;
	}

	h2 {
		font-size: 18px;
		font-weight: 400;
	}

	.location {
		font-style: italic;
		opacity: 0.8;
	}

	.description {
		margin-top: 10px;
		line-height: 1.6;
	}
	
	.mural-details {
		display: flex;
		flex-wrap: wrap;
		gap: 15px;
		margin-top: 15px;
		font-size: 12px;
	}
	
	.detail {
		background-color: var(--background);
		color: var(--primary);
		padding: 4px 8px;
		border-radius: 20px;
		transition: all 0.3s ease;
	}
	
	.detail:hover {
		transform: scale(1.05);
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
			transform: rotate(-5deg);
		}
		100% {
			transform: rotate(5deg);
		}
	}

	@media (min-width: 768px) {
		.mural-item {
			flex-direction: row;
		}

		.mural-image {
			width: 50%;
			height: 250px;
		}

		.mural-info {
			width: 50%;
			padding-left: 20px;
		}
	}
	
	@media (max-width: 768px) {
		.content > p {
			max-width: 100%;
		}
	}
</style> 