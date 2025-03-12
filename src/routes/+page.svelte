<script>
	// Home page
	import { onMount } from 'svelte';
	import { theme } from '$lib/store/theme';
	
	// Flower symbols for more organic feel
	const flowers = ['✿', '❀', '✾', '❁', '✽'];
</script>

<!-- <Title /> -->

<div class="container">
	<div class="flower-corner top-left">✿</div>
	<div class="flower-corner top-right">❀</div>
	
	<div class="hero">
		<h1>SICOVECAS <span class="flower">✿</span></h1>
		<p class="tagline">Graffiti and Visual Artist</p>
	</div>
	
	<div class="featured-work">
		<div class="main-image">
			<img src="/obi.png" alt="Featured artwork by Sicovecas" />
		</div>
		
		<div class="featured-text">
			<p><span class="flower">❀</span> Creating colorful and sensitive pieces with stories of neighbors and families, shared food, and waiting for the rain to pass on people's porches <span class="flower">❀</span></p>
			<a href="/about" class="learn-more">Learn more about the artist ✿</a>
		</div>
	</div>
	
	<div class="categories">
		<div class="category">
			<a href="/art">
				<div class="category-image">
					<img src="/img-1.png" alt="Art by Sicovecas" />
				</div>
				<h2>Art <span class="flower">✿</span></h2>
			</a>
		</div>
		<div class="category">
			<a href="/murals">
				<div class="category-image">
					<img src="/obi.png" alt="Murals by Sicovecas" />
				</div>
				<h2>Murals <span class="flower">❀</span></h2>
			</a>
		</div>
		<div class="category">
			<a href="/exhibitions">
				<div class="category-image">
					<img src="/abstract-art.jpg" alt="Exhibitions by Sicovecas" />
				</div>
				<h2>Exhibitions <span class="flower">✿</span></h2>
			</a>
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
		overflow: visible;
	}

	.hero {
		margin-bottom: 40px;
		text-align: center;
	}

	h1 {
		font-size: 32px;
		margin-bottom: 10px;
		font-weight: 400;
		letter-spacing: 0.15em;
	}

	.tagline {
		font-size: 16px;
		opacity: 0.8;
		font-style: italic;
	}

	.featured-work {
		margin-bottom: 60px;
	}

	.main-image {
		width: 100%;
		height: 400px;
		background-color: var(--background-50);
		margin-bottom: 20px;
		border-radius: 20px;
		transition: transform var(--transition-medium);
		overflow: hidden;
	}
	
	.main-image img {
		width: 100%;
		height: 100%;
		object-fit: cover;
		transition: transform var(--transition-medium);
	}
	
	.main-image:hover {
		transform: scale(1.02);
	}
	
	.main-image:hover img {
		transform: scale(1.05);
	}

	.featured-text {
		margin-top: 20px;
		text-align: center;
		max-width: 80%;
		margin-left: auto;
		margin-right: auto;
	}

	.featured-text p {
		margin-bottom: 20px;
		line-height: 1.8;
		font-size: 16px;
		font-style: italic;
	}

	.learn-more {
		display: inline-block;
		margin-top: 10px;
		border-bottom: 1px solid var(--primary);
		padding-bottom: 2px;
	}

	.categories {
		display: grid;
		grid-template-columns: repeat(3, 1fr);
		gap: 30px;
	}

	.category {
		text-align: center;
		transition: transform var(--transition-medium);
	}
	
	.category:hover {
		transform: translateY(-5px);
	}

	.category a {
		text-decoration: none;
	}
	
	.category a::after {
		display: none;
	}

	.category-image {
		width: 100%;
		aspect-ratio: 1;
		background-color: var(--background-50);
		margin-bottom: 10px;
		transition: all var(--transition-medium);
		border-radius: 50%;
		overflow: hidden;
	}
	
	.category-image img {
		width: 100%;
		height: 100%;
		object-fit: cover;
		transition: transform var(--transition-medium);
	}

	.category:hover .category-image {
		transform: translateY(-5px) scale(1.05);
	}
	
	.category:hover .category-image img {
		transform: scale(1.1);
	}

	h2 {
		font-size: 18px;
		margin-top: 10px;
		font-weight: 400;
	}
	
	.flower {
		display: inline-block;
		font-size: 0.9em;
		color: var(--accent);
	}
	
	.flower-corner {
		position: absolute;
		font-size: 24px;
		opacity: 0.7;
		color: var(--accent);
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
	
	/* Mobile responsiveness */
	@media only screen and (max-width: 768px) {
		.container {
			margin-top: 40px;
		}
		
		h1 {
			font-size: 28px;
		}
		
		.main-image {
			height: 300px;
		}
		
		.categories {
			grid-template-columns: repeat(2, 1fr);
		}
	}
	
	@media only screen and (max-width: 480px) {
		.container {
			margin-top: 30px;
		}
		
		h1 {
			font-size: 24px;
		}
		
		.main-image {
			height: 250px;
		}
		
		.categories {
			grid-template-columns: 1fr;
			gap: 20px;
		}
		
		.featured-text {
			max-width: 100%;
		}
	}
</style>