using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class GameManager : MonoBehaviour
{
    const float ORIGIN_SPEED = 3f;
    public float globalSpeed = 1f;
    public static int highScore;
    public float score;
    public bool isLive;

    public static GameManager instance;
    public GameObject highScoreTextUI;
    public GameObject scoreTextUI;
    public GameObject gameoverUI;

    void Awake()
    {
        instance = this;
        Application.targetFrameRate = 60;
    }

    void Start()
    {
        score = 0f;
        isLive = true;
        highScore = PlayerPrefs.GetInt("HighScore", 99);
        scoreTextUI.GetComponent<Text>().text = "Score: " + (int)score;
        highScoreTextUI.GetComponent<Text>().text = string.Format("{0:000}", highScore);
        AudioManager.instance.PlayBgm(true);
        AudioManager.instance.PlaySfx(AudioManager.Sfx.Start);
    }

    void Update()
    {
        if (!isLive) return;

        score += Time.deltaTime * 2f;
        globalSpeed = ORIGIN_SPEED + (score * 0.01f);
    }

    void LateUpdate()
    {
        if (!isLive) return;

        scoreTextUI.GetComponent<Text>().text = "Score: " + (int)score;
        if (score > highScore)
        {
            highScore = (int)score;
            highScoreTextUI.GetComponent<Text>().text = string.Format("{0:000}", highScore);
        }
    }

    public void GameOver()
    {
        isLive = false;
        gameoverUI.SetActive(true);
        AudioManager.instance.PlayBgm(false);

        PlayerPrefs.SetInt("HighScore", highScore);
        PlayerPrefs.Save();
    }

    public void Restart()
    {
        SceneManager.LoadScene(0);
        isLive = true;
    }
}
