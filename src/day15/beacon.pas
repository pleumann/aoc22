program Beacon;

{$I /Users/joerg/Projekte/pl0/lib/Files.pas}

type
  TRange = record
    Start, Stop: Real;
  end;

  TRangeArray = array[0..31] of TRange;

  TSensor = record
    X, Y, BX, BY, D: Real;
  end;

  TSensorArray = array[0..31] of TSensor;

var
  NumSensors: Integer;
  Sensors: TSensorArray;
  M: Integer;
  YY, Infinity: Real;

function Min(I, J: Real): Real;
begin
  if I <= J then Min := I else Min := J;
end;

function Max(I, J: Real): Real;
begin
  if I >= J then Max := I else Max := J;
end;

function Intersect(var A, B: TRange; var C: TRange): Boolean;
begin
  if (A.Stop <= B.Start) or (A.Start >= B.Stop) then
  begin
    Intersect := False;
    Exit;
  end;

  C.Start := Max(A.Start, B.Start);
  C.Stop := Min(A.Stop, B.Stop);

  Intersect := True;
end;

procedure Subtract(var From, What: TRange; var Pieces: TRangeArray; var Count: Integer);
var
  R: TRange;
begin
  if not Intersect(From, What, R) then
  begin
    Pieces[Count] := From;
    Inc(Count);
    Exit;
  end;

  R.Start := What.Stop;
  R.Stop := Infinity;

  if Intersect(From, R, Pieces[Count]) then Inc(Count);

  R.Start := -Infinity;
  R.Stop := What.Start;

  if Intersect(From, R, Pieces[Count]) then Inc(Count);
end;

procedure SensorInit(var S: TSensor; Data: TString);

  function GetNumber(C: Char): Real;
  var
    P, Q, E: Integer;
    R: Real; 
    S: TString;
  begin
    P := Pos('=', Data);
    Q := Pos(C, Data);
    S := Copy(Data, P + 1, Q - P - 1) + '$';
    Val(S, R, E);
    Delete(Data, 1, Q);
    GetNumber := R;
  end;

begin
  Data := Data + '$';

  with S do
  begin
    X := GetNumber(',');
    Y := GetNumber(':');
    BX := GetNumber(',');
    BY := GetNumber('$');

    D := Abs(BX - X) + Abs(BY - Y);

    GotoXY(1 + 40 * (NumSensors / 12), 6 + NumSensors mod 12);
    Write('[', NumSensors:2, '] x=', X:7:0, ' y=', Y:7:0, ' d=', D:7:0);
  end;
end;

function SensorRange(var S: TSensor; AtY: Real; var R: TRange): Boolean;
var
  L: Real;
begin
  L := S.D - Abs(AtY - S.Y);
  if L < 0 then
  begin
    SensorRange := False;
    Exit;
  end;

  R.Start := S.X - L;
  R.Stop := S.X + L + 1;

  SensorRange := True;
end;

procedure Load;
var
  T: Text;
  S: TString;
begin
  Assign(T, 'INPUT   .TXT');
  Reset(T);

  NumSensors := 0;

  while not IsEof(T) do
  begin
    ReadLine(T, S);
    SensorInit(Sensors[NumSensors], S);
    Inc(NumSensors);
  end;

  Close(T);
end;

procedure ShowRanges(var Ranges: TRangeArray; NumRanges: Integer);
var
  I: Integer;
begin
  GotoXY(1, 22);

  for I := 0 to NumRanges - 1 do
  begin
    GotoXY(1 + 20 * (I mod 4), 21 + I / 4);
    Write('[', Ranges[I].Start:8:0, ',', Ranges[I].Stop - 1:8:0, ']');
  end;

  Write(#27'J');
end;

procedure SensorRangesForCoord(Y: Real; var Ranges: TRangeArray; var NumRanges: Integer);
var
  I, J, NumPieces: Integer;
  R: TRange;
  Pieces: TRangeArray;
  Count: Real;
begin
  GotoXY(28,19);
  Write(#27'pRanges for y=', Y:8:0, #27'q');

  NumRanges := 0;
  for I := 0 to NumSensors - 1 do
  begin
    if SensorRange(Sensors[I], Y, R) then
    begin
      NumPieces := 0;
      for J := 0 to NumRanges - 1 do
        Subtract(Ranges[J], R, Pieces, NumPieces);

      NumRanges := NumPieces;
      if NumPieces <> 0 then
        Ranges := Pieces;

      if Sensors[I].BY = Y then
      begin
        Ranges[NumRanges].Start := R.Start;
        Ranges[NumRanges].Stop := Sensors[I].BX;
        Inc(NumRanges);
        Ranges[NumRanges].Start := Sensors[I].BX + 1;
        Ranges[NumRanges].Stop := R.Stop;
        Inc(NumRanges);
      end
      else
      begin
        Ranges[NumRanges] := R;
        Inc(NumRanges);
      end;
    end;
  end;

  ShowRanges(Ranges, NumRanges);
end;

procedure Part1;
var
  I, J, NumRanges, NumPieces: Integer;
  R: TRange;
  Ranges, Pieces: TRangeArray;
  Count: Real;
begin
  SensorRangesForCoord(YY, Ranges, NumRanges);

  Count := 0;
  for I := 0 to NumRanges - 1 do
    Count := Count + Ranges[I].Stop - Ranges[I].Start;

  GotoXY(9, 3); Write(Count:0:0);
end;

procedure SetHighlight(I: Integer; B: Boolean);
begin
  GotoXY(2 + 40 * (I / 12), 6 + I mod 12);
  if B then
    Write(#27'p', I:2, #27'q')
  else
    Write(I:2);
end;

function CheckPossiblePosition(Y: Real): Boolean;
var
  I, J, NumPossible, NumPieces, NumRanges: Integer;
  R: TRange;
  Ranges, Pieces, Possible: TRangeArray;
  Count, Z, P, Q: Real;
begin
    if (Y < 0) or (Y > 2.0 * YY + 1) then
    begin
      CheckPossiblePosition := False;
      Exit;
    end;

    (* WriteLn(Y:0:0); *)

    SensorRangesForCoord(Y, Ranges, NumRanges);

    Possible[0].Start := 0;
    Possible[0].Stop := 2.0 * YY + 1;
    NumPossible := 1;

    for I := 0 to NumRanges - 1 do
    begin
      R := Ranges[I];
      NumPieces := 0;
      for J := 0 to NumPossible - 1 do
        Subtract(Possible[J], R, Pieces, NumPieces);

      NumPossible := NumPieces;
      if NumPieces <> 0 then
      Possible := Pieces;
    end;

    Count := 0;
    for J := 0 to NumPossible - 1 do
    begin
      R := Pieces[J];
      Count := Count + R.Stop - R.Start;
    end;

    if Count = 1 then
    begin
      GotoXY(9, 4);

      P := 4.0 * Possible[0].Start + Int(Y / 1000000.0);
      Q := Y mod 1000000.0;

      Write(P:0:0, Q:6:0);

      (* Write(Y:0:0, ' + 4000000 * ', Possible[0].Start:0:0, ' (please do the math yourself)'); *)
      CheckPossiblePosition := True;
      Exit;
    end;

    CheckPossiblePosition := False;
end;

procedure Part2;
var
  I, J: Integer;
  Y1, Y2: Real;
  S1, S2: TSensor;
begin
  for I := 0 to NumSensors - 1 do
  begin
    S1 := Sensors[I];
    SetHighlight(I, True);
    for J := 0 to NumSensors - 1 do
    begin
      if I <> J then
      begin
        SetHighlight(J, True);
        S2 := Sensors[J];

        Y1 := Int((S2.Y - S2.D - S2.X + S1.Y - S1.D - S1.X) / 2.0);
        Y2 := Int((S1.Y - S1.D - S1.X + S2.Y + S2.D + S2.X) / 2.0);

        if CheckPossiblePosition(Y1) then Exit;
        if CheckPossiblePosition(Y2) then Exit;

        SetHighlight(J, False);
      end;
    end;
    SetHighlight(I, False);
  end;
end;

begin
  Write(#27'f');

  ClrScr;
  WriteLn('*** AoC 2022.15 Beacon Exclusion Zone ***');
  WriteLn;
  WriteLn('Part 1: n/a');
  WriteLn('Part 2: n/a');

  GotoXY(28,4);
  Write(#27'p   List of sensors   ', #27'q');

  Infinity :=  999999999.0;
  YY := 2000000.0;

  Load;

  WriteLn;

  Part1;
  Part2;

  GotoXY(1, 23);

  Write(#27'e');
end.