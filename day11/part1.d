import std;

void main()
{
    Monkey[] monkeys = [
        new Monkey(
            [64, 89, 65, 95],
            old => old * 7,
            item => item % 3 == 0 ?  4 : 1
        ),

        new Monkey(
            [76, 66, 74, 87, 70, 56, 51, 66],
            old => old + 5,
            item => item % 13 == 0 ?  7 : 3
        ),

        new Monkey(
            [91, 60, 63],
            old => old * old,
            item => item % 2 == 0 ?  6 : 5
        ),

        new Monkey(
            [92, 61, 79, 97, 79],
            old => old + 6,
            item => item % 11 == 0 ?  2 : 6
        ),

        new Monkey(
            [93, 54],
            old => old * 11,
            item => item % 5 == 0 ?  1 : 7
        ),

        new Monkey(
            [60, 79, 92, 69, 88, 82, 70],
            old => old + 8,
            item => item % 17 == 0 ?  4 : 0
        ),

        new Monkey(
            [64, 57, 73, 89, 55, 53],
            old => old + 1,
            item => item % 19 == 0 ?  0 : 5
        ),

        new Monkey(
            [62],
            old => old + 4,
            item => item % 7 == 0 ?  3 : 2
        )
    ];

    foreach(round; 0 .. 20)
    {
        foreach(i, monkey; monkeys)
        {
            monkey.inspectItems(monkeys);
        }
    }

    monkeys.sort!"a.inspectedItemCount > b.inspectedItemCount";
    writeln(monkeys[0].inspectedItemCount * monkeys[1].inspectedItemCount);
}

class Monkey
{
    ulong inspectedItemCount;

    public:
    ulong[] items;
    ulong function(ulong item) operation;
    ulong function(ulong item) test;

    this(
        ulong[] items,
        ulong function(ulong item) operation,
        ulong function(ulong item) test
    )
    {
        this.items = items;
        this.operation = operation;
        this.test = test;
    }

    void inspectItems(Monkey[] monkeys)
    {
        foreach(item; items)
        {
            item = operation(item);
            item = cast(ulong) round(item / 3);
            monkeys[test(item)].items ~= item;
            inspectedItemCount++;
        }
        items = [];
    }

    override string toString() const
    {
        return items.map!(to!string).joiner(", ").to!string;
    }
}

unittest
{
    auto monkeys = [
        new Monkey(
            [79, 98],
            old => old * 19,
            item => item % 23 == 0 ? 2 : 3
        ),
        new Monkey(
            [54, 65, 75, 74],
            old => old + 6,
            item => item % 19 == 0 ? 2 : 0
        ),
        new Monkey(
            [79, 60, 97],
            old => old * old,
            item => item % 13 == 0 ? 1 : 3
        ),
        new Monkey(
            [74],
            old => old + 3,
            item => item % 17 == 0 ? 0 : 1
        ),
    ];

    foreach(round; 0 .. 20)
    {
        foreach(i, monkey; monkeys)
        {
            monkey.inspectItems(monkeys);
        }
    }

    monkeys.sort!"a.inspectedItemCount > b.inspectedItemCount";
    assert(monkeys[0].inspectedItemCount * monkeys[1].inspectedItemCount == 10605);
}
