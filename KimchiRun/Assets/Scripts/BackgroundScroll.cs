using UnityEngine;

public class BackgroundScroll : MonoBehaviour
{
    [Header("Settings")]
    [Tooltip("The speed at which the background scrolls.")]
    [Range(0.1f, 1f)]
    public float scrollSpeed = 0.5f;

    [Header("References")]
    public MeshRenderer meshRenderer;

    void Update()
    {
        meshRenderer.material.mainTextureOffset += new Vector2((scrollSpeed * GameManager.instance.CalculateGameSpeed()) * Time.deltaTime, 0);
    }
}
