Shader "_LME/SequenceAnimation" {
Properties {
    _Color ("Main Color", Color) = (1,1,1,1)
    _MainTex ("Base (RGBA)", 2D) = "white" {}
    _Rows ("Rows", Float) = 4
    _Columns ("Columns", Float) = 4    
    _Speed ("Speed", Float) = 200

    _HighlightColor( "XXXX", Color ) = ( 1, 1, 1 )
    _Ratio( "Ratio", Float ) = 1.0
    }

    SubShader {
        Tags { "RenderType"="Opaque"}
        LOD 150

        CGPROGRAM
        #pragma surface surf Lambert alpha

        sampler2D _MainTex;
        fixed4 _Color;

        fixed _Columns;
        fixed _Rows;
        fixed _Speed;
        fixed3 _HighlightColor;
        fixed _Ratio;

        struct Input {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutput o) {            
            int index = floor( _Time * _Speed );
            int row = index / _Columns;
            int column = index - row * _Columns;

            float2 uv = float2( ( IN.uv_MainTex.x + column ) / _Columns, ( IN.uv_MainTex.y + _Rows - row - 1 ) / _Rows );
            
            fixed4 c = tex2D( _MainTex, uv ) * _Color;
            o.Albedo = c.rgb * _HighlightColor * _Ratio;
            o.Alpha = c.a;
        }

        ENDCG
    }

    Fallback "Transparent/VertexLit"
}