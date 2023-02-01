program Supply;

{$I /Users/joerg/Projekte/pl0/lib/files.pas}

var
  Stacks: array[0..9] of String[64];

procedure Dump(I: Integer);
var
  L: Integer;
begin
  L := Length(Stacks[I]);
  GotoXY(1, 4 + I);
  Write(I, ': ');
  if L > 1 then
    Write(Copy(Stacks[I], 1, L - 1));

  if L > 0 then
  begin
    Write(#27'p');
    Write(Stacks[I][L]);
    Write(#27'q');
  end;

  Write(#27'K');
end;

procedure Push(I: Integer; C: Char);
begin
  Stacks[I] := Stacks[I] + C;
end;

function Pop(I: Integer): Char;
var
  L: Integer;
begin
  L := Length(Stacks[I]);
  Pop := Stacks[I][L];
  Stacks[I][0] := Char(L - 1);
end;

procedure Clear(I: Integer);
begin
  Stacks[I][0] := #0;
end;

function IsEmpty(I: Integer): Boolean;
begin
  IsEmpty := Length(Stacks[I]) = 0;
end;

procedure Move1(Count, Source, Dest: Integer);
var
  I: Integer;
begin
  for I := 1 to Count do
  begin
    Push(Dest, Pop(Source));
    Dump(Source);
    Dump(Dest);
  end;
end;

procedure Move2(Count, Source, Dest: Integer);
var
  I: Integer;
begin
  for I := 1 to Count do
  begin
    Push(0, Pop(Source));
    Dump(Source);
  end;

  for I := 1 to Count do
  begin
    Push(Dest, Pop(0));
    Dump(Dest);
  end;
end;

function Solve(Model: Integer): TString;
var
  T: Text;
  S: TString;
  I, J, Count, Source, Dest, Err: Integer;
  C: Char;
begin
  for I := 0 to 9 do
    Clear(I);

  Assign(T, 'INPUT   .TXT');
  Reset(T);

  ReadLine(T, S);
  while Pos('[', S) <> 0 do
  begin
    for I := 1 to (Length(S) + 1) / 4 do
    begin
      C := S[4 * I - 2];
      if C <> ' ' then Insert(C, Stacks[I], 1);
    end;
    
    ReadLine(T, S);
  end;

  for I := 1 to 9 do
    Dump(I);

  ReadLine(T, S); { Empty line }
  while not IsEof(T) do
  begin
    ReadLine(T, S);

    I := Pos(' from ', S);
    J := Pos(' to ', S);

    Val(Copy(S, 6, I - 6), Count, Err);
    Val(Copy(S, I + 6, J - I + 6), Source, Err);
    Val(Copy(S, J + 4, 255), Dest, Err);

    GotoXY(1, 3);
    WriteLn('CrateMover (tm) '#27'p' , Model, #27'q now moving ', Count:2, ' creates from ', Source, ' to ', Dest);

    if Model = 9000 then
      Move1(Count, Source, Dest)
    else
      Move2(Count, Source, Dest);
  end;

  Close(T);

  S := '';
  for I := 0 to 9 do
    if not IsEmpty(I) then S := S + Pop(I);

  Solve := S;
end;

var
  S: TString;

begin
  ClrScr;

  Write(#27'f');
  WriteLn('*** AoC 2022.05 Supply Stacks ***');
  WriteLn;

  S := Solve(9000);
  GotoXY(1, 15);
  WriteLn('Part 1: ', S);

  S := Solve(9001);
  GotoXY(1, 16);
  WriteLn('Part 2: ', S);
  Write(#27'e');
end.