<script>
    import { screenType } from '$lib/store/store';
    import Title from '$lib/components/site/title.svelte';
</script>

<Title />

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
      <a href="/daniel_humphries_cv.pdf">ME</a>
      <p>//</p>
      <!-- <a href="/daniel_humphries_cv.pdf">CV</a>
      <p>//</p> -->
      <a href="mailto: dan@aufbau.io">Email</a>
      <p>]</p>
    </div>
    <a href='/'><h1><span style="font-size: 32px; width: 100%;">↝</span></h1></a>
  </div>
</body>

<style>
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