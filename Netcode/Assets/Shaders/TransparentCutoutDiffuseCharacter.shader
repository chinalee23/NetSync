Shader "_LME/Transparent Cutout Diffuse Character" {
	Properties {
		_MainTex( "Base (RGB)", 2D ) = "white" {}
		_AlbedoFactor( "Albedo Factor", Float) = 0.5
		_EmissionFactor( "Emission Factor", Float) = 0.5
		_Cutoff ( "Alpha Cutoff", Range( 0, 1 ) ) = 0.5
		_HighlightColor( "XXXX", Color ) = ( 1, 1, 1 )
	}
	SubShader {
		Tags { "Queue" = "AlphaTest" "IgnoreProjector" = "True" "RenderType" = "TransparentCutout" }
		LOD 150
		
		CGPROGRAM
		
		#pragma surface surf Lambert alphatest:_Cutoff

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
			o.Emission = c.rgb * ( _EmissionFactor + 0.1 ) * _HighlightColor;
			o.Alpha = c.a;
		}

		ENDCG
	} 
	FallBack "Mobile/VertexLit"
}
