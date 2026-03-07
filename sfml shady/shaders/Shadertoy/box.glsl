void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord * 2.0 - iResolution.xy) / iResolution.y; // shift and alter the pixel coords
    
    vec2 r = vec2(0.5, 0.2); // rectangle length and width

    float d = length(vec2(max(abs(uv)-r,0.0))); //box formula
    
    d = smoothstep(0.1, 0.11, d); // cleans the box
    
    fragColor = vec4(0.0,0.0, d,1.0);
}