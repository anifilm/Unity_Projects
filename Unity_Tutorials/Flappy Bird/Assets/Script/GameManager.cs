using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class GameManager : MonoBehaviour
{
    public float pipeTime = 1.0f;
    public float pipeMin = -1.0f;
    public float pipeMax = 1.0f;

    public GameObject pipePrefab;

    static public int score = 0;
    static public int bestScore = 0;
    public Text ScoreText;

    static public bool playerDie = true;

    public GameObject startPanel;
    public GameObject player;

    public void startBtn()
    {
        playerDie = false;
        StartCoroutine(PipeStart());
        startPanel.SetActive(false);
        player.GetComponent<Rigidbody2D>().simulated = true;
        player.SetActive(true);
    }

    // Start is called before the first frame update
    private void Start()
    {
        //StartCoroutine(PipeStart());
    }

    private void Update()
    {
        ScoreText.text = score.ToString();
    }

    IEnumerator PipeStart()
    {
        do
        {
            Instantiate(pipePrefab, new Vector3(Random.Range(2.7f, 2.9f), Random.Range(pipeMin, pipeMax), 0), Quaternion.Euler(new Vector3(0, 0, 0)));
            yield return new WaitForSeconds(pipeTime);
        } while (!playerDie);
    }
}
