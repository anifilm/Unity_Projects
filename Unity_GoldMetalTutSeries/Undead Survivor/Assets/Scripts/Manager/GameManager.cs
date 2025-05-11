using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class GameManager : MonoBehaviour
{
    public static GameManager instance;

    [Header("Game Controll")]
    public float gameTime;
    public float maxGameTime = 300f;
    public bool isLive;

    [Header("Player Info")]
    public int playerId;
    public float health = 0;
    public float maxHealth = 100;
    public int level = 1;
    public int kill = 0;
    public int exp = 0;
    public int[] nextExp = { 1, 5, 10, 15, 20, 30, 60, 100, 150, 210, 280, 360, 450, 600 };

    [Header("Game Object")]
    public PoolManager poolManager;
    public Player player;
    public LevelUp levelUpUI;
    public Result resultUI;
    public GameObject enemyCleaner;

    void Awake()
    {
        instance = this;
    }

    public void GameStart(int id)
    {
        playerId = id;
        health = maxHealth;
        player.gameObject.SetActive(true);
        levelUpUI.Select(playerId % 4);
        Resume();
    }

    public void GameOver()
    {
        StartCoroutine(GameOverRoutine());
    }

    IEnumerator GameOverRoutine()
    {
        isLive = false;
        yield return new WaitForSeconds(0.5f);
        resultUI.gameObject.SetActive(true);
        resultUI.Lose();
        Time.timeScale = 0.5f;
    }

    public void GameVictory()
    {
        StartCoroutine(GameVictoryRoutine());
    }

    IEnumerator GameVictoryRoutine()
    {
        isLive = false;
        enemyCleaner.SetActive(true);
        yield return new WaitForSeconds(0.5f);
        resultUI.gameObject.SetActive(true);
        resultUI.Win();
        Time.timeScale = 0.5f;
    }

    public void GameRetry()
    {
        SceneManager.LoadScene(0);
    }

    void Update()
    {
        if (!isLive) return;

        gameTime += Time.deltaTime;
        if (gameTime >= maxGameTime)
        {
            gameTime = maxGameTime;
            GameVictory();
        }
    }

    public void GetExp()
    {
        if (!isLive) return;

        exp++;
        if (exp >= nextExp[Mathf.Min(level, nextExp.Length - 1)])
        {
            LevelUp();
        }
    }

    public void LevelUp()
    {
        level++;
        exp = 0;
        levelUpUI.Show();
    }

    public void Stop()
    {
        isLive = false;
        Time.timeScale = 0f;
    }

    public void Resume()
    {
        isLive = true;
        Time.timeScale = 1f;
    }
}
