import std;

void main()
{
    char[char] rules = [
        'S': 'R',
        'R': 'P',
        'P': 'S',
    ];

    char[char] scores = [
        'R': 1,
        'P': 2,
        'S': 3,
    ];

    char[char] mapping = [
        'A': 'R',
        'B': 'P',
        'C': 'S',
        'X': 'R',
        'Y': 'P',
        'Z': 'S',
    ];

    int score;
    foreach(line; stdin.byLine)
    {
        char opponent, player;
        line.formattedRead!"%c %c"(opponent, player);

        opponent = mapping[opponent];
        player = mapping[player];

        if(opponent == player)
        {
            score += scores[player];
            score += 3;
        }
        else if(rules[opponent] == player)
        {
            score += scores[player];
            score += 6;
        }
        else
        {
            score += scores[player];
        }
    }
    score.writeln();
}
