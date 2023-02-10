program Enough;

{$I /Users/joerg/Projekte/pl0/lib/Files.pas}

const
  Timeout = 13500;

type
  Resource = (Ore, Clay, Obsidian, Geode);

  TStringArray = array[0..9] of String[10];

var
  Cost: array[Resource, Resource] of Byte;

  Stock, Robots, Limit: array[Resource] of Byte;

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

function TimeToWait(What: Resource): Integer;
var
  C, T, W: Integer;
  R: Resource;
begin
  T := 0;
  
  for R := Ore to Obsidian do
  begin
    C := Cost[What][R] - Stock[R];
    if C > 0 then
    begin
      W := Robots[R];
      if W = 0 then
      begin
        TimeToWait := 99;
        Exit;
      end;

      T := Max(T, (C + W - 1) / W);
    end;
  end;

  TimeToWait := T;
end;
    
procedure Build(What: Resource);
begin
  (*
  Dec(Stock[Ore], Cost[What, Ore]);
  Dec(Stock[Clay], Cost[What, Clay]);
  Dec(Stock[Obsidian], Cost[What, Obsidian]);
  Inc(Robots[What]);
  *)

  inline(
    $06 / $00 /         (* ld b,0       *)
    $dd / $4e / $06 /   (* ld c,(ix+6)  *)
    $21 / Robots /      (* ld hl,Robots *)
    $09 /               (* add hl,bc    *)
    $34 /               (* inc (hl)     *)
    $21 / Cost /        (* ld hl,Cost   *)
    $cb / $21 /         (* sla c        *)
    $cb / $21 /         (* sla c        *)
    $09 /               (* add hl,bc    *)
    $11 / Stock /       (* ld de,Stock  *)
    $06 / $03 /         (* ld b,3       *)
                        (* @l1:         *)
    $1a /               (* ld a,(de)    *)
    $96 /               (* sub (hl)     *)
    $12 /               (* ld (de),a    *)
    $23 /               (* inc hl       *)
    $13 /               (* inc de       *)
    $10 / $f9           (* djnz l1      *)
  );
end;

procedure Recycle(What: Resource);
begin
  (*
  Dec(Robots[What]);
  Inc(Stock[Ore], Cost[What, Ore]);
  Inc(Stock[Clay], Cost[What, Clay]);
  Inc(Stock[Obsidian], Cost[What, Obsidian]);
  *)

  inline(
    $06 / $00 /         (* ld b,0       *)
    $dd / $4e / $06 /   (* ld c,(ix+6)  *)
    $21 / Robots /      (* ld hl,Robots *)
    $09 /               (* add hl,bc    *)
    $35 /               (* dec (hl)     *)
    $21 / Cost /        (* ld hl,Cost   *)
    $cb / $21 /         (* sla c        *)
    $cb / $21 /         (* sla c        *)
    $09 /               (* add hl,bc    *)
    $11 / Stock /       (* ld de,Stock  *)
    $06 / $03 /         (* ld b,3       *)
                        (* @l1:         *)
    $1a /               (* ld a,(de)    *)
    $86 /               (* add (hl)     *)
    $12 /               (* ld (de),a    *)
    $23 /               (* inc hl       *)
    $13 /               (* inc de       *)
    $10 / $f9           (* djnz l1      *)
  );
end;

procedure Collect(N: Byte);
begin
  (*
  while N > 0 do
  begin  
    Inc(Stock[Ore], Robots[Ore]);
    Inc(Stock[Clay], Robots[Clay]);
    Inc(Stock[Obsidian], Robots[Obsidian]);
    Inc(Stock[Geode], Robots[Geode]);
  *)

  inline(
    $dd / $4e / $06 /   (* ld c,(ix+6)  *)
    $0c /               (* inc c        *)
    $18 / $0f /         (* jr @l3       *)
                        (* @l1:         *)
    $21 / Robots /      (* ld hl,Robots *)
    $11 / Stock /       (* ld de,Stock  *)
    $06 / $04 /         (* ld b,4       *)
                        (* @l2:         *)
    $1a /               (* ld a,(de)    *)
    $86 /               (* add (hl)     *)
    $12 /               (* ld (de),a    *)
    $23 /               (* inc hl       *)
    $13 /               (* inc de       *)
    $10 / $f9 /         (* djnz l2      *)
                        (* @l3:         *)
    $0d /               (* dec c        *)
    $20 / $ee           (* jr nz,l1     *)
  );
end;

procedure Drop(N: Byte);
begin
  (*
  while N > 0 do
  begin
    Dec(Stock[Ore], Robots[Ore]);
    Dec(Stock[Clay], Robots[Clay]);
    Dec(Stock[Obsidian], Robots[Obsidian]);
    Dec(Stock[Geode], Robots[Geode]);
    Dec(N);
  end;
  *)

  inline(
    $dd / $4e / $06 /   (* ld c,(ix+6)  *)
    $0c /               (* inc c        *)
    $18 / $0f /         (* jr @l3       *)
                        (* @l1:         *)
    $21 / Robots /      (* ld hl,Robots *)
    $11 / Stock /       (* ld de,Stock  *)
    $06 / $04 /         (* ld b,4       *)
                        (* @l2:         *)
    $1a /               (* ld a,(de)    *)
    $96 /               (* sub (hl)     *)
    $12 /               (* ld (de),a    *)
    $23 /               (* inc hl       *)
    $13 /               (* inc de       *)
    $10 / $f9 /         (* djnz l2      *)
                        (* @l3:         *)
    $0d /               (* dec c        *)
    $20 / $ee           (* jr nz,l1     *)
  );
end;

procedure Simulate(Rounds: Byte);
var
  Existing, Potential, NumGeodes, Time, I: Byte;
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
      Time := TimeToWait(R);
      if Time < Rounds then         (* Can build in time, go ahead. *)
      begin
        Inc(Time);
        Collect(Time);
        Build(R);
        Simulate(Rounds - Time);
        Recycle(R);
        Drop(Time);
      end
      else
      begin
        Collect(Rounds);            (* Can't build in time, just wait. *)
        Simulate(0);
        Drop(Rounds);
      end;
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

  WriteLn('*** AoC 2022.19 Not Enough Resources ***');
  WriteLn;
  WriteLn('Minutes left:  0  1  2  3  4  5  6  7  8  9 |      0  1  2  3  4  5  6  7  8  9');
  WriteLn('-------------------------------------------------------------------------------');

  for I := 1 to 15 do
  begin
    GotoXY(1, 4 + I);
    Write('Blueprint ', I:2, ':  0  0  0  0  0  0  0  0  0  0');
    Write(' | ', 15 + I:2, ':  0  0  0  0  0  0  0  0  0  0');
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
