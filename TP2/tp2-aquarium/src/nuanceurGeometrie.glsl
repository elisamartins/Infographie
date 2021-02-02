#version 410

layout(triangles) in;
layout(triangle_strip, max_vertices = 3) out;

in Attribs {
    vec4 couleur;
} AttribsIn[];

out Attribs {
    vec4 couleur;
    vec3 normale, lumiDir, obsVec;
} AttribsOut;

void main()
{
    // calculer la normale 
    vec3 arete1 = vec3(gl_in[1].gl_Position) -  vec3(gl_in[0].gl_Position);
    vec3 arete2 = vec3(gl_in[2].gl_Position) -  vec3(gl_in[0].gl_Position);
    AttribsOut.normale = cross(arete1, arete2);

    // variables illumination
    AttribsOut.lumiDir = vec3(0,0,1);
    AttribsOut.obsVec = vec3(0,0,1);

    // émettre les sommets
    for ( int i = 0 ; i < gl_in.length() ; ++i )
    {
        gl_ViewportIndex = 0;
        gl_Position = gl_in[i].gl_Position;
        AttribsOut.couleur = AttribsIn[i].couleur;
        EmitVertex();
    }
    EndPrimitive();

}