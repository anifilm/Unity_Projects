using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class Reposition : MonoBehaviour
{
    public float positionValue = 17f;
    public UnityEvent onMove;

    void LateUpdate()
    {
        if (transform.position.x > -positionValue) return;

        transform.position = new Vector3(positionValue, transform.position.y, transform.position.z);
        onMove?.Invoke();
    }
}
