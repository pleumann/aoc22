program Rucksack;

{$I /Users/joerg/Projekte/pl0/lib/files.pas}

type
  TCharSet = set of Char;

function StrToSet(S: TString): TCharSet;
var
  I: Integer;
  C: TCharSet;
begin
  C := [];

  for I := 1 to Length(S) do
    Include(C, S[I]);

  StrToSet := C;
end;

function SetToInt(C: TCharSet): Integer;
var
  D: Char;
  I: Integer;
begin
  I := 0;

  for D := 'a' to 'z' do
    if D in C then I := I + Ord(D) - Ord('a') + 1;

  for D := 'A' to 'Z' do
    if D in C then I := I + Ord(D) - Ord('A') + 27;

  SetToInt := I;
end;

procedure WriteSet(Y: Integer; C: TCharSet);
var
  D: Char;
begin
  GotoXY(1, Y);
  for D := 'a' to 'z' do
  begin
    if D in C then
      Write(#27'p', D, #27'q')
    else
      Write(D);
  end;

  GotoXY(1, Y + 2);
  for D := 'A' to 'Z' do
  begin
    if D in C then
      Write(#27'p', D, #27'q')
    else
      Write(D);
  end;
end;

function Sum1(S: TString): Integer;
var
  L, I: Integer;
  C, C1, C2: TCharSet;
  S1, S2: TString;
begin
  L := Length(S) / 2;

  S1 := Copy(S, 1, L);
  S2 := Copy(S, L + 1, 255);

  GotoXY(33, 4);
  Write(S1, #27'K');

  GotoXY(33, 8);
  Write(S2, #27'K');

  C1 := StrToSet(S1);
  C2 := StrToSet(S2);

  WriteSet(3, C1);
  WriteSet(7, C2);

  C := C1 * C2; 

  WriteSet(18, C);

  I := SetToInt(C);

  GotoXY(33, 19);
  Write(I:4);

  Sum1 := I;
end;

function Sum2(S1, S2, S3: TString): Integer;
var
  C1, C2, C3, C: TCharSet;
  I: Integer;
begin

  GotoXY(33, 4);
  Write(S1, #27'K');

  GotoXY(33, 8);
  Write(S2, #27'K');

  GotoXY(33, 12);
  Write(S3, #27'K');

  C1 := StrToSet(S1);
  C2 := StrToSet(S2);
  C3 := StrToSet(S3);

  WriteSet(3, C1);
  WriteSet(7, C2);
  WriteSet(11, C3);

  C := C1 * C2 * C3; 

  WriteSet(18, C);

  I := SetToInt(C);

  GotoXY(33, 19);
  Write(I:4);

  Sum2 := I;
end;

procedure Solve1;
var
  T: Text;
  S: TString;
  I: Integer;
begin
  Assign(T, 'INPUT   .TXT');
  Reset(T);

  I := 0;

  while not IsEof(T) do
  begin
    ReadLine(T, S);

    I := I + Sum1(S);

    GotoXY(9, 22);
    Write(I:4);
  end;

  Close(T);
end;

procedure Solve2;
var
  T: Text;
  S1, S2, S3: TString;
  I: Integer;
begin
  Assign(T, 'INPUT   .TXT');
  Reset(T);

  I := 0;

  while not IsEof(T) do
  begin
    ReadLine(T, S1);
    ReadLine(T, S2);
    ReadLine(T, S3);

    I := I + Sum2(S1, S2, S3);

    GotoXY(23, 22);
    Write(I:4);
  end;

  Close(T);
end;

begin
  Write(#27'f');

  ClrScr;

  WriteLn('*** AoC 2022.03 Rucksack Reorganization ***');

  GotoXY(1, 4);
  Write('========================== <---');
  GotoXY(1, 8);
  Write('========================== <---');

  GotoXY(1, 15);
  WriteLn('     |    common    |');
  WriteLn('     v    subset    v');

  GotoXY(1, 19);
  Write('========================== --->');

  GotoXY(1, 22);
  WriteLn('Part 1:    0  Part 2:    0');

  Solve1;

  GotoXY(1, 12);
  Write('========================== <---');

  Solve2;

  WriteLn(#27'e');
end.