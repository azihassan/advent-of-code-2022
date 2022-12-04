import std;

alias Range = Tuple!(int, int);
void main()
{
    int counter = 0;
    foreach(line; stdin.byLine)
    {
        Range left, right;
        line.formattedRead!"%d-%d,%d-%d"(left[0], left[1], right[0], right[1]);
        counter += left.contains(right) || right.contains(left);
    }
    counter.writeln();
}

bool contains(Range a, Range b)
{
    return a[0] <= b[0] && b[1] <= a[1];
}

unittest
{
    static assert(!tuple(2, 4).contains(tuple(4, 6)));
    static assert(!tuple(2, 3).contains(tuple(4, 5)));
    static assert(!tuple(5, 7).contains(tuple(7, 9)));
    static assert(tuple(2, 8).contains(tuple(3, 7)));
    static assert(tuple(4, 6).contains(tuple(6, 6)));
    static assert(!tuple(2, 6).contains(tuple(4, 8)));
}
