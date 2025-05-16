using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BgMove : MonoBehaviour
{
    public float moveSpeed = 0.2f;
    public float startPos = 2.0f;
    public float resetPos = -0.3f;

    // Update is called once per frame
    private void Update()
    {
        if (!GameManager.instance.playerDie)
        {
            transform.Translate(-moveSpeed * Time.deltaTime, 0, 0);
            if (transform.position.x <= resetPos)
            {
                transform.position = new Vector3(startPos, 0, 0);
            }
        }
    }
}
