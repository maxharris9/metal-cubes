#include <metal_stdlib>
using namespace metal;


constant float4 verts[] =
{
    float4(-1.0, 1.0, 0.0, 0.0),
    float4( 1.0, 1.0, 1.0, 0.0),
    float4(-1.0,-1.0, 0.0, 1.0),
    float4( 1.0,-1.0, 1.0, 1.0),
};

struct Varyings
{
    float4 position [[position]];
    float2 uv;
};

vertex Varyings quad_vertex_main(uint vid [[vertex_id]])
{
    Varyings out;

    out.position = float4(verts[vid].xy, 0.0, 1.0);
    out.uv = verts[vid].zw;

    return out;
}

constexpr sampler s(coord::normalized, address::repeat, filter::nearest);

fragment float4 textured_quad_fragment(Varyings input [[stage_in]],
                                       texture2d<float> tex [[texture(0)]])
{
    return tex.sample(s, input.uv);
}
