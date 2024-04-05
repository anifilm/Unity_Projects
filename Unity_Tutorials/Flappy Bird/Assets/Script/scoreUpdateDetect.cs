using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class scoreUpdateDetect : MonoBehaviour
{
    private void OnTriggerExit2D(Collider2D collision)
    {
        if (collision.gameObject.tag.CompareTo("Player") == 0)
        {
            //Debug.LogError("점수");
            GameManager.score += 1;
        }
    }
}
