using Unity.VisualScripting;
using UnityEditor.SearchService;
using UnityEngine;
using UnityEngine.SceneManagement;

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
    public GameObject BuildingSpawner;
    public GameObject EnemySpawner;
    public GameObject FoodSpawner;
    public GameObject Player;

    [Header("Settings")]
    public int lives = 3;
    public int score = 0;

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
        gameState = GameState.Playing;
        mainMenuUI.SetActive(false);
        gameUI.SetActive(true);

        BuildingSpawner.SetActive(true);
        EnemySpawner.SetActive(true);
        FoodSpawner.SetActive(true);
        Player.SetActive(true);
    }

    public void GameOver()
    {
        gameState = GameState.GameOver;

        Invoke("RestartGame", 3f);
    }

    public void RestartGame()
    {
        //SceneManager.LoadScene(0);

        gameState = GameState.MainMenu;
        mainMenuUI.SetActive(true);
        gameUI.SetActive(false);

        BuildingSpawner.SetActive(false);
        EnemySpawner.SetActive(false);
        FoodSpawner.SetActive(false);
        Player.GetComponent<Player>().ResetPlayer();
        Player.SetActive(true);

        lives = 3;
        score = 0;
    }
}
