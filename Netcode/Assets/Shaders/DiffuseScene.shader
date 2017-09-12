Shader "_LME/Diffuse Scene Lightmap Unlit" {
	Properties {
		_MainTex( "Base (RGB)", 2D ) = "white" {}
		_Color( "Main Color (RGB)", Color ) = ( 1, 1, 1 )
		_HighlightColor( "XXXX", Color ) = ( 1, 1, 1 )
	}
	SubShader {
		Tags { "RenderType" = "Opaque" }
		LOD 150
		
		CGPROGRAM
		
		#pragma surface surf Lambert

		sampler2D _MainTex;
		fixed3 _Color;
		fixed3 _HighlightColor;

		struct Input {
			float2 uv_MainTex;
		};

		void surf( Input IN, inout SurfaceOutput o ) {
			fixed4 c = tex2D( _MainTex, IN.uv_MainTex );
			o.Albedo = c.rgb * _Color * _HighlightColor;
			o.Alpha = 1;
		}

		ENDCG
	} 
	FallBack "Mobile/Unlit (Supports Lightmap)"
}
