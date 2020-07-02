#include <metal_stdlib>
#include "SharedObjectsBridge.h"
using namespace metal;

struct Vertex
{
    packed_float3 position;
    packed_float3 normal;
};

struct Varyings
{
    float4 position [[position]];
    float4 shadow0Position;
};

struct LitVaryings
{
    float4 position [[position]];
    float4 shadow0Position;
    float3 worldSpacePosition;
    float3 worldSpaceNormal;
};

vertex Varyings vertex_main(const device Vertex* verts [[buffer(0)]],
                          constant ObjectData& data [[buffer(1)]],
                          constant MainPass&  frame_constants [[buffer(2)]],
                          uint vid [[vertex_id]])
{
    Varyings out;

    float4 worldPosition = data.LocalToWorld * float4(verts[vid].position, 1.0);
    out.position = frame_constants.ViewProjection * worldPosition;
    out.shadow0Position = frame_constants.ViewShadow0Projection * worldPosition;

    return out;
}

fragment float4 unshaded_fragment(Varyings input [[stage_in]],
                                      constant ObjectData& data [[buffer(1)]])
{
    return data.color;
}
