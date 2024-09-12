using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using UnityEditor;

public class AddSkinnedMeshParts : MonoBehaviour
{
    [SerializeField] GameObject[] parts;

    void Start()
    {
        foreach (var part in parts)
        {
            if (part != null && PrefabUtility.GetPrefabAssetType(part) == PrefabAssetType.Regular)
            {
                AddSkinnedMeshPartsPrefab(part);
            }
            else
            {
                AddSkinnedMeshRenderer(part);
            }
        }
    }

    public void AddSkinnedMeshRenderer(GameObject newSkinnedMesh)
    {
        // add skinned mesh
        var newSkinnedMeshRenderer = newSkinnedMesh.GetComponentInChildren<SkinnedMeshRenderer>();
        SkinnedMeshRenderer skinnedMeshRenderer = Instantiate(newSkinnedMeshRenderer, transform);

        Transform[] childrens = transform.GetComponentsInChildren<Transform>(true);

        // sort bones.
        Transform[] bones = new Transform[newSkinnedMeshRenderer.bones.Length];
        for (int boneOrder = 0; boneOrder < newSkinnedMeshRenderer.bones.Length; boneOrder++)
        {
            bones[boneOrder] = System.Array.Find(childrens, c => c.name == newSkinnedMeshRenderer.bones[boneOrder].name);
        }
        skinnedMeshRenderer.bones = bones;
    }

    public void AddSkinnedMeshPartsPrefab(GameObject newSkinnedMeshPrefab)
    {
        // add skinned mesh prefab
        var newSkinnedMeshRenderer = newSkinnedMeshPrefab.GetComponentInChildren<SkinnedMeshRenderer>();
        SkinnedMeshRenderer skinnedMeshRenderer = Instantiate(newSkinnedMeshRenderer, transform);

        Transform[] childrens = transform.GetComponentsInChildren<Transform>(true);

        // sort bones.
        Transform[] bones = new Transform[newSkinnedMeshRenderer.bones.Length];
        PartsInfo partsInfo = newSkinnedMeshPrefab.GetComponent<PartsInfo>();
        if (partsInfo != null)
        {
            if (skinnedMeshRenderer != null)
            {
                skinnedMeshRenderer.rootBone = System.Array.Find(childrens, x => x.name.Equals(partsInfo.RootboneName));
                for (int boneOrder = 0; boneOrder < partsInfo.BoneNames.Length; boneOrder++)
                {
                    bones[boneOrder] = System.Array.Find(childrens, x => x.name.Equals(partsInfo.BoneNames[boneOrder]));
                }
                skinnedMeshRenderer.bones = bones;
            }
        }
    }
}
