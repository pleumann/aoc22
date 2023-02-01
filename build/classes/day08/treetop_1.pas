program TreeTop;

{$I /Users/joerg/Projekte/pl0/lib/Files.pas}

var
  Map: array[0..99] of array[0..99] of Byte;
  Size: Integer;

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
    for J := 0 to Size - 1 do
      Map[I][J] := Ord(S[J + 1]) - 48;

    ReadLine(T, S);
  end;
        
  Close(T);
end;

function Visible(I, J: Integer): Boolean;
var
  Height, K: Integer;
  B: Boolean;
begin
  Visible := True;
  Height := Map[I][J];

  B := True;
  for K := 0 to J - 1 do
    if Map[I][K] >= Height then
    begin
      B := False;
      Break;
    end;

  if B then Exit;

  B := True;
  for K := J + 1 to Size - 1 do
    if Map[I][K] >= Height then 
    begin
      B := False;
      Break;
    end;

  if B then Exit;

  B := True;
  for K := I - 1 downto 0 do
    if Map[K][J] >= Height then
    begin
      B := False;
      Break;
    end;

  if B then Exit;

  B := True;
  for K := I + 1 to Size - 1 do
    if Map[K][J] >= Height then
    begin
      B := False;
      Break;
    end;

  Visible := B;
end;

procedure Part1;
var
  I, J, K, Max, Count: Integer;
begin
  WriteLn('--- Part 1 ---');
  WriteLn;

  Count := 0;

  for I := 0 to Size - 1 do
  begin
    Write('.');
    for J := 0 to Size - 1 do
      if Visible(I, J) then Count := Count + 1;
  end;

  WriteLn;
  WriteLn;
  WriteLn('Visible trees: ', Count:8);
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
  WriteLn;
  WriteLn('*** AoC 2022.08 Treetop Tree House ***');
  WriteLn;

  Load;
  Part1;
  Part2;
end.
