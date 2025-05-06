using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Enemy : MonoBehaviour
{
    public Rigidbody2D target;
    public RuntimeAnimatorController[] animatorControllers;
    public float speed;
    public float health;
    public float maxHealth;
    bool isLive;

    SpriteRenderer sprite;
    Rigidbody2D rigid;
    Animator animator;

    void Awake()
    {
        sprite = GetComponent<SpriteRenderer>();
        rigid = GetComponent<Rigidbody2D>();
        animator = GetComponent<Animator>();
    }

    void OnEnable()
    {
        target = GameManager.instance.player.GetComponent<Rigidbody2D>();
        health = maxHealth;
        isLive = true;
    }

    public void Init(SpawnData spawnData)
    {
        animator.runtimeAnimatorController = animatorControllers[spawnData.spriteType];
        speed = spawnData.speed;
        maxHealth = spawnData.health;
        health = maxHealth;
    }

    void FixedUpdate()
    {
        if (!isLive) return;

        Vector2 dirVector = target.position - rigid.position;
        Vector2 nextVector = dirVector.normalized * speed * Time.fixedDeltaTime;
        rigid.MovePosition(rigid.position + nextVector);
        rigid.velocity = Vector2.zero;
    }

    void LateUpdate()
    {
        if (!isLive) return;

        sprite.flipX = target.position.x < rigid.position.x;
    }


    void OnTriggerEnter2D(Collider2D collision)
    {
        if (!collision.CompareTag("Bullet")) return;

        Bullet bullet = collision.GetComponent<Bullet>();
        health -= bullet.damage;

        if (health > 0)
        {
            isLive = true;
        }
        else
        {
            isLive = false;
            Dead();
        }
    }

    void Dead()
    {
        gameObject.SetActive(false);
    }
}
