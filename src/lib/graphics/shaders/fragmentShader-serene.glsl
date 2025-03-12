uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;
uniform vec3 skyColor;
uniform vec3 sunColor;
uniform vec3 seaColor;
uniform vec3 mountainColor;
uniform vec3 cityColor;
uniform vec3 accentColor;
uniform vec3 themeColor;
uniform vec3 primaryColor;

// Noise functions
float hash(float n) {
    return fract(sin(n) * 43758.5453);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    f = f * f * (3.0 - 2.0 * f);
    float n = i.x + i.y * 57.0;
    return mix(
        mix(hash(n), hash(n + 1.0), f.x),
        mix(hash(n + 57.0), hash(n + 58.0), f.x),
        f.y
    );
}

// FBM (Fractal Brownian Motion)
float fbm(vec2 p) {
    float f = 0.0;
    float amp = 0.5;
    for (int i = 0; i < 6; i++) {
        f += amp * noise(p);
        p *= 2.0;
        amp *= 0.5;
    }
    return f;
}

// Soft light blend mode
vec3 blendSoftLight(vec3 base, vec3 blend) {
    return mix(
        sqrt(base) * (2.0 * blend - 1.0) + 2.0 * base * (1.0 - blend),
        2.0 * base * blend + base * base * (1.0 - 2.0 * blend),
        step(0.5, base)
    );
}

void main() {
    // Normalized coordinates
    vec2 uv = gl_FragCoord.xy / resolution.xy;
    
    // Aspect ratio correction
    float aspect = resolution.x / resolution.y;
    uv.x *= aspect;
    
    // Center coordinates
    vec2 center = vec2(aspect * 0.5, 0.5);
    
    // Mouse influence
    vec2 mousePos = vec2(mouse.x * aspect, mouse.y);
    float mouseInfluence = smoothstep(0.5, 0.0, length(uv - mousePos)) * 0.2;
    
    // Time variables
    float t = time * 0.1;
    
    // Sky gradient
    float skyGradient = smoothstep(0.0, 1.0, uv.y);
    vec3 sky = mix(skyColor * 0.8, skyColor * 1.2, skyGradient);
    
    // Sun
    float sunSize = 0.15 + sin(t) * 0.02;
    vec2 sunPos = vec2(aspect * 0.5 + sin(t * 0.5) * 0.2, 0.7 + cos(t * 0.3) * 0.1);
    float sunDist = length(uv - sunPos);
    float sunMask = smoothstep(sunSize, sunSize - 0.1, sunDist);
    vec3 sun = sunColor * sunMask;
    
    // Sun glow
    float sunGlow = smoothstep(sunSize + 0.4, sunSize, sunDist) * 0.5;
    sun += sunColor * 0.5 * sunGlow;
    
    // Sun rays
    float rayStrength = 0.04 + sin(t) * 0.01;
    float rays = 0.0;
    for (float i = 0.0; i < 16.0; i++) {
        float angle = i / 16.0 * 6.28 + t * 0.2;
        vec2 rayDir = vec2(cos(angle), sin(angle));
        rays += smoothstep(0.05, 0.0, abs(dot(normalize(uv - sunPos), rayDir) - 1.0)) * rayStrength;
    }
    sun += sunColor * rays * smoothstep(sunSize + 0.2, sunSize, sunDist);
    
    // Mountains
    float mountainHeight = 0.4;
    float mountainLine = 0.3;
    
    // First mountain range
    float mountain1 = fbm(vec2(uv.x * 3.0, t * 0.1)) * 0.25;
    float mountain1Mask = smoothstep(mountainLine + mountain1, mountainLine + mountain1 + 0.01, uv.y);
    
    // Second mountain range
    float mountain2 = fbm(vec2(uv.x * 4.0 + 10.0, t * 0.05)) * 0.2;
    float mountain2Mask = smoothstep(mountainLine - 0.1 + mountain2, mountainLine - 0.1 + mountain2 + 0.01, uv.y);
    
    // Mountain details
    float mountainDetail = fbm(vec2(uv.x * 20.0, uv.y * 20.0)) * 0.05;
    
    // Combine mountains
    vec3 mountains = mix(mountainColor, mountainColor * 0.7, mountain1Mask);
    mountains = mix(mountains, mountainColor * 0.5, mountain2Mask);
    
    // Add snow caps
    float snowCaps = smoothstep(0.6, 0.7, fbm(vec2(uv.x * 5.0, uv.y * 50.0)));
    mountains = mix(mountains, vec3(1.0, 1.0, 1.0), snowCaps * (1.0 - mountain1Mask) * (1.0 - mountain2Mask) * step(mountainLine, uv.y) * 0.5);
    
    // Sea
    float seaHeight = 0.3;
    float seaLine = smoothstep(seaHeight - 0.05, seaHeight + 0.05, uv.y);
    float waves = fbm(vec2(uv.x * 8.0, uv.y * 25.0 + t * 0.3)) * 0.04;
    vec3 sea = mix(seaColor * 0.7, seaColor * 1.3, waves + seaLine);
    
    // Add wave highlights
    float highlights = smoothstep(0.4, 0.6, waves * 10.0) * 0.3;
    sea += accentColor * highlights * smoothstep(0.1, 0.3, uv.y);
    
    // City silhouette
    float cityHeight = 0.3;
    float cityDetail = fbm(vec2(uv.x * 25.0, 0.0)) * 0.15;
    float cityMask = smoothstep(cityHeight + cityDetail, cityHeight + cityDetail + 0.01, uv.y);
    
    // Add some buildings
    float buildings = 0.0;
    for (float i = 0.0; i < 20.0; i++) {
        float buildingX = fract(i / 20.0 + 0.5);
        float buildingWidth = 0.01 + 0.02 * hash(i);
        float buildingHeight = 0.05 + 0.1 * hash(i + 10.0);
        if (abs(uv.x - buildingX) < buildingWidth && uv.y < cityHeight + buildingHeight) {
            buildings = 1.0;
        }
    }
    
    vec3 city = mix(cityColor * 0.8, cityColor * 1.2, cityMask);
    city = mix(city, cityColor * 1.5, buildings * (1.0 - cityMask) * step(uv.y, cityHeight));
    
    // City lights
    float lights = fbm(vec2(uv.x * 40.0, uv.y * 40.0)) * cityMask;
    lights = smoothstep(0.7, 1.0, lights) * smoothstep(0.0, 0.3, uv.y);
    city += accentColor * lights * (0.5 + 0.5 * sin(time * 0.5));
    
    // Combine all elements
    vec3 finalColor = sky;
    finalColor = mix(finalColor, mountains, (1.0 - mountain1Mask) * (1.0 - mountain2Mask) * step(mountainLine, uv.y));
    finalColor = mix(finalColor, sea, (1.0 - seaLine) * step(uv.y, seaHeight));
    finalColor = mix(finalColor, city, (1.0 - cityMask) * step(uv.y, cityHeight));
    finalColor += sun;
    
    // Add subtle noise texture
    float noise = fbm(uv * 10.0 + t) * 0.03;
    finalColor += noise;
    
    // Blend with theme color
    finalColor = blendSoftLight(finalColor, themeColor);
    
    // Mouse interaction
    finalColor = mix(finalColor, accentColor, mouseInfluence);
    
    // Vignette effect
    float vignette = smoothstep(1.0, 0.3, length(uv - center));
    finalColor *= vignette * 0.5 + 0.5;
    
    // Output with transparency for gallery feel
    gl_FragColor = vec4(finalColor, 1.0);
} 