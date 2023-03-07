program Grove;

{$I /Users/joerg/Projekte/pl0/lib/Files.pas}

const
  FileName = 'INPUT   .TXT';

type
  PNode = ^TNode;
  TNode = record
    Next, Prev: PNode;
    Value, Value2: Integer;
  end;

var
  Nodes: array[0..4999] of TNode;

  Count, Zero, Sum1, Sum2: Integer;

  R, A, B: Real;

function SafeMod(A, B: Real): Real;
begin
  SafeMod := A - Int(A / B) * B;
end;

(* Original Pascal version *)
function FwdSlow(P: PNode; Count: Integer): PNode;
begin
  while Count > 0 do
  begin
    P := P^.Next;
    Dec(Count);
  end;
  FwdSlow := P;
end;

(* Assembly version *)
function FwdFast(P: PNode; Count: Integer): PNode; register;
inline(
  $42 /             (* ld b,d       *)
  $4b /             (* ld c,e       *)

  $78 /             (* ld a,b       *)
  $b1 /             (* or c         *)
  $c8 /             (* ret z        *)

  $5e /             (* ld e,(hl)    *)
  $23 /             (* inc hl       *)
  $56 /             (* ld d,(hl)    *)
  $eb /             (* ex de,hl     *)

  $0b /             (* dec bc       *)
  $18 / $f6         (* jr loop      *)
);

(* Improved assembly version with separate loops *)
function FwdFaster(P: PNode; Count: Integer): PNode; register;
inline(
  $43 /             (* ld b,e       *)
  $1b /             (* dec de       *)
  $14 /             (* inc d        *)
  $4a /             (* ld c,d       *)
                    (* @loop        *)
  $5e /             (* ld e,(hl)    *)
  $23 /             (* inc hl       *)
  $56 /             (* ld d,(hl)    *)
  $eb /             (* ex de,hl     *)
  $10 / $fa /       (* djnz loop    *)
  $0d /             (* dec c        *)
  $c2 / *-8         (* jp nz,loop   *)
);

var
  _SP: Integer;

(* Ped's assembly version with turbo-boost via SP *)
function FwdEvenFaster(P: PNode; Count: Integer): PNode; register;
inline(
  $43 /             (* ld b,e       *)
  $1b /             (* dec de       *)
  $14 /             (* inc d        *)
  $4a /             (* ld c,d       *)
  $ed / $73 / _SP / (* ld (_SP),sp  *)
  $f3 /             (* di           *)
                    (* @loop        *)
  $f9 /             (* ld sp,hl     *)
  $e1 /             (* pop hl       *)
  $10 / $fc /       (* djnz loop    *)
  $0d /             (* dec c        *)
  $c2 / *-6 /       (* jr nz,loop   *)
  $ed / $7b / _SP / (* ld sp,(_SP)  *)
  $fb               (* ei           *)
);

procedure Transfer(Node, Prev, Next: PNode);
begin
  if (Node = Prev) or (Node = Next) then Exit;

  Node^.Prev^.Next := Node^.Next;
  Node^.Next^.Prev := Node^.Prev;

  Prev^.Next := Node;
  Node^.Prev := Prev;
  
  Next^.Prev := Node;
  Node^.Next := Next;
end;

procedure Mix(Node: PNode);
var
  I: Integer;
  Temp: PNode;
begin
  I := Node^.Value2;

  if I > 0 then
  begin
    Temp := FwdEvenFaster(Node, I);
    Transfer(Node, Temp, Temp^.Next); 
  end
end;

procedure Load;
var
  T: Text;
  S: String;
  I, Err : Integer;
begin
  WriteLn('Loading input file...');

  Assign(T, 'INPUT   .TXT');
  Reset(T);

  Count := 0;

  while not IsEof(T) do
  begin
    ReadLine(T, S);
    Val(S, I, Err);
    Nodes[Count].Value := I;
    if I = 0 then Zero := Count;
    Count := Count + 1;
  end;

  Close(T);

  WriteLn;
end;

function Process(Factor: Real; Rounds: Integer): Integer;
var
  I, J, Sum: Integer;
  Node: PNode;
begin
  WriteLn('Setting up lists...');

  for I := 0 to Count - 2 do
  begin
    Nodes[I].Next := Ptr(Addr(Nodes[I + 1]));
    Nodes[I + 1].Prev:= Ptr(Addr(Nodes[I]));
  end;

  Nodes[Count - 1].Next := Ptr(Addr(Nodes[0]));
  Nodes[0].Prev := Ptr(Addr(Nodes[Count - 1]));

  WriteLn('Preparing numbers...');

  for I := 0 to Count - 1 do
  begin
    J := Nodes[I].Value;

    if J > 0 then
      J := Fix(SafeMod(SafeMod(Factor, Count - 1) * SafeMod(J, Count - 1), Count - 1))
    else
      J := Count - 1 + Fix(SafeMod(SafeMod(Factor, Count - 1) * SafeMod(J, Count - 1), Count -1));

    Nodes[I].Value2 := J;
  end;

  WriteLn;

  for I := 1 to Rounds do
  begin
    Write(#27'AMixing ');
    case I of
      1: Write(' 1st');
      2: Write(' 2nd');
      3: Write(' 3rd');
      else Write(I:2, 'th');
    end;
    WriteLn(' time...');

    for J := 0 to Count - 1 do Mix(Ptr(Addr(Nodes[J])));
  end;

  Sum := 0;

  Node := Ptr(Addr(Nodes[Zero]));
  for I := 1 to 3 do
  begin
    Node := FwdEvenFaster(Node, 1000);
    WriteLn(1000 * I, 'th number is ', Node^.Value:5);
    Sum := Sum + Node^.Value;
  end;

  WriteLn('Sum is ', Sum);
  WriteLn;

  Process := Sum;
end;

begin
  ClrScr;

  WriteLn('*** AoC 2022.20 Grove Positioning System ***');
  WriteLn;

  Load;

  R := 811589153.0;

  Sum1 := Process(1, 1);
  Sum2 := Process(R, 10);

  A := SafeMod(R, 1000000.0) * Sum2;
  B := Int(R / 1000000.0) * Sum2;

  B := B + Int(A / 1000000.0);
  A := SafeMod(A, 1000000.0);

  WriteLn('Part 1: ', Sum1);
  WriteLn('Part 2: ', B:0:0, A:6:0);
end.
