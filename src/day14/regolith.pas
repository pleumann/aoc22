program Regolith;

{$I /Users/joerg/Projekte/pl0/lib/Files.pas}

type
  TStringArray = array[0..31] of String[10];

var
  Sand, Rock: array[0..400] of set of Byte;

  Floor, Top, Left, Part1, Part2: Integer;

  Horz: array[0..200] of Integer;

procedure SetSand(X, Y: Integer);
begin
  Include(Sand[X], Y);
end;

function GetSand(X, Y: Integer): Boolean;
begin
  GetSand := Y in Sand[X];
end;

procedure SetRock(X, Y: Integer);
begin
  Include(Rock[X], Y);
  Include(Sand[X], Y);
end;

function GetRock(X, Y: Integer): Boolean;
begin
  GetRock := Y in Rock[X];
end;

function Split(S, T: TString; var A: TStringArray): Integer;
var
  I, J: Byte;
begin
  I := 0;
  J := Pos(T, S);
  while J <> 0 do
  begin
    A[I] := Copy(S, 1, J - 1);
    I := I + 1;
    Delete(S, 1, J + Length(T) - 1);
    J := Pos(T, S);
  end;
  A[I] := S;
  I := I + 1;

  Split := I;
end;

function StrToInt(S: TString): Integer;
var
  I, E: Integer;
begin
  Val(S, I, E);
  StrToInt := I;
end;

procedure ParseTuple(S: TString; var I, J: Integer);
var
  K: Byte;
begin
  K := Pos(',', S);
  I := StrToInt(Copy(S, 1, K - 1)) - 300;
  J := StrToInt(Copy(S, K + 1, 255));
end;

procedure Init;
var
  I: Integer;
begin
  for I := 0 to 400 do
  begin
    Sand[I] := [];
    Rock[I] := [];
  end;
end;

function Min(I, J: Integer): Integer;
begin
  if I <= J then Min := I else Min := J;
end;

function Max(I, J: Integer): Integer;
begin
  if I >= J then Max := I else Max := J;
end;

procedure Load;
var
  T: Text;
  S: TString;
  A: TStringArray;
  Num, I, J, X1, X2, Y1, Y2: Integer;
begin
  Assign(T, 'INPUT   .TXT');
  Reset(T);

  Floor := 0;

  while not IsEof(T) do
  begin
    ReadLine(T, S);
    (* WriteLn(S); *)
    Num := Split(S, ' -> ', A);
    
    ParseTuple(A[0], X1, Y1);
    Floor := Max(Floor, Y1 + 2);

    for I := 1 to Num - 1 do
    begin
      ParseTuple(A[I], X2, Y2);
      Floor := Max(Floor, Y2 + 2);

      if X1 < X2 then
        for J := X1 to X2 do SetRock(J, Y1)
      else if X1 > X2 then
        for J := X2 to X1 do SetRock(J, Y1)
      else if Y1 < Y2 then
        for J := Y1 to Y2 do SetRock(X1, J)
      else if Y1 > Y2 then
        for J := Y2 to Y1 do SetRock(X1, J)
      else WriteLn('Oops!');

      X1 := X2;
      Y1 := Y2;
    end;
  end;

  Close(T);

  for I := 0 to 400 do SetRock(I, Floor);
end;

function Fall(X, Y: Integer): Integer;
begin
  Horz[Y] := X;
  while True do
  begin
    if not GetSand(X, Y + 1) then
    begin
      Inc(Y);
      Horz[Y] := X;
    end
    else if not GetSand(X - 1, Y + 1) then
    begin
      Dec(X);
      Inc(Y);
      Horz[Y] := X;
    end
    else if not GetSand(X + 1, Y + 1) then
    begin
      Inc(X);
      Inc(Y);
      Horz[Y] := X;
    end
    else Break;
  end;

  SetSand(X, Y);
  Fall := Y;
end;

procedure Show(X, Y: Integer);
var
  I, J, K: Integer;
  Visible: Boolean;
begin
  Visible := (X >= Left) and (X <= Left + 79) and (Y >= Top) and (Y <= Top + 21);

  if Visible then
  begin
    GotoXY(1 + X - Left, 3 + Y - Top);
    Write('o');
    for K := 0 to 255 do begin end;
  end
  else if GetRock(Horz[Y], Y + 1) and ((Part2 = 0) or (Y < Floor - 1)) then
  begin
    for I := -32768 to 16383 do begin end;

    Top := Y - 19;
    if Top < 0 then Top := 0;

    Left := 160;

    GotoXY(58, 1);
    Write(#27'p AOC-CCTV at level ', Top:3, ' '#27'q');
    GotoXY(1, 3);
    Write(#27'J');
    
    for I := 0 to 21 do
    begin
      GotoXY(1, 3 + I);
      for J := 0 to 79 do
        if GetSand(Left + J, Top + I) (* or (Left + J = Horz[Top + I]) *) then
        begin
          if GetRock(Left + J, Top + I) then Write(#27'p#'#27'q') else Write('o');
        end
        else Write(' ');
    end;
  end;
end;

procedure Solve;
var
  X, Y, Z, NextX, NextY: Integer;
begin
  Part1 := 0;
  Part2 := 0;

  Left := 999;
  Top := 999;

  Horz[0] := 200;
  Y := 1;

  repeat
    Y := Y - 1;
    X := Horz[Y];
    Part1 := Part1 + 1;
    Y := Fall(X, Y);
    Show(Horz[Y], Y);
  until Y = Floor - 1;

  repeat
    Y := Y - 1;
    X := Horz[Y];
    Part2 := Part2 + 1;
    Y := Fall(X, Y);
    Show(Horz[Y], Y);
  until Y = 0;

  GotoXY(1, 3);
  WriteLn('Part 1: ', Part1 - 1:5);
  GotoXY(1, 4);
  WriteLn('Part 2: ', Part1 + Part2:5);

  GotoXY(1, 23);
end;

begin
  Write(#27'f');

  ClrScr;

  WriteLn('*** AoC 2022.14 Regolith Reservoir ***');
  WriteLn;
  WriteLn('Loading data...');

  Init;
  Load;
  Solve;

  Write(#27'e');
end.
