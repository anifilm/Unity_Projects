using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class GameManager : MonoBehaviour
{
    public static GameManager instance;

    public float pipeTime = 1.0f;
    public float pipeMin = -1.0f;
    public float pipeMax = 1.0f;

    public GameObject pipePrefab;

    public int score = 0;
    public int bestScore = 0;
    public Text ScoreText;

    public bool playerDie = false;

    public GameObject startPanel;
    public GameObject player;

    void Awake()
    {
        instance = this;
        Application.targetFrameRate = 60;
    }

    private void Start()
    {
        //StartCoroutine(PipeStart());
        if (PlayerPrefs.HasKey("BestScore"))
        {
            bestScore = PlayerPrefs.GetInt("BestScore");
        }
        score = 0;
    }

    private void Update()
    {
        ScoreText.text = score.ToString();
    }

    public void StartBtn()
    {
        playerDie = false;
        StartCoroutine(PipeStart());
        startPanel.SetActive(false);
        player.GetComponent<Rigidbody2D>().simulated = true;
        player.SetActive(true);

        AudioManager.instance.PlaySfx(AudioManager.Sfx.Start);
        AudioManager.instance.PlayBgm(true);
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
