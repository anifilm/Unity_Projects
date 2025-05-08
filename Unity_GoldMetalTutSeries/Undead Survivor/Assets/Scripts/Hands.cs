using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Hands : MonoBehaviour
{
    public bool isLeft;
    public SpriteRenderer hand;

    SpriteRenderer playerSprite;

    Vector3 leftPosition = new Vector3(-0.162f, -0.363f, 0);
    Vector3 leftPositionReverse = new Vector3(-0.132f, -0.361f, 0);
    Vector3 leftRotation = new Vector3(0, 0, -20);
    Vector3 leftRotationReverse = new Vector3(0, 0, 15);
    Vector3 rightPosition = new Vector3(0.315f, -0.172f, 0);
    Vector3 rightPositionReverse = new Vector3(0.019f, -0.307f, 0);

    void Awake()
    {
        hand = transform.GetComponent<SpriteRenderer>();
        playerSprite = transform.parent.GetComponent<SpriteRenderer>();
    }

    void LateUpdate()
    {
        if (!GameManager.instance.isLive) return;

        if (playerSprite.flipX)
        {
            // 플레이어가 왼쪽으로 이동시
            if (isLeft)
            {
                hand.flipX = true;
                hand.sortingOrder = 4;
                transform.localPosition = leftPositionReverse;
                transform.localRotation = Quaternion.Euler(leftRotationReverse);
            }
            else
            {
                hand.flipX = true;
                hand.sortingOrder = 6;
                transform.localPosition = rightPositionReverse;
            }
        }
        else
        {
            // 플레이어가 오른쪽으로 이동시
            if (isLeft)
            {
                hand.flipX = false;
                hand.sortingOrder = 6;
                transform.localPosition = leftPosition;
                transform.localRotation = Quaternion.Euler(leftRotation);
            }
            else
            {
                hand.flipX = false;
                hand.sortingOrder = 4;
                transform.localPosition = rightPosition;
            }
        }
    }
}
