using UnityEngine;

public class Spawner : MonoBehaviour
{
    [Header("Settings")]
    public Transform spawnPoint;
    public float spawnInterval = 2f;
    public float spawnRange = 2f;

    [Header("References")]
    public GameObject[] prefabsToSpawn;

    private int lastIndex = -1;

    void Start()
    {
        if (prefabsToSpawn.Length == 0)
        {
            Debug.LogError("No prefabs assigned to spawn.");
            return;
        }
    }

    public void OnEnable()
    {
        InvokeRepeating(nameof(Spawn), spawnInterval - 1f, spawnInterval);
    }

    public void OnDisable()
    {
        CancelInvoke(nameof(Spawn));
        // 모든 자식 오브젝트를 삭제
        foreach (Transform child in spawnPoint)
        {
            Destroy(child.gameObject);
        }
    }

    void Spawn()
    {
        if (GameManager.instance.gameState != GameState.Playing) return;

        int randomIndex = Random.Range(0, prefabsToSpawn.Length);
        // 중복되지 않도록 랜덤 인덱스 생성
        int attempts = 0;
        while (randomIndex == lastIndex && attempts < 10)
        {
            randomIndex = Random.Range(0, prefabsToSpawn.Length);
            attempts++;
        }
        lastIndex = randomIndex;

        GameObject prefabToSpawn = prefabsToSpawn[randomIndex];

        Vector3 spawnPosition = spawnPoint.position + new Vector3(Random.Range(-spawnRange, spawnRange), 0, 0);
        Instantiate(prefabToSpawn, spawnPosition, Quaternion.identity, spawnPoint);
    }
}
