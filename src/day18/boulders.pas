program Boulders;

{$I /Users/joerg/Projekte/pl0/lib/Files.pas}

const
  Air   = 0;
  Stone = 1;
  Water = 2;

var
  Map: array[0..19, 0..19, 0..19] of Byte;

procedure Clear;
var
  I, J, K: Integer;
begin
  for I := 0 to 19 do
    for J := 0 to 19 do
      for K := 0 to 19 do
        Map[I, J, K] := Air
end;

procedure Load;
var
  T: Text;
  S: String;
  P, Error, I, J, K: Integer;
begin
  Assign(T, 'INPUT   .TXT');
  Reset(T);
  while not IsEof(T) do
  begin
    ReadLine(T, S);
    P := Pos(',', S);

    Val(Copy(S, 1, P - 1), I, Error);
    Delete(S, 1, P);
    P := Pos(',', S);
    Val(Copy(S, 1, P - 1), J, Error);
    Delete(S, 1, P);
    Val(S, K, Error);

    Map[I, J, K] := Stone;
  end;
end;

function Visible: Integer;
var
  I, J, K, Count: Integer;
begin
  Count := 0;

  for I := 0 to 19 do
    for J := 0 to 19 do
      for K := 0 to 19 do
        if Map[I, J, K] = Stone then
        begin
          if (I =  0) or (Map[I - 1, J, K] = Air) then Count:= Count + 1;
          if (I = 19) or (Map[I + 1, J, K] = Air) then Count:= Count + 1;
          if (J =  0) or (Map[I, J - 1, K] = Air) then Count:= Count + 1;
          if (J = 19) or (Map[I, J + 1, K] = Air) then Count:= Count + 1;
          if (K =  0) or (Map[I, J, K - 1] = Air) then Count:= Count + 1;
          if (K = 19) or (Map[I, J, K + 1] = Air) then Count:= Count + 1;
        end;

  Visible := Count;
end;

procedure Flood;
var
  X, Y, Z, Progress: Integer;

  procedure Recurse;
  begin
    if Map[X, Y, Z] = Air then
      begin
        Map[X, Y, Z] := Water;

        if X >  0 then begin X := X - 1; Recurse; X := X + 1; end;
        if X < 19 then begin X := X + 1; Recurse; X := X - 1; end;
        if Y >  0 then begin Y := Y - 1; Recurse; Y := Y + 1; end;
        if Y < 19 then begin Y := Y + 1; Recurse; Y := Y - 1; end;
        if Z >  0 then begin Z := Z - 1; Recurse; Z := Z + 1; end;
        if Z < 19 then begin Z := Z + 1; Recurse; Z := Z - 1; end;
      end;
  end;

begin
  X := 0;
  Y := 0;
  Z := 0;

  Progress := 0;

  Recurse;
end;

procedure Invert;
var
  I, J, K: Integer;
begin
  for I := 0 to 19 do
    for J := 0 to 19 do
      for K := 0 to 19 do
        if Map[I, J, K] = Stone then
          Map[I, J, K] := Air
        else if Map[I, J, K] = Air then
          Map[I, J, K] := Stone;
end;

procedure Show(Column: Integer);
var
  I, J, K: Integer;
begin
  for I := 0 to 9 do
  begin
    for J := 0 to 19 do
    begin
      GotoXY(Column, 3 + J);
      for K := 0 to 19 do
        if Map[I, J, K] = Stone then
          Write('#')
        else if Map[I, J, K] = Water then
          Write('~')
        else
          Write(' ');
    end;
    
    for J := 0 to 8191 do begin end;
  end;
end;

var
  V1, V2: Integer;
    
begin
  Write(#27'f');

  ClrScr;
  WriteLn('*** AoC 2022.18 Boiling Boulders ***');

  Clear;
  Load;
  Show(1);
  V1 := Visible;

  Flood;
  Show(26);
  Invert;
  Show(52);
  V2 := Visible;

  GotoXY(34, 24);
  Write('Part 1: ', V1);

  GotoXY(60, 24);
  Write('Part 2: ', V1 - V2);

  GotoXY(1, 23);

  Write(#27'e');
end.
