Shader "IndieImpulse/Unlit/IconEffectsPack/ImageX2Mask4Color"
{
    Properties
    {
        [NoScaleOffset]_MainTex("MainTex", 2D) = "white" {}
        [HDR]_Color("Color", Color) = (0, 0, 0, 0)
        [HDR]_Color2("Color2", Color) = (0, 0, 0, 0)
        [HDR]_Color3("Color3", Color) = (0, 0, 0, 0)
        [HDR]_Color4("Color4", Color) = (0, 0, 0, 0)
        [NoScaleOffset]_Mask("Mask", 2D) = "white" {}
        _Tilling("Tilling", Vector) = (0, 0, 0, 0)
        _Move("Move", Float) = 0
        _Speed("Speed", Float) = 0
        [NoScaleOffset]_Mask2("Mask2", 2D) = "white" {}
        _ColorSpeed("ColorSpeed", Float) = 0
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
        Cull Off
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
        float4 _Color;
        float4 _Color2;
        float4 _Color3;
        float4 _Color4;
        float4 _Mask_TexelSize;
        float2 _Tilling;
        float _Move;
        float _Speed;
        float4 _Mask2_TexelSize;
        float _ColorSpeed;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_MainTex);
        SAMPLER(sampler_MainTex);
        TEXTURE2D(_Mask);
        SAMPLER(sampler_Mask);
        TEXTURE2D(_Mask2);
        SAMPLER(sampler_Mask2);
        
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
        
        void Unity_OneMinus_float4(float4 In, out float4 Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Sine_float(float In, out float Out)
        {
            Out = sin(In);
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
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
            UnityTexture2D _Property_cd673621650149ebacf2c467fd6cbec7_Out_0 = UnityBuildTexture2DStructNoScale(_Mask2);
            float4 _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_RGBA_0 = SAMPLE_TEXTURE2D(_Property_cd673621650149ebacf2c467fd6cbec7_Out_0.tex, _Property_cd673621650149ebacf2c467fd6cbec7_Out_0.samplerstate, _Property_cd673621650149ebacf2c467fd6cbec7_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_R_4 = _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_RGBA_0.r;
            float _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_G_5 = _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_RGBA_0.g;
            float _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_B_6 = _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_RGBA_0.b;
            float _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_A_7 = _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_RGBA_0.a;
            float4 _OneMinus_9110807526f147c6b89c8ee3881a9256_Out_1;
            Unity_OneMinus_float4(_SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_RGBA_0, _OneMinus_9110807526f147c6b89c8ee3881a9256_Out_1);
            UnityTexture2D _Property_fa540f388df540609b44289e408721ce_Out_0 = UnityBuildTexture2DStructNoScale(_MainTex);
            float4 _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_RGBA_0 = SAMPLE_TEXTURE2D(_Property_fa540f388df540609b44289e408721ce_Out_0.tex, _Property_fa540f388df540609b44289e408721ce_Out_0.samplerstate, _Property_fa540f388df540609b44289e408721ce_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_R_4 = _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_RGBA_0.r;
            float _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_G_5 = _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_RGBA_0.g;
            float _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_B_6 = _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_RGBA_0.b;
            float _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_A_7 = _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_RGBA_0.a;
            float4 _Multiply_544c1a00069f4992a46fc44db20f92f0_Out_2;
            Unity_Multiply_float4_float4(_OneMinus_9110807526f147c6b89c8ee3881a9256_Out_1, _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_RGBA_0, _Multiply_544c1a00069f4992a46fc44db20f92f0_Out_2);
            UnityTexture2D _Property_720e4d2150bb4c60b112ba418350b06c_Out_0 = UnityBuildTexture2DStructNoScale(_Mask);
            float2 _Property_0220ad02561645b5808016c0775b50f2_Out_0 = _Tilling;
            float _Property_5398e72b3dc44eaf9b79ea0d4f8af707_Out_0 = _Move;
            float _Property_fae368b578414d37b2ac2f98eba0219e_Out_0 = _Speed;
            float _Multiply_427e1a3cc85c42e6b2a6c9cefaf71e05_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_fae368b578414d37b2ac2f98eba0219e_Out_0, _Multiply_427e1a3cc85c42e6b2a6c9cefaf71e05_Out_2);
            float2 _Vector2_e8284808a65b4a11b48aba11eff83428_Out_0 = float2(_Property_5398e72b3dc44eaf9b79ea0d4f8af707_Out_0, _Multiply_427e1a3cc85c42e6b2a6c9cefaf71e05_Out_2);
            float2 _TilingAndOffset_6aa09ab2395d44b18a728391c05e4d34_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_0220ad02561645b5808016c0775b50f2_Out_0, _Vector2_e8284808a65b4a11b48aba11eff83428_Out_0, _TilingAndOffset_6aa09ab2395d44b18a728391c05e4d34_Out_3);
            float4 _SampleTexture2D_1445a3a145f0494fb6101655445fd084_RGBA_0 = SAMPLE_TEXTURE2D(_Property_720e4d2150bb4c60b112ba418350b06c_Out_0.tex, _Property_720e4d2150bb4c60b112ba418350b06c_Out_0.samplerstate, _Property_720e4d2150bb4c60b112ba418350b06c_Out_0.GetTransformedUV(_TilingAndOffset_6aa09ab2395d44b18a728391c05e4d34_Out_3));
            float _SampleTexture2D_1445a3a145f0494fb6101655445fd084_R_4 = _SampleTexture2D_1445a3a145f0494fb6101655445fd084_RGBA_0.r;
            float _SampleTexture2D_1445a3a145f0494fb6101655445fd084_G_5 = _SampleTexture2D_1445a3a145f0494fb6101655445fd084_RGBA_0.g;
            float _SampleTexture2D_1445a3a145f0494fb6101655445fd084_B_6 = _SampleTexture2D_1445a3a145f0494fb6101655445fd084_RGBA_0.b;
            float _SampleTexture2D_1445a3a145f0494fb6101655445fd084_A_7 = _SampleTexture2D_1445a3a145f0494fb6101655445fd084_RGBA_0.a;
            float4 _Multiply_1e0d5ab94f084efa9e56270220982c0d_Out_2;
            Unity_Multiply_float4_float4(_Multiply_544c1a00069f4992a46fc44db20f92f0_Out_2, (_SampleTexture2D_1445a3a145f0494fb6101655445fd084_R_4.xxxx), _Multiply_1e0d5ab94f084efa9e56270220982c0d_Out_2);
            float4 _Property_8760ea6533344ee9922b142944ae6ad5_Out_0 = IsGammaSpace() ? LinearToSRGB(_Color3) : _Color3;
            float4 _Property_cc4b848634b54134ba1b7bcbea3cc549_Out_0 = IsGammaSpace() ? LinearToSRGB(_Color4) : _Color4;
            float _Multiply_c2cc77910fef4d8fbd17fb599ce5518a_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_fae368b578414d37b2ac2f98eba0219e_Out_0, _Multiply_c2cc77910fef4d8fbd17fb599ce5518a_Out_2);
            float _Sine_a725c9420b984bf2bc8264f31d3c5311_Out_1;
            Unity_Sine_float(_Multiply_c2cc77910fef4d8fbd17fb599ce5518a_Out_2, _Sine_a725c9420b984bf2bc8264f31d3c5311_Out_1);
            float _Remap_f569deacc8d847b4a611dba4d71c1e01_Out_3;
            Unity_Remap_float(_Sine_a725c9420b984bf2bc8264f31d3c5311_Out_1, float2 (-1, 1), float2 (0, 1), _Remap_f569deacc8d847b4a611dba4d71c1e01_Out_3);
            float4 _Lerp_6ad7180848164426b34e00ceae53071f_Out_3;
            Unity_Lerp_float4(_Property_8760ea6533344ee9922b142944ae6ad5_Out_0, _Property_cc4b848634b54134ba1b7bcbea3cc549_Out_0, (_Remap_f569deacc8d847b4a611dba4d71c1e01_Out_3.xxxx), _Lerp_6ad7180848164426b34e00ceae53071f_Out_3);
            float4 _Property_741392ff3e254965ac5abc5c69cbef3e_Out_0 = IsGammaSpace() ? LinearToSRGB(_Color) : _Color;
            float4 _Property_cdfdf6b4854047e7ba38c372adb82566_Out_0 = IsGammaSpace() ? LinearToSRGB(_Color2) : _Color2;
            float _Property_e06a44c369334c5ba84fd5762aa7b422_Out_0 = _ColorSpeed;
            float _Multiply_939668cebf9146d793fa55f29b72e6d4_Out_2;
            Unity_Multiply_float_float(_Property_e06a44c369334c5ba84fd5762aa7b422_Out_0, IN.TimeParameters.x, _Multiply_939668cebf9146d793fa55f29b72e6d4_Out_2);
            float _Sine_64edcc5d83af4c01821d12a499ee656a_Out_1;
            Unity_Sine_float(_Multiply_939668cebf9146d793fa55f29b72e6d4_Out_2, _Sine_64edcc5d83af4c01821d12a499ee656a_Out_1);
            float _Remap_9196ab8fb5794c68898099a97c1bd57f_Out_3;
            Unity_Remap_float(_Sine_64edcc5d83af4c01821d12a499ee656a_Out_1, float2 (-1, 1), float2 (0, 1), _Remap_9196ab8fb5794c68898099a97c1bd57f_Out_3);
            float4 _Lerp_97ac5e67510249e294cce56d3298bb44_Out_3;
            Unity_Lerp_float4(_Property_741392ff3e254965ac5abc5c69cbef3e_Out_0, _Property_cdfdf6b4854047e7ba38c372adb82566_Out_0, (_Remap_9196ab8fb5794c68898099a97c1bd57f_Out_3.xxxx), _Lerp_97ac5e67510249e294cce56d3298bb44_Out_3);
            float4 _Add_b4d3b56af07c49a5b9a7d823205d02fd_Out_2;
            Unity_Add_float4(_Lerp_6ad7180848164426b34e00ceae53071f_Out_3, _Lerp_97ac5e67510249e294cce56d3298bb44_Out_3, _Add_b4d3b56af07c49a5b9a7d823205d02fd_Out_2);
            float4 _Multiply_30b6f91fcd094b80b9ad387224af0a7e_Out_2;
            Unity_Multiply_float4_float4(_Multiply_1e0d5ab94f084efa9e56270220982c0d_Out_2, _Add_b4d3b56af07c49a5b9a7d823205d02fd_Out_2, _Multiply_30b6f91fcd094b80b9ad387224af0a7e_Out_2);
            surface.BaseColor = (_Multiply_30b6f91fcd094b80b9ad387224af0a7e_Out_2.xyz);
            surface.Alpha = (_Multiply_1e0d5ab94f084efa9e56270220982c0d_Out_2).x;
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
        Cull Off
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
        float4 _Color;
        float4 _Color2;
        float4 _Color3;
        float4 _Color4;
        float4 _Mask_TexelSize;
        float2 _Tilling;
        float _Move;
        float _Speed;
        float4 _Mask2_TexelSize;
        float _ColorSpeed;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_MainTex);
        SAMPLER(sampler_MainTex);
        TEXTURE2D(_Mask);
        SAMPLER(sampler_Mask);
        TEXTURE2D(_Mask2);
        SAMPLER(sampler_Mask2);
        
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
        
        void Unity_OneMinus_float4(float4 In, out float4 Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
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
            UnityTexture2D _Property_cd673621650149ebacf2c467fd6cbec7_Out_0 = UnityBuildTexture2DStructNoScale(_Mask2);
            float4 _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_RGBA_0 = SAMPLE_TEXTURE2D(_Property_cd673621650149ebacf2c467fd6cbec7_Out_0.tex, _Property_cd673621650149ebacf2c467fd6cbec7_Out_0.samplerstate, _Property_cd673621650149ebacf2c467fd6cbec7_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_R_4 = _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_RGBA_0.r;
            float _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_G_5 = _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_RGBA_0.g;
            float _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_B_6 = _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_RGBA_0.b;
            float _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_A_7 = _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_RGBA_0.a;
            float4 _OneMinus_9110807526f147c6b89c8ee3881a9256_Out_1;
            Unity_OneMinus_float4(_SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_RGBA_0, _OneMinus_9110807526f147c6b89c8ee3881a9256_Out_1);
            UnityTexture2D _Property_fa540f388df540609b44289e408721ce_Out_0 = UnityBuildTexture2DStructNoScale(_MainTex);
            float4 _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_RGBA_0 = SAMPLE_TEXTURE2D(_Property_fa540f388df540609b44289e408721ce_Out_0.tex, _Property_fa540f388df540609b44289e408721ce_Out_0.samplerstate, _Property_fa540f388df540609b44289e408721ce_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_R_4 = _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_RGBA_0.r;
            float _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_G_5 = _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_RGBA_0.g;
            float _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_B_6 = _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_RGBA_0.b;
            float _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_A_7 = _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_RGBA_0.a;
            float4 _Multiply_544c1a00069f4992a46fc44db20f92f0_Out_2;
            Unity_Multiply_float4_float4(_OneMinus_9110807526f147c6b89c8ee3881a9256_Out_1, _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_RGBA_0, _Multiply_544c1a00069f4992a46fc44db20f92f0_Out_2);
            UnityTexture2D _Property_720e4d2150bb4c60b112ba418350b06c_Out_0 = UnityBuildTexture2DStructNoScale(_Mask);
            float2 _Property_0220ad02561645b5808016c0775b50f2_Out_0 = _Tilling;
            float _Property_5398e72b3dc44eaf9b79ea0d4f8af707_Out_0 = _Move;
            float _Property_fae368b578414d37b2ac2f98eba0219e_Out_0 = _Speed;
            float _Multiply_427e1a3cc85c42e6b2a6c9cefaf71e05_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_fae368b578414d37b2ac2f98eba0219e_Out_0, _Multiply_427e1a3cc85c42e6b2a6c9cefaf71e05_Out_2);
            float2 _Vector2_e8284808a65b4a11b48aba11eff83428_Out_0 = float2(_Property_5398e72b3dc44eaf9b79ea0d4f8af707_Out_0, _Multiply_427e1a3cc85c42e6b2a6c9cefaf71e05_Out_2);
            float2 _TilingAndOffset_6aa09ab2395d44b18a728391c05e4d34_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_0220ad02561645b5808016c0775b50f2_Out_0, _Vector2_e8284808a65b4a11b48aba11eff83428_Out_0, _TilingAndOffset_6aa09ab2395d44b18a728391c05e4d34_Out_3);
            float4 _SampleTexture2D_1445a3a145f0494fb6101655445fd084_RGBA_0 = SAMPLE_TEXTURE2D(_Property_720e4d2150bb4c60b112ba418350b06c_Out_0.tex, _Property_720e4d2150bb4c60b112ba418350b06c_Out_0.samplerstate, _Property_720e4d2150bb4c60b112ba418350b06c_Out_0.GetTransformedUV(_TilingAndOffset_6aa09ab2395d44b18a728391c05e4d34_Out_3));
            float _SampleTexture2D_1445a3a145f0494fb6101655445fd084_R_4 = _SampleTexture2D_1445a3a145f0494fb6101655445fd084_RGBA_0.r;
            float _SampleTexture2D_1445a3a145f0494fb6101655445fd084_G_5 = _SampleTexture2D_1445a3a145f0494fb6101655445fd084_RGBA_0.g;
            float _SampleTexture2D_1445a3a145f0494fb6101655445fd084_B_6 = _SampleTexture2D_1445a3a145f0494fb6101655445fd084_RGBA_0.b;
            float _SampleTexture2D_1445a3a145f0494fb6101655445fd084_A_7 = _SampleTexture2D_1445a3a145f0494fb6101655445fd084_RGBA_0.a;
            float4 _Multiply_1e0d5ab94f084efa9e56270220982c0d_Out_2;
            Unity_Multiply_float4_float4(_Multiply_544c1a00069f4992a46fc44db20f92f0_Out_2, (_SampleTexture2D_1445a3a145f0494fb6101655445fd084_R_4.xxxx), _Multiply_1e0d5ab94f084efa9e56270220982c0d_Out_2);
            surface.Alpha = (_Multiply_1e0d5ab94f084efa9e56270220982c0d_Out_2).x;
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
        Cull Off
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
        float4 _Color;
        float4 _Color2;
        float4 _Color3;
        float4 _Color4;
        float4 _Mask_TexelSize;
        float2 _Tilling;
        float _Move;
        float _Speed;
        float4 _Mask2_TexelSize;
        float _ColorSpeed;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_MainTex);
        SAMPLER(sampler_MainTex);
        TEXTURE2D(_Mask);
        SAMPLER(sampler_Mask);
        TEXTURE2D(_Mask2);
        SAMPLER(sampler_Mask2);
        
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
        
        void Unity_OneMinus_float4(float4 In, out float4 Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
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
            UnityTexture2D _Property_cd673621650149ebacf2c467fd6cbec7_Out_0 = UnityBuildTexture2DStructNoScale(_Mask2);
            float4 _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_RGBA_0 = SAMPLE_TEXTURE2D(_Property_cd673621650149ebacf2c467fd6cbec7_Out_0.tex, _Property_cd673621650149ebacf2c467fd6cbec7_Out_0.samplerstate, _Property_cd673621650149ebacf2c467fd6cbec7_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_R_4 = _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_RGBA_0.r;
            float _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_G_5 = _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_RGBA_0.g;
            float _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_B_6 = _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_RGBA_0.b;
            float _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_A_7 = _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_RGBA_0.a;
            float4 _OneMinus_9110807526f147c6b89c8ee3881a9256_Out_1;
            Unity_OneMinus_float4(_SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_RGBA_0, _OneMinus_9110807526f147c6b89c8ee3881a9256_Out_1);
            UnityTexture2D _Property_fa540f388df540609b44289e408721ce_Out_0 = UnityBuildTexture2DStructNoScale(_MainTex);
            float4 _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_RGBA_0 = SAMPLE_TEXTURE2D(_Property_fa540f388df540609b44289e408721ce_Out_0.tex, _Property_fa540f388df540609b44289e408721ce_Out_0.samplerstate, _Property_fa540f388df540609b44289e408721ce_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_R_4 = _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_RGBA_0.r;
            float _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_G_5 = _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_RGBA_0.g;
            float _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_B_6 = _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_RGBA_0.b;
            float _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_A_7 = _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_RGBA_0.a;
            float4 _Multiply_544c1a00069f4992a46fc44db20f92f0_Out_2;
            Unity_Multiply_float4_float4(_OneMinus_9110807526f147c6b89c8ee3881a9256_Out_1, _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_RGBA_0, _Multiply_544c1a00069f4992a46fc44db20f92f0_Out_2);
            UnityTexture2D _Property_720e4d2150bb4c60b112ba418350b06c_Out_0 = UnityBuildTexture2DStructNoScale(_Mask);
            float2 _Property_0220ad02561645b5808016c0775b50f2_Out_0 = _Tilling;
            float _Property_5398e72b3dc44eaf9b79ea0d4f8af707_Out_0 = _Move;
            float _Property_fae368b578414d37b2ac2f98eba0219e_Out_0 = _Speed;
            float _Multiply_427e1a3cc85c42e6b2a6c9cefaf71e05_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_fae368b578414d37b2ac2f98eba0219e_Out_0, _Multiply_427e1a3cc85c42e6b2a6c9cefaf71e05_Out_2);
            float2 _Vector2_e8284808a65b4a11b48aba11eff83428_Out_0 = float2(_Property_5398e72b3dc44eaf9b79ea0d4f8af707_Out_0, _Multiply_427e1a3cc85c42e6b2a6c9cefaf71e05_Out_2);
            float2 _TilingAndOffset_6aa09ab2395d44b18a728391c05e4d34_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_0220ad02561645b5808016c0775b50f2_Out_0, _Vector2_e8284808a65b4a11b48aba11eff83428_Out_0, _TilingAndOffset_6aa09ab2395d44b18a728391c05e4d34_Out_3);
            float4 _SampleTexture2D_1445a3a145f0494fb6101655445fd084_RGBA_0 = SAMPLE_TEXTURE2D(_Property_720e4d2150bb4c60b112ba418350b06c_Out_0.tex, _Property_720e4d2150bb4c60b112ba418350b06c_Out_0.samplerstate, _Property_720e4d2150bb4c60b112ba418350b06c_Out_0.GetTransformedUV(_TilingAndOffset_6aa09ab2395d44b18a728391c05e4d34_Out_3));
            float _SampleTexture2D_1445a3a145f0494fb6101655445fd084_R_4 = _SampleTexture2D_1445a3a145f0494fb6101655445fd084_RGBA_0.r;
            float _SampleTexture2D_1445a3a145f0494fb6101655445fd084_G_5 = _SampleTexture2D_1445a3a145f0494fb6101655445fd084_RGBA_0.g;
            float _SampleTexture2D_1445a3a145f0494fb6101655445fd084_B_6 = _SampleTexture2D_1445a3a145f0494fb6101655445fd084_RGBA_0.b;
            float _SampleTexture2D_1445a3a145f0494fb6101655445fd084_A_7 = _SampleTexture2D_1445a3a145f0494fb6101655445fd084_RGBA_0.a;
            float4 _Multiply_1e0d5ab94f084efa9e56270220982c0d_Out_2;
            Unity_Multiply_float4_float4(_Multiply_544c1a00069f4992a46fc44db20f92f0_Out_2, (_SampleTexture2D_1445a3a145f0494fb6101655445fd084_R_4.xxxx), _Multiply_1e0d5ab94f084efa9e56270220982c0d_Out_2);
            surface.Alpha = (_Multiply_1e0d5ab94f084efa9e56270220982c0d_Out_2).x;
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
        float4 _Color;
        float4 _Color2;
        float4 _Color3;
        float4 _Color4;
        float4 _Mask_TexelSize;
        float2 _Tilling;
        float _Move;
        float _Speed;
        float4 _Mask2_TexelSize;
        float _ColorSpeed;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_MainTex);
        SAMPLER(sampler_MainTex);
        TEXTURE2D(_Mask);
        SAMPLER(sampler_Mask);
        TEXTURE2D(_Mask2);
        SAMPLER(sampler_Mask2);
        
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
        
        void Unity_OneMinus_float4(float4 In, out float4 Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
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
            UnityTexture2D _Property_cd673621650149ebacf2c467fd6cbec7_Out_0 = UnityBuildTexture2DStructNoScale(_Mask2);
            float4 _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_RGBA_0 = SAMPLE_TEXTURE2D(_Property_cd673621650149ebacf2c467fd6cbec7_Out_0.tex, _Property_cd673621650149ebacf2c467fd6cbec7_Out_0.samplerstate, _Property_cd673621650149ebacf2c467fd6cbec7_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_R_4 = _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_RGBA_0.r;
            float _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_G_5 = _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_RGBA_0.g;
            float _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_B_6 = _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_RGBA_0.b;
            float _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_A_7 = _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_RGBA_0.a;
            float4 _OneMinus_9110807526f147c6b89c8ee3881a9256_Out_1;
            Unity_OneMinus_float4(_SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_RGBA_0, _OneMinus_9110807526f147c6b89c8ee3881a9256_Out_1);
            UnityTexture2D _Property_fa540f388df540609b44289e408721ce_Out_0 = UnityBuildTexture2DStructNoScale(_MainTex);
            float4 _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_RGBA_0 = SAMPLE_TEXTURE2D(_Property_fa540f388df540609b44289e408721ce_Out_0.tex, _Property_fa540f388df540609b44289e408721ce_Out_0.samplerstate, _Property_fa540f388df540609b44289e408721ce_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_R_4 = _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_RGBA_0.r;
            float _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_G_5 = _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_RGBA_0.g;
            float _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_B_6 = _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_RGBA_0.b;
            float _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_A_7 = _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_RGBA_0.a;
            float4 _Multiply_544c1a00069f4992a46fc44db20f92f0_Out_2;
            Unity_Multiply_float4_float4(_OneMinus_9110807526f147c6b89c8ee3881a9256_Out_1, _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_RGBA_0, _Multiply_544c1a00069f4992a46fc44db20f92f0_Out_2);
            UnityTexture2D _Property_720e4d2150bb4c60b112ba418350b06c_Out_0 = UnityBuildTexture2DStructNoScale(_Mask);
            float2 _Property_0220ad02561645b5808016c0775b50f2_Out_0 = _Tilling;
            float _Property_5398e72b3dc44eaf9b79ea0d4f8af707_Out_0 = _Move;
            float _Property_fae368b578414d37b2ac2f98eba0219e_Out_0 = _Speed;
            float _Multiply_427e1a3cc85c42e6b2a6c9cefaf71e05_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_fae368b578414d37b2ac2f98eba0219e_Out_0, _Multiply_427e1a3cc85c42e6b2a6c9cefaf71e05_Out_2);
            float2 _Vector2_e8284808a65b4a11b48aba11eff83428_Out_0 = float2(_Property_5398e72b3dc44eaf9b79ea0d4f8af707_Out_0, _Multiply_427e1a3cc85c42e6b2a6c9cefaf71e05_Out_2);
            float2 _TilingAndOffset_6aa09ab2395d44b18a728391c05e4d34_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_0220ad02561645b5808016c0775b50f2_Out_0, _Vector2_e8284808a65b4a11b48aba11eff83428_Out_0, _TilingAndOffset_6aa09ab2395d44b18a728391c05e4d34_Out_3);
            float4 _SampleTexture2D_1445a3a145f0494fb6101655445fd084_RGBA_0 = SAMPLE_TEXTURE2D(_Property_720e4d2150bb4c60b112ba418350b06c_Out_0.tex, _Property_720e4d2150bb4c60b112ba418350b06c_Out_0.samplerstate, _Property_720e4d2150bb4c60b112ba418350b06c_Out_0.GetTransformedUV(_TilingAndOffset_6aa09ab2395d44b18a728391c05e4d34_Out_3));
            float _SampleTexture2D_1445a3a145f0494fb6101655445fd084_R_4 = _SampleTexture2D_1445a3a145f0494fb6101655445fd084_RGBA_0.r;
            float _SampleTexture2D_1445a3a145f0494fb6101655445fd084_G_5 = _SampleTexture2D_1445a3a145f0494fb6101655445fd084_RGBA_0.g;
            float _SampleTexture2D_1445a3a145f0494fb6101655445fd084_B_6 = _SampleTexture2D_1445a3a145f0494fb6101655445fd084_RGBA_0.b;
            float _SampleTexture2D_1445a3a145f0494fb6101655445fd084_A_7 = _SampleTexture2D_1445a3a145f0494fb6101655445fd084_RGBA_0.a;
            float4 _Multiply_1e0d5ab94f084efa9e56270220982c0d_Out_2;
            Unity_Multiply_float4_float4(_Multiply_544c1a00069f4992a46fc44db20f92f0_Out_2, (_SampleTexture2D_1445a3a145f0494fb6101655445fd084_R_4.xxxx), _Multiply_1e0d5ab94f084efa9e56270220982c0d_Out_2);
            surface.Alpha = (_Multiply_1e0d5ab94f084efa9e56270220982c0d_Out_2).x;
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
        float4 _Color;
        float4 _Color2;
        float4 _Color3;
        float4 _Color4;
        float4 _Mask_TexelSize;
        float2 _Tilling;
        float _Move;
        float _Speed;
        float4 _Mask2_TexelSize;
        float _ColorSpeed;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_MainTex);
        SAMPLER(sampler_MainTex);
        TEXTURE2D(_Mask);
        SAMPLER(sampler_Mask);
        TEXTURE2D(_Mask2);
        SAMPLER(sampler_Mask2);
        
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
        
        void Unity_OneMinus_float4(float4 In, out float4 Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
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
            UnityTexture2D _Property_cd673621650149ebacf2c467fd6cbec7_Out_0 = UnityBuildTexture2DStructNoScale(_Mask2);
            float4 _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_RGBA_0 = SAMPLE_TEXTURE2D(_Property_cd673621650149ebacf2c467fd6cbec7_Out_0.tex, _Property_cd673621650149ebacf2c467fd6cbec7_Out_0.samplerstate, _Property_cd673621650149ebacf2c467fd6cbec7_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_R_4 = _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_RGBA_0.r;
            float _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_G_5 = _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_RGBA_0.g;
            float _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_B_6 = _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_RGBA_0.b;
            float _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_A_7 = _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_RGBA_0.a;
            float4 _OneMinus_9110807526f147c6b89c8ee3881a9256_Out_1;
            Unity_OneMinus_float4(_SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_RGBA_0, _OneMinus_9110807526f147c6b89c8ee3881a9256_Out_1);
            UnityTexture2D _Property_fa540f388df540609b44289e408721ce_Out_0 = UnityBuildTexture2DStructNoScale(_MainTex);
            float4 _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_RGBA_0 = SAMPLE_TEXTURE2D(_Property_fa540f388df540609b44289e408721ce_Out_0.tex, _Property_fa540f388df540609b44289e408721ce_Out_0.samplerstate, _Property_fa540f388df540609b44289e408721ce_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_R_4 = _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_RGBA_0.r;
            float _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_G_5 = _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_RGBA_0.g;
            float _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_B_6 = _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_RGBA_0.b;
            float _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_A_7 = _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_RGBA_0.a;
            float4 _Multiply_544c1a00069f4992a46fc44db20f92f0_Out_2;
            Unity_Multiply_float4_float4(_OneMinus_9110807526f147c6b89c8ee3881a9256_Out_1, _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_RGBA_0, _Multiply_544c1a00069f4992a46fc44db20f92f0_Out_2);
            UnityTexture2D _Property_720e4d2150bb4c60b112ba418350b06c_Out_0 = UnityBuildTexture2DStructNoScale(_Mask);
            float2 _Property_0220ad02561645b5808016c0775b50f2_Out_0 = _Tilling;
            float _Property_5398e72b3dc44eaf9b79ea0d4f8af707_Out_0 = _Move;
            float _Property_fae368b578414d37b2ac2f98eba0219e_Out_0 = _Speed;
            float _Multiply_427e1a3cc85c42e6b2a6c9cefaf71e05_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_fae368b578414d37b2ac2f98eba0219e_Out_0, _Multiply_427e1a3cc85c42e6b2a6c9cefaf71e05_Out_2);
            float2 _Vector2_e8284808a65b4a11b48aba11eff83428_Out_0 = float2(_Property_5398e72b3dc44eaf9b79ea0d4f8af707_Out_0, _Multiply_427e1a3cc85c42e6b2a6c9cefaf71e05_Out_2);
            float2 _TilingAndOffset_6aa09ab2395d44b18a728391c05e4d34_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_0220ad02561645b5808016c0775b50f2_Out_0, _Vector2_e8284808a65b4a11b48aba11eff83428_Out_0, _TilingAndOffset_6aa09ab2395d44b18a728391c05e4d34_Out_3);
            float4 _SampleTexture2D_1445a3a145f0494fb6101655445fd084_RGBA_0 = SAMPLE_TEXTURE2D(_Property_720e4d2150bb4c60b112ba418350b06c_Out_0.tex, _Property_720e4d2150bb4c60b112ba418350b06c_Out_0.samplerstate, _Property_720e4d2150bb4c60b112ba418350b06c_Out_0.GetTransformedUV(_TilingAndOffset_6aa09ab2395d44b18a728391c05e4d34_Out_3));
            float _SampleTexture2D_1445a3a145f0494fb6101655445fd084_R_4 = _SampleTexture2D_1445a3a145f0494fb6101655445fd084_RGBA_0.r;
            float _SampleTexture2D_1445a3a145f0494fb6101655445fd084_G_5 = _SampleTexture2D_1445a3a145f0494fb6101655445fd084_RGBA_0.g;
            float _SampleTexture2D_1445a3a145f0494fb6101655445fd084_B_6 = _SampleTexture2D_1445a3a145f0494fb6101655445fd084_RGBA_0.b;
            float _SampleTexture2D_1445a3a145f0494fb6101655445fd084_A_7 = _SampleTexture2D_1445a3a145f0494fb6101655445fd084_RGBA_0.a;
            float4 _Multiply_1e0d5ab94f084efa9e56270220982c0d_Out_2;
            Unity_Multiply_float4_float4(_Multiply_544c1a00069f4992a46fc44db20f92f0_Out_2, (_SampleTexture2D_1445a3a145f0494fb6101655445fd084_R_4.xxxx), _Multiply_1e0d5ab94f084efa9e56270220982c0d_Out_2);
            surface.Alpha = (_Multiply_1e0d5ab94f084efa9e56270220982c0d_Out_2).x;
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
        Cull Off
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
        float4 _Color;
        float4 _Color2;
        float4 _Color3;
        float4 _Color4;
        float4 _Mask_TexelSize;
        float2 _Tilling;
        float _Move;
        float _Speed;
        float4 _Mask2_TexelSize;
        float _ColorSpeed;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_MainTex);
        SAMPLER(sampler_MainTex);
        TEXTURE2D(_Mask);
        SAMPLER(sampler_Mask);
        TEXTURE2D(_Mask2);
        SAMPLER(sampler_Mask2);
        
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
        
        void Unity_OneMinus_float4(float4 In, out float4 Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
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
            UnityTexture2D _Property_cd673621650149ebacf2c467fd6cbec7_Out_0 = UnityBuildTexture2DStructNoScale(_Mask2);
            float4 _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_RGBA_0 = SAMPLE_TEXTURE2D(_Property_cd673621650149ebacf2c467fd6cbec7_Out_0.tex, _Property_cd673621650149ebacf2c467fd6cbec7_Out_0.samplerstate, _Property_cd673621650149ebacf2c467fd6cbec7_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_R_4 = _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_RGBA_0.r;
            float _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_G_5 = _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_RGBA_0.g;
            float _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_B_6 = _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_RGBA_0.b;
            float _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_A_7 = _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_RGBA_0.a;
            float4 _OneMinus_9110807526f147c6b89c8ee3881a9256_Out_1;
            Unity_OneMinus_float4(_SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_RGBA_0, _OneMinus_9110807526f147c6b89c8ee3881a9256_Out_1);
            UnityTexture2D _Property_fa540f388df540609b44289e408721ce_Out_0 = UnityBuildTexture2DStructNoScale(_MainTex);
            float4 _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_RGBA_0 = SAMPLE_TEXTURE2D(_Property_fa540f388df540609b44289e408721ce_Out_0.tex, _Property_fa540f388df540609b44289e408721ce_Out_0.samplerstate, _Property_fa540f388df540609b44289e408721ce_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_R_4 = _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_RGBA_0.r;
            float _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_G_5 = _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_RGBA_0.g;
            float _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_B_6 = _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_RGBA_0.b;
            float _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_A_7 = _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_RGBA_0.a;
            float4 _Multiply_544c1a00069f4992a46fc44db20f92f0_Out_2;
            Unity_Multiply_float4_float4(_OneMinus_9110807526f147c6b89c8ee3881a9256_Out_1, _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_RGBA_0, _Multiply_544c1a00069f4992a46fc44db20f92f0_Out_2);
            UnityTexture2D _Property_720e4d2150bb4c60b112ba418350b06c_Out_0 = UnityBuildTexture2DStructNoScale(_Mask);
            float2 _Property_0220ad02561645b5808016c0775b50f2_Out_0 = _Tilling;
            float _Property_5398e72b3dc44eaf9b79ea0d4f8af707_Out_0 = _Move;
            float _Property_fae368b578414d37b2ac2f98eba0219e_Out_0 = _Speed;
            float _Multiply_427e1a3cc85c42e6b2a6c9cefaf71e05_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_fae368b578414d37b2ac2f98eba0219e_Out_0, _Multiply_427e1a3cc85c42e6b2a6c9cefaf71e05_Out_2);
            float2 _Vector2_e8284808a65b4a11b48aba11eff83428_Out_0 = float2(_Property_5398e72b3dc44eaf9b79ea0d4f8af707_Out_0, _Multiply_427e1a3cc85c42e6b2a6c9cefaf71e05_Out_2);
            float2 _TilingAndOffset_6aa09ab2395d44b18a728391c05e4d34_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_0220ad02561645b5808016c0775b50f2_Out_0, _Vector2_e8284808a65b4a11b48aba11eff83428_Out_0, _TilingAndOffset_6aa09ab2395d44b18a728391c05e4d34_Out_3);
            float4 _SampleTexture2D_1445a3a145f0494fb6101655445fd084_RGBA_0 = SAMPLE_TEXTURE2D(_Property_720e4d2150bb4c60b112ba418350b06c_Out_0.tex, _Property_720e4d2150bb4c60b112ba418350b06c_Out_0.samplerstate, _Property_720e4d2150bb4c60b112ba418350b06c_Out_0.GetTransformedUV(_TilingAndOffset_6aa09ab2395d44b18a728391c05e4d34_Out_3));
            float _SampleTexture2D_1445a3a145f0494fb6101655445fd084_R_4 = _SampleTexture2D_1445a3a145f0494fb6101655445fd084_RGBA_0.r;
            float _SampleTexture2D_1445a3a145f0494fb6101655445fd084_G_5 = _SampleTexture2D_1445a3a145f0494fb6101655445fd084_RGBA_0.g;
            float _SampleTexture2D_1445a3a145f0494fb6101655445fd084_B_6 = _SampleTexture2D_1445a3a145f0494fb6101655445fd084_RGBA_0.b;
            float _SampleTexture2D_1445a3a145f0494fb6101655445fd084_A_7 = _SampleTexture2D_1445a3a145f0494fb6101655445fd084_RGBA_0.a;
            float4 _Multiply_1e0d5ab94f084efa9e56270220982c0d_Out_2;
            Unity_Multiply_float4_float4(_Multiply_544c1a00069f4992a46fc44db20f92f0_Out_2, (_SampleTexture2D_1445a3a145f0494fb6101655445fd084_R_4.xxxx), _Multiply_1e0d5ab94f084efa9e56270220982c0d_Out_2);
            surface.Alpha = (_Multiply_1e0d5ab94f084efa9e56270220982c0d_Out_2).x;
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
        Cull Off
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
        float4 _Color;
        float4 _Color2;
        float4 _Color3;
        float4 _Color4;
        float4 _Mask_TexelSize;
        float2 _Tilling;
        float _Move;
        float _Speed;
        float4 _Mask2_TexelSize;
        float _ColorSpeed;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_MainTex);
        SAMPLER(sampler_MainTex);
        TEXTURE2D(_Mask);
        SAMPLER(sampler_Mask);
        TEXTURE2D(_Mask2);
        SAMPLER(sampler_Mask2);
        
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
        
        void Unity_OneMinus_float4(float4 In, out float4 Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Sine_float(float In, out float Out)
        {
            Out = sin(In);
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
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
            UnityTexture2D _Property_cd673621650149ebacf2c467fd6cbec7_Out_0 = UnityBuildTexture2DStructNoScale(_Mask2);
            float4 _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_RGBA_0 = SAMPLE_TEXTURE2D(_Property_cd673621650149ebacf2c467fd6cbec7_Out_0.tex, _Property_cd673621650149ebacf2c467fd6cbec7_Out_0.samplerstate, _Property_cd673621650149ebacf2c467fd6cbec7_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_R_4 = _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_RGBA_0.r;
            float _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_G_5 = _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_RGBA_0.g;
            float _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_B_6 = _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_RGBA_0.b;
            float _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_A_7 = _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_RGBA_0.a;
            float4 _OneMinus_9110807526f147c6b89c8ee3881a9256_Out_1;
            Unity_OneMinus_float4(_SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_RGBA_0, _OneMinus_9110807526f147c6b89c8ee3881a9256_Out_1);
            UnityTexture2D _Property_fa540f388df540609b44289e408721ce_Out_0 = UnityBuildTexture2DStructNoScale(_MainTex);
            float4 _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_RGBA_0 = SAMPLE_TEXTURE2D(_Property_fa540f388df540609b44289e408721ce_Out_0.tex, _Property_fa540f388df540609b44289e408721ce_Out_0.samplerstate, _Property_fa540f388df540609b44289e408721ce_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_R_4 = _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_RGBA_0.r;
            float _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_G_5 = _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_RGBA_0.g;
            float _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_B_6 = _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_RGBA_0.b;
            float _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_A_7 = _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_RGBA_0.a;
            float4 _Multiply_544c1a00069f4992a46fc44db20f92f0_Out_2;
            Unity_Multiply_float4_float4(_OneMinus_9110807526f147c6b89c8ee3881a9256_Out_1, _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_RGBA_0, _Multiply_544c1a00069f4992a46fc44db20f92f0_Out_2);
            UnityTexture2D _Property_720e4d2150bb4c60b112ba418350b06c_Out_0 = UnityBuildTexture2DStructNoScale(_Mask);
            float2 _Property_0220ad02561645b5808016c0775b50f2_Out_0 = _Tilling;
            float _Property_5398e72b3dc44eaf9b79ea0d4f8af707_Out_0 = _Move;
            float _Property_fae368b578414d37b2ac2f98eba0219e_Out_0 = _Speed;
            float _Multiply_427e1a3cc85c42e6b2a6c9cefaf71e05_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_fae368b578414d37b2ac2f98eba0219e_Out_0, _Multiply_427e1a3cc85c42e6b2a6c9cefaf71e05_Out_2);
            float2 _Vector2_e8284808a65b4a11b48aba11eff83428_Out_0 = float2(_Property_5398e72b3dc44eaf9b79ea0d4f8af707_Out_0, _Multiply_427e1a3cc85c42e6b2a6c9cefaf71e05_Out_2);
            float2 _TilingAndOffset_6aa09ab2395d44b18a728391c05e4d34_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_0220ad02561645b5808016c0775b50f2_Out_0, _Vector2_e8284808a65b4a11b48aba11eff83428_Out_0, _TilingAndOffset_6aa09ab2395d44b18a728391c05e4d34_Out_3);
            float4 _SampleTexture2D_1445a3a145f0494fb6101655445fd084_RGBA_0 = SAMPLE_TEXTURE2D(_Property_720e4d2150bb4c60b112ba418350b06c_Out_0.tex, _Property_720e4d2150bb4c60b112ba418350b06c_Out_0.samplerstate, _Property_720e4d2150bb4c60b112ba418350b06c_Out_0.GetTransformedUV(_TilingAndOffset_6aa09ab2395d44b18a728391c05e4d34_Out_3));
            float _SampleTexture2D_1445a3a145f0494fb6101655445fd084_R_4 = _SampleTexture2D_1445a3a145f0494fb6101655445fd084_RGBA_0.r;
            float _SampleTexture2D_1445a3a145f0494fb6101655445fd084_G_5 = _SampleTexture2D_1445a3a145f0494fb6101655445fd084_RGBA_0.g;
            float _SampleTexture2D_1445a3a145f0494fb6101655445fd084_B_6 = _SampleTexture2D_1445a3a145f0494fb6101655445fd084_RGBA_0.b;
            float _SampleTexture2D_1445a3a145f0494fb6101655445fd084_A_7 = _SampleTexture2D_1445a3a145f0494fb6101655445fd084_RGBA_0.a;
            float4 _Multiply_1e0d5ab94f084efa9e56270220982c0d_Out_2;
            Unity_Multiply_float4_float4(_Multiply_544c1a00069f4992a46fc44db20f92f0_Out_2, (_SampleTexture2D_1445a3a145f0494fb6101655445fd084_R_4.xxxx), _Multiply_1e0d5ab94f084efa9e56270220982c0d_Out_2);
            float4 _Property_8760ea6533344ee9922b142944ae6ad5_Out_0 = IsGammaSpace() ? LinearToSRGB(_Color3) : _Color3;
            float4 _Property_cc4b848634b54134ba1b7bcbea3cc549_Out_0 = IsGammaSpace() ? LinearToSRGB(_Color4) : _Color4;
            float _Multiply_c2cc77910fef4d8fbd17fb599ce5518a_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_fae368b578414d37b2ac2f98eba0219e_Out_0, _Multiply_c2cc77910fef4d8fbd17fb599ce5518a_Out_2);
            float _Sine_a725c9420b984bf2bc8264f31d3c5311_Out_1;
            Unity_Sine_float(_Multiply_c2cc77910fef4d8fbd17fb599ce5518a_Out_2, _Sine_a725c9420b984bf2bc8264f31d3c5311_Out_1);
            float _Remap_f569deacc8d847b4a611dba4d71c1e01_Out_3;
            Unity_Remap_float(_Sine_a725c9420b984bf2bc8264f31d3c5311_Out_1, float2 (-1, 1), float2 (0, 1), _Remap_f569deacc8d847b4a611dba4d71c1e01_Out_3);
            float4 _Lerp_6ad7180848164426b34e00ceae53071f_Out_3;
            Unity_Lerp_float4(_Property_8760ea6533344ee9922b142944ae6ad5_Out_0, _Property_cc4b848634b54134ba1b7bcbea3cc549_Out_0, (_Remap_f569deacc8d847b4a611dba4d71c1e01_Out_3.xxxx), _Lerp_6ad7180848164426b34e00ceae53071f_Out_3);
            float4 _Property_741392ff3e254965ac5abc5c69cbef3e_Out_0 = IsGammaSpace() ? LinearToSRGB(_Color) : _Color;
            float4 _Property_cdfdf6b4854047e7ba38c372adb82566_Out_0 = IsGammaSpace() ? LinearToSRGB(_Color2) : _Color2;
            float _Property_e06a44c369334c5ba84fd5762aa7b422_Out_0 = _ColorSpeed;
            float _Multiply_939668cebf9146d793fa55f29b72e6d4_Out_2;
            Unity_Multiply_float_float(_Property_e06a44c369334c5ba84fd5762aa7b422_Out_0, IN.TimeParameters.x, _Multiply_939668cebf9146d793fa55f29b72e6d4_Out_2);
            float _Sine_64edcc5d83af4c01821d12a499ee656a_Out_1;
            Unity_Sine_float(_Multiply_939668cebf9146d793fa55f29b72e6d4_Out_2, _Sine_64edcc5d83af4c01821d12a499ee656a_Out_1);
            float _Remap_9196ab8fb5794c68898099a97c1bd57f_Out_3;
            Unity_Remap_float(_Sine_64edcc5d83af4c01821d12a499ee656a_Out_1, float2 (-1, 1), float2 (0, 1), _Remap_9196ab8fb5794c68898099a97c1bd57f_Out_3);
            float4 _Lerp_97ac5e67510249e294cce56d3298bb44_Out_3;
            Unity_Lerp_float4(_Property_741392ff3e254965ac5abc5c69cbef3e_Out_0, _Property_cdfdf6b4854047e7ba38c372adb82566_Out_0, (_Remap_9196ab8fb5794c68898099a97c1bd57f_Out_3.xxxx), _Lerp_97ac5e67510249e294cce56d3298bb44_Out_3);
            float4 _Add_b4d3b56af07c49a5b9a7d823205d02fd_Out_2;
            Unity_Add_float4(_Lerp_6ad7180848164426b34e00ceae53071f_Out_3, _Lerp_97ac5e67510249e294cce56d3298bb44_Out_3, _Add_b4d3b56af07c49a5b9a7d823205d02fd_Out_2);
            float4 _Multiply_30b6f91fcd094b80b9ad387224af0a7e_Out_2;
            Unity_Multiply_float4_float4(_Multiply_1e0d5ab94f084efa9e56270220982c0d_Out_2, _Add_b4d3b56af07c49a5b9a7d823205d02fd_Out_2, _Multiply_30b6f91fcd094b80b9ad387224af0a7e_Out_2);
            surface.BaseColor = (_Multiply_30b6f91fcd094b80b9ad387224af0a7e_Out_2.xyz);
            surface.Alpha = (_Multiply_1e0d5ab94f084efa9e56270220982c0d_Out_2).x;
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
        Cull Off
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
        float4 _Color;
        float4 _Color2;
        float4 _Color3;
        float4 _Color4;
        float4 _Mask_TexelSize;
        float2 _Tilling;
        float _Move;
        float _Speed;
        float4 _Mask2_TexelSize;
        float _ColorSpeed;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_MainTex);
        SAMPLER(sampler_MainTex);
        TEXTURE2D(_Mask);
        SAMPLER(sampler_Mask);
        TEXTURE2D(_Mask2);
        SAMPLER(sampler_Mask2);
        
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
        
        void Unity_OneMinus_float4(float4 In, out float4 Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
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
            UnityTexture2D _Property_cd673621650149ebacf2c467fd6cbec7_Out_0 = UnityBuildTexture2DStructNoScale(_Mask2);
            float4 _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_RGBA_0 = SAMPLE_TEXTURE2D(_Property_cd673621650149ebacf2c467fd6cbec7_Out_0.tex, _Property_cd673621650149ebacf2c467fd6cbec7_Out_0.samplerstate, _Property_cd673621650149ebacf2c467fd6cbec7_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_R_4 = _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_RGBA_0.r;
            float _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_G_5 = _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_RGBA_0.g;
            float _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_B_6 = _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_RGBA_0.b;
            float _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_A_7 = _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_RGBA_0.a;
            float4 _OneMinus_9110807526f147c6b89c8ee3881a9256_Out_1;
            Unity_OneMinus_float4(_SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_RGBA_0, _OneMinus_9110807526f147c6b89c8ee3881a9256_Out_1);
            UnityTexture2D _Property_fa540f388df540609b44289e408721ce_Out_0 = UnityBuildTexture2DStructNoScale(_MainTex);
            float4 _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_RGBA_0 = SAMPLE_TEXTURE2D(_Property_fa540f388df540609b44289e408721ce_Out_0.tex, _Property_fa540f388df540609b44289e408721ce_Out_0.samplerstate, _Property_fa540f388df540609b44289e408721ce_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_R_4 = _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_RGBA_0.r;
            float _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_G_5 = _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_RGBA_0.g;
            float _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_B_6 = _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_RGBA_0.b;
            float _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_A_7 = _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_RGBA_0.a;
            float4 _Multiply_544c1a00069f4992a46fc44db20f92f0_Out_2;
            Unity_Multiply_float4_float4(_OneMinus_9110807526f147c6b89c8ee3881a9256_Out_1, _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_RGBA_0, _Multiply_544c1a00069f4992a46fc44db20f92f0_Out_2);
            UnityTexture2D _Property_720e4d2150bb4c60b112ba418350b06c_Out_0 = UnityBuildTexture2DStructNoScale(_Mask);
            float2 _Property_0220ad02561645b5808016c0775b50f2_Out_0 = _Tilling;
            float _Property_5398e72b3dc44eaf9b79ea0d4f8af707_Out_0 = _Move;
            float _Property_fae368b578414d37b2ac2f98eba0219e_Out_0 = _Speed;
            float _Multiply_427e1a3cc85c42e6b2a6c9cefaf71e05_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_fae368b578414d37b2ac2f98eba0219e_Out_0, _Multiply_427e1a3cc85c42e6b2a6c9cefaf71e05_Out_2);
            float2 _Vector2_e8284808a65b4a11b48aba11eff83428_Out_0 = float2(_Property_5398e72b3dc44eaf9b79ea0d4f8af707_Out_0, _Multiply_427e1a3cc85c42e6b2a6c9cefaf71e05_Out_2);
            float2 _TilingAndOffset_6aa09ab2395d44b18a728391c05e4d34_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_0220ad02561645b5808016c0775b50f2_Out_0, _Vector2_e8284808a65b4a11b48aba11eff83428_Out_0, _TilingAndOffset_6aa09ab2395d44b18a728391c05e4d34_Out_3);
            float4 _SampleTexture2D_1445a3a145f0494fb6101655445fd084_RGBA_0 = SAMPLE_TEXTURE2D(_Property_720e4d2150bb4c60b112ba418350b06c_Out_0.tex, _Property_720e4d2150bb4c60b112ba418350b06c_Out_0.samplerstate, _Property_720e4d2150bb4c60b112ba418350b06c_Out_0.GetTransformedUV(_TilingAndOffset_6aa09ab2395d44b18a728391c05e4d34_Out_3));
            float _SampleTexture2D_1445a3a145f0494fb6101655445fd084_R_4 = _SampleTexture2D_1445a3a145f0494fb6101655445fd084_RGBA_0.r;
            float _SampleTexture2D_1445a3a145f0494fb6101655445fd084_G_5 = _SampleTexture2D_1445a3a145f0494fb6101655445fd084_RGBA_0.g;
            float _SampleTexture2D_1445a3a145f0494fb6101655445fd084_B_6 = _SampleTexture2D_1445a3a145f0494fb6101655445fd084_RGBA_0.b;
            float _SampleTexture2D_1445a3a145f0494fb6101655445fd084_A_7 = _SampleTexture2D_1445a3a145f0494fb6101655445fd084_RGBA_0.a;
            float4 _Multiply_1e0d5ab94f084efa9e56270220982c0d_Out_2;
            Unity_Multiply_float4_float4(_Multiply_544c1a00069f4992a46fc44db20f92f0_Out_2, (_SampleTexture2D_1445a3a145f0494fb6101655445fd084_R_4.xxxx), _Multiply_1e0d5ab94f084efa9e56270220982c0d_Out_2);
            surface.Alpha = (_Multiply_1e0d5ab94f084efa9e56270220982c0d_Out_2).x;
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
        Cull Off
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
        float4 _Color;
        float4 _Color2;
        float4 _Color3;
        float4 _Color4;
        float4 _Mask_TexelSize;
        float2 _Tilling;
        float _Move;
        float _Speed;
        float4 _Mask2_TexelSize;
        float _ColorSpeed;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_MainTex);
        SAMPLER(sampler_MainTex);
        TEXTURE2D(_Mask);
        SAMPLER(sampler_Mask);
        TEXTURE2D(_Mask2);
        SAMPLER(sampler_Mask2);
        
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
        
        void Unity_OneMinus_float4(float4 In, out float4 Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
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
            UnityTexture2D _Property_cd673621650149ebacf2c467fd6cbec7_Out_0 = UnityBuildTexture2DStructNoScale(_Mask2);
            float4 _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_RGBA_0 = SAMPLE_TEXTURE2D(_Property_cd673621650149ebacf2c467fd6cbec7_Out_0.tex, _Property_cd673621650149ebacf2c467fd6cbec7_Out_0.samplerstate, _Property_cd673621650149ebacf2c467fd6cbec7_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_R_4 = _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_RGBA_0.r;
            float _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_G_5 = _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_RGBA_0.g;
            float _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_B_6 = _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_RGBA_0.b;
            float _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_A_7 = _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_RGBA_0.a;
            float4 _OneMinus_9110807526f147c6b89c8ee3881a9256_Out_1;
            Unity_OneMinus_float4(_SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_RGBA_0, _OneMinus_9110807526f147c6b89c8ee3881a9256_Out_1);
            UnityTexture2D _Property_fa540f388df540609b44289e408721ce_Out_0 = UnityBuildTexture2DStructNoScale(_MainTex);
            float4 _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_RGBA_0 = SAMPLE_TEXTURE2D(_Property_fa540f388df540609b44289e408721ce_Out_0.tex, _Property_fa540f388df540609b44289e408721ce_Out_0.samplerstate, _Property_fa540f388df540609b44289e408721ce_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_R_4 = _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_RGBA_0.r;
            float _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_G_5 = _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_RGBA_0.g;
            float _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_B_6 = _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_RGBA_0.b;
            float _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_A_7 = _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_RGBA_0.a;
            float4 _Multiply_544c1a00069f4992a46fc44db20f92f0_Out_2;
            Unity_Multiply_float4_float4(_OneMinus_9110807526f147c6b89c8ee3881a9256_Out_1, _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_RGBA_0, _Multiply_544c1a00069f4992a46fc44db20f92f0_Out_2);
            UnityTexture2D _Property_720e4d2150bb4c60b112ba418350b06c_Out_0 = UnityBuildTexture2DStructNoScale(_Mask);
            float2 _Property_0220ad02561645b5808016c0775b50f2_Out_0 = _Tilling;
            float _Property_5398e72b3dc44eaf9b79ea0d4f8af707_Out_0 = _Move;
            float _Property_fae368b578414d37b2ac2f98eba0219e_Out_0 = _Speed;
            float _Multiply_427e1a3cc85c42e6b2a6c9cefaf71e05_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_fae368b578414d37b2ac2f98eba0219e_Out_0, _Multiply_427e1a3cc85c42e6b2a6c9cefaf71e05_Out_2);
            float2 _Vector2_e8284808a65b4a11b48aba11eff83428_Out_0 = float2(_Property_5398e72b3dc44eaf9b79ea0d4f8af707_Out_0, _Multiply_427e1a3cc85c42e6b2a6c9cefaf71e05_Out_2);
            float2 _TilingAndOffset_6aa09ab2395d44b18a728391c05e4d34_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_0220ad02561645b5808016c0775b50f2_Out_0, _Vector2_e8284808a65b4a11b48aba11eff83428_Out_0, _TilingAndOffset_6aa09ab2395d44b18a728391c05e4d34_Out_3);
            float4 _SampleTexture2D_1445a3a145f0494fb6101655445fd084_RGBA_0 = SAMPLE_TEXTURE2D(_Property_720e4d2150bb4c60b112ba418350b06c_Out_0.tex, _Property_720e4d2150bb4c60b112ba418350b06c_Out_0.samplerstate, _Property_720e4d2150bb4c60b112ba418350b06c_Out_0.GetTransformedUV(_TilingAndOffset_6aa09ab2395d44b18a728391c05e4d34_Out_3));
            float _SampleTexture2D_1445a3a145f0494fb6101655445fd084_R_4 = _SampleTexture2D_1445a3a145f0494fb6101655445fd084_RGBA_0.r;
            float _SampleTexture2D_1445a3a145f0494fb6101655445fd084_G_5 = _SampleTexture2D_1445a3a145f0494fb6101655445fd084_RGBA_0.g;
            float _SampleTexture2D_1445a3a145f0494fb6101655445fd084_B_6 = _SampleTexture2D_1445a3a145f0494fb6101655445fd084_RGBA_0.b;
            float _SampleTexture2D_1445a3a145f0494fb6101655445fd084_A_7 = _SampleTexture2D_1445a3a145f0494fb6101655445fd084_RGBA_0.a;
            float4 _Multiply_1e0d5ab94f084efa9e56270220982c0d_Out_2;
            Unity_Multiply_float4_float4(_Multiply_544c1a00069f4992a46fc44db20f92f0_Out_2, (_SampleTexture2D_1445a3a145f0494fb6101655445fd084_R_4.xxxx), _Multiply_1e0d5ab94f084efa9e56270220982c0d_Out_2);
            surface.Alpha = (_Multiply_1e0d5ab94f084efa9e56270220982c0d_Out_2).x;
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
        float4 _Color;
        float4 _Color2;
        float4 _Color3;
        float4 _Color4;
        float4 _Mask_TexelSize;
        float2 _Tilling;
        float _Move;
        float _Speed;
        float4 _Mask2_TexelSize;
        float _ColorSpeed;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_MainTex);
        SAMPLER(sampler_MainTex);
        TEXTURE2D(_Mask);
        SAMPLER(sampler_Mask);
        TEXTURE2D(_Mask2);
        SAMPLER(sampler_Mask2);
        
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
        
        void Unity_OneMinus_float4(float4 In, out float4 Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
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
            UnityTexture2D _Property_cd673621650149ebacf2c467fd6cbec7_Out_0 = UnityBuildTexture2DStructNoScale(_Mask2);
            float4 _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_RGBA_0 = SAMPLE_TEXTURE2D(_Property_cd673621650149ebacf2c467fd6cbec7_Out_0.tex, _Property_cd673621650149ebacf2c467fd6cbec7_Out_0.samplerstate, _Property_cd673621650149ebacf2c467fd6cbec7_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_R_4 = _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_RGBA_0.r;
            float _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_G_5 = _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_RGBA_0.g;
            float _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_B_6 = _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_RGBA_0.b;
            float _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_A_7 = _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_RGBA_0.a;
            float4 _OneMinus_9110807526f147c6b89c8ee3881a9256_Out_1;
            Unity_OneMinus_float4(_SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_RGBA_0, _OneMinus_9110807526f147c6b89c8ee3881a9256_Out_1);
            UnityTexture2D _Property_fa540f388df540609b44289e408721ce_Out_0 = UnityBuildTexture2DStructNoScale(_MainTex);
            float4 _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_RGBA_0 = SAMPLE_TEXTURE2D(_Property_fa540f388df540609b44289e408721ce_Out_0.tex, _Property_fa540f388df540609b44289e408721ce_Out_0.samplerstate, _Property_fa540f388df540609b44289e408721ce_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_R_4 = _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_RGBA_0.r;
            float _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_G_5 = _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_RGBA_0.g;
            float _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_B_6 = _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_RGBA_0.b;
            float _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_A_7 = _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_RGBA_0.a;
            float4 _Multiply_544c1a00069f4992a46fc44db20f92f0_Out_2;
            Unity_Multiply_float4_float4(_OneMinus_9110807526f147c6b89c8ee3881a9256_Out_1, _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_RGBA_0, _Multiply_544c1a00069f4992a46fc44db20f92f0_Out_2);
            UnityTexture2D _Property_720e4d2150bb4c60b112ba418350b06c_Out_0 = UnityBuildTexture2DStructNoScale(_Mask);
            float2 _Property_0220ad02561645b5808016c0775b50f2_Out_0 = _Tilling;
            float _Property_5398e72b3dc44eaf9b79ea0d4f8af707_Out_0 = _Move;
            float _Property_fae368b578414d37b2ac2f98eba0219e_Out_0 = _Speed;
            float _Multiply_427e1a3cc85c42e6b2a6c9cefaf71e05_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_fae368b578414d37b2ac2f98eba0219e_Out_0, _Multiply_427e1a3cc85c42e6b2a6c9cefaf71e05_Out_2);
            float2 _Vector2_e8284808a65b4a11b48aba11eff83428_Out_0 = float2(_Property_5398e72b3dc44eaf9b79ea0d4f8af707_Out_0, _Multiply_427e1a3cc85c42e6b2a6c9cefaf71e05_Out_2);
            float2 _TilingAndOffset_6aa09ab2395d44b18a728391c05e4d34_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_0220ad02561645b5808016c0775b50f2_Out_0, _Vector2_e8284808a65b4a11b48aba11eff83428_Out_0, _TilingAndOffset_6aa09ab2395d44b18a728391c05e4d34_Out_3);
            float4 _SampleTexture2D_1445a3a145f0494fb6101655445fd084_RGBA_0 = SAMPLE_TEXTURE2D(_Property_720e4d2150bb4c60b112ba418350b06c_Out_0.tex, _Property_720e4d2150bb4c60b112ba418350b06c_Out_0.samplerstate, _Property_720e4d2150bb4c60b112ba418350b06c_Out_0.GetTransformedUV(_TilingAndOffset_6aa09ab2395d44b18a728391c05e4d34_Out_3));
            float _SampleTexture2D_1445a3a145f0494fb6101655445fd084_R_4 = _SampleTexture2D_1445a3a145f0494fb6101655445fd084_RGBA_0.r;
            float _SampleTexture2D_1445a3a145f0494fb6101655445fd084_G_5 = _SampleTexture2D_1445a3a145f0494fb6101655445fd084_RGBA_0.g;
            float _SampleTexture2D_1445a3a145f0494fb6101655445fd084_B_6 = _SampleTexture2D_1445a3a145f0494fb6101655445fd084_RGBA_0.b;
            float _SampleTexture2D_1445a3a145f0494fb6101655445fd084_A_7 = _SampleTexture2D_1445a3a145f0494fb6101655445fd084_RGBA_0.a;
            float4 _Multiply_1e0d5ab94f084efa9e56270220982c0d_Out_2;
            Unity_Multiply_float4_float4(_Multiply_544c1a00069f4992a46fc44db20f92f0_Out_2, (_SampleTexture2D_1445a3a145f0494fb6101655445fd084_R_4.xxxx), _Multiply_1e0d5ab94f084efa9e56270220982c0d_Out_2);
            surface.Alpha = (_Multiply_1e0d5ab94f084efa9e56270220982c0d_Out_2).x;
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
        float4 _Color;
        float4 _Color2;
        float4 _Color3;
        float4 _Color4;
        float4 _Mask_TexelSize;
        float2 _Tilling;
        float _Move;
        float _Speed;
        float4 _Mask2_TexelSize;
        float _ColorSpeed;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_MainTex);
        SAMPLER(sampler_MainTex);
        TEXTURE2D(_Mask);
        SAMPLER(sampler_Mask);
        TEXTURE2D(_Mask2);
        SAMPLER(sampler_Mask2);
        
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
        
        void Unity_OneMinus_float4(float4 In, out float4 Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
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
            UnityTexture2D _Property_cd673621650149ebacf2c467fd6cbec7_Out_0 = UnityBuildTexture2DStructNoScale(_Mask2);
            float4 _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_RGBA_0 = SAMPLE_TEXTURE2D(_Property_cd673621650149ebacf2c467fd6cbec7_Out_0.tex, _Property_cd673621650149ebacf2c467fd6cbec7_Out_0.samplerstate, _Property_cd673621650149ebacf2c467fd6cbec7_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_R_4 = _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_RGBA_0.r;
            float _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_G_5 = _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_RGBA_0.g;
            float _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_B_6 = _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_RGBA_0.b;
            float _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_A_7 = _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_RGBA_0.a;
            float4 _OneMinus_9110807526f147c6b89c8ee3881a9256_Out_1;
            Unity_OneMinus_float4(_SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_RGBA_0, _OneMinus_9110807526f147c6b89c8ee3881a9256_Out_1);
            UnityTexture2D _Property_fa540f388df540609b44289e408721ce_Out_0 = UnityBuildTexture2DStructNoScale(_MainTex);
            float4 _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_RGBA_0 = SAMPLE_TEXTURE2D(_Property_fa540f388df540609b44289e408721ce_Out_0.tex, _Property_fa540f388df540609b44289e408721ce_Out_0.samplerstate, _Property_fa540f388df540609b44289e408721ce_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_R_4 = _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_RGBA_0.r;
            float _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_G_5 = _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_RGBA_0.g;
            float _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_B_6 = _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_RGBA_0.b;
            float _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_A_7 = _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_RGBA_0.a;
            float4 _Multiply_544c1a00069f4992a46fc44db20f92f0_Out_2;
            Unity_Multiply_float4_float4(_OneMinus_9110807526f147c6b89c8ee3881a9256_Out_1, _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_RGBA_0, _Multiply_544c1a00069f4992a46fc44db20f92f0_Out_2);
            UnityTexture2D _Property_720e4d2150bb4c60b112ba418350b06c_Out_0 = UnityBuildTexture2DStructNoScale(_Mask);
            float2 _Property_0220ad02561645b5808016c0775b50f2_Out_0 = _Tilling;
            float _Property_5398e72b3dc44eaf9b79ea0d4f8af707_Out_0 = _Move;
            float _Property_fae368b578414d37b2ac2f98eba0219e_Out_0 = _Speed;
            float _Multiply_427e1a3cc85c42e6b2a6c9cefaf71e05_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_fae368b578414d37b2ac2f98eba0219e_Out_0, _Multiply_427e1a3cc85c42e6b2a6c9cefaf71e05_Out_2);
            float2 _Vector2_e8284808a65b4a11b48aba11eff83428_Out_0 = float2(_Property_5398e72b3dc44eaf9b79ea0d4f8af707_Out_0, _Multiply_427e1a3cc85c42e6b2a6c9cefaf71e05_Out_2);
            float2 _TilingAndOffset_6aa09ab2395d44b18a728391c05e4d34_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_0220ad02561645b5808016c0775b50f2_Out_0, _Vector2_e8284808a65b4a11b48aba11eff83428_Out_0, _TilingAndOffset_6aa09ab2395d44b18a728391c05e4d34_Out_3);
            float4 _SampleTexture2D_1445a3a145f0494fb6101655445fd084_RGBA_0 = SAMPLE_TEXTURE2D(_Property_720e4d2150bb4c60b112ba418350b06c_Out_0.tex, _Property_720e4d2150bb4c60b112ba418350b06c_Out_0.samplerstate, _Property_720e4d2150bb4c60b112ba418350b06c_Out_0.GetTransformedUV(_TilingAndOffset_6aa09ab2395d44b18a728391c05e4d34_Out_3));
            float _SampleTexture2D_1445a3a145f0494fb6101655445fd084_R_4 = _SampleTexture2D_1445a3a145f0494fb6101655445fd084_RGBA_0.r;
            float _SampleTexture2D_1445a3a145f0494fb6101655445fd084_G_5 = _SampleTexture2D_1445a3a145f0494fb6101655445fd084_RGBA_0.g;
            float _SampleTexture2D_1445a3a145f0494fb6101655445fd084_B_6 = _SampleTexture2D_1445a3a145f0494fb6101655445fd084_RGBA_0.b;
            float _SampleTexture2D_1445a3a145f0494fb6101655445fd084_A_7 = _SampleTexture2D_1445a3a145f0494fb6101655445fd084_RGBA_0.a;
            float4 _Multiply_1e0d5ab94f084efa9e56270220982c0d_Out_2;
            Unity_Multiply_float4_float4(_Multiply_544c1a00069f4992a46fc44db20f92f0_Out_2, (_SampleTexture2D_1445a3a145f0494fb6101655445fd084_R_4.xxxx), _Multiply_1e0d5ab94f084efa9e56270220982c0d_Out_2);
            surface.Alpha = (_Multiply_1e0d5ab94f084efa9e56270220982c0d_Out_2).x;
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
        Cull Off
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
        float4 _Color;
        float4 _Color2;
        float4 _Color3;
        float4 _Color4;
        float4 _Mask_TexelSize;
        float2 _Tilling;
        float _Move;
        float _Speed;
        float4 _Mask2_TexelSize;
        float _ColorSpeed;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_MainTex);
        SAMPLER(sampler_MainTex);
        TEXTURE2D(_Mask);
        SAMPLER(sampler_Mask);
        TEXTURE2D(_Mask2);
        SAMPLER(sampler_Mask2);
        
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
        
        void Unity_OneMinus_float4(float4 In, out float4 Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
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
            UnityTexture2D _Property_cd673621650149ebacf2c467fd6cbec7_Out_0 = UnityBuildTexture2DStructNoScale(_Mask2);
            float4 _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_RGBA_0 = SAMPLE_TEXTURE2D(_Property_cd673621650149ebacf2c467fd6cbec7_Out_0.tex, _Property_cd673621650149ebacf2c467fd6cbec7_Out_0.samplerstate, _Property_cd673621650149ebacf2c467fd6cbec7_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_R_4 = _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_RGBA_0.r;
            float _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_G_5 = _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_RGBA_0.g;
            float _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_B_6 = _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_RGBA_0.b;
            float _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_A_7 = _SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_RGBA_0.a;
            float4 _OneMinus_9110807526f147c6b89c8ee3881a9256_Out_1;
            Unity_OneMinus_float4(_SampleTexture2D_bb2b1bd4c57e43128e3c18b6845e7e01_RGBA_0, _OneMinus_9110807526f147c6b89c8ee3881a9256_Out_1);
            UnityTexture2D _Property_fa540f388df540609b44289e408721ce_Out_0 = UnityBuildTexture2DStructNoScale(_MainTex);
            float4 _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_RGBA_0 = SAMPLE_TEXTURE2D(_Property_fa540f388df540609b44289e408721ce_Out_0.tex, _Property_fa540f388df540609b44289e408721ce_Out_0.samplerstate, _Property_fa540f388df540609b44289e408721ce_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_R_4 = _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_RGBA_0.r;
            float _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_G_5 = _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_RGBA_0.g;
            float _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_B_6 = _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_RGBA_0.b;
            float _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_A_7 = _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_RGBA_0.a;
            float4 _Multiply_544c1a00069f4992a46fc44db20f92f0_Out_2;
            Unity_Multiply_float4_float4(_OneMinus_9110807526f147c6b89c8ee3881a9256_Out_1, _SampleTexture2D_d6ba7f47d45943ac95d49ce7caa5d4e9_RGBA_0, _Multiply_544c1a00069f4992a46fc44db20f92f0_Out_2);
            UnityTexture2D _Property_720e4d2150bb4c60b112ba418350b06c_Out_0 = UnityBuildTexture2DStructNoScale(_Mask);
            float2 _Property_0220ad02561645b5808016c0775b50f2_Out_0 = _Tilling;
            float _Property_5398e72b3dc44eaf9b79ea0d4f8af707_Out_0 = _Move;
            float _Property_fae368b578414d37b2ac2f98eba0219e_Out_0 = _Speed;
            float _Multiply_427e1a3cc85c42e6b2a6c9cefaf71e05_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_fae368b578414d37b2ac2f98eba0219e_Out_0, _Multiply_427e1a3cc85c42e6b2a6c9cefaf71e05_Out_2);
            float2 _Vector2_e8284808a65b4a11b48aba11eff83428_Out_0 = float2(_Property_5398e72b3dc44eaf9b79ea0d4f8af707_Out_0, _Multiply_427e1a3cc85c42e6b2a6c9cefaf71e05_Out_2);
            float2 _TilingAndOffset_6aa09ab2395d44b18a728391c05e4d34_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_0220ad02561645b5808016c0775b50f2_Out_0, _Vector2_e8284808a65b4a11b48aba11eff83428_Out_0, _TilingAndOffset_6aa09ab2395d44b18a728391c05e4d34_Out_3);
            float4 _SampleTexture2D_1445a3a145f0494fb6101655445fd084_RGBA_0 = SAMPLE_TEXTURE2D(_Property_720e4d2150bb4c60b112ba418350b06c_Out_0.tex, _Property_720e4d2150bb4c60b112ba418350b06c_Out_0.samplerstate, _Property_720e4d2150bb4c60b112ba418350b06c_Out_0.GetTransformedUV(_TilingAndOffset_6aa09ab2395d44b18a728391c05e4d34_Out_3));
            float _SampleTexture2D_1445a3a145f0494fb6101655445fd084_R_4 = _SampleTexture2D_1445a3a145f0494fb6101655445fd084_RGBA_0.r;
            float _SampleTexture2D_1445a3a145f0494fb6101655445fd084_G_5 = _SampleTexture2D_1445a3a145f0494fb6101655445fd084_RGBA_0.g;
            float _SampleTexture2D_1445a3a145f0494fb6101655445fd084_B_6 = _SampleTexture2D_1445a3a145f0494fb6101655445fd084_RGBA_0.b;
            float _SampleTexture2D_1445a3a145f0494fb6101655445fd084_A_7 = _SampleTexture2D_1445a3a145f0494fb6101655445fd084_RGBA_0.a;
            float4 _Multiply_1e0d5ab94f084efa9e56270220982c0d_Out_2;
            Unity_Multiply_float4_float4(_Multiply_544c1a00069f4992a46fc44db20f92f0_Out_2, (_SampleTexture2D_1445a3a145f0494fb6101655445fd084_R_4.xxxx), _Multiply_1e0d5ab94f084efa9e56270220982c0d_Out_2);
            surface.Alpha = (_Multiply_1e0d5ab94f084efa9e56270220982c0d_Out_2).x;
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