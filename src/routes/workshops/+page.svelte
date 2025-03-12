<script>
	// Workshops page
</script>

<div class="container">
	<h1>Workshops</h1>
	<div class="content">
		<p>Join our creative workshops and educational sessions.</p>
		
		<div class="upcoming-workshops">
			<h2>Upcoming Workshops</h2>
			<div class="workshops-grid">
				<div class="workshop-card">
					<div class="workshop-image"></div>
					<div class="workshop-details">
						<h3>Workshop Title</h3>
						<p class="date">Date: TBD</p>
						<p class="location">Location: Studio Space</p>
						<p class="description">A brief description of the workshop, what participants will learn, and what to bring.</p>
						<button class="register-btn">Register</button>
					</div>
				</div>
				<div class="workshop-card">
					<div class="workshop-image"></div>
					<div class="workshop-details">
						<h3>Workshop Title</h3>
						<p class="date">Date: TBD</p>
						<p class="location">Location: Studio Space</p>
						<p class="description">A brief description of the workshop, what participants will learn, and what to bring.</p>
						<button class="register-btn">Register</button>
					</div>
				</div>
			</div>
		</div>
		
		<div class="past-workshops">
			<h2>Past Workshops</h2>
			<div class="workshops-list">
				<div class="past-workshop">
					<h3>Workshop Title</h3>
					<p>Date: Past Date</p>
					<p>A brief summary of the workshop and its outcomes.</p>
				</div>
				<div class="past-workshop">
					<h3>Workshop Title</h3>
					<p>Date: Past Date</p>
					<p>A brief summary of the workshop and its outcomes.</p>
				</div>
			</div>
		</div>
	</div>
</div>

<style>
	.container {
		padding: var(--margin);
		margin-top: 60px;
		max-width: var(--column-width);
		margin-left: auto;
		margin-right: auto;
	}

	h1 {
		margin-bottom: 30px;
	}

	h2 {
		margin: 40px 0 20px;
		font-size: 18px;
	}

	h3 {
		font-size: 16px;
		margin-bottom: 5px;
	}

	.content {
		margin-top: 20px;
	}

	.workshops-grid {
		display: grid;
		grid-template-columns: 1fr;
		gap: 30px;
		margin-top: 20px;
	}

	.workshop-card {
		border: var(--border);
		border-radius: 2px;
		overflow: hidden;
	}

	.workshop-image {
		width: 100%;
		height: 180px;
		background-color: var(--background-50);
	}

	.workshop-details {
		padding: 20px;
	}

	.date, .location {
		font-size: 12px;
		margin-bottom: 5px;
	}

	.description {
		margin: 15px 0;
		line-height: 1.5;
	}

	.register-btn {
		background-color: var(--background);
		color: var(--primary);
		border: var(--border);
		padding: 8px 15px;
		cursor: pointer;
		transition: all 0.2s ease;
	}

	.register-btn:hover {
		opacity: 0.9;
	}

	.workshops-list {
		margin-top: 20px;
		display: flex;
		flex-direction: column;
		gap: 20px;
	}

	.past-workshop {
		padding-bottom: 20px;
		border-bottom: var(--border);
	}

	.past-workshop:last-child {
		border-bottom: none;
	}

	@media (min-width: 768px) {
		.workshops-grid {
			grid-template-columns: repeat(2, 1fr);
		}
	}
</style> 