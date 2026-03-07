#define KEY_W 87
#define KEY_A 65
#define KEY_S 83
#define KEY_D 68
const int KEY_LEFT  = 37;
const int KEY_RIGHT = 39;
const int KEY_DOWN  = 40;
const int KEY_UP    = 38;

const float speed = 1.0;
const float turnSpeed = 2.0;


void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    float outData = 0.0;

    // read stored turn (pixel 2, red channel)
    float turn = texelFetch(iChannel0, ivec2(2, 0), 0).r;
    // camera-relative basis (XZ plane)
    vec2 forward = vec2(sin(turn), cos(turn));   // (x,z)
    vec2 right   = vec2(forward.y, -forward.x);  // 90° rotate  || trig stuff

    float w = texelFetch(iChannel1, ivec2(KEY_W, 0), 0).r;
    float s = texelFetch(iChannel1, ivec2(KEY_S, 0), 0).r;
    float d = texelFetch(iChannel1, ivec2(KEY_D, 0), 0).r;
    float a = texelFetch(iChannel1, ivec2(KEY_A, 0), 0).r;
    
    switch(int(fragCoord.x)) {
        //movement data
        case 0: //x pos
            outData = texelFetch(iChannel0, ivec2(0, 0), 0).r
                + (iTimeDelta * speed) * ( (w - s) * forward.x 
                + (d - a) * right.x );
            break;
        
        case 1: // z pos
        	outData = texelFetch(iChannel0, ivec2(1, 0), 0).r
                + (iTimeDelta * speed) * ( (w - s) * forward.y 
                + (d - a) * right.y );
        	break;
            
        // turning data
        case 2: // left/right - xz rot
        	outData = texelFetch(iChannel0, ivec2(2, 0), 0).r +
                (iTimeDelta * turnSpeed) * texelFetch(iChannel1, ivec2(KEY_RIGHT, 0), 0).r -
        		(iTimeDelta * turnSpeed) * texelFetch(iChannel1, ivec2(KEY_LEFT, 0), 0).r;
        	break; 
         
        case 3: // up/down - xy rot
            outData = texelFetch(iChannel0, ivec2(3,0), 0).r +
            (iTimeDelta * turnSpeed) * texelFetch(iChannel1, ivec2(KEY_DOWN, 0), 0).r -
            (iTimeDelta * turnSpeed) * texelFetch(iChannel1, ivec2(KEY_UP, 0), 0).r;
            outData = clamp(outData, -1.55, 1.55);
            break;
    }
    
    fragColor = vec4(outData, 0.0, 0.0, 1.0);
}