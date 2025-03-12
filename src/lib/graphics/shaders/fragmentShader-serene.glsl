uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;
uniform bool isMobile;
uniform vec3 skyColor;
uniform vec3 sunColor;
uniform vec3 seaColor;
uniform vec3 mountainColor;
uniform vec3 themeColor;
uniform vec3 primaryColor;
uniform float routeTransition; // For smooth transitions between routes

varying vec2 vUv;

// Optimized hash function
float hash(float n) {
    return fract(sin(n) * 43758.5453);
}

// Simplified noise function
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    // Optimized smoothing
    f = f * f * (3.0 - 2.0 * f);
    float a = hash(i.x + i.y * 57.0);
    float b = hash(i.x + 1.0 + i.y * 57.0);
    return mix(a, b, f.x);
}

// Optimized FBM with fewer iterations
float fbm(vec2 p) {
    float f = 0.0;
    f += 0.5 * noise(p);
    p *= 2.0;
    f += 0.25 * noise(p);
    p *= 2.0;
    f += 0.125 * noise(p);
    return f;
}

// Optimized rotation matrix - precompute sin/cos
mat2 rotate2d(float angle) {
    float s = sin(angle);
    float c = cos(angle);
    return mat2(c, -s, s, c);
}

// Simplified distortion function
vec2 distort(vec2 p, vec2 center, float intensity) {
    vec2 dir = p - center;
    float dist = max(length(dir), 0.001); // Avoid division by zero
    float factor = intensity / (dist * dist);
    return p + dir * factor * smoothstep(1.0, 0.0, dist * 2.0);
}

// Optimized color transition function
vec3 transitionColor(vec3 from, vec3 to, float t) {
    // Simplified easing
    float ease = t < 0.5 ? 4.0 * t * t * t : 1.0 - pow(-2.0 * t + 2.0, 3.0) / 2.0;
    return mix(from, to, ease);
}

void main() {
    // Use vUv directly
    vec2 uv = vUv;
    
    // Aspect ratio correction
    float aspect = resolution.x / resolution.y;
    uv.x *= aspect;
    
    // Simplified time variable
    float t = time * 0.05;
    
    // Get interaction point (mouse on desktop, animated on mobile)
    vec2 interactionPoint;
    if (isMobile) {
        // Simplified mobile animation
        interactionPoint = vec2(
            0.5 + 0.3 * sin(t * 0.7),
            0.5 + 0.3 * cos(t * 0.5)
        );
    } else {
        // On desktop, use mouse position
        interactionPoint = mouse;
        interactionPoint.x *= aspect;
    }
    
    // Apply distortion with reduced calculations
    float distortionStrength = 0.05;
    vec2 distortedUV = distort(uv, interactionPoint, distortionStrength);
    
    // Simplified ripple effect
    float rippleDistance = length(uv - interactionPoint);
    vec2 rippleDir = normalize(uv - interactionPoint);
    float rippleStrength = 0.02 * sin(rippleDistance * 20.0 - t * 5.0) / (rippleDistance + 0.5);
    distortedUV += rippleDir * rippleStrength;
    
    // Simplified rotation
    if (rippleDistance < 0.8) { // Only apply rotation when close to interaction point
        float rotationAngle = 0.1 * sin(t) * (0.8 - rippleDistance);
        vec2 rotationUV = distortedUV - interactionPoint;
        rotationUV = rotate2d(rotationAngle) * rotationUV;
        distortedUV = rotationUV + interactionPoint;
    }
    
    // Color transitions - only calculate if needed
    vec3 transitionSkyColor = skyColor;
    vec3 transitionSunColor = sunColor;
    vec3 transitionSeaColor = seaColor;
    vec3 transitionMountainColor = mountainColor;
    
    if (routeTransition > 0.01) {
        // Simplified color transitions
        float transitionPulse = sin(routeTransition * 12.0) * (1.0 - routeTransition) * 0.3;
        
        // Optimized color transitions
        transitionSkyColor = transitionColor(skyColor, skyColor * vec3(1.3, 1.2, 1.1), routeTransition);
        transitionSunColor = transitionColor(sunColor, sunColor * vec3(1.4, 1.3, 0.9), routeTransition);
        transitionSeaColor = transitionColor(seaColor, seaColor * vec3(0.9, 1.3, 1.4), routeTransition);
        transitionMountainColor = transitionColor(mountainColor, mountainColor * vec3(1.2, 1.1, 1.3), routeTransition);
        
        // Add pulse
        transitionSkyColor += vec3(transitionPulse);
        transitionSunColor += vec3(transitionPulse);
        transitionSeaColor += vec3(transitionPulse);
        transitionMountainColor += vec3(transitionPulse);
    }
    
    // Background gradient
    vec3 color = mix(transitionSkyColor * 0.9, transitionSkyColor * 1.1, distortedUV.y);
    
    // Sun with simplified calculations
    float sunSize = 0.15;
    vec2 sunPos = vec2(aspect * 0.65, 0.7);
    sunPos += (interactionPoint - vec2(aspect * 0.5, 0.5)) * 0.05;
    
    float sunDist = length(distortedUV - sunPos);
    float sun = smoothstep(sunSize, sunSize - 0.05, sunDist);
    float sunGlow = smoothstep(sunSize + 0.4, sunSize, sunDist) * 0.5;
    
    // Add sun
    color = mix(color, transitionSunColor, sun * 0.8 + sunGlow * 0.5);
    
    // Horizon and landscape with fewer calculations
    float horizonHeight = 0.35 + (interactionPoint.y - 0.5) * 0.05;
    float horizonBlur = 0.1;
    
    // Simplified landscape
    float landHeight = horizonHeight;
    float landShape = 0.05 * fbm(vec2(distortedUV.x * 4.0, 0.5));
    float land = smoothstep(landHeight + landShape, landHeight + landShape + 0.01, distortedUV.y);
    
    // Simplified water
    float waterHeight = horizonHeight;
    float waterLine = smoothstep(waterHeight - 0.05, waterHeight + 0.05, distortedUV.y);
    
    // Simplified waves
    float waves = 0.02 * sin(distortedUV.x * 15.0 + t * 3.0) * smoothstep(0.0, 0.3, distortedUV.y);
    
    // Add landscape and water
    if (distortedUV.y > landHeight) {
        color = mix(color, transitionMountainColor, (1.0 - land) * 0.8);
    }
    if (distortedUV.y < waterHeight) {
        color = mix(color, transitionSeaColor, (1.0 - waterLine) * 0.8);
        
        // Simplified reflections
        float reflections = fbm(vec2(distortedUV.x * 20.0, distortedUV.y * 20.0 + t)) * 0.03;
        color += vec3(0.9) * reflections * (1.0 - waterLine);
    }
    
    // Color splash effect only during transitions
    if (routeTransition > 0.01 && routeTransition < 0.99) {
        float burstIntensity = sin(routeTransition * 6.28) * (1.0 - routeTransition) * routeTransition * 4.0;
        
        // Simplified burst color
        vec3 burstColor = vec3(
            0.8 + 0.4 * sin(uv.x * 5.0 + time),
            0.8 + 0.4 * sin(uv.y * 5.0 + time * 1.1),
            0.8 + 0.4 * sin((uv.x + uv.y) * 5.0 + time * 0.9)
        );
        
        // Simplified pattern
        float burstPattern = fbm(uv * 8.0 + vec2(sin(time * 0.2), cos(time * 0.2)));
        color = mix(color, burstColor, burstPattern * burstIntensity * 0.3);
    }
    
    // Simplified vignette
    float vignette = smoothstep(1.0, 0.4, length((uv - vec2(aspect * 0.5, 0.5)) * vec2(0.7, 1.0)));
    color = mix(color, color * 0.9, 1.0 - vignette);
    
    // Simplified color shift
    vec3 colorShift = vec3(
        0.02 * sin(interactionPoint.x * 3.14159),
        0.02 * sin(interactionPoint.y * 3.14159),
        0.02 * cos(interactionPoint.x * interactionPoint.y * 3.14159)
    );
    color += colorShift;
    
    // Theme blend
    color = mix(color, themeColor, 0.1);
    
    // Output
    gl_FragColor = vec4(color, 1.0);
} 