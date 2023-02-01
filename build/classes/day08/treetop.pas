program TreeTop;

{$I /Users/joerg/Projekte/pl0/lib/Files.pas}

var
  Map: array[0..99] of array[0..99] of Char;
  Size: Integer;

procedure Load;
var
  T: Text;
  S: TString;
  I, J: Integer;
begin
  WriteLn('           '#27'p    Loading     '#27'q');
  WriteLn;

  Assign(T, 'INPUT   .TXT');
  Reset(T);

  ReadLine(T, S);
  Size := Length(S);

  for I := 0 to Size - 1 do
  begin
    Write('.');
    if I mod 33 = 32 then WriteLn((I + 1) * 100 / Size:4, '%');
    for J := 0 to Size - 1 do
      Map[I][J] := S[J + 1];

    ReadLine(T, S);
  end;
        
  Close(T);

  WriteLn;
end;

procedure CheckTree(Row, Column: Integer; var Visible: Integer; var Score: Real);
var
  Left, Right, Top, Bottom: Integer;
  Height: Char;
begin
  Height := Map[Row][Column];

  Visible := 4;

  for Left := Column - 1 downto 0 do
  begin
    if Map[Row][Left] >= Height then
    begin
      Visible := Visible - 1;
      Break;
    end;
  end;

  for Right := Column + 1 to Size - 1 do
  begin
    if Map[Row][Right] >= Height then
    begin
      Visible := Visible - 1;
      Break;
    end;
  end;

  for Top := Row - 1 downto 0 do
  begin
    if Map[Top][Column] >= Height then
    begin
      Visible := Visible - 1;
      Break;
    end;
  end;

  for Bottom := Row + 1 to Size - 1 do
  begin
    if Map[Bottom][Column] >= Height then
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
  WriteLn('           '#27'p   Processing   '#27'q');
  WriteLn;

  Trees := 0;
  Best := 0;

  for I := 0 to Size - 1 do
  begin
    Write('.');
    if I mod 33 = 32 then WriteLn((I + 1) * 100 / Size:4, '%');

    for J := 0 to Size - 1 do
    begin
      CheckTree(I, J, Visible, Score);
      if Visible > 0 then Trees := Trees + 1;
      if Score > Best then Best := Score;
    end;
  end;

  WriteLn;
  WriteLn('Part 1: ', Trees, ' trees are visible.');
  WriteLn('Part 2: Scenic score is ', Best:0:0, '.');
end;

begin
  ClrScr;

  WriteLn('*** AoC 2022.08 Treetop Tree House ***');
  WriteLn;

  Load;
  Process;
end.
