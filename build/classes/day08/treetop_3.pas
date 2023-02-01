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
  WriteLn('--- Loading ---');
  WriteLn;

  Assign(T, 'INPUT   .TXT');
  Reset(T);

  ReadLine(T, S);
  Size := Length(S);

  for I := 0 to Size - 1 do
  begin
    Write('.');
    for J := 0 to Size - 1 do
      Map[I][J] := Ord(S[J + 1]) - 48;

    ReadLine(T, S);
  end;
        
  Close(T);

  WriteLn;
  WriteLn;
end;

procedure CheckTree(Row, Column: Integer; var Visible: Integer; var Score: Real);
var
  K, Left, Right, Top, Bottom: Integer;
begin
  K := Map[Row][Column];

  Visible := 4;

  Left := Column;
  while Left > 0 do
  begin
    Left := Left - 1;
    if Map[Row][Left] >= K then
    begin
      Visible := Visible - 1;
      Break;
    end;
  end;

  Right := Column;
  while Right < Size - 1 do
  begin
    Right := Right + 1;
    if Map[Row][Right] >= K then
    begin
      Visible := Visible - 1;
      Break;
    end;
  end;

  Top := Row;
  while Top > 0 do
  begin
    Top := Top - 1;
    if Map[Top][Column] >= K then
    begin
      Visible := Visible - 1;
      Break;
    end;
  end;

  Bottom := Row;
  while Bottom < Size - 1 do
  begin
    Bottom := Bottom + 1;
    if Map[Bottom][Column] >= K then
    begin
      Visible := Visible - 1;
      Break;
    end;
  end;

  Score := (Column - Left) * (Right - Column);
  Score := Score * (Row - Top) * (Bottom - Row);
end;

procedure Process;
var
  I, J, Trees, Visible: Integer;
  Score, Best: Real;
begin
  WriteLn('--- Processing ---');
  WriteLn;

  Trees := 0;
  Best := 0;

  for I := 0 to Size - 1 do
  begin
    Write('.');

    for J := 0 to Size - 1 do
    begin
      CheckTree(I, J, Visible, Score);
      if Visible > 0 then Trees := Trees + 1;
      if Score > Best then Best := Score;
    end;
  end;

  WriteLn;
  WriteLn;
  WriteLn('Visible trees: ', Trees:6);
  WriteLn('Scenic score : ', Best:6:0);
  WriteLn;
end;

begin
  WriteLn;
  WriteLn('*** AoC 2022.08 Treetop Tree House ***');
  WriteLn;

  Load;
  Process;
end.
