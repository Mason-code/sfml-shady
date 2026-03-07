vec2 getCoord() {
    return vec2(
    	texelFetch(iChannel0, ivec2(0, 0), 0).r,
        texelFetch(iChannel0, ivec2(1, 0), 0).r
    );
}

vec3 rot3D(vec3 p, vec3 axis, float angle)
{
    // Rodrigues' rotation formula
    return mix(dot(axis, p) * axis, p , cos(angle)) 
    + cross(axis, p) * sin(angle);
}

mat2 rot2D(float angle)
{
    float s = sin(angle);
    float c = cos(angle);
    return mat2(c, -s, s, c);
}

// cubic polynomial
float smin( float a, float b, float k )
{
    k *= 6.0;
    float h = max( k-abs(a-b), 0.0 )/k;
    return min(a,b) - h*h*h*k*(1.0/6.0);
}

float sdSphere(vec3 p, float radius)
{
    return length(p) - radius;
}

float sdBox( vec3 p, vec3 b)
{
    vec3 q = abs(p) - b;
    return length(max(q,0.0)) + min(max(q.x,max(q.y,q.z)),0.0);
}


// point in 3d space. finds distance to nearest object in the scene
float map(vec3 p)
{
    vec3 spherePos = vec3(sin(iTime) * 3., 0, 0); // sphere position
    float sphere = sdSphere(p - spherePos, 1.); // sphere sdf
    
    vec3 q = p; // Input Point copy 
    q.y -= iTime * .4; // opposite?: boxes move up
    q = fract(q) - .5; // space repitition ******
    
    float box = sdBox(q, vec3(0.1 * (1.0 - 0.3 * abs(sin(iTime))))) ; // box sdf   ** divide/multiply the input position to scale **
                                       // divide output by scaling factor to remove artfiacts in the rendering
    
    float ground = p.y + .40; // ground sdf
    
    
    // Combine shapes: minimun between the two distances (closest distance to the scene)
    return smin(ground, smin(sphere, box, .2), .1); 
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = (fragCoord*2.0-iResolution.xy) / iResolution.y;
    vec2 m = (iMouse.xy * 2. - iResolution.xy) / iResolution.y; // mouse pos in clip space
    
    // Initialization
    vec2 pos = getCoord(); // gets data saved in texture
    // Use both components. Pick the axes you want:
    // Common: x = strafe, z = forward/back
    vec3 ro = vec3(pos.x, 0.0, pos.y - 3.0);
    //vec3 ro = vec3(0,0,-3); // ray origin 
    
    vec3 rd = normalize(vec3(uv,1)); // ray direction
    vec3 col = vec3(0); // final p ixel color
    
    float t = 0.0; //total distance ray traveled from origin
    
    
    float turnLR = texelFetch(iChannel0, ivec2(2,0), 0).r;
    float turnUP = texelFetch(iChannel0, ivec2(3,0), 0).r;
    // Horizontal/vert camera roration 
    //ro.xz += -turn;
    rd.xz = rot2D(turnLR) * rd.xz; // yaw
    rd.yz = rot2D(turnUP) * rd.yz; // pitch (local)
    
     
    // Vertical camera roration 
    //ro.yz *= rot2D(-m.y);
    ///rd.yz *= rot2D(-m.y);
    
    // Raymarching!
    for (int i = 0; i < 80; i++){
        vec3 p = ro + rd * t; // position along the ray

        float d = map(p); // furthest distance that can be traveled before it hits something in the scene

        t += d; // "march" the ray
        
        if (d < 0.001 || t > 100.0) break; // early stop  
    }
    
    // coloring 
    col = vec3(t * .15); // color based on distance
    fragColor = vec4(col, 1.0);
}
