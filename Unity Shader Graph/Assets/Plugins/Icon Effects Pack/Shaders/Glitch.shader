Shader "IndieImpulse/Unlit/IconEffectsPack/Glitch"
{
    Properties
    {
        [NoScaleOffset]_MainTex("MainTex", 2D) = "white" {}
        _Glitch("Glitch", Float) = 0
        [HDR]_Color("Color", Color) = (0, 0, 0, 0)
        [HideInInspector]_QueueOffset("_QueueOffset", Float) = 0
        [HideInInspector]_QueueControl("_QueueControl", Float) = -1
        [HideInInspector][NoScaleOffset]unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}
    }
    SubShader
    {
        Tags
        {
            "RenderPipeline"="UniversalPipeline"
            "RenderType"="Transparent"
            "UniversalMaterialType" = "Unlit"
            "Queue"="Transparent"
            "ShaderGraphShader"="true"
            "ShaderGraphTargetId"="UniversalUnlitSubTarget"
        }
        Pass
        {
            Name "Universal Forward"
            Tags
            {
                // LightMode: <None>
            }
        
        // Render State
        Cull Back
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
        ZTest LEqual
        ZWrite Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma multi_compile_instancing
        #pragma multi_compile_fog
        #pragma instancing_options renderinglayer
        #pragma multi_compile _ DOTS_INSTANCING_ON
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma shader_feature _ _SAMPLE_GI
        #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
        #pragma multi_compile_fragment _ DEBUG_DISPLAY
        // GraphKeywords: <None>
        
        // Defines
        
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_VIEWDIRECTION_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_UNLIT
        #define _FOG_FRAGMENT 1
        #define _SURFACE_TYPE_TRANSPARENT 1
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 texCoord0;
             float3 viewDirectionWS;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float4 uv0;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float3 interp1 : INTERP1;
             float4 interp2 : INTERP2;
             float3 interp3 : INTERP3;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyz =  input.normalWS;
            output.interp2.xyzw =  input.texCoord0;
            output.interp3.xyz =  input.viewDirectionWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.normalWS = input.interp1.xyz;
            output.texCoord0 = input.interp2.xyzw;
            output.viewDirectionWS = input.interp3.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _MainTex_TexelSize;
        float _Glitch;
        float4 _Color;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_MainTex);
        SAMPLER(sampler_MainTex);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Comparison_Greater_float(float A, float B, out float Out)
        {
            Out = A > B ? 1 : 0;
        }
        
        void Unity_Posterize_float4(float4 In, float4 Steps, out float4 Out)
        {
            Out = floor(In / (1 / Steps)) * (1 / Steps);
        }
        
        
        inline float Unity_SimpleNoise_RandomValue_float (float2 uv)
        {
            float angle = dot(uv, float2(12.9898, 78.233));
            #if defined(SHADER_API_MOBILE) && (defined(SHADER_API_GLES) || defined(SHADER_API_GLES3) || defined(SHADER_API_VULKAN))
                // 'sin()' has bad precision on Mali GPUs for inputs > 10000
                angle = fmod(angle, TWO_PI); // Avoid large inputs to sin()
            #endif
            return frac(sin(angle)*43758.5453);
        }
        
        inline float Unity_SimpleNnoise_Interpolate_float (float a, float b, float t)
        {
            return (1.0-t)*a + (t*b);
        }
        
        
        inline float Unity_SimpleNoise_ValueNoise_float (float2 uv)
        {
            float2 i = floor(uv);
            float2 f = frac(uv);
            f = f * f * (3.0 - 2.0 * f);
        
            uv = abs(frac(uv) - 0.5);
            float2 c0 = i + float2(0.0, 0.0);
            float2 c1 = i + float2(1.0, 0.0);
            float2 c2 = i + float2(0.0, 1.0);
            float2 c3 = i + float2(1.0, 1.0);
            float r0 = Unity_SimpleNoise_RandomValue_float(c0);
            float r1 = Unity_SimpleNoise_RandomValue_float(c1);
            float r2 = Unity_SimpleNoise_RandomValue_float(c2);
            float r3 = Unity_SimpleNoise_RandomValue_float(c3);
        
            float bottomOfGrid = Unity_SimpleNnoise_Interpolate_float(r0, r1, f.x);
            float topOfGrid = Unity_SimpleNnoise_Interpolate_float(r2, r3, f.x);
            float t = Unity_SimpleNnoise_Interpolate_float(bottomOfGrid, topOfGrid, f.y);
            return t;
        }
        void Unity_SimpleNoise_float(float2 UV, float Scale, out float Out)
        {
            float t = 0.0;
        
            float freq = pow(2.0, float(0));
            float amp = pow(0.5, float(3-0));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;
        
            freq = pow(2.0, float(1));
            amp = pow(0.5, float(3-1));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;
        
            freq = pow(2.0, float(2));
            amp = pow(0.5, float(3-2));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;
        
            Out = t;
        }
        
        void Unity_Fraction_float(float In, out float Out)
        {
            Out = frac(In);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_SampleGradientV1_float(Gradient Gradient, float Time, out float4 Out)
        {
            float3 color = Gradient.colors[0].rgb;
            [unroll]
            for (int c = 1; c < Gradient.colorsLength; c++)
            {
                float colorPos = saturate((Time - Gradient.colors[c - 1].w) / (Gradient.colors[c].w - Gradient.colors[c - 1].w)) * step(c, Gradient.colorsLength - 1);
                color = lerp(color, Gradient.colors[c].rgb, lerp(colorPos, step(0.01, colorPos), Gradient.type));
            }
        #ifdef UNITY_COLORSPACE_GAMMA
            color = LinearToSRGB(color);
        #endif
            float alpha = Gradient.alphas[0].x;
            [unroll]
            for (int a = 1; a < Gradient.alphasLength; a++)
            {
                float alphaPos = saturate((Time - Gradient.alphas[a - 1].y) / (Gradient.alphas[a].y - Gradient.alphas[a - 1].y)) * step(a, Gradient.alphasLength - 1);
                alpha = lerp(alpha, Gradient.alphas[a].x, lerp(alphaPos, step(0.01, alphaPos), Gradient.type));
            }
            Out = float4(color, alpha);
        }
        
        void Unity_RandomRange_float(float2 Seed, float Min, float Max, out float Out)
        {
             float randomno =  frac(sin(dot(Seed, float2(12.9898, 78.233)))*43758.5453);
             Out = lerp(Min, Max, randomno);
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _Property_cb3a1e3de89b4726b9a0635fe0f3e2ea_Out_0 = _Glitch;
            float _Comparison_e2a4fb5191904b1fb860567bcb12d930_Out_2;
            Unity_Comparison_Greater_float(_Property_cb3a1e3de89b4726b9a0635fe0f3e2ea_Out_0, 0, _Comparison_e2a4fb5191904b1fb860567bcb12d930_Out_2);
            float4 _UV_456b9c89fb434ceb9147a268bd819ba0_Out_0 = IN.uv0;
            float4 _Posterize_481d28d2b2fd4ddebcc686054f637b09_Out_2;
            Unity_Posterize_float4(_UV_456b9c89fb434ceb9147a268bd819ba0_Out_0, float4(12, 12, 12, 4), _Posterize_481d28d2b2fd4ddebcc686054f637b09_Out_2);
            float _SimpleNoise_cde6ca44ddef403a842ed90a6ab8c4d0_Out_2;
            Unity_SimpleNoise_float((_Posterize_481d28d2b2fd4ddebcc686054f637b09_Out_2.xy), 500, _SimpleNoise_cde6ca44ddef403a842ed90a6ab8c4d0_Out_2);
            float _Fraction_e87d167ea39b41238b60af0940743fb4_Out_1;
            Unity_Fraction_float(_SimpleNoise_cde6ca44ddef403a842ed90a6ab8c4d0_Out_2, _Fraction_e87d167ea39b41238b60af0940743fb4_Out_1);
            float _Multiply_7518e7fe7f814122b4218e9236439ead_Out_2;
            Unity_Multiply_float_float(_Fraction_e87d167ea39b41238b60af0940743fb4_Out_1, IN.TimeParameters.x, _Multiply_7518e7fe7f814122b4218e9236439ead_Out_2);
            float _Fraction_89fde9a65c8a458994c8253f5c358b88_Out_1;
            Unity_Fraction_float(_Multiply_7518e7fe7f814122b4218e9236439ead_Out_2, _Fraction_89fde9a65c8a458994c8253f5c358b88_Out_1);
            float4 _SampleGradient_b0632de439cb477982e6944782bce099_Out_2;
            Unity_SampleGradientV1_float(NewGradient(0, 4, 2, float4(1, 1, 1, 0),float4(0.4150943, 0.1789946, 0, 0.3941253),float4(1, 0.8410894, 0, 0.6617685),float4(1, 1, 1, 1),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0), float2(1, 0),float2(1, 1),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0)), _Fraction_89fde9a65c8a458994c8253f5c358b88_Out_1, _SampleGradient_b0632de439cb477982e6944782bce099_Out_2);
            UnityTexture2D _Property_746103c6d35a49b8a832a78a800c16db_Out_0 = UnityBuildTexture2DStructNoScale(_MainTex);
            float4 _UV_c2208a01c68a4e36be52cea883d4fcdf_Out_0 = IN.uv0;
            float4 _UV_eee149bb2a554c72a682890871dd2328_Out_0 = IN.uv0;
            float _Split_3eaefb55a74c48c18fb16f4f435caa1b_R_1 = _UV_eee149bb2a554c72a682890871dd2328_Out_0[0];
            float _Split_3eaefb55a74c48c18fb16f4f435caa1b_G_2 = _UV_eee149bb2a554c72a682890871dd2328_Out_0[1];
            float _Split_3eaefb55a74c48c18fb16f4f435caa1b_B_3 = _UV_eee149bb2a554c72a682890871dd2328_Out_0[2];
            float _Split_3eaefb55a74c48c18fb16f4f435caa1b_A_4 = _UV_eee149bb2a554c72a682890871dd2328_Out_0[3];
            float _SimpleNoise_bf0709d2c0ff4974876f4f331d99f9a9_Out_2;
            Unity_SimpleNoise_float((_Split_3eaefb55a74c48c18fb16f4f435caa1b_G_2.xx), _Property_cb3a1e3de89b4726b9a0635fe0f3e2ea_Out_0, _SimpleNoise_bf0709d2c0ff4974876f4f331d99f9a9_Out_2);
            float _SimpleNoise_5c6b3e9b03c54e6d86996fa545240e32_Out_2;
            Unity_SimpleNoise_float((IN.TimeParameters.x.xx), 500, _SimpleNoise_5c6b3e9b03c54e6d86996fa545240e32_Out_2);
            float _RandomRange_54ec6d53bdce4eb3afb9fe52174ee719_Out_3;
            Unity_RandomRange_float((_SimpleNoise_5c6b3e9b03c54e6d86996fa545240e32_Out_2.xx), -1, 1, _RandomRange_54ec6d53bdce4eb3afb9fe52174ee719_Out_3);
            float _Multiply_727a0ba96b7a421e93aa3ce4bba6abbc_Out_2;
            Unity_Multiply_float_float(_SimpleNoise_bf0709d2c0ff4974876f4f331d99f9a9_Out_2, _RandomRange_54ec6d53bdce4eb3afb9fe52174ee719_Out_3, _Multiply_727a0ba96b7a421e93aa3ce4bba6abbc_Out_2);
            float2 _Vector2_1fdee0dada2f419bbbedb9288a55e0b6_Out_0 = float2(_Multiply_727a0ba96b7a421e93aa3ce4bba6abbc_Out_2, _Multiply_727a0ba96b7a421e93aa3ce4bba6abbc_Out_2);
            float2 _Add_314e2e2180f54f489047d1c6df3ce8c8_Out_2;
            Unity_Add_float2((_UV_c2208a01c68a4e36be52cea883d4fcdf_Out_0.xy), _Vector2_1fdee0dada2f419bbbedb9288a55e0b6_Out_0, _Add_314e2e2180f54f489047d1c6df3ce8c8_Out_2);
            float4 _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0 = SAMPLE_TEXTURE2D(_Property_746103c6d35a49b8a832a78a800c16db_Out_0.tex, _Property_746103c6d35a49b8a832a78a800c16db_Out_0.samplerstate, _Property_746103c6d35a49b8a832a78a800c16db_Out_0.GetTransformedUV(_Add_314e2e2180f54f489047d1c6df3ce8c8_Out_2));
            float _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_R_4 = _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0.r;
            float _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_G_5 = _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0.g;
            float _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_B_6 = _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0.b;
            float _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_A_7 = _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0.a;
            float4 _Branch_d826e821815e407cb7a1dccd0c75f9ed_Out_3;
            Unity_Branch_float4(_Comparison_e2a4fb5191904b1fb860567bcb12d930_Out_2, _SampleGradient_b0632de439cb477982e6944782bce099_Out_2, _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0, _Branch_d826e821815e407cb7a1dccd0c75f9ed_Out_3);
            float4 _Property_3972ba0c594d4f75a3dfcb9a1cf2c9fb_Out_0 = IsGammaSpace() ? LinearToSRGB(_Color) : _Color;
            float4 _Multiply_028af5f91b3d4eedac9f0ad17399bbce_Out_2;
            Unity_Multiply_float4_float4(_SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0, _Property_3972ba0c594d4f75a3dfcb9a1cf2c9fb_Out_0, _Multiply_028af5f91b3d4eedac9f0ad17399bbce_Out_2);
            float4 _Multiply_b9f22c9e2b5a4943960230312fde11e4_Out_2;
            Unity_Multiply_float4_float4(_Branch_d826e821815e407cb7a1dccd0c75f9ed_Out_3, _Multiply_028af5f91b3d4eedac9f0ad17399bbce_Out_2, _Multiply_b9f22c9e2b5a4943960230312fde11e4_Out_2);
            surface.BaseColor = (_Multiply_b9f22c9e2b5a4943960230312fde11e4_Out_2.xyz);
            surface.Alpha = (_Multiply_b9f22c9e2b5a4943960230312fde11e4_Out_2).x;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.uv0 = input.texCoord0;
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/UnlitPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "DepthNormalsOnly"
            Tags
            {
                "LightMode" = "DepthNormalsOnly"
            }
        
        // Render State
        Cull Back
        ZTest LEqual
        ZWrite On
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma multi_compile_instancing
        #pragma multi_compile _ DOTS_INSTANCING_ON
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHNORMALSONLY
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float4 uv0;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float4 interp1 : INTERP1;
             float4 interp2 : INTERP2;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.normalWS;
            output.interp1.xyzw =  input.tangentWS;
            output.interp2.xyzw =  input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.normalWS = input.interp0.xyz;
            output.tangentWS = input.interp1.xyzw;
            output.texCoord0 = input.interp2.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _MainTex_TexelSize;
        float _Glitch;
        float4 _Color;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_MainTex);
        SAMPLER(sampler_MainTex);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Comparison_Greater_float(float A, float B, out float Out)
        {
            Out = A > B ? 1 : 0;
        }
        
        void Unity_Posterize_float4(float4 In, float4 Steps, out float4 Out)
        {
            Out = floor(In / (1 / Steps)) * (1 / Steps);
        }
        
        
        inline float Unity_SimpleNoise_RandomValue_float (float2 uv)
        {
            float angle = dot(uv, float2(12.9898, 78.233));
            #if defined(SHADER_API_MOBILE) && (defined(SHADER_API_GLES) || defined(SHADER_API_GLES3) || defined(SHADER_API_VULKAN))
                // 'sin()' has bad precision on Mali GPUs for inputs > 10000
                angle = fmod(angle, TWO_PI); // Avoid large inputs to sin()
            #endif
            return frac(sin(angle)*43758.5453);
        }
        
        inline float Unity_SimpleNnoise_Interpolate_float (float a, float b, float t)
        {
            return (1.0-t)*a + (t*b);
        }
        
        
        inline float Unity_SimpleNoise_ValueNoise_float (float2 uv)
        {
            float2 i = floor(uv);
            float2 f = frac(uv);
            f = f * f * (3.0 - 2.0 * f);
        
            uv = abs(frac(uv) - 0.5);
            float2 c0 = i + float2(0.0, 0.0);
            float2 c1 = i + float2(1.0, 0.0);
            float2 c2 = i + float2(0.0, 1.0);
            float2 c3 = i + float2(1.0, 1.0);
            float r0 = Unity_SimpleNoise_RandomValue_float(c0);
            float r1 = Unity_SimpleNoise_RandomValue_float(c1);
            float r2 = Unity_SimpleNoise_RandomValue_float(c2);
            float r3 = Unity_SimpleNoise_RandomValue_float(c3);
        
            float bottomOfGrid = Unity_SimpleNnoise_Interpolate_float(r0, r1, f.x);
            float topOfGrid = Unity_SimpleNnoise_Interpolate_float(r2, r3, f.x);
            float t = Unity_SimpleNnoise_Interpolate_float(bottomOfGrid, topOfGrid, f.y);
            return t;
        }
        void Unity_SimpleNoise_float(float2 UV, float Scale, out float Out)
        {
            float t = 0.0;
        
            float freq = pow(2.0, float(0));
            float amp = pow(0.5, float(3-0));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;
        
            freq = pow(2.0, float(1));
            amp = pow(0.5, float(3-1));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;
        
            freq = pow(2.0, float(2));
            amp = pow(0.5, float(3-2));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;
        
            Out = t;
        }
        
        void Unity_Fraction_float(float In, out float Out)
        {
            Out = frac(In);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_SampleGradientV1_float(Gradient Gradient, float Time, out float4 Out)
        {
            float3 color = Gradient.colors[0].rgb;
            [unroll]
            for (int c = 1; c < Gradient.colorsLength; c++)
            {
                float colorPos = saturate((Time - Gradient.colors[c - 1].w) / (Gradient.colors[c].w - Gradient.colors[c - 1].w)) * step(c, Gradient.colorsLength - 1);
                color = lerp(color, Gradient.colors[c].rgb, lerp(colorPos, step(0.01, colorPos), Gradient.type));
            }
        #ifdef UNITY_COLORSPACE_GAMMA
            color = LinearToSRGB(color);
        #endif
            float alpha = Gradient.alphas[0].x;
            [unroll]
            for (int a = 1; a < Gradient.alphasLength; a++)
            {
                float alphaPos = saturate((Time - Gradient.alphas[a - 1].y) / (Gradient.alphas[a].y - Gradient.alphas[a - 1].y)) * step(a, Gradient.alphasLength - 1);
                alpha = lerp(alpha, Gradient.alphas[a].x, lerp(alphaPos, step(0.01, alphaPos), Gradient.type));
            }
            Out = float4(color, alpha);
        }
        
        void Unity_RandomRange_float(float2 Seed, float Min, float Max, out float Out)
        {
             float randomno =  frac(sin(dot(Seed, float2(12.9898, 78.233)))*43758.5453);
             Out = lerp(Min, Max, randomno);
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _Property_cb3a1e3de89b4726b9a0635fe0f3e2ea_Out_0 = _Glitch;
            float _Comparison_e2a4fb5191904b1fb860567bcb12d930_Out_2;
            Unity_Comparison_Greater_float(_Property_cb3a1e3de89b4726b9a0635fe0f3e2ea_Out_0, 0, _Comparison_e2a4fb5191904b1fb860567bcb12d930_Out_2);
            float4 _UV_456b9c89fb434ceb9147a268bd819ba0_Out_0 = IN.uv0;
            float4 _Posterize_481d28d2b2fd4ddebcc686054f637b09_Out_2;
            Unity_Posterize_float4(_UV_456b9c89fb434ceb9147a268bd819ba0_Out_0, float4(12, 12, 12, 4), _Posterize_481d28d2b2fd4ddebcc686054f637b09_Out_2);
            float _SimpleNoise_cde6ca44ddef403a842ed90a6ab8c4d0_Out_2;
            Unity_SimpleNoise_float((_Posterize_481d28d2b2fd4ddebcc686054f637b09_Out_2.xy), 500, _SimpleNoise_cde6ca44ddef403a842ed90a6ab8c4d0_Out_2);
            float _Fraction_e87d167ea39b41238b60af0940743fb4_Out_1;
            Unity_Fraction_float(_SimpleNoise_cde6ca44ddef403a842ed90a6ab8c4d0_Out_2, _Fraction_e87d167ea39b41238b60af0940743fb4_Out_1);
            float _Multiply_7518e7fe7f814122b4218e9236439ead_Out_2;
            Unity_Multiply_float_float(_Fraction_e87d167ea39b41238b60af0940743fb4_Out_1, IN.TimeParameters.x, _Multiply_7518e7fe7f814122b4218e9236439ead_Out_2);
            float _Fraction_89fde9a65c8a458994c8253f5c358b88_Out_1;
            Unity_Fraction_float(_Multiply_7518e7fe7f814122b4218e9236439ead_Out_2, _Fraction_89fde9a65c8a458994c8253f5c358b88_Out_1);
            float4 _SampleGradient_b0632de439cb477982e6944782bce099_Out_2;
            Unity_SampleGradientV1_float(NewGradient(0, 4, 2, float4(1, 1, 1, 0),float4(0.4150943, 0.1789946, 0, 0.3941253),float4(1, 0.8410894, 0, 0.6617685),float4(1, 1, 1, 1),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0), float2(1, 0),float2(1, 1),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0)), _Fraction_89fde9a65c8a458994c8253f5c358b88_Out_1, _SampleGradient_b0632de439cb477982e6944782bce099_Out_2);
            UnityTexture2D _Property_746103c6d35a49b8a832a78a800c16db_Out_0 = UnityBuildTexture2DStructNoScale(_MainTex);
            float4 _UV_c2208a01c68a4e36be52cea883d4fcdf_Out_0 = IN.uv0;
            float4 _UV_eee149bb2a554c72a682890871dd2328_Out_0 = IN.uv0;
            float _Split_3eaefb55a74c48c18fb16f4f435caa1b_R_1 = _UV_eee149bb2a554c72a682890871dd2328_Out_0[0];
            float _Split_3eaefb55a74c48c18fb16f4f435caa1b_G_2 = _UV_eee149bb2a554c72a682890871dd2328_Out_0[1];
            float _Split_3eaefb55a74c48c18fb16f4f435caa1b_B_3 = _UV_eee149bb2a554c72a682890871dd2328_Out_0[2];
            float _Split_3eaefb55a74c48c18fb16f4f435caa1b_A_4 = _UV_eee149bb2a554c72a682890871dd2328_Out_0[3];
            float _SimpleNoise_bf0709d2c0ff4974876f4f331d99f9a9_Out_2;
            Unity_SimpleNoise_float((_Split_3eaefb55a74c48c18fb16f4f435caa1b_G_2.xx), _Property_cb3a1e3de89b4726b9a0635fe0f3e2ea_Out_0, _SimpleNoise_bf0709d2c0ff4974876f4f331d99f9a9_Out_2);
            float _SimpleNoise_5c6b3e9b03c54e6d86996fa545240e32_Out_2;
            Unity_SimpleNoise_float((IN.TimeParameters.x.xx), 500, _SimpleNoise_5c6b3e9b03c54e6d86996fa545240e32_Out_2);
            float _RandomRange_54ec6d53bdce4eb3afb9fe52174ee719_Out_3;
            Unity_RandomRange_float((_SimpleNoise_5c6b3e9b03c54e6d86996fa545240e32_Out_2.xx), -1, 1, _RandomRange_54ec6d53bdce4eb3afb9fe52174ee719_Out_3);
            float _Multiply_727a0ba96b7a421e93aa3ce4bba6abbc_Out_2;
            Unity_Multiply_float_float(_SimpleNoise_bf0709d2c0ff4974876f4f331d99f9a9_Out_2, _RandomRange_54ec6d53bdce4eb3afb9fe52174ee719_Out_3, _Multiply_727a0ba96b7a421e93aa3ce4bba6abbc_Out_2);
            float2 _Vector2_1fdee0dada2f419bbbedb9288a55e0b6_Out_0 = float2(_Multiply_727a0ba96b7a421e93aa3ce4bba6abbc_Out_2, _Multiply_727a0ba96b7a421e93aa3ce4bba6abbc_Out_2);
            float2 _Add_314e2e2180f54f489047d1c6df3ce8c8_Out_2;
            Unity_Add_float2((_UV_c2208a01c68a4e36be52cea883d4fcdf_Out_0.xy), _Vector2_1fdee0dada2f419bbbedb9288a55e0b6_Out_0, _Add_314e2e2180f54f489047d1c6df3ce8c8_Out_2);
            float4 _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0 = SAMPLE_TEXTURE2D(_Property_746103c6d35a49b8a832a78a800c16db_Out_0.tex, _Property_746103c6d35a49b8a832a78a800c16db_Out_0.samplerstate, _Property_746103c6d35a49b8a832a78a800c16db_Out_0.GetTransformedUV(_Add_314e2e2180f54f489047d1c6df3ce8c8_Out_2));
            float _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_R_4 = _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0.r;
            float _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_G_5 = _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0.g;
            float _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_B_6 = _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0.b;
            float _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_A_7 = _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0.a;
            float4 _Branch_d826e821815e407cb7a1dccd0c75f9ed_Out_3;
            Unity_Branch_float4(_Comparison_e2a4fb5191904b1fb860567bcb12d930_Out_2, _SampleGradient_b0632de439cb477982e6944782bce099_Out_2, _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0, _Branch_d826e821815e407cb7a1dccd0c75f9ed_Out_3);
            float4 _Property_3972ba0c594d4f75a3dfcb9a1cf2c9fb_Out_0 = IsGammaSpace() ? LinearToSRGB(_Color) : _Color;
            float4 _Multiply_028af5f91b3d4eedac9f0ad17399bbce_Out_2;
            Unity_Multiply_float4_float4(_SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0, _Property_3972ba0c594d4f75a3dfcb9a1cf2c9fb_Out_0, _Multiply_028af5f91b3d4eedac9f0ad17399bbce_Out_2);
            float4 _Multiply_b9f22c9e2b5a4943960230312fde11e4_Out_2;
            Unity_Multiply_float4_float4(_Branch_d826e821815e407cb7a1dccd0c75f9ed_Out_3, _Multiply_028af5f91b3d4eedac9f0ad17399bbce_Out_2, _Multiply_b9f22c9e2b5a4943960230312fde11e4_Out_2);
            surface.Alpha = (_Multiply_b9f22c9e2b5a4943960230312fde11e4_Out_2).x;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.uv0 = input.texCoord0;
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthNormalsOnlyPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "ShadowCaster"
            Tags
            {
                "LightMode" = "ShadowCaster"
            }
        
        // Render State
        Cull Back
        ZTest LEqual
        ZWrite On
        ColorMask 0
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma multi_compile_instancing
        #pragma multi_compile _ DOTS_INSTANCING_ON
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        #pragma multi_compile_vertex _ _CASTING_PUNCTUAL_LIGHT_SHADOW
        // GraphKeywords: <None>
        
        // Defines
        
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_SHADOWCASTER
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 normalWS;
             float4 texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float4 uv0;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float4 interp1 : INTERP1;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.normalWS;
            output.interp1.xyzw =  input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.normalWS = input.interp0.xyz;
            output.texCoord0 = input.interp1.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _MainTex_TexelSize;
        float _Glitch;
        float4 _Color;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_MainTex);
        SAMPLER(sampler_MainTex);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Comparison_Greater_float(float A, float B, out float Out)
        {
            Out = A > B ? 1 : 0;
        }
        
        void Unity_Posterize_float4(float4 In, float4 Steps, out float4 Out)
        {
            Out = floor(In / (1 / Steps)) * (1 / Steps);
        }
        
        
        inline float Unity_SimpleNoise_RandomValue_float (float2 uv)
        {
            float angle = dot(uv, float2(12.9898, 78.233));
            #if defined(SHADER_API_MOBILE) && (defined(SHADER_API_GLES) || defined(SHADER_API_GLES3) || defined(SHADER_API_VULKAN))
                // 'sin()' has bad precision on Mali GPUs for inputs > 10000
                angle = fmod(angle, TWO_PI); // Avoid large inputs to sin()
            #endif
            return frac(sin(angle)*43758.5453);
        }
        
        inline float Unity_SimpleNnoise_Interpolate_float (float a, float b, float t)
        {
            return (1.0-t)*a + (t*b);
        }
        
        
        inline float Unity_SimpleNoise_ValueNoise_float (float2 uv)
        {
            float2 i = floor(uv);
            float2 f = frac(uv);
            f = f * f * (3.0 - 2.0 * f);
        
            uv = abs(frac(uv) - 0.5);
            float2 c0 = i + float2(0.0, 0.0);
            float2 c1 = i + float2(1.0, 0.0);
            float2 c2 = i + float2(0.0, 1.0);
            float2 c3 = i + float2(1.0, 1.0);
            float r0 = Unity_SimpleNoise_RandomValue_float(c0);
            float r1 = Unity_SimpleNoise_RandomValue_float(c1);
            float r2 = Unity_SimpleNoise_RandomValue_float(c2);
            float r3 = Unity_SimpleNoise_RandomValue_float(c3);
        
            float bottomOfGrid = Unity_SimpleNnoise_Interpolate_float(r0, r1, f.x);
            float topOfGrid = Unity_SimpleNnoise_Interpolate_float(r2, r3, f.x);
            float t = Unity_SimpleNnoise_Interpolate_float(bottomOfGrid, topOfGrid, f.y);
            return t;
        }
        void Unity_SimpleNoise_float(float2 UV, float Scale, out float Out)
        {
            float t = 0.0;
        
            float freq = pow(2.0, float(0));
            float amp = pow(0.5, float(3-0));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;
        
            freq = pow(2.0, float(1));
            amp = pow(0.5, float(3-1));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;
        
            freq = pow(2.0, float(2));
            amp = pow(0.5, float(3-2));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;
        
            Out = t;
        }
        
        void Unity_Fraction_float(float In, out float Out)
        {
            Out = frac(In);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_SampleGradientV1_float(Gradient Gradient, float Time, out float4 Out)
        {
            float3 color = Gradient.colors[0].rgb;
            [unroll]
            for (int c = 1; c < Gradient.colorsLength; c++)
            {
                float colorPos = saturate((Time - Gradient.colors[c - 1].w) / (Gradient.colors[c].w - Gradient.colors[c - 1].w)) * step(c, Gradient.colorsLength - 1);
                color = lerp(color, Gradient.colors[c].rgb, lerp(colorPos, step(0.01, colorPos), Gradient.type));
            }
        #ifdef UNITY_COLORSPACE_GAMMA
            color = LinearToSRGB(color);
        #endif
            float alpha = Gradient.alphas[0].x;
            [unroll]
            for (int a = 1; a < Gradient.alphasLength; a++)
            {
                float alphaPos = saturate((Time - Gradient.alphas[a - 1].y) / (Gradient.alphas[a].y - Gradient.alphas[a - 1].y)) * step(a, Gradient.alphasLength - 1);
                alpha = lerp(alpha, Gradient.alphas[a].x, lerp(alphaPos, step(0.01, alphaPos), Gradient.type));
            }
            Out = float4(color, alpha);
        }
        
        void Unity_RandomRange_float(float2 Seed, float Min, float Max, out float Out)
        {
             float randomno =  frac(sin(dot(Seed, float2(12.9898, 78.233)))*43758.5453);
             Out = lerp(Min, Max, randomno);
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _Property_cb3a1e3de89b4726b9a0635fe0f3e2ea_Out_0 = _Glitch;
            float _Comparison_e2a4fb5191904b1fb860567bcb12d930_Out_2;
            Unity_Comparison_Greater_float(_Property_cb3a1e3de89b4726b9a0635fe0f3e2ea_Out_0, 0, _Comparison_e2a4fb5191904b1fb860567bcb12d930_Out_2);
            float4 _UV_456b9c89fb434ceb9147a268bd819ba0_Out_0 = IN.uv0;
            float4 _Posterize_481d28d2b2fd4ddebcc686054f637b09_Out_2;
            Unity_Posterize_float4(_UV_456b9c89fb434ceb9147a268bd819ba0_Out_0, float4(12, 12, 12, 4), _Posterize_481d28d2b2fd4ddebcc686054f637b09_Out_2);
            float _SimpleNoise_cde6ca44ddef403a842ed90a6ab8c4d0_Out_2;
            Unity_SimpleNoise_float((_Posterize_481d28d2b2fd4ddebcc686054f637b09_Out_2.xy), 500, _SimpleNoise_cde6ca44ddef403a842ed90a6ab8c4d0_Out_2);
            float _Fraction_e87d167ea39b41238b60af0940743fb4_Out_1;
            Unity_Fraction_float(_SimpleNoise_cde6ca44ddef403a842ed90a6ab8c4d0_Out_2, _Fraction_e87d167ea39b41238b60af0940743fb4_Out_1);
            float _Multiply_7518e7fe7f814122b4218e9236439ead_Out_2;
            Unity_Multiply_float_float(_Fraction_e87d167ea39b41238b60af0940743fb4_Out_1, IN.TimeParameters.x, _Multiply_7518e7fe7f814122b4218e9236439ead_Out_2);
            float _Fraction_89fde9a65c8a458994c8253f5c358b88_Out_1;
            Unity_Fraction_float(_Multiply_7518e7fe7f814122b4218e9236439ead_Out_2, _Fraction_89fde9a65c8a458994c8253f5c358b88_Out_1);
            float4 _SampleGradient_b0632de439cb477982e6944782bce099_Out_2;
            Unity_SampleGradientV1_float(NewGradient(0, 4, 2, float4(1, 1, 1, 0),float4(0.4150943, 0.1789946, 0, 0.3941253),float4(1, 0.8410894, 0, 0.6617685),float4(1, 1, 1, 1),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0), float2(1, 0),float2(1, 1),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0)), _Fraction_89fde9a65c8a458994c8253f5c358b88_Out_1, _SampleGradient_b0632de439cb477982e6944782bce099_Out_2);
            UnityTexture2D _Property_746103c6d35a49b8a832a78a800c16db_Out_0 = UnityBuildTexture2DStructNoScale(_MainTex);
            float4 _UV_c2208a01c68a4e36be52cea883d4fcdf_Out_0 = IN.uv0;
            float4 _UV_eee149bb2a554c72a682890871dd2328_Out_0 = IN.uv0;
            float _Split_3eaefb55a74c48c18fb16f4f435caa1b_R_1 = _UV_eee149bb2a554c72a682890871dd2328_Out_0[0];
            float _Split_3eaefb55a74c48c18fb16f4f435caa1b_G_2 = _UV_eee149bb2a554c72a682890871dd2328_Out_0[1];
            float _Split_3eaefb55a74c48c18fb16f4f435caa1b_B_3 = _UV_eee149bb2a554c72a682890871dd2328_Out_0[2];
            float _Split_3eaefb55a74c48c18fb16f4f435caa1b_A_4 = _UV_eee149bb2a554c72a682890871dd2328_Out_0[3];
            float _SimpleNoise_bf0709d2c0ff4974876f4f331d99f9a9_Out_2;
            Unity_SimpleNoise_float((_Split_3eaefb55a74c48c18fb16f4f435caa1b_G_2.xx), _Property_cb3a1e3de89b4726b9a0635fe0f3e2ea_Out_0, _SimpleNoise_bf0709d2c0ff4974876f4f331d99f9a9_Out_2);
            float _SimpleNoise_5c6b3e9b03c54e6d86996fa545240e32_Out_2;
            Unity_SimpleNoise_float((IN.TimeParameters.x.xx), 500, _SimpleNoise_5c6b3e9b03c54e6d86996fa545240e32_Out_2);
            float _RandomRange_54ec6d53bdce4eb3afb9fe52174ee719_Out_3;
            Unity_RandomRange_float((_SimpleNoise_5c6b3e9b03c54e6d86996fa545240e32_Out_2.xx), -1, 1, _RandomRange_54ec6d53bdce4eb3afb9fe52174ee719_Out_3);
            float _Multiply_727a0ba96b7a421e93aa3ce4bba6abbc_Out_2;
            Unity_Multiply_float_float(_SimpleNoise_bf0709d2c0ff4974876f4f331d99f9a9_Out_2, _RandomRange_54ec6d53bdce4eb3afb9fe52174ee719_Out_3, _Multiply_727a0ba96b7a421e93aa3ce4bba6abbc_Out_2);
            float2 _Vector2_1fdee0dada2f419bbbedb9288a55e0b6_Out_0 = float2(_Multiply_727a0ba96b7a421e93aa3ce4bba6abbc_Out_2, _Multiply_727a0ba96b7a421e93aa3ce4bba6abbc_Out_2);
            float2 _Add_314e2e2180f54f489047d1c6df3ce8c8_Out_2;
            Unity_Add_float2((_UV_c2208a01c68a4e36be52cea883d4fcdf_Out_0.xy), _Vector2_1fdee0dada2f419bbbedb9288a55e0b6_Out_0, _Add_314e2e2180f54f489047d1c6df3ce8c8_Out_2);
            float4 _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0 = SAMPLE_TEXTURE2D(_Property_746103c6d35a49b8a832a78a800c16db_Out_0.tex, _Property_746103c6d35a49b8a832a78a800c16db_Out_0.samplerstate, _Property_746103c6d35a49b8a832a78a800c16db_Out_0.GetTransformedUV(_Add_314e2e2180f54f489047d1c6df3ce8c8_Out_2));
            float _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_R_4 = _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0.r;
            float _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_G_5 = _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0.g;
            float _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_B_6 = _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0.b;
            float _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_A_7 = _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0.a;
            float4 _Branch_d826e821815e407cb7a1dccd0c75f9ed_Out_3;
            Unity_Branch_float4(_Comparison_e2a4fb5191904b1fb860567bcb12d930_Out_2, _SampleGradient_b0632de439cb477982e6944782bce099_Out_2, _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0, _Branch_d826e821815e407cb7a1dccd0c75f9ed_Out_3);
            float4 _Property_3972ba0c594d4f75a3dfcb9a1cf2c9fb_Out_0 = IsGammaSpace() ? LinearToSRGB(_Color) : _Color;
            float4 _Multiply_028af5f91b3d4eedac9f0ad17399bbce_Out_2;
            Unity_Multiply_float4_float4(_SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0, _Property_3972ba0c594d4f75a3dfcb9a1cf2c9fb_Out_0, _Multiply_028af5f91b3d4eedac9f0ad17399bbce_Out_2);
            float4 _Multiply_b9f22c9e2b5a4943960230312fde11e4_Out_2;
            Unity_Multiply_float4_float4(_Branch_d826e821815e407cb7a1dccd0c75f9ed_Out_3, _Multiply_028af5f91b3d4eedac9f0ad17399bbce_Out_2, _Multiply_b9f22c9e2b5a4943960230312fde11e4_Out_2);
            surface.Alpha = (_Multiply_b9f22c9e2b5a4943960230312fde11e4_Out_2).x;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.uv0 = input.texCoord0;
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "SceneSelectionPass"
            Tags
            {
                "LightMode" = "SceneSelectionPass"
            }
        
        // Render State
        Cull Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENESELECTIONPASS 1
        #define ALPHA_CLIP_THRESHOLD 1
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float4 uv0;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 interp0 : INTERP0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyzw =  input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.interp0.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _MainTex_TexelSize;
        float _Glitch;
        float4 _Color;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_MainTex);
        SAMPLER(sampler_MainTex);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Comparison_Greater_float(float A, float B, out float Out)
        {
            Out = A > B ? 1 : 0;
        }
        
        void Unity_Posterize_float4(float4 In, float4 Steps, out float4 Out)
        {
            Out = floor(In / (1 / Steps)) * (1 / Steps);
        }
        
        
        inline float Unity_SimpleNoise_RandomValue_float (float2 uv)
        {
            float angle = dot(uv, float2(12.9898, 78.233));
            #if defined(SHADER_API_MOBILE) && (defined(SHADER_API_GLES) || defined(SHADER_API_GLES3) || defined(SHADER_API_VULKAN))
                // 'sin()' has bad precision on Mali GPUs for inputs > 10000
                angle = fmod(angle, TWO_PI); // Avoid large inputs to sin()
            #endif
            return frac(sin(angle)*43758.5453);
        }
        
        inline float Unity_SimpleNnoise_Interpolate_float (float a, float b, float t)
        {
            return (1.0-t)*a + (t*b);
        }
        
        
        inline float Unity_SimpleNoise_ValueNoise_float (float2 uv)
        {
            float2 i = floor(uv);
            float2 f = frac(uv);
            f = f * f * (3.0 - 2.0 * f);
        
            uv = abs(frac(uv) - 0.5);
            float2 c0 = i + float2(0.0, 0.0);
            float2 c1 = i + float2(1.0, 0.0);
            float2 c2 = i + float2(0.0, 1.0);
            float2 c3 = i + float2(1.0, 1.0);
            float r0 = Unity_SimpleNoise_RandomValue_float(c0);
            float r1 = Unity_SimpleNoise_RandomValue_float(c1);
            float r2 = Unity_SimpleNoise_RandomValue_float(c2);
            float r3 = Unity_SimpleNoise_RandomValue_float(c3);
        
            float bottomOfGrid = Unity_SimpleNnoise_Interpolate_float(r0, r1, f.x);
            float topOfGrid = Unity_SimpleNnoise_Interpolate_float(r2, r3, f.x);
            float t = Unity_SimpleNnoise_Interpolate_float(bottomOfGrid, topOfGrid, f.y);
            return t;
        }
        void Unity_SimpleNoise_float(float2 UV, float Scale, out float Out)
        {
            float t = 0.0;
        
            float freq = pow(2.0, float(0));
            float amp = pow(0.5, float(3-0));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;
        
            freq = pow(2.0, float(1));
            amp = pow(0.5, float(3-1));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;
        
            freq = pow(2.0, float(2));
            amp = pow(0.5, float(3-2));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;
        
            Out = t;
        }
        
        void Unity_Fraction_float(float In, out float Out)
        {
            Out = frac(In);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_SampleGradientV1_float(Gradient Gradient, float Time, out float4 Out)
        {
            float3 color = Gradient.colors[0].rgb;
            [unroll]
            for (int c = 1; c < Gradient.colorsLength; c++)
            {
                float colorPos = saturate((Time - Gradient.colors[c - 1].w) / (Gradient.colors[c].w - Gradient.colors[c - 1].w)) * step(c, Gradient.colorsLength - 1);
                color = lerp(color, Gradient.colors[c].rgb, lerp(colorPos, step(0.01, colorPos), Gradient.type));
            }
        #ifdef UNITY_COLORSPACE_GAMMA
            color = LinearToSRGB(color);
        #endif
            float alpha = Gradient.alphas[0].x;
            [unroll]
            for (int a = 1; a < Gradient.alphasLength; a++)
            {
                float alphaPos = saturate((Time - Gradient.alphas[a - 1].y) / (Gradient.alphas[a].y - Gradient.alphas[a - 1].y)) * step(a, Gradient.alphasLength - 1);
                alpha = lerp(alpha, Gradient.alphas[a].x, lerp(alphaPos, step(0.01, alphaPos), Gradient.type));
            }
            Out = float4(color, alpha);
        }
        
        void Unity_RandomRange_float(float2 Seed, float Min, float Max, out float Out)
        {
             float randomno =  frac(sin(dot(Seed, float2(12.9898, 78.233)))*43758.5453);
             Out = lerp(Min, Max, randomno);
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _Property_cb3a1e3de89b4726b9a0635fe0f3e2ea_Out_0 = _Glitch;
            float _Comparison_e2a4fb5191904b1fb860567bcb12d930_Out_2;
            Unity_Comparison_Greater_float(_Property_cb3a1e3de89b4726b9a0635fe0f3e2ea_Out_0, 0, _Comparison_e2a4fb5191904b1fb860567bcb12d930_Out_2);
            float4 _UV_456b9c89fb434ceb9147a268bd819ba0_Out_0 = IN.uv0;
            float4 _Posterize_481d28d2b2fd4ddebcc686054f637b09_Out_2;
            Unity_Posterize_float4(_UV_456b9c89fb434ceb9147a268bd819ba0_Out_0, float4(12, 12, 12, 4), _Posterize_481d28d2b2fd4ddebcc686054f637b09_Out_2);
            float _SimpleNoise_cde6ca44ddef403a842ed90a6ab8c4d0_Out_2;
            Unity_SimpleNoise_float((_Posterize_481d28d2b2fd4ddebcc686054f637b09_Out_2.xy), 500, _SimpleNoise_cde6ca44ddef403a842ed90a6ab8c4d0_Out_2);
            float _Fraction_e87d167ea39b41238b60af0940743fb4_Out_1;
            Unity_Fraction_float(_SimpleNoise_cde6ca44ddef403a842ed90a6ab8c4d0_Out_2, _Fraction_e87d167ea39b41238b60af0940743fb4_Out_1);
            float _Multiply_7518e7fe7f814122b4218e9236439ead_Out_2;
            Unity_Multiply_float_float(_Fraction_e87d167ea39b41238b60af0940743fb4_Out_1, IN.TimeParameters.x, _Multiply_7518e7fe7f814122b4218e9236439ead_Out_2);
            float _Fraction_89fde9a65c8a458994c8253f5c358b88_Out_1;
            Unity_Fraction_float(_Multiply_7518e7fe7f814122b4218e9236439ead_Out_2, _Fraction_89fde9a65c8a458994c8253f5c358b88_Out_1);
            float4 _SampleGradient_b0632de439cb477982e6944782bce099_Out_2;
            Unity_SampleGradientV1_float(NewGradient(0, 4, 2, float4(1, 1, 1, 0),float4(0.4150943, 0.1789946, 0, 0.3941253),float4(1, 0.8410894, 0, 0.6617685),float4(1, 1, 1, 1),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0), float2(1, 0),float2(1, 1),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0)), _Fraction_89fde9a65c8a458994c8253f5c358b88_Out_1, _SampleGradient_b0632de439cb477982e6944782bce099_Out_2);
            UnityTexture2D _Property_746103c6d35a49b8a832a78a800c16db_Out_0 = UnityBuildTexture2DStructNoScale(_MainTex);
            float4 _UV_c2208a01c68a4e36be52cea883d4fcdf_Out_0 = IN.uv0;
            float4 _UV_eee149bb2a554c72a682890871dd2328_Out_0 = IN.uv0;
            float _Split_3eaefb55a74c48c18fb16f4f435caa1b_R_1 = _UV_eee149bb2a554c72a682890871dd2328_Out_0[0];
            float _Split_3eaefb55a74c48c18fb16f4f435caa1b_G_2 = _UV_eee149bb2a554c72a682890871dd2328_Out_0[1];
            float _Split_3eaefb55a74c48c18fb16f4f435caa1b_B_3 = _UV_eee149bb2a554c72a682890871dd2328_Out_0[2];
            float _Split_3eaefb55a74c48c18fb16f4f435caa1b_A_4 = _UV_eee149bb2a554c72a682890871dd2328_Out_0[3];
            float _SimpleNoise_bf0709d2c0ff4974876f4f331d99f9a9_Out_2;
            Unity_SimpleNoise_float((_Split_3eaefb55a74c48c18fb16f4f435caa1b_G_2.xx), _Property_cb3a1e3de89b4726b9a0635fe0f3e2ea_Out_0, _SimpleNoise_bf0709d2c0ff4974876f4f331d99f9a9_Out_2);
            float _SimpleNoise_5c6b3e9b03c54e6d86996fa545240e32_Out_2;
            Unity_SimpleNoise_float((IN.TimeParameters.x.xx), 500, _SimpleNoise_5c6b3e9b03c54e6d86996fa545240e32_Out_2);
            float _RandomRange_54ec6d53bdce4eb3afb9fe52174ee719_Out_3;
            Unity_RandomRange_float((_SimpleNoise_5c6b3e9b03c54e6d86996fa545240e32_Out_2.xx), -1, 1, _RandomRange_54ec6d53bdce4eb3afb9fe52174ee719_Out_3);
            float _Multiply_727a0ba96b7a421e93aa3ce4bba6abbc_Out_2;
            Unity_Multiply_float_float(_SimpleNoise_bf0709d2c0ff4974876f4f331d99f9a9_Out_2, _RandomRange_54ec6d53bdce4eb3afb9fe52174ee719_Out_3, _Multiply_727a0ba96b7a421e93aa3ce4bba6abbc_Out_2);
            float2 _Vector2_1fdee0dada2f419bbbedb9288a55e0b6_Out_0 = float2(_Multiply_727a0ba96b7a421e93aa3ce4bba6abbc_Out_2, _Multiply_727a0ba96b7a421e93aa3ce4bba6abbc_Out_2);
            float2 _Add_314e2e2180f54f489047d1c6df3ce8c8_Out_2;
            Unity_Add_float2((_UV_c2208a01c68a4e36be52cea883d4fcdf_Out_0.xy), _Vector2_1fdee0dada2f419bbbedb9288a55e0b6_Out_0, _Add_314e2e2180f54f489047d1c6df3ce8c8_Out_2);
            float4 _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0 = SAMPLE_TEXTURE2D(_Property_746103c6d35a49b8a832a78a800c16db_Out_0.tex, _Property_746103c6d35a49b8a832a78a800c16db_Out_0.samplerstate, _Property_746103c6d35a49b8a832a78a800c16db_Out_0.GetTransformedUV(_Add_314e2e2180f54f489047d1c6df3ce8c8_Out_2));
            float _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_R_4 = _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0.r;
            float _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_G_5 = _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0.g;
            float _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_B_6 = _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0.b;
            float _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_A_7 = _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0.a;
            float4 _Branch_d826e821815e407cb7a1dccd0c75f9ed_Out_3;
            Unity_Branch_float4(_Comparison_e2a4fb5191904b1fb860567bcb12d930_Out_2, _SampleGradient_b0632de439cb477982e6944782bce099_Out_2, _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0, _Branch_d826e821815e407cb7a1dccd0c75f9ed_Out_3);
            float4 _Property_3972ba0c594d4f75a3dfcb9a1cf2c9fb_Out_0 = IsGammaSpace() ? LinearToSRGB(_Color) : _Color;
            float4 _Multiply_028af5f91b3d4eedac9f0ad17399bbce_Out_2;
            Unity_Multiply_float4_float4(_SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0, _Property_3972ba0c594d4f75a3dfcb9a1cf2c9fb_Out_0, _Multiply_028af5f91b3d4eedac9f0ad17399bbce_Out_2);
            float4 _Multiply_b9f22c9e2b5a4943960230312fde11e4_Out_2;
            Unity_Multiply_float4_float4(_Branch_d826e821815e407cb7a1dccd0c75f9ed_Out_3, _Multiply_028af5f91b3d4eedac9f0ad17399bbce_Out_2, _Multiply_b9f22c9e2b5a4943960230312fde11e4_Out_2);
            surface.Alpha = (_Multiply_b9f22c9e2b5a4943960230312fde11e4_Out_2).x;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.uv0 = input.texCoord0;
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "ScenePickingPass"
            Tags
            {
                "LightMode" = "Picking"
            }
        
        // Render State
        Cull Back
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENEPICKINGPASS 1
        #define ALPHA_CLIP_THRESHOLD 1
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float4 uv0;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 interp0 : INTERP0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyzw =  input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.interp0.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _MainTex_TexelSize;
        float _Glitch;
        float4 _Color;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_MainTex);
        SAMPLER(sampler_MainTex);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Comparison_Greater_float(float A, float B, out float Out)
        {
            Out = A > B ? 1 : 0;
        }
        
        void Unity_Posterize_float4(float4 In, float4 Steps, out float4 Out)
        {
            Out = floor(In / (1 / Steps)) * (1 / Steps);
        }
        
        
        inline float Unity_SimpleNoise_RandomValue_float (float2 uv)
        {
            float angle = dot(uv, float2(12.9898, 78.233));
            #if defined(SHADER_API_MOBILE) && (defined(SHADER_API_GLES) || defined(SHADER_API_GLES3) || defined(SHADER_API_VULKAN))
                // 'sin()' has bad precision on Mali GPUs for inputs > 10000
                angle = fmod(angle, TWO_PI); // Avoid large inputs to sin()
            #endif
            return frac(sin(angle)*43758.5453);
        }
        
        inline float Unity_SimpleNnoise_Interpolate_float (float a, float b, float t)
        {
            return (1.0-t)*a + (t*b);
        }
        
        
        inline float Unity_SimpleNoise_ValueNoise_float (float2 uv)
        {
            float2 i = floor(uv);
            float2 f = frac(uv);
            f = f * f * (3.0 - 2.0 * f);
        
            uv = abs(frac(uv) - 0.5);
            float2 c0 = i + float2(0.0, 0.0);
            float2 c1 = i + float2(1.0, 0.0);
            float2 c2 = i + float2(0.0, 1.0);
            float2 c3 = i + float2(1.0, 1.0);
            float r0 = Unity_SimpleNoise_RandomValue_float(c0);
            float r1 = Unity_SimpleNoise_RandomValue_float(c1);
            float r2 = Unity_SimpleNoise_RandomValue_float(c2);
            float r3 = Unity_SimpleNoise_RandomValue_float(c3);
        
            float bottomOfGrid = Unity_SimpleNnoise_Interpolate_float(r0, r1, f.x);
            float topOfGrid = Unity_SimpleNnoise_Interpolate_float(r2, r3, f.x);
            float t = Unity_SimpleNnoise_Interpolate_float(bottomOfGrid, topOfGrid, f.y);
            return t;
        }
        void Unity_SimpleNoise_float(float2 UV, float Scale, out float Out)
        {
            float t = 0.0;
        
            float freq = pow(2.0, float(0));
            float amp = pow(0.5, float(3-0));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;
        
            freq = pow(2.0, float(1));
            amp = pow(0.5, float(3-1));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;
        
            freq = pow(2.0, float(2));
            amp = pow(0.5, float(3-2));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;
        
            Out = t;
        }
        
        void Unity_Fraction_float(float In, out float Out)
        {
            Out = frac(In);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_SampleGradientV1_float(Gradient Gradient, float Time, out float4 Out)
        {
            float3 color = Gradient.colors[0].rgb;
            [unroll]
            for (int c = 1; c < Gradient.colorsLength; c++)
            {
                float colorPos = saturate((Time - Gradient.colors[c - 1].w) / (Gradient.colors[c].w - Gradient.colors[c - 1].w)) * step(c, Gradient.colorsLength - 1);
                color = lerp(color, Gradient.colors[c].rgb, lerp(colorPos, step(0.01, colorPos), Gradient.type));
            }
        #ifdef UNITY_COLORSPACE_GAMMA
            color = LinearToSRGB(color);
        #endif
            float alpha = Gradient.alphas[0].x;
            [unroll]
            for (int a = 1; a < Gradient.alphasLength; a++)
            {
                float alphaPos = saturate((Time - Gradient.alphas[a - 1].y) / (Gradient.alphas[a].y - Gradient.alphas[a - 1].y)) * step(a, Gradient.alphasLength - 1);
                alpha = lerp(alpha, Gradient.alphas[a].x, lerp(alphaPos, step(0.01, alphaPos), Gradient.type));
            }
            Out = float4(color, alpha);
        }
        
        void Unity_RandomRange_float(float2 Seed, float Min, float Max, out float Out)
        {
             float randomno =  frac(sin(dot(Seed, float2(12.9898, 78.233)))*43758.5453);
             Out = lerp(Min, Max, randomno);
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _Property_cb3a1e3de89b4726b9a0635fe0f3e2ea_Out_0 = _Glitch;
            float _Comparison_e2a4fb5191904b1fb860567bcb12d930_Out_2;
            Unity_Comparison_Greater_float(_Property_cb3a1e3de89b4726b9a0635fe0f3e2ea_Out_0, 0, _Comparison_e2a4fb5191904b1fb860567bcb12d930_Out_2);
            float4 _UV_456b9c89fb434ceb9147a268bd819ba0_Out_0 = IN.uv0;
            float4 _Posterize_481d28d2b2fd4ddebcc686054f637b09_Out_2;
            Unity_Posterize_float4(_UV_456b9c89fb434ceb9147a268bd819ba0_Out_0, float4(12, 12, 12, 4), _Posterize_481d28d2b2fd4ddebcc686054f637b09_Out_2);
            float _SimpleNoise_cde6ca44ddef403a842ed90a6ab8c4d0_Out_2;
            Unity_SimpleNoise_float((_Posterize_481d28d2b2fd4ddebcc686054f637b09_Out_2.xy), 500, _SimpleNoise_cde6ca44ddef403a842ed90a6ab8c4d0_Out_2);
            float _Fraction_e87d167ea39b41238b60af0940743fb4_Out_1;
            Unity_Fraction_float(_SimpleNoise_cde6ca44ddef403a842ed90a6ab8c4d0_Out_2, _Fraction_e87d167ea39b41238b60af0940743fb4_Out_1);
            float _Multiply_7518e7fe7f814122b4218e9236439ead_Out_2;
            Unity_Multiply_float_float(_Fraction_e87d167ea39b41238b60af0940743fb4_Out_1, IN.TimeParameters.x, _Multiply_7518e7fe7f814122b4218e9236439ead_Out_2);
            float _Fraction_89fde9a65c8a458994c8253f5c358b88_Out_1;
            Unity_Fraction_float(_Multiply_7518e7fe7f814122b4218e9236439ead_Out_2, _Fraction_89fde9a65c8a458994c8253f5c358b88_Out_1);
            float4 _SampleGradient_b0632de439cb477982e6944782bce099_Out_2;
            Unity_SampleGradientV1_float(NewGradient(0, 4, 2, float4(1, 1, 1, 0),float4(0.4150943, 0.1789946, 0, 0.3941253),float4(1, 0.8410894, 0, 0.6617685),float4(1, 1, 1, 1),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0), float2(1, 0),float2(1, 1),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0)), _Fraction_89fde9a65c8a458994c8253f5c358b88_Out_1, _SampleGradient_b0632de439cb477982e6944782bce099_Out_2);
            UnityTexture2D _Property_746103c6d35a49b8a832a78a800c16db_Out_0 = UnityBuildTexture2DStructNoScale(_MainTex);
            float4 _UV_c2208a01c68a4e36be52cea883d4fcdf_Out_0 = IN.uv0;
            float4 _UV_eee149bb2a554c72a682890871dd2328_Out_0 = IN.uv0;
            float _Split_3eaefb55a74c48c18fb16f4f435caa1b_R_1 = _UV_eee149bb2a554c72a682890871dd2328_Out_0[0];
            float _Split_3eaefb55a74c48c18fb16f4f435caa1b_G_2 = _UV_eee149bb2a554c72a682890871dd2328_Out_0[1];
            float _Split_3eaefb55a74c48c18fb16f4f435caa1b_B_3 = _UV_eee149bb2a554c72a682890871dd2328_Out_0[2];
            float _Split_3eaefb55a74c48c18fb16f4f435caa1b_A_4 = _UV_eee149bb2a554c72a682890871dd2328_Out_0[3];
            float _SimpleNoise_bf0709d2c0ff4974876f4f331d99f9a9_Out_2;
            Unity_SimpleNoise_float((_Split_3eaefb55a74c48c18fb16f4f435caa1b_G_2.xx), _Property_cb3a1e3de89b4726b9a0635fe0f3e2ea_Out_0, _SimpleNoise_bf0709d2c0ff4974876f4f331d99f9a9_Out_2);
            float _SimpleNoise_5c6b3e9b03c54e6d86996fa545240e32_Out_2;
            Unity_SimpleNoise_float((IN.TimeParameters.x.xx), 500, _SimpleNoise_5c6b3e9b03c54e6d86996fa545240e32_Out_2);
            float _RandomRange_54ec6d53bdce4eb3afb9fe52174ee719_Out_3;
            Unity_RandomRange_float((_SimpleNoise_5c6b3e9b03c54e6d86996fa545240e32_Out_2.xx), -1, 1, _RandomRange_54ec6d53bdce4eb3afb9fe52174ee719_Out_3);
            float _Multiply_727a0ba96b7a421e93aa3ce4bba6abbc_Out_2;
            Unity_Multiply_float_float(_SimpleNoise_bf0709d2c0ff4974876f4f331d99f9a9_Out_2, _RandomRange_54ec6d53bdce4eb3afb9fe52174ee719_Out_3, _Multiply_727a0ba96b7a421e93aa3ce4bba6abbc_Out_2);
            float2 _Vector2_1fdee0dada2f419bbbedb9288a55e0b6_Out_0 = float2(_Multiply_727a0ba96b7a421e93aa3ce4bba6abbc_Out_2, _Multiply_727a0ba96b7a421e93aa3ce4bba6abbc_Out_2);
            float2 _Add_314e2e2180f54f489047d1c6df3ce8c8_Out_2;
            Unity_Add_float2((_UV_c2208a01c68a4e36be52cea883d4fcdf_Out_0.xy), _Vector2_1fdee0dada2f419bbbedb9288a55e0b6_Out_0, _Add_314e2e2180f54f489047d1c6df3ce8c8_Out_2);
            float4 _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0 = SAMPLE_TEXTURE2D(_Property_746103c6d35a49b8a832a78a800c16db_Out_0.tex, _Property_746103c6d35a49b8a832a78a800c16db_Out_0.samplerstate, _Property_746103c6d35a49b8a832a78a800c16db_Out_0.GetTransformedUV(_Add_314e2e2180f54f489047d1c6df3ce8c8_Out_2));
            float _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_R_4 = _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0.r;
            float _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_G_5 = _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0.g;
            float _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_B_6 = _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0.b;
            float _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_A_7 = _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0.a;
            float4 _Branch_d826e821815e407cb7a1dccd0c75f9ed_Out_3;
            Unity_Branch_float4(_Comparison_e2a4fb5191904b1fb860567bcb12d930_Out_2, _SampleGradient_b0632de439cb477982e6944782bce099_Out_2, _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0, _Branch_d826e821815e407cb7a1dccd0c75f9ed_Out_3);
            float4 _Property_3972ba0c594d4f75a3dfcb9a1cf2c9fb_Out_0 = IsGammaSpace() ? LinearToSRGB(_Color) : _Color;
            float4 _Multiply_028af5f91b3d4eedac9f0ad17399bbce_Out_2;
            Unity_Multiply_float4_float4(_SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0, _Property_3972ba0c594d4f75a3dfcb9a1cf2c9fb_Out_0, _Multiply_028af5f91b3d4eedac9f0ad17399bbce_Out_2);
            float4 _Multiply_b9f22c9e2b5a4943960230312fde11e4_Out_2;
            Unity_Multiply_float4_float4(_Branch_d826e821815e407cb7a1dccd0c75f9ed_Out_3, _Multiply_028af5f91b3d4eedac9f0ad17399bbce_Out_2, _Multiply_b9f22c9e2b5a4943960230312fde11e4_Out_2);
            surface.Alpha = (_Multiply_b9f22c9e2b5a4943960230312fde11e4_Out_2).x;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.uv0 = input.texCoord0;
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "DepthNormals"
            Tags
            {
                "LightMode" = "DepthNormalsOnly"
            }
        
        // Render State
        Cull Back
        ZTest LEqual
        ZWrite On
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma multi_compile_instancing
        #pragma multi_compile _ DOTS_INSTANCING_ON
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHNORMALSONLY
        #define _SURFACE_TYPE_TRANSPARENT 1
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 normalWS;
             float4 texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float4 uv0;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float4 interp1 : INTERP1;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.normalWS;
            output.interp1.xyzw =  input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.normalWS = input.interp0.xyz;
            output.texCoord0 = input.interp1.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _MainTex_TexelSize;
        float _Glitch;
        float4 _Color;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_MainTex);
        SAMPLER(sampler_MainTex);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Comparison_Greater_float(float A, float B, out float Out)
        {
            Out = A > B ? 1 : 0;
        }
        
        void Unity_Posterize_float4(float4 In, float4 Steps, out float4 Out)
        {
            Out = floor(In / (1 / Steps)) * (1 / Steps);
        }
        
        
        inline float Unity_SimpleNoise_RandomValue_float (float2 uv)
        {
            float angle = dot(uv, float2(12.9898, 78.233));
            #if defined(SHADER_API_MOBILE) && (defined(SHADER_API_GLES) || defined(SHADER_API_GLES3) || defined(SHADER_API_VULKAN))
                // 'sin()' has bad precision on Mali GPUs for inputs > 10000
                angle = fmod(angle, TWO_PI); // Avoid large inputs to sin()
            #endif
            return frac(sin(angle)*43758.5453);
        }
        
        inline float Unity_SimpleNnoise_Interpolate_float (float a, float b, float t)
        {
            return (1.0-t)*a + (t*b);
        }
        
        
        inline float Unity_SimpleNoise_ValueNoise_float (float2 uv)
        {
            float2 i = floor(uv);
            float2 f = frac(uv);
            f = f * f * (3.0 - 2.0 * f);
        
            uv = abs(frac(uv) - 0.5);
            float2 c0 = i + float2(0.0, 0.0);
            float2 c1 = i + float2(1.0, 0.0);
            float2 c2 = i + float2(0.0, 1.0);
            float2 c3 = i + float2(1.0, 1.0);
            float r0 = Unity_SimpleNoise_RandomValue_float(c0);
            float r1 = Unity_SimpleNoise_RandomValue_float(c1);
            float r2 = Unity_SimpleNoise_RandomValue_float(c2);
            float r3 = Unity_SimpleNoise_RandomValue_float(c3);
        
            float bottomOfGrid = Unity_SimpleNnoise_Interpolate_float(r0, r1, f.x);
            float topOfGrid = Unity_SimpleNnoise_Interpolate_float(r2, r3, f.x);
            float t = Unity_SimpleNnoise_Interpolate_float(bottomOfGrid, topOfGrid, f.y);
            return t;
        }
        void Unity_SimpleNoise_float(float2 UV, float Scale, out float Out)
        {
            float t = 0.0;
        
            float freq = pow(2.0, float(0));
            float amp = pow(0.5, float(3-0));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;
        
            freq = pow(2.0, float(1));
            amp = pow(0.5, float(3-1));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;
        
            freq = pow(2.0, float(2));
            amp = pow(0.5, float(3-2));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;
        
            Out = t;
        }
        
        void Unity_Fraction_float(float In, out float Out)
        {
            Out = frac(In);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_SampleGradientV1_float(Gradient Gradient, float Time, out float4 Out)
        {
            float3 color = Gradient.colors[0].rgb;
            [unroll]
            for (int c = 1; c < Gradient.colorsLength; c++)
            {
                float colorPos = saturate((Time - Gradient.colors[c - 1].w) / (Gradient.colors[c].w - Gradient.colors[c - 1].w)) * step(c, Gradient.colorsLength - 1);
                color = lerp(color, Gradient.colors[c].rgb, lerp(colorPos, step(0.01, colorPos), Gradient.type));
            }
        #ifdef UNITY_COLORSPACE_GAMMA
            color = LinearToSRGB(color);
        #endif
            float alpha = Gradient.alphas[0].x;
            [unroll]
            for (int a = 1; a < Gradient.alphasLength; a++)
            {
                float alphaPos = saturate((Time - Gradient.alphas[a - 1].y) / (Gradient.alphas[a].y - Gradient.alphas[a - 1].y)) * step(a, Gradient.alphasLength - 1);
                alpha = lerp(alpha, Gradient.alphas[a].x, lerp(alphaPos, step(0.01, alphaPos), Gradient.type));
            }
            Out = float4(color, alpha);
        }
        
        void Unity_RandomRange_float(float2 Seed, float Min, float Max, out float Out)
        {
             float randomno =  frac(sin(dot(Seed, float2(12.9898, 78.233)))*43758.5453);
             Out = lerp(Min, Max, randomno);
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _Property_cb3a1e3de89b4726b9a0635fe0f3e2ea_Out_0 = _Glitch;
            float _Comparison_e2a4fb5191904b1fb860567bcb12d930_Out_2;
            Unity_Comparison_Greater_float(_Property_cb3a1e3de89b4726b9a0635fe0f3e2ea_Out_0, 0, _Comparison_e2a4fb5191904b1fb860567bcb12d930_Out_2);
            float4 _UV_456b9c89fb434ceb9147a268bd819ba0_Out_0 = IN.uv0;
            float4 _Posterize_481d28d2b2fd4ddebcc686054f637b09_Out_2;
            Unity_Posterize_float4(_UV_456b9c89fb434ceb9147a268bd819ba0_Out_0, float4(12, 12, 12, 4), _Posterize_481d28d2b2fd4ddebcc686054f637b09_Out_2);
            float _SimpleNoise_cde6ca44ddef403a842ed90a6ab8c4d0_Out_2;
            Unity_SimpleNoise_float((_Posterize_481d28d2b2fd4ddebcc686054f637b09_Out_2.xy), 500, _SimpleNoise_cde6ca44ddef403a842ed90a6ab8c4d0_Out_2);
            float _Fraction_e87d167ea39b41238b60af0940743fb4_Out_1;
            Unity_Fraction_float(_SimpleNoise_cde6ca44ddef403a842ed90a6ab8c4d0_Out_2, _Fraction_e87d167ea39b41238b60af0940743fb4_Out_1);
            float _Multiply_7518e7fe7f814122b4218e9236439ead_Out_2;
            Unity_Multiply_float_float(_Fraction_e87d167ea39b41238b60af0940743fb4_Out_1, IN.TimeParameters.x, _Multiply_7518e7fe7f814122b4218e9236439ead_Out_2);
            float _Fraction_89fde9a65c8a458994c8253f5c358b88_Out_1;
            Unity_Fraction_float(_Multiply_7518e7fe7f814122b4218e9236439ead_Out_2, _Fraction_89fde9a65c8a458994c8253f5c358b88_Out_1);
            float4 _SampleGradient_b0632de439cb477982e6944782bce099_Out_2;
            Unity_SampleGradientV1_float(NewGradient(0, 4, 2, float4(1, 1, 1, 0),float4(0.4150943, 0.1789946, 0, 0.3941253),float4(1, 0.8410894, 0, 0.6617685),float4(1, 1, 1, 1),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0), float2(1, 0),float2(1, 1),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0)), _Fraction_89fde9a65c8a458994c8253f5c358b88_Out_1, _SampleGradient_b0632de439cb477982e6944782bce099_Out_2);
            UnityTexture2D _Property_746103c6d35a49b8a832a78a800c16db_Out_0 = UnityBuildTexture2DStructNoScale(_MainTex);
            float4 _UV_c2208a01c68a4e36be52cea883d4fcdf_Out_0 = IN.uv0;
            float4 _UV_eee149bb2a554c72a682890871dd2328_Out_0 = IN.uv0;
            float _Split_3eaefb55a74c48c18fb16f4f435caa1b_R_1 = _UV_eee149bb2a554c72a682890871dd2328_Out_0[0];
            float _Split_3eaefb55a74c48c18fb16f4f435caa1b_G_2 = _UV_eee149bb2a554c72a682890871dd2328_Out_0[1];
            float _Split_3eaefb55a74c48c18fb16f4f435caa1b_B_3 = _UV_eee149bb2a554c72a682890871dd2328_Out_0[2];
            float _Split_3eaefb55a74c48c18fb16f4f435caa1b_A_4 = _UV_eee149bb2a554c72a682890871dd2328_Out_0[3];
            float _SimpleNoise_bf0709d2c0ff4974876f4f331d99f9a9_Out_2;
            Unity_SimpleNoise_float((_Split_3eaefb55a74c48c18fb16f4f435caa1b_G_2.xx), _Property_cb3a1e3de89b4726b9a0635fe0f3e2ea_Out_0, _SimpleNoise_bf0709d2c0ff4974876f4f331d99f9a9_Out_2);
            float _SimpleNoise_5c6b3e9b03c54e6d86996fa545240e32_Out_2;
            Unity_SimpleNoise_float((IN.TimeParameters.x.xx), 500, _SimpleNoise_5c6b3e9b03c54e6d86996fa545240e32_Out_2);
            float _RandomRange_54ec6d53bdce4eb3afb9fe52174ee719_Out_3;
            Unity_RandomRange_float((_SimpleNoise_5c6b3e9b03c54e6d86996fa545240e32_Out_2.xx), -1, 1, _RandomRange_54ec6d53bdce4eb3afb9fe52174ee719_Out_3);
            float _Multiply_727a0ba96b7a421e93aa3ce4bba6abbc_Out_2;
            Unity_Multiply_float_float(_SimpleNoise_bf0709d2c0ff4974876f4f331d99f9a9_Out_2, _RandomRange_54ec6d53bdce4eb3afb9fe52174ee719_Out_3, _Multiply_727a0ba96b7a421e93aa3ce4bba6abbc_Out_2);
            float2 _Vector2_1fdee0dada2f419bbbedb9288a55e0b6_Out_0 = float2(_Multiply_727a0ba96b7a421e93aa3ce4bba6abbc_Out_2, _Multiply_727a0ba96b7a421e93aa3ce4bba6abbc_Out_2);
            float2 _Add_314e2e2180f54f489047d1c6df3ce8c8_Out_2;
            Unity_Add_float2((_UV_c2208a01c68a4e36be52cea883d4fcdf_Out_0.xy), _Vector2_1fdee0dada2f419bbbedb9288a55e0b6_Out_0, _Add_314e2e2180f54f489047d1c6df3ce8c8_Out_2);
            float4 _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0 = SAMPLE_TEXTURE2D(_Property_746103c6d35a49b8a832a78a800c16db_Out_0.tex, _Property_746103c6d35a49b8a832a78a800c16db_Out_0.samplerstate, _Property_746103c6d35a49b8a832a78a800c16db_Out_0.GetTransformedUV(_Add_314e2e2180f54f489047d1c6df3ce8c8_Out_2));
            float _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_R_4 = _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0.r;
            float _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_G_5 = _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0.g;
            float _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_B_6 = _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0.b;
            float _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_A_7 = _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0.a;
            float4 _Branch_d826e821815e407cb7a1dccd0c75f9ed_Out_3;
            Unity_Branch_float4(_Comparison_e2a4fb5191904b1fb860567bcb12d930_Out_2, _SampleGradient_b0632de439cb477982e6944782bce099_Out_2, _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0, _Branch_d826e821815e407cb7a1dccd0c75f9ed_Out_3);
            float4 _Property_3972ba0c594d4f75a3dfcb9a1cf2c9fb_Out_0 = IsGammaSpace() ? LinearToSRGB(_Color) : _Color;
            float4 _Multiply_028af5f91b3d4eedac9f0ad17399bbce_Out_2;
            Unity_Multiply_float4_float4(_SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0, _Property_3972ba0c594d4f75a3dfcb9a1cf2c9fb_Out_0, _Multiply_028af5f91b3d4eedac9f0ad17399bbce_Out_2);
            float4 _Multiply_b9f22c9e2b5a4943960230312fde11e4_Out_2;
            Unity_Multiply_float4_float4(_Branch_d826e821815e407cb7a1dccd0c75f9ed_Out_3, _Multiply_028af5f91b3d4eedac9f0ad17399bbce_Out_2, _Multiply_b9f22c9e2b5a4943960230312fde11e4_Out_2);
            surface.Alpha = (_Multiply_b9f22c9e2b5a4943960230312fde11e4_Out_2).x;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.uv0 = input.texCoord0;
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthNormalsOnlyPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
    }
    SubShader
    {
        Tags
        {
            "RenderPipeline"="UniversalPipeline"
            "RenderType"="Transparent"
            "UniversalMaterialType" = "Unlit"
            "Queue"="Transparent"
            "ShaderGraphShader"="true"
            "ShaderGraphTargetId"="UniversalUnlitSubTarget"
        }
        Pass
        {
            Name "Universal Forward"
            Tags
            {
                // LightMode: <None>
            }
        
        // Render State
        Cull Back
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
        ZTest LEqual
        ZWrite Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma only_renderers gles gles3 glcore d3d11
        #pragma multi_compile_instancing
        #pragma multi_compile_fog
        #pragma instancing_options renderinglayer
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma shader_feature _ _SAMPLE_GI
        #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
        #pragma multi_compile_fragment _ DEBUG_DISPLAY
        // GraphKeywords: <None>
        
        // Defines
        
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_VIEWDIRECTION_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_UNLIT
        #define _FOG_FRAGMENT 1
        #define _SURFACE_TYPE_TRANSPARENT 1
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 texCoord0;
             float3 viewDirectionWS;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float4 uv0;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float3 interp1 : INTERP1;
             float4 interp2 : INTERP2;
             float3 interp3 : INTERP3;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyz =  input.normalWS;
            output.interp2.xyzw =  input.texCoord0;
            output.interp3.xyz =  input.viewDirectionWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.normalWS = input.interp1.xyz;
            output.texCoord0 = input.interp2.xyzw;
            output.viewDirectionWS = input.interp3.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _MainTex_TexelSize;
        float _Glitch;
        float4 _Color;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_MainTex);
        SAMPLER(sampler_MainTex);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Comparison_Greater_float(float A, float B, out float Out)
        {
            Out = A > B ? 1 : 0;
        }
        
        void Unity_Posterize_float4(float4 In, float4 Steps, out float4 Out)
        {
            Out = floor(In / (1 / Steps)) * (1 / Steps);
        }
        
        
        inline float Unity_SimpleNoise_RandomValue_float (float2 uv)
        {
            float angle = dot(uv, float2(12.9898, 78.233));
            #if defined(SHADER_API_MOBILE) && (defined(SHADER_API_GLES) || defined(SHADER_API_GLES3) || defined(SHADER_API_VULKAN))
                // 'sin()' has bad precision on Mali GPUs for inputs > 10000
                angle = fmod(angle, TWO_PI); // Avoid large inputs to sin()
            #endif
            return frac(sin(angle)*43758.5453);
        }
        
        inline float Unity_SimpleNnoise_Interpolate_float (float a, float b, float t)
        {
            return (1.0-t)*a + (t*b);
        }
        
        
        inline float Unity_SimpleNoise_ValueNoise_float (float2 uv)
        {
            float2 i = floor(uv);
            float2 f = frac(uv);
            f = f * f * (3.0 - 2.0 * f);
        
            uv = abs(frac(uv) - 0.5);
            float2 c0 = i + float2(0.0, 0.0);
            float2 c1 = i + float2(1.0, 0.0);
            float2 c2 = i + float2(0.0, 1.0);
            float2 c3 = i + float2(1.0, 1.0);
            float r0 = Unity_SimpleNoise_RandomValue_float(c0);
            float r1 = Unity_SimpleNoise_RandomValue_float(c1);
            float r2 = Unity_SimpleNoise_RandomValue_float(c2);
            float r3 = Unity_SimpleNoise_RandomValue_float(c3);
        
            float bottomOfGrid = Unity_SimpleNnoise_Interpolate_float(r0, r1, f.x);
            float topOfGrid = Unity_SimpleNnoise_Interpolate_float(r2, r3, f.x);
            float t = Unity_SimpleNnoise_Interpolate_float(bottomOfGrid, topOfGrid, f.y);
            return t;
        }
        void Unity_SimpleNoise_float(float2 UV, float Scale, out float Out)
        {
            float t = 0.0;
        
            float freq = pow(2.0, float(0));
            float amp = pow(0.5, float(3-0));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;
        
            freq = pow(2.0, float(1));
            amp = pow(0.5, float(3-1));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;
        
            freq = pow(2.0, float(2));
            amp = pow(0.5, float(3-2));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;
        
            Out = t;
        }
        
        void Unity_Fraction_float(float In, out float Out)
        {
            Out = frac(In);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_SampleGradientV1_float(Gradient Gradient, float Time, out float4 Out)
        {
            float3 color = Gradient.colors[0].rgb;
            [unroll]
            for (int c = 1; c < Gradient.colorsLength; c++)
            {
                float colorPos = saturate((Time - Gradient.colors[c - 1].w) / (Gradient.colors[c].w - Gradient.colors[c - 1].w)) * step(c, Gradient.colorsLength - 1);
                color = lerp(color, Gradient.colors[c].rgb, lerp(colorPos, step(0.01, colorPos), Gradient.type));
            }
        #ifdef UNITY_COLORSPACE_GAMMA
            color = LinearToSRGB(color);
        #endif
            float alpha = Gradient.alphas[0].x;
            [unroll]
            for (int a = 1; a < Gradient.alphasLength; a++)
            {
                float alphaPos = saturate((Time - Gradient.alphas[a - 1].y) / (Gradient.alphas[a].y - Gradient.alphas[a - 1].y)) * step(a, Gradient.alphasLength - 1);
                alpha = lerp(alpha, Gradient.alphas[a].x, lerp(alphaPos, step(0.01, alphaPos), Gradient.type));
            }
            Out = float4(color, alpha);
        }
        
        void Unity_RandomRange_float(float2 Seed, float Min, float Max, out float Out)
        {
             float randomno =  frac(sin(dot(Seed, float2(12.9898, 78.233)))*43758.5453);
             Out = lerp(Min, Max, randomno);
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _Property_cb3a1e3de89b4726b9a0635fe0f3e2ea_Out_0 = _Glitch;
            float _Comparison_e2a4fb5191904b1fb860567bcb12d930_Out_2;
            Unity_Comparison_Greater_float(_Property_cb3a1e3de89b4726b9a0635fe0f3e2ea_Out_0, 0, _Comparison_e2a4fb5191904b1fb860567bcb12d930_Out_2);
            float4 _UV_456b9c89fb434ceb9147a268bd819ba0_Out_0 = IN.uv0;
            float4 _Posterize_481d28d2b2fd4ddebcc686054f637b09_Out_2;
            Unity_Posterize_float4(_UV_456b9c89fb434ceb9147a268bd819ba0_Out_0, float4(12, 12, 12, 4), _Posterize_481d28d2b2fd4ddebcc686054f637b09_Out_2);
            float _SimpleNoise_cde6ca44ddef403a842ed90a6ab8c4d0_Out_2;
            Unity_SimpleNoise_float((_Posterize_481d28d2b2fd4ddebcc686054f637b09_Out_2.xy), 500, _SimpleNoise_cde6ca44ddef403a842ed90a6ab8c4d0_Out_2);
            float _Fraction_e87d167ea39b41238b60af0940743fb4_Out_1;
            Unity_Fraction_float(_SimpleNoise_cde6ca44ddef403a842ed90a6ab8c4d0_Out_2, _Fraction_e87d167ea39b41238b60af0940743fb4_Out_1);
            float _Multiply_7518e7fe7f814122b4218e9236439ead_Out_2;
            Unity_Multiply_float_float(_Fraction_e87d167ea39b41238b60af0940743fb4_Out_1, IN.TimeParameters.x, _Multiply_7518e7fe7f814122b4218e9236439ead_Out_2);
            float _Fraction_89fde9a65c8a458994c8253f5c358b88_Out_1;
            Unity_Fraction_float(_Multiply_7518e7fe7f814122b4218e9236439ead_Out_2, _Fraction_89fde9a65c8a458994c8253f5c358b88_Out_1);
            float4 _SampleGradient_b0632de439cb477982e6944782bce099_Out_2;
            Unity_SampleGradientV1_float(NewGradient(0, 4, 2, float4(1, 1, 1, 0),float4(0.4150943, 0.1789946, 0, 0.3941253),float4(1, 0.8410894, 0, 0.6617685),float4(1, 1, 1, 1),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0), float2(1, 0),float2(1, 1),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0)), _Fraction_89fde9a65c8a458994c8253f5c358b88_Out_1, _SampleGradient_b0632de439cb477982e6944782bce099_Out_2);
            UnityTexture2D _Property_746103c6d35a49b8a832a78a800c16db_Out_0 = UnityBuildTexture2DStructNoScale(_MainTex);
            float4 _UV_c2208a01c68a4e36be52cea883d4fcdf_Out_0 = IN.uv0;
            float4 _UV_eee149bb2a554c72a682890871dd2328_Out_0 = IN.uv0;
            float _Split_3eaefb55a74c48c18fb16f4f435caa1b_R_1 = _UV_eee149bb2a554c72a682890871dd2328_Out_0[0];
            float _Split_3eaefb55a74c48c18fb16f4f435caa1b_G_2 = _UV_eee149bb2a554c72a682890871dd2328_Out_0[1];
            float _Split_3eaefb55a74c48c18fb16f4f435caa1b_B_3 = _UV_eee149bb2a554c72a682890871dd2328_Out_0[2];
            float _Split_3eaefb55a74c48c18fb16f4f435caa1b_A_4 = _UV_eee149bb2a554c72a682890871dd2328_Out_0[3];
            float _SimpleNoise_bf0709d2c0ff4974876f4f331d99f9a9_Out_2;
            Unity_SimpleNoise_float((_Split_3eaefb55a74c48c18fb16f4f435caa1b_G_2.xx), _Property_cb3a1e3de89b4726b9a0635fe0f3e2ea_Out_0, _SimpleNoise_bf0709d2c0ff4974876f4f331d99f9a9_Out_2);
            float _SimpleNoise_5c6b3e9b03c54e6d86996fa545240e32_Out_2;
            Unity_SimpleNoise_float((IN.TimeParameters.x.xx), 500, _SimpleNoise_5c6b3e9b03c54e6d86996fa545240e32_Out_2);
            float _RandomRange_54ec6d53bdce4eb3afb9fe52174ee719_Out_3;
            Unity_RandomRange_float((_SimpleNoise_5c6b3e9b03c54e6d86996fa545240e32_Out_2.xx), -1, 1, _RandomRange_54ec6d53bdce4eb3afb9fe52174ee719_Out_3);
            float _Multiply_727a0ba96b7a421e93aa3ce4bba6abbc_Out_2;
            Unity_Multiply_float_float(_SimpleNoise_bf0709d2c0ff4974876f4f331d99f9a9_Out_2, _RandomRange_54ec6d53bdce4eb3afb9fe52174ee719_Out_3, _Multiply_727a0ba96b7a421e93aa3ce4bba6abbc_Out_2);
            float2 _Vector2_1fdee0dada2f419bbbedb9288a55e0b6_Out_0 = float2(_Multiply_727a0ba96b7a421e93aa3ce4bba6abbc_Out_2, _Multiply_727a0ba96b7a421e93aa3ce4bba6abbc_Out_2);
            float2 _Add_314e2e2180f54f489047d1c6df3ce8c8_Out_2;
            Unity_Add_float2((_UV_c2208a01c68a4e36be52cea883d4fcdf_Out_0.xy), _Vector2_1fdee0dada2f419bbbedb9288a55e0b6_Out_0, _Add_314e2e2180f54f489047d1c6df3ce8c8_Out_2);
            float4 _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0 = SAMPLE_TEXTURE2D(_Property_746103c6d35a49b8a832a78a800c16db_Out_0.tex, _Property_746103c6d35a49b8a832a78a800c16db_Out_0.samplerstate, _Property_746103c6d35a49b8a832a78a800c16db_Out_0.GetTransformedUV(_Add_314e2e2180f54f489047d1c6df3ce8c8_Out_2));
            float _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_R_4 = _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0.r;
            float _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_G_5 = _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0.g;
            float _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_B_6 = _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0.b;
            float _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_A_7 = _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0.a;
            float4 _Branch_d826e821815e407cb7a1dccd0c75f9ed_Out_3;
            Unity_Branch_float4(_Comparison_e2a4fb5191904b1fb860567bcb12d930_Out_2, _SampleGradient_b0632de439cb477982e6944782bce099_Out_2, _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0, _Branch_d826e821815e407cb7a1dccd0c75f9ed_Out_3);
            float4 _Property_3972ba0c594d4f75a3dfcb9a1cf2c9fb_Out_0 = IsGammaSpace() ? LinearToSRGB(_Color) : _Color;
            float4 _Multiply_028af5f91b3d4eedac9f0ad17399bbce_Out_2;
            Unity_Multiply_float4_float4(_SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0, _Property_3972ba0c594d4f75a3dfcb9a1cf2c9fb_Out_0, _Multiply_028af5f91b3d4eedac9f0ad17399bbce_Out_2);
            float4 _Multiply_b9f22c9e2b5a4943960230312fde11e4_Out_2;
            Unity_Multiply_float4_float4(_Branch_d826e821815e407cb7a1dccd0c75f9ed_Out_3, _Multiply_028af5f91b3d4eedac9f0ad17399bbce_Out_2, _Multiply_b9f22c9e2b5a4943960230312fde11e4_Out_2);
            surface.BaseColor = (_Multiply_b9f22c9e2b5a4943960230312fde11e4_Out_2.xyz);
            surface.Alpha = (_Multiply_b9f22c9e2b5a4943960230312fde11e4_Out_2).x;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.uv0 = input.texCoord0;
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/UnlitPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "DepthNormalsOnly"
            Tags
            {
                "LightMode" = "DepthNormalsOnly"
            }
        
        // Render State
        Cull Back
        ZTest LEqual
        ZWrite On
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma only_renderers gles gles3 glcore d3d11
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHNORMALSONLY
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float4 uv0;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float4 interp1 : INTERP1;
             float4 interp2 : INTERP2;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.normalWS;
            output.interp1.xyzw =  input.tangentWS;
            output.interp2.xyzw =  input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.normalWS = input.interp0.xyz;
            output.tangentWS = input.interp1.xyzw;
            output.texCoord0 = input.interp2.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _MainTex_TexelSize;
        float _Glitch;
        float4 _Color;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_MainTex);
        SAMPLER(sampler_MainTex);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Comparison_Greater_float(float A, float B, out float Out)
        {
            Out = A > B ? 1 : 0;
        }
        
        void Unity_Posterize_float4(float4 In, float4 Steps, out float4 Out)
        {
            Out = floor(In / (1 / Steps)) * (1 / Steps);
        }
        
        
        inline float Unity_SimpleNoise_RandomValue_float (float2 uv)
        {
            float angle = dot(uv, float2(12.9898, 78.233));
            #if defined(SHADER_API_MOBILE) && (defined(SHADER_API_GLES) || defined(SHADER_API_GLES3) || defined(SHADER_API_VULKAN))
                // 'sin()' has bad precision on Mali GPUs for inputs > 10000
                angle = fmod(angle, TWO_PI); // Avoid large inputs to sin()
            #endif
            return frac(sin(angle)*43758.5453);
        }
        
        inline float Unity_SimpleNnoise_Interpolate_float (float a, float b, float t)
        {
            return (1.0-t)*a + (t*b);
        }
        
        
        inline float Unity_SimpleNoise_ValueNoise_float (float2 uv)
        {
            float2 i = floor(uv);
            float2 f = frac(uv);
            f = f * f * (3.0 - 2.0 * f);
        
            uv = abs(frac(uv) - 0.5);
            float2 c0 = i + float2(0.0, 0.0);
            float2 c1 = i + float2(1.0, 0.0);
            float2 c2 = i + float2(0.0, 1.0);
            float2 c3 = i + float2(1.0, 1.0);
            float r0 = Unity_SimpleNoise_RandomValue_float(c0);
            float r1 = Unity_SimpleNoise_RandomValue_float(c1);
            float r2 = Unity_SimpleNoise_RandomValue_float(c2);
            float r3 = Unity_SimpleNoise_RandomValue_float(c3);
        
            float bottomOfGrid = Unity_SimpleNnoise_Interpolate_float(r0, r1, f.x);
            float topOfGrid = Unity_SimpleNnoise_Interpolate_float(r2, r3, f.x);
            float t = Unity_SimpleNnoise_Interpolate_float(bottomOfGrid, topOfGrid, f.y);
            return t;
        }
        void Unity_SimpleNoise_float(float2 UV, float Scale, out float Out)
        {
            float t = 0.0;
        
            float freq = pow(2.0, float(0));
            float amp = pow(0.5, float(3-0));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;
        
            freq = pow(2.0, float(1));
            amp = pow(0.5, float(3-1));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;
        
            freq = pow(2.0, float(2));
            amp = pow(0.5, float(3-2));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;
        
            Out = t;
        }
        
        void Unity_Fraction_float(float In, out float Out)
        {
            Out = frac(In);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_SampleGradientV1_float(Gradient Gradient, float Time, out float4 Out)
        {
            float3 color = Gradient.colors[0].rgb;
            [unroll]
            for (int c = 1; c < Gradient.colorsLength; c++)
            {
                float colorPos = saturate((Time - Gradient.colors[c - 1].w) / (Gradient.colors[c].w - Gradient.colors[c - 1].w)) * step(c, Gradient.colorsLength - 1);
                color = lerp(color, Gradient.colors[c].rgb, lerp(colorPos, step(0.01, colorPos), Gradient.type));
            }
        #ifdef UNITY_COLORSPACE_GAMMA
            color = LinearToSRGB(color);
        #endif
            float alpha = Gradient.alphas[0].x;
            [unroll]
            for (int a = 1; a < Gradient.alphasLength; a++)
            {
                float alphaPos = saturate((Time - Gradient.alphas[a - 1].y) / (Gradient.alphas[a].y - Gradient.alphas[a - 1].y)) * step(a, Gradient.alphasLength - 1);
                alpha = lerp(alpha, Gradient.alphas[a].x, lerp(alphaPos, step(0.01, alphaPos), Gradient.type));
            }
            Out = float4(color, alpha);
        }
        
        void Unity_RandomRange_float(float2 Seed, float Min, float Max, out float Out)
        {
             float randomno =  frac(sin(dot(Seed, float2(12.9898, 78.233)))*43758.5453);
             Out = lerp(Min, Max, randomno);
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _Property_cb3a1e3de89b4726b9a0635fe0f3e2ea_Out_0 = _Glitch;
            float _Comparison_e2a4fb5191904b1fb860567bcb12d930_Out_2;
            Unity_Comparison_Greater_float(_Property_cb3a1e3de89b4726b9a0635fe0f3e2ea_Out_0, 0, _Comparison_e2a4fb5191904b1fb860567bcb12d930_Out_2);
            float4 _UV_456b9c89fb434ceb9147a268bd819ba0_Out_0 = IN.uv0;
            float4 _Posterize_481d28d2b2fd4ddebcc686054f637b09_Out_2;
            Unity_Posterize_float4(_UV_456b9c89fb434ceb9147a268bd819ba0_Out_0, float4(12, 12, 12, 4), _Posterize_481d28d2b2fd4ddebcc686054f637b09_Out_2);
            float _SimpleNoise_cde6ca44ddef403a842ed90a6ab8c4d0_Out_2;
            Unity_SimpleNoise_float((_Posterize_481d28d2b2fd4ddebcc686054f637b09_Out_2.xy), 500, _SimpleNoise_cde6ca44ddef403a842ed90a6ab8c4d0_Out_2);
            float _Fraction_e87d167ea39b41238b60af0940743fb4_Out_1;
            Unity_Fraction_float(_SimpleNoise_cde6ca44ddef403a842ed90a6ab8c4d0_Out_2, _Fraction_e87d167ea39b41238b60af0940743fb4_Out_1);
            float _Multiply_7518e7fe7f814122b4218e9236439ead_Out_2;
            Unity_Multiply_float_float(_Fraction_e87d167ea39b41238b60af0940743fb4_Out_1, IN.TimeParameters.x, _Multiply_7518e7fe7f814122b4218e9236439ead_Out_2);
            float _Fraction_89fde9a65c8a458994c8253f5c358b88_Out_1;
            Unity_Fraction_float(_Multiply_7518e7fe7f814122b4218e9236439ead_Out_2, _Fraction_89fde9a65c8a458994c8253f5c358b88_Out_1);
            float4 _SampleGradient_b0632de439cb477982e6944782bce099_Out_2;
            Unity_SampleGradientV1_float(NewGradient(0, 4, 2, float4(1, 1, 1, 0),float4(0.4150943, 0.1789946, 0, 0.3941253),float4(1, 0.8410894, 0, 0.6617685),float4(1, 1, 1, 1),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0), float2(1, 0),float2(1, 1),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0)), _Fraction_89fde9a65c8a458994c8253f5c358b88_Out_1, _SampleGradient_b0632de439cb477982e6944782bce099_Out_2);
            UnityTexture2D _Property_746103c6d35a49b8a832a78a800c16db_Out_0 = UnityBuildTexture2DStructNoScale(_MainTex);
            float4 _UV_c2208a01c68a4e36be52cea883d4fcdf_Out_0 = IN.uv0;
            float4 _UV_eee149bb2a554c72a682890871dd2328_Out_0 = IN.uv0;
            float _Split_3eaefb55a74c48c18fb16f4f435caa1b_R_1 = _UV_eee149bb2a554c72a682890871dd2328_Out_0[0];
            float _Split_3eaefb55a74c48c18fb16f4f435caa1b_G_2 = _UV_eee149bb2a554c72a682890871dd2328_Out_0[1];
            float _Split_3eaefb55a74c48c18fb16f4f435caa1b_B_3 = _UV_eee149bb2a554c72a682890871dd2328_Out_0[2];
            float _Split_3eaefb55a74c48c18fb16f4f435caa1b_A_4 = _UV_eee149bb2a554c72a682890871dd2328_Out_0[3];
            float _SimpleNoise_bf0709d2c0ff4974876f4f331d99f9a9_Out_2;
            Unity_SimpleNoise_float((_Split_3eaefb55a74c48c18fb16f4f435caa1b_G_2.xx), _Property_cb3a1e3de89b4726b9a0635fe0f3e2ea_Out_0, _SimpleNoise_bf0709d2c0ff4974876f4f331d99f9a9_Out_2);
            float _SimpleNoise_5c6b3e9b03c54e6d86996fa545240e32_Out_2;
            Unity_SimpleNoise_float((IN.TimeParameters.x.xx), 500, _SimpleNoise_5c6b3e9b03c54e6d86996fa545240e32_Out_2);
            float _RandomRange_54ec6d53bdce4eb3afb9fe52174ee719_Out_3;
            Unity_RandomRange_float((_SimpleNoise_5c6b3e9b03c54e6d86996fa545240e32_Out_2.xx), -1, 1, _RandomRange_54ec6d53bdce4eb3afb9fe52174ee719_Out_3);
            float _Multiply_727a0ba96b7a421e93aa3ce4bba6abbc_Out_2;
            Unity_Multiply_float_float(_SimpleNoise_bf0709d2c0ff4974876f4f331d99f9a9_Out_2, _RandomRange_54ec6d53bdce4eb3afb9fe52174ee719_Out_3, _Multiply_727a0ba96b7a421e93aa3ce4bba6abbc_Out_2);
            float2 _Vector2_1fdee0dada2f419bbbedb9288a55e0b6_Out_0 = float2(_Multiply_727a0ba96b7a421e93aa3ce4bba6abbc_Out_2, _Multiply_727a0ba96b7a421e93aa3ce4bba6abbc_Out_2);
            float2 _Add_314e2e2180f54f489047d1c6df3ce8c8_Out_2;
            Unity_Add_float2((_UV_c2208a01c68a4e36be52cea883d4fcdf_Out_0.xy), _Vector2_1fdee0dada2f419bbbedb9288a55e0b6_Out_0, _Add_314e2e2180f54f489047d1c6df3ce8c8_Out_2);
            float4 _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0 = SAMPLE_TEXTURE2D(_Property_746103c6d35a49b8a832a78a800c16db_Out_0.tex, _Property_746103c6d35a49b8a832a78a800c16db_Out_0.samplerstate, _Property_746103c6d35a49b8a832a78a800c16db_Out_0.GetTransformedUV(_Add_314e2e2180f54f489047d1c6df3ce8c8_Out_2));
            float _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_R_4 = _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0.r;
            float _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_G_5 = _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0.g;
            float _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_B_6 = _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0.b;
            float _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_A_7 = _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0.a;
            float4 _Branch_d826e821815e407cb7a1dccd0c75f9ed_Out_3;
            Unity_Branch_float4(_Comparison_e2a4fb5191904b1fb860567bcb12d930_Out_2, _SampleGradient_b0632de439cb477982e6944782bce099_Out_2, _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0, _Branch_d826e821815e407cb7a1dccd0c75f9ed_Out_3);
            float4 _Property_3972ba0c594d4f75a3dfcb9a1cf2c9fb_Out_0 = IsGammaSpace() ? LinearToSRGB(_Color) : _Color;
            float4 _Multiply_028af5f91b3d4eedac9f0ad17399bbce_Out_2;
            Unity_Multiply_float4_float4(_SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0, _Property_3972ba0c594d4f75a3dfcb9a1cf2c9fb_Out_0, _Multiply_028af5f91b3d4eedac9f0ad17399bbce_Out_2);
            float4 _Multiply_b9f22c9e2b5a4943960230312fde11e4_Out_2;
            Unity_Multiply_float4_float4(_Branch_d826e821815e407cb7a1dccd0c75f9ed_Out_3, _Multiply_028af5f91b3d4eedac9f0ad17399bbce_Out_2, _Multiply_b9f22c9e2b5a4943960230312fde11e4_Out_2);
            surface.Alpha = (_Multiply_b9f22c9e2b5a4943960230312fde11e4_Out_2).x;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.uv0 = input.texCoord0;
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthNormalsOnlyPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "ShadowCaster"
            Tags
            {
                "LightMode" = "ShadowCaster"
            }
        
        // Render State
        Cull Back
        ZTest LEqual
        ZWrite On
        ColorMask 0
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma only_renderers gles gles3 glcore d3d11
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        #pragma multi_compile_vertex _ _CASTING_PUNCTUAL_LIGHT_SHADOW
        // GraphKeywords: <None>
        
        // Defines
        
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_SHADOWCASTER
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 normalWS;
             float4 texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float4 uv0;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float4 interp1 : INTERP1;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.normalWS;
            output.interp1.xyzw =  input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.normalWS = input.interp0.xyz;
            output.texCoord0 = input.interp1.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _MainTex_TexelSize;
        float _Glitch;
        float4 _Color;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_MainTex);
        SAMPLER(sampler_MainTex);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Comparison_Greater_float(float A, float B, out float Out)
        {
            Out = A > B ? 1 : 0;
        }
        
        void Unity_Posterize_float4(float4 In, float4 Steps, out float4 Out)
        {
            Out = floor(In / (1 / Steps)) * (1 / Steps);
        }
        
        
        inline float Unity_SimpleNoise_RandomValue_float (float2 uv)
        {
            float angle = dot(uv, float2(12.9898, 78.233));
            #if defined(SHADER_API_MOBILE) && (defined(SHADER_API_GLES) || defined(SHADER_API_GLES3) || defined(SHADER_API_VULKAN))
                // 'sin()' has bad precision on Mali GPUs for inputs > 10000
                angle = fmod(angle, TWO_PI); // Avoid large inputs to sin()
            #endif
            return frac(sin(angle)*43758.5453);
        }
        
        inline float Unity_SimpleNnoise_Interpolate_float (float a, float b, float t)
        {
            return (1.0-t)*a + (t*b);
        }
        
        
        inline float Unity_SimpleNoise_ValueNoise_float (float2 uv)
        {
            float2 i = floor(uv);
            float2 f = frac(uv);
            f = f * f * (3.0 - 2.0 * f);
        
            uv = abs(frac(uv) - 0.5);
            float2 c0 = i + float2(0.0, 0.0);
            float2 c1 = i + float2(1.0, 0.0);
            float2 c2 = i + float2(0.0, 1.0);
            float2 c3 = i + float2(1.0, 1.0);
            float r0 = Unity_SimpleNoise_RandomValue_float(c0);
            float r1 = Unity_SimpleNoise_RandomValue_float(c1);
            float r2 = Unity_SimpleNoise_RandomValue_float(c2);
            float r3 = Unity_SimpleNoise_RandomValue_float(c3);
        
            float bottomOfGrid = Unity_SimpleNnoise_Interpolate_float(r0, r1, f.x);
            float topOfGrid = Unity_SimpleNnoise_Interpolate_float(r2, r3, f.x);
            float t = Unity_SimpleNnoise_Interpolate_float(bottomOfGrid, topOfGrid, f.y);
            return t;
        }
        void Unity_SimpleNoise_float(float2 UV, float Scale, out float Out)
        {
            float t = 0.0;
        
            float freq = pow(2.0, float(0));
            float amp = pow(0.5, float(3-0));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;
        
            freq = pow(2.0, float(1));
            amp = pow(0.5, float(3-1));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;
        
            freq = pow(2.0, float(2));
            amp = pow(0.5, float(3-2));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;
        
            Out = t;
        }
        
        void Unity_Fraction_float(float In, out float Out)
        {
            Out = frac(In);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_SampleGradientV1_float(Gradient Gradient, float Time, out float4 Out)
        {
            float3 color = Gradient.colors[0].rgb;
            [unroll]
            for (int c = 1; c < Gradient.colorsLength; c++)
            {
                float colorPos = saturate((Time - Gradient.colors[c - 1].w) / (Gradient.colors[c].w - Gradient.colors[c - 1].w)) * step(c, Gradient.colorsLength - 1);
                color = lerp(color, Gradient.colors[c].rgb, lerp(colorPos, step(0.01, colorPos), Gradient.type));
            }
        #ifdef UNITY_COLORSPACE_GAMMA
            color = LinearToSRGB(color);
        #endif
            float alpha = Gradient.alphas[0].x;
            [unroll]
            for (int a = 1; a < Gradient.alphasLength; a++)
            {
                float alphaPos = saturate((Time - Gradient.alphas[a - 1].y) / (Gradient.alphas[a].y - Gradient.alphas[a - 1].y)) * step(a, Gradient.alphasLength - 1);
                alpha = lerp(alpha, Gradient.alphas[a].x, lerp(alphaPos, step(0.01, alphaPos), Gradient.type));
            }
            Out = float4(color, alpha);
        }
        
        void Unity_RandomRange_float(float2 Seed, float Min, float Max, out float Out)
        {
             float randomno =  frac(sin(dot(Seed, float2(12.9898, 78.233)))*43758.5453);
             Out = lerp(Min, Max, randomno);
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _Property_cb3a1e3de89b4726b9a0635fe0f3e2ea_Out_0 = _Glitch;
            float _Comparison_e2a4fb5191904b1fb860567bcb12d930_Out_2;
            Unity_Comparison_Greater_float(_Property_cb3a1e3de89b4726b9a0635fe0f3e2ea_Out_0, 0, _Comparison_e2a4fb5191904b1fb860567bcb12d930_Out_2);
            float4 _UV_456b9c89fb434ceb9147a268bd819ba0_Out_0 = IN.uv0;
            float4 _Posterize_481d28d2b2fd4ddebcc686054f637b09_Out_2;
            Unity_Posterize_float4(_UV_456b9c89fb434ceb9147a268bd819ba0_Out_0, float4(12, 12, 12, 4), _Posterize_481d28d2b2fd4ddebcc686054f637b09_Out_2);
            float _SimpleNoise_cde6ca44ddef403a842ed90a6ab8c4d0_Out_2;
            Unity_SimpleNoise_float((_Posterize_481d28d2b2fd4ddebcc686054f637b09_Out_2.xy), 500, _SimpleNoise_cde6ca44ddef403a842ed90a6ab8c4d0_Out_2);
            float _Fraction_e87d167ea39b41238b60af0940743fb4_Out_1;
            Unity_Fraction_float(_SimpleNoise_cde6ca44ddef403a842ed90a6ab8c4d0_Out_2, _Fraction_e87d167ea39b41238b60af0940743fb4_Out_1);
            float _Multiply_7518e7fe7f814122b4218e9236439ead_Out_2;
            Unity_Multiply_float_float(_Fraction_e87d167ea39b41238b60af0940743fb4_Out_1, IN.TimeParameters.x, _Multiply_7518e7fe7f814122b4218e9236439ead_Out_2);
            float _Fraction_89fde9a65c8a458994c8253f5c358b88_Out_1;
            Unity_Fraction_float(_Multiply_7518e7fe7f814122b4218e9236439ead_Out_2, _Fraction_89fde9a65c8a458994c8253f5c358b88_Out_1);
            float4 _SampleGradient_b0632de439cb477982e6944782bce099_Out_2;
            Unity_SampleGradientV1_float(NewGradient(0, 4, 2, float4(1, 1, 1, 0),float4(0.4150943, 0.1789946, 0, 0.3941253),float4(1, 0.8410894, 0, 0.6617685),float4(1, 1, 1, 1),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0), float2(1, 0),float2(1, 1),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0)), _Fraction_89fde9a65c8a458994c8253f5c358b88_Out_1, _SampleGradient_b0632de439cb477982e6944782bce099_Out_2);
            UnityTexture2D _Property_746103c6d35a49b8a832a78a800c16db_Out_0 = UnityBuildTexture2DStructNoScale(_MainTex);
            float4 _UV_c2208a01c68a4e36be52cea883d4fcdf_Out_0 = IN.uv0;
            float4 _UV_eee149bb2a554c72a682890871dd2328_Out_0 = IN.uv0;
            float _Split_3eaefb55a74c48c18fb16f4f435caa1b_R_1 = _UV_eee149bb2a554c72a682890871dd2328_Out_0[0];
            float _Split_3eaefb55a74c48c18fb16f4f435caa1b_G_2 = _UV_eee149bb2a554c72a682890871dd2328_Out_0[1];
            float _Split_3eaefb55a74c48c18fb16f4f435caa1b_B_3 = _UV_eee149bb2a554c72a682890871dd2328_Out_0[2];
            float _Split_3eaefb55a74c48c18fb16f4f435caa1b_A_4 = _UV_eee149bb2a554c72a682890871dd2328_Out_0[3];
            float _SimpleNoise_bf0709d2c0ff4974876f4f331d99f9a9_Out_2;
            Unity_SimpleNoise_float((_Split_3eaefb55a74c48c18fb16f4f435caa1b_G_2.xx), _Property_cb3a1e3de89b4726b9a0635fe0f3e2ea_Out_0, _SimpleNoise_bf0709d2c0ff4974876f4f331d99f9a9_Out_2);
            float _SimpleNoise_5c6b3e9b03c54e6d86996fa545240e32_Out_2;
            Unity_SimpleNoise_float((IN.TimeParameters.x.xx), 500, _SimpleNoise_5c6b3e9b03c54e6d86996fa545240e32_Out_2);
            float _RandomRange_54ec6d53bdce4eb3afb9fe52174ee719_Out_3;
            Unity_RandomRange_float((_SimpleNoise_5c6b3e9b03c54e6d86996fa545240e32_Out_2.xx), -1, 1, _RandomRange_54ec6d53bdce4eb3afb9fe52174ee719_Out_3);
            float _Multiply_727a0ba96b7a421e93aa3ce4bba6abbc_Out_2;
            Unity_Multiply_float_float(_SimpleNoise_bf0709d2c0ff4974876f4f331d99f9a9_Out_2, _RandomRange_54ec6d53bdce4eb3afb9fe52174ee719_Out_3, _Multiply_727a0ba96b7a421e93aa3ce4bba6abbc_Out_2);
            float2 _Vector2_1fdee0dada2f419bbbedb9288a55e0b6_Out_0 = float2(_Multiply_727a0ba96b7a421e93aa3ce4bba6abbc_Out_2, _Multiply_727a0ba96b7a421e93aa3ce4bba6abbc_Out_2);
            float2 _Add_314e2e2180f54f489047d1c6df3ce8c8_Out_2;
            Unity_Add_float2((_UV_c2208a01c68a4e36be52cea883d4fcdf_Out_0.xy), _Vector2_1fdee0dada2f419bbbedb9288a55e0b6_Out_0, _Add_314e2e2180f54f489047d1c6df3ce8c8_Out_2);
            float4 _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0 = SAMPLE_TEXTURE2D(_Property_746103c6d35a49b8a832a78a800c16db_Out_0.tex, _Property_746103c6d35a49b8a832a78a800c16db_Out_0.samplerstate, _Property_746103c6d35a49b8a832a78a800c16db_Out_0.GetTransformedUV(_Add_314e2e2180f54f489047d1c6df3ce8c8_Out_2));
            float _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_R_4 = _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0.r;
            float _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_G_5 = _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0.g;
            float _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_B_6 = _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0.b;
            float _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_A_7 = _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0.a;
            float4 _Branch_d826e821815e407cb7a1dccd0c75f9ed_Out_3;
            Unity_Branch_float4(_Comparison_e2a4fb5191904b1fb860567bcb12d930_Out_2, _SampleGradient_b0632de439cb477982e6944782bce099_Out_2, _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0, _Branch_d826e821815e407cb7a1dccd0c75f9ed_Out_3);
            float4 _Property_3972ba0c594d4f75a3dfcb9a1cf2c9fb_Out_0 = IsGammaSpace() ? LinearToSRGB(_Color) : _Color;
            float4 _Multiply_028af5f91b3d4eedac9f0ad17399bbce_Out_2;
            Unity_Multiply_float4_float4(_SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0, _Property_3972ba0c594d4f75a3dfcb9a1cf2c9fb_Out_0, _Multiply_028af5f91b3d4eedac9f0ad17399bbce_Out_2);
            float4 _Multiply_b9f22c9e2b5a4943960230312fde11e4_Out_2;
            Unity_Multiply_float4_float4(_Branch_d826e821815e407cb7a1dccd0c75f9ed_Out_3, _Multiply_028af5f91b3d4eedac9f0ad17399bbce_Out_2, _Multiply_b9f22c9e2b5a4943960230312fde11e4_Out_2);
            surface.Alpha = (_Multiply_b9f22c9e2b5a4943960230312fde11e4_Out_2).x;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.uv0 = input.texCoord0;
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "SceneSelectionPass"
            Tags
            {
                "LightMode" = "SceneSelectionPass"
            }
        
        // Render State
        Cull Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma only_renderers gles gles3 glcore d3d11
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENESELECTIONPASS 1
        #define ALPHA_CLIP_THRESHOLD 1
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float4 uv0;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 interp0 : INTERP0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyzw =  input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.interp0.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _MainTex_TexelSize;
        float _Glitch;
        float4 _Color;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_MainTex);
        SAMPLER(sampler_MainTex);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Comparison_Greater_float(float A, float B, out float Out)
        {
            Out = A > B ? 1 : 0;
        }
        
        void Unity_Posterize_float4(float4 In, float4 Steps, out float4 Out)
        {
            Out = floor(In / (1 / Steps)) * (1 / Steps);
        }
        
        
        inline float Unity_SimpleNoise_RandomValue_float (float2 uv)
        {
            float angle = dot(uv, float2(12.9898, 78.233));
            #if defined(SHADER_API_MOBILE) && (defined(SHADER_API_GLES) || defined(SHADER_API_GLES3) || defined(SHADER_API_VULKAN))
                // 'sin()' has bad precision on Mali GPUs for inputs > 10000
                angle = fmod(angle, TWO_PI); // Avoid large inputs to sin()
            #endif
            return frac(sin(angle)*43758.5453);
        }
        
        inline float Unity_SimpleNnoise_Interpolate_float (float a, float b, float t)
        {
            return (1.0-t)*a + (t*b);
        }
        
        
        inline float Unity_SimpleNoise_ValueNoise_float (float2 uv)
        {
            float2 i = floor(uv);
            float2 f = frac(uv);
            f = f * f * (3.0 - 2.0 * f);
        
            uv = abs(frac(uv) - 0.5);
            float2 c0 = i + float2(0.0, 0.0);
            float2 c1 = i + float2(1.0, 0.0);
            float2 c2 = i + float2(0.0, 1.0);
            float2 c3 = i + float2(1.0, 1.0);
            float r0 = Unity_SimpleNoise_RandomValue_float(c0);
            float r1 = Unity_SimpleNoise_RandomValue_float(c1);
            float r2 = Unity_SimpleNoise_RandomValue_float(c2);
            float r3 = Unity_SimpleNoise_RandomValue_float(c3);
        
            float bottomOfGrid = Unity_SimpleNnoise_Interpolate_float(r0, r1, f.x);
            float topOfGrid = Unity_SimpleNnoise_Interpolate_float(r2, r3, f.x);
            float t = Unity_SimpleNnoise_Interpolate_float(bottomOfGrid, topOfGrid, f.y);
            return t;
        }
        void Unity_SimpleNoise_float(float2 UV, float Scale, out float Out)
        {
            float t = 0.0;
        
            float freq = pow(2.0, float(0));
            float amp = pow(0.5, float(3-0));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;
        
            freq = pow(2.0, float(1));
            amp = pow(0.5, float(3-1));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;
        
            freq = pow(2.0, float(2));
            amp = pow(0.5, float(3-2));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;
        
            Out = t;
        }
        
        void Unity_Fraction_float(float In, out float Out)
        {
            Out = frac(In);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_SampleGradientV1_float(Gradient Gradient, float Time, out float4 Out)
        {
            float3 color = Gradient.colors[0].rgb;
            [unroll]
            for (int c = 1; c < Gradient.colorsLength; c++)
            {
                float colorPos = saturate((Time - Gradient.colors[c - 1].w) / (Gradient.colors[c].w - Gradient.colors[c - 1].w)) * step(c, Gradient.colorsLength - 1);
                color = lerp(color, Gradient.colors[c].rgb, lerp(colorPos, step(0.01, colorPos), Gradient.type));
            }
        #ifdef UNITY_COLORSPACE_GAMMA
            color = LinearToSRGB(color);
        #endif
            float alpha = Gradient.alphas[0].x;
            [unroll]
            for (int a = 1; a < Gradient.alphasLength; a++)
            {
                float alphaPos = saturate((Time - Gradient.alphas[a - 1].y) / (Gradient.alphas[a].y - Gradient.alphas[a - 1].y)) * step(a, Gradient.alphasLength - 1);
                alpha = lerp(alpha, Gradient.alphas[a].x, lerp(alphaPos, step(0.01, alphaPos), Gradient.type));
            }
            Out = float4(color, alpha);
        }
        
        void Unity_RandomRange_float(float2 Seed, float Min, float Max, out float Out)
        {
             float randomno =  frac(sin(dot(Seed, float2(12.9898, 78.233)))*43758.5453);
             Out = lerp(Min, Max, randomno);
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _Property_cb3a1e3de89b4726b9a0635fe0f3e2ea_Out_0 = _Glitch;
            float _Comparison_e2a4fb5191904b1fb860567bcb12d930_Out_2;
            Unity_Comparison_Greater_float(_Property_cb3a1e3de89b4726b9a0635fe0f3e2ea_Out_0, 0, _Comparison_e2a4fb5191904b1fb860567bcb12d930_Out_2);
            float4 _UV_456b9c89fb434ceb9147a268bd819ba0_Out_0 = IN.uv0;
            float4 _Posterize_481d28d2b2fd4ddebcc686054f637b09_Out_2;
            Unity_Posterize_float4(_UV_456b9c89fb434ceb9147a268bd819ba0_Out_0, float4(12, 12, 12, 4), _Posterize_481d28d2b2fd4ddebcc686054f637b09_Out_2);
            float _SimpleNoise_cde6ca44ddef403a842ed90a6ab8c4d0_Out_2;
            Unity_SimpleNoise_float((_Posterize_481d28d2b2fd4ddebcc686054f637b09_Out_2.xy), 500, _SimpleNoise_cde6ca44ddef403a842ed90a6ab8c4d0_Out_2);
            float _Fraction_e87d167ea39b41238b60af0940743fb4_Out_1;
            Unity_Fraction_float(_SimpleNoise_cde6ca44ddef403a842ed90a6ab8c4d0_Out_2, _Fraction_e87d167ea39b41238b60af0940743fb4_Out_1);
            float _Multiply_7518e7fe7f814122b4218e9236439ead_Out_2;
            Unity_Multiply_float_float(_Fraction_e87d167ea39b41238b60af0940743fb4_Out_1, IN.TimeParameters.x, _Multiply_7518e7fe7f814122b4218e9236439ead_Out_2);
            float _Fraction_89fde9a65c8a458994c8253f5c358b88_Out_1;
            Unity_Fraction_float(_Multiply_7518e7fe7f814122b4218e9236439ead_Out_2, _Fraction_89fde9a65c8a458994c8253f5c358b88_Out_1);
            float4 _SampleGradient_b0632de439cb477982e6944782bce099_Out_2;
            Unity_SampleGradientV1_float(NewGradient(0, 4, 2, float4(1, 1, 1, 0),float4(0.4150943, 0.1789946, 0, 0.3941253),float4(1, 0.8410894, 0, 0.6617685),float4(1, 1, 1, 1),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0), float2(1, 0),float2(1, 1),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0)), _Fraction_89fde9a65c8a458994c8253f5c358b88_Out_1, _SampleGradient_b0632de439cb477982e6944782bce099_Out_2);
            UnityTexture2D _Property_746103c6d35a49b8a832a78a800c16db_Out_0 = UnityBuildTexture2DStructNoScale(_MainTex);
            float4 _UV_c2208a01c68a4e36be52cea883d4fcdf_Out_0 = IN.uv0;
            float4 _UV_eee149bb2a554c72a682890871dd2328_Out_0 = IN.uv0;
            float _Split_3eaefb55a74c48c18fb16f4f435caa1b_R_1 = _UV_eee149bb2a554c72a682890871dd2328_Out_0[0];
            float _Split_3eaefb55a74c48c18fb16f4f435caa1b_G_2 = _UV_eee149bb2a554c72a682890871dd2328_Out_0[1];
            float _Split_3eaefb55a74c48c18fb16f4f435caa1b_B_3 = _UV_eee149bb2a554c72a682890871dd2328_Out_0[2];
            float _Split_3eaefb55a74c48c18fb16f4f435caa1b_A_4 = _UV_eee149bb2a554c72a682890871dd2328_Out_0[3];
            float _SimpleNoise_bf0709d2c0ff4974876f4f331d99f9a9_Out_2;
            Unity_SimpleNoise_float((_Split_3eaefb55a74c48c18fb16f4f435caa1b_G_2.xx), _Property_cb3a1e3de89b4726b9a0635fe0f3e2ea_Out_0, _SimpleNoise_bf0709d2c0ff4974876f4f331d99f9a9_Out_2);
            float _SimpleNoise_5c6b3e9b03c54e6d86996fa545240e32_Out_2;
            Unity_SimpleNoise_float((IN.TimeParameters.x.xx), 500, _SimpleNoise_5c6b3e9b03c54e6d86996fa545240e32_Out_2);
            float _RandomRange_54ec6d53bdce4eb3afb9fe52174ee719_Out_3;
            Unity_RandomRange_float((_SimpleNoise_5c6b3e9b03c54e6d86996fa545240e32_Out_2.xx), -1, 1, _RandomRange_54ec6d53bdce4eb3afb9fe52174ee719_Out_3);
            float _Multiply_727a0ba96b7a421e93aa3ce4bba6abbc_Out_2;
            Unity_Multiply_float_float(_SimpleNoise_bf0709d2c0ff4974876f4f331d99f9a9_Out_2, _RandomRange_54ec6d53bdce4eb3afb9fe52174ee719_Out_3, _Multiply_727a0ba96b7a421e93aa3ce4bba6abbc_Out_2);
            float2 _Vector2_1fdee0dada2f419bbbedb9288a55e0b6_Out_0 = float2(_Multiply_727a0ba96b7a421e93aa3ce4bba6abbc_Out_2, _Multiply_727a0ba96b7a421e93aa3ce4bba6abbc_Out_2);
            float2 _Add_314e2e2180f54f489047d1c6df3ce8c8_Out_2;
            Unity_Add_float2((_UV_c2208a01c68a4e36be52cea883d4fcdf_Out_0.xy), _Vector2_1fdee0dada2f419bbbedb9288a55e0b6_Out_0, _Add_314e2e2180f54f489047d1c6df3ce8c8_Out_2);
            float4 _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0 = SAMPLE_TEXTURE2D(_Property_746103c6d35a49b8a832a78a800c16db_Out_0.tex, _Property_746103c6d35a49b8a832a78a800c16db_Out_0.samplerstate, _Property_746103c6d35a49b8a832a78a800c16db_Out_0.GetTransformedUV(_Add_314e2e2180f54f489047d1c6df3ce8c8_Out_2));
            float _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_R_4 = _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0.r;
            float _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_G_5 = _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0.g;
            float _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_B_6 = _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0.b;
            float _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_A_7 = _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0.a;
            float4 _Branch_d826e821815e407cb7a1dccd0c75f9ed_Out_3;
            Unity_Branch_float4(_Comparison_e2a4fb5191904b1fb860567bcb12d930_Out_2, _SampleGradient_b0632de439cb477982e6944782bce099_Out_2, _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0, _Branch_d826e821815e407cb7a1dccd0c75f9ed_Out_3);
            float4 _Property_3972ba0c594d4f75a3dfcb9a1cf2c9fb_Out_0 = IsGammaSpace() ? LinearToSRGB(_Color) : _Color;
            float4 _Multiply_028af5f91b3d4eedac9f0ad17399bbce_Out_2;
            Unity_Multiply_float4_float4(_SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0, _Property_3972ba0c594d4f75a3dfcb9a1cf2c9fb_Out_0, _Multiply_028af5f91b3d4eedac9f0ad17399bbce_Out_2);
            float4 _Multiply_b9f22c9e2b5a4943960230312fde11e4_Out_2;
            Unity_Multiply_float4_float4(_Branch_d826e821815e407cb7a1dccd0c75f9ed_Out_3, _Multiply_028af5f91b3d4eedac9f0ad17399bbce_Out_2, _Multiply_b9f22c9e2b5a4943960230312fde11e4_Out_2);
            surface.Alpha = (_Multiply_b9f22c9e2b5a4943960230312fde11e4_Out_2).x;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.uv0 = input.texCoord0;
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "ScenePickingPass"
            Tags
            {
                "LightMode" = "Picking"
            }
        
        // Render State
        Cull Back
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma only_renderers gles gles3 glcore d3d11
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENEPICKINGPASS 1
        #define ALPHA_CLIP_THRESHOLD 1
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float4 uv0;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 interp0 : INTERP0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyzw =  input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.interp0.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _MainTex_TexelSize;
        float _Glitch;
        float4 _Color;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_MainTex);
        SAMPLER(sampler_MainTex);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Comparison_Greater_float(float A, float B, out float Out)
        {
            Out = A > B ? 1 : 0;
        }
        
        void Unity_Posterize_float4(float4 In, float4 Steps, out float4 Out)
        {
            Out = floor(In / (1 / Steps)) * (1 / Steps);
        }
        
        
        inline float Unity_SimpleNoise_RandomValue_float (float2 uv)
        {
            float angle = dot(uv, float2(12.9898, 78.233));
            #if defined(SHADER_API_MOBILE) && (defined(SHADER_API_GLES) || defined(SHADER_API_GLES3) || defined(SHADER_API_VULKAN))
                // 'sin()' has bad precision on Mali GPUs for inputs > 10000
                angle = fmod(angle, TWO_PI); // Avoid large inputs to sin()
            #endif
            return frac(sin(angle)*43758.5453);
        }
        
        inline float Unity_SimpleNnoise_Interpolate_float (float a, float b, float t)
        {
            return (1.0-t)*a + (t*b);
        }
        
        
        inline float Unity_SimpleNoise_ValueNoise_float (float2 uv)
        {
            float2 i = floor(uv);
            float2 f = frac(uv);
            f = f * f * (3.0 - 2.0 * f);
        
            uv = abs(frac(uv) - 0.5);
            float2 c0 = i + float2(0.0, 0.0);
            float2 c1 = i + float2(1.0, 0.0);
            float2 c2 = i + float2(0.0, 1.0);
            float2 c3 = i + float2(1.0, 1.0);
            float r0 = Unity_SimpleNoise_RandomValue_float(c0);
            float r1 = Unity_SimpleNoise_RandomValue_float(c1);
            float r2 = Unity_SimpleNoise_RandomValue_float(c2);
            float r3 = Unity_SimpleNoise_RandomValue_float(c3);
        
            float bottomOfGrid = Unity_SimpleNnoise_Interpolate_float(r0, r1, f.x);
            float topOfGrid = Unity_SimpleNnoise_Interpolate_float(r2, r3, f.x);
            float t = Unity_SimpleNnoise_Interpolate_float(bottomOfGrid, topOfGrid, f.y);
            return t;
        }
        void Unity_SimpleNoise_float(float2 UV, float Scale, out float Out)
        {
            float t = 0.0;
        
            float freq = pow(2.0, float(0));
            float amp = pow(0.5, float(3-0));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;
        
            freq = pow(2.0, float(1));
            amp = pow(0.5, float(3-1));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;
        
            freq = pow(2.0, float(2));
            amp = pow(0.5, float(3-2));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;
        
            Out = t;
        }
        
        void Unity_Fraction_float(float In, out float Out)
        {
            Out = frac(In);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_SampleGradientV1_float(Gradient Gradient, float Time, out float4 Out)
        {
            float3 color = Gradient.colors[0].rgb;
            [unroll]
            for (int c = 1; c < Gradient.colorsLength; c++)
            {
                float colorPos = saturate((Time - Gradient.colors[c - 1].w) / (Gradient.colors[c].w - Gradient.colors[c - 1].w)) * step(c, Gradient.colorsLength - 1);
                color = lerp(color, Gradient.colors[c].rgb, lerp(colorPos, step(0.01, colorPos), Gradient.type));
            }
        #ifdef UNITY_COLORSPACE_GAMMA
            color = LinearToSRGB(color);
        #endif
            float alpha = Gradient.alphas[0].x;
            [unroll]
            for (int a = 1; a < Gradient.alphasLength; a++)
            {
                float alphaPos = saturate((Time - Gradient.alphas[a - 1].y) / (Gradient.alphas[a].y - Gradient.alphas[a - 1].y)) * step(a, Gradient.alphasLength - 1);
                alpha = lerp(alpha, Gradient.alphas[a].x, lerp(alphaPos, step(0.01, alphaPos), Gradient.type));
            }
            Out = float4(color, alpha);
        }
        
        void Unity_RandomRange_float(float2 Seed, float Min, float Max, out float Out)
        {
             float randomno =  frac(sin(dot(Seed, float2(12.9898, 78.233)))*43758.5453);
             Out = lerp(Min, Max, randomno);
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _Property_cb3a1e3de89b4726b9a0635fe0f3e2ea_Out_0 = _Glitch;
            float _Comparison_e2a4fb5191904b1fb860567bcb12d930_Out_2;
            Unity_Comparison_Greater_float(_Property_cb3a1e3de89b4726b9a0635fe0f3e2ea_Out_0, 0, _Comparison_e2a4fb5191904b1fb860567bcb12d930_Out_2);
            float4 _UV_456b9c89fb434ceb9147a268bd819ba0_Out_0 = IN.uv0;
            float4 _Posterize_481d28d2b2fd4ddebcc686054f637b09_Out_2;
            Unity_Posterize_float4(_UV_456b9c89fb434ceb9147a268bd819ba0_Out_0, float4(12, 12, 12, 4), _Posterize_481d28d2b2fd4ddebcc686054f637b09_Out_2);
            float _SimpleNoise_cde6ca44ddef403a842ed90a6ab8c4d0_Out_2;
            Unity_SimpleNoise_float((_Posterize_481d28d2b2fd4ddebcc686054f637b09_Out_2.xy), 500, _SimpleNoise_cde6ca44ddef403a842ed90a6ab8c4d0_Out_2);
            float _Fraction_e87d167ea39b41238b60af0940743fb4_Out_1;
            Unity_Fraction_float(_SimpleNoise_cde6ca44ddef403a842ed90a6ab8c4d0_Out_2, _Fraction_e87d167ea39b41238b60af0940743fb4_Out_1);
            float _Multiply_7518e7fe7f814122b4218e9236439ead_Out_2;
            Unity_Multiply_float_float(_Fraction_e87d167ea39b41238b60af0940743fb4_Out_1, IN.TimeParameters.x, _Multiply_7518e7fe7f814122b4218e9236439ead_Out_2);
            float _Fraction_89fde9a65c8a458994c8253f5c358b88_Out_1;
            Unity_Fraction_float(_Multiply_7518e7fe7f814122b4218e9236439ead_Out_2, _Fraction_89fde9a65c8a458994c8253f5c358b88_Out_1);
            float4 _SampleGradient_b0632de439cb477982e6944782bce099_Out_2;
            Unity_SampleGradientV1_float(NewGradient(0, 4, 2, float4(1, 1, 1, 0),float4(0.4150943, 0.1789946, 0, 0.3941253),float4(1, 0.8410894, 0, 0.6617685),float4(1, 1, 1, 1),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0), float2(1, 0),float2(1, 1),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0)), _Fraction_89fde9a65c8a458994c8253f5c358b88_Out_1, _SampleGradient_b0632de439cb477982e6944782bce099_Out_2);
            UnityTexture2D _Property_746103c6d35a49b8a832a78a800c16db_Out_0 = UnityBuildTexture2DStructNoScale(_MainTex);
            float4 _UV_c2208a01c68a4e36be52cea883d4fcdf_Out_0 = IN.uv0;
            float4 _UV_eee149bb2a554c72a682890871dd2328_Out_0 = IN.uv0;
            float _Split_3eaefb55a74c48c18fb16f4f435caa1b_R_1 = _UV_eee149bb2a554c72a682890871dd2328_Out_0[0];
            float _Split_3eaefb55a74c48c18fb16f4f435caa1b_G_2 = _UV_eee149bb2a554c72a682890871dd2328_Out_0[1];
            float _Split_3eaefb55a74c48c18fb16f4f435caa1b_B_3 = _UV_eee149bb2a554c72a682890871dd2328_Out_0[2];
            float _Split_3eaefb55a74c48c18fb16f4f435caa1b_A_4 = _UV_eee149bb2a554c72a682890871dd2328_Out_0[3];
            float _SimpleNoise_bf0709d2c0ff4974876f4f331d99f9a9_Out_2;
            Unity_SimpleNoise_float((_Split_3eaefb55a74c48c18fb16f4f435caa1b_G_2.xx), _Property_cb3a1e3de89b4726b9a0635fe0f3e2ea_Out_0, _SimpleNoise_bf0709d2c0ff4974876f4f331d99f9a9_Out_2);
            float _SimpleNoise_5c6b3e9b03c54e6d86996fa545240e32_Out_2;
            Unity_SimpleNoise_float((IN.TimeParameters.x.xx), 500, _SimpleNoise_5c6b3e9b03c54e6d86996fa545240e32_Out_2);
            float _RandomRange_54ec6d53bdce4eb3afb9fe52174ee719_Out_3;
            Unity_RandomRange_float((_SimpleNoise_5c6b3e9b03c54e6d86996fa545240e32_Out_2.xx), -1, 1, _RandomRange_54ec6d53bdce4eb3afb9fe52174ee719_Out_3);
            float _Multiply_727a0ba96b7a421e93aa3ce4bba6abbc_Out_2;
            Unity_Multiply_float_float(_SimpleNoise_bf0709d2c0ff4974876f4f331d99f9a9_Out_2, _RandomRange_54ec6d53bdce4eb3afb9fe52174ee719_Out_3, _Multiply_727a0ba96b7a421e93aa3ce4bba6abbc_Out_2);
            float2 _Vector2_1fdee0dada2f419bbbedb9288a55e0b6_Out_0 = float2(_Multiply_727a0ba96b7a421e93aa3ce4bba6abbc_Out_2, _Multiply_727a0ba96b7a421e93aa3ce4bba6abbc_Out_2);
            float2 _Add_314e2e2180f54f489047d1c6df3ce8c8_Out_2;
            Unity_Add_float2((_UV_c2208a01c68a4e36be52cea883d4fcdf_Out_0.xy), _Vector2_1fdee0dada2f419bbbedb9288a55e0b6_Out_0, _Add_314e2e2180f54f489047d1c6df3ce8c8_Out_2);
            float4 _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0 = SAMPLE_TEXTURE2D(_Property_746103c6d35a49b8a832a78a800c16db_Out_0.tex, _Property_746103c6d35a49b8a832a78a800c16db_Out_0.samplerstate, _Property_746103c6d35a49b8a832a78a800c16db_Out_0.GetTransformedUV(_Add_314e2e2180f54f489047d1c6df3ce8c8_Out_2));
            float _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_R_4 = _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0.r;
            float _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_G_5 = _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0.g;
            float _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_B_6 = _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0.b;
            float _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_A_7 = _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0.a;
            float4 _Branch_d826e821815e407cb7a1dccd0c75f9ed_Out_3;
            Unity_Branch_float4(_Comparison_e2a4fb5191904b1fb860567bcb12d930_Out_2, _SampleGradient_b0632de439cb477982e6944782bce099_Out_2, _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0, _Branch_d826e821815e407cb7a1dccd0c75f9ed_Out_3);
            float4 _Property_3972ba0c594d4f75a3dfcb9a1cf2c9fb_Out_0 = IsGammaSpace() ? LinearToSRGB(_Color) : _Color;
            float4 _Multiply_028af5f91b3d4eedac9f0ad17399bbce_Out_2;
            Unity_Multiply_float4_float4(_SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0, _Property_3972ba0c594d4f75a3dfcb9a1cf2c9fb_Out_0, _Multiply_028af5f91b3d4eedac9f0ad17399bbce_Out_2);
            float4 _Multiply_b9f22c9e2b5a4943960230312fde11e4_Out_2;
            Unity_Multiply_float4_float4(_Branch_d826e821815e407cb7a1dccd0c75f9ed_Out_3, _Multiply_028af5f91b3d4eedac9f0ad17399bbce_Out_2, _Multiply_b9f22c9e2b5a4943960230312fde11e4_Out_2);
            surface.Alpha = (_Multiply_b9f22c9e2b5a4943960230312fde11e4_Out_2).x;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.uv0 = input.texCoord0;
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "DepthNormals"
            Tags
            {
                "LightMode" = "DepthNormalsOnly"
            }
        
        // Render State
        Cull Back
        ZTest LEqual
        ZWrite On
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma only_renderers gles gles3 glcore d3d11
        #pragma multi_compile_instancing
        #pragma multi_compile_fog
        #pragma instancing_options renderinglayer
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHNORMALSONLY
        #define _SURFACE_TYPE_TRANSPARENT 1
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 normalWS;
             float4 texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float4 uv0;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float4 interp1 : INTERP1;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.normalWS;
            output.interp1.xyzw =  input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.normalWS = input.interp0.xyz;
            output.texCoord0 = input.interp1.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _MainTex_TexelSize;
        float _Glitch;
        float4 _Color;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_MainTex);
        SAMPLER(sampler_MainTex);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Comparison_Greater_float(float A, float B, out float Out)
        {
            Out = A > B ? 1 : 0;
        }
        
        void Unity_Posterize_float4(float4 In, float4 Steps, out float4 Out)
        {
            Out = floor(In / (1 / Steps)) * (1 / Steps);
        }
        
        
        inline float Unity_SimpleNoise_RandomValue_float (float2 uv)
        {
            float angle = dot(uv, float2(12.9898, 78.233));
            #if defined(SHADER_API_MOBILE) && (defined(SHADER_API_GLES) || defined(SHADER_API_GLES3) || defined(SHADER_API_VULKAN))
                // 'sin()' has bad precision on Mali GPUs for inputs > 10000
                angle = fmod(angle, TWO_PI); // Avoid large inputs to sin()
            #endif
            return frac(sin(angle)*43758.5453);
        }
        
        inline float Unity_SimpleNnoise_Interpolate_float (float a, float b, float t)
        {
            return (1.0-t)*a + (t*b);
        }
        
        
        inline float Unity_SimpleNoise_ValueNoise_float (float2 uv)
        {
            float2 i = floor(uv);
            float2 f = frac(uv);
            f = f * f * (3.0 - 2.0 * f);
        
            uv = abs(frac(uv) - 0.5);
            float2 c0 = i + float2(0.0, 0.0);
            float2 c1 = i + float2(1.0, 0.0);
            float2 c2 = i + float2(0.0, 1.0);
            float2 c3 = i + float2(1.0, 1.0);
            float r0 = Unity_SimpleNoise_RandomValue_float(c0);
            float r1 = Unity_SimpleNoise_RandomValue_float(c1);
            float r2 = Unity_SimpleNoise_RandomValue_float(c2);
            float r3 = Unity_SimpleNoise_RandomValue_float(c3);
        
            float bottomOfGrid = Unity_SimpleNnoise_Interpolate_float(r0, r1, f.x);
            float topOfGrid = Unity_SimpleNnoise_Interpolate_float(r2, r3, f.x);
            float t = Unity_SimpleNnoise_Interpolate_float(bottomOfGrid, topOfGrid, f.y);
            return t;
        }
        void Unity_SimpleNoise_float(float2 UV, float Scale, out float Out)
        {
            float t = 0.0;
        
            float freq = pow(2.0, float(0));
            float amp = pow(0.5, float(3-0));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;
        
            freq = pow(2.0, float(1));
            amp = pow(0.5, float(3-1));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;
        
            freq = pow(2.0, float(2));
            amp = pow(0.5, float(3-2));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;
        
            Out = t;
        }
        
        void Unity_Fraction_float(float In, out float Out)
        {
            Out = frac(In);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_SampleGradientV1_float(Gradient Gradient, float Time, out float4 Out)
        {
            float3 color = Gradient.colors[0].rgb;
            [unroll]
            for (int c = 1; c < Gradient.colorsLength; c++)
            {
                float colorPos = saturate((Time - Gradient.colors[c - 1].w) / (Gradient.colors[c].w - Gradient.colors[c - 1].w)) * step(c, Gradient.colorsLength - 1);
                color = lerp(color, Gradient.colors[c].rgb, lerp(colorPos, step(0.01, colorPos), Gradient.type));
            }
        #ifdef UNITY_COLORSPACE_GAMMA
            color = LinearToSRGB(color);
        #endif
            float alpha = Gradient.alphas[0].x;
            [unroll]
            for (int a = 1; a < Gradient.alphasLength; a++)
            {
                float alphaPos = saturate((Time - Gradient.alphas[a - 1].y) / (Gradient.alphas[a].y - Gradient.alphas[a - 1].y)) * step(a, Gradient.alphasLength - 1);
                alpha = lerp(alpha, Gradient.alphas[a].x, lerp(alphaPos, step(0.01, alphaPos), Gradient.type));
            }
            Out = float4(color, alpha);
        }
        
        void Unity_RandomRange_float(float2 Seed, float Min, float Max, out float Out)
        {
             float randomno =  frac(sin(dot(Seed, float2(12.9898, 78.233)))*43758.5453);
             Out = lerp(Min, Max, randomno);
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _Property_cb3a1e3de89b4726b9a0635fe0f3e2ea_Out_0 = _Glitch;
            float _Comparison_e2a4fb5191904b1fb860567bcb12d930_Out_2;
            Unity_Comparison_Greater_float(_Property_cb3a1e3de89b4726b9a0635fe0f3e2ea_Out_0, 0, _Comparison_e2a4fb5191904b1fb860567bcb12d930_Out_2);
            float4 _UV_456b9c89fb434ceb9147a268bd819ba0_Out_0 = IN.uv0;
            float4 _Posterize_481d28d2b2fd4ddebcc686054f637b09_Out_2;
            Unity_Posterize_float4(_UV_456b9c89fb434ceb9147a268bd819ba0_Out_0, float4(12, 12, 12, 4), _Posterize_481d28d2b2fd4ddebcc686054f637b09_Out_2);
            float _SimpleNoise_cde6ca44ddef403a842ed90a6ab8c4d0_Out_2;
            Unity_SimpleNoise_float((_Posterize_481d28d2b2fd4ddebcc686054f637b09_Out_2.xy), 500, _SimpleNoise_cde6ca44ddef403a842ed90a6ab8c4d0_Out_2);
            float _Fraction_e87d167ea39b41238b60af0940743fb4_Out_1;
            Unity_Fraction_float(_SimpleNoise_cde6ca44ddef403a842ed90a6ab8c4d0_Out_2, _Fraction_e87d167ea39b41238b60af0940743fb4_Out_1);
            float _Multiply_7518e7fe7f814122b4218e9236439ead_Out_2;
            Unity_Multiply_float_float(_Fraction_e87d167ea39b41238b60af0940743fb4_Out_1, IN.TimeParameters.x, _Multiply_7518e7fe7f814122b4218e9236439ead_Out_2);
            float _Fraction_89fde9a65c8a458994c8253f5c358b88_Out_1;
            Unity_Fraction_float(_Multiply_7518e7fe7f814122b4218e9236439ead_Out_2, _Fraction_89fde9a65c8a458994c8253f5c358b88_Out_1);
            float4 _SampleGradient_b0632de439cb477982e6944782bce099_Out_2;
            Unity_SampleGradientV1_float(NewGradient(0, 4, 2, float4(1, 1, 1, 0),float4(0.4150943, 0.1789946, 0, 0.3941253),float4(1, 0.8410894, 0, 0.6617685),float4(1, 1, 1, 1),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0), float2(1, 0),float2(1, 1),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0)), _Fraction_89fde9a65c8a458994c8253f5c358b88_Out_1, _SampleGradient_b0632de439cb477982e6944782bce099_Out_2);
            UnityTexture2D _Property_746103c6d35a49b8a832a78a800c16db_Out_0 = UnityBuildTexture2DStructNoScale(_MainTex);
            float4 _UV_c2208a01c68a4e36be52cea883d4fcdf_Out_0 = IN.uv0;
            float4 _UV_eee149bb2a554c72a682890871dd2328_Out_0 = IN.uv0;
            float _Split_3eaefb55a74c48c18fb16f4f435caa1b_R_1 = _UV_eee149bb2a554c72a682890871dd2328_Out_0[0];
            float _Split_3eaefb55a74c48c18fb16f4f435caa1b_G_2 = _UV_eee149bb2a554c72a682890871dd2328_Out_0[1];
            float _Split_3eaefb55a74c48c18fb16f4f435caa1b_B_3 = _UV_eee149bb2a554c72a682890871dd2328_Out_0[2];
            float _Split_3eaefb55a74c48c18fb16f4f435caa1b_A_4 = _UV_eee149bb2a554c72a682890871dd2328_Out_0[3];
            float _SimpleNoise_bf0709d2c0ff4974876f4f331d99f9a9_Out_2;
            Unity_SimpleNoise_float((_Split_3eaefb55a74c48c18fb16f4f435caa1b_G_2.xx), _Property_cb3a1e3de89b4726b9a0635fe0f3e2ea_Out_0, _SimpleNoise_bf0709d2c0ff4974876f4f331d99f9a9_Out_2);
            float _SimpleNoise_5c6b3e9b03c54e6d86996fa545240e32_Out_2;
            Unity_SimpleNoise_float((IN.TimeParameters.x.xx), 500, _SimpleNoise_5c6b3e9b03c54e6d86996fa545240e32_Out_2);
            float _RandomRange_54ec6d53bdce4eb3afb9fe52174ee719_Out_3;
            Unity_RandomRange_float((_SimpleNoise_5c6b3e9b03c54e6d86996fa545240e32_Out_2.xx), -1, 1, _RandomRange_54ec6d53bdce4eb3afb9fe52174ee719_Out_3);
            float _Multiply_727a0ba96b7a421e93aa3ce4bba6abbc_Out_2;
            Unity_Multiply_float_float(_SimpleNoise_bf0709d2c0ff4974876f4f331d99f9a9_Out_2, _RandomRange_54ec6d53bdce4eb3afb9fe52174ee719_Out_3, _Multiply_727a0ba96b7a421e93aa3ce4bba6abbc_Out_2);
            float2 _Vector2_1fdee0dada2f419bbbedb9288a55e0b6_Out_0 = float2(_Multiply_727a0ba96b7a421e93aa3ce4bba6abbc_Out_2, _Multiply_727a0ba96b7a421e93aa3ce4bba6abbc_Out_2);
            float2 _Add_314e2e2180f54f489047d1c6df3ce8c8_Out_2;
            Unity_Add_float2((_UV_c2208a01c68a4e36be52cea883d4fcdf_Out_0.xy), _Vector2_1fdee0dada2f419bbbedb9288a55e0b6_Out_0, _Add_314e2e2180f54f489047d1c6df3ce8c8_Out_2);
            float4 _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0 = SAMPLE_TEXTURE2D(_Property_746103c6d35a49b8a832a78a800c16db_Out_0.tex, _Property_746103c6d35a49b8a832a78a800c16db_Out_0.samplerstate, _Property_746103c6d35a49b8a832a78a800c16db_Out_0.GetTransformedUV(_Add_314e2e2180f54f489047d1c6df3ce8c8_Out_2));
            float _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_R_4 = _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0.r;
            float _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_G_5 = _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0.g;
            float _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_B_6 = _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0.b;
            float _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_A_7 = _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0.a;
            float4 _Branch_d826e821815e407cb7a1dccd0c75f9ed_Out_3;
            Unity_Branch_float4(_Comparison_e2a4fb5191904b1fb860567bcb12d930_Out_2, _SampleGradient_b0632de439cb477982e6944782bce099_Out_2, _SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0, _Branch_d826e821815e407cb7a1dccd0c75f9ed_Out_3);
            float4 _Property_3972ba0c594d4f75a3dfcb9a1cf2c9fb_Out_0 = IsGammaSpace() ? LinearToSRGB(_Color) : _Color;
            float4 _Multiply_028af5f91b3d4eedac9f0ad17399bbce_Out_2;
            Unity_Multiply_float4_float4(_SampleTexture2D_22aa983e3e134804ab9111f15fa7a382_RGBA_0, _Property_3972ba0c594d4f75a3dfcb9a1cf2c9fb_Out_0, _Multiply_028af5f91b3d4eedac9f0ad17399bbce_Out_2);
            float4 _Multiply_b9f22c9e2b5a4943960230312fde11e4_Out_2;
            Unity_Multiply_float4_float4(_Branch_d826e821815e407cb7a1dccd0c75f9ed_Out_3, _Multiply_028af5f91b3d4eedac9f0ad17399bbce_Out_2, _Multiply_b9f22c9e2b5a4943960230312fde11e4_Out_2);
            surface.Alpha = (_Multiply_b9f22c9e2b5a4943960230312fde11e4_Out_2).x;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.uv0 = input.texCoord0;
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthNormalsOnlyPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
    }
    CustomEditorForRenderPipeline "UnityEditor.ShaderGraphUnlitGUI" "UnityEngine.Rendering.Universal.UniversalRenderPipelineAsset"
    CustomEditor "UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI"
    FallBack "Hidden/Shader Graph/FallbackError"
}