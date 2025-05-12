using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Reposition : MonoBehaviour
{
    public float positionValue = 17f;

    void LateUpdate()
    {
        if (transform.position.x > -positionValue) return;

        transform.position = new Vector3(positionValue, transform.position.y, transform.position.z);
    }
}
