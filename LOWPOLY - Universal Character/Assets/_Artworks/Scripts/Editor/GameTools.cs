using UnityEngine;
using UnityEditor;
using System.Collections;
using System.Collections.Generic;
using System.Linq;

public class GameTools : MonoBehaviour
{
    [MenuItem("Assets/GameTools/Parts to Prefab", false, 0)]
    static void BuildPartsOne()
    {
        if (Selection.activeObject != null)
        {
            if (MakeParts(AssetDatabase.GetAssetPath(Selection.activeObject)))
            {
                Debug.Log("Make Parts Prefab complete!!!");
            }
            else
            {
                Debug.Log("Not parts object!!!");
            }
        }
        else
        {
            Debug.Log("Not parts object!!!");
        }
    }

    static bool MakeParts(string pathSrc)
    {

        if (pathSrc.IndexOf("Assets/_Artworks/Character/Parts") >= 0 && pathSrc.ToLower().IndexOf(".fbx") >= 0)
        {
            string pathTarget = pathSrc.Replace("_Artworks", "Prefabs").Replace(".FBX".ToLower(), ".prefab");
            GameObject partsObject = Instantiate<GameObject>(AssetDatabase.LoadAssetAtPath<GameObject>(pathSrc));
            //SkinnedMeshRenderer partsSkin = partsObject.GetComponentInChildren<SkinnedMeshRenderer>();
            SkinnedMeshRenderer[] partsSkins = partsObject.GetComponentsInChildren<SkinnedMeshRenderer>();

            foreach (var partsSkin in partsSkins)
            {
                string pathTargetPart = pathTarget.Replace(partsObject.name.Replace("(Clone)", ""), partsSkin.name);
                if (partsSkin != null)
                {
                    //partsSkin.shadowCastingMode = UnityEngine.Rendering.ShadowCastingMode.Off;
                    //partsSkin.receiveShadows = false;

                    // Light Probes를 사용하지 않도록 설정
                    //partsSkin.lightProbeUsage = UnityEngine.Rendering.LightProbeUsage.Off;
                    // Reflection Probes를 사용하지 않도록 설정
                    //partsSkin.reflectionProbeUsage = UnityEngine.Rendering.ReflectionProbeUsage.Off;

                    PartsInfo partsInfo = partsSkin.gameObject.AddComponent<PartsInfo>();
                    partsInfo.RootboneName = partsSkin.rootBone.name;
                    partsInfo.BoneNames = new string[partsSkin.bones.Length];

                    for (int i = 0; i < partsSkin.bones.Length; i++)
                    {
                        partsInfo.BoneNames[i] = partsSkin.bones[i].name;
                    }
                    //PrefabUtility.CreatePrefab(pathTarget, partsSkin.gameObject, ReplacePrefabOptions.ReplaceNameBased);
                    PrefabUtility.SaveAsPrefabAsset(partsSkin.gameObject, pathTargetPart);
                }
                else
                {
                    Debug.Log(string.Format("Build error : A = {0}", pathSrc));
                }
            }
            DestroyImmediate(partsObject);
            return true;
        }
        else
        {
            Debug.Log(string.Format("Build error : B = {0}", pathSrc));
        }
        return false;
    }
}
