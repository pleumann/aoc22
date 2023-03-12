program Unstable;

{$I /Users/joerg/Projekte/pl0/lib/Files.pas}

type
  Direction = (North, South, West, East, Happy);

  Elf = record
    X, Y: Byte;
    Z: Direction;
  end;

var
  Elves: array[0..2749] of Elf;

  Field: array[0..174, 0..174] of Char;

  FirstDir: Direction;

  NumElves: Integer;

  Moved: Boolean;

procedure ConOut(C: Char); register;
inline (
  $4d /                 (* ld c,l           *)
  $2a / $01 / $00 /     (* ld hl,($0001)    *)
  $11 / $09 / $00 /     (* ld de, $0009     *)
  $19 /                 (* add hl,de        *)
  $e9                   (* jp (hl)          *)
);

function NextDir(D: Direction): Direction; register;
inline(
  $7d /                 (* ld a,l           *)
  $3c /                 (* inc a            *)
  $e6 / $03 /           (* and a,3          *)
  $6f                   (* ld l,a           *)
);
(*
begin
  NextDir := Direction((Ord(D) + 1) mod 4);
end;
*)

function Analyze(var C: Char): Integer; register;
inline(
  $11 / >175 /          (* ld de,175        *)
  $37 /                 (* scf              *)
  $ed / $52 /           (* sbc hl,de        *)
  $3e / $23 /           (* ld a,'#'         *)
  $0e / $00 /           (* ld c,0           *)

  $be /                 (* cp (hl)          *)
  $20 / $02 /           (* jr nz,2          *)
  $cb / $c1 /           (* set 0,c          *)

  $23 /                 (* inc hl           *)

  $be /                 (* cp (hl)          *)
  $20 / $02 /           (* jr nz,2          *)
  $cb / $d9 /           (* set 3,c          *)

  $23 /                 (* inc hl           *)

  $be /                 (* cp (hl)          *)
  $20 / $02 /           (* jr nz,2          *)
  $cb / $e9 /           (* set 5,c          *)

  $19 /                 (* add hl,de        *)

  $be /                 (* cp (hl)          *)
  $20 / $02 /           (* jr nz,2          *)
  $cb / $f1 /           (* set 6,c          *)

  $2b /                 (* dec hl           *)
  $2b /                 (* dec hl           *)

  $be /                 (* cp (hl)          *)
  $20 / $02 /           (* jr nz,2          *)
  $cb / $c9 /           (* set 1,c          *)

  $19 /                 (* add hl,de        *)

  $be /                 (* cp (hl)          *)
  $20 / $02 /           (* jr nz,2          *)
  $cb / $d1 /           (* set 3,c          *)

  $23 /                 (* inc hl           *)

  $be /                 (* cp (hl)          *)
  $20 / $02 /           (* jr nz,2          *)
  $cb / $e1 /           (* set 4,c          *)

  $23 /                 (* inc hl           *)

  $be /                 (* cp (hl)          *)
  $20 / $02 /           (* jr nz,2          *)
  $cb / $f9 /           (* set 7,c          *)

  $26 / $00 /           (* ld h,0           *)
  $69                   (* ld l,c           *)
);
(*
var
  B: Integer;
begin
  B := 0;

  if Field[X - 1, Y - 1] = '#' then B := B or 1;
  if Field[X    , Y - 1] = '#' then B := B or 2;
  if Field[X + 1, Y - 1] = '#' then B := B or 4;
  if Field[X - 1, Y    ] = '#' then B := B or 8;
  if Field[X + 1, Y    ] = '#' then B := B or 16;
  if Field[X - 1, Y + 1] = '#' then B := B or 32;
  if Field[X    , Y + 1] = '#' then B := B or 64;
  if Field[X + 1, Y + 1] = '#' then B := B or 128;

  Analyze := B;
end;
*)

procedure Consider(var E: Elf);
var
  I, B: Byte;
  D: Direction;
begin
  with E do
  begin
    Z := Happy;

    B := Analyze(Field[X, Y]);

    if B = 0 then Exit;

    D := FirstDir;

    for I := 0 to 3 do
    begin
      case D of
        North: if B and 7 = 0 then
               begin
                 Z := North;
                 Inc(Field[X, Y - 1]);
                 Exit;
               end;
        South: if B and 224 = 0 then
               begin 
                 Z := South;
                 Inc(Field[X, Y + 1]);
                 Exit;
               end;
        West:  if B and 41 = 0 then
               begin 
                 Z := West;
                 Inc(Field[X - 1, Y]);
                 Exit;
               end;
        East:  if B and 148 = 0 then
               begin 
                 Z := East;
                 Inc(Field[X + 1, Y]);
                 Exit;
               end;
      end;

      D := NextDir(D);
    end;
  end;
end;

procedure Travel(var E: Elf);
var
  I: Integer;
begin
  with E do
  begin
    case Z of
      North:  if Field[X, Y - 1] = '/' then
              begin
                Field[X, Y] := '.';
                Dec(Y);
                Field[X, Y] := '#';
                Moved := True;
              end
              else Field[X, Y - 1] := '.';
      South:  if Field[X, Y + 1] = '/' then
              begin
                Field[X, Y] := '.';
                Inc(Y);
                Field[X, Y] := '#';
                Moved := True;
              end
              else Field[X, Y + 1] := '.';
      West:   if Field[X - 1, Y] = '/' then
              begin
                Field[X, Y] := '.';
                Dec(X);
                Field[X, Y] := '#';
                Moved := True;
              end
              else Field[X - 1, Y] := '.';
      East:   if Field[X + 1, Y] = '/' then
              begin
                Field[X, Y] := '.';
                Inc(X);
                Field[X, Y] := '#';
                Moved := True;
              end
              else Field[X + 1, Y] := '.';
    end;
  end;
end;

procedure Dump;
var
  I, J: Byte;
begin
  GotoXY(1, 3);

  for I := 95 to 114 do
  begin
    for J := 90 to 149 do ConOut(Field[I, J]);
    WriteLn;
  end;
end;

procedure CalcFreeCells;
var
  I: Integer;
  X, Y, MinX, MaxX, MinY, MaxY: Byte;
begin
  MinX := 255;
  MaxX := 0;
  MinY := 255;
  MaxY := 0;

  for I := 0 to NumElves -1 do
  begin
    X := Elves[I].X;
    Y := Elves[I].Y;
    if X < MinX then MinX := X;
    if X > MaxX then MaxX := X;
    if Y < MinY then MinY := Y;
    if Y > MaxY then MaxY := Y;
  end;

  GotoXY(65, 15);
  WriteLn('Part 1: ', (MaxX - MinX + 1) * (MaxY - MinY + 1) - NumElves:4);
end;

procedure Process;
var
  Rounds, I, X, Y: Integer;
begin
  Rounds := 1;
  FirstDir := North;

  while Rounds < 11 do
  begin
    GotoXY(65, 10);
    WriteLn('Rounds: ', Rounds:4);

    Dump;

    for I := 0 to NumElves - 1 do Consider(Elves[I]);
    for I := 0 to NumElves - 1 do Travel(Elves[I]);

    Inc(Rounds);
    FirstDir := NextDir(FirstDir);
  end;

  CalcFreeCells;

  while True do
  begin
    GotoXY(65, 10);
    WriteLn('Rounds: ', Rounds:4);

    Dump;

    Moved := False;

    for I := 0 to NumElves - 1 do Consider(Elves[I]);
    for I := 0 to NumElves - 1 do Travel(Elves[I]);

    if not Moved then 
    begin 
      GotoXY(65, 20);
      WriteLn('Part 2: ', Rounds:4);
      Break;
    end;

    Inc(Rounds);
    FirstDir := NextDir(FirstDir);
  end;
end;

procedure Load;
var
  T: Text;
  S: TString;
  X, Y: Byte;
begin
  NumElves := 0;

  for X := 0 to 174 do
    for Y := 0 to 174 do
      Field[X, Y] := '.';

  Y := 25;

  Assign(T, 'INPUT   .TXT');
  Reset(T);

  while not IsEof(T) do
  begin
    ReadLine(T, S);
    for X := 1 to Length(S) do
      if S[X] = '#' then
      begin
        Elves[NumElves].X := 25 + X;
        Elves[NumElves].Y := Y;
        Field[25 + X, Y] := '#';
        Inc(NumElves);
      end;
    Inc(Y);
  end;

  Close(T);

  GotoXY(65, 5);
  Write('Elves : ', NumElves:4);
end;

begin
  Write(#27'f');

  ClrScr;
  WriteLn('*** AoC 2022.23 Unstable Diffusion ***');
  WriteLn;
  WriteLn('Loading...');

  Load;
  Process;

  GotoXY(1, 23);
  Write(#27'e');
end.
