import std;

void main()
{
    int maxSum = 0;
    int currentSum = 0;
    foreach(line; stdin.byLine.map!strip)
    {
        if(line.strip == "")
        {
            maxSum = max(maxSum, currentSum);
            currentSum = 0;
            continue;
        }
        currentSum += line.to!int;
    }
    maxSum.writeln();
}
