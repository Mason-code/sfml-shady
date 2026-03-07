uniform vec2 iResolution;
uniform float iTime;
uniform ivec2 iMouse_xy;
uniform ivec2 iMouse_zw;

vec4 iMouse = vec4(iMouse_xy, iMouse_zw);


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{    
    vec2 uv = (fragCoord * 2.0 - iResolution.xy) / iResolution.y; // shift and alter the pixel coords
    
    vec2 r = vec2(0.5, 0.2); // rectangle length and width

    float d = length(vec2(max(abs(uv)-r,0.0))); //box formula
    
    d = smoothstep(0.1, 0.11, d); // cleans the box
    
    fragColor = vec4(0.0,0.0, d,1.0);	
    //fragColor = vec4(color, 1);
}

void main()
{
    vec4 col;
    mainImage(col, gl_FragCoord.xy);  // call it, filling col
    gl_FragColor = col;               // output it
}
