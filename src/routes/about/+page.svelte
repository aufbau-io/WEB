<script>
	// About page
	import { theme } from '$lib/store/theme';
	
	// Flower symbols
	const flowers = ['✿', '❀', '✾', '❁', '✽'];
</script>

<div class="container">
	<div class="flower-corner top-left">✿</div>
	<div class="flower-corner top-right">❀</div>
	
	<h1>About <span class="flower">✿</span></h1>
	
	<div class="content">
		<p class="intro"><span class="flower">❀</span> Having been painting on the street since 2006, graffiti and visual artist Sicovecas captures this very public art experience in his style.</p>
		
		<p>Sicovecas' work is primarily about "interaction". His name, a play on "As I See (Sic)", reflects how he as artist interacts with the environment around him – be it the social or the physical. Sicovecas chooses his spots carefully for the feel of the location, the shifts in light, the quirks and the activities of the people around it, and his art responds to this.</p>
		
		<p>His work is not only public in the location being a public space, but it is a social act – in painting on someone's wall, or in someone's neighborhood, Sic's pieces involve trust and building relationships with those he encounters. <span class="flower">✿</span></p>
		
		<div class="image-placeholder">
			<img src="/obi.png" alt="Sicovecas artwork" />
		</div>
		
		<p><span class="flower">❀</span> All these elements of interaction inform what he paints, creating colorful and sensitive pieces with stories of neighbors and families, shared food, and waiting for the rain to pass on people's porches.</p>
		
		<p>As Sic has developed his artistic practice, expanding into mix-media visual art, he has taken these interactions, the use of space, and the humanness of the encounters during the art creation, and incorporated them into everything he creates – whether that be canvases, ceramics or exhibition spaces.</p>
		
		<div class="image-placeholder">
			<img src="/img-2.png" alt="Sicovecas artwork" />
		</div>
		
		<p>These works are characteristically raw, abstract and organic – in his words "the closest style to being human". <span class="flower">✿</span></p>
		
		<p class="outro">Sicovecas has held exhibitions and joined events in Indonesia, the United Kingdom, Singapore & France. <span class="flower">❀</span></p>
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
		display: flex;
		flex-direction: column;
		gap: 20px;
	}

	p {
		line-height: 1.6;
		font-size: 14px;
		max-width: 95%;
		margin: 0 auto;
	}
	
	.intro, .outro {
		font-size: 16px;
		font-style: italic;
		text-align: center;
	}

	.image-placeholder {
		width: 100%;
		height: 300px;
		background-color: var(--background-50);
		margin: 10px 0;
		border-radius: 15px;
		overflow: hidden;
		transition: transform var(--transition-medium);
	}
	
	.image-placeholder img {
		width: 100%;
		height: 100%;
		object-fit: cover;
		transition: transform var(--transition-medium);
	}
	
	.image-placeholder:hover {
		transform: scale(1.02);
	}
	
	.image-placeholder:hover img {
		transform: scale(1.05);
	}
	
	.flower {
		display: inline-block;
		font-size: 0.9em;
		color: var(--accent);
	}
	
	.flower-corner {
		position: absolute;
		font-size: 24px;
		opacity: 0.5;
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

	@media (max-width: 768px) {
		.container {
			margin-top: 40px;
		}
		
		.image-placeholder {
			height: 200px;
		}
		
		p {
			max-width: 100%;
			font-size: 13px;
		}
		
		.intro, .outro {
			font-size: 15px;
		}
	}
	
	@media (max-width: 480px) {
		.container {
			margin-top: 30px;
		}
		
		.image-placeholder {
			height: 180px;
		}
		
		.flower-corner {
			font-size: 18px;
		}
	}
</style>