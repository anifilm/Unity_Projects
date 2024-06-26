using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class flyButton : MonoBehaviour
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
        if (!GameManager.playerDie)
        {
            if (Input.GetMouseButtonDown(0))
            {
                birdAnim.SetTrigger("Tap");
                GetComponent<Rigidbody2D>().velocity = new Vector3(0, birdJump, 0);
                transform.rotation = Quaternion.Euler(0, 0, 36f);
            }
#if UNITY_EDITOR
            transform.Rotate(0, 0, -0.05f);
#elif UNITY_ANDROID
            transform.Rotate(0, 0, -0.5f);
#endif
        }
        else
        {
            // die
            birdAnim.SetTrigger("Die");
        }
    }

    private void OnCollisionEnter2D(Collision2D collision)
    {
        if (collision.gameObject.tag.CompareTo("Pipe_Ground") == 0)
        {
            GameManager.playerDie = true;
            EndPannel.SetActive(true);
        }
    }
}
