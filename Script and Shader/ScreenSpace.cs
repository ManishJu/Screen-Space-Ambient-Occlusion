using System.Collections;
using System.Collections.Generic;
using UnityEngine;
[ExecuteInEditMode]

public class ScreenSpace : MonoBehaviour {


    public Material EffectMaterial;

    void Start()
    {
        Screen.SetResolution(1920, 1080, true);
        GetComponent<Camera>().depthTextureMode = DepthTextureMode.DepthNormals;
       // GetComponent<Camera>().depthTextureMode = DepthTextureMode.Depth;
    }

    void OnRenderImage(RenderTexture src, RenderTexture dst)
    {
        Graphics.Blit(src, dst, EffectMaterial);
    }

}
