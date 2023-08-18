<script>
import { onMount, onDestroy } from 'svelte';
import regl from 'regl';
import { mat4 } from 'gl-matrix';

import vertexShader from './shaders/vertexShader.glsl';
import fragmentShader_aufbau from './shaders/fragmentShader-aufbau.glsl';

import blitFragShader from './util-shaders/blit.frag.glsl';
import quadVertShader from './util-shaders/quad.vert.glsl';

let canvas;
let reglInstance;
let msaaFramebuffer;

const colors = {
    color1: [208/255, 208/255, 208/255],
    color2: [187/255, 69/255, 0],
    color3: [218/255, 170/255, 85/255],
    color4: [0, 105/255, 148/255],
    color5: [80/255, 153/255, 180/255],
    color6: [0, 0, 255/255],
    color7: [0, 255/255, 0],
    color9: [143/255, 189/255, 90/255]
};

let fullSquare, halfSquare;

const uvFullSquare = [
    0.25, 0.25,
    0.75, 0.25,
    0.75, 0.75,
    0.25, 0.25,
    0.75, 0.75,
    0.25, 0.75
];

const uvHalfSquare = [
    0, 0,
    1, 0,
    1, 1,
    0, 0,
    1, 1,
    0, 1
];

const fullscreenQuad = [
  -1, -1,
   1, -1,
  -1,  1,
  -1,  1,
   1, -1,
   1,  1
];

let projectionMatrix = mat4.create();
let modelViewMatrix = mat4.create();

function setCanvasToFullScreen() {
	canvas.width = window.innerWidth;
	canvas.height = window.innerHeight;

	let aspectRatio = canvas.width / canvas.height;
	const scaleFactor = aspectRatio > 1 ? aspectRatio : 1 / aspectRatio;

	fullSquare = [
	    -1 * scaleFactor, -1 * scaleFactor,
	    1 * scaleFactor, -1 * scaleFactor,
	    1 * scaleFactor, 1 * scaleFactor,
	
	    -1 * scaleFactor, -1 * scaleFactor,
	    1 * scaleFactor, 1 * scaleFactor,
	    -1 * scaleFactor, 1 * scaleFactor
	];

    halfSquare = [
	    -0.5 * scaleFactor, -0.5 * scaleFactor,
	    0.5 * scaleFactor, -0.5 * scaleFactor,
	    0.5 * scaleFactor, 0.5 * scaleFactor,
	
	    -0.5 * scaleFactor, -0.5 * scaleFactor,
	    0.5 * scaleFactor, 0.5 * scaleFactor,
	    -0.5 * scaleFactor, 0.5 * scaleFactor
	];

    mat4.ortho(projectionMatrix, -aspectRatio, aspectRatio, -1, 1, -1, 1);
    
    if (msaaFramebuffer) {
        msaaFramebuffer.resize(canvas.width, canvas.height);
    }

    return;
}

onMount(() => {
    setCanvasToFullScreen();
    reglInstance = regl(canvas);

    msaaFramebuffer = reglInstance.framebuffer({
        width: canvas.width,
        height: canvas.height,
        color: reglInstance.texture({
            width: canvas.width,
            height: canvas.height,
            type: 'uint8',
            format: 'rgba'
        }),
        depth: true, // This might internally create a depth renderbuffer attachment.
        stencil: false,
        samples: 4
    });

    let drawFullScreenSquare = createDrawCommand(fullSquare, uvFullSquare);
    let drawHalfScreenSquare = createDrawCommand(halfSquare, uvHalfSquare);

    window.addEventListener('resize', () => {
        setCanvasToFullScreen();
        drawFullScreenSquare = createDrawCommand(fullSquare, uvFullSquare);
        drawHalfScreenSquare = createDrawCommand(halfSquare, uvHalfSquare);
    });

    function createDrawCommand(positions, uvCoords) {
        return reglInstance({
            frag: fragmentShader_aufbau,
            vert: vertexShader,
            attributes: {
                position: positions,
                uv: uvCoords,
            },
            uniforms: {
                projectionMatrix: () => projectionMatrix,
                modelViewMatrix: () => modelViewMatrix,
                color1: colors.color1,
                color2: colors.color5,
                color3: colors.color9,
                time: ({ time }) => time,
                mouse: [0.5, 0.5], // Center of the canvas. You can later update it with actual mouse coordinates.
            },
            viewport: {
                x: 0,
                y: 0,
                width: () => canvas.width,
                height: () => canvas.height
            },
            depth: {
                enable: false
            },
            count: 6
        });
    }

    const drawBlit = reglInstance({
        frag: blitFragShader,
        vert: quadVertShader,
        attributes: {
            position: fullscreenQuad,
        },
        uniforms: {
            sourceTexture: reglInstance.prop('srcTexture')
        },
        count: 6
        });


    const frameLoop = reglInstance.frame(({ tick }) => {
        // Clear the MSAA framebuffer
        reglInstance.clear({ color: [0, 0, 0, 1], framebuffer: msaaFramebuffer });

        // Render to the MSAA framebuffer
        reglInstance({ framebuffer: msaaFramebuffer })(() => {
            drawFullScreenSquare();
            drawHalfScreenSquare();
        });

        drawBlit({ srcTexture: msaaFramebuffer.color[0] });
    });


    return () => {
        window.removeEventListener('resize', setCanvasToFullScreen);
        frameLoop.cancel();
    };
});

onDestroy(() => {
    reglInstance && reglInstance.destroy();
});

</script>

<canvas bind:this={canvas}></canvas>


<style>
	canvas {
		position: absolute;
		z-index: -1;
	}
</style>
