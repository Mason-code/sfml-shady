void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord * 2.0 - iResolution.xy) / iResolution.y;
    
    float radius = 0.5;
    float d = length(uv) - radius; // formula
    
    d = smoothstep(0.1, 0.11, d); // cleans the circle
    
    fragColor = vec4(0.0,0.0, d,1.0);
}