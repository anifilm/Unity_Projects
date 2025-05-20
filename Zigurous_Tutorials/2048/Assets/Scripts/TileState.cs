using UnityEngine;

[CreateAssetMenu(fileName = "TileState", menuName = "2048/TileState", order = 1)]
public class TileState : ScriptableObject
{
    public int number;
    public Color backgroundColor;
    public Color textColor;
}
