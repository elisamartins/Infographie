#version 410

layout(points) in;
layout(triangle_strip, max_vertices = 4) out;

uniform mat4 matrProj;

uniform int texnumero;
uniform float tempsDeVieMax;

in Attribs {
    vec4 couleur;
    float tempsDeVieRestant;
    float sens; // du vol (partie 3)
    float hauteur; // du vol (partie 3)
} AttribsIn[];

out Attribs {
    vec4 couleur;
    vec2 texCoord;
} AttribsOut;

// la hauteur minimale en-dessous de laquelle les lutins ne tournent plus (partie 3)
const float hauteurInerte = 8.0;

void main()
{
    gl_Position = matrProj * gl_in[0].gl_Position;
    gl_PointSize = gl_in[0].gl_PointSize;
    AttribsOut.couleur = AttribsIn[0].couleur;

    vec2 coins[4];
    coins[0] = vec2( -0.5,  0.5 );
    coins[1] = vec2( -0.5, -0.5 );
    coins[2] = vec2(  0.5,  0.5 );
    coins[3] = vec2(  0.5, -0.5 );

        for ( int i = 0 ; i < 4 ; ++i ){

            float fact = gl_in[0].gl_PointSize;

            AttribsOut.couleur = AttribsIn[0].couleur;
            AttribsOut.texCoord = coins[i] + vec2( 0.5, 0.5 );
           
            mat2 matrRot = mat2(1, 0, 0, 1);

            // Flocon: tourne autour de son centre
            if (texnumero == 1){

                if(AttribsIn[0].hauteur >= hauteurInerte){
                    float angle = 6.0 * AttribsIn[0].tempsDeVieRestant;
                    matrRot = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
                }
                
                // Disparait graduellement
                AttribsOut.couleur.a = AttribsIn[0].couleur.a * AttribsIn[0].tempsDeVieRestant;

            }

            // Oiseau: battement d'ailes
            if (texnumero == 2){
                const float nlutins = 16.0;
                int num = 12;

                // Si plus haut que hauteurInerte => battement d'ailes
                if(AttribsIn[0].hauteur > hauteurInerte)
                    num = int( mod(18.0 * AttribsIn[0].tempsDeVieRestant, nlutins) );
        
                AttribsOut.texCoord.x = AttribsIn[0].sens * (AttribsOut.texCoord.x + num) / nlutins;
            }

            vec4 pos = vec4( gl_in[0].gl_Position.xy + fact * coins[i] * matrRot, gl_in[0].gl_Position.zw );
            
            gl_Position = matrProj * pos;  
            
            EmitVertex();
           }
        
}
