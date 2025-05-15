using UnityEngine;

public class Destroyer : MonoBehaviour
{
    void Update()
    {
        if (transform.position.x < -10)
        {
            Destroy(gameObject);
        }
    }
}
