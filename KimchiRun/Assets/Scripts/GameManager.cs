using Unity.VisualScripting;
using UnityEditor.SearchService;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.SocialPlatforms.Impl;

public enum GameState
{
    MainMenu,
    Playing,
    GameOver,
}

public class GameManager : MonoBehaviour
{
    public static GameManager instance;

    public GameState gameState = GameState.MainMenu;

    [Header("References")]
    public GameObject mainMenuUI;
    public GameObject gameUI;
    public GameObject scoreUI;

    public GameObject BuildingSpawner;
    public GameObject EnemySpawner;
    public GameObject FoodSpawner;
    public GameObject Player;

    [Header("Settings")]
    public int lives = 3;
    public int score = 0;

    private float playStartTime;

    void Awake()
    {
        if (instance == null)
        {
            instance = this;
        }
    }

    void Start()
    {
        mainMenuUI.SetActive(true);
        gameUI.SetActive(false);

        if (PlayerPrefs.HasKey("HighScore"))
        {
            scoreUI.GetComponent<UnityEngine.UI.Text>().text = "High Score: " + PlayerPrefs.GetInt("HighScore").ToString();
        }
        else
        {
            scoreUI.SetActive(false);
        }

        BuildingSpawner.SetActive(false);
        EnemySpawner.SetActive(false);
        FoodSpawner.SetActive(false);
        Player.SetActive(true);
    }

    void Update()
    {
        if (gameState == GameState.MainMenu)
        {
            if (Input.GetKeyDown(KeyCode.Space))
            {
                GameStart();
            }
        }
        else if (gameState == GameState.Playing)
        {
            if (Input.GetKeyDown(KeyCode.Escape))
            {
                gameState = GameState.MainMenu;
            }

            CalculateScore();
        }
        else if (gameState == GameState.GameOver)
        {
            if (Input.GetKeyDown(KeyCode.R))
            {
                gameState = GameState.Playing;
            }
        }
    }

    public void GameStart()
    {
        AudioManager.instance.PlaySfx(AudioManager.Sfx.Start);
        Invoke("PlayBgm", 1f);

        gameState = GameState.Playing;
        mainMenuUI.SetActive(false);
        gameUI.SetActive(true);
        scoreUI.SetActive(true);

        // 점수 초기화
        lives = 3;
        score = 0;
        playStartTime = Time.time;

        BuildingSpawner.SetActive(true);
        EnemySpawner.SetActive(true);
        FoodSpawner.SetActive(true);
        Player.SetActive(true);
    }

    void CalculateScore()
    {
        score = (int)(Time.time - playStartTime);
        scoreUI.GetComponent<UnityEngine.UI.Text>().text = "Score: " + score.ToString();
    }

    void SaveHighScore()
    {
        if (PlayerPrefs.GetInt("HighScore") < score)
        {
            PlayerPrefs.SetInt("HighScore", score);
        }
        scoreUI.GetComponent<UnityEngine.UI.Text>().text = "High Score: " + score.ToString();
    }

    public void GameOver()
    {
        gameState = GameState.GameOver;

        Invoke("RestartGame", 3f);
    }

    public void RestartGame()
    {
        SaveHighScore();
        AudioManager.instance.PlayBgm(false);

        // 씬을 다시 로드하여 게임을 초기화
        //SceneManager.LoadScene(0);

        gameState = GameState.MainMenu;
        mainMenuUI.SetActive(true);
        gameUI.SetActive(false);

        BuildingSpawner.SetActive(false);
        EnemySpawner.SetActive(false);
        FoodSpawner.SetActive(false);
        Player.GetComponent<Player>().ResetPlayer();
        Player.SetActive(true);
    }

    void PlayBgm()
    {
        AudioManager.instance.PlayBgm(true);
    }
}
