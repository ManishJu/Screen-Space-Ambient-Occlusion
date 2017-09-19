
    Shader "Custom/Ssao_disk_attempt7" {
	Properties{

		_Depthcheck("Depthcheck", Range(0, 200)) = 40 // for adjusting depth in the scene
		_Radius("Radius", Range(0,100)) = 1
		_MainTex("Main Texture", 2D) = "white"

	}
	SubShader{

		Pass{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			sampler2D _MainTex;
   		sampler2D _CameraDepthNormalsTexture;
			float _Depthcheck;
			float _Radius;
			float4 _MainTex_TexelSize;

			struct v2f {
				float4 pos : SV_POSITION;
				float4 uv:TEXCOORD1;
			};

		   //Vertex Shader
			v2f vert(appdata_full v) {
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = ComputeScreenPos(o.pos); 
				return o;
			}

			float2 returnScreenPos(float2 pos,float addX, float addY){
				pos.x += addX*_MainTex_TexelSize.x ;
				pos.y += addY*_MainTex_TexelSize.y ;
				return pos;
			}

			float4 frag(v2f i) : COLOR {

			sampler2D _CDNT = _CameraDepthNormalsTexture;
			float4 uv2 = i.uv;
			float d1; // depth of the original pixel	
			float3 n1; // normal of the original pix
			float3 n; 	// normal of the neighbouring pixel for comparison
			float d; // depth of the neighbouring pixel for comparison
			float sO = 0.0; // sum occlusion factor

			// give depth and normal of that pixel
      		DecodeDepthNormal(tex2D(_CDNT,i.uv), d1, n1);
			d1 *= _Depthcheck;
			int R = int(_Radius);
			for(int ii = -R; ii <= R ; ii++){
				for(int jj = -R; jj <= R ; jj++){
				  DecodeDepthNormal(tex2D(_CDNT,returnScreenPos(i.uv.xy,float(ii),float(jj))), d, n);
					d *= _Depthcheck;
					sO += (d < d1) ? 1.0 : 0.0;
				}
			}

			//clamping down the net effect of SSAO	
			 sO = (R*R / (R*R + sO/5) );

			//original color 
			float4 mainColor = tex2D(_MainTex, uv2);
			//SSAO effect
      		float4 Occlusion =  float4(sO, sO, sO, 1);
      		return Occlusion;
      		//comment above line to see the result;
      		//resultant effect
			return mainColor * Occlusion ;

			}
			ENDCG
		}
	}
    }
