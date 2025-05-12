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
        if (isGround && Input.GetButtonDown("Jump"))
        {
            isJump = true;
            rigid.AddForce(Vector2.up * startJumpForce, ForceMode2D.Impulse);
        }
        else if (!isGround && isJump && Input.GetButtonDown("Jump"))
        {
            isJump = false;
            rigid.AddForce(Vector2.up * jumpForce, ForceMode2D.Impulse);
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
    }

    void OnTriggerEnter2D(Collider2D collision)
    {
        rigid.simulated = false;
        ChangeAnimation(DinoState.Hit);
    }

    void ChangeAnimation(DinoState state)
    {
        animator.SetInteger("State", (int)state);
    }
}
