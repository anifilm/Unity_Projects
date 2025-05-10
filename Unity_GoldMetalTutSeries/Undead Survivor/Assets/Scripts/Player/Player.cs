using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;

public class Player : MonoBehaviour
{
    public Vector2 inputVec;
    public float speed;
    public Scanner scanner;
    public Hands[] hands;
    public RuntimeAnimatorController[] animatorControllers;

    Rigidbody2D rigid;
    SpriteRenderer sprite;
    Animator animator;

    void Awake()
    {
        scanner = GetComponent<Scanner>();
        rigid = GetComponent<Rigidbody2D>();
        sprite = GetComponent<SpriteRenderer>();
        animator = GetComponent<Animator>();
        hands = GetComponentsInChildren<Hands>(true);
    }

    void OnEnable()
    {
        if (!GameManager.instance) return;

        animator.runtimeAnimatorController = animatorControllers[GameManager.instance.playerId % 2];
        speed *= Character.Speed;
    }

    void Update()
    {
        if (!GameManager.instance.isLive) return;

        // 인풋 시스템 변경으로 주석 처리
        //inputVec.x = Input.GetAxis("Horizontal");
        //inputVec.y = Input.GetAxis("Vertical");
    }

    void FixedUpdate()
    {
        if (!GameManager.instance.isLive) return;

        // 1. 힘을 준다
        //rigid.AddForce(inputVec);
        // 2. 속도 제어
        //rigid.velocity = inputVec;
        // 3. 위치 이동
        Vector2 nextVec = inputVec * speed * Time.fixedDeltaTime;
        rigid.MovePosition(rigid.position + nextVec);
    }

    void LateUpdate()
    {
        if (!GameManager.instance.isLive) return;

        animator.SetFloat("Speed", inputVec.magnitude);

        if (inputVec.x > 0)
            sprite.flipX = false;
        else if (inputVec.x < 0)
            sprite.flipX = true;
    }

    void OnMove(InputValue value)
    {
        inputVec = value.Get<Vector2>();
    }

    void OnCollisionStay2D(Collision2D collision)
    {
        if (!GameManager.instance.isLive) return;

        GameManager.instance.health -= 10 * Time.deltaTime;

        if (GameManager.instance.health <= 0)
        {
            for (int i = 2; i < transform.childCount; i++)
            {
                transform.GetChild(i).gameObject.SetActive(false);
            }
            animator.SetTrigger("Dead");
            sprite.sortingOrder = 1;

            GameManager.instance.GameOver();
        }
    }
}
