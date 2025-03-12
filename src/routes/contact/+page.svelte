<script>
	// Contact page
	let formData = {
		name: '',
		email: '',
		subject: '',
		message: ''
	};

	function handleSubmit() {
		// Handle form submission (to be implemented)
		console.log('Form submitted:', formData);
		alert('Thank you for your message! We will get back to you soon.');
		
		// Reset form
		formData = {
			name: '',
			email: '',
			subject: '',
			message: ''
		};
	}
</script>

<div class="container">
	<h1>Contact</h1>
	<div class="content">
		<p>Get in touch with us for inquiries, collaborations, or just to say hello.</p>
		
		<div class="contact-grid">
			<div class="contact-info">
				<div class="info-item">
					<h2>Email</h2>
					<p><a href="mailto:hello@example.com">hello@example.com</a></p>
				</div>
				
				<div class="info-item">
					<h2>Phone</h2>
					<p>+1 (123) 456-7890</p>
				</div>
				
				<div class="info-item">
					<h2>Studio</h2>
					<p>123 Art Street<br>Creative District<br>City, State 12345</p>
				</div>
				
				<div class="info-item">
					<h2>Social</h2>
					<div class="social-links">
						<a href="https://instagram.com/sicovecasstudio" class="social-link">Instagram</a>
						<a href="https://twitter.com/sicovecasstudio" class="social-link">Twitter</a>
						<a href="https://facebook.com/sicovecasstudio" class="social-link">Facebook</a>
					</div>
				</div>
			</div>
			
			<div class="contact-form">
				<h2>Send a Message</h2>
				<form on:submit|preventDefault={handleSubmit}>
					<div class="form-group">
						<label for="name">Name</label>
						<input 
							type="text" 
							id="name" 
							bind:value={formData.name} 
							required
						/>
					</div>
					
					<div class="form-group">
						<label for="email">Email</label>
						<input 
							type="email" 
							id="email" 
							bind:value={formData.email} 
							required
						/>
					</div>
					
					<div class="form-group">
						<label for="subject">Subject</label>
						<input 
							type="text" 
							id="subject" 
							bind:value={formData.subject} 
							required
						/>
					</div>
					
					<div class="form-group">
						<label for="message">Message</label>
						<textarea 
							id="message" 
							bind:value={formData.message} 
							rows="5" 
							required
						></textarea>
					</div>
					
					<button type="submit" class="submit-btn">Send Message</button>
				</form>
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
		font-size: 16px;
		margin-bottom: 10px;
	}

	.content {
		margin-top: 20px;
	}

	.contact-grid {
		display: grid;
		grid-template-columns: 1fr;
		gap: 40px;
		margin-top: 30px;
	}

	.contact-info {
		display: grid;
		grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
		gap: 30px;
	}

	.info-item {
		margin-bottom: 20px;
	}

	.social-links {
		display: flex;
		flex-wrap: wrap;
		gap: 10px;
	}

	.social-link {
		margin-right: 15px;
	}

	.contact-form {
		border: var(--border);
		padding: 30px;
		border-radius: 2px;
	}

	.form-group {
		margin-bottom: 20px;
	}

	label {
		display: block;
		margin-bottom: 5px;
		font-size: 12px;
	}

	input, textarea {
		width: 100%;
		padding: 10px;
		background: none;
		border: var(--border);
		color: var(--primary);
		font-family: var(--font-body);
	}

	textarea {
		resize: vertical;
	}

	.submit-btn {
		background-color: var(--background);
		color: var(--primary);
		border: none;
		padding: 10px 20px;
		cursor: pointer;
		transition: all 0.2s ease;
	}

	.submit-btn:hover {
		opacity: 0.9;
	}

	@media (min-width: 768px) {
		.contact-grid {
			grid-template-columns: 1fr 1fr;
		}
	}
</style> 