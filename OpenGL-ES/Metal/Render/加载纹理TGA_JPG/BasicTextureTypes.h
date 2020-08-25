//
//  BasicTextureTypes.h
//  OpenGL-ES
//
//  Created by nucarf on 2020/8/25.
//  Copyright © 2020 zhaixingxing. All rights reserved.
//

#ifndef BasicTextureTypes_h
#define BasicTextureTypes_h

/*
 介绍:
 头文件包含了 Metal shaders 与C/OBJC 源之间共享的类型和枚举常数
*/

// 缓存区索引值 共享与 shader 和 C 代码 为了确保Metal Shader缓存区索引能够匹配 Metal API Buffer 设置的集合调用
typedef enum ZXVertexInputIndex
{
    //顶点
    ZXVertexInputIndexVertices     = 0,
    //视图大小
    ZXVertexInputIndexViewportSize = 1,
} ZXVertexInputIndex;

//纹理索引
typedef enum ZXTextureIndex
{
    ZXTextureIndexBaseColor = 0
}ZXTextureIndex;

//结构体: 顶点/颜色值
typedef struct
{
    // 像素空间的位置
    // 像素中心点(100,100)
    vector_float2 position;
    // 2D 纹理
    vector_float2 textureCoordinate;
} ZXVertex1;

#endif /* BasicTextureTypes_h */
