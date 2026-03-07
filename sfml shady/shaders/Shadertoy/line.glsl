void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord * 2.0 - iResolution.xy) / iResolution.y;

    vec2 B = vec2(-0.2, 1.0); // top point
    vec2 A = vec2(0.0, -1.0); // bottom point

    float d = (uv.x - (((uv.y-A.y)*(B.x-A.x))/(B.y-A.y)) + A.x) * sin(atan(B.y-A.y,B.x-A.x));
    
    d = smoothstep(0.0,0.1,abs(d));
    fragColor = vec4(vec3(sin(d)),1.0);
}