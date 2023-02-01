program Camp;

{$I /Users/joerg/Projekte/pl0/lib/files.pas}

procedure Split(S: TString; C: Char; var T, U: TString);
var
  P: Integer;
begin
  P := Pos(C, S);
  if P <> 0 then
  begin
    T := Copy(S, 1, P - 1);
    U := Copy(S, P + 1, Length(S) - P);
  end
end;

function Scale(X: Integer): Integer;
begin
  Scale := 1 + X * 74 / 100;
end;

procedure Draw(Row, Left, Right: Integer);
var
  X1, X2, I: Integer;
begin
  X1 := Scale(Left);
  X2 := Scale(Right);

  GotoXY(1, Row);

  for I := 1 to X1 - 1 do
    Write('.');

(*  Write(#27'p'); *)

  for I := X1 to X2 do
    Write('#');

(*  Write(#27'q'); *)

  for I := X2 + 1 to 74 do
    Write('.');

  Write(' ', Left:2, '-', Right:2);

end;

procedure Solve;
var
  T: Text;
  S: TString;
  L: array[0..3] of TString;
  A, B, C, D, Err, Row, Part1, Part2: Integer;
begin
  Part1 := 0;
  Part2 := 0;

  Row := 6;

  Assign(T, 'INPUT   .TXT');
  Reset(T);

  while not IsEof(T) do
  begin
    ReadLine(T, S);

    Split(S, ',', L[0], L[1]);

    Split(L[0], '-', L[2], L[3]);
    Val(L[2], A, Err);
    Val(L[3], B, Err);
    
    Split(L[1], '-', L[2], L[3]);
    Val(L[2], C, Err);
    Val(L[3], D, Err);

    Draw(Row, A, B);
    Draw(Row + 1, C, D);

    if (A >= C) and (B <= D) or (C >= A) and (D <= B) then
    begin
      Part1 := Part1 + 1;
      Part2 := Part2 + 1;
    end
    else if (A >= C) and (A <= D) or (B >= C) and (B <= D) then
      Part2 := Part2 + 1;

    GotoXY(1, 3);
    WriteLn('Part 1: ', Part1:5);
    WriteLn('Part 2: ', Part2:5);

    Row := Row + 3;
    if Row = 24 then Row := 6;
  end;

  Close(T);

  GotoXY(1, 5);
  Write(#27'J');
end;

begin
  Write(#27'f');

  ClrScr;
  WriteLn('*** AoC 2022.04 Camp Cleanup ***');
  Solve;

  Write(#27'e');
end.


