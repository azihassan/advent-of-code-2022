import std;

void main()
{
    JSONValue[] packets = [
        "[[2]]".parseJSON(),
        "[[6]]".parseJSON(),
    ];

    foreach(line; stdin.byLine.map!strip)
    {
        if(line == "")
        {
            continue;
        }
        packets ~= line.parseJSON();
    }

    packets.sort!inOrder;
    ulong key = 1;
    foreach(i, packet; packets)
    {
        if(packet == "[[2]]".parseJSON())
        {
            key *= (i + 1);
        }
        if(packet == "[[6]]".parseJSON())
        {
            key *= (i + 1);
        }
    }
    key.writeln();
}

int compare(JSONValue left, JSONValue right)
{
    if(left.type == JSONType.integer && right.type == JSONType.integer)
    {
        if(left.integer == right.integer)
        {
            return 0;
        }
        return left.integer < right.integer ? -1 : 1;
    }

    if(left.type == JSONType.array && right.type == JSONType.integer)
    {
        return compare(left, parseJSON("[" ~ right.integer.to!string ~ "]"));
    }

    if(left.type == JSONType.integer && right.type == JSONType.array)
    {
        return compare(parseJSON("[" ~ left.integer.to!string ~ "]"), right);
    }

    ulong length = min(left.array.length, right.array.length);
    foreach(i; 0 .. length)
    {
        if(compare(left.array[i], right.array[i]) == -1)
        {
            return -1;
        }
        if(compare(left.array[i], right.array[i]) == 1)
        {
            return 1;
        }
    }

    if(left.array.length == right.array.length)
    {
        return 0;
    }
    return left.array.length < right.array.length ? -1 : 1;
}

bool inOrder(JSONValue left, JSONValue right)
{
    return left.compare(right) == -1;
}

unittest
{
    assert(inOrder("[1, 1, 3, 1, 1]".parseJSON(), "[1, 1, 5, 1, 1]".parseJSON()));
    assert(inOrder("[[1], [2, 3, 4]]".parseJSON(), "[[1], 4]".parseJSON()));
    assert(!inOrder("[9]".parseJSON(), "[[8, 7, 6]]".parseJSON()));
    assert(inOrder("[[4, 4], 4, 4]".parseJSON(), "[[4, 4], 4, 4, 4]".parseJSON()));
    assert(!inOrder("[7, 7, 7, 7]".parseJSON(), "[7, 7, 7]".parseJSON()));
    assert(inOrder("[]".parseJSON(), "[3]".parseJSON()));
    assert(!inOrder("[[[]]]".parseJSON(), "[[]]".parseJSON()));
    assert(!inOrder("[1, [2, [3, [4, [5, 6, 7]]]], 8, 9]".parseJSON(), "[1, [2, [3, [4, [5, 6, 0]]]], 8, 9]".parseJSON()));
}

unittest
{
    JSONValue[] packets = [
        "[1,1,3,1,1]".parseJSON(),
        "[1,1,5,1,1]".parseJSON(),
        "[[1],[2,3,4]]".parseJSON(),
        "[[1],4]".parseJSON(),
        "[9]".parseJSON(),
        "[[8,7,6]]".parseJSON(),
        "[[4,4],4,4]".parseJSON(),
        "[[4,4],4,4,4]".parseJSON(),
        "[7,7,7,7]".parseJSON(),
        "[7,7,7]".parseJSON(),
        "[]".parseJSON(),
        "[3]".parseJSON(),
        "[[[]]]".parseJSON(),
        "[[]]".parseJSON(),
        "[1,[2,[3,[4,[5,6,7]]]],8,9]".parseJSON(),
        "[1,[2,[3,[4,[5,6,0]]]],8,9]".parseJSON(),
        "[[2]]".parseJSON(),
        "[[6]]".parseJSON(),
    ];
    packets.sort!(inOrder);
    assert(packets == [
        "[]".parseJSON(),
        "[[]]".parseJSON(),
        "[[[]]]".parseJSON(),
        "[1,1,3,1,1]".parseJSON(),
        "[1,1,5,1,1]".parseJSON(),
        "[[1],[2,3,4]]".parseJSON(),
        "[1,[2,[3,[4,[5,6,0]]]],8,9]".parseJSON(),
        "[1,[2,[3,[4,[5,6,7]]]],8,9]".parseJSON(),
        "[[1],4]".parseJSON(),
        "[[2]]".parseJSON(),
        "[3]".parseJSON(),
        "[[4,4],4,4]".parseJSON(),
        "[[4,4],4,4,4]".parseJSON(),
        "[[6]]".parseJSON(),
        "[7,7,7]".parseJSON(),
        "[7,7,7,7]".parseJSON(),
        "[[8,7,6]]".parseJSON(),
        "[9]".parseJSON(),
    ]);
}
