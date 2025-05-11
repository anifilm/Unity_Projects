using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LevelUp : MonoBehaviour
{
    RectTransform rectTransform;
    Item[] items;

    void Awake()
    {
        rectTransform = GetComponent<RectTransform>();
        items = GetComponentsInChildren<Item>(true);
    }

    public void Show()
    {
        Next();
        rectTransform.localScale = Vector3.one;
        GameManager.instance.Stop();
        AudioManager.instance.FilterBgm(true);
        AudioManager.instance.PlaySfx(AudioManager.Sfx.LevelUp);
    }

    public void Hide()
    {
        rectTransform.localScale = Vector3.zero;
        GameManager.instance.Resume();
        AudioManager.instance.FilterBgm(false);
        AudioManager.instance.PlaySfx(AudioManager.Sfx.Select);
    }

    public void Select(int index)
    {
        items[index].OnClick();
    }

    void Next()
    {
        foreach (Item item in items)
        {
            item.gameObject.SetActive(false);
        }

        int[] randomSelection = new int[3];
        while (true)
        {
            randomSelection[0] = Random.Range(0, items.Length);
            randomSelection[1] = Random.Range(0, items.Length);
            randomSelection[2] = Random.Range(0, items.Length);
            if (randomSelection[0] != randomSelection[1] && randomSelection[0] != randomSelection[2] && randomSelection[1] != randomSelection[2])
            {
                break;
            }
        }

        for (int i = 0; i < randomSelection.Length; i++)
        {
            Item randomItem = items[randomSelection[i]];
            if (randomItem.level == randomItem.data.damages.Length)
            {
                items[4].gameObject.SetActive(true);
            }
            else
            {
                randomItem.gameObject.SetActive(true);
            }
        }
    }
}
