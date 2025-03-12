uniform float time;
uniform vec2 resolution;
uniform vec3 skyColor;
uniform vec3 sunColor;
uniform vec3 seaColor;
uniform vec3 mountainColor;
uniform vec3 themeColor;
uniform vec3 primaryColor;

varying vec2 vUv;

// Simple hash function for minimal noise
float hash(float n) {
    return fract(sin(n) * 43758.5453);
}

// Simple noise function
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    f = f * f * (3.0 - 2.0 * f);
    return mix(hash(i.x + i.y * 57.0), hash(i.x + 1.0 + i.y * 57.0), f.x);
}

void main() {
    // Use vUv directly
    vec2 uv = vUv;
    
    // Aspect ratio correction
    float aspect = resolution.x / resolution.y;
    uv.x *= aspect;
    
    // Simple time variable
    float t = time * 0.1;
    
    // Sky gradient - more vibrant
    vec3 color = mix(skyColor * 0.7, skyColor * 1.3, uv.y);
    
    // Enhanced sun - larger and more vibrant
    float sunSize = 0.2; // Larger sun
    vec2 sunPos = vec2(aspect * 0.5, 0.7);
    float sunDist = length(uv - sunPos);
    float sun = smoothstep(sunSize, sunSize - 0.1, sunDist);
    
    // Enhanced sun glow - larger and more intense
    float sunGlow = smoothstep(sunSize + 0.4, sunSize, sunDist) * 0.8;
    
    // Simple sun rays
    float rays = 0.0;
    for (float i = 0.0; i < 6.0; i++) {
        float angle = i / 6.0 * 3.14159 * 2.0 + t;
        vec2 rayDir = vec2(cos(angle), sin(angle));
        rays += smoothstep(0.05, 0.0, abs(dot(normalize(uv - sunPos), rayDir) - 1.0)) * 0.2;
    }
    
    // Add enhanced sun to scene
    color = mix(color, sunColor * 1.2, sun + sunGlow * 0.7 + rays);
    
    // Enhanced islands/mountains - more defined
    float islandHeight = 0.3;
    float islandShape = 0.08 * sin(uv.x * 8.0) + 0.05 * sin(uv.x * 16.0 + t);
    float islands = smoothstep(islandHeight + islandShape, islandHeight + islandShape + 0.01, uv.y);
    
    // Enhanced sea - more vibrant and dynamic waves
    float seaHeight = 0.3;
    float seaLine = smoothstep(seaHeight - 0.05, seaHeight + 0.05, uv.y);
    float waves = 0.04 * sin(uv.x * 15.0 + t * 3.0) * smoothstep(0.0, 0.3, uv.y);
    waves += 0.02 * sin(uv.x * 30.0 + t * 5.0) * smoothstep(0.0, 0.3, uv.y); // Add smaller waves
    
    // Add enhanced islands and sea to scene
    color = mix(color, mountainColor * 1.2, (1.0 - islands) * step(islandHeight, uv.y));
    color = mix(color, seaColor * 1.3 + waves, (1.0 - seaLine) * step(uv.y, seaHeight));
    
    // Add sea highlights
    float highlights = smoothstep(0.4, 0.6, waves * 10.0) * 0.3;
    color += vec3(1.0, 1.0, 0.8) * highlights * (1.0 - seaLine) * step(uv.y, seaHeight);
    
    // Simple vignette - less intense
    float vignette = smoothstep(1.0, 0.6, length(uv - vec2(aspect * 0.5, 0.5)));
    color *= vignette * 0.3 + 0.7; // Less darkening at edges
    
    // Less theme color blending for more vibrant colors
    color = mix(color, themeColor, 0.05);
    
    // Output with full opacity
    gl_FragColor = vec4(color, 1.0);
} 