import std;

void main()
{
    string[] program = stdin.byLineCopy.map!strip.array;
    auto cpu = Cpu(program);
    while(!cpu.finished)
    {
        cpu.nextCycle();
    }
    cpu.signalStrength.writeln();
}

struct Cpu
{
    string[] program;
    long[char] registers;
    ulong pc;
    ulong clock;
    long signalStrength;

    this(string[] program)
    {
        this.program = program;
        registers['x'] = 1;
    }

    bool finished() @property
    {
        return pc == program.length;
    }

    private void tick(int cycles)
    {
        while(cycles--)
        {
            clock++;
            if(clock == 20 || (clock > 20 && (clock - 20) % 40 == 0))
            {
                signalStrength += clock * registers['x'];
            }
        }
    }

    void nextCycle()
    {
        if(finished)
        {
            return;
        }

        string[] instruction = program[pc].split(" ");
        switch(instruction[0])
        {
            case "addx":
                tick(2);
                registers['x'] += instruction[1].to!long;
                pc++;
            break;
            default:
                tick(1);
                pc++;
            break;
        }

    }
}

unittest
{
    string[] input = [
        "addx 15", "addx -11", "addx 6", "addx -3", "addx 5", "addx -1", "addx -8", "addx 13",
        "addx 4", "noop", "addx -1", "addx 5", "addx -1", "addx 5", "addx -1", "addx 5",
        "addx -1", "addx 5", "addx -1", "addx -35", "addx 1", "addx 24", "addx -19", "addx 1",
        "addx 16", "addx -11", "noop", "noop", "addx 21", "addx -15", "noop", "noop",
        "addx -3", "addx 9", "addx 1", "addx -3", "addx 8", "addx 1", "addx 5", "noop",
        "noop", "noop", "noop", "noop", "addx -36", "noop", "addx 1", "addx 7",
        "noop", "noop", "noop", "addx 2", "addx 6", "noop", "noop", "noop",
        "noop", "noop", "addx 1", "noop", "noop", "addx 7", "addx 1", "noop",
        "addx -13", "addx 13", "addx 7", "noop", "addx 1", "addx -33", "noop", "noop",
        "noop", "addx 2", "noop", "noop", "noop", "addx 8", "noop", "addx -1",
        "addx 2", "addx 1", "noop", "addx 17", "addx -9", "addx 1", "addx 1", "addx -3",
        "addx 11", "noop", "noop", "addx 1", "noop", "addx 1", "noop", "noop",
        "addx -13", "addx -19", "addx 1", "addx 3", "addx 26", "addx -30", "addx 12", "addx -1",
        "addx 3", "addx 1", "noop", "noop", "noop", "addx -9", "addx 18", "addx 1",
        "addx 2", "noop", "noop", "addx 9", "noop", "noop", "noop", "addx -1",
        "addx 2", "addx -37", "addx 1", "addx 3", "noop", "addx 15", "addx -21", "addx 22",
        "addx -6", "addx 1", "noop", "addx 2", "addx 1", "noop", "addx -10", "noop",
        "noop", "addx 20", "addx 1", "addx 2", "addx 2", "addx -6", "addx -11", "noop",
        "noop", "noop"
    ];

    auto cpu = Cpu(input);
    while(!cpu.finished)
    {
        cpu.nextCycle();
    }
    assert(cpu.signalStrength == [420, 1140, 1800, 2940, 2880, 3960].sum());
}
