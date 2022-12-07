import std;

void main()
{
    stdin.readln().strip().findFirstMarker().writeln();
}

ulong findFirstMarker(string input)
{
    ulong start = 0;
    ulong end = 4;

    while(end < input.length)
    {
        if(input[start .. end].isUnique())
        {
            return end;
        }
        start++;
        end++;
    }
    return -1;
}

bool isUnique(string input)
{
    bool[char] unique;
    foreach(char c; input)
    {
        if(c in unique)
        {
            return false;
        }
        unique[c] = true;
    }
    return true;
}

unittest
{
    static assert("mjqjpqmgbljsphdztnvjfqwrcgsmlb".findFirstMarker() == 7);
    static assert("bvwbjplbgvbhsrlpgdmjqwftvncz".findFirstMarker() == 5);
    static assert("nppdvjthqldpwncqszvftbrmjlhg".findFirstMarker() == 6);
    static assert("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg".findFirstMarker() == 10);
    static assert("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw".findFirstMarker() == 11);
}
