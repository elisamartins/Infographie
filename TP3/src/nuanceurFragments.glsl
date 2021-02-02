#version 410

// Définition des paramètres des sources de lumière
layout (std140) uniform LightSourceParameters
{
    vec4 ambient[3];
    vec4 diffuse[3];
    vec4 specular[3];
    vec4 position[3];      // dans le repère du monde
} LightSource;

// Définition des paramètres des matériaux
layout (std140) uniform MaterialParameters
{
    vec4 emission;
    vec4 ambient;
    vec4 diffuse;
    vec4 specular;
    float shininess;
} FrontMaterial;

// Définition des paramètres globaux du modèle de lumière
layout (std140) uniform LightModelParameters
{
    vec4 ambient;       // couleur ambiante globale
    bool twoSide;       // éclairage sur les deux côtés ou un seul?
} LightModel;

layout (std140) uniform varsUnif
{
    // partie 1: illumination
    int typeIllumination;     // 0:Gouraud, 1:Phong
    bool utiliseBlinn;        // indique si on veut utiliser modèle spéculaire de Blinn ou Phong
    bool afficheNormales;     // indique si on utilise les normales comme couleurs (utile pour le débogage)
    // partie 2: texture
    int iTexCoul;             // numéro de la texture de couleurs appliquée
    int iTexNorm;             // numéro de la texture de normales appliquée
};

uniform sampler2D laTextureCoul;
uniform sampler2D laTextureNorm;

/////////////////////////////////////////////////////////////////

in Attribs {
    vec4 couleur;
    vec3 N;
    vec3 L[3];
    vec3 O;
    vec2 texCoord;
} AttribsIn;

out vec4 FragColor;

float attenuation = 1.0;
vec4 calculerReflexion( in int j, in vec3 L, in vec3 N, in vec3 O ) // pour la lumière j
{
    float NdotL = max( 0.0, dot(N, L ) );
    vec4 couleur = vec4(0.0);
    if ( NdotL > 0 ){
            float spec = max( 0.0, ( utiliseBlinn ) ?
                          dot( normalize( L + O ), N ) : // Blinn
                          dot( reflect( -L, N ), O ) ); // Phong
            if (spec > 0) couleur += FrontMaterial.specular * pow( spec, FrontMaterial.shininess );
            couleur += FrontMaterial.diffuse * LightSource.diffuse[j] * NdotL;
    }
    return couleur;
}

void main( void )
{
    vec3 L[3] = AttribsIn.L;
    vec3 N = normalize( AttribsIn.N );
    vec3 O = normalize( AttribsIn.O );

    // Placage de relief
    if( iTexNorm != 0 ){
        vec3 dN = normalize( ( texture(laTextureNorm, AttribsIn.texCoord).rgb - 0.5) * 2.0 );
        N = normalize( N + dN );
    }

    // Si c'est Phong
    if(typeIllumination == 1) {
       FragColor = FrontMaterial.emission + FrontMaterial.ambient * LightModel.ambient;

        for(int j = 0; j < 3; j++)
            FragColor += calculerReflexion( j, normalize(AttribsIn.L[j]), N, O );
                    
        FragColor = clamp(FragColor, 0.0, 1.0);
    }

    // Si c'est Gouraud
    else FragColor = clamp(AttribsIn.couleur, 0.0, 1.0);

    // S'il y a une texture de couleur
    if( iTexCoul != 0 ){
        vec4 coul = texture( laTextureCoul, AttribsIn.texCoord.st );
        if ( length(coul.rgb) < 0.5 ) discard;
        else FragColor *= coul;
    }

}
