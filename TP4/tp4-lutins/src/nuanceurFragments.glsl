#version 410

uniform sampler2D leLutin;
uniform int texnumero;

in Attribs {
    vec4 couleur;
    vec2 texCoord;
} AttribsIn;

out vec4 FragColor;

void main( void )
{
    vec4 tex = texture( leLutin, AttribsIn.texCoord );

    if (texnumero != 0) {
       if (tex.a < 0.1) discard;

       else{
        FragColor.rgb = mix(AttribsIn.couleur.rgb, tex.rgb, 0.6);
        FragColor.a = AttribsIn.couleur.a;
        }
    }

    else
        FragColor = AttribsIn.couleur;


}
