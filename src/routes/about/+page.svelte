<script>
  	import { onMount } from 'svelte';
    import { screenType } from '$lib/store/store';

let fonts = ['martina-plantijn', 'nb-television-3d', 'nb-architekt', 'nb-television'];
let text = 'AUFBAU';
let lastFontChange = Date.now();
let lastHighlightChange = Date.now();
let currentFont = 0;
const fontChangeInterval = 100; // Interval for changing font
const highlightInterval = 400; // Interval for highlighting text

onMount(() => {
    const h1Element = document.querySelector('section h1');

    window.addEventListener('mousemove', () => {
        // Change font
        if (Date.now() - lastFontChange > fontChangeInterval) {
            lastFontChange = Date.now();
            currentFont = (currentFont + 1) % fonts.length;
            h1Element.style.fontFamily = fonts[currentFont];
        }

        // Highlight text
        if (Date.now() - lastHighlightChange > highlightInterval) {
            lastHighlightChange = Date.now();
            randomHighlight(h1Element);
        }
    });
});

function randomHighlight(h1Element) {
    let randomStart = Math.floor(Math.random() * text.length);
    let randomLength = Math.floor(Math.random() * (text.length - randomStart)) / 2;

    let highlightedText = '';
    for (let i = 0; i < text.length; i++) {
        if (i >= randomStart && i < randomStart + randomLength) {
            highlightedText += `<span class="highlight" style="font-size: 20vw;background:var(--background);color:var(--primary);padding:10px 0;">${text[i]}</span>`;
        } else {
            highlightedText += text[i];
        }
    }

    h1Element.innerHTML = highlightedText;
}
</script>

<body>
  <div class="fill">
    <h1 style="padding:10px;">D<span class="tmp">A</span>NIEL HUMPHRIES</h1>
    <p style="text-align:center;">Freelancer, open to Creative and{#if $screenType !=1}<br>{/if} technical Work with small clients.</p>
    <br>
    <p>graphics</p>
    <p>creative web engineering</p>
    <p>neuroscience, ML, mathematics</p>
    <br>
    <div class="links">
      <p>[</p>
      <a href="/daniel_humphries_cv.pdf">CV</a>
      <p>//</p>
      <a href="mailto: dan@aufbau.io">Email</a>
      <p>]</p>
    </div>
    <a href='/'><h1><span style="font-size: 32px; width: 100%;">↝</span></h1></a>
  </div>
</body>

<section>
	<h1>AUFBAU</h1>
</section>

<style>
  	section {
		padding: 0 0;
		height: 100%;
		width: 100%;
		overflow: hidden;
		display: flex;
		flex-flow: column nowrap;
		justify-content: center;

		align-items: center;
		text-align: center;

		overflow: none;
		user-select: none;
    
	}

	section h1 {
		font-size: 20vw;
		color: var(--background);
	}

  body {
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);

    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    height: 100vh;
    color: var(--primary);

  }

  .fill {
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    background: var(--background);
    border: solid 1px var(--primary);
    padding: 10px 20px;
    min-width: 400px;
  }

  .tmp {
    font-family:martina-plantijn;
    font-style: italic;
  }

  .links {
    display: flex;
    flex-direction: row;
    justify-content: center;
    align-items: center;
    gap: 10px;
  }

  body h1 {
    font-size: 20px;
    margin: 10px 2px 2px 2px;
    color: var(--primary);

    padding-bottom: 5px;
  }

  a {
    padding: 0 10px;
  }

  a:hover {
    text-underline-offset: 4px;
  }

  @media (max-width: 600px) {
    body, .fill {
      min-width: 90%;
      max-width: 90%;
    }
  }
</style>