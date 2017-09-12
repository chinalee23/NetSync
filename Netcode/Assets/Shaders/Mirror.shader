
Shader "_LME/MirrorTransparent" {
	Properties {	
		_Color ("Main Color", Color) = (1,1,1,1)
		_MainTex ("Base (RGBA)", 2D) = "white" {}
		_MainRate("Main Rate",Range(0,1))=1

		_Ref ("For Mirror reflection,don't set it!", 2D) = "white" {}
		_RefRate("Reflective Rate", Range (0, 1)) = 1
		_Distortion ("Distortion", range (0,2)) = 0

		_HighlightColor( "XXXX", Color ) = ( 1, 1, 1 )
		_Ratio( "Ratio", Float ) = 1.0
	}

	SubShader {
		Tags { "Queue"="Transparent" "RenderType"="Opaque" }

		Cull Back
		ZWrite Off
		ZTest LEqual
		Blend SrcAlpha OneMinusSrcAlpha

		CGPROGRAM

		#pragma surface surf BlinnPhong alpha

		sampler2D _MainTex;
		sampler2D _Ref;
		fixed4 _Color;
		half _MainRate;
		half _RefRate;
		half _Distortion;
		fixed3 _HighlightColor;
		fixed _Ratio;

		struct Input {
			float2 uv_MainTex;
			float2 uv_BumpMap;
			float4 screenPos;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);	
			float2 screenUV = IN.screenPos.xy / IN.screenPos.w * _Distortion;
			fixed4 ref = tex2D(_Ref, screenUV);
				
			o.Albedo = tex.rgb * _Color.rgb * _MainRate * _HighlightColor * _Ratio;
			o.Emission = ref.rgb * _RefRate * _HighlightColor * _Ratio;
			o.Alpha = tex.a * _Color.a;
		}
		
		ENDCG
	}

	FallBack "Transparent/VertexLit"
}