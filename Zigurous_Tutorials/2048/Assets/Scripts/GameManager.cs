using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class GameManager : MonoBehaviour
{
    public static GameManager instance { get; private set; }

    [SerializeField] private TileBoard board;
    [SerializeField] private CanvasGroup gameOverUI;
    [SerializeField] private TextMeshProUGUI scoreText;
    [SerializeField] private TextMeshProUGUI bestScoreText;

    public int score { get; private set; } = 0;

    void Awake()
    {
        instance = this;
    }

    void Start()
    {
        NewGame();
    }

    public void NewGame()
    {
        Debug.Log("New Game!");

        SetScore(0);
        bestScoreText.text = LoadBestScore().ToString();

        gameOverUI.alpha = 0f;
        gameOverUI.interactable = false;

        board.ClearBoard();
        board.CreateTile();
        board.CreateTile();
        board.enabled = true;
    }

    public void GameOver()
    {
        Debug.Log("Game Over!");

        board.enabled = false;
        gameOverUI.interactable = true;
        StartCoroutine(Fade(gameOverUI, 1f, 1f));
    }

    private IEnumerator Fade(CanvasGroup canvasGroup, float to, float delay = 0f)
    {
        yield return new WaitForSeconds(delay);

        float elapsedTime = 0f;
        float duration = 0.5f;
        float from = canvasGroup.alpha;

        while (elapsedTime < duration)
        {
            canvasGroup.alpha = Mathf.Lerp(from, to, elapsedTime / duration);
            elapsedTime += Time.deltaTime;
            yield return null;
        }

        canvasGroup.alpha = to;
    }

    public void IncreaseScore(int amount)
    {
        SetScore(score + amount);
    }

    private void SetScore(int score)
    {
        this.score = score;
        scoreText.text = score.ToString();

        SaveBestScore();
    }

    private void SaveBestScore()
    {
        int currentBestScore = LoadBestScore();

        if (score > currentBestScore)
        {
            PlayerPrefs.SetInt("BestScore", score);
            bestScoreText.text = score.ToString();
        }
    }

    private int LoadBestScore()
    {
        return PlayerPrefs.GetInt("BestScore", 0);
    }
}
