# 片元着色器代码解析

** GLSL文件中不能加中文注释 **

### 1. 灰度滤镜
```
 precision highp float;
 uniform sampler2D Texture;
 varying vec2 TextureCoordsVarying;
 //变换因子
 const highp vec3 W = vec3(0.2125, 0.7154, 0.0721);

 void main()
 {
     //获取对应纹理坐标下的颜色值
     lowp vec4 textureColor = texture2D(Texture, TextureCoordsVarying);
     //将颜色与变换因子点乘得到灰度值
     float luminance = dot(textureColor.rgb, W);
     //将灰度值转化成(luminance,luminance,luminance,mask.a),并填充到图像
     gl_FragColor = vec4(vec3(luminance), textureColor.a);
 }
```

### 2. 马赛克:正方形
 ```
precision mediump float;
//纹理理坐标
varying vec2 TextureCoordsVarying; //纹理采样器器
uniform sampler2D Texture;
//纹理理图⽚片size
const vec2 TexSize = vec2(400.0, 400.0); //⻢赛克Size
const vec2 mosaicSize = vec2(16.0, 16.0);
void main()
{
//计算实际图像位置
vec2 intXY = vec2(TextureCoordsVarying.x*TexSize.x, TextureCoordsVarying.y*TexSize.y);
// floor (x) 内建函数,返回小于/等于X的最大整数值.
// floor (intXY.x / mosaicSize.x) * mosaicSize.x 计算出⼀个小⻢赛克的坐标.
vec2 XYMosaic = vec2(floor(intXY.x/mosaicSize.x)*mosaicSize.x, floor(intXY.y/
mosaicSize.y)*mosaicSize.y);
//换算回纹理理坐标
vec2 UVMosaic = vec2(XYMosaic.x/TexSize.x, XYMosaic.y/TexSize.y);
//获取到⻢赛克后的纹理理坐标的颜⾊色值
vec4 color = texture2D(Texture, UVMosaic);
//将⻢赛克颜⾊色值赋值给gl_FragColor. gl_FragColor = color;
}
```
### 3. 马赛克:六边形
```
precision highp float;
uniform sampler2D Texture;
varying vec2 TextureCoordsVarying;
//六边形的边长
const float mosaicSize = 0.03;

void main(void)
{
    float length = mosaicSize;
    //sqrt(3)/2
    float TR = 0.866025;
    float TB = 1.5;

    // 纹理坐标:(0,0)(0,1)(1,0)(1,1)
    float x = TextureCoordsVarying.x;
    float y = TextureCoordsVarying.y;

    //纹理坐标对应的矩阵坐标
    int wx = int(x / TB / length);
    int wy = int(y / TR / length);
    vec2 v1, v2, vn;

    if (wx / 2 * 2 == wx) {
        if (wy / 2 * 2 == wy) {
            //(0,0),(1,1)
            v1 = vec2(length * 1.5 * float(wx), length * TR * float(wy));
            v2 = vec2(length * 1.5 * float(wx + 1), length * TR * float(wy + 1));
        } else {
            //(0,1),(1,0)
            v1 = vec2(length * 1.5 * float(wx), length * TR * float(wy + 1));
            v2 = vec2(length * 1.5 * float(wx + 1), length * TR * float(wy));
        }
    } else {
        if (wy / 2 * 2 == wy) {
            //(0,1),(1,0)
            v1 = vec2(length * 1.5 * float(wx), length * TR * float(wy + 1));
            v2 = vec2(length * 1.5 * float(wx + 1), length * TR * float(wy));
        } else {
            //(0,0),(1,1)
            v1 = vec2(length * 1.5 * float(wx), length * TR * float(wy));
            v2 = vec2(length * 1.5 * float(wx + 1), length * TR * float(wy + 1));
        }
    }

    //计算参考点和当前纹素的距离
    float s1 = sqrt(pow(v1.x - x, 2.0) + pow(v1.y - y, 2.0));
    float s2 = sqrt(pow(v2.x - x, 2.0) + pow(v2.y - y, 2.0));
    
    //选择距离小的则为六边形的中心点, 则获取它的颜色
    if (s1 < s2) {
        vn = v1;
    } else {
        vn = v2;
    }

    //vec4 color = texture2D(Texture, vec2(length * 1.5 * float(wx), length * TR * float(wy)));
    //获取六边形中心点的颜色值
    vec4 color = texture2D(Texture, vn);
    //将颜色值填充到内建变量 gl_FragColor内
    gl_FragColor = color;
}
```

###### 注意①:
 * ⾸先六边形可以分裂成⼀个矩形块. ⽽这个矩形块的宽为:√3  ⻓为: 3; 
* 那么⻓宽⽐为: 3: √3;  
* 矩形的宽为: length * √3/2;  
* 矩形的⻓为: length * 3/2 
* 所以TR = sqrt(3)/2 = 0.866025 
* 所以TB = 3/2 = 1.5; 
###### 注意②
* 第⼀种： 如上图表示当点在偶数⾏偶数列，或者奇数⾏奇数列的情形，这种情况下，只有左上右下有个点是六边形中⼼点。
* 左上点的纹理坐标为：v1 = vec2(length * 1.5 * float(wx), length * TR * float(wy))；
* 右下点的纹理坐标为:v2 = vec2(length * 1.5 * float(wx + 1), length * TR * float(wy + 1));

* 第⼆种：表示当点在奇数⾏偶数列，或者偶数⾏奇数列的情形，这种情况下，只有左下右上有个点是六边形中⼼点。
* 左下点的纹理坐标为：v1 = vec2(length * 1.5 * float(wx), length * TR * float(wy + 1))；
* 右上点的纹理坐标为:v2 = v2 = vec2(length * 1.5 * float(wx + 1), length * TR * float(wy))。


### 4. 马赛克:三角形

```
precision highp float;
uniform sampler2D Texture;
varying vec2 TextureCoordsVarying;

float mosaicSize = 0.03;

void main(void)
{
    //TR其实是√3/2
    const float TR = 0.866025;
    //π/6 = 30.0
    const float PI6 = 0.523599;

    float x = TextureCoordsVarying.x;
    float y = TextureCoordsVarying.y;

    int wx = int(x / (1.5 * mosaicSize));
    int wy = int(y / (TR * mosaicSize));

    vec2 v1, v2, vn;

    if (wx / 2 * 2 == wx) {
        if (wy / 2 * 2 == wy) {
            v1 = vec2(mosaicSize * 1.5 * float(wx), mosaicSize * TR * float(wy));
            v2 = vec2(mosaicSize * 1.5 * float(wx + 1), mosaicSize * TR * float(wy + 1));
        } else {
            v1 = vec2(mosaicSize * 1.5 * float(wx), mosaicSize * TR * float(wy + 1));
            v2 = vec2(mosaicSize * 1.5 * float(wx + 1), mosaicSize * TR * float(wy));
        }
    } else {
        if (wy / 2 * 2 == wy) {
            v1 = vec2(mosaicSize * 1.5 * float(wx), mosaicSize * TR * float(wy + 1));
            v2 = vec2(mosaicSize * 1.5 * float(wx + 1), mosaicSize * TR * float(wy));
        } else {
            v1 = vec2(mosaicSize * 1.5 * float(wx), mosaicSize * TR * float(wy));
            v2 = vec2(mosaicSize * 1.5 * float(wx + 1), mosaicSize * TR * float(wy + 1));
        }
    }

    // 计算参考点与当前纹素的距离
    float s1 = sqrt(pow(v1.x - x, 2.0) + pow(v1.y - y, 2.0));
    float s2 = sqrt(pow(v2.x - x, 2.0) + pow(v2.y - y, 2.0));

    // 选择距离⼩的则为六边形中⼼点. 此时可以了解点属于哪个六边形
    if (s1 < s2) {
        vn = v1;
    } else {
        vn = v2;
    }

    //纹理中该点的颜⾊值.
    vec4 mid = texture2D(Texture, vn);
    //获取a与纹理中⼼的⻆度.
    //atan算出的范围是-180⾄180度，对应的数值是-PI⾄PI
    float a = atan((x - vn.x) / (y - vn.y));

    //计算六个三⻆形的中⼼点
    vec2 area1 = vec2(vn.x, vn.y - mosaicSize * TR / 2.0);
    vec2 area2 = vec2(vn.x + mosaicSize / 2.0, vn.y - mosaicSize * TR / 2.0);
    vec2 area3 = vec2(vn.x + mosaicSize / 2.0, vn.y + mosaicSize * TR / 2.0);
    vec2 area4 = vec2(vn.x, vn.y + mosaicSize * TR / 2.0);
    vec2 area5 = vec2(vn.x - mosaicSize / 2.0, vn.y + mosaicSize * TR / 2.0);
    vec2 area6 = vec2(vn.x - mosaicSize / 2.0, vn.y - mosaicSize * TR / 2.0);

    //判断夹⻆a 属于哪个三⻆形.则获取哪个三⻆形的中⼼点坐标
    if (a >= PI6 && a < PI6 * 3.0) {
        vn = area1;
    } else if (a >= PI6 * 3.0 && a < PI6 * 5.0) {
        vn = area2;
    } else if ((a >= PI6 * 5.0 && a <= PI6 * 6.0) || (a < -PI6 * 5.0 && a > -PI6 * 6.0)) {
        vn = area3;
    } else if (a < -PI6 * 3.0 && a >= -PI6 * 5.0) {
        vn = area4;
    } else if (a <= -PI6 && a > -PI6 * 3.0) {
        vn = area5;
    } else if (a > -PI6 && a < PI6) {
        vn = area6;
    }
    //判断夹⻆a 属于哪个三⻆形.则获取哪个三⻆形的中⼼点坐标
    vec4 color = texture2D(Texture, vn);
    gl_FragColor = color;
}
```
### 5. 缩放

```
attribute vec4 Position;
attribute vec2 TextureCoords;
varying vec2 TextureCoordsVarying;

//时间戳,及时更新
uniform float Time;

const float PI = 3.1415926;

void main(void)
{
    //一次缩放时长
    float duration = 0.6;
    //最大缩放幅度
    float maxAmplitude = 0.3;
    //表示传入的时间周期, 即time的控制范围被控制在[0.0, 0.6]
    //mod(a, b), 求模运算 a % b;
    float time = mod(Time, duration);
    
    //amplitude 表示振幅，引⼊ PI 的⽬的是为了使⽤ sin 函数，将 amplitude 的范围控制在 1.0 ~ 1.3 之间，并随着时间变化
    float amplitude = 1.0 + maxAmplitude * abs(sin(time * (PI / duration)));
    
    //放⼤关键: 将顶点坐标的 x 和 y 分别乘上⼀个放⼤系数，在纹理坐标不变的情况下，就达到了拉伸的效果。
    //x,y 放⼤; z和w保存不变
    gl_Position = vec4(Position.x * amplitude, Position.y * amplitude, Position.zw);
    TextureCoordsVarying = TextureCoords;
}

```
### 6. 灵魂出窍效果
```
precision highp float;
uniform sampler2D Texture;
varying vec2 TextureCoordsVarying;

uniform float Time;

void main()
{
    //一次动画时间
    float duration = 0.7;
    //最大透明度
    float maxAlpha = 0.4;
    //最大缩放比例
    float maxScale = 1.8;

    //进度取值范围[0, 1]
    float progress = mod(Time, duration) / duration;
    //透明度范围[0, 0.4]
    float alpha = maxAlpha * (1.0 - progress);
    //缩放⽐例(1.0 - 1.8)
    float scale = 1.0 + (maxScale - 1.0) * progress;

    //放大纹理坐标
    //将顶点坐标对应的纹理坐标的 x 值到纹理中点的距离，缩⼩⼀定的⽐例。这次我们是改变了纹理坐标，⽽保持顶点坐标不变，同样达到了拉伸的效果
    float weakX = 0.5 + (TextureCoordsVarying.x - 0.5) / scale;
    float weakY = 0.5 + (TextureCoordsVarying.y - 0.5) / scale;
    //获取放⼤的纹理坐标
    vec2 weakTextureCoords = vec2(weakX, weakY);

    //通过上⾯的计算，我们得到了两个纹理颜⾊值 weakMask 和 mask， weakMask 是在 mask 的基础上做了放⼤处
    vec4 weakMask = texture2D(Texture, weakTextureCoords);

    vec4 mask = texture2D(Texture, TextureCoordsVarying);

    //在GLSL 实现颜⾊混合⽅程式.默认颜⾊混合⽅程式 = mask * (1.0 - alpha) + weakMask * alpha
    //参考OpenGL 第⼆节课中的颜⾊混合
    //计算最终的颜⾊赋值给⽚元着⾊器的内置变量: gl_FragColor
    gl_FragColor = mask * (1.0 - alpha) + weakMask * alpha;
}

```

### 7. 抖动
```
precision highp float;
uniform sampler2D Texture;
varying vec2 TextureCoordsVarying;

uniform float Time;

void main()
{
    //⼀次抖动滤镜的时⻓
    float duration = 0.7;
    //放⼤图⽚上限
    float maxScale = 1.1;
    //颜色偏移步长
    float offset = 0.02;

    //进度 0~1
    float progress = mod(Time, duration) / duration;
    vec2 offsetCoords = vec2(offset, offset) * progress;
    //缩放⽐例(1.0 - 1.1)
    float scale = 1.0 + (maxScale - 1.0) * progress;

    //放⼤后的纹理坐标
    vec2 ScaleTextureCoords = vec2(0.5, 0.5) + (TextureCoordsVarying - vec2(0.5, 0.5)) / scale;

    //获取3组颜⾊
    //原始颜⾊ + offsetCoords
    vec4 maskR = texture2D(Texture, ScaleTextureCoords + offsetCoords);
    vec4 maskB = texture2D(Texture, ScaleTextureCoords - offsetCoords);
    //原始颜⾊
    vec4 mask = texture2D(Texture, ScaleTextureCoords);

    //从3组颜⾊中分别取出: 红⾊R,绿⾊G,蓝⾊B,透明度A填充到⽚元着⾊器内置变量gl_FragColor内.
    gl_FragColor = vec4(maskR.r, mask.g, maskB.b, mask.a);
}

```

### 8. 闪白
```
precision highp float;
uniform sampler2D Texture;
varying vec2 TextureCoordsVarying;

uniform float Time;

const float PI = 3.1415926;

void main(void)
{
    float duration = 0.6;
    //表示将传⼊的时间转换到⼀个周期内，即 time 的范围是 0 ~ 0.6
    float time = mod(Time, duration);

    //⽩⾊颜⾊遮罩
    vec4 whiteMask = vec4(1.0, 1.0, 1.0, 1.0);

    //amplitude 表示振幅，引⼊ PI 的⽬的是为了使⽤ sin 函数，将 amplitude 的范围控制在 0.0 ~ 1.0 之间，并随着时间变化
    float amplitude = abs(sin(time * (PI / duration)));

    //获取纹理坐标对应的纹素颜⾊值
    vec4 mask = texture2D(Texture, TextureCoordsVarying);

    //利⽤混合⽅程式: 将纹理颜⾊与⽩⾊遮罩融合.
    //注意: ⽩⾊遮罩的透明度会随着时间变化做调整
    //我们已经知道了如何实现两个层的叠加.当前的透明度来计算最终的颜⾊值即可。
    gl_FragColor = mask * (1.0 - amplitude) + whiteMask * amplitude;
}

```

### 9. 毛刺
```
precision highp float;
uniform sampler2D Texture;
varying vec2 TextureCoordsVarying;

//时间撮
uniform float Time;
//PI 常量
const float PI = 3.1415926;

float rand(float n)
{
    return fract(sin(n) * 43758.5453123);
}

void main()
{
    //最⼤抖动
    float maxJitter = 0.06;
    //⼀次⽑刺滤镜的时⻓
    float duration = 0.3;
    //红⾊颜⾊偏移
    float colorROffset = 0.01;
    //绿⾊颜⾊偏移
    float colorBOffset = -0.025;

    //表示将传⼊的时间转换到⼀个周期内，即 time 的范围是 0 ~ 0.6
    float time = mod(Time, duration * 2.0);
    //amplitude 表示振幅，引⼊ PI 的⽬的是为了使⽤ sin 函数，将 amplitude 的范围控制在 1.0 ~ 1.3 之间，并随着时间变化
    float amplitude = max(sin(time * (PI / duration)), 0.0);
    
    // -1~1 像素随机偏移范围(-1,1)
    float jitter = rand(TextureCoordsVarying.y) * 2.0 - 1.0;    // -1~1

    //判断是否需要偏移,如果jtter范围< 最⼤抖动*振幅
    bool needOffset = abs(jitter) < maxJitter * amplitude;

    //获取纹理x 坐标,根据needOffset,来计算它的X撕裂,如果是needOffset = yes 则撕裂⼤;如果 needOffset = no 则撕裂⼩;
    float textureX = TextureCoordsVarying.x + (needOffset ? jitter : (jitter * amplitude * 0.006));

    //获取纹理撕裂后的x,y坐标
    vec2 textureCoords = vec2(textureX, TextureCoordsVarying.y);

    //颜⾊偏移
    //获取3组颜⾊: 根据撕裂计算后的纹理坐标,获取纹素的颜⾊
    vec4 mask = texture2D(Texture, textureCoords);
    //获取3组颜⾊: 根据撕裂计算后的纹理坐标,获取纹素的颜⾊
    vec4 maskR = texture2D(Texture, textureCoords + vec2(colorROffset * amplitude, 0.0));
    //获取3组颜⾊: 根据撕裂技术后的纹理坐标,获取纹素颜⾊
    vec4 maskB = texture2D(Texture, textureCoords + vec2(colorBOffset * amplitude, 0.0));

    //颜⾊主要撕裂: 红⾊和蓝⾊部分.所以只调整红⾊
    gl_FragColor = vec4(maskR.r, mask.g, maskB.b, mask.a);
}

```

### 10. 缩放

### 11. 缩放
