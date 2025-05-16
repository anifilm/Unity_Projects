using UnityEngine;
using UnityEngine.UIElements;

public class Player : MonoBehaviour
{
    [Header("Settings")]
    public float firstJumpForce = 5f;
    public float secondJumpForce = 5f;

    enum PlayerState
    {
        Idle,
        Running,
        FirstJumping,
        SecondJumping,
        Dead = 5,
        NotInvincible,
        Invincible,
    }

    private Rigidbody2D playerRigidBody;
    private CapsuleCollider2D playerCollider;
    private Animator playerAnimator;

    private bool isInvincible = false;
    private bool isGround = true;
    private bool isJumping = false;

    void Start()
    {
        playerRigidBody = GetComponent<Rigidbody2D>();
        playerCollider = GetComponent<CapsuleCollider2D>();
        playerAnimator = GetComponent<Animator>();
    }

    void Update()
    {
        if (GameManager.instance.gameState != GameState.Playing) return;

        if (isGround && (Input.GetKeyDown(KeyCode.Space) || Input.GetMouseButtonDown(0)))
        {
            isJumping = true;
            Jump(firstJumpForce);
        }
        else if (!isGround && isJumping && (Input.GetKeyDown(KeyCode.Space) || Input.GetMouseButtonDown(0)))
        {
            isJumping = false;
            Jump(secondJumpForce);
        }
    }

    void Jump(float jumpForce)
    {
        playerRigidBody.AddForceY(jumpForce, ForceMode2D.Impulse);
        if (isJumping)
        {
            ChangeAnimation(PlayerState.FirstJumping);
            AudioManager.instance.PlaySfx(AudioManager.Sfx.Jump);
        }
        else
        {
            ChangeAnimation(PlayerState.SecondJumping);
            AudioManager.instance.PlaySfx(AudioManager.Sfx.Jump);
        }
    }

    void OnCollisionExit2D(Collision2D collision)
    {
        isGround = false;

    }

    void OnCollisionEnter2D(Collision2D collision)
    {
        if (!isGround && collision.gameObject.CompareTag("Ground"))
        {
            isGround = true;
            ChangeAnimation(PlayerState.Running);
            AudioManager.instance.PlaySfx(AudioManager.Sfx.Land);
        }
    }

    void OnTriggerEnter2D(Collider2D collider)
    {
        if (collider.CompareTag("Enemy"))
        {
            if (!isInvincible)
            {
                AudioManager.instance.PlaySfx(AudioManager.Sfx.Hit);
                Hit();
            }
        }
        else if (collider.CompareTag("Food"))
        {
            Destroy(collider.gameObject);
            AudioManager.instance.PlaySfx(AudioManager.Sfx.Heal);
            Heal();
        }
        else if (collider.CompareTag("Gold"))
        {
            Destroy(collider.gameObject);
            AudioManager.instance.PlaySfx(AudioManager.Sfx.Gold);
            StartInvincible(6f);
        }
    }

    void ChangeAnimation(PlayerState state)
    {
        playerAnimator.SetInteger("State", (int)state);
    }

    void Hit()
    {
        GameManager.instance.lives -= 1;

        if (GameManager.instance.lives <= 0)
        {
            Dead();
        }
        else
        {
            if (isGround)
            {
                playerRigidBody.AddForceY(secondJumpForce, ForceMode2D.Impulse);
            }
            StartInvincible(2f);
        }
    }

    void Heal()
    {
        GameManager.instance.lives = Mathf.Min(GameManager.instance.lives + 1, 3);
    }

    void Dead()
    {
        playerRigidBody.AddForceY(firstJumpForce * 1.5f, ForceMode2D.Impulse);
        playerCollider.enabled = false;
        ChangeAnimation(PlayerState.Dead);

        GameManager.instance.GameOver();
    }

    void StartInvincible(float duration)
    {
        isInvincible = true;
        playerAnimator.SetBool("Invinsible", isInvincible);
        Invoke("StopInvincible", duration);
    }

    void StopInvincible()
    {
        isInvincible = false;
        playerAnimator.SetBool("Invinsible", isInvincible);
    }

    public void ResetPlayer()
    {
        gameObject.SetActive(false);
        playerCollider.enabled = true;
        ChangeAnimation(PlayerState.Running);
        transform.position = new Vector3(-3, -1.258f, 0);
        isInvincible = false;
        isGround = true;
        isJumping = false;
    }
}
