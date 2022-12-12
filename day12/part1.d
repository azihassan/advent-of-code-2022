import std;

void main()
{
    char[][] map = stdin.byLine.map!strip.map!dup.array;
    Point start, end;
    foreach(y; 0 .. map.length)
    {
        foreach(x; 0 .. map[y].length)
        {
            Point current = Point(cast(int) x, cast(int) y);
            if(map.cellAt(current) == 'S')
            {
                start = current;
            }
            else if(map.cellAt(current) == 'E')
            {
                end = current;
                map[y][x] = 'z';
            }
        }
    }
    map.findMinimalDistance(start, end).writeln();
}

ulong findMinimalDistance(char[][] map, Point start, Point end)
{
    bool[Point] visited;
    Point[Point] parents;
    DList!Point queue;
    queue ~= start;
    visited[start] = true;
    while(!queue.empty())
    {
        Point current = queue.front();
        queue.removeFront();
        if(current == end)
        {
            auto path = parents.buildPath(end);
            return path.length - 1;
        }

        foreach(neighbor; map.neighbors(current))
        {
            if((neighbor in visited) == null)
            {
                visited[neighbor] = true;
                queue ~= neighbor;
                parents[neighbor] = current;
            }
        }
    }
    return 0;
}

Point[] buildPath(Point[Point] parents, Point end)
{
    Point[] sequential = [end];
    Point current = end;
    while(current in parents)
    {
        current = parents[current];
        sequential ~= current;
    }
    sequential.reverse();
    return sequential;
}

void print(char[][] map, Point[] path)
{
    path.map!(p => p.to!string ~ "(" ~ map.cellAt(p) ~ ")").joiner(", ").writeln();
    writeln("Total steps : ", path.length);
}

Point[] neighbors(char[][] map, Point cell)
{
    Point[] adjescent = [
        Point(-1, 0),
        Point(+1, 0),
        Point(0, -1),
        Point(0, +1),
    ];
    Point[] neighbors;
    foreach(delta; adjescent)
    {
        Point neighbor = delta + cell;
        if(!map.withinBounds(neighbor))
        {
            continue;
        }
        int difference = map.cellAt(cell) - map.cellAt(neighbor);
        if(difference >= -1 || map.cellAt(cell) == 'S')
        {
            neighbors ~= neighbor;
        }
    }
    return neighbors;
}

char cellAt(char[][] map, Point cell)
{
    return map[cell.y][cell.x];
}

bool withinBounds(char[][] map, Point cell)
{
    return 0 <= cell.x && cell.x < map[0].length && 0 <= cell.y && cell.y < map.length;
}

unittest
{
    char[][] map = [
        "Sabqponm".dup,
        "abcryxxl".dup,
        "accszzxk".dup,
        "acctuvwj".dup,
        "abdefghi".dup
    ];

    ulong result = map.findMinimalDistance(Point(0, 0), Point(5, 2));
    assert(result == 31);
}

struct Point
{
    int x;
    int y;

    Point opBinary(string op)(Point other) const if(op == "+" || op == "-")
    {
        return Point(
            mixin("x " ~ op ~ " other.x"),
            mixin("y " ~ op ~ " other.y")
        );
    }

    bool opEquals(const Point other) const
    {
        return other.x == x && other.y == y;
    }

    string toString() const
    {
        return format!"[%d, %d]"(x, y);
    }

    size_t toHash() const
    {
        return toString().hashOf();
    }
}

