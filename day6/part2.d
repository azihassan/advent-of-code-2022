import std;

void main()
{
    stdin.readln().strip().findFirstMarker().writeln();
}

ulong findFirstMarker(string input)
{
    ulong start = 0;
    ulong end = 1;
    bool[char] unique;

    unique[input[start]] = true;

    while(end < input.length)
    {
        writeln(input[start .. end]);
        writeln(input);
        writeln();
        if(input[end] in unique && end - start == 14)
        {
            return end;
        }

        unique[input[end]] = true;
        end++;

        if(input[start] == input[end])
        {
            unique.remove(input[start]);
            start++;
        }
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
    writeln("mjqjpqmgbljsphdztnvjfqwrcgsmlb".findFirstMarker());
    assert("mjqjpqmgbljsphdztnvjfqwrcgsmlb".findFirstMarker() == 19);
    assert("bvwbjplbgvbhsrlpgdmjqwftvncz".findFirstMarker() == 23);
    assert("nppdvjthqldpwncqszvftbrmjlhg".findFirstMarker() == 23);
    assert("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg".findFirstMarker() == 29);
    assert("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw".findFirstMarker() == 26);
}
