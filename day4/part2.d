import std;

alias Range = Tuple!(int, int);
void main()
{
    int counter = 0;
    foreach(line; stdin.byLine)
    {
        Range left, right;
        line.formattedRead!"%d-%d,%d-%d"(left[0], left[1], right[0], right[1]);
        counter += overlap(left, right);
    }
    counter.writeln();
}

bool overlap(Range a, Range b)
{
    if(a[0] <= b[0] && b[0] <= a[1]) return true;
    if(b[0] <= a[0] && a[0] <= b[1]) return true;
    return false;
}

unittest
{
    static assert(tuple(5, 7).overlap(tuple(7, 9)));
    static assert(tuple(2, 8).overlap(tuple(3, 7)));
    static assert(tuple(6, 6).overlap(tuple(4, 6)));
    static assert(tuple(2, 6).overlap(tuple(4, 8)));

    static assert(!tuple(2, 4).overlap(tuple(6, 8)));
    static assert(!tuple(2, 3).overlap(tuple(4, 5)));
}
