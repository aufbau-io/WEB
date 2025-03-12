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
    return f; // Reduced to 2 iterations for better performance
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
    // Simple linear interpolation for better performance
    return mix(from, to, t);
}

// Gentle floating particles function
float gentleParticles(vec2 uv, float time) {
    float particles = 0.0;
    
    // Create 6 particles with different speeds and positions
    for (int i = 0; i < 6; i++) {
        float idx = float(i) + 1.0;
        float speed = 0.2 + 0.1 * hash(idx);
        float size = 0.003 + 0.002 * hash(idx * 2.1);
        
        // Unique movement pattern for each particle
        vec2 particlePos = vec2(
            0.2 + 0.6 * hash(idx * 3.7) + 0.1 * sin(time * speed + idx * 2.0),
            0.2 + 0.6 * hash(idx * 2.3) + 0.1 * cos(time * speed * 0.7 + idx)
        );
        
        // Gentle pulsing
        float pulse = 0.5 + 0.5 * sin(time * 0.5 + idx);
        
        // Calculate particle
        float dist = length(uv - particlePos);
        particles += smoothstep(size * (0.8 + 0.2 * pulse), 0.0, dist) * 0.5;
    }
    
    return particles;
}

void main() {
    // Use vUv directly
    vec2 uv = vUv;
    
    // Aspect ratio correction
    float aspect = max(resolution.x / resolution.y, 0.5); // Prevent extreme values
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
    vec2 rippleDir = normalize(uv - interactionPoint + vec2(0.0001)); // Prevent NaN
    float rippleStrength = 0.02 * sin(rippleDistance * 20.0 - t * 5.0) / (rippleDistance + 0.5);
    distortedUV += rippleDir * rippleStrength;
    
    // Simplified rotation - only apply when needed
    if (rippleDistance < 0.8) {
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
    
    // Clamp routeTransition to prevent issues
    float safeRouteTransition = clamp(routeTransition, 0.0, 1.0);
    
    if (safeRouteTransition > 0.01) {
        // Simplified color transitions
        float transitionPulse = sin(safeRouteTransition * 12.0) * (1.0 - safeRouteTransition) * 0.3;
        
        // Optimized color transitions
        transitionSkyColor = transitionColor(skyColor, skyColor * vec3(1.3, 1.2, 1.1), safeRouteTransition);
        transitionSunColor = transitionColor(sunColor, sunColor * vec3(1.4, 1.3, 0.9), safeRouteTransition);
        transitionSeaColor = transitionColor(seaColor, seaColor * vec3(0.9, 1.3, 1.4), safeRouteTransition);
        transitionMountainColor = transitionColor(mountainColor, mountainColor * vec3(1.2, 1.1, 1.3), safeRouteTransition);
        
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
    
    // Simplified landscape
    float landHeight = horizonHeight;
    float landShape = 0.05 * fbm(vec2(distortedUV.x * 4.0, 0.5));
    float land = smoothstep(landHeight + landShape, landHeight + landShape + 0.01, distortedUV.y);
    
    // Simplified water
    float waterHeight = horizonHeight;
    float waterLine = smoothstep(waterHeight - 0.05, waterHeight + 0.05, distortedUV.y);
    
    // Add islands on the sea
    float islands = 0.0;
    if (distortedUV.y < waterHeight) {
        // Create several small islands with different sizes and positions
        for (int i = 0; i < 4; i++) {
            float idx = float(i) + 1.0;
            
            // Island position - spread across the water
            float islandPosX = 0.2 + 0.6 * hash(idx * 3.7);
            float islandDistance = waterHeight - 0.05 - 0.15 * hash(idx * 2.3); // Further from shore
            
            // Island shape
            float islandSize = 0.03 + 0.02 * hash(idx * 1.5);
            float islandShape = islandSize * (0.8 + 0.4 * fbm(vec2(distortedUV.x * 10.0 + idx, distortedUV.y * 10.0)));
            
            // Calculate island
            vec2 islandCenter = vec2(islandPosX * aspect, islandDistance);
            float dist = length(distortedUV - islandCenter);
            
            // Add gentle movement to islands
            dist += 0.005 * sin(time * 0.5 + idx * 2.0 + distortedUV.x * 5.0);
            
            // Island shape with smoother edges
            float island = smoothstep(islandShape, islandShape - 0.01, dist);
            
            // Island color variation - slightly different for each island
            vec3 islandColor = transitionMountainColor * (0.9 + 0.2 * hash(idx * 7.3));
            
            // Add island to the scene
            color = mix(color, islandColor, island * 0.8 * (1.0 - waterLine));
            
            // Add reflection below island
            float reflectionStrength = 0.2 * (1.0 - waterLine);
            float reflectionDist = length(vec2(distortedUV.x, waterHeight + (waterHeight - distortedUV.y) * 0.3) - islandCenter);
            float reflection = smoothstep(islandShape * 1.5, islandShape * 1.2, reflectionDist);
            color = mix(color, islandColor * 0.6, reflection * reflectionStrength * (1.0 - waterLine));
            
            // Add island to total
            islands += island;
        }
    }
    
    // Add landscape and water with simplified logic
    if (distortedUV.y > landHeight) {
        color = mix(color, transitionMountainColor, (1.0 - land) * 0.8);
    }
    if (distortedUV.y < waterHeight) {
        // Only apply sea color where there are no islands
        color = mix(color, transitionSeaColor, (1.0 - waterLine) * 0.8 * (1.0 - islands));
        
        // Simplified reflections - less visible where islands are
        float reflections = fbm(vec2(distortedUV.x * 20.0, distortedUV.y * 20.0 + t)) * 0.03;
        color += vec3(0.9) * reflections * (1.0 - waterLine) * (1.0 - islands * 0.8);
    }
    
    // Color splash effect only during transitions - simplified
    if (safeRouteTransition > 0.01 && safeRouteTransition < 0.99) {
        float burstIntensity = sin(safeRouteTransition * 6.28) * (1.0 - safeRouteTransition) * safeRouteTransition * 4.0;
        
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
    
    // Add gentle floating particles (like fireflies or dust motes)
    float particles = gentleParticles(uv, time * 10.0);
    
    // Create a warm, gentle glow for the particles
    vec3 particleColor = mix(
        vec3(1.0, 0.95, 0.8),  // Warm yellow
        vec3(0.9, 0.95, 1.0),  // Cool blue
        sin(time * 0.1) * 0.5 + 0.5
    );
    
    // Add particles with subtle glow
    color += particleColor * particles;
    
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
    
    // Ensure valid color output
    color = clamp(color, 0.0, 1.0);
    
    // Output
    gl_FragColor = vec4(color, 1.0);
} 