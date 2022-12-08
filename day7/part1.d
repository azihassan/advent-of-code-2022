import std;

enum Command { LS, CD }
void main()
{
    auto root = new Tree("/", TreeType.DIRECTORY, 0, []);
    Tree[] stack = [root];
    auto command = Command.CD;
    readln(); //skip cd /
    Tree[string] directories;
    foreach(line; stdin.byLine.map!strip)
    {
        string[] parts = line.idup.split(" ");
        if(parts[0] == "$")
        {
            command = parts[1] == "cd" ? Command.CD : Command.LS;
        }

        if(command == Command.LS)
        {
            if(parts[1] == "ls")
            {
                continue;
            }

            if(parts[0] == "dir")
            {
                Tree directory = new Tree(parts[1], TreeType.DIRECTORY, 0, []);
                stack.back().addChild(directory);
                string path = stack.map!(e => e.name).chain(directory.name.only).joiner("/").to!string;
                directories[path] = directory;
            }
            else
            {
                stack.back().addChild(new Tree(parts[1], TreeType.FILE, parts[0].to!ulong, []));
            }
        }

        else if(command == Command.CD)
        {
            if(parts[2] == "/")
            {
                stack = [root];
            }
            else if(parts[2] == "..")
            {
                stack.popBack();
            }
            else
            {
                string path = stack.map!(e => e.name).chain(parts[2].only).joiner("/").to!string;
                stack ~= directories[path];
            }
        }
    }

    root.calculateSizes();
    root.findDirectoriesWithMaxSize(100000).writeln();
}

ulong findDirectoriesWithMaxSize(Tree root, ulong maxSize)
{
    ulong totalSize = 0;
    foreach(child; root.children)
    {
        if(child.type == TreeType.DIRECTORY)
        {
            if(child.size <= maxSize)
            {
                totalSize += child.size;
            }
            totalSize += child.findDirectoriesWithMaxSize(maxSize);
        }
    }
    return totalSize;
}

enum TreeType
{
    DIRECTORY, FILE
}

class Tree
{
    private:
    string name;
    TreeType type;
    ulong size;
    Tree[] children;
    Tree[string] childrenByName;

    public:
    this(string name, TreeType type, ulong size, Tree[] children)
    {
        this.name = name;
        this.type = type;
        this.size = size;
        this.children = children;
        foreach(child; children)
        {
            this.childrenByName[child.name] = child;
        }
    }

    void addChild(Tree child)
    {
        children ~= child;
        childrenByName[child.name] = child;
    }
}

void print(Tree root, ulong tab = 0)
{
    foreach(i; 0 .. tab) write("  ");
    writefln("- %s (%s) : %u", root.name, root.type, root.size);
    foreach(child; root.children)
    {
        if(child.type == TreeType.DIRECTORY)
        {
            print(child, tab + 1);
        }
        else
        {
            foreach(i; 0 .. tab + 1) write("  ");
            writefln("- %s (%s) : %u", child.name, child.type, child.size);
        }
    }
}


ulong calculateSizes(Tree root)
{
    if(root.type == TreeType.FILE)
    {
        return root.size;
    }
    foreach(child; root.children)
    {
        if(child.type == TreeType.FILE)
        {
            root.size += child.size;
        }
        else
        {
            root.size += child.calculateSizes();
        }
    }
    return root.size;
}


unittest
{
    auto tree = new Tree("/", TreeType.DIRECTORY, 0, [
        new Tree("a", TreeType.DIRECTORY, 0, [
            new Tree("e", TreeType.DIRECTORY, 0, [
                new Tree("i", TreeType.FILE, 584, [])
            ]),
            new Tree("f", TreeType.FILE, 29116, []),
            new Tree("g", TreeType.FILE, 2557, []),
            new Tree("h.lst", TreeType.FILE, 62596, [])
        ]),
        new Tree("b.txt", TreeType.FILE, 14848514, []),
        new Tree("c.dat", TreeType.FILE, 8504156, []),
        new Tree("d", TreeType.DIRECTORY, 0, [
            new Tree("j", TreeType.FILE, 4060174, []),
            new Tree("d.log", TreeType.FILE, 8033020, []),
            new Tree("d.ext", TreeType.FILE, 5626152, []),
            new Tree("k", TreeType.FILE, 7214296, [])
        ])
    ]);

    tree.calculateSizes();
    assert(tree.size == 48381165);
    assert(tree.childrenByName["a"].size == 94853);
    assert(tree.childrenByName["a"].childrenByName["e"].size == 584);
    assert(tree.childrenByName["d"].size == 24933642);
    tree.print();
}

