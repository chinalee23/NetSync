Shader "_LME/Self-Illumin Diffuse Scene" {
	Properties {
		_MainTex( "Base (RGB)", 2D ) = "white" {}
		_AlbedoFactor( "Albedo Factor", Float) = 1
		_EmissionFactor( "Emission Factor", Float) = 1
		_HighlightColor( "XXXX", Color ) = ( 1, 1, 1 )
	}
	SubShader {
		Tags { "RenderType" = "Opaque" }
		LOD 150
		
		CGPROGRAM
		
		#pragma surface surf Lambert

		sampler2D _MainTex;
		fixed _AlbedoFactor;
		fixed _EmissionFactor;
		fixed3 _HighlightColor;

		struct Input {
			float2 uv_MainTex;
		};

		void surf( Input IN, inout SurfaceOutput o ) {
			fixed4 c = tex2D( _MainTex, IN.uv_MainTex );
			o.Albedo = c.rgb * _AlbedoFactor * _HighlightColor;
			o.Emission = c.rgb * _EmissionFactor * _HighlightColor;
			o.Alpha = c.a;
		}

		ENDCG
	} 
	FallBack "Mobile/Unlit (Supports Lightmap)"
}
