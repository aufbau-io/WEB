  precision highp float;
  varying vec2 vUv;
  uniform float time;
  uniform float aspectRatio;
  
  // float soften(float value) {
  //   // Non-linear scaling function to soften transitions
  //   return  value * (2.71828 + 2.71828 * value);
  // }

  
  void main() {
    float zoom = 1.0;
    float timescale = 0.00025;

    float time = time * 1000.0;

    vec2 adjustedPosition = (vUv - 0.5) / zoom + 0.5;
    adjustedPosition.x *= aspectRatio; // Adjust for aspect ratio

    // Define pastel colors directly in the shader
    // vec3 sunshade = vec3(1.0, 0.5882, 0.3098); // sunshade
    // vec3 primary = vec3(0.9, 0.4882, 0.3098);
    vec3 primary = vec3(1.0, 0.5882, 0.3098);
    vec3 pastel1 = vec3(1.0, 0.7137, 0.7569); // Pastel pink
    vec3 pastel2 = vec3(0.5961, 1.0, 0.5961); // Mint green
    vec3 pastel3 = vec3(0.9020, 0.9020, 0.9804); // Lavender

    // Adjust the center position
    vec2 center = vec2(0.5, 0.5);
    center.x *= aspectRatio;

    // Stabilize the band size
    // float bandSize = 0.1 + sin(time * timescale) * 0.025; 
    float bandSize = 0.075;
    float dist = length(adjustedPosition - center);
    float bandedDist = fract(dist / bandSize) * bandSize / dist * fract(dist / bandSize);

    // Smoother wave effect
    float wave = 2.71828 * timescale + -sin(bandedDist * 3.142 * 0.5 + (time * timescale));

    // Sample the noise texture
    // float noiseEffect = texture2D(uNoiseTexture, vUv).r;

    // // Create a high-frequency noise pattern
    float noisePattern = sin(dot(adjustedPosition, vec2(12.9898, 78.233)) * 45.0 + time * timescale)
                       + cos(dot(adjustedPosition, vec2(43.2321, 29.1234)) * 45.0 - time * timescale);
    float noiseEffect = abs(noisePattern);

    float range1 = step(0.33, noiseEffect);
    // float range2 = step(0.66, noiseEffect) * (1.0 - range1); // Apply only if range1 is not active
    // float range3 = 1.0 - step(0.66, noiseEffect); // Apply only if range2 is not active
    
    vec3 color = mix(primary, pastel1, range1 * -wave );
    color = mix(primary, color, wave * noiseEffect );

    gl_FragColor = vec4(color, 1.0);
  }