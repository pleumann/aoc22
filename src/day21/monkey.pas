program Monkey;

{$i /Users/joerg/Projekte/pl0/lib/Files.pas}
{$i bigint.pas}

type
  NameStr = String[4];

  NodePtr = ^NodeRec;
  NodeRec = record
    Name: NameStr;

    case Leaf: Boolean of
      False: (Operator: Char; Left, Right: NodePtr;);
      True:  (Value: BigInt;);
  end;

var
  HashMap: array[0..7000] of NodePtr;

procedure Init;
var
  I: Integer;
begin
  for I := 0 to 7000 do
    HashMap[I] := nil;
end;

function HashKey(Name: TString): Integer;
var
  I: Integer;
begin
  I := ((Ord(Name[1]) - 97) * 1000 + (Ord(Name[2]) - 97) * 100 + (Ord(Name[3]) - 97) * 10 + (Ord(Name[4]) - 97)) mod 7001;
  HashKey := I;
end;

procedure Define(Node: NodePtr);
var
  I: Integer;
  S: NameStr;
begin
  S := Node^.Name;
  I := HashKey(S);
  while HashMap[I] <> nil do
  begin
    I := (I + Ord(Node^.Name[4])) mod 7001;
  end;

  HashMap[I] := Node;
end;

function Lookup(Name: TString): NodePtr;
var
  I: Integer;
  P: NodePtr;
begin
  I := HashKey(Name);
  P := HashMap[I];
  while P <> nil do
  begin
    if P^.Name = Name then
    begin
      Lookup := P;
      Exit;
    end;
    I := (I + Ord(Name[4])) mod 7001;
    P := HashMap[I];
  end;

  WriteLn('Error: ', Name, ' not found.');
  Lookup := nil;
end;

procedure Load;
var
  T: Text;
  S, U: TString;
  N: NodePtr;
  I: Integer;
begin
  Assign(T, 'INPUT   .TXT');

  WriteLn('Loading...');

  Reset(T);
  while not IsEof(T) do
  begin
    ReadLine(T, S);
    if S = '' then Continue;
    New(N);
    U := Copy(S, 1, 4);
    N^.Name := U;           (* Bug: Should be N^.Name := Copy(...) *)
    Define(N);              (* Bug: Crashes in Define              *)
  end;

  Close(T);

  WriteLn('Resolving...');

  Reset(T);
  while not IsEof(T) do
  begin
    ReadLine(T, S);
    if S = '' then Continue;
    N := Lookup(Copy(S, 1, 4));

    with N^ do
    if Length(S) > 10 then
    begin
      (* cqrh: bnph * jzrj *)

      Leaf := False;

      Operator := S[12];
      Left := Lookup(Copy(S, 7, 4));
      Right := Lookup(Copy(S, 14, 4));
    end
    else
    begin
      (* mbjq: 5 *)

      Leaf := True;

      BigVal(Copy(S, 7, 255), Value);
    end;
  end;

  Close(T);
end;

procedure Eval(Part: Integer; Node: NodePtr; var Big: BigInt);
const
  S: String = '';
var
  Tmp, Tmp2: BigInt;
begin
  if Node^.Leaf then
    Big := Node^.Value
  else
  begin
    Eval(Part, Node^.Left, Big);
    Eval(Part, Node^.Right, Tmp);

    if Part = 1 then
    begin
      GotoXY(1, 10);
      Write(#27'L');
      BigStr(Big, S);
      Write(S:20);
      Write(' ', Node^.Operator, ' ');
      BigStr(Tmp, S);
      Write(S:20);
      Write(' = ');
    end;

    case Node^.Operator of
      '+': BigAdd(Big, Tmp);
      '-': BigSub(Big, Tmp);
      '*': BigMul(Big, Tmp);
      '/': BigDiv(Big, Tmp, Tmp2);
    else
      WriteLn('Oops: ', Node^.Operator);
    end;

    if Part = 1 then
    begin
      BigStr(Big, S);
      Write(S:20);
    end;

    if Node^.Left^.Leaf and (Node^.Left^.Name <> 'humn') then
      if Node^.Right^.Leaf and (Node^.Right^.Name <> 'humn') then
      begin
        Node^.Value := Big;
        Node^.Leaf := True;
      end;
  end;
end;

var
  Root, Humn: NodePtr;
  I, J, L, H, T, R, Left, Right: BigInt;
  S: TString;
  C: Integer;

begin
  InitHeap(24576);

  Write(#27'f');

  ClrScr;

  WriteLn('*** AoC 2022.21 Monkey Math ***');
  WriteLn;

  Init;
  Load;

  Root := Lookup('root');
  Humn := Lookup('humn');
  

  Eval(1, Lookup('root'), I);
  BigStr(I, S);

  GotoXY(1, 6);
  WriteLn('Part 1: ', S);

  GotoXY(1, 10);
  Write(#27'L');

  L := BigMin;
  H := BigMax;
  BigVal('1000000', I);
  BigDiv(H, I, R);

  BigVal('2', T);

  while BigCmp(L, H) <> 0 do
  begin
    I := L;
    J := H;
    BigSub(J, L);
    BigDiv(J, T, R);
    BigAdd(I, J);

    GotoXY(1, 10);
    Write(#27'L');
    BigStr(L, S);
    Write(S:20);
    Write(' : ');
    BigStr(I, S);
    Write(S:20);
    Write(' : ');
    BigStr(H, S);
    Write(S:20);

    Humn^.Value := I;

    Eval(2, Root^.Left, Left);
    Eval(2, Root^.Right, Right);

    C := BigCmp(Right, Left);
    if C < 0 then
    begin
      L := I;
      BigAdd(L, BigOne);
    end
    else if C > 0 then 
    begin 
      H := I;
      BigSub(H, BigOne);
    end
    else Break;
  end;

  BigStr(I, S);
  GotoXY(1, 7);
  WriteLn('Part 2: ', S);

  Write(#27'J');
  Write(#27'e');
end.