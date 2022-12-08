import std;

void main()
{
    uint[][] grid = stdin
        .byLine
        .map!strip
        .map!(line => line.map!(c => c - '0').array)
        .array;
    grid.countVisible().writeln();
}

int countVisible(uint[][] grid)
{
    int count = 0;
    count += grid.length * 2; //columns
    count += (grid[0].length - 2) * 2; //rows
    foreach(row; 1 .. grid.length - 1)
    {
        foreach(column; 1 .. grid[row].length - 1)
        {
            count += grid.isVisible(row, column);
        }
    }
    return count;
}

bool isVisible(uint[][] grid, ulong row, ulong column)
{
    uint current = grid[row][column];
    ulong width = grid[0].length;
    ulong height = grid.length;
    return grid[0 .. row].all!(line => line[column] < current)
        || grid[row + 1 .. grid.length].all!(line => line[column] < current)
        || grid[row][0 .. column].all!(tree => tree < current)
        || grid[row][column + 1 .. width].all!(tree => tree < current);
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

    static assert(grid.isVisible(1, 1));
    static assert(grid.isVisible(1, 2));
    static assert(!grid.isVisible(1, 3));
    static assert(!grid.isVisible(2, 2));
    static assert(grid.countVisible() == 21);
}
