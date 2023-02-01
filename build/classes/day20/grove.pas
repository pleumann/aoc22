program Grove;

{$I /Users/joerg/Projekte/pl0/lib/Files.pas}

const
  FileName = 'INPUT   .TXT';

type
  PNode = ^TNode;
  TNode = record
    Value: Integer;
    Prev, Next: PNode;
  end;

var
  Nodes: array[0..4999] of TNode;

  Count: Integer;

procedure Move(Node, Prev, Next: PNode);
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
  Temp: PNode;
  I: Integer;
begin
(*  Write('.'); *)

  Temp := Node;

  if Temp^.Value > 0 then
  begin
    for I := 0 to Temp^.Value mod (Count - 1) - 1 do Temp := Temp^.Next;
    Move(Node, Temp, Temp^.Next); 
  end
  else if Temp^.Value < 0 then
  begin
    for I := 0 to -Temp^.Value mod (Count - 1) - 1 do Temp := Temp^.Prev;
    Move(Node, Temp^.Prev, Temp);
  end;
end;

procedure Dump(Node: PNode);
var
  Temp: PNode;
begin
  Temp := Node;

  repeat
    Write(Temp^.Value, ', ');
    Temp := Temp ^.Next;
  until Temp = Node;

  WriteLn;
end;
        
procedure Part1;
var
  T: Text;
  S: String;
  I, J, Err, Zero, Sum: Integer;
  Node: PNode;
begin
  Assign(T, 'INPUT   .TXT');
  Reset(T);

  Count := 0;

  while not IsEof(T) do
  begin
    ReadLine(T, S);
    (* WriteLn(Count, ' ', S); *)
    Val(S, I, Err);
    Nodes[Count].Value := I;
    if I = 0 then Zero := Count;
    Count := Count + 1;
  end;

  Close(T);

  WriteLn('Read ', Count , ' numbers.');

  for I := 0 to Count - 2 do
  begin
    Nodes[I].Next := Ptr(Addr(Nodes[I + 1]));
    Nodes[I + 1].Prev:= Ptr(Addr(Nodes[I]));
  end;

  Nodes[Count - 1].Next := Ptr(Addr(Nodes[0]));
  Nodes[0].Prev := Ptr(Addr(Nodes[Count - 1]));

(*  Dump(Ptr(Addr(Nodes[0]))); *)

  for I := 0 to Count - 1 do
  begin
    Mix(Ptr(Addr(Nodes[I])));
(*    Dump(Ptr(Addr(Nodes[I]))); *)
    WriteLn('Mixing: ', I:4);
    Write(#27'A');
  end;
  
  WriteLn;

  Sum := 0;

  Node := Ptr(Addr(Nodes[Zero]));
  for I := 1 to 3 do
  begin
    for J := 1 to 1000 mod Count do Node := Node^.Next;
    WriteLn(1000 * I, 'th number is ', Node^.Value);
    Sum := Sum + Node^.Value;
  end;

  WriteLn('Sum is ', Sum);

end;

procedure Part2;
var
  T: Text;
  S: String;
  I, J, Err, Zero, I1, I2, I3: Integer;
  Node, K1, K2, K3: PNode;
  R, Sum: Real;
begin
  Assign(T, 'INPUT   .TXT');
  Reset(T);

  Count := 0;

  while not IsEof(T) do
  begin
    ReadLine(T, S);
    (* WriteLn(Count, ' ', S); *)
    Val(S, I, Err);
    Nodes[Count].Value := I;
    if I = 0 then Zero := Count;
    Count := Count + 1;
  end;

  Close(T);

  WriteLn('Read ', Count , ' numbers.');

  for I := 0 to Count - 2 do
  begin
    Nodes[I].Next := Ptr(Addr(Nodes[I + 1]));
    Nodes[I + 1].Prev:= Ptr(Addr(Nodes[I]));
  end;

  Nodes[Count - 1].Next := Ptr(Addr(Nodes[0]));
  Nodes[0].Prev := Ptr(Addr(Nodes[Count - 1]));

  for I := 0 to Count - 1 do
  begin
    R := (811589153.0 mod (Count - 1)) * (Nodes[I].Value mod (Count - 1)) mod (Count - 1);
    Nodes[I].Value := Fix(R);
  end;

(*  Dump(Ptr(Addr(Nodes[0]))); *)

  for I := 0 to 9 do
  begin
    WriteLn('Round ', I);
    WriteLn;
    for J := 0 to Count - 1 do
    begin
      Mix(Ptr(Addr(Nodes[J])));
  (*    Dump(Ptr(Addr(Nodes[J]))); *)
      WriteLn(#27'AMixing: ', J:4);
    end;
  end;
  
  WriteLn;

  Sum := 0;

  K1 := Ptr(Addr(Nodes[Zero]));
  for I := 0 to 999 do K1 := K1^.Next;    

  K2 := K1;
  for I := 0 to 999 do K2 := K2^.Next;

  K3:= K2;
  for I := 0 to 999 do K3 := K3^.Next;

  I1 := (Addr(K1^) - Addr(Nodes)) / 6;
  I2 := (Addr(K2^) - Addr(Nodes)) / 6;
  I3 := (Addr(K3^) - Addr(Nodes)) / 6;

(*  Assign(T, FileName); *)
  Reset(T);

  Count := 0;

  R := 1;

  while not IsEof(T) do
  begin
    ReadLine(T, S);
    (* WriteLn(Count, ' ', S); *)
    Val(S, I, Err);

    if (Count = I1) or (Count = I2) or (Count = I3) then
    begin
      R := 811589153.0 * I;
      WriteLn(Count, 'th number is ', I: 5, ' ', R:15:0);
      Sum := Sum + R;
    end;

    Count := Count + 1;
  end;

  Close(T);

  WriteLn('Sum is ', Sum:15:0);
end;

begin
  WriteLn;
  WriteLn('*** AoC 2022.20 Grove Positioning System ***');
  WriteLn;

  (* Part1; *)
  Part2;
end.
