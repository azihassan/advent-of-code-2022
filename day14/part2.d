import std;

void main()
{
    Line[] rocks = [];
    foreach(line; stdin.byLine.map!strip)
    {
        auto parts = line.split(" -> ");

        Point previous;
        parts[0].formattedRead!"%d,%d"(previous.x, previous.y);

        foreach(part; parts[1 .. $])
        {
            Point current;
            part.formattedRead!"%d,%d"(current.x, current.y);
            rocks ~= tuple(previous, current);
            previous = current;
        }
    }
    auto simulation = Simulation(
        Point(500, 0),
        rocks,
    );
    while(!simulation.done)
    {
        simulation.nextGrain();
    }
    writeln(simulation.sand.length);
}

unittest
{
    Line[] rocks = [
        tuple(Point(498, 4), Point(498, 6)),
        tuple(Point(498, 6), Point(496, 6)),

        tuple(Point(503,4), Point(502,4)),
        tuple(Point(502,4), Point(502,9)),
        tuple(Point(502,9), Point(494,9)),
    ];

    auto simulation = Simulation(
        Point(500, 0),
        rocks,
    );

    while(!simulation.done)
    {
        simulation.nextGrain();
    }
    assert(simulation.sand.length == 93);
}

alias Line = Tuple!(Point, Point);

struct Simulation
{
    Point origin;
    bool[Point] rocks;
    bool[Point] occupied;
    bool[Point] sand;
    bool done;

    int floor;

    this(Point origin, Line[] rocks)
    {
        this.origin = origin;

        int lowest;
        foreach(line; rocks)
        {
            foreach(point; toPoints(line.expand))
            {
                occupied[point] = true;
                this.rocks[point] = true;
                lowest = max(lowest, point.y);
            }
        }

        floor = lowest + 2;
    }

    void nextGrain()
    {
        if(done)
        {
            return;
        }

        Point grain = origin;
        while(true)
        {
            Point left = grain + Point(-1, 1);
            Point right = grain + Point(1, 1);
            Point below = grain + Point(0, 1);

            if(
                below.y == floor ||
                (below in occupied && left in occupied && right in occupied)
            )
            {
                occupied[grain] = true;
                sand[grain] = true;
                done = grain == origin;
                return;
            }
            if(
                below in occupied &&
                left !in occupied
            )
            {
                grain.x--;
            }
            else if(
                below in occupied &&
                left in occupied &&
                right !in occupied
            )
            {
                grain.x++;
            }
            grain.y++;
        }
    }

    void draw()
    {
        writeln();
        Point topLeft = origin;
        Point bottomRight;
        foreach(point,_; occupied)
        {
            if(point.x < topLeft.x) topLeft.x = point.x;
            if(point.y < topLeft.y) topLeft.y = point.y;

            if(point.x > bottomRight.x) bottomRight.x = point.x;
            if(point.y > bottomRight.y) bottomRight.y = point.y;
        }

        writeln("Top left = ", topLeft);
        writeln("Bottom right = ", bottomRight);

        foreach(y; topLeft.y .. bottomRight.y + 1)
        {
            foreach(x; topLeft.x .. bottomRight.x + 1)
            {
                Point current = Point(x, y);
                if(current in rocks) write('#');
                else if(current in sand) write('o');
                else write('.');
            }
            writeln();
        }
        writeln();
    }

    private Point[] toPoints(Point start, Point end)
    in (start.x == end.x || start.y == end.y, "Diagonal lines aren't supported")
    {
        Point[] points;
        if(start.x == end.x)
        {
            int yMin = min(start.y, end.y);
            int yMax = max(start.y, end.y);
            foreach(y; yMin .. yMax + 1)
            {
                points ~= Point(start.x, y);
            }
        }
        else if(start.y == end.y)
        {
            int xMin = min(start.x, end.x);
            int xMax = max(start.x, end.x);
            foreach(x; xMin .. xMax + 1)
            {
                points ~= Point(x, start.y);
            }
        }
        return points;
    }
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
