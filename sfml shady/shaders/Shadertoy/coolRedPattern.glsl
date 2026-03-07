vec3 palette( in float t)
{
     vec3 a = vec3(1.0, 0.0, 0.0);
     vec3 b = vec3(2.0, 0.0, 0.0);
     vec3 c = vec3(3.000, 0.0, 0.0);
     vec3 d = vec3(1.0, 0.0, 0.0);
    
    return a + b*cos( 6.283185*(c*t+d) );
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord * 2.0 - iResolution.xy) / iResolution.y;
    vec2 uv2 = uv;
    vec3 finalColor = vec3(0.0);
    
    for (float i = 0.0; i < 4.0; i++){
        uv = fract(1.5*uv)- 0.5;
        float d = length(uv) * exp(-length(uv2)*.7);
        vec3 col = palette(length(uv) + i*0.4 + iTime*.4);
        d = sin(d * 8.0 + iTime) / 8.0;
        d = abs(d);
        d = pow(0.01 / d,1.2);
        finalColor += col * d;
    }
    fragColor = vec4(finalColor,1.0);
}