program TreeTop;

{$I /Users/joerg/Projekte/pl0/lib/Files.pas}

type
  TArrayOfSets = array[0..383] of set of Byte; (* Table for visited locations *)
 
var
  X, Y: array[0..9] of Integer;                (* Coordinates of all 10 knots *)
  Seen1, Seen2: TArrayOfSets;                  (* Visited locations parts 1/2 *)
  Part1, Part2: Integer;                       (* Number of visited locations *)

(*
 * Adds coordinates to given "seen" set, incrementing the counter if necessary.
 *)
procedure AddSeen(Part: Integer; var Seen: TArrayOfSets; var Counter: Integer; A, B: Integer);
begin
  (* -18 335 -14 218 *)

  A := A + 32;
  B := B + 16;

  if not (B in Seen[A]) then
  begin
    Include(Seen[A], B);
    Counter := Counter + 1;
    GotoXY(9, 2 + Part);
    Write(Counter:4); 
  end;
end;

(*
 * Implements the sign function.
 *)
function Sgn(A: Integer): Integer;
begin
  if A > 0 then
    Sgn := 1
  else if A < 0 then
    Sgn := -1
  else
    Sgn := 0;
end;

(*
 * Performs a single move (1 step) for the head, adjusting all tail parts.
 *)
procedure Move(Dir: Char);
var
  I, DX, DY: Integer;
begin
  case Dir of
    'R': X[0] := X[0] + 1;
    'L': X[0] := X[0] - 1;
    'U': Y[0] := Y[0] + 1;
    'D': Y[0] := Y[0] - 1;
  end;

  for I := 1 to 9 do
  begin
    DX := X[I - 1] - X[I];
    DY := Y[I - 1] - Y[I];

    if (Abs(DX) > 1) or (Abs(DY) > 1) then
    begin
      X[I] := X[I] + Sgn(DX);
      Y[I] := Y[I] + Sgn(DY);
    end
    else Break;
  end;
end;

(*
 * Shows the current state of the bridge and the input that lead to the most
 * recent change. Moves the print position 11 characters, wrapping around if
 * necessary.
 *)
procedure Print(Count: Integer; Dir: Char; Steps: Integer);
const
  Bridge: TString = 'H123456789';
  Col: Integer = 1;
var
  I, MinX, MinY: Integer;
  S: array[0..9] of String[10];
begin
  MinX := X[0];
  MinY := Y[0];

  for I := 1 to 9 do
  begin
    if X[I] < MinX then MinX := X[I];
    if Y[I] < MinY then MinY := Y[I];
  end;

  if Col > 70 then
    Col := 1;

  GotoXY(Col, 6);
  Write(#27'p#', Count:4, ': ', Dir, Steps:2, #27'q');

  GotoXY(Col, 17);
  Write(#27'pH: ', X[0]:3, ',', Y[0]:3, #27'q');

  for I := 0 to 9 do
    S[I] := '..........';

  for I := 0 to 9 do
    S[Y[I] - MinY][1 + X[I] - MinX] := Bridge[1 + I];

  for I := 0 to 9 do
  begin
    GotoXY(Col, 16 - I);
    Write(S[I]);
  end;

  GotoXY(Col + X[0] - MinX, 16 - (Y[0] - MinY));
  Write(#27'pH'#27'q');

  Col := Col + 11;
end;

(*
 * Solves the puzzle. Single pass is sufficient for both parts.
 *)
procedure Process;
var
  T: Text;
  S: TString;
  Count, I, Steps, Err: Integer;
  C: Char;
begin
  Count := 1;

  for I := 0 to 9 do
  begin
    X[I] := 0;
    Y[I] := 0;
  end;

  for I := 0 to 383 do
  begin
    Seen1[I] := [];
    Seen2[I] := [];
  end;

  Part1 := 0;
  Part2 := 0;

  Assign(T, 'INPUT   .TXT');
  Reset(T);

  while not IsEof(T) do
  begin
    ReadLine(T, S);

    C := S[1];
    Val(Copy(S, 3, 255), Steps, Err);

    for I := 1 to Steps do
    begin
      Move(C);
      AddSeen(1, Seen1, Part1, X[1], Y[1]);
      AddSeen(2, Seen2, Part2, X[9], Y[9]);
    end;

    Print(Count, C, Steps);

    Count := Count + 1;
  end;
        
  Close(T);
end;

begin
  Write(#27'f');

  ClrScr;
  WriteLn('*** AoC 2022.09 Rope Bridge ***');
  WriteLn;
  WriteLn('Part 1:');
  WriteLn('Part 2:');

  Process;

  GotoXY(1, 18);
  Write(#27'e');
end.
