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
    Collider2D coll;
    Animator animator;

    WaitForFixedUpdate wait;

    void Awake()
    {
        sprite = GetComponent<SpriteRenderer>();
        rigid = GetComponent<Rigidbody2D>();
        coll = GetComponent<Collider2D>();
        animator = GetComponent<Animator>();
        wait = new WaitForFixedUpdate();
    }

    void OnEnable()
    {
        target = GameManager.instance.player.GetComponent<Rigidbody2D>();
        health = maxHealth;
        isLive = true;
        coll.enabled = true;
        rigid.simulated = true;
        sprite.sortingOrder = 2;
        //animator.SetBool("Dead", false);
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
        if (!isLive || animator.GetCurrentAnimatorStateInfo(0).IsName("Hit")) return;

        Vector2 dirVector = target.position - rigid.position;
        Vector2 nextVector = dirVector.normalized * speed * Time.fixedDeltaTime;
        rigid.MovePosition(rigid.position + nextVector);
        rigid.velocity = Vector2.zero;
    }

    void LateUpdate()
    {
        if (!isLive || animator.GetCurrentAnimatorStateInfo(0).IsName("Hit")) return;

        sprite.flipX = target.position.x < rigid.position.x;
    }

    void OnTriggerEnter2D(Collider2D collision)
    {
        if (!collision.CompareTag("Bullet") || !isLive) return;

        Bullet bullet = collision.GetComponent<Bullet>();
        health -= bullet.damage;
        StartCoroutine(KnockBackHit());

        if (health > 0)
        {
            animator.SetTrigger("Hit");
        }
        else if (health <= 0)
        {
            isLive = false;
            coll.enabled = false;
            rigid.simulated = false;
            sprite.sortingOrder = 1;
            animator.SetBool("Dead", true);
            GameManager.instance.kill++;
            GameManager.instance.GetExp();
        }
    }

    IEnumerator KnockBackHit()
    {
        yield return wait; // 다음 하나의 물리 프레임 딜레이
        Vector3 playerPos = GameManager.instance.player.transform.position;
        Vector3 dirVector = transform.position - playerPos;
        rigid.AddForce(dirVector.normalized * 3f, ForceMode2D.Impulse);
    }

    void Dead()
    {
        gameObject.SetActive(false);
    }
}
