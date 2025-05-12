using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Scroller : MonoBehaviour
{
    public int count;
    public float scrollRate;

    void Start()
    {
        count = transform.childCount;
    }

    void Update()
    {
        if (GameManager.instance.isLive == false) return;

        float totalSpeed = GameManager.instance.globalSpeed * scrollRate;
        transform.Translate(Vector3.left * totalSpeed * Time.deltaTime);
    }
}
