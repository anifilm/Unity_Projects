using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Dino : MonoBehaviour
{
    public enum DinoState
    {
        Stand, Run, Jump, Hit
    }

    public float startJumpForce;
    public float jumpForce;
    private bool isGround = true;
    private bool isJump = false;

    private Rigidbody2D rigid;
    private Animator animator;

    void Awake()
    {
        rigid = GetComponent<Rigidbody2D>();
        animator = GetComponent<Animator>();
    }

    void Update()
    {
        if (GameManager.instance.isLive == false) return;

        if (isGround && (Input.GetButtonDown("Jump") || Input.GetMouseButtonDown(0)))
        {
            isJump = true;
            rigid.AddForce(Vector2.up * startJumpForce, ForceMode2D.Impulse);
            AudioManager.instance.PlaySfx(AudioManager.Sfx.Jump);
        }
        else if (!isGround && isJump && (Input.GetButtonDown("Jump") || Input.GetMouseButtonDown(0)))
        {
            isJump = false;
            rigid.AddForce(Vector2.up * jumpForce, ForceMode2D.Impulse);
            AudioManager.instance.PlaySfx(AudioManager.Sfx.Jump);
        }
    }

    void OnCollisionExit2D(Collision2D collision)
    {
        isGround = false;
        ChangeAnimation(DinoState.Jump);
    }

    void OnCollisionEnter2D(Collision2D collision)
    {
        isGround = true;
        ChangeAnimation(DinoState.Run);
        AudioManager.instance.PlaySfx(AudioManager.Sfx.Land);
    }

    void OnTriggerEnter2D(Collider2D collision)
    {
        rigid.simulated = false;
        ChangeAnimation(DinoState.Hit);
        AudioManager.instance.PlaySfx(AudioManager.Sfx.Hit);
        GameManager.instance.GameOver();
    }

    void ChangeAnimation(DinoState state)
    {
        animator.SetInteger("State", (int)state);
    }
}
