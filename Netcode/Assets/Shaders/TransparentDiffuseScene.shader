Shader "_LME/Transparent Diffuse Scene Lightmap Unlit" {
	Properties {
		_MainTex( "Base (RGBA)", 2D ) = "white" {}
		_Color( "Main Color (RGBA)", Color ) = ( 1, 1, 1, 1 )
		_HighlightColor( "XXXX", Color ) = ( 1, 1, 1 )
	}
	SubShader {
		Tags { "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" }
		LOD 150

		CGPROGRAM
		
		#pragma surface surf Lambert alpha

		sampler2D _MainTex;
		fixed4 _Color;
		fixed3 _HighlightColor;

		struct Input {
			float2 uv_MainTex;
		};

		void surf( Input IN, inout SurfaceOutput o ) {
			fixed4 c = tex2D( _MainTex, IN.uv_MainTex ) * _Color;
			o.Albedo = c.rgb * _HighlightColor;
			o.Alpha = c.a;
		}
		
		ENDCG
	}
	FallBack "Mobile/Unlit (Supports Lightmap)"
}
