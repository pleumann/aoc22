program Enough;

{$I /Users/joerg/Projekte/pl0/lib/Files.pas}

const
  Timeout = 10300;

type
  Resource = (Ore, Clay, Obsidian, Geode);
  TResourceArray = array[Resource] of Byte;
  TStringArray = array[0..9] of String[10];

var
  Stock, Robots, Limit: TResourceArray;
  Cost: array[Resource] of TResourceArray;
  Best: array[0..32] of Byte;
  WatchDog, Num, Part1, Part2, I: Integer;
  T: Text;

procedure Update(B: Boolean);
var
  I: Integer;
begin
  GotoXY(14 + 36 * ((Num - 1) / 15), 5 + ((Num - 1) mod 15));
  if B then Write(#27'p');
  for I := 0 to 9 do Write(Best[I]:3);
  if B then Write(#27'q');
end;

function Min(I, J: Integer): Integer;
begin
  if I <= J then Min := I else Min := J;
end;

function Max(I, J: Integer): Integer;
begin
  if I >= J then Max := I else Max := J;
end;

function CanBuild(What: Resource): Boolean; register;
inline(
  $eb /             (* ex de,hl     *)

  $21 / Cost /      (* ld hl,Cost   *)
  $cb / $23 /       (* sla e        *)
  $cb / $23 /       (* sla e        *)
  $19 /             (* add hl,de    *)
  $11 / Stock /     (* ld de,Stock  *)

  $1a /             (* ld a,(de)    *)
  $be /             (* cp (hl)      *)
  $38 / $10 /       (* jr c,@Bail   *)

  $23 /             (* inc hl       *)
  $13 /             (* inc de       *)

  $1a /             (* ld a,(de)    *)
  $be /             (* cp (hl)      *)
  $38 / $0a /       (* jr c,@Bail   *)

  $23 /             (* inc hl       *)
  $13 /             (* inc de       *)

  $1a /             (* ld a,(de)    *)
  $be /             (* cp (hl)      *)
  $38 / $04 /       (* jr c,@Bail   *)

  $21 / 01 / 00 /   (* ld hl,1      *)
  $c9 /             (* ret          *)

                    (* @Bail:       *)
  $21 / $00 / $00   (* ld hl,0      *)
                    (* ret          *)
);

procedure Build(What: Resource); register;
inline(
  $eb /             (* ex de,hl     *)

  $21 / Robots /    (* ld hl,Robots *)
  $19 /             (* add hl,de    *)
  $34 /             (* inc (hl)     *)

  $21 / Cost /      (* ld hl,Cost   *)
  $cb / $23 /       (* sla e        *)
  $cb / $23 /       (* sla e        *)
  $19 /             (* add hl,de    *)
  $11 / Stock /     (* ld de,Stock  *)

  $1a /             (* ld a,(de)    *)
  $96 /             (* sub (hl)     *)
  $12 /             (* ld (de),a    *)

  $23 /             (* inc hl       *)
  $13 /             (* inc de       *)

  $1a /             (* ld a,(de)    *)
  $96 /             (* sub (hl)     *)
  $12 /             (* ld (de),a    *)

  $23 /             (* inc hl       *)
  $13 /             (* inc de       *)

  $1a /             (* ld a,(de)    *)
  $96 /             (* sub (hl)     *)
  $12               (* ld (de),a    *)
                    (* ret          *)
);

procedure Collect; register;
inline(
  $21 / Robots /    (* ld hl,Robots *)
  $11 / Stock /     (* ld de,Stock  *)

  $1a /             (* ld a,(de)    *)
  $86 /             (* add (hl)     *)
  $12 /             (* ld (de),a    *)

  $23 /             (* inc hl       *)
  $13 /             (* inc de       *)

  $1a /             (* ld a,(de)    *)
  $86 /             (* add (hl)     *)
  $12 /             (* ld (de),a    *)

  $23 /             (* inc hl       *)
  $13 /             (* inc de       *)

  $1a /             (* ld a,(de)    *)
  $86 /             (* add (hl)     *)
  $12 /             (* ld (de),a    *)

  $23 /             (* inc hl       *)
  $13 /             (* inc de       *)

  $1a /             (* ld a,(de)    *)
  $86 /             (* add (hl)     *)
  $12               (* ld (de),a    *)
                    (* ret          *)
);

procedure Move(var Src, Dst: TResourceArray); register;
inline(
  $ed / $a0 /       (* ldi          *)
  $ed / $a0 /       (* ldi          *)
  $ed / $a0 /       (* ldi          *)
  $ed / $a0         (* ldi          *)
                    (* ret          *)
);

procedure Simulate(Rounds: Byte);
var
  Existing, Potential, NumGeodes, Remaining: Byte;
  SavedRobots, SavedStock: TResourceArray;
  Possible: Boolean;
  R: Resource;
begin
  NumGeodes := Stock[Geode];

  (* Are we better or worse than the current best for this round? *)
  if NumGeodes > Best[Rounds] then
  begin
    if Rounds = 0 then Update(True);
    Best[Rounds] := NumGeodes;
    Watchdog := 0;
  end
  else if NumGeodes < Best[Rounds] then Exit;

  (* End simulation naturally. *)
  if Rounds = 0 then Exit;

  (* Is it possible to beat the current best number of geodes? *)
  Existing := Rounds * Robots[Geode];
  Potential := ((Rounds - 1) * Rounds) / 2;
  if NumGeodes + Existing + Potential <= Best[0] then Exit;

  (* Did we do too many iterations without any progress? *)
  if Watchdog >= Timeout then Exit;
  Inc(WatchDog);

  (* Try to build all robots types, waiting as long as necessary. *)
  for R := Ore to Geode do
  begin
    if Robots[R] < Limit[R] then
    begin
      Move(Robots, SavedRobots);
      Move(Stock, SavedStock);

      Remaining := Rounds;
      Possible := False;
      repeat
        Possible := CanBuild(R);
        Collect;
        Dec(Remaining);
      until Possible or (Remaining = 0);

      if Possible then Build(R);
      Simulate(Remaining);

      Move(SavedRobots, Robots);
      Move(SavedStock, Stock);
    end;
  end;
end;

procedure Split(S: TString; C: Char; var A: TStringArray);
var
  I, J, K: Byte;
begin
  J := 1;
  I := 1;
  K := 0;
  while (J < Length(S)) and (K < 10) do
  begin
    while (I <= Length(S)) and (S[I] <> ' ') do
      I := I + 1;
    if (I <> J) then
    begin
      A[K] := Copy(S, J, I - J);
      K := K + 1;
    end;
    I := I + 1;
    J := I;
  end;
end;

function StrToInt(S: TString): Integer;
var
  I, E: Integer;
begin
  Val(S, I, E);
  StrToInt := I;
end;

function StrToRes(S: TString): Resource;
begin
  case S[2] of
    'r': StrToRes := Ore;
    'l': StrToRes := Clay;
    'b': StrToRes := Obsidian;
    'e': StrToRes := Geode;
    else
      WriteLn('Invalid resource: ', S);
  end;
end;

procedure Load(var T: Text);
var
  I, J: Resource;
  K, P: Integer;
  S: TString;
  A: TStringArray;
begin
  for I := Ore to Geode do
  begin
    Stock[I] := 0;
    Robots[I] := 0;
    Limit[I] := 0;

    for J := Ore to Geode do
      Cost[I, J] := 0;
  end;

  for K := 0 to 32 do
    Best[K] := 0;

  Robots[Ore] := 1;

  ReadLine(T, S);
  P := Pos(':', S);
  Delete(S, 1, P + 1);

  while Length(S) <> 0 do
  begin
    P := Pos('.', S);
    Split(Copy(S, 1, P - 1), ' ', A);
    Delete(S, 1, P);

    I := StrToRes(A[1]);

    J := StrToRes(A[5]);
    K := StrToInt(A[4]);

    Cost[I][J] := K;

    Limit[J] := Max(Limit[J], K);

    if A[6] = 'and' then
    begin
      J := StrToRes(A[8]);
      K := StrToInt(A[7]);

      Cost[I][J] := K;

      Limit[J] := Max(Limit[J], K);
    end;
  end;

  Limit[Geode] := 32767;
  WatchDog := 0;
end;

begin
  ClrScr;

  WriteLn('*** AoC 2022.19 Not Enough Minerals ***');
  WriteLn;
  WriteLn('Minutes left:  0  1  2  3  4  5  6  7  8  9 |      0  1  2  3  4  5  6  7  8  9');
  WriteLn('-------------------------------------------------------------------------------');

  for I := 1 to 15 do
  begin
    GotoXY(1, 4 + I);
    Write('Blueprint ', I:2, ':                              ');
    Write(' | ', 15 + I:2, ':                              ');
  end;

  Num := 1;

  Part1 := 0;
  Part2 := 1;

  Assign(T, 'INPUT   .TXT');
  Reset(T);
  while not IsEof(T) do
  begin
    Load(T);

    Update(True);

    if Num < 4 then
    begin
      Simulate(32);
      Part2 := Part2 * Best[0];
      Part1 := Part1 + Num * Best[8];
    end else begin
      Simulate(24);
      Part1 := Part1 + Num * Best[0];
    end;

    Update(False);

    Num := Num + 1;
  end;

  Close(T);

  WriteLn;
  WriteLn;
  WriteLn('Part 1: ', Part1);
  WriteLn('Part 2: ', Part2);
end.
