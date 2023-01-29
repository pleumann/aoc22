program Monkey;

{$I /Users/joerg/Projekte/pl0/lib/Files.pas}

type
  TRealArray = array[0..39] of Real;

  TMonkey = record
    Items:      TRealArray;
    NumItems:   Integer;
    Operation:  Char;
    Argument:   Real;
    Check:      Real;
    Targets:    array[Boolean] of Integer;
    Activity:   Real;
  end;

var
  Monkeys:      array[0..7] of TMonkey;
  NumMonkeys:   Integer;

  Modulus, Limit, Divisor: Real;

function SafeMod(A, B: Real): Real;
begin
  SafeMod := A - Int(A / B) * B;
end;

function MultMod(A, B: Real): Real;
var
  PartA, PartMult: Real;
begin
  if (A <= 1) or (B <= 1) or ((A <= Limit) and (B <= Limit)) then
    MultMod := SafeMod(A * B, Modulus)
  else
  begin
    PartA := Int(A / Divisor);
    PartMult := MultMod(PartA, B);

    MultMod := SafeMod(SafeMod(PartMult * Divisor, Modulus) + 
               SafeMod(B * SafeMod(A, Divisor), Modulus), Modulus);
  end;
end;

procedure Load;
var
  I, K, P, Error: Integer;
  S: TString;
  T: Text;
begin
  NumMonkeys := 0;

  Assign(T, 'INPUT   .TXT');
  Reset(T);

  Modulus := 1;

  while not IsEof(T) do
  begin
    ReadLine(T, S);
    Val(Copy(S, 8, 255), I, Error);

    Monkeys[NumMonkeys].NumItems := 0;
    Monkeys[NumMonkeys].Activity := 0;

    ReadLine(T, S);
    S := Copy(S, 19, 255);
    while Length(S) <> 0 do
    begin
      Val(Copy(S, 1, 2), I, Error);
      K := Monkeys[NumMonkeys].NumItems;
      Monkeys[NumMonkeys].Items[K] := I;
      Monkeys[NumMonkeys].NumItems := K + 1;
      S := Copy(S, 5, 255);
    end;

    ReadLine(T, S);
    Monkeys[NumMonkeys].Operation := S[24];
    S := Copy(S, 26, 255);
    if S = 'old' then Monkeys[NumMonkeys].Operation := '^' else
    begin
      Val(S, I, Error);
      Monkeys[NumMonkeys].Argument := I;
    end;

    ReadLine(T, S);
    Val(Copy(S, 22, 255), I, Error);
    Monkeys[NumMonkeys].Check := I;
    Modulus := Modulus * I;
    
    ReadLine(T, S);
    Val(Copy(S, 30, 255), Monkeys[NumMonkeys].Targets[True], Error);

    ReadLine(T, S);
    Val(Copy(S, 31, 255), Monkeys[NumMonkeys].Targets[False], Error);

    ReadLine(T, S);
    
    NumMonkeys := NumMonkeys + 1;
  end;

  Close(T);

  Limit := 100000.0;
  Divisor := Int(10000000000.0 / Modulus);
end;

procedure Part1(var M: TMonkey);
var
  I, J, K: Integer;
  R: Real;
begin
  with M do
  begin
    for I := 0 to NumItems - 1 do
    begin
      Activity := Activity + 1;

      R := Items[I];

      case Operation of
        '+': R := Int((R + Argument) / 3);
        '*': R := Int((R * Argument) / 3);
        '^': R := Int((R * R) / 3);
      end;

      J := Targets[SafeMod(R, Check) = 0];

      K := Monkeys[J].NumItems;
      Monkeys[J].Items[K] := R;
      Monkeys[J].NumItems := K + 1;
    end;

    NumItems := 0;
  end;
end;

procedure Part2(var M: TMonkey);
var
  I, J, K: Integer;
  R, S, T: Real;
begin
  with M do if NumItems <> 0 then
  begin
    for I := 0 to NumItems - 1 do
    begin
      Activity := Activity + 1;

      R := Items[I];

      case Operation of
        '+': R := SafeMod(R + Argument, Modulus);
        '*': R := SafeMod(R * Argument, Modulus);
        '^': R := MultMod(R, R);
      end;

      J := Targets[SafeMod(R, Check) = 0];

      K := Monkeys[J].NumItems;
      Monkeys[J].Items[K] := R;
      Monkeys[J].NumItems := K + 1;
    end;

    NumItems := 0;
  end;
end;

procedure Dump;
var
  I, J: Integer;
begin
  GotoXY(1, 6);
  Write(#27'J');
  for I := 0 to NumMonkeys - 1 do
  with Monkeys[I] do
  begin
    GotoXY(1 + 10 * I, 5);
    Write(#27'p', I, ':', Monkeys[I].Activity:7:0, #27'q');

    for J := 0 to Monkeys[I].NumItems - 1 do 
    begin
      GotoXY(1 + 10 * I, 6 + J);
      Write(Monkeys[I].Items[J]:9:0);
    end;
  end;
end;

function GetBusiness: Real;
var A, B: Real;
I: Integer;
begin
  A := 0;
  B := 0;
  for I := 0 to NumMonkeys do
  begin
    if Monkeys[I].Activity > B then
    begin
      B := Monkeys[I].Activity;
      if B > A then
      begin
        B := A;
        A := Monkeys[I].Activity;
      end;
    end;
  end;
  GetBusiness := A * B;
end;

var
  I, J: Integer;

begin
  Write(#27'f');
  ClrScr;
  WriteLn('*** AoC 2022.11 Monkey in the Middle ***');
  WriteLn;

  Load;
  Dump;

  GotoXY(1, 3);
  WriteLn('Modulus: ', Modulus:0:0);

  for I := 1 to 20 do
  begin
    GotoXY(21, 3);
    Write('Round: ', I);
    for J := 0 to NumMonkeys - 1 do
      Part1(Monkeys[J]);
    Dump;
  end;

  GotoXY(41, 3);
  Write('Part 1: ', GetBusiness:0:0);
  
  Load;
  Dump;

  for I := 1 to 10000 do
  begin
    GotoXY(21, 3);
    Write('Round: ', I, ' ');
    for J := 0 to NumMonkeys - 1 do
      Part2(Monkeys[J]);
    Dump;
  end;

  GotoXY(61, 3);
  Write('Part 2: ', GetBusiness:0:0);

  GotoXY(1, 6);
  Write(#27'J'#27'e');
end.
