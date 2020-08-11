# 片元着色器代码解析

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
