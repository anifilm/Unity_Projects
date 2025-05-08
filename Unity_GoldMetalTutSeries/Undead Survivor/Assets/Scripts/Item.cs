using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Item : MonoBehaviour
{
    public ItemData data;
    public int level;
    public Weapon weapon;
    public Gear gear;

    Image icon;
    Text textLevel;
    Text textName;
    Text textDescription;

    void Awake()
    {
        icon = GetComponentsInChildren<Image>()[1];
        icon.sprite = data.itemIcon;

        Text[] texts = GetComponentsInChildren<Text>();
        textLevel = texts[0];
        textName = texts[1];
        textDescription = texts[2];

        textName.text = data.itemName;
    }

    void LateUpdate()
    {
        textLevel.text = string.Format("LV.{0}", level);
    }

    void OnEnable()
    {
        textLevel.text = string.Format("LV.{0}", level);

        switch (data.itemType)
        {
            case ItemData.ItemType.Melee:
            case ItemData.ItemType.Range:
                textDescription.text = string.Format(data.itemDescription, data.damages[level] * 100, data.counts[level]);
                break;
            case ItemData.ItemType.Glove:
            case ItemData.ItemType.Shoes:
                textDescription.text = string.Format(data.itemDescription, data.damages[level] * 100);
                break;
            default:
                textDescription.text = string.Format(data.itemDescription);
                break;
        }
    }

    public void OnClick()
    {
        switch (data.itemType)
        {
            case ItemData.ItemType.Melee:
            case ItemData.ItemType.Range:
                if (level == 0)
                {
                    GameObject newWeapon = new GameObject();
                    weapon = newWeapon.AddComponent<Weapon>();
                    weapon.Init(data);
                }
                else
                {
                    float nextDamage = data.baseDamage;
                    int nextCount = data.baseCount;
                    nextDamage += data.baseDamage * data.damages[level];
                    nextCount += data.counts[level];
                    weapon.LevelUp(nextDamage, nextCount);
                }
                level++;
                break;
            case ItemData.ItemType.Glove:
            case ItemData.ItemType.Shoes:
                if (level == 0)
                {
                    GameObject newGear = new GameObject();
                    gear = newGear.AddComponent<Gear>();
                    gear.Init(data);
                }
                else
                {
                    float nextRate = data.damages[level];
                    gear.LevelUp(nextRate);
                }
                level++;
                break;
            case ItemData.ItemType.Heal:
                GameManager.instance.health = GameManager.instance.maxHealth;
                break;
        }


        if (level == data.damages.Length)
        {
            GetComponent<Button>().interactable = false;
            GetComponentsInChildren<Image>()[1].color = new Color(0.7f, 0.7f, 0.7f, 0.7f);
        }
    }
}
