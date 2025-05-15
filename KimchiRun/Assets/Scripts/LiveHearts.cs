using UnityEngine;
using UnityEngine.UI;

public class LiveHearts : MonoBehaviour
{
    public Sprite onHeart;
    public Sprite offHeart;
    public Image[] heartImages;

    void Update()
    {
        for (int i = 0; i < heartImages.Length; i++)
        {
            if (i < GameManager.instance.lives)
            {
                heartImages[i].sprite = onHeart;
            }
            else
            {
                heartImages[i].sprite = offHeart;
            }
        }
    }
}
