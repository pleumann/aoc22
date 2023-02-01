program Rucksack;

{$I /Users/joerg/Projekte/pl0/lib/files.pas}

type
  TPrio = array[1..52] of Boolean;

procedure MakePrio(S: String; var P: TPrio);
var
  C: Char;
  I: Integer;
begin
  for I := 1 to 52 do P[I] := False;

  for I := 1 to Length(S) do
  begin
    C := S[I];
    if C >= 'a' then
      P[Ord(C) - Ord('a') + 1] := True;
    else
      P[Ord(C) - Ord('A') + 27] := True;
  end;
end;

procedure AndPrio(var P, Q: TPrio);
begin
end;

function Common(First, Second: TString): TString;
var
  C, Result: TString;
  I: Integer;
begin
  Result := '';

  for I := 1 to Length(Second) do
  begin
    C := Second[I];
    if Pos(C, First) > 0 then
      if Pos(C, Result) = 0 then
        Result := Result + C;
  end;

  Common := Result
end;

function Priority(S: TString): Integer;
var
  C: Char;
begin
  C := S[1];
  if C >= 'a' then
    Priority := Ord(C) - Ord('a') + 1
  else
    Priority := Ord(C) - Ord('A') + 27;
end;

procedure Part1;
var
  T: Text;
  S: TString;
  L, Sum: Integer;
begin
  WriteLn('--- Part 1 ---');
  WriteLn;

  Assign(T, 'INPUT   .TXT');
  Reset(T);

  Sum := 0;

  while not IsEof(T) do
  begin
    Write('.');
    ReadLine(T, S);
    L := Length(S) / 2;
    Sum := Sum + Priority(Common(Copy(S, 1, L), Copy(S, L + 1, 255)));
  end;

  Close(T);

  WriteLn;
  WriteLn;
  WriteLn('Sum of priorities: ', Sum);
  WriteLn;
end;

procedure Part2;
var
  T: Text;
  S1, S2, S3: TString;
  L, Sum: Integer;
begin
  WriteLn('--- Part 2 ---');
  WriteLn;

  Assign(T, 'INPUT   .TXT');
  Reset(T);

  Sum := 0;

  while not IsEof(T) do
  begin
    Write('...');
    ReadLine(T, S1);
    ReadLine(T, S2);
    ReadLine(T, S3);

    Sum := Sum + Priority(Common(Common(S1, S2), S3));
  end;

  Close(T);

  WriteLn;
  WriteLn;
  WriteLn('Sum of priorities: ', Sum);
  WriteLn;
end;

begin
  WriteLn;
  WriteLn('*** AoC 2022.03 Rucksack Reorganization ***');
  WriteLn;

  Part1;
  Part2;
end.