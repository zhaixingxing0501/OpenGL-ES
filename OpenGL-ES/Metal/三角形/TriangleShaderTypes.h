//
//  TriangleShaderTypes.h
//  OpenGL-ES
//
//  Created by nucarf on 2020/8/20.
//  Copyright © 2020 zhaixingxing. All rights reserved.
//

#ifndef TriangleShaderTypes_h
#define TriangleShaderTypes_h

/*
 介绍:
 头文件包含了 Metal shaders 与C/OBJC 源之间共享的类型和枚举常数
*/

// 缓存区索引值 共享与 shader 和 C 代码 为了确保Metal Shader缓存区索引能够匹配 Metal API Buffer 设置的集合调用
typedef enum ZXVertexInputIndex {
    //顶点
    ZXVertexInputIndexVertices     = 0,
    //视图大小
    ZXVertexInputIndexViewportSize = 1,
} ZXVertexInputIndex;

//结构体: 顶点/颜色值
typedef struct {
    // 像素空间的位置
    // 像素中心点(100,100)
    vector_float4 position;

    // RGBA颜色
    vector_float4 color;
} ZXVertex;

#endif /* TriangleShaderTypes_h */
