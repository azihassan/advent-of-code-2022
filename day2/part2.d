import std;

enum Outcome: char
{
    WIN = 'Z', LOSS = 'X', DRAW = 'Y'
}

void main()
{
    char[char] winningMoves = [
        'S': 'R',
        'R': 'P',
        'P': 'S',
    ];

    char[char] losingMoves = [
        'R': 'S',
        'P': 'R',
        'S': 'P'
    ];

    char[char] moveScores = [
        'R': 1,
        'P': 2,
        'S': 3,
    ];

    char[Outcome] outcomeScores = [
        Outcome.WIN: 6,
        Outcome.DRAW: 3,
        Outcome.LOSS: 0,
    ];

    char[char] mapping = [
        'A': 'R',
        'B': 'P',
        'C': 'S',
    ];

    int score;
    foreach(line; stdin.byLine)
    {
        char opponent, outcome;
        line.formattedRead!"%c %c"(opponent, outcome);

        opponent = mapping[opponent];

        score += outcomeScores[outcome.to!Outcome];
        final switch(outcome.to!Outcome) with(Outcome)
        {
            case DRAW: //loss
                char move = opponent;
                score += moveScores[move];
            break;

            case LOSS: //draw
                char move = losingMoves[opponent];
                score += moveScores[move];
            break;

            case WIN: //win
                char move = winningMoves[opponent];
                score += moveScores[move];
            break;
        }
    }
    score.writeln();
}
