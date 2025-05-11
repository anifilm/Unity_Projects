using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Weapon : MonoBehaviour
{
    public int id;
    public int prefabId;
    public float damage;
    public int count;
    public float speed;
    private float timer;

    Player player;

    void Awake()
    {
        player = GameManager.instance.player;
    }

    public void LevelUp(float damage, int count)
    {
        this.damage = damage * Character.Damage;
        this.count = count + (int)Character.Count;

        if (id == 0)
            Setup();

        player.BroadcastMessage("ApplyGear", SendMessageOptions.DontRequireReceiver);
    }

    public void Init(ItemData data)
    {
        name = "Weapon " + data.itemId;
        transform.parent = player.transform;
        transform.localPosition = Vector3.zero;

        id = data.itemId;
        damage = data.baseDamage * Character.Damage;
        count = data.baseCount + (int)Character.Count;
        for (int i = 0; i < GameManager.instance.poolManager.prefabs.Length; i++)
        {
            if (data.projectile == GameManager.instance.poolManager.prefabs[i])
            {
                prefabId = i;
                break;
            }
        }

        switch (id)
        {
            case 0:
                speed = 150f * Character.WeaponSpeed;
                Setup();
                break;
            default:
                speed = 1f * Character.WeaponRate;
                break;
        }

        Hands hand = player.hands[(int)data.itemType];
        hand.hand.sprite = data.hand;
        hand.gameObject.SetActive(true);

        player.BroadcastMessage("ApplyGear", SendMessageOptions.DontRequireReceiver);
    }

    void Setup()
    {
        for (int i = 0; i < count; i++)
        {
            Transform bullet;
            if (i < transform.childCount)
            {
                bullet = transform.GetChild(i);
            }
            else
            {
                bullet = GameManager.instance.poolManager.GetObject(prefabId).transform;
                bullet.parent = transform;
            }
            bullet.localPosition = Vector3.zero;
            bullet.localRotation = Quaternion.identity;
            Vector3 rotVec = Vector3.forward * 360 * i / count;
            bullet.Rotate(rotVec);
            bullet.Translate(bullet.up * 1.5f, Space.World);
            bullet.GetComponent<Bullet>().Init(damage, -100, Vector3.zero); // -100 is Infinity Per
        }
    }

    void Update()
    {
        if (!GameManager.instance.isLive) return;
        switch (id)
        {
            case 0:
                transform.Rotate(Vector3.back * speed * Time.deltaTime);
                break;
            default:
                timer += Time.deltaTime;
                if (timer > speed)
                {
                    timer = 0f;
                    Fire();
                }
                break;
        }
    }

    void Fire()
    {
        if (!player.scanner.nearestTarget) return;

        Vector3 targetPos = player.scanner.nearestTarget.transform.position;
        Vector3 direction = (targetPos - transform.position).normalized;

        Transform bullet = GameManager.instance.poolManager.GetObject(prefabId).transform;
        bullet.parent = transform;
        bullet.position = transform.position;
        bullet.rotation = Quaternion.FromToRotation(Vector3.up, direction);
        bullet.GetComponent<Bullet>().Init(damage, count, direction);

        AudioManager.instance.PlaySfx(AudioManager.Sfx.Range);
    }
}
