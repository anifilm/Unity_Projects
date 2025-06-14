Shader "IndieImpulse/Unlit/IconEffectsPack/MoveLinesWithColors"
{
    Properties
    {
        [HDR]CircleColor("Color", Color) = (1, 1, 1, 1)
        [HDR]CircleColor_2("Color 2", Color) = (1, 1, 1, 1)
        [NoScaleOffset]Texture2D_bc1d9eb6d4344d4084d949d7b33e529a("Mask", 2D) = "white" {}
        [NoScaleOffset]_MainTex("MainTex", 2D) = "white" {}
        Vector2_47b54501113b4c409f7770bf21e02d97("MainTextSpeed", Vector) = (1, 0, 0, 0)
        Vector1_89bcc8638aeb4eb98b6b8b61db4dd490("AlphaClip", Range(0, 1)) = 0
        _ColorChangeSpeed("ColorChangeSpeed", Float) = 0
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
            "ShaderGraphTargetId"=""
        }
        Pass
        {
            Name "Sprite Unlit"
            Tags
            {
                "LightMode" = "Universal2D"
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
        #pragma exclude_renderers d3d11_9x
        #pragma vertex vert
        #pragma fragment frag
        
            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>
        
            // Keywords
            #pragma multi_compile_fragment _ DEBUG_DISPLAY
            // GraphKeywords: <None>
        
            // Defines
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_COLOR
            #define VARYINGS_NEED_POSITION_WS
            #define VARYINGS_NEED_TEXCOORD0
            #define VARYINGS_NEED_COLOR
            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_SPRITEUNLIT
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
            // Includes
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreInclude' */
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
            // --------------------------------------------------
            // Structs and Packing
        
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
            struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float4 texCoord0;
             float4 color;
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
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyzw =  input.texCoord0;
            output.interp2.xyzw =  input.color;
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
            output.texCoord0 = input.interp1.xyzw;
            output.color = input.interp2.xyzw;
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
        float4 CircleColor_2;
        float4 CircleColor;
        float4 Texture2D_bc1d9eb6d4344d4084d949d7b33e529a_TexelSize;
        float4 _MainTex_TexelSize;
        float2 Vector2_47b54501113b4c409f7770bf21e02d97;
        float Vector1_89bcc8638aeb4eb98b6b8b61db4dd490;
        float _ColorChangeSpeed;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Texture2D_bc1d9eb6d4344d4084d949d7b33e529a);
        SAMPLER(samplerTexture2D_bc1d9eb6d4344d4084d949d7b33e529a);
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
            
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
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
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_Rotate_Radians_float(float2 UV, float2 Center, float Rotation, out float2 Out)
        {
            //rotation matrix
            UV -= Center;
            float s = sin(Rotation);
            float c = cos(Rotation);
        
            //center rotation matrix
            float2x2 rMatrix = float2x2(c, -s, s, c);
            rMatrix *= 0.5;
            rMatrix += 0.5;
            rMatrix = rMatrix*2 - 1;
        
            //multiply the UVs by the rotation matrix
            UV.xy = mul(UV.xy, rMatrix);
            UV += Center;
        
            Out = UV;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
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
            float4 _Property_3740e7aeff3e44fa8ff9aa43444060c8_Out_0 = IsGammaSpace() ? LinearToSRGB(CircleColor_2) : CircleColor_2;
            float4 _Property_01bbe1e7680b401e874750d026308a46_Out_0 = IsGammaSpace() ? LinearToSRGB(CircleColor) : CircleColor;
            float _Property_167b0e71998c4c838a9de5d07dd06646_Out_0 = _ColorChangeSpeed;
            float _Multiply_50aa3b40f7a14bd7b87a6d5c409fe58c_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_167b0e71998c4c838a9de5d07dd06646_Out_0, _Multiply_50aa3b40f7a14bd7b87a6d5c409fe58c_Out_2);
            float _Sine_46561b2793af464298e551c036902dba_Out_1;
            Unity_Sine_float(_Multiply_50aa3b40f7a14bd7b87a6d5c409fe58c_Out_2, _Sine_46561b2793af464298e551c036902dba_Out_1);
            float _Remap_1df654c9aa1044f7abd828139d89139a_Out_3;
            Unity_Remap_float(_Sine_46561b2793af464298e551c036902dba_Out_1, float2 (-1, 1), float2 (0, 1), _Remap_1df654c9aa1044f7abd828139d89139a_Out_3);
            float4 _Lerp_d76262fb51a44078947867ea70c5a00c_Out_3;
            Unity_Lerp_float4(_Property_3740e7aeff3e44fa8ff9aa43444060c8_Out_0, _Property_01bbe1e7680b401e874750d026308a46_Out_0, (_Remap_1df654c9aa1044f7abd828139d89139a_Out_3.xxxx), _Lerp_d76262fb51a44078947867ea70c5a00c_Out_3);
            UnityTexture2D _Property_5891bba0aebe4bf2b31acc2e171b012e_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_bc1d9eb6d4344d4084d949d7b33e529a);
            float2 _Property_59033699b8174a5da45c401c3bc8afc7_Out_0 = Vector2_47b54501113b4c409f7770bf21e02d97;
            float2 _Multiply_af95df0b772b427a8ecb025f9ee14390_Out_2;
            Unity_Multiply_float2_float2((IN.TimeParameters.x.xx), _Property_59033699b8174a5da45c401c3bc8afc7_Out_0, _Multiply_af95df0b772b427a8ecb025f9ee14390_Out_2);
            float2 _Rotate_aa10a20f657d4e0e9e74f137abd63909_Out_3;
            Unity_Rotate_Radians_float(IN.uv0.xy, float2 (0.5, 0.5), (_Multiply_af95df0b772b427a8ecb025f9ee14390_Out_2).x, _Rotate_aa10a20f657d4e0e9e74f137abd63909_Out_3);
            float4 _SampleTexture2D_fe0d963923a94d97b5d0da26f130eab5_RGBA_0 = SAMPLE_TEXTURE2D(_Property_5891bba0aebe4bf2b31acc2e171b012e_Out_0.tex, _Property_5891bba0aebe4bf2b31acc2e171b012e_Out_0.samplerstate, _Property_5891bba0aebe4bf2b31acc2e171b012e_Out_0.GetTransformedUV(_Rotate_aa10a20f657d4e0e9e74f137abd63909_Out_3));
            float _SampleTexture2D_fe0d963923a94d97b5d0da26f130eab5_R_4 = _SampleTexture2D_fe0d963923a94d97b5d0da26f130eab5_RGBA_0.r;
            float _SampleTexture2D_fe0d963923a94d97b5d0da26f130eab5_G_5 = _SampleTexture2D_fe0d963923a94d97b5d0da26f130eab5_RGBA_0.g;
            float _SampleTexture2D_fe0d963923a94d97b5d0da26f130eab5_B_6 = _SampleTexture2D_fe0d963923a94d97b5d0da26f130eab5_RGBA_0.b;
            float _SampleTexture2D_fe0d963923a94d97b5d0da26f130eab5_A_7 = _SampleTexture2D_fe0d963923a94d97b5d0da26f130eab5_RGBA_0.a;
            UnityTexture2D _Property_e53f115c5350438db818ee2e25e84f66_Out_0 = UnityBuildTexture2DStructNoScale(_MainTex);
            float4 _SampleTexture2D_b792db77a11748a88494980d164a77ed_RGBA_0 = SAMPLE_TEXTURE2D(_Property_e53f115c5350438db818ee2e25e84f66_Out_0.tex, _Property_e53f115c5350438db818ee2e25e84f66_Out_0.samplerstate, _Property_e53f115c5350438db818ee2e25e84f66_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_b792db77a11748a88494980d164a77ed_R_4 = _SampleTexture2D_b792db77a11748a88494980d164a77ed_RGBA_0.r;
            float _SampleTexture2D_b792db77a11748a88494980d164a77ed_G_5 = _SampleTexture2D_b792db77a11748a88494980d164a77ed_RGBA_0.g;
            float _SampleTexture2D_b792db77a11748a88494980d164a77ed_B_6 = _SampleTexture2D_b792db77a11748a88494980d164a77ed_RGBA_0.b;
            float _SampleTexture2D_b792db77a11748a88494980d164a77ed_A_7 = _SampleTexture2D_b792db77a11748a88494980d164a77ed_RGBA_0.a;
            float4 _Multiply_5c340ccb4c5f44d7b13f7b4357b90fc6_Out_2;
            Unity_Multiply_float4_float4(_SampleTexture2D_fe0d963923a94d97b5d0da26f130eab5_RGBA_0, _SampleTexture2D_b792db77a11748a88494980d164a77ed_RGBA_0, _Multiply_5c340ccb4c5f44d7b13f7b4357b90fc6_Out_2);
            float4 _Multiply_073d50ba797e42daa7dfb3574c85ef1f_Out_2;
            Unity_Multiply_float4_float4(_Lerp_d76262fb51a44078947867ea70c5a00c_Out_3, _Multiply_5c340ccb4c5f44d7b13f7b4357b90fc6_Out_2, _Multiply_073d50ba797e42daa7dfb3574c85ef1f_Out_2);
            float _Split_57fa424231f8454c962dff75f2eb208a_R_1 = _Multiply_5c340ccb4c5f44d7b13f7b4357b90fc6_Out_2[0];
            float _Split_57fa424231f8454c962dff75f2eb208a_G_2 = _Multiply_5c340ccb4c5f44d7b13f7b4357b90fc6_Out_2[1];
            float _Split_57fa424231f8454c962dff75f2eb208a_B_3 = _Multiply_5c340ccb4c5f44d7b13f7b4357b90fc6_Out_2[2];
            float _Split_57fa424231f8454c962dff75f2eb208a_A_4 = _Multiply_5c340ccb4c5f44d7b13f7b4357b90fc6_Out_2[3];
            surface.BaseColor = (_Multiply_073d50ba797e42daa7dfb3574c85ef1f_Out_2.xyz);
            surface.Alpha = _Split_57fa424231f8454c962dff75f2eb208a_R_1;
            return surface;
        }
        
            // --------------------------------------------------
            // Build Graph Inputs
        
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
        
            
        
        
        
        
        
            output.uv0 =                                        input.texCoord0;
            output.TimeParameters =                             _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN                output.FaceSign =                                   IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
            return output;
        }
        
            // --------------------------------------------------
            // Main
        
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/2D/ShaderGraph/Includes/SpriteUnlitPass.hlsl"
        
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
        #pragma exclude_renderers d3d11_9x
        #pragma vertex vert
        #pragma fragment frag
        
            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>
        
            // Keywords
            // PassKeywords: <None>
            // GraphKeywords: <None>
        
            // Defines
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define VARYINGS_NEED_TEXCOORD0
            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENESELECTIONPASS 1
        
        #define _ALPHATEST_ON 1
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
            // Includes
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreInclude' */
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
            // --------------------------------------------------
            // Structs and Packing
        
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
        float4 CircleColor_2;
        float4 CircleColor;
        float4 Texture2D_bc1d9eb6d4344d4084d949d7b33e529a_TexelSize;
        float4 _MainTex_TexelSize;
        float2 Vector2_47b54501113b4c409f7770bf21e02d97;
        float Vector1_89bcc8638aeb4eb98b6b8b61db4dd490;
        float _ColorChangeSpeed;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Texture2D_bc1d9eb6d4344d4084d949d7b33e529a);
        SAMPLER(samplerTexture2D_bc1d9eb6d4344d4084d949d7b33e529a);
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
            
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_Rotate_Radians_float(float2 UV, float2 Center, float Rotation, out float2 Out)
        {
            //rotation matrix
            UV -= Center;
            float s = sin(Rotation);
            float c = cos(Rotation);
        
            //center rotation matrix
            float2x2 rMatrix = float2x2(c, -s, s, c);
            rMatrix *= 0.5;
            rMatrix += 0.5;
            rMatrix = rMatrix*2 - 1;
        
            //multiply the UVs by the rotation matrix
            UV.xy = mul(UV.xy, rMatrix);
            UV += Center;
        
            Out = UV;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
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
            UnityTexture2D _Property_5891bba0aebe4bf2b31acc2e171b012e_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_bc1d9eb6d4344d4084d949d7b33e529a);
            float2 _Property_59033699b8174a5da45c401c3bc8afc7_Out_0 = Vector2_47b54501113b4c409f7770bf21e02d97;
            float2 _Multiply_af95df0b772b427a8ecb025f9ee14390_Out_2;
            Unity_Multiply_float2_float2((IN.TimeParameters.x.xx), _Property_59033699b8174a5da45c401c3bc8afc7_Out_0, _Multiply_af95df0b772b427a8ecb025f9ee14390_Out_2);
            float2 _Rotate_aa10a20f657d4e0e9e74f137abd63909_Out_3;
            Unity_Rotate_Radians_float(IN.uv0.xy, float2 (0.5, 0.5), (_Multiply_af95df0b772b427a8ecb025f9ee14390_Out_2).x, _Rotate_aa10a20f657d4e0e9e74f137abd63909_Out_3);
            float4 _SampleTexture2D_fe0d963923a94d97b5d0da26f130eab5_RGBA_0 = SAMPLE_TEXTURE2D(_Property_5891bba0aebe4bf2b31acc2e171b012e_Out_0.tex, _Property_5891bba0aebe4bf2b31acc2e171b012e_Out_0.samplerstate, _Property_5891bba0aebe4bf2b31acc2e171b012e_Out_0.GetTransformedUV(_Rotate_aa10a20f657d4e0e9e74f137abd63909_Out_3));
            float _SampleTexture2D_fe0d963923a94d97b5d0da26f130eab5_R_4 = _SampleTexture2D_fe0d963923a94d97b5d0da26f130eab5_RGBA_0.r;
            float _SampleTexture2D_fe0d963923a94d97b5d0da26f130eab5_G_5 = _SampleTexture2D_fe0d963923a94d97b5d0da26f130eab5_RGBA_0.g;
            float _SampleTexture2D_fe0d963923a94d97b5d0da26f130eab5_B_6 = _SampleTexture2D_fe0d963923a94d97b5d0da26f130eab5_RGBA_0.b;
            float _SampleTexture2D_fe0d963923a94d97b5d0da26f130eab5_A_7 = _SampleTexture2D_fe0d963923a94d97b5d0da26f130eab5_RGBA_0.a;
            UnityTexture2D _Property_e53f115c5350438db818ee2e25e84f66_Out_0 = UnityBuildTexture2DStructNoScale(_MainTex);
            float4 _SampleTexture2D_b792db77a11748a88494980d164a77ed_RGBA_0 = SAMPLE_TEXTURE2D(_Property_e53f115c5350438db818ee2e25e84f66_Out_0.tex, _Property_e53f115c5350438db818ee2e25e84f66_Out_0.samplerstate, _Property_e53f115c5350438db818ee2e25e84f66_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_b792db77a11748a88494980d164a77ed_R_4 = _SampleTexture2D_b792db77a11748a88494980d164a77ed_RGBA_0.r;
            float _SampleTexture2D_b792db77a11748a88494980d164a77ed_G_5 = _SampleTexture2D_b792db77a11748a88494980d164a77ed_RGBA_0.g;
            float _SampleTexture2D_b792db77a11748a88494980d164a77ed_B_6 = _SampleTexture2D_b792db77a11748a88494980d164a77ed_RGBA_0.b;
            float _SampleTexture2D_b792db77a11748a88494980d164a77ed_A_7 = _SampleTexture2D_b792db77a11748a88494980d164a77ed_RGBA_0.a;
            float4 _Multiply_5c340ccb4c5f44d7b13f7b4357b90fc6_Out_2;
            Unity_Multiply_float4_float4(_SampleTexture2D_fe0d963923a94d97b5d0da26f130eab5_RGBA_0, _SampleTexture2D_b792db77a11748a88494980d164a77ed_RGBA_0, _Multiply_5c340ccb4c5f44d7b13f7b4357b90fc6_Out_2);
            float _Split_57fa424231f8454c962dff75f2eb208a_R_1 = _Multiply_5c340ccb4c5f44d7b13f7b4357b90fc6_Out_2[0];
            float _Split_57fa424231f8454c962dff75f2eb208a_G_2 = _Multiply_5c340ccb4c5f44d7b13f7b4357b90fc6_Out_2[1];
            float _Split_57fa424231f8454c962dff75f2eb208a_B_3 = _Multiply_5c340ccb4c5f44d7b13f7b4357b90fc6_Out_2[2];
            float _Split_57fa424231f8454c962dff75f2eb208a_A_4 = _Multiply_5c340ccb4c5f44d7b13f7b4357b90fc6_Out_2[3];
            surface.Alpha = _Split_57fa424231f8454c962dff75f2eb208a_R_1;
            return surface;
        }
        
            // --------------------------------------------------
            // Build Graph Inputs
        
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
        
            
        
        
        
        
        
            output.uv0 =                                        input.texCoord0;
            output.TimeParameters =                             _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN                output.FaceSign =                                   IS_FRONT_VFACE(input.cullFace, true, false);
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
        #pragma exclude_renderers d3d11_9x
        #pragma vertex vert
        #pragma fragment frag
        
            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>
        
            // Keywords
            // PassKeywords: <None>
            // GraphKeywords: <None>
        
            // Defines
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define VARYINGS_NEED_TEXCOORD0
            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENEPICKINGPASS 1
        
        #define _ALPHATEST_ON 1
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
            // Includes
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreInclude' */
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
            // --------------------------------------------------
            // Structs and Packing
        
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
        float4 CircleColor_2;
        float4 CircleColor;
        float4 Texture2D_bc1d9eb6d4344d4084d949d7b33e529a_TexelSize;
        float4 _MainTex_TexelSize;
        float2 Vector2_47b54501113b4c409f7770bf21e02d97;
        float Vector1_89bcc8638aeb4eb98b6b8b61db4dd490;
        float _ColorChangeSpeed;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Texture2D_bc1d9eb6d4344d4084d949d7b33e529a);
        SAMPLER(samplerTexture2D_bc1d9eb6d4344d4084d949d7b33e529a);
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
            
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_Rotate_Radians_float(float2 UV, float2 Center, float Rotation, out float2 Out)
        {
            //rotation matrix
            UV -= Center;
            float s = sin(Rotation);
            float c = cos(Rotation);
        
            //center rotation matrix
            float2x2 rMatrix = float2x2(c, -s, s, c);
            rMatrix *= 0.5;
            rMatrix += 0.5;
            rMatrix = rMatrix*2 - 1;
        
            //multiply the UVs by the rotation matrix
            UV.xy = mul(UV.xy, rMatrix);
            UV += Center;
        
            Out = UV;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
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
            UnityTexture2D _Property_5891bba0aebe4bf2b31acc2e171b012e_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_bc1d9eb6d4344d4084d949d7b33e529a);
            float2 _Property_59033699b8174a5da45c401c3bc8afc7_Out_0 = Vector2_47b54501113b4c409f7770bf21e02d97;
            float2 _Multiply_af95df0b772b427a8ecb025f9ee14390_Out_2;
            Unity_Multiply_float2_float2((IN.TimeParameters.x.xx), _Property_59033699b8174a5da45c401c3bc8afc7_Out_0, _Multiply_af95df0b772b427a8ecb025f9ee14390_Out_2);
            float2 _Rotate_aa10a20f657d4e0e9e74f137abd63909_Out_3;
            Unity_Rotate_Radians_float(IN.uv0.xy, float2 (0.5, 0.5), (_Multiply_af95df0b772b427a8ecb025f9ee14390_Out_2).x, _Rotate_aa10a20f657d4e0e9e74f137abd63909_Out_3);
            float4 _SampleTexture2D_fe0d963923a94d97b5d0da26f130eab5_RGBA_0 = SAMPLE_TEXTURE2D(_Property_5891bba0aebe4bf2b31acc2e171b012e_Out_0.tex, _Property_5891bba0aebe4bf2b31acc2e171b012e_Out_0.samplerstate, _Property_5891bba0aebe4bf2b31acc2e171b012e_Out_0.GetTransformedUV(_Rotate_aa10a20f657d4e0e9e74f137abd63909_Out_3));
            float _SampleTexture2D_fe0d963923a94d97b5d0da26f130eab5_R_4 = _SampleTexture2D_fe0d963923a94d97b5d0da26f130eab5_RGBA_0.r;
            float _SampleTexture2D_fe0d963923a94d97b5d0da26f130eab5_G_5 = _SampleTexture2D_fe0d963923a94d97b5d0da26f130eab5_RGBA_0.g;
            float _SampleTexture2D_fe0d963923a94d97b5d0da26f130eab5_B_6 = _SampleTexture2D_fe0d963923a94d97b5d0da26f130eab5_RGBA_0.b;
            float _SampleTexture2D_fe0d963923a94d97b5d0da26f130eab5_A_7 = _SampleTexture2D_fe0d963923a94d97b5d0da26f130eab5_RGBA_0.a;
            UnityTexture2D _Property_e53f115c5350438db818ee2e25e84f66_Out_0 = UnityBuildTexture2DStructNoScale(_MainTex);
            float4 _SampleTexture2D_b792db77a11748a88494980d164a77ed_RGBA_0 = SAMPLE_TEXTURE2D(_Property_e53f115c5350438db818ee2e25e84f66_Out_0.tex, _Property_e53f115c5350438db818ee2e25e84f66_Out_0.samplerstate, _Property_e53f115c5350438db818ee2e25e84f66_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_b792db77a11748a88494980d164a77ed_R_4 = _SampleTexture2D_b792db77a11748a88494980d164a77ed_RGBA_0.r;
            float _SampleTexture2D_b792db77a11748a88494980d164a77ed_G_5 = _SampleTexture2D_b792db77a11748a88494980d164a77ed_RGBA_0.g;
            float _SampleTexture2D_b792db77a11748a88494980d164a77ed_B_6 = _SampleTexture2D_b792db77a11748a88494980d164a77ed_RGBA_0.b;
            float _SampleTexture2D_b792db77a11748a88494980d164a77ed_A_7 = _SampleTexture2D_b792db77a11748a88494980d164a77ed_RGBA_0.a;
            float4 _Multiply_5c340ccb4c5f44d7b13f7b4357b90fc6_Out_2;
            Unity_Multiply_float4_float4(_SampleTexture2D_fe0d963923a94d97b5d0da26f130eab5_RGBA_0, _SampleTexture2D_b792db77a11748a88494980d164a77ed_RGBA_0, _Multiply_5c340ccb4c5f44d7b13f7b4357b90fc6_Out_2);
            float _Split_57fa424231f8454c962dff75f2eb208a_R_1 = _Multiply_5c340ccb4c5f44d7b13f7b4357b90fc6_Out_2[0];
            float _Split_57fa424231f8454c962dff75f2eb208a_G_2 = _Multiply_5c340ccb4c5f44d7b13f7b4357b90fc6_Out_2[1];
            float _Split_57fa424231f8454c962dff75f2eb208a_B_3 = _Multiply_5c340ccb4c5f44d7b13f7b4357b90fc6_Out_2[2];
            float _Split_57fa424231f8454c962dff75f2eb208a_A_4 = _Multiply_5c340ccb4c5f44d7b13f7b4357b90fc6_Out_2[3];
            surface.Alpha = _Split_57fa424231f8454c962dff75f2eb208a_R_1;
            return surface;
        }
        
            // --------------------------------------------------
            // Build Graph Inputs
        
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
        
            
        
        
        
        
        
            output.uv0 =                                        input.texCoord0;
            output.TimeParameters =                             _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN                output.FaceSign =                                   IS_FRONT_VFACE(input.cullFace, true, false);
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
        
            ENDHLSL
        }
        Pass
        {
            Name "Sprite Unlit"
            Tags
            {
                "LightMode" = "UniversalForward"
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
        #pragma exclude_renderers d3d11_9x
        #pragma vertex vert
        #pragma fragment frag
        
            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>
        
            // Keywords
            #pragma multi_compile_fragment _ DEBUG_DISPLAY
            // GraphKeywords: <None>
        
            // Defines
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_COLOR
            #define VARYINGS_NEED_POSITION_WS
            #define VARYINGS_NEED_TEXCOORD0
            #define VARYINGS_NEED_COLOR
            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_SPRITEFORWARD
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
            // Includes
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreInclude' */
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
            // --------------------------------------------------
            // Structs and Packing
        
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
            struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float4 texCoord0;
             float4 color;
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
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyzw =  input.texCoord0;
            output.interp2.xyzw =  input.color;
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
            output.texCoord0 = input.interp1.xyzw;
            output.color = input.interp2.xyzw;
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
        float4 CircleColor_2;
        float4 CircleColor;
        float4 Texture2D_bc1d9eb6d4344d4084d949d7b33e529a_TexelSize;
        float4 _MainTex_TexelSize;
        float2 Vector2_47b54501113b4c409f7770bf21e02d97;
        float Vector1_89bcc8638aeb4eb98b6b8b61db4dd490;
        float _ColorChangeSpeed;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Texture2D_bc1d9eb6d4344d4084d949d7b33e529a);
        SAMPLER(samplerTexture2D_bc1d9eb6d4344d4084d949d7b33e529a);
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
            
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
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
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_Rotate_Radians_float(float2 UV, float2 Center, float Rotation, out float2 Out)
        {
            //rotation matrix
            UV -= Center;
            float s = sin(Rotation);
            float c = cos(Rotation);
        
            //center rotation matrix
            float2x2 rMatrix = float2x2(c, -s, s, c);
            rMatrix *= 0.5;
            rMatrix += 0.5;
            rMatrix = rMatrix*2 - 1;
        
            //multiply the UVs by the rotation matrix
            UV.xy = mul(UV.xy, rMatrix);
            UV += Center;
        
            Out = UV;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
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
            float4 _Property_3740e7aeff3e44fa8ff9aa43444060c8_Out_0 = IsGammaSpace() ? LinearToSRGB(CircleColor_2) : CircleColor_2;
            float4 _Property_01bbe1e7680b401e874750d026308a46_Out_0 = IsGammaSpace() ? LinearToSRGB(CircleColor) : CircleColor;
            float _Property_167b0e71998c4c838a9de5d07dd06646_Out_0 = _ColorChangeSpeed;
            float _Multiply_50aa3b40f7a14bd7b87a6d5c409fe58c_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_167b0e71998c4c838a9de5d07dd06646_Out_0, _Multiply_50aa3b40f7a14bd7b87a6d5c409fe58c_Out_2);
            float _Sine_46561b2793af464298e551c036902dba_Out_1;
            Unity_Sine_float(_Multiply_50aa3b40f7a14bd7b87a6d5c409fe58c_Out_2, _Sine_46561b2793af464298e551c036902dba_Out_1);
            float _Remap_1df654c9aa1044f7abd828139d89139a_Out_3;
            Unity_Remap_float(_Sine_46561b2793af464298e551c036902dba_Out_1, float2 (-1, 1), float2 (0, 1), _Remap_1df654c9aa1044f7abd828139d89139a_Out_3);
            float4 _Lerp_d76262fb51a44078947867ea70c5a00c_Out_3;
            Unity_Lerp_float4(_Property_3740e7aeff3e44fa8ff9aa43444060c8_Out_0, _Property_01bbe1e7680b401e874750d026308a46_Out_0, (_Remap_1df654c9aa1044f7abd828139d89139a_Out_3.xxxx), _Lerp_d76262fb51a44078947867ea70c5a00c_Out_3);
            UnityTexture2D _Property_5891bba0aebe4bf2b31acc2e171b012e_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_bc1d9eb6d4344d4084d949d7b33e529a);
            float2 _Property_59033699b8174a5da45c401c3bc8afc7_Out_0 = Vector2_47b54501113b4c409f7770bf21e02d97;
            float2 _Multiply_af95df0b772b427a8ecb025f9ee14390_Out_2;
            Unity_Multiply_float2_float2((IN.TimeParameters.x.xx), _Property_59033699b8174a5da45c401c3bc8afc7_Out_0, _Multiply_af95df0b772b427a8ecb025f9ee14390_Out_2);
            float2 _Rotate_aa10a20f657d4e0e9e74f137abd63909_Out_3;
            Unity_Rotate_Radians_float(IN.uv0.xy, float2 (0.5, 0.5), (_Multiply_af95df0b772b427a8ecb025f9ee14390_Out_2).x, _Rotate_aa10a20f657d4e0e9e74f137abd63909_Out_3);
            float4 _SampleTexture2D_fe0d963923a94d97b5d0da26f130eab5_RGBA_0 = SAMPLE_TEXTURE2D(_Property_5891bba0aebe4bf2b31acc2e171b012e_Out_0.tex, _Property_5891bba0aebe4bf2b31acc2e171b012e_Out_0.samplerstate, _Property_5891bba0aebe4bf2b31acc2e171b012e_Out_0.GetTransformedUV(_Rotate_aa10a20f657d4e0e9e74f137abd63909_Out_3));
            float _SampleTexture2D_fe0d963923a94d97b5d0da26f130eab5_R_4 = _SampleTexture2D_fe0d963923a94d97b5d0da26f130eab5_RGBA_0.r;
            float _SampleTexture2D_fe0d963923a94d97b5d0da26f130eab5_G_5 = _SampleTexture2D_fe0d963923a94d97b5d0da26f130eab5_RGBA_0.g;
            float _SampleTexture2D_fe0d963923a94d97b5d0da26f130eab5_B_6 = _SampleTexture2D_fe0d963923a94d97b5d0da26f130eab5_RGBA_0.b;
            float _SampleTexture2D_fe0d963923a94d97b5d0da26f130eab5_A_7 = _SampleTexture2D_fe0d963923a94d97b5d0da26f130eab5_RGBA_0.a;
            UnityTexture2D _Property_e53f115c5350438db818ee2e25e84f66_Out_0 = UnityBuildTexture2DStructNoScale(_MainTex);
            float4 _SampleTexture2D_b792db77a11748a88494980d164a77ed_RGBA_0 = SAMPLE_TEXTURE2D(_Property_e53f115c5350438db818ee2e25e84f66_Out_0.tex, _Property_e53f115c5350438db818ee2e25e84f66_Out_0.samplerstate, _Property_e53f115c5350438db818ee2e25e84f66_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_b792db77a11748a88494980d164a77ed_R_4 = _SampleTexture2D_b792db77a11748a88494980d164a77ed_RGBA_0.r;
            float _SampleTexture2D_b792db77a11748a88494980d164a77ed_G_5 = _SampleTexture2D_b792db77a11748a88494980d164a77ed_RGBA_0.g;
            float _SampleTexture2D_b792db77a11748a88494980d164a77ed_B_6 = _SampleTexture2D_b792db77a11748a88494980d164a77ed_RGBA_0.b;
            float _SampleTexture2D_b792db77a11748a88494980d164a77ed_A_7 = _SampleTexture2D_b792db77a11748a88494980d164a77ed_RGBA_0.a;
            float4 _Multiply_5c340ccb4c5f44d7b13f7b4357b90fc6_Out_2;
            Unity_Multiply_float4_float4(_SampleTexture2D_fe0d963923a94d97b5d0da26f130eab5_RGBA_0, _SampleTexture2D_b792db77a11748a88494980d164a77ed_RGBA_0, _Multiply_5c340ccb4c5f44d7b13f7b4357b90fc6_Out_2);
            float4 _Multiply_073d50ba797e42daa7dfb3574c85ef1f_Out_2;
            Unity_Multiply_float4_float4(_Lerp_d76262fb51a44078947867ea70c5a00c_Out_3, _Multiply_5c340ccb4c5f44d7b13f7b4357b90fc6_Out_2, _Multiply_073d50ba797e42daa7dfb3574c85ef1f_Out_2);
            float _Split_57fa424231f8454c962dff75f2eb208a_R_1 = _Multiply_5c340ccb4c5f44d7b13f7b4357b90fc6_Out_2[0];
            float _Split_57fa424231f8454c962dff75f2eb208a_G_2 = _Multiply_5c340ccb4c5f44d7b13f7b4357b90fc6_Out_2[1];
            float _Split_57fa424231f8454c962dff75f2eb208a_B_3 = _Multiply_5c340ccb4c5f44d7b13f7b4357b90fc6_Out_2[2];
            float _Split_57fa424231f8454c962dff75f2eb208a_A_4 = _Multiply_5c340ccb4c5f44d7b13f7b4357b90fc6_Out_2[3];
            surface.BaseColor = (_Multiply_073d50ba797e42daa7dfb3574c85ef1f_Out_2.xyz);
            surface.Alpha = _Split_57fa424231f8454c962dff75f2eb208a_R_1;
            return surface;
        }
        
            // --------------------------------------------------
            // Build Graph Inputs
        
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
        
            
        
        
        
        
        
            output.uv0 =                                        input.texCoord0;
            output.TimeParameters =                             _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN                output.FaceSign =                                   IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
            return output;
        }
        
            // --------------------------------------------------
            // Main
        
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/2D/ShaderGraph/Includes/SpriteUnlitPass.hlsl"
        
            ENDHLSL
        }
    }
    CustomEditor "UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI"
    FallBack "Hidden/Shader Graph/FallbackError"
}