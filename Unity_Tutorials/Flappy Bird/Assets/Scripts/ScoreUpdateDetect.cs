using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ScoreUpdateDetect : MonoBehaviour
{
    private void OnTriggerExit2D(Collider2D collision)
    {
        if (collision.gameObject.CompareTag("Player"))
        {
            GameManager.instance.score += 1;
        }
    }
}
