<script>
	// Exhibitions page
	import { onMount } from 'svelte';
	import { theme } from '$lib/store/theme';
	
	// Placeholder exhibition items
	const upcomingExhibitions = [
		{
			title: "Interactions: Urban Dialogues",
			dates: "June 15 - July 30, 2023",
			location: "Contemporary Art Space, London",
			description: "A solo exhibition exploring the interactions between urban environments and their inhabitants.",
			rotation: -1.5
		},
		{
			title: "Collective Memory",
			dates: "August 10 - September 25, 2023",
			location: "Gallery Modern, Singapore",
			description: "Group exhibition featuring works that examine shared cultural memories and experiences.",
			rotation: 1
		}
	];
	
	const pastExhibitions = [
		{
			title: "Raw Abstractions",
			dates: "January 5 - February 28, 2023",
			location: "Urban Gallery, Jakarta",
			description: "A collection of abstract works exploring organic forms and raw expressions.",
			rotation: -1
		},
		{
			title: "Street to Canvas",
			dates: "October 10 - November 30, 2022",
			location: "Street Art Museum, Paris",
			description: "Exploring the transition from public murals to gallery works.",
			rotation: 1.5
		},
		{
			title: "Community Portraits",
			dates: "May 15 - June 30, 2022",
			location: "People's Gallery, London",
			description: "Portraits and stories from neighborhood interactions and community building.",
			rotation: -0.5
		},
		{
			title: "Dialogues in Color",
			dates: "February 1 - March 15, 2022",
			location: "Color Space, Singapore",
			description: "An exploration of color theory and emotional responses in urban settings.",
			rotation: 0.8
		}
	];
	
	// Flower symbols
	const flowers = ['✿', '❀', '✾', '❁', '✽'];
</script>

<div class="container">
	<div class="flower-corner top-left">✿</div>
	<div class="flower-corner top-right">❀</div>
	
	<h1>Exhibitions <span class="flower">✿</span></h1>
	<div class="content">
		<p>Current, upcoming, and past exhibitions featuring Sicovecas' work. <span class="flower">❀</span></p>
		
		<div class="exhibition-section">
			<h2>Current & Upcoming <span class="flower">✿</span></h2>
			<div class="exhibitions-grid">
				{#each upcomingExhibitions as exhibition, i}
					<div class="exhibition-card" style="--rotation: {exhibition.rotation}deg">
						<div class="exhibition-image" style="opacity: {0.7 + (i % 2) * 0.2}">
							<img 
								src={i % 2 === 0 ? '/img-1.png' : '/img-2.png'} 
								alt={exhibition.title}
								onerror="this.onerror=null; this.src='/img-1.png';"
							/>
						</div>
						<div class="exhibition-details">
							<h3>{exhibition.title} <span class="flower">{flowers[i % flowers.length]}</span></h3>
							<p class="dates">{exhibition.dates}</p>
							<p class="location">{exhibition.location}</p>
							<p class="description">{exhibition.description}</p>
							<button class="more-info">More Information <span class="flower">{flowers[(i+2) % flowers.length]}</span></button>
						</div>
					</div>
				{/each}
			</div>
		</div>
		
		<div class="exhibition-section">
			<h2>Past Exhibitions <span class="flower">❀</span></h2>
			<div class="past-exhibitions">
				{#each pastExhibitions as exhibition, i}
					<div class="past-exhibition" style="--rotation: {exhibition.rotation}deg">
						<div class="past-exhibition-header">
							<h3>{exhibition.title} <span class="flower">{flowers[i % flowers.length]}</span></h3>
							<p class="dates">{exhibition.dates}</p>
						</div>
						<div class="past-exhibition-content">
							<div class="thumbnail" style="opacity: {0.6 + (i % 4) * 0.1}">
								<img 
									src={i % 2 === 0 ? '/img-1.png' : '/img-2.png'} 
									alt={exhibition.title}
									onerror="this.onerror=null; this.src='/img-1.png';"
								/>
							</div>
							<div class="details">
								<p class="location">{exhibition.location}</p>
								<p class="description">{exhibition.description}</p>
							</div>
						</div>
					</div>
				{/each}
			</div>
		</div>
		
		<div class="exhibition-section">
			<h2>Exhibition Archive <span class="flower">✿</span></h2>
			<div class="archive-years">
				{#each ['2022', '2021', '2020', '2019', '2018'] as year, i}
					<button class="year-btn" style="--rotation: {-2 + i * 1}deg">
						{year} <span class="flower">{flowers[i % flowers.length]}</span>
					</button>
				{/each}
			</div>
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
	
	h2 {
		font-size: 22px;
		margin-bottom: 20px;
		border-bottom: var(--border);
		padding-bottom: 10px;
		font-weight: 400;
		transform: rotate(var(--rotation, -0.5deg));
	}
	
	h3 {
		font-size: 18px;
		margin-bottom: 8px;
		font-weight: 400;
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
	
	.exhibition-section {
		margin-bottom: 60px;
	}

	.exhibitions-grid {
		display: grid;
		grid-template-columns: 1fr;
		gap: 30px;
		margin-top: 30px;
	}
	
	.exhibition-card {
		border: var(--border);
		overflow: hidden;
		border-radius: 10px;
		transform: rotate(var(--rotation, 0deg));
		transition: all 0.4s ease;
	}
	
	.exhibition-card:hover {
		transform: translateY(-5px) rotate(0deg);
	}
	
	.exhibition-image {
		width: 100%;
		height: 200px;
		background-color: var(--background);
		border-radius: 10px 10px 0 0;
		overflow: hidden;
	}
	
	.exhibition-image img {
		width: 100%;
		height: 100%;
		object-fit: cover;
		transition: transform var(--transition-medium);
	}
	
	.exhibition-card:hover .exhibition-image img {
		transform: scale(1.1);
	}
	
	.exhibition-details {
		padding: 20px;
	}
	
	.dates, .location {
		font-size: 14px;
		margin-bottom: 5px;
	}
	
	.location {
		font-style: italic;
	}
	
	.description {
		margin: 15px 0;
		line-height: 1.5;
	}
	
	.more-info {
		background-color: var(--background);
		color: var(--primary);
		border: none;
		padding: 8px 15px;
		cursor: pointer;
		transition: all 0.3s ease;
		border-radius: 20px;
	}
	
	.more-info:hover {
		opacity: 0.8;
		transform: scale(1.05);
	}
	
	.past-exhibitions {
		display: flex;
		flex-direction: column;
		gap: 25px;
	}
	
	.past-exhibition {
		border-bottom: var(--border);
		padding-bottom: 25px;
		transform: rotate(var(--rotation, 0deg));
		transition: all 0.4s ease;
	}
	
	.past-exhibition:hover {
		transform: translateY(-5px) rotate(0deg);
	}
	
	.past-exhibition:last-child {
		border-bottom: none;
	}
	
	.past-exhibition-header {
		margin-bottom: 15px;
	}
	
	.past-exhibition-content {
		display: flex;
		flex-direction: column;
		gap: 15px;
	}
	
	.thumbnail {
		width: 100%;
		height: 120px;
		background-color: var(--background);
		border-radius: 8px;
		overflow: hidden;
	}
	
	.thumbnail img {
		width: 100%;
		height: 100%;
		object-fit: cover;
		transition: transform var(--transition-medium);
	}
	
	.past-exhibition:hover .thumbnail img {
		transform: scale(1.1);
	}
	
	.archive-years {
		display: flex;
		flex-wrap: wrap;
		gap: 15px;
		justify-content: center;
	}
	
	.year-btn {
		background: none;
		border: var(--border);
		padding: 8px 15px;
		cursor: pointer;
		transition: all 0.3s ease;
		border-radius: 20px;
		transform: rotate(var(--rotation, 0deg));
	}
	
	.year-btn:hover {
		background-color: var(--background);
		color: var(--primary);
		transform: rotate(0deg) scale(1.05);
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
		.exhibitions-grid {
			grid-template-columns: repeat(2, 1fr);
		}
		
		.past-exhibition-content {
			flex-direction: row;
		}
		
		.thumbnail {
			width: 150px;
			height: 100px;
			flex-shrink: 0;
		}
		
	.details {
			flex-grow: 1;
		}
	}
	
	@media (max-width: 768px) {
		.content > p {
			max-width: 100%;
		}
	}
</style> 