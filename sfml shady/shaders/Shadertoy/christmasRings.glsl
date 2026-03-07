void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord * 2.0 - iResolution.xy) / iResolution.y;
    float d = length(uv);
    
    vec3 col = vec3(0.0, 1.5, 0.0);
    
    d = sin(d * 8.0 + iTime) / 8.0;

    d = abs(d);
    d = 0.02 / d;
    
    col = vec3(d, 1.0 - d, 0.0);
    
    
    fragColor = vec4(col,1.0);
}