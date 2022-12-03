import std;

void main()
{
    string common;
    foreach(line; stdin.byLineCopy.map!strip)
    {
        string left = line[0 .. $ / 2];
        string right = line[$ / 2 .. $];
        char error = findCommonItem(left, right);
        if(error != ' ')
        {
            common ~= error;
        }
    }
    common.writeln();
    common.prioritize().writeln();
}

char findCommonItem(string left, string right)
{
    bool[char] set;
    foreach(c; left)
    {
        set[c] = true;
    }
    foreach(c; right)
    {
        if(c in set)
        {
            return c;
        }
    }
    return ' ';
}

unittest
{
    static assert(findCommonItem("vJrwpWtwJgWr", "hcsFMMfFFhFp") == 'p');
    static assert(findCommonItem("abc", "def") == ' ');
}

ulong prioritize(string types)
{
    return types.map!(c => 'a' <= c && c <= 'z' ? c - 'a' + 1 : c - 'A' + 27).sum();
}

unittest
{
    static assert("Z".prioritize == 52);
    static assert("pLPvts".prioritize == 157);
}
