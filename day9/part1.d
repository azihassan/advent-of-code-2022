import std;

void main()
{
    stdin.byLineCopy.countVisited().writeln();
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

    void opOpAssign(string op)(Point other) if(op == "+")
    {
        x += other.x;
        y += other.y;
    }

    Point unary() const
    {
        return Point(
            x == 0 ? 0 : x / x.abs(),
            y == 0 ? 0 : y / y.abs()
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
}

ulong countVisited(R)(R moves) if(isInputRange!R && is(ElementType!R == string))//(string[] moves)
{
    Point head, tail;
    bool[string] visited;
    foreach(move; moves)
    {
        char direction;
        int steps;
        move.formattedRead!"%c %d"(direction, steps);
        foreach(i; 0 .. steps)
        {
            simulateStep(head, tail, direction);
            visited[tail.to!string] = true;
        }
    }
    return visited.length;
}

void simulateStep(ref Point head, ref Point tail, char direction)
{
    Point[char] directions = [
        'U': Point(0, -1),
        'R': Point(+1, 0),
        'D': Point(0, +1),
        'L': Point(-1, 0)
    ];

    head += directions[direction];
    Point difference = head - tail;
    if(difference.x.abs() > 1 || difference.y.abs() > 1)
    {
        tail += difference.unary();
    }
}

unittest
{
    string[] moves = [
        "R 4",
        "U 4",
        "L 3",
        "D 1",
        "R 4",
        "D 1",
        "L 5",
        "R 2"
    ];
    assert(moves.countVisited() == 13L);
}
