program Calorie;

{$i ../logging.inc}

var
  Scores: array[0..2] of Real;
  X, Y: Integer;
  Part1, Part2: String[20];

procedure Erase(Wait: Boolean);
var
  I: Integer;
begin
  if Wait then
    for I := 0 to 32767 do begin (* Wait *) end;

  GotoXY(1, 5);
  ClrEos;
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
  S: String;
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
  Str(Scores[0]:0:0, Part1);
  Str(Scores[0] + Scores[1] + Scores[2]:0:0, Part2);
  WriteLn('Part 1: ', Part1:7);
  WriteLn('Part 2: ', Part2:7);
end;

procedure Solve;
var
  T: Text;
  S: String;
  I, Err: Integer;
  R, Current: Real;
begin
  Erase(False);

  Current := 0;
  for I := 0 to 2 do
    Scores[I] := 0;

  Assign(T, ParamStr(1));
  Reset(T);

  while not Eof(T) do
  begin
    ReadLn(T, S);

    if S = '' then
    begin
      Check(Current);
      Current := 0;
    end
    else
    begin
      Val(S, R, Err);
      Print(R);
      Current := Current + R;
    end;
  end;

  Check(Current);

  Close(T);

  Erase(True);
end;

begin
  CursorOff;

  ClrScr;
  WriteLn('*** AoC 2022.01 Calorie Counting ***');
  Solve;

  CursorOn;

  Log(1, Part1, Part2);
end.
