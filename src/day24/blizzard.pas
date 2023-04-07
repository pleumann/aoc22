program Blizzard;

{$I /Users/joerg/Projekte/pl0/lib/Files.pas}

type
  Point = record
    X, Y: Byte;
  end;

const
  TopLeft:     Point = (X:  0; Y:  0);
  BottomRight: Point = (X: 24; Y:119);

  Labels: array[Boolean] of String[6] = ('origin', 'target');

var
  Blizzards, Map: array[0..24, 0..119] of Char;

  Points, NewPoints: array[0..2999] of Point;
  NumPoints, NumNewPoints: Integer;

procedure Load;
var
  T: Text;
  S: TString;
  I, J: Byte;
begin
  Assign(T, 'INPUT   .TXT');
  Reset(T);

  ReadLine(T, S);
  for I := 0 to 24 do
  begin
    ReadLine(T, S);
    for J := 0 to 119 do Blizzards[I, J] := S[2 + J];
  end;

  Close(T);
end;

procedure Update(Time: Integer);
var
  I, J: Byte;
  K, Time1, Time2: Integer;

  procedure Put(var C: Char; D: Char);
  begin
    case C of
      '.': C := D;
      '2': C := '3';
      '3': C := '4';
      else C := '2';
    end;
  end;

begin
  Time1 := Time mod 25;
  Time2 := Time mod 120;

  for I := 0 to 119 do
    Map[0, I] := '.';
  for I := 1 to 24 do
    Move(Map[0], Map[I], 120);

  for I := 0 to 24 do
    for J := 0 to 119 do
    begin
      case Blizzards[I, J] of
        '^':  begin
                K := I - Time1;
                if K < 0 then Inc(K, 25);
                Put(Map[K, J], '^');
              end;
        'v':  begin
                K := I + Time1;
                if K > 24 then Dec(K, 25);
                Put(Map[K, J], 'v');
              end;
        '<':  begin
                K := J - Time2;
                if K < 0 then Inc(K, 120);
                Put(Map[I, K], '<');
              end;
        '>':  begin
                K := J + Time2;
                if K > 119 then Dec(K, 120);
                Put(Map[I, K], '>');
              end;
      end;
    end;
end;

procedure ConOut(C: Char); register;
inline (
  $4d /                 (* ld c,l           *)
  $2a / $01 / $00 /     (* ld hl,($0001)    *)
  $11 / $09 / $00 /     (* ld de, $0009     *)
  $19 /                 (* add hl,de        *)
  $e9                   (* jp (hl)          *)
);

procedure Show(X, Y: Integer);
var
  I, J: Byte;
begin
  for I := 0 to 19 do
  begin
    GotoXY(X, Y + I);
    for J := 0 to 18 - I do ConOut(Map[I, J]);
    ConOut(' '); ConOut('/'); ConOut(' ');
    for J := 0 to I - 1 do ConOut(Map[5 + I, 101 + J]);
  end;
end;

function Simulate(Origin, Target: Point; Go, Time: Integer): Integer;
var
  I: Integer;
  L: Point;
  Stop: Boolean;

  procedure Try(X, Y: Byte);
  var
    S: Point;
  begin
    if Map[X, Y] <> '.' then Exit;
    
    Map[X, Y] := 'E';

    S.X := X;
    S.Y := Y;

    NewPoints[NumNewPoints] := S;
    Inc(NumNewPoints);

    if (X = Target.X) and (Y = Target.Y) then Stop := True; 
  end;

begin
  NumPoints := 0;
  NumNewPoints := 0;
  Stop := False;

  GotoXY(13 + Go * 23, 3);
  Write(#27'pX----- Trip ', (Go + 1), ' ', Labels[Odd(Go)], ' /'#27'q');
  GotoXY(13 + Go * 23, 24);
  Write(#27'p/ Trip ', (Go + 1), ' ',Labels[not Odd(Go)], ' -----X', #27'q');

  repeat
    GotoXY(1, 10);
    WriteLn('Time  : ', Time:3);
    WriteLn('Elves : ', NumPoints:3);

    Update(Time);

    for I := 0 to NumPoints - 1 do with Points[I] do
    begin
      if Y > 0 then Try(X, Y - 1);
      if Y < 119 then Try(X, Y + 1);

      if X > 0 then Try(X - 1, Y);
      if X < 24 then Try(X + 1, Y);

      Try(X, Y);
    end;

    Try(Origin.X, Origin.Y);

    Show(13 + Go * 23, 4);

    if NumNewPoints <> 0 then Move(NewPoints, Points, NumNewPoints shl 1);

    NumPoints := NumNewPoints;
    NumNewPoints := 0;
    Inc(Time);
  until Stop;

  Simulate := Time;
end;

var
  I, J, K: Integer;

begin
  Write(#27'f');
  ClrScr;

  WriteLn('*** AoC 2022.24 Blizzard Basin ***');
  WriteLn;

  Load;

  I := Simulate(TopLeft, BottomRight, 0, 0);

  GotoXY(1, 16);
  WriteLn('Part 1: ', I);

  J := Simulate(BottomRight, TopLeft, 1, I + 1);
  K := Simulate(TopLeft, BottomRight, 2, J + 1);

  GotoXY(1, 17);
  WriteLn('Part 2: ', K);

  GotoXY(1, 23);
  Write(#27'e');
end.