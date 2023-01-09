program Calorie;

{$I /Users/joerg/Projekte/pl0/lib/files.pas}

var
  Scores: array[0..2] of Real;
  X, Y: Integer;

procedure Erase(Wait: Boolean);
var
  I: Integer;
begin
  if Wait then
    for I := 0 to 32767 do begin (* Wait *) end;

  GotoXY(1, 5);
  Write(#27'J');
  X := 0;
  Y := 0;
end;

procedure Print(R: Real);
begin
  if X = 10 then Erase(True);

  GotoXY(1 + 8 * X, 6 + Y);
  if R = -1 then
    Write(' ====== ')
  else
    Write(R:7:0, ' ');

  Y := Y + 1;
end;

procedure Check(R: Real);
var
  I: Integer;
  S: TString;
begin
  Print(-1);
  Print(R);

  X := X + 1;
  Y := 0;

  if R > Scores[2] then
  begin
    Scores[2] := R;
    if R > Scores[1] then
    begin
      Scores[2] := Scores[1];
      Scores[1] := R;
      if R > Scores[0] then
      begin
        Scores[1] := Scores[0];
        Scores[0] := R;
      end;
    end;
  end;

  GotoXY(1, 3);
  WriteLn('Part 1: ', Scores[0]:7:0);
  WriteLn('Part 2: ', Scores[0] + Scores[1] + Scores[2]:7:0);
end;

procedure Solve;
var
  T: Text;
  S: TString;
  I, Err: Integer;
  R, Current: Real;
begin
  Erase(False);

  Current := 0;
  for I := 0 to 2 do
    Scores[I] := 0;

  Assign(T, 'INPUT   .TXT');
  Reset(T);

  while not IsEof(T) do
  begin
    ReadLine(T, S);

    if S = '' then
    begin
      Check(Current);
      Current := 0;
    end
    else
    begin
      Val(S + '  ', R, Err);
      Print(R);
      Current := Current + R;
    end;
  end;

  Check(Current);

  Close(T);

  Erase(True);
end;

begin
  Write(#27'f');

  ClrScr;
  WriteLn('*** AoC 2022.01 Calorie Counting ***');
  Solve;

  Write(#27'e');
end.
