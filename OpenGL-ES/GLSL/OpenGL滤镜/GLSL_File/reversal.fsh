precision highp float;
uniform sampler2D Texture;
varying vec2 TextureCoordsVarying;

void main()
{
    vec2 uv = TextureCoordsVarying.xy;

    uv.y = 1.0 - uv.y;

    gl_FragColor = texture2D(Texture, uv);
}
