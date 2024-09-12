using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ChangeSkinnedMesh : MonoBehaviour
{
    [SerializeField] SkinnedMeshRenderer skinnedMeshRenderer;
    [SerializeField] Mesh meshToChangeTo;

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space))
        {
            ChangeMesh();
        }
    }

    public void ChangeMesh()
    {
        skinnedMeshRenderer.sharedMesh = meshToChangeTo;
    }
}
