Shader "_LME/Transparent Cutout Diffuse Scene Lightmap Unlit" {
	Properties {
		_MainTex( "Base (RGBA)", 2D ) = "white" {}
		_Color( "Main Color (RGBA)", Color ) = ( 1, 1, 1, 1 )
		_Cutoff ( "Alpha Cutoff", Range( 0, 1 ) ) = 0.5
		_HighlightColor( "XXXX", Color ) = ( 1, 1, 1 )
		_Ratio("Ratio", Float) = 1.0
	}
	SubShader {
		Tags { "Queue" = "AlphaTest" "IgnoreProjector" = "True" "RenderType" = "TransparentCutout" }
		LOD 150

		CGPROGRAM
		
		#pragma surface surf Lambert alphatest:_Cutoff

		sampler2D _MainTex;
		fixed4 _Color;
		fixed3 _HighlightColor;
		fixed _Ratio;

		struct Input {
			float2 uv_MainTex;
		};

		void surf( Input IN, inout SurfaceOutput o ) {
			fixed4 c = tex2D( _MainTex, IN.uv_MainTex ) * _Color;
			o.Albedo = c.rgb * _HighlightColor * _Ratio;
			o.Alpha = c.a;
		}
		
		ENDCG
	}
	FallBack "Mobile/Unlit (Supports Lightmap)"
}
