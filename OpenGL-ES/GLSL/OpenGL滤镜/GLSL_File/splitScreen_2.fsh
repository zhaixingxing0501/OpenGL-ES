precision highp float;
uniform sampler2D Texture;
varying vec2 TextureCoordsVarying;

void main()
{
    vec2 uv = TextureCoordsVarying.xy;

    if (uv.y <= 0.50 && uv.y >= 0.0) {
        uv.y += 0.25;
    } else {
        uv.y -= 0.25;
    }

    gl_FragColor = texture2D(Texture, uv);
}
