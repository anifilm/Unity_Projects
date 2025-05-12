using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ChangeSprite : MonoBehaviour
{
    public Sprite[] sprites;
    SpriteRenderer spriteRenderer;

    void Awake()
    {
        spriteRenderer = GetComponent<SpriteRenderer>();
        ChangeSpriteImage();
    }

    public void ChangeSpriteImage()
    {
        int random = Random.Range(0, sprites.Length);
        spriteRenderer.sprite = sprites[random];
    }
}
