using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Game : MonoBehaviour
{
    public int width = 16;
    public int height = 16;
    public int mineCount = 32;

    private Board board;
    private Cell[,] state;

    private bool isGameOver;

    private void OnValidate()
    {
        mineCount = Mathf.Clamp(mineCount, 0, width * height);
    }
    void Awake()
    {
        board = GetComponentInChildren<Board>();
    }

    void Start()
    {
        NewGame();
    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.R))
        {
            NewGame();
        }

        if (isGameOver) return;

        if (Input.GetMouseButtonDown(1))
        {
            Flags();
        }
        else if (Input.GetMouseButtonDown(0))
        {
            Reveal();
        }
    }

    private void NewGame()
    {
        isGameOver = false;
        state = new Cell[width, height];

        GenerateCells();
        GenerateMines();
        GenerateNumbers();

        Camera.main.transform.position = new Vector3(width / 2f, height / 2f, -10f);
        board.Draw(state);
    }

    private void GenerateCells()
    {
        for (int x = 0; x < width; x++)
        {
            for (int y = 0; y < height; y++)
            {
                Cell cell = new Cell();
                cell.position = new Vector3Int(x, y, 0);
                cell.type = Cell.Type.Empty;
                state[x, y] = cell;
            }
        }
    }

    private void GenerateMines()
    {
        for (int i = 0; i < mineCount; i++)
        {
            int x = Random.Range(0, width);
            int y = Random.Range(0, height);

            while (state[x, y].type == Cell.Type.Mine)
            {
                x++;
                if (x >= width)
                {
                    x = 0;
                    y++;
                    if (y >= height) y = 0;
                }
            }

            state[x, y].type = Cell.Type.Mine;
        }
    }

    private void GenerateNumbers()
    {
        for (int x = 0; x < width; x++)
        {
            for (int y = 0; y < height; y++)
            {
                Cell cell = state[x, y];
                if (cell.type == Cell.Type.Mine) continue;

                cell.number = CountMines(x, y);
                if (cell.number > 0) cell.type = Cell.Type.Number;
                state[x, y] = cell;
            }
        }
    }

    private int CountMines(int cellX, int cellY)
    {
        int count = 0;
        for (int adjacentX = -1; adjacentX <= 1; adjacentX++)
        {
            for (int adjacentY = -1; adjacentY <= 1; adjacentY++)
            {
                if (adjacentX == 0 && adjacentY == 0) continue;
                int x = cellX + adjacentX;
                int y = cellY + adjacentY;

                if (GetCell(x, y).type == Cell.Type.Mine) count++;
            }
        }
        return count;
    }

    private void Flags()
    {
        Vector3 worldPosition = Camera.main.ScreenToWorldPoint(Input.mousePosition);
        Vector3Int cellPosition = board.tilemap.WorldToCell(worldPosition);

        Cell cell = GetCell(cellPosition.x, cellPosition.y);
        if (cell.type == Cell.Type.Invalid) return;

        cell.isFlagged = !cell.isFlagged;
        state[cellPosition.x, cellPosition.y] = cell;

        board.Draw(state);
    }

    private void Reveal()
    {
        Vector3 worldPosition = Camera.main.ScreenToWorldPoint(Input.mousePosition);
        Vector3Int cellPosition = board.tilemap.WorldToCell(worldPosition);

        Cell cell = GetCell(cellPosition.x, cellPosition.y);
        if (cell.type == Cell.Type.Invalid || cell.isRevealed || cell.isFlagged) return;

        switch (cell.type)
        {
            case Cell.Type.Mine:
                Explode(cell);
                break;
            case Cell.Type.Empty:
                Flood(cell);
                CheckWinCondition();
                break;
            default:
                cell.isRevealed = true;
                state[cellPosition.x, cellPosition.y] = cell;
                CheckWinCondition();
                break;
        }

        board.Draw(state);
    }

    private void Flood(Cell cell)
    {
        if (cell.isRevealed) return;
        if (cell.type == Cell.Type.Mine || cell.type == Cell.Type.Invalid) return;

        cell.isRevealed = true;
        state[cell.position.x, cell.position.y] = cell;

        if (cell.type == Cell.Type.Empty)
        {
            Flood(GetCell(cell.position.x - 1, cell.position.y));
            Flood(GetCell(cell.position.x + 1, cell.position.y));
            Flood(GetCell(cell.position.x, cell.position.y - 1));
            Flood(GetCell(cell.position.x, cell.position.y + 1));
        }
    }

    private void Explode(Cell cell)
    {
        isGameOver = true;
        Debug.Log("Game Over!");

        cell.isRevealed = true;
        cell.isExploded = true;
        state[cell.position.x, cell.position.y] = cell;

        for (int x = 0; x < width; x++)
        {
            for (int y = 0; y < height; y++)
            {
                cell = state[x, y];
                if (cell.type == Cell.Type.Mine)
                {
                    cell.isRevealed = true;
                    state[x, y] = cell;
                }
            }
        }
    }

    private void CheckWinCondition()
    {
        for (int x = 0; x < width; x++)
        {
            for (int y = 0; y < height; y++)
            {
                Cell cell = state[x, y];
                if (cell.type != Cell.Type.Mine && !cell.isRevealed) return;
            }
        }

        Debug.Log("You win!");
        isGameOver = true;

        for (int x = 0; x < width; x++)
        {
            for (int y = 0; y < height; y++)
            {
                Cell cell = state[x, y];
                if (cell.type == Cell.Type.Mine)
                {
                    cell.isFlagged = true;
                    state[x, y] = cell;
                }
            }
        }
    }

    private Cell GetCell(int x, int y)
    {
        if (IsValid(x, y))
        {
            return state[x, y];
        }
        return new Cell();
    }

    private bool IsValid(int x, int y)
    {
        return x >= 0 && x < width && y >= 0 && y < height;
    }
}
