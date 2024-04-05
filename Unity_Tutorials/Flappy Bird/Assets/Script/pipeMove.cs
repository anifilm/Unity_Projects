using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class pipeMove : MonoBehaviour
{
    public float pipeSpeed = 1.0f;

    // Update is called once per frame
    private void Update()
    {
        if (!GameManager.playerDie)
        {
            transform.Translate(-pipeSpeed * Time.deltaTime, 0, 0);
            if (transform.position.x <= -4.0f)
            {
                Destroy(gameObject);
            }
        }
    }
}
