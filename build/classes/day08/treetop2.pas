program TreeTop;

{$I /Users/joerg/Projekte/pl0/lib/Files.pas}

var
  Map: array[0..99] of array[0..99] of Byte;
  Visible: array[0..99] of array[0..99] of Boolean;
  Size, NumVisible: Integer;

procedure Load;
var
  T: Text;
  S: TString;
  I, J: Integer;
begin
  GotoXY(2, 3);
  Write(#27'pInput file '#27'q');

  Assign(T, 'INPUT   .TXT');
  Reset(T);

  ReadLine(T, S);
  Size := Length(S);

  for I := 0 to Size - 1 do
  begin
    GotoXY(2 + I mod 11, 4 + I / 11);
    Write('.');
    for J := 0 to Size - 1 do
    begin
      Map[I][J] := Ord(S[J + 1]) - 48;
      Visible[I][J] := False;
    end;
    ReadLine(T, S);
  end;
        
  Close(T);

  WriteLn;
  WriteLn;
end;

function CheckVisibility(Row, Column, Max: Integer): Integer;
var
  K: Integer;
begin
  K := Map[Row][Column];

  if K > Max then
  begin
    Max := K;
    if not Visible[Row][Column] then
    begin
      Visible[Row][Column] := True;
      NumVisible := NumVisible + 1;
    end;
  end;

  CheckVisibility := Max;
end;

procedure Part1;
var
  I, J, Max: Integer;
begin
  NumVisible := 0;

  GotoXY(15, 3);
  Write(#27'pWest view  '#27'q');

  for I := 0 to Size - 1 do
  begin
    GotoXY(15 + I mod 11, 4 + I / 11);
    Write('.');

    Max := -1;
    for J := 0 to Size - 1 do
    begin
      Max := CheckVisibility(I, J, Max);
      if Max = 9 then Break;
    end;
  end;

  GotoXY(28, 3);
  Write(#27'pEast view  '#27'q');

  for I := 0 to Size - 1 do
  begin
    GotoXY(28 + I mod 11, 4 + I / 11);
    Write('.');

    Max := -1;
    for J := Size - 1 downto 0 do
    begin
      Max := CheckVisibility(I, J, Max);
      if Max = 9 then Break;
    end;
  end;
        
  GotoXY(41, 3);
  Write(#27'pNorth view '#27'q');

  for J := 0 to Size - 1 do
  begin
    GotoXY(41 + J mod 11, 4 + J / 11);

    Write('.');

    Max := -1;
    for I := 0 to Size - 1 do
    begin
      Max := CheckVisibility(I, J, Max);
      if Max = 9 then Break;
    end;
  end;

  GotoXY(54, 3);
  Write(#27'pSouth view '#27'q');

  for J := 0 to Size - 1 do
  begin
    GotoXY(54 + J mod 11, 4 + J / 11);
    Write('.');

    Max := -1;
    for I := Size - 1 downto 0 do
    begin
      Max := CheckVisibility(I, J, Max);
      if Max = 9 then Break;
    end;
  end;

  GotoXY(1, 14);
  WriteLn('Part 1: ', NumVisible, ' visible trees');
end;

function Score(Row, Column: Integer): Real;
var
  K, Left, Right, Top, Bottom: Integer;
  Score1, Score2: Real;
begin
  K := Map[Row][Column];

  Left := Column;
  while Left > 0 do
  begin
    Left := Left - 1;
    if Map[Row][Left] >= K then Break;
  end;

  Right := Column;
  while Right < Size - 1 do
  begin
    Right := Right + 1;
    if Map[Row][Right] >= K then Break;
  end;

  Top := Row;
  while Top > 0 do
  begin
    Top := Top - 1;
    if Map[Top][Column] >= K then Break;
  end;

  Bottom := Row;
  while Bottom < Size - 1 do
  begin
    Bottom := Bottom + 1;
    if Map[Bottom][Column] >= K then Break;
  end;

  Score1 := (Column - Left) * (Right - Column);
  Score2 := (Row - Top) * (Bottom - Row);
  Score := Score1 * Score2;

(*  WriteLn(Row, ' ', Column, ' ', Left, ' ', Right, ' ', Top, ' ', Bottom); *)
end;

function ScoreB(Row, Column: Integer): Real;
var
  K, Left, Right, Top, Bottom: Integer;
  Score1, Score2: Real;
begin
  K := Map[Row][Column];

  for Left := Column - 1 downto 0 do
    if Map[Row][Left] >= K then Break;

  for Right := Column + 1 to Size - 1 do
    if Map[Row][Right] >= K then Break;

  for Top := Row - 1 downto 0 do
    if Map[Top][Column] >= K then Break;

  for Bottom  := Row + 1 to Size - 1 do
    if Map[Bottom][Column] >= K then Break;

  Score1 := (Column - Left) * (Right - Column);
  Score2 := (Row - Top) * (Bottom - Row);
  ScoreB := Score1 * Score2;

(*  WriteLn(Row, ' ', Column, ' ', Left, ' ', Right, ' ', Top, ' ', Bottom); *)
end;

procedure Part2;
var
  I, J: Integer;
  K, Best: Real;
begin
  GotoXY(67, 3);
  Write(#27'pTree scores'#27'q');

  Best := 0;

  for I := 0 to Size - 1 do
  begin
    GotoXY(67 + I mod 11, 4 + I / 11);
    Write('.');

    for J := 0 to Size - 1 do
    begin
      K := ScoreB(I, J);
      if K > Best then Best := K;
    end;
  end;

  GotoXY(1, 15);
  WriteLn('Part 2: ', Best:0:0, ' scenic score');
end;

begin
  ClrScr;
  WriteLn('*** AoC 2022.08 Treetop Tree House ***');

  Load;
  Part1;
  Part2;
end.
