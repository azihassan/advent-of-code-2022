import std;

void main()
{
    stdin.byLineCopy.countVisited(10).writeln();
}

class Point
{
    public:
    int x;
    int y;

    this(int x, int y)
    {
        this.x = x;
        this.y = y;
    }

    Point opBinary(string op)(Point other) const if(op == "+" || op == "-")
    {
        return new Point(
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
        return new Point(
            x == 0 ? 0 : x / x.abs(),
            y == 0 ? 0 : y / y.abs()
        );
    }

    bool opEquals(const Point other) const
    {
        return other.x == x && other.y == y;
    }

    override string toString() const
    {
        return format!"[%d, %d]"(x, y);
    }
}

ulong countVisited(R)(R moves, ulong maxLength) if(isInputRange!R && is(ElementType!R == string))
{
    Point[] rope;
    rope.reserve(maxLength);
    foreach(i; 0 .. maxLength)
    {
        rope ~= new Point(0, 0);
    }

    bool[string] visited;
    foreach(move; moves)
    {
        char direction;
        int steps;
        move.formattedRead!"%c %d"(direction, steps);
        foreach(i; 0 .. steps)
        {
            simulateStep(rope, direction);
            Point tail = rope[$ - 1];
            visited[tail.to!string] = true;
        }
    }
    return visited.length;
}

void simulateStep(ref Point[] rope, char direction)
{
    Point[char] directions = [
        'U': new Point(0, -1),
        'R': new Point(+1, 0),
        'D': new Point(0, +1),
        'L': new Point(-1, 0)
    ];

    Point head = rope[0];
    head += directions[direction];

    Point previous = rope[0];
    foreach(i; 1 .. rope.length)
    {
        Point current = rope[i];
        Point difference = previous - current;
        if(difference.x.abs() > 1 || difference.y.abs() > 1)
        {
            current += difference.unary();
        }
        previous = current;
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
    assert(moves.countVisited(10) == 1L);
}

unittest
{
    string[] moves = [
        "R 5",
        "U 8",
        "L 8",
        "D 3",
        "R 17",
        "D 10",
        "L 25",
        "U 20"
    ];
    assert(moves.countVisited(10) == 36L);
}
