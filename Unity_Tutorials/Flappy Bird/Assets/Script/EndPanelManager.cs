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
        Score.text = GameManager.score.ToString();

        if (GameManager.bestScore < GameManager.score)
        {
            GameManager.bestScore = GameManager.score;
            newImage.SetActive(true);
        }
        else
        {
            newImage.SetActive(false);
        }

        BestScore.text = GameManager.bestScore.ToString();

        if (GameManager.score >= 10)
        {
            medal.GetComponent<Image>().sprite = gold_m;
        }
        else if (GameManager.score >= 2)
        {
            medal.GetComponent<Image>().sprite = silver_m;
        }
        else
        {
            medal.GetComponent<Image>().sprite = bronze_m;
        }
    }

    public void okBtn()
    {
        GameManager.score = 0;
        SceneManager.LoadScene("main");
    }
}
