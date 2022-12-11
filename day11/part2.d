import std;

void main()
{
    enum mod = 3 * 13 * 2 * 11 * 5 * 17 * 19 * 7;
    Monkey[] monkeys = [
        new Monkey(
            [64UL, 89UL, 65UL, 95UL],
            old => (old * 7) % mod,
            item => item % 3 == 0 ?  4UL : 1UL
        ),

        new Monkey(
            [76UL, 66UL, 74UL, 87UL, 70UL, 56UL, 51UL, 66UL],
            old => (old + 5) % mod,
            item => item % 13 == 0 ? 7UL : 3UL
        ),

        new Monkey(
            [91UL, 60UL, 63UL],
            old => (old * old) % mod,
            item => item % 2 == 0 ? 6UL : 5UL
        ),

        new Monkey(
            [92UL, 61UL, 79UL, 97UL, 79UL],
            old => (old + 6) % mod,
            item => item % 11 == 0 ? 2UL : 6UL
        ),

        new Monkey(
            [93UL, 54UL],
            old => (old * 11) % mod,
            item => item % 5 == 0 ? 1UL : 7UL
        ),

        new Monkey(
            [60UL, 79UL, 92UL, 69UL, 88UL, 82UL, 70UL],
            old => (old + 8) % mod,
            item => item % 17 == 0 ?  4UL : 0UL
        ),

        new Monkey(
            [64UL, 57UL, 73UL, 89UL, 55UL, 53UL],
            old => (old + 1) % mod,
            item => item % 19 == 0 ?  0UL : 5UL
        ),

        new Monkey(
            [62UL],
            old => (old + 4) % mod,
            item => item % 7 == 0 ?  3UL : 2UL
        )
    ];

    foreach(round; 0 .. 10000)
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
            [79UL, 98UL],
            old => (old * 19) % (23 * 19 * 13 * 17),
            item => item % 23 == 0 ? 2UL : 3UL
        ),
        new Monkey(
            [54UL, 65UL, 75UL, 74UL],
            old => (old + 6) % (23 * 19 * 13 * 17),
            item => item % 19 == 0 ? 2UL : 0UL
        ),
        new Monkey(
            [79UL, 60UL, 97UL],
            old => (old * old) % (23 * 19 * 13 * 17),
            item => item % 13 == 0 ? 1UL : 3UL
        ),
        new Monkey(
            [74UL],
            old => (old + 3) % (23 * 19 * 13 * 17),
            item => item % 17 == 0 ? 0UL : 1UL
        ),
    ];

    foreach(round; 0 .. 20)
    {
        foreach(i, monkey; monkeys)
        {
            monkey.inspectItems(monkeys);
        }
    }


    assert(monkeys[0].inspectedItemCount == 99);
    assert(monkeys[1].inspectedItemCount == 97);
    assert(monkeys[2].inspectedItemCount == 8);
    assert(monkeys[3].inspectedItemCount == 103);

    foreach(round; 20 .. 1000)
    {
        foreach(i, monkey; monkeys)
        {
            monkey.inspectItems(monkeys);
        }
    }

    assert(monkeys[0].inspectedItemCount == 5204);
    assert(monkeys[1].inspectedItemCount == 4792);
    assert(monkeys[2].inspectedItemCount == 199);
    assert(monkeys[3].inspectedItemCount == 5192);
}
