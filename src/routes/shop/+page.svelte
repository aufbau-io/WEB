<script>
	// Shop page
</script>

<div class="container">
	<h1>Shop</h1>
	<div class="content">
		<p>Browse and purchase original artwork, prints, and merchandise.</p>
		
		<div class="shop-filters">
			<button class="filter-btn active">All</button>
			<button class="filter-btn">Originals</button>
			<button class="filter-btn">Prints</button>
			<button class="filter-btn">Merchandise</button>
		</div>
		
		<div class="products-grid">
			<!-- Product items will go here -->
			<div class="product-card">
				<div class="product-image"></div>
				<div class="product-info">
					<h2>Product Title</h2>
					<p class="price">$XX.XX</p>
					<button class="add-to-cart">Add to Cart</button>
				</div>
			</div>
			<div class="product-card">
				<div class="product-image"></div>
				<div class="product-info">
					<h2>Product Title</h2>
					<p class="price">$XX.XX</p>
					<button class="add-to-cart">Add to Cart</button>
				</div>
			</div>
			<div class="product-card">
				<div class="product-image"></div>
				<div class="product-info">
					<h2>Product Title</h2>
					<p class="price">$XX.XX</p>
					<button class="add-to-cart">Add to Cart</button>
				</div>
			</div>
			<div class="product-card">
				<div class="product-image"></div>
				<div class="product-info">
					<h2>Product Title</h2>
					<p class="price">$XX.XX</p>
					<button class="add-to-cart">Add to Cart</button>
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

	.content {
		margin-top: 20px;
	}

	.shop-filters {
		display: flex;
		flex-wrap: wrap;
		gap: 10px;
		margin: 30px 0;
	}

	.filter-btn {
		background: none;
		border: var(--border);
		padding: 8px 15px;
		cursor: pointer;
		transition: all 0.2s ease;
	}

	.filter-btn:hover, .filter-btn.active {
		background-color: var(--background);
		color: var(--primary);
	}

	.products-grid {
		display: grid;
		grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
		gap: 30px;
		margin-top: 20px;
	}

	.product-card {
		border: var(--border);
		border-radius: 2px;
		overflow: hidden;
		transition: transform 0.3s ease;
	}

	.product-card:hover {
		transform: translateY(-5px);
	}

	.product-image {
		width: 100%;
		aspect-ratio: 1;
		background-color: var(--background-50);
	}

	.product-info {
		padding: 15px;
	}

	h2 {
		font-size: 16px;
		margin-bottom: 8px;
	}

	.price {
		font-weight: bold;
		margin-bottom: 15px;
	}

	.add-to-cart {
		width: 100%;
		background-color: var(--background);
		color: var(--primary);
		border: none;
		padding: 8px 0;
		cursor: pointer;
		transition: all 0.2s ease;
	}

	.add-to-cart:hover {
		opacity: 0.9;
	}

	@media (max-width: 768px) {
		.products-grid {
			grid-template-columns: repeat(2, 1fr);
		}
	}

	@media (max-width: 480px) {
		.products-grid {
			grid-template-columns: 1fr;
		}
	}
</style> 