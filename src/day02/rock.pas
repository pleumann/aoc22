program Rock;

{$I /Users/joerg/Projekte/pl0/lib/files.pas}

const
  AsciiArt: array[1..15] of TString = (
    '             ___,@                                                    ',
    '            /  <                                                      ',
    '       ,_  /    \  _,                                ______           ',
    '        \\/______\//    ________      ________      //\\\\\\          ',
    ',____.  |; (e  e) ;|   |        |    |        |    (; O  O ;)         ',
    ' \___ \ \/\   7  /\/   |Rock    |    |Rock    |     \   7  /          ',
    '     \/\   \"=="/      |Paper   |    |Paper   |      \"=="/           ',
    '      \ \___)--(_______|Scissors|    |Scissors|_______)--(_____       ',
    '       \___  ()  _____/|________|    |________|\_____      ___ \      ',
    '          /  ()  \    "----"              "----"    |      |  \ \     ',
    '         /   ()   \                                 |======|   \/\___ ',
    '        /-.______.-\                                |_ __ _|    \ ___\',
    '      _    |_||_|    _                               |_||_|      """""',
    '     (@____) || (____@)                            __| || |__         ',
    '      \______||______/                            /____||____\        '
  );

function Play1(Them, Us: Char): Integer;
begin
  case Them of
    'A': case Us of 
           'X': Play1 := 4;
           'Y': Play1 := 8;
           'Z': Play1 := 3;
         end;
    'B': case Us of
           'X': Play1 := 1;
           'Y': Play1 := 5;
           'Z': Play1 := 9;
         end;
    'C': case Us of
           'X': Play1 := 7;
           'Y': Play1 := 2;
           'Z': Play1 := 6;
         end;
  end;           
end;

function Play2(Them, Us: Char): Integer;
begin
  case Them of
    'A': case Us of
           'X': Play2 := 3;
           'Y': Play2 := 4;
           'Z': Play2 := 8;
         end;
    'B': case Us of
           'X': Play2 := 1;
           'Y': Play2 := 5;
           'Z': Play2 := 9;
         end;
    'C': case Us of
           'X': Play2 := 2;
           'Y': Play2 := 6;
           'Z': Play2 := 7;
         end;
  end;           
end;

procedure Show(Column: Integer; Move: Char);
begin
  GotoXY(Column, 8);
  if (Move = 'A') or (Move = 'X') then
    Write(#27'pRock    '#27'q')
  else
    Write('Rock    ');

  GotoXY(Column, 9);
  if (Move = 'B') or (Move = 'Y') then
    Write(#27'pPaper   '#27'q')
  else
    Write('Paper   ');

  GotoXY(Column, 10);
  if (Move = 'C') or (Move = 'Z') then
    WriteLn(#27'pScissors'#27'q')
  else
    WriteLn('Scissors');
end;

procedure Solve;
var
  T: Text;
  S: TString;
  Them, Us: Char;
  Part1, Part2, Round: Integer;
begin
  Round := 0;

  Part1 := 0;
  Part2 := 0;

  Assign(T, 'INPUT   .TXT');
  Reset(T);

  while not IsEof(T) do
  begin
    ReadLine(T, S);

    GotoXY(34,4);

    Round := Round + 1;
    Write('Round : ', Round:6);

    Them := S[1];
    Show(30, Them);

    Us := S[3];
    Show(44, Us);

    Part1 := Part1 + Play1(Them, Us);
    Part2 := Part2 + Play2(Them, Us);

    GotoXY(34, 15);
    Write('Part 1: ', Part1:6);
    GotoXY(34, 16);
    Write('Part 2: ', Part2:6);
  end;

  Close(T);
end;

var
  I: Integer;

begin
  Write(#27'f');

  ClrScr;
  GotoXY(21, 1);
  WriteLn('*** AoC 2022.02 Rock Paper Scissors ***');

  GotoXY(1, 3);
  for I := 1 to 15 do
    WriteLn('     ', AsciiArt[I]);

  Solve;

  GotoXY(1, 18);
  Write(#27'e');
end.

