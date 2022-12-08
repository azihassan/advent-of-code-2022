import std;

void main()
{
    uint[][] grid = stdin
        .byLine
        .map!strip
        .map!(line => line.map!(c => c - '0').array)
        .array;
    grid.findOptimalTree().writeln();
}

ulong findOptimalTree(uint[][] grid)
{
    ulong score;
    foreach(row; 0 .. grid.length)
    {
        foreach(column; 0 .. grid[row].length)
        {
            score = max(score, grid.calculateScore(row, column));
        }
    }
    return score;
}

ulong calculateRowScore(R)(uint[][] grid, uint tree, ulong row, R columns) if(isInputRange!R)
{
    uint distance;
    foreach(c; columns)
    {
        uint current = grid[row][c];
        distance++;
        if(current >= tree)
        {
            break;
        }
    }
    return distance;
}

ulong calculateColumnScore(R)(uint[][] grid, uint tree, R rows, ulong column) if(isInputRange!R)
{
    uint distance;
    foreach(r; rows)
    {
        uint current = grid[r][column];
        distance++;
        if(current >= tree)
        {
            break;
        }
    }
    return distance;
}

ulong calculateScore(uint[][] grid, ulong row, ulong column)
{
    ulong score = 1;
    uint tree = grid[row][column];
    score *= grid.calculateColumnScore(tree, iota(0, row).retro(), column);
    score *= grid.calculateColumnScore(tree, iota(row + 1, grid.length), column);
    score *= grid.calculateRowScore(tree, row, iota(0, column).retro());
    score *= grid.calculateRowScore(tree, row, iota(column + 1, grid[0].length));
    return score;
}

unittest
{
    enum uint[][] grid = [
        "30373".map!(d => d - '0').array,
        "25512".map!(d => d - '0').array,
        "65332".map!(d => d - '0').array,
        "33549".map!(d => d - '0').array,
        "35390".map!(d => d - '0').array
    ];

    static assert(grid.calculateScore(1, 2) == 4);
    static assert(grid.calculateScore(3, 2) == 8);
    static assert(grid.findOptimalTree() == 8);
}
