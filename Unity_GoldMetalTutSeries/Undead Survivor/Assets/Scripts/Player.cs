using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;

public class Player : MonoBehaviour
{
    public Vector2 inputVec;
    public float speed;

    Rigidbody2D rigid;
    SpriteRenderer sprite;
    Animator animator;

    void Awake()
    {
        rigid = GetComponent<Rigidbody2D>();
        sprite = GetComponent<SpriteRenderer>();
        animator = GetComponent<Animator>();
    }

    void Update()
    {
        // 인풋 시스템 변경으로 주석 처리
        //inputVec.x = Input.GetAxis("Horizontal");
        //inputVec.y = Input.GetAxis("Vertical");
    }

    void FixedUpdate()
    {
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
}
