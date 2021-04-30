Shader "Unlit/Transparent Colored Stencil Test"
{
	Properties
	{
		_MainTex ("Base (RGB), Alpha (A)", 2D) = "black" {}
	}
	
	SubShader
	{
		LOD 200

		Tags
		{
			"Queue" = "Transparent"
			"IgnoreProjector" = "True"
			"RenderType" = "Transparent"
			"DisableBatching" = "True"
		}
		// 追加
		CGINCLUDE
		//定义宏
		#define PI 3.14159
		ENDCG

		Stencil {
            Ref 5
            Comp always
            Pass replace
        }
        
		Pass
		{
			Cull Off
			Lighting Off
			ZWrite Off
			Fog { Mode Off }
			Offset -1, -1
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag			
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			float4 _MainTex_ST;

			struct appdata_t
			{
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
			};
	
			struct v2f
			{
				float4 vertex : SV_POSITION;
				half2 texcoord : TEXCOORD0;
			};
	
			v2f o;

			v2f vert (appdata_t v)
			{

				o.vertex = UnityObjectToClipPos(v.vertex);
				o.texcoord = v.texcoord;
				return o;
			}
				
			fixed4 frag (v2f IN) : SV_Target
			{			
				
				fixed4 col= tex2D(_MainTex, IN.texcoord);
				float dis = distance(IN.texcoord,float2(0.5,0.5));//距离中心的长度
				float lp = smoothstep(0.3,0.7,dis);
				col.a=min(lp*3,col.a);
		
				if (dis<0.3)
				{
					col.a=0;
				}

		        return col;
		    }
			ENDCG
		}
	}

}
