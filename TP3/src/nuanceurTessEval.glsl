#version 410

layout(quads) in;

in Attribs {
    vec4 couleur;
    vec3 N;
    vec3 L[3];
    vec3 O;
    vec2 texCoord;
} AttribsIn[];

out Attribs {
    vec4 couleur;
    vec3 N;
    vec3 L[3];
    vec3 O;
    vec2 texCoord;
} AttribsOut;

vec4 interpole(vec4 v0, vec4 v1, vec4 v2, vec4 v3){
    return mix( mix( v0, v1, gl_TessCoord.x ),
                mix( v3, v2, gl_TessCoord.x ),
                gl_TessCoord.y );
}

void main(void) {

    vec4 p0 = gl_in[0].gl_Position;
    vec4 p1 = gl_in[1].gl_Position;
    vec4 p2 = gl_in[2].gl_Position;
    vec4 p3 = gl_in[3].gl_Position;
    gl_Position = interpole(p0, p1, p3, p2);

    AttribsOut.couleur = interpole( AttribsIn[0].couleur,
                                    AttribsIn[1].couleur,
                                    AttribsIn[2].couleur,
                                    AttribsIn[3].couleur );

    AttribsOut.N = AttribsIn[0].N;
    AttribsOut.L = AttribsIn[0].L;
    AttribsOut.O = AttribsIn[0].O;
    AttribsOut.texCoord = AttribsIn[0].texCoord;
 
}