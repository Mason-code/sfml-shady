vec3 palette( in float t)
{
     vec3 a = vec3(-2.712, -0.250, 1.428);
     vec3 b = vec3(-1.952, 3.138, 0.848);
     vec3 c = vec3(-2.923, -2.563, 6.157);
     vec3 d = vec3(-0.532, -1.732, -1.413);
    
    return a + b*cos( 6.283185*(c*t+d) );
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord * 2.0 - iResolution.xy) / iResolution.y;
    vec2 uv2 = uv;
    vec3 finalColor = vec3(0.0);
    
    for (float i = 0.0; i < 1.0; i++){
        uv = fract(22.0*uv)- 0.5;
        float d = length(uv) * exp(-length(uv2));
        vec3 col = palette(length(uv2) + i*0.4 + iTime*.4);
        d = sin(d * 8.0 + iTime) / 8.0;
        d = abs(d);
        d = pow(0.05 / d,1.6);
        finalColor += exp(col* d)/2.0;
    }
    fragColor = vec4(finalColor,1.0);
}