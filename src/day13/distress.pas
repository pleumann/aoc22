program Distress;

{$I /Users/joerg/Projekte/pl0/lib/Files.pas}

type
  PNode = ^TNode;
  TNode = record
    Value: Integer;
    Next : PNode;
    First: PNode;
    Last:  PNode;
  end;

function NewNode: PNode;
var
  N: PNode;
begin
  New(N);
  with N^ do
  begin
    Value := -1;
    Next  := nil;
    First := nil;
    Last  := nil;
  end;
  NewNode := N;
end;

procedure DisposeNode(N: PNode);
begin
  if N^.Next <> nil then DisposeNode(N^.Next);
  if N^.First <> nil then DisposeNode(N^.First);
  Dispose(N);
end;

procedure AddNode(Node, Child: PNode);
begin
  if Node^.First = nil then
  begin
    Node^.First := Child;
    Node^.Last := Child;
  end
  else
  begin
    Node^.Last^.Next := Child;
    Node^.Last := Child;
  end;
end;

var
  C: Char;

function ParseNode(var T: Text): PNode;
var
  N: PNode;
begin
  N := NewNode;
  
  if C = '[' then
  begin  
    C := ReadChar(T);
    if C <> ']' then
    begin
      AddNode(N, ParseNode(T));

      while C = ',' do
      begin
        C := ReadChar(T);
        AddNode(N, ParseNode(T));
      end;
    end;

    if C <> ']' then WriteLn('Error: '']'' expected.');
    C := ReadChar(T);

    ParseNode := N;
  end
  else
  begin
    if (C < '0') or (C > '9') then WriteLn('Error: ''0-9'' expected.');

    N^.Value := Ord(C) - Ord('0');
    C := ReadChar(T);
    while (C >= '0') and (C <= '9') do
    begin
      N^.Value := N^.Value * 10 + Ord(C) - Ord('0');
      C := ReadChar(T);
    end;

    ParseNode := N;    
  end;
end;

function CompareNode(L, R: PNode): Integer;
var
  I, J, LC, RC: PNode;
  K: Integer;
begin
  if (L^.Value >= 0) and (R^.Value >= 0) then
    CompareNode := L^.Value - R^.Value
  else if L^.Value >= 0 then
  begin
    I := NewNode;
    I^.Value := L^.Value;
    J := NewNode;
    AddNode(J, I);
    CompareNode := CompareNode(J, R);
    DisposeNode(J);
  end
  else if R^.Value >= 0 then
  begin
    I := NewNode;
    I^.Value := R^.Value;
    J := NewNode;
    AddNode(J, I);
    CompareNode := CompareNode(L, J);
    DisposeNode(J);
  end
  else if (L^.Value < 0) and (R^.Value < 0) then
  begin
    LC := L^.First;
    RC := R^.First;
    while (LC <> nil) and (RC <> nil) do
    begin
      K := CompareNode(LC, RC);
      if K <> 0 then
      begin
        CompareNode := K;
        Exit;
      end;
      LC := LC^.Next;
      RC := RC^.Next;
    end;
    if (LC = nil) and (RC = nil) then
      CompareNode := 0
    else if LC = nil then
      CompareNode := -1
    else
      CompareNode := 1;
  end
  else WriteLn('Oops!');
end;

procedure Process;
var
  Index, Count, Before1, Before2: Integer;
  T: Text;
  N, M, Divider1, Divider2: PNode;
begin
  Index := 1;
  Count := 0;

  Divider1 := NewNode;
  AddNode(Divider1, NewNode);
  AddNode(Divider1^.First, NewNode);
  Divider1^.First^.First^.Value := 2;

  Divider2 := NewNode;
  AddNode(Divider2, NewNode);
  AddNode(Divider2^.First, NewNode);
  Divider2^.First^.First^.Value := 6;

  Before1 := 1;
  Before2 := 2;

  Assign(T, 'INPUT   .TXT');
  Reset(T);

  C := ReadChar(T);

  while not IsEof(T) do
  begin

    N := ParseNode(T);

    C := ReadChar(T);
    M := ParseNode(T);

    C := ReadChar(T);
    C := ReadChar(T);

    if CompareNode(N, M) <= 0 then
    begin
      Write(' ',#27'p ',Index:3, ' '#27'q  '); 
      Count := Count + Index;
    end
    else
      Write('  ',Index:3, '   ');

    if Index mod 10 = 0 then WriteLn;

    if CompareNode(N, Divider1) < 0 then
    begin
      Before1 := Before1 + 1;
      Before2 := Before2 + 1;
    end
    else if CompareNode(N, Divider2) < 0 then
      Before2 := Before2 + 1;

    if CompareNode(M, Divider1) < 0 then
    begin
      Before1 := Before1 + 1;
      Before2 := Before2 + 1;
    end
    else if CompareNode(M, Divider2) < 0 then
      Before2 := Before2 + 1;

    DisposeNode(N);
    DisposeNode(M);

    Index := Index + 1;
  end;

  Close(T);

  WriteLn;
  WriteLn('Part 1: Sum of right-order packet indices is ', Count:5, '.');
  WriteLn('Part 2: Product of divider packet indices is ', Before1 * Before2:5, '.');
end;

begin
  ClrScr;

  WriteLn('*** AoC 2022.13 Distress Signal ***');
  WriteLn;

  InitHeap(16364);

  Process;
end.