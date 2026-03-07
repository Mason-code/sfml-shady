uniform vec2 iResolution;
uniform float iTime;
uniform ivec2 iMouse_xy;
uniform ivec2 iMouse_zw;

vec4 iMouse = vec4(iMouse_xy, iMouse_zw);

float sdSphere( vec3 p, float r )
{
  return length(p) - r;
}

float map(vec3 p){
    float circle = sdSphere(p - vec3(0,0,2), 2.);
    float ground = p.y + 1.5;
    return min(circle,ground);
}

float softshadow( in vec3 ro, in vec3 rd, float mint, float maxt, float w )
{
    float res = 1.0;
    float t = mint;
    for( int i=0; i<256 && t<maxt; i++ )
    {
        float h = map(ro + t*rd);
        res = min( res, h/(w*t) );
        t += clamp(h, 0.005, 0.50);
        if( res<-1.0 || t>maxt ) break;
    }
    res = max(res,-1.0);
    return 0.25*(1.0+res)*(1.0+res)*(2.0-res);
}




void mainImage( out vec4 fragColor, in vec2 fragCoord )
{    
	vec2 uv = (fragCoord*2.0-iResolution.xy) / iResolution.y;

    vec3 ro = vec3(0,0,-3);
    vec3 rd = normalize(vec3(uv,1));

    //float shadow = softshadow(ro, rd);

    float t = 0;
    for(int i = 0; i < 80; i++){
        vec3 p = ro + rd * t;  // cuz distance times direction gives the correctb stuff
        
        float d = map(p); 

        t += d;
        
        if (d < 0.001 || t > 100.0) break; // early stop  

    }
    
    
    vec3 col = vec3(t * .15);// * shadow;
	fragColor = vec4(vec3(col), 1);
}

void main()
{
    vec4 col;
    mainImage(col, gl_FragCoord.xy);  // call it, filling col
    gl_FragColor = col;               // output it
}
