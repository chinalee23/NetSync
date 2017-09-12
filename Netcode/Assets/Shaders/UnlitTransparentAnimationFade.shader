Shader "_LME/Unlit Transparent Animation Fade" {
	Properties {
		_MainTex("Base (RGBA)", 2D) = "black" {}
		_texRate("MainTex color Rate", Float) = 1
		_FadeTex("Fade", 2D) = "white" {}
		_Emission("Emission", Color) = (0,0,0,0)
		_MainTexSpeedU("_MainTexSpeed U", Float) = 0
		_MainTexSpeedV("_MainTexSpeed V", Float) = 0

		_HighlightColor( "XXXX", Color ) = ( 1, 1, 1 )
		_Ratio( "Ratio", Float ) = 1.0
	}
	SubShader {
		Tags {
			"Queue" = "Transparent"
			"IgnoreProjector" = "True"
			"RenderType" = "Transparent"
		}
		LOD 150
	
		Cull Back
		ZWrite Off
		ZTest LEqual
		ColorMask RGBA
		Blend SrcAlpha OneMinusSrcAlpha
	
		CGPROGRAM

		#pragma surface surf Unlit alpha noshadow noambient nolightmap noambient

		half4 LightingUnlit (SurfaceOutput s, fixed3 lightDir, fixed atten) {
           half4 c;
           c.rgb = s.Albedo;
           c.a = s.Alpha;
           return c;
         }

		uniform sampler2D _MainTex;
		uniform sampler2D _FadeTex;
		half _texRate;
		float4 _Emission;
		half _MainTexSpeedU;
		half _MainTexSpeedV;
		fixed3 _HighlightColor;
		fixed _Ratio;

		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			float u=_Time * _MainTexSpeedU;
			float v=_Time * _MainTexSpeedV;
			float2 MainTexUV=(IN.uv_MainTex.xy) + float2(u, v);
			
			float4 color = tex2D(_MainTex, MainTexUV);
			float4 fade = tex2D(_FadeTex, IN.uv_MainTex);
			o.Albedo = color.rgb * _texRate * _HighlightColor * _Ratio;
			o.Alpha = color.a * fade.r;
			o.Emission = _Emission * _HighlightColor * _Ratio;
		}

		ENDCG
	}

	Fallback "Unlit/Texture"
}
