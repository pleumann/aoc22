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
  Assign(T, 'INPUT   .TXT');
  Reset(T);

  ReadLine(T, S);
  Size := Length(S);

  for I := 0 to Size - 1 do
  begin
    (* WriteLn(S); *)
    for J := 0 to Size - 1 do
    begin
      Map[I][J] := Ord(S[J + 1]) - 48;
      Visible[I][J] := False;
    end;
    ReadLine(T, S);
  end;
        
  Close(T);
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

procedure Paint(Max: Integer);
var
  I: Integer;
begin
  for I := 0 to 9 do
  begin
    GotoXY(1, 12 - I);
    Write(#27'N');
  end;

  for I := 0 to Max do
  begin
    GotoXY(80, 12 - I);
    Write('#');
  end;
end;

procedure Part1;
var
  I, J, Max: Integer;
begin
  WriteLn('--- Part 1 ---');
  WriteLn;

  NumVisible := 0;

  (* West view *)
  for I := 0 to Size - 1 do
  begin
    Max := -1;
    for J := 0 to Size - 1 do
    begin
      Max := CheckVisibility(I, J, Max);
      if Max = 9 then Break;
    end;

    Paint(Max);
  end;

  (* East view *)
  for I := 0 to Size - 1 do
  begin
    Max := -1;
    for J := Size - 1 downto 0 do
    begin
      Max := CheckVisibility(I, J, Max);
      if Max = 9 then Break;
    end;

    Paint(Max);
  end;
        
  (* North view *)
  for J := 0 to Size - 1 do
  begin
    Max := -1;
    for I := 0 to Size - 1 do
    begin
      Max := CheckVisibility(I, J, Max);
      if Max = 9 then Break;
    end;

    Paint(Max);
  end;

  (* South view *)
  for J := 0 to Size - 1 do
  begin
    Max := -1;
    for I := Size - 1 downto 0 do
    begin
      Max := CheckVisibility(I, J, Max);
      if Max = 9 then Break;
    end;
    Paint(Max);
  end;
        
  WriteLn;
  WriteLn;
  WriteLn('Visible trees: ', NumVisible:8);
  WriteLn;
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

procedure Part2;
var
  I, J: Integer;
  K, Best: Real;
begin
  WriteLn('--- Part 2 ---');
  WriteLn;

  Best := 0;

  for I := 0 to Size - 1 do
  begin
    Write('.');

    for J := 0 to Size - 1 do
    begin
      K := Score(I, J);
      if K > Best then Best := K;
    end;
  end;

  WriteLn;
  WriteLn;
  WriteLn('Scenic score : ', Best:8:0);
  WriteLn;
end;

begin
  ClrScr;

  WriteLn;
  WriteLn('*** AoC 2022.08 Treetop Tree House ***');
  WriteLn;

  Load;
  Part1;
  Part2;
end.
