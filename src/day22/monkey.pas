program Monkey;

{$I /Users/joerg/Projekte/pl0/lib/Files.pas}

type
  Facing = (East, South, West, North);

  Matrix = array[0..5, Facing] of Integer;

const
  Adjacent1: Matrix = (
    (1, 2, 1, 4),
    (0, 1, 0, 1),
    (2, 4, 2, 0),
    (4, 5, 4, 5),
    (3, 0, 3, 2),
    (5, 3, 5, 3)
  );

  Transform1: Matrix = (
    (0, 0, 0, 0),
    (0, 0, 0, 0),
    (0, 0, 0, 0),
    (0, 0, 0, 0),
    (0, 0, 0, 0),
    (0, 0, 0, 0)
  );

  Adjacent2: Matrix = (
    (1, 2, 3, 5),
    (4, 2, 0, 5),
    (1, 4, 3, 0),
    (4, 5, 0, 2),
    (1, 5, 3, 2),
    (4, 1, 0, 3)
  );

  Transform2: Matrix = (
    ( 0,  0, -2, -3),
    ( 2,  1,  0,  4),
    (-1,  0, -1,  0),
    ( 0,  0,  2,  1),
    (-2,  1,  0,  0),
    (-1, -4,  3,  0)  
  );

  VisualX: array[0..5] of Integer = (2, 3, 2, 1, 2, 1);

  VisualY: array[0..5] of Integer = (0, 0, 1, 2, 2, 3);

var
  Cube: array[0..5, 0..49, 0..49] of Char;

  Path: array[0..5652] of Char;

  Part1, Part2: Real;

function Right(F: Facing): Facing;
begin
  if F = North then Right := East else Right := Succ(F);
end;

function Left(F: Facing): Facing;
begin
  if F = East then Left := North else Left := Pred(F);
end;

procedure RotateRight(var X, Y: Integer; var F: Facing);
begin
  case F of
    East:   begin
              X := 49 - Y;
              Y := 0;
            end;

    South:  begin
              Y := X;
              X := 49;
            end;

    West:   begin
              X := 49 - Y;
              Y := 49;
            end;

    North:  begin
              Y := X;
              X := 0;
            end;
  end;

  F := Right(F);
end;

procedure RotateLeft(var X, Y: Integer; var F: Facing);
begin
  case F of
    East:   begin
              X := Y;
              Y := 49;
            end;

    South:  begin
              Y := 49 - X;
              X := 0;
            end;

    West:   begin
              X := Y;
              Y := 0;
            end;

    North:  begin
              Y := 49 - X;
              X := 49;
            end;
  end;

  F := Left(F);
end;

function Hop(var S, X, Y: Integer; var F: Facing; var Adjacent, Transform: Matrix): Boolean;
var
  SS, XX, YY, TT: Integer;
  FF: Facing;
begin
  SS := Adjacent[S, F];
  TT := Transform[S, F];

  XX := X;
  YY := Y;
  FF := F;

  if TT = 0 then
    case FF of
      East:  XX := 0;
      South: YY := 0;
      West : XX := 49;
      North: YY := 49;
    end;
       
  while TT > 0 do
  begin
    RotateRight(XX, YY, FF);
    Dec(TT);
  end;

  while TT < 0 do
  begin
    RotateLeft(XX, YY, FF);
    Inc(TT);
  end;

  if Cube[SS, YY, XX] = '.' then
  begin
    S := SS;
    X := XX;
    Y := YY;
    F := FF;
    Hop := True;

    (* WriteLn('Hop to side=', SS, ' X=', X, ' Y=', Y, ' Facing=', F); *)
  end
  else Hop := False;
end;

function GetAbsoluteX(S, X: Integer): Integer;
begin
  case S of
    0, 2, 4: X := X + 50;
    1, 3: X := X + 100;
  end;

  GetAbsoluteX := X;
end;

function GetAbsoluteY(S, Y: Integer): Integer;
begin
  case S of
    2: Y := Y + 50;
    3, 4: Y := Y + 100;
    5: Y := Y + 150;
  end;

  GetAbsoluteY := Y;
end;

procedure ShowSide(S: Integer; Active: Boolean);
var
  X, Y, I, J: Integer;
begin
  X := 25 + VisualX[S] * 6;
  Y := 4 + VisualY[S] * 4;

  for I := 0 to 2 do
  begin
    if Active then Write(#27'p');
    GotoXY(X, Y);
    for J := 0 to 4 do Write(S);
    Inc(Y);
    if Active then Write(#27'q');
  end;
end;

procedure ShowSide2(S: Integer; Active: Boolean);
var
  X, Y, I: Integer;
begin
  case S of
    0: begin X := 55; Y :=  8; end;
    1: begin X := 60; Y :=  9; end;
    2: begin X := 52; Y := 12; end;
    3: begin X := 68; Y :=  8; end;
    4: begin X := 73; Y :=  9; end;
    5: begin X := 65; Y := 12; end;
  end;

  if Active then Write(#27'p');
  GotoXY(X, Y);

  case S of
    0, 3: begin
      for I := 0 to 2 do
      begin
        GotoXY(X - I, Y + I);
        Write(S,S,S,S,S);
      end;
    end;

    1, 4: begin
      GotoXY(X, Y); Write(S);
      GotoXY(X - 1, Y + 1); Write(S, S);
      GotoXY(X - 2, Y + 2); Write(S, S, S);
      GotoXY(X - 2, Y + 3); Write(S, S);
      GotoXY(X - 2, Y + 4); Write(S);
    end;

    2, 5: begin
      for I := 0 to 2 do
      begin
        GotoXY(X, Y + I);
        Write(S,S,S,S,S);
      end;
    end;
  end;

  if Active then Write(#27'q');
end;

procedure Load;
var
  T: Text;
  S: String;
  I: Integer;
begin
  WriteLn('Loading...');

  Assign(T, 'INPUT   .TXT');
  Reset(T);

  for I := 0 to 49 do
  begin
    ReadLine(T, S);
    Move(S[51], Cube[0][I], 50);
    Move(S[101], Cube[1][I], 50);
  end;

  for I := 0 to 49 do
  begin
    ReadLine(T, S);
    Move(S[51], Cube[2][I], 50);
  end;

  for I := 0 to 49 do
  begin
    ReadLine(T, S);
    Move(S[1], Cube[3][I], 50);
    Move(S[51], Cube[4][I], 50);
  end;

  for I := 0 to 49 do
  begin
    ReadLine(T, S);
    Move(S[1], Cube[5][I], 50);
  end;

  ReadLine(T, S);

  for I := 0 to 5651 do Path[I] := ReadChar(T);
  Path[5652] := 'X';

  Close(T);
end;

procedure Dump;
var
  I, J, K: Integer;
begin
  for I := 0 to 5 do
  begin
    WriteLn('Side ', I, ':');

    for J := 0 to 49 do
    begin
      for K := 0 to 49 do Write(Cube[I][J][K]);
      WriteLn;
    end;

    WriteLn;
  end;
end;

function Process(Part: Integer; var Adjacent, Transform: Matrix): Real;
var
  S, NewS, X, Y, P, Q, LastSide, I: Integer;
  F: Facing;
begin
  S := 0;
  X := 0;
  Y := 0;
  F := East;

  LastSide := -1;

  P := 0;

  repeat
    Q := 0;
    while (Path[P] >= '0') and (Path[P] <= '9') do begin
      Q := Q * 10 + Ord(Path[P]) - 48;
      Inc(P);
    end;

    (*WriteLn('Forward ', Q, ' into ', F, ' direction'); *)

    while Q > 0 do
    begin
      case F of
        East:   begin
                  if X = 49 then begin
                    if not Hop(S, X, Y, F, Adjacent, Transform) then Break;
                  end
                  else begin
                    if Cube[S][Y, X + 1] = '.' then Inc(X) else Break;
                  end;
                end;

        South:  begin
                  if Y = 49 then begin
                    if not Hop(S, X, Y, F, Adjacent, Transform) then Break;
                  end
                  else begin
                    if Cube[S][Y + 1, X] = '.' then Inc(Y) else Break;
                  end;
                end;

        West:   begin
                  if X = 0 then begin
                    if not Hop(S, X, Y, F, Adjacent, Transform) then Break;
                  end
                  else begin
                    if Cube[S][Y, X - 1] = '.' then Dec(X) else Break;
                  end;
                end;

        North:  begin
                  if Y = 0 then begin
                    if not Hop(S, X, Y, F, Adjacent, Transform) then Break;
                  end
                  else begin
                    if Cube[S][Y - 1, X] = '.' then Dec(Y) else Break;
                  end;
                end;
      end;

      Dec(Q);
    end;

    case Path[P] of
      'R':  begin
              F := Right(F);
              Inc(P);
            end;
      'L':  begin
              F := Left(F);
              Inc(P);
            end;
    end;

    GotoXY(9, 10); Write(GetAbsoluteY(S, Y):6);
    GotoXY(9, 11); Write(GetAbsoluteX(S, X):6);
    GotoXY(9, 12); Write(F:6);
    (* GotoXY(9, 13); Write(Y:6); *)

    if S <> LastSide then
    begin
      if LastSide <> -1 then
      begin
        ShowSide(LastSide, False);
        if Part = 2 then ShowSide2(LastSide, False);
      end;

      ShowSide(S, True);
      if Part = 2 then ShowSide2(S, True);
      LastSide := S;
    end;

    for I := 0 to 767 do begin end;

    (* WriteLn('Side: ', S, ' X=', X, ' Y=', Y, ' Facing=', F); *)
  until Path[P] = 'X';

  Process := 1000.0 * (1.0 + GetAbsoluteY(S, Y)) + 4.0 * (1.0 + GetAbsoluteX(S, X)) + Ord(F);
end;

begin
  Write(#27'f');

  ClrScr;

  WriteLn('*** AoC 2022.22 Monkey Map ***');
  WriteLn;
  WriteLn;

  Load;

  WriteLn('Processing...');

  GotoXY( 1, 10);
  WriteLn('Row   :');
  WriteLn('Column:');
  WriteLn('Facing:');

  GotoXY(30,  3); Write('      +-----+-----+');
  GotoXY(30,  4); Write('      |00000|11111|');
  GotoXY(30,  5); Write('      |00000|11111|');
  GotoXY(30,  6); Write('      |00000|11111|');
  GotoXY(30,  7); Write('      +-----+-----+');
  GotoXY(30,  8); Write('      |22222|');
  GotoXY(30,  9); Write('      |22222|');
  GotoXY(30, 10); Write('      |22222|');
  GotoXY(30, 11); Write('+-----+-----+');
  GotoXY(30, 12); Write('|33333|44444|');
  GotoXY(30, 13); Write('|33333|44444|');
  GotoXY(30, 14); Write('|33333|44444|');
  GotoXY(30, 15); Write('+-----+-----+');
  GotoXY(30, 16); Write('|55555|');
  GotoXY(30, 17); Write('|55555|');
  GotoXY(30, 18); Write('|55555|');
  GotoXY(30, 19); Write('+-----+');

  Part1 := Process(1, Adjacent1, Transform1);
  GotoXY(1, 17); WriteLn('Part 1: ', Part1:6:0);

  GotoXY(51,  7); Write('    +-----+      +-----+');
  GotoXY(51,  8); Write('   /00000/|     /33333/|');
  GotoXY(51,  9); Write('  /00000/1|    /33333/4|');
  GotoXY(51, 10); Write(' /00000/11|   /33333/44|');
  GotoXY(51, 11); Write('+-----+111+  +-----+444+');
  GotoXY(51, 12); Write('|22222|11/   |55555|44/ ');
  GotoXY(51, 13); Write('|22222|1/    |55555|4/  ');
  GotoXY(51, 14); Write('|22222|/     |55555|/   ');
  GotoXY(51, 15); Write('+-----+      +-----+    ');

  Part2 := Process(2, Adjacent2, Transform2);
  GotoXY(1, 18); WriteLn('Part 2: ', Part2:6:0);

  WriteLn;

  Write(#27'e');
end.
