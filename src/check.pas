program Check;

const
  NumDays = 25;

type
  TResults = array[1..NumDays] of String[63];

var
  Expected, Actual: TResults;
  Day, Correct: Integer;
  E1, E2, A1, A2: String[63];

(**
 * Loads the results of all days from the given log file. Lines look like
 * "19: 1616, 8990". If a day occurs more than once, the last entry wins.
 * Returns False if the file does not exist.
 *)
function Load(Name: String; var Results: TResults): Boolean;
var
  T: Text;
  S, D: String;
  I, P, Err: Integer;
begin
  for I := 1 to NumDays do
    Results[I] := '';

  Assign(T, Name);
  {$i-}
  Reset(T);
  {$i+}
  if IOResult <> 0 then
  begin
    Load := False;
    Exit;
  end;

  while not Eof(T) do
  begin
    ReadLn(T, S);

    (* Files from other systems may bring a CR along *)
    while (Length(S) > 0) and (S[Length(S)] in [#13, ' ']) do
      Delete(S, Length(S), 1);

    P := Pos(':', S);
    if P <> 0 then
    begin
      D := Copy(S, 1, P - 1);
      while (Length(D) > 0) and (D[1] = ' ') do
        Delete(D, 1, 1);

      Val(D, I, Err);
      if (Err = 0) and (I >= 1) and (I <= NumDays) then
        Results[I] := Copy(S, P + 2, 63);
    end;
  end;

  Close(T);
  Load := True;
end;

(**
 * Splits "Part1, Part2" into its two parts.
 *)
procedure Split(S: String; var Part1, Part2: String);
var
  P: Integer;
begin
  P := Pos(', ', S);
  if P = 0 then
  begin
    Part1 := S;
    Part2 := '';
  end
  else
  begin
    Part1 := Copy(S, 1, P - 1);
    Part2 := Copy(S, P + 2, 63);
  end;
end;

(**
 * Prints one result with a check mark, optionally padded to a fixed width.
 *)
procedure Show(Act, Exp: String; Pad: Boolean);
begin
  if Act = '' then
    Act := '-';

  if Act = Exp then
  begin
    Write('[X] ');
    Correct := Correct + 1;
  end
  else
    Write('[ ] ');

  Write(Act);
  if Pad then
    Write('':21 - Length(Act));
end;

(**
 * Draws a Christmas tree to the left of the results. Four tiers of growing
 * width, then the trunk.
 *)
procedure Tree;
const
  Center = 13;
  Top = 4;
var
  Row, Tier, Width, I: Integer;
begin
  Row := Top;

  for Tier := 0 to 3 do
  begin
    if Tier = 0 then Width := 1 else Width := 2 * Tier + 3;
    while Width <= 4 * Tier + 7 do
    begin
      GotoXY(Center - Width div 2, Row);
      for I := 1 to Width do
        if (Row > Top) and ((I + Row) mod 6 = 0) then
          Write('o')
        else
          Write('*');
      Row := Row + 1;
      Width := Width + 2;
    end;
  end;

  for I := 0 to 2 do
  begin
    GotoXY(Center - 1, Row + I);
    Write('###');
  end;
end;

begin
  ClrScr;
  WriteLn('*** AoC 2022 Results ***');
  WriteLn;

  if not Load('golden.log', Expected) then
  begin
    WriteLn('Cannot find golden.log');
    Halt(1);
  end;

  if not Load('aoc22.log', Actual) then
  begin
    WriteLn('Cannot find aoc22.log');
    Halt(1);
  end;

  Correct := 0;

  for Day := 1 to NumDays do
  begin
    Split(Expected[Day], E1, E2);
    Split(Actual[Day], A1, A2);

    Write('':26, Day:2, '  ');
    Show(A1, E1, True);
    Show(A2, E2, False);
    WriteLn;
  end;

  Tree;

  (* Summary goes below the tree, next to the last day *)
  GotoXY(1, 2 + NumDays);
  WriteLn(Correct:2, ' / ', 2 * NumDays:2, ' results correct.');
  WriteLn;

  if Correct <> 2 * NumDays then
    Halt(1);
end.
