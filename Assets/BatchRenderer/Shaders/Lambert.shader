﻿Shader "BatchRenderer/Lambert" {
Properties {
    g_base_color ("Base Color", Color) = (1,1,1,1)
    g_base_emission ("Emission", Color) = (0,0,0,0)
    _MainTex ("Base (RGB)", 2D) = "white" {}
}
SubShader {
    Tags { "RenderType"="BatchedOpaque" }
    LOD 200


CGPROGRAM
#pragma target 5.0
#pragma surface surf Lambert vertex:vert
#include "UnityCG.cginc"
#include "BatchRenderer.cginc"

struct Input {
    float2 uv_MainTex;
    float4 color;
    float4 emission;
    float kill;
};

sampler2D _MainTex;
float4 g_base_color;
float4 g_base_emission;

void vert (inout appdata_full v, out Input o)
{
    UNITY_INITIALIZE_OUTPUT(Input,o);

    float4 color = v.color * g_base_color;
    float4 emission = g_base_emission;
    float k = ApplyInstanceTransform(v.texcoord1, v.vertex, v.normal, v.texcoord.xy, color, emission);

    o.uv_MainTex = v.texcoord;
    o.color = color;
    o.emission = emission;
    o.kill = k;
}

void surf (Input IN, inout SurfaceOutput o)
{
    if(IN.kill!=0.0f) { discard; }

    fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * IN.color;
    o.Albedo = c.rgb;
    o.Alpha = c.a;
    o.Emission = IN.emission;
}
ENDCG
}

Fallback "BatchRenderer/BatchBase"
}
