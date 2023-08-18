<script>
    import { onMount, onDestroy } from 'svelte';
    import regl from 'regl';
    import { mat4 } from 'gl-matrix';
    
    let canvas; // reference to the canvas element
    let reglInstance;
    
    // Full screen square
    const fullSquare = [
      -1, -1,
      1, -1,
      1, 1,
      
      -1, -1,
      1, 1,
      -1, 1
    ];
    
    // Half screen square
    const halfSquare = [
      -0.5, -0.5,
      0.5, -0.5,
      0.5, 0.5,
      
      -0.5, -0.5,
      0.5, 0.5,
      -0.5, 0.5
    ];
    
    let projectionMatrix = mat4.create();
    let modelViewMatrix = mat4.create();
    
    function setCanvasToFullScreen() {
        canvas.width = window.innerWidth;
        canvas.height = window.innerHeight;
    
        // Update the orthographic projection
        let aspectRatio = canvas.width / canvas.height;
        mat4.ortho(projectionMatrix, -aspectRatio, aspectRatio, -1, 1, -1, 1);
        
    }
    
    onMount(() => {
        setCanvasToFullScreen();
        window.addEventListener('resize', setCanvasToFullScreen);
    
        reglInstance = regl(canvas);
    
        const drawFullScreenSquare = createDrawCommand(fullSquare);
        const drawHalfScreenSquare = createDrawCommand(halfSquare);
    
        function createDrawCommand(positions) {
            return reglInstance({
                frag: `
                    precision mediump float;
                    uniform vec4 color;
                    void main() {
                        gl_FragColor = color;
                    }`,
                vert: `
                    precision mediump float;
                    attribute vec2 position;
                    uniform float angle;
                    uniform float direction;
                    uniform mat4 projectionMatrix;
                    uniform mat4 modelViewMatrix;
                    void main() {
                        vec2 rotatedPosition = vec2(
                        cos(angle * direction) * position.x + sin(angle * direction) * position.y,
                        -sin(angle * direction) * position.x + cos(angle * direction) * position.y
                    );
                    vec4 mvPosition = vec4(rotatedPosition, 0.0, 1.0) * modelViewMatrix;
                    gl_Position = mvPosition * projectionMatrix;
                }`,
                attributes: {
                    position: positions
                },
                uniforms: {
                    projectionMatrix: () => projectionMatrix,
                    modelViewMatrix: () => modelViewMatrix,
                    color: reglInstance.prop('color'),
                    direction: reglInstance.prop('direction'),
                    angle: ({ tick }) => 0.01 * tick
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
    
        const frameLoop = reglInstance.frame(({ tick }) => {
            reglInstance.clear({ color: [0, 0, 0, 1] });
    
            let colorFullScreen = [
                Math.sin(0.02 * (0.001 * tick)),
                Math.cos(0.02 * (0.02 * tick)),
                Math.sin(0.02 * (0.3 * tick)),
                1
            ];
            
            let colorHalfScreen = [
                Math.cos(0.02 * (0.001 * tick)),
                Math.sin(0.02 * (0.02 * tick)),
                Math.cos(0.02 * (0.3 * tick)),
                1
            ];
    
            drawFullScreenSquare({ color: colorFullScreen, direction: 1.0 });
            drawHalfScreenSquare({ color: colorHalfScreen, direction: -1.0 });
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
    