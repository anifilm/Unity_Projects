using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class EndPanelManager : MonoBehaviour
{
    public Text Score;
    public Text BestScore;

    public GameObject newImage;
    public GameObject medal;
    public Sprite gold_m;
    public Sprite silver_m;
    public Sprite bronze_m;

    public void OnEnable()
    {
        Score.text = GameManager.instance.score.ToString();

        if (GameManager.instance.bestScore < GameManager.instance.score)
        {
            GameManager.instance.bestScore = GameManager.instance.score;
            newImage.SetActive(true);

            PlayerPrefs.SetInt("BestScore", GameManager.instance.bestScore);
            PlayerPrefs.Save();
        }
        else
        {
            newImage.SetActive(false);
        }

        BestScore.text = GameManager.instance.bestScore.ToString();

        if (GameManager.instance.score >= 10)
        {
            medal.GetComponent<Image>().sprite = gold_m;
        }
        else if (GameManager.instance.score >= 2)
        {
            medal.GetComponent<Image>().sprite = silver_m;
        }
        else
        {
            medal.GetComponent<Image>().sprite = bronze_m;
        }
    }

    public void OkBtn()
    {
        AudioManager.instance.PlaySfx(AudioManager.Sfx.Start);
        Invoke("RestartGame", 0.5f);
    }

    void RestartGame()
    {
        SceneManager.LoadScene(0);
    }
}
