import std;

void main()
{
    string common;
    foreach(group; stdin.byLineCopy.map!strip.chunks(3).map!array)
    {
        char error = findCommonItem(group[0], group[1], group[2]);
        if(error != ' ')
        {
            common ~= error;
        }
    }
    common.prioritize().writeln();
}

char findCommonItem(string a, string b, string c)
{
    bool[char] common;
    bool[char] set;
    foreach(item; a)
    {
        set[item] = true;
    }
    foreach(item; b)
    {
        if(item in set)
        {
            common[item] = true;
        }
    }
    foreach(item; c)
    {
        if(item in common)
        {
            return item;
        }
    }
    return ' ';
}

unittest
{
    static assert(findCommonItem("vJrwpWtwJgWrhcsFMMfFFhFp", "jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL", "PmmdzqPrVvPwwTWBwg") == 'r');
    static assert(findCommonItem("wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn", "ttgJtRGJQctTZtZT", "CrZsJsPPZsGzwwsLwLmpwMDw") == 'Z');
}

ulong prioritize(string types)
{
    return types.map!(c => 'a' <= c && c <= 'z' ? c - 'a' + 1 : c - 'A' + 27).sum();
}

unittest
{
    static assert("rZ".prioritize == 70);
}
