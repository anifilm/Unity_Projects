using UnityEngine;

public class Mover : MonoBehaviour
{
    [Header("Settings")]
    public float moveSpeed = 3f;

    void Update()
    {
        transform.Translate(Vector3.left * (moveSpeed * GameManager.instance.CalculateGameSpeed()) * Time.deltaTime);
    }
}
