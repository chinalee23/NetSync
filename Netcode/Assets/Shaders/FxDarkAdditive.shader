Shader "_LME/Fx Dark Additive" {
	Properties {
		_TintColor ("Tint Color", Color) = (0.5, 0.5, 0.5, 0.5)
		_MainTex ("Particle Texture", 2D) = "white" {}
		_DarkTex ("Dark Texture", 2D) = "white" {}
	}

	Category {
		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
		Blend SrcAlpha One
		ColorMask RGB
		Cull Off Lighting Off ZWrite Off Fog { Color (0, 0, 0, 0) }
		BindChannels {
			Bind "Color", color
			Bind "Vertex", vertex
			Bind "TexCoord", texcoord
		}
	
		SubShader {
			Pass {
				SetTexture [_MainTex] {
					constantColor [_TintColor]
					combine texture * constant
				}
				SetTexture [_DarkTex] {
					combine texture * previous
				}
			}
		}
	}
}
