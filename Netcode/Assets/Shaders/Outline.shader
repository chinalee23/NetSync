// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "_LME/Outline" {
	Properties {
		_OutlineWidth("Outline Width", Float) = 0.003
		_OutlineColor("Outline Color", Color) = (1, 1, 1, 1)
	}
	SubShader {
		Tags { "RenderType" = "Opaque" }
		
		Pass {  
		    Cull Off
		    ZWrite Off
		    ZTest LEqual
		    ColorMask RGB // alpha not used

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata_t {
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct v2f {
				float4 vertex : SV_POSITION;
			};

			float _OutlineWidth;
			fixed4 _OutlineColor;
			
			v2f vert ( appdata_t v )
			{
				v2f o;
				o.vertex = UnityObjectToClipPos( v.vertex );

				float3 normal = normalize( mul( (float3x3)UNITY_MATRIX_IT_MV, v.normal ) );
				float2 offset = TransformViewToProjection( normal.xy );
				o.vertex.xy += offset * o.vertex.z * _OutlineWidth;

				return o;
			}
			
			fixed4 frag ( v2f i ) : SV_Target
			{
				return _OutlineColor; 
			}

			ENDCG
		}
	} 
}
