using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Spawner : MonoBehaviour
{
    public Transform[] spawnPoints;
    public SpawnData[] spawnDatas;
    public float levelTime;

    public int gameLevel;
    float spawnTime;

    void Awake()
    {
        spawnPoints = GetComponentsInChildren<Transform>();
    }

    void OnEnable()
    {
        if (!GameManager.instance) return;
        levelTime = (GameManager.instance.maxGameTime / spawnDatas.Length) - 1f;
    }

    void Update()
    {
        if (!GameManager.instance.isLive) return;

        spawnTime += Time.deltaTime;
        gameLevel = Mathf.Min(Mathf.FloorToInt(GameManager.instance.gameTime / levelTime), spawnDatas.Length - 1);

        if (spawnTime > spawnDatas[gameLevel].spawnTime)
        {
            Spawn();
            spawnTime = 0;
        }
    }

    void Spawn()
    {
        GameObject enemy = GameManager.instance.poolManager.GetObject(0);
        enemy.transform.position = spawnPoints[Random.Range(1, spawnPoints.Length)].position;
        enemy.GetComponent<Enemy>().Init(spawnDatas[gameLevel]);
    }
}

[System.Serializable]
public class SpawnData
{
    public float spawnTime;
    public int spriteType;
    public int health;
    public float speed;
}
