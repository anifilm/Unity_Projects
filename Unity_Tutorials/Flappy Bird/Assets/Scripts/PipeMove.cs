using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PipeMove : MonoBehaviour
{
    public float pipeSpeed = 1.0f;

    void Update()
    {
        if (!GameManager.instance.playerDie)
        {
            transform.Translate(-pipeSpeed * Time.deltaTime, 0, 0);
            if (transform.position.x <= -4.0f)
            {
                Destroy(gameObject);
            }
        }
    }
}
