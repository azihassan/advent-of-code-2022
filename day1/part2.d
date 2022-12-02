import std;

void main()
{
    auto heap = BinaryHeap!(int[], "a > b")([], 0);
    int currentSum;
    foreach(line; stdin.byLine.map!strip)
    {
        if(line != "")
        {
            currentSum += line.to!int;
            continue;
        }

        heap.insert(currentSum);
        while(heap.length > 3)
        {
            heap.removeFront();
        }
        currentSum = 0;
    }
    heap.sum.writeln();
}
