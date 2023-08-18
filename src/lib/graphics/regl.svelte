<script>
import { onMount, onDestroy } from 'svelte';
import { screenType } from '$lib/store/store';
import { page } from '$app/stores';

import regl from 'regl';
import { mat4 } from 'gl-matrix';

import vertexShader from './shaders/vertexShader.glsl';
import fragmentShader_aufbau from './shaders/fragmentShader-aufbau.glsl';
import fragmentShader_niels from './shaders/fragmentShader-niels.glsl';
import fragmentShader_sicovecas1 from './shaders/fragmentShader-sicovecas1.glsl';
import fragmentShader_sicovecas2 from './shaders/fragmentShader-sicovecas2.glsl';

let canvas;
let reglInstance;
let mouse = {x: 0.5, y: 0.5};
let dpr;
let drawFullScreenSquare = null;
let drawHalfScreenSquare = null;
let unsubscribe;

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

const colors_aufbau = {
    color1: colors.color1,
    color2: colors.color5,
    color3: colors.color9,
    color4: null
}

const colors_niels = {
    color1: colors.color1,
    color2: colors.color2,
    color3: colors.color6,
    color4: colors.color7,
}

const colors_sicovecas1 = {
    color1: colors.color4,
    color2: colors.color5,
    color3: colors.color5,
    color4: null
}

const colors_sicovecas2 = {
    color1: colors.color1,
    color2: colors.color2,
    color3: colors.color3,
    color4: null
}

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
    dpr = window.devicePixelRatio || 1;
    canvas.width = window.innerWidth * dpr;
    canvas.height = window.innerHeight * dpr;

    let aspectRatio = (canvas.width / dpr) / (canvas.height / dpr);

    // Let's use window height as our base scale reference
    // Decide on a reference height (like 800 pixels) and adjust the scale accordingly
    const baseHeight = 600;
    const scaleFactorHalf = (window.innerHeight / baseHeight);
    const scaleFactorFull = aspectRatio > 0.8 ? aspectRatio : 0.8 / aspectRatio;
    // const scaleFactorFull = scaleFactorHalf * 1.2

    fullSquare = [
        -1 * scaleFactorFull, -1 * scaleFactorFull,
        1 * scaleFactorFull, -1 * scaleFactorFull,
        1 * scaleFactorFull, 1 * scaleFactorFull,

        -1 * scaleFactorFull, -1 * scaleFactorFull,
        1 * scaleFactorFull, 1 * scaleFactorFull,
        -1 * scaleFactorFull, 1 * scaleFactorFull
    ];

    halfSquare = [
        -0.5 * scaleFactorHalf, -0.5 * scaleFactorHalf,
        0.5 * scaleFactorHalf, -0.5 * scaleFactorHalf,
        0.5 * scaleFactorHalf, 0.5 * scaleFactorHalf,

        -0.5 * scaleFactorHalf, -0.5 * scaleFactorHalf,
        0.5 * scaleFactorHalf, 0.5 * scaleFactorHalf,
        -0.5 * scaleFactorHalf, 0.5 * scaleFactorHalf
    ];

    mat4.ortho(projectionMatrix, -aspectRatio, aspectRatio, -1, 1, -1, 1);
    
}

function onDocumentMouseMove(event) {
    var clientX = event.clientX * dpr;
    var clientY = event.clientY * dpr;

    mouse.x = (clientX / (window.innerWidth * dpr)) * 2 - 1;
	mouse.y = -(clientY / (window.innerHeight * dpr)) * 2 + 1;
};


onMount(() => {
    setCanvasToFullScreen();
    reglInstance = regl(canvas);

    unsubscribe = page.subscribe(({ url }) => {
        if (reglInstance) {
            updateDrawCommands(url.pathname);
        }
    });

    window.addEventListener('mousemove', onDocumentMouseMove);
    window.addEventListener('resize', () => {
        setCanvasToFullScreen()
        updateDrawCommands($page.url.pathname)
    ;});
    reglInstance.frame(({ tick }) => {
        reglInstance.clear({ color: [0, 0, 0, 1] });
        if (drawFullScreenSquare) {
            drawFullScreenSquare();
        }
        if (drawHalfScreenSquare) {
            drawHalfScreenSquare();
        }
    });

    return () => {
        window.removeEventListener('mousemove', onDocumentMouseMove);
        window.removeEventListener('resize', setCanvasToFullScreen);
        unsubscribe && unsubscribe();
    };
});

function updateDrawCommands(pathname) {
     switch (pathname) {
         case '/':
             drawFullScreenSquare = createDrawCommand(fragmentShader_aufbau, vertexShader, fullSquare, uvFullSquare, colors_aufbau);
             drawHalfScreenSquare = createDrawCommand(fragmentShader_aufbau, vertexShader, halfSquare, uvHalfSquare, colors_aufbau);
             break;
         case '/niels':
             drawFullScreenSquare = createDrawCommand(fragmentShader_niels, vertexShader, fullSquare, uvFullSquare, colors_niels);
             drawHalfScreenSquare = null;
             break;
         case '/sicovecas':
             drawFullScreenSquare = createDrawCommand(fragmentShader_sicovecas1, vertexShader, fullSquare, uvFullSquare, colors_sicovecas1);
             drawHalfScreenSquare = createDrawCommand(fragmentShader_sicovecas2, vertexShader, halfSquare, uvHalfSquare, colors_sicovecas2);
             break;
     }
 }


function createDrawCommand(frag, vert, positions, uvCoords, assigned_colors) {
    return reglInstance({
        frag: frag,
        vert: vert,
        attributes: {
            position: positions,
            uv: uvCoords,
        },
        uniforms: {
            projectionMatrix: () => projectionMatrix,
            modelViewMatrix: () => modelViewMatrix,
            color1: assigned_colors.color1,
            color2: assigned_colors.color2,
            color3: assigned_colors.color3,
            color4: assigned_colors.color4 ? assigned_colors.color4 : [0, 0, 0],
            time: ({ time }) => time,
            mouse: ({ time }) => {
                
                if ($screenType == 1 && $page.url.pathname == '/') {
                    return [Math.cos(time), Math.tan(time * 0.1)];
                }
                
                if ($screenType == 1 && $page.url.pathname == '/niels') {
                    return [time, time * 0.1];
                }
                
                return [mouse.x, mouse.y];
            }
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
