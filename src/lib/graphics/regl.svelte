<script>
import { onMount, onDestroy } from 'svelte';
import regl from 'regl';
import { mat4 } from 'gl-matrix';

import vertexShader from './shaders/vertexShader.glsl';
import fragmentShader_aufbau from './shaders/fragmentShader-aufbau.glsl';

let canvas;
let reglInstance;

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

let projectionMatrix = mat4.create();
let modelViewMatrix = mat4.create();

function setCanvasToFullScreen() {
    const dpr = window.devicePixelRatio || 1;
	canvas.width = window.innerWidth * dpr;
	canvas.height = window.innerHeight * dpr;

	let aspectRatio = (canvas.width / dpr) / (canvas.height / dpr);
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
}

function onDocumentMouseMove(event) {
    var clientX = event.clientX;
    var clientY = event.clientY;

    mouse.x = (clientX / window.innerWidth) * 2 - 1;
	mouse.y = -(clientY / window.innerHeight) * 2 + 1;
};

onMount(() => {
    setCanvasToFullScreen();
    reglInstance = regl(canvas);

    let drawFullScreenSquare = createDrawCommand(fullSquare, uvFullSquare);
    let drawHalfScreenSquare = createDrawCommand(halfSquare, uvHalfSquare);

    window.addEventListener('mousemove', onDocumentMouseMove);
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

    reglInstance.frame(({ tick }) => {
        reglInstance.clear({ color: [0, 0, 0, 1] });
        drawFullScreenSquare();
        drawHalfScreenSquare();
    });

    return () => {
        window.removeEventListener('resize', setCanvasToFullScreen);
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
    width: 100%;
    height: 100%;
    display: block;
	z-index: -1;
	}
</style>
