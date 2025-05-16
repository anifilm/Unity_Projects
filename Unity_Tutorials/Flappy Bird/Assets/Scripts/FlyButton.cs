using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FlyButton : MonoBehaviour
{
    public float birdJump = 2.0f;
    public GameObject EndPannel;

    public Animator birdAnim;

    // Start is called before the first frame update
    private void Start()
    {
        GetComponent<Rigidbody2D>().velocity = new Vector3(0, birdJump, 0);
        transform.rotation = Quaternion.Euler(0, 0, 36f);
    }

    // Update is called once per frame
    private void Update()
    {
        if (!GameManager.instance.playerDie)
        {
            if (Input.GetMouseButtonDown(0))
            {
                birdAnim.SetTrigger("Tap");
                AudioManager.instance.PlaySfx(AudioManager.Sfx.Fly);
                GetComponent<Rigidbody2D>().velocity = new Vector3(0, birdJump, 0);
                transform.rotation = Quaternion.Euler(0, 0, 36f);
            }

            transform.Rotate(0, 0, -0.6f);
        }
        else
        {
            // die
            birdAnim.SetTrigger("Die");
        }
    }

    private void OnCollisionEnter2D(Collision2D collision)
    {
        if (!GameManager.instance.playerDie && collision.gameObject.CompareTag("Pipe"))
        {
            GameManager.instance.playerDie = true;
            EndPannel.SetActive(true);
            AudioManager.instance.PlaySfx(AudioManager.Sfx.Hit);
            AudioManager.instance.PlayBgm(false);
        }
        else if (collision.gameObject.CompareTag("Ground"))
        {
            GameManager.instance.playerDie = true;
            EndPannel.SetActive(true);
            AudioManager.instance.PlaySfx(AudioManager.Sfx.Land);
            AudioManager.instance.PlayBgm(false);
        }
    }
}
