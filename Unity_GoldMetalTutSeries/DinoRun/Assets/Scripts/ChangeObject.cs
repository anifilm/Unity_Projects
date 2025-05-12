using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ChangeObject : MonoBehaviour
{
    public GameObject[] gameObjects;

    void Awake()
    {
        ChangeGameObject();
    }

    public void ChangeGameObject()
    {
        int randomObject = Random.Range(0, gameObjects.Length);
        int randomScale = Random.Range(0, 2);
        for (int i = 0; i < gameObjects.Length; i++)
        {
            transform.GetChild(i).gameObject.transform.localScale = new Vector3(randomScale == 0 ? 1 : -1, 1, 1);
            transform.GetChild(i).gameObject.SetActive(i == randomObject);
        }
    }
}
