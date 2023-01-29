program Monkey;

{$I /Users/joerg/Projekte/pl0/lib/Files.pas}

type
  TMonkey = record
    Operation:  Char;
    Argument:   Real;
    Check:      Real;
    Targets:    array[False..True] of Integer;
    Activity:   Real;
  end;

  TItem = record
    Owner: Integer;
    case Boolean of
      False: (Value: Real;);
      True:  (Words: array[0..2] of Integer;);
  end;

  TCache = record
    Round: Integer;
    Value: Real;
  end;

var
  Monkeys:    array[0..7] of TMonkey;
  NumMonkeys: Integer;

  Items:      array[0..39] of TItem;
  NumItems:   Integer;

  Cache:      array[0..7, 0..300] of TCache;

  Modulus, Limit, Divisor: Real;

function SafeMod(A, B: Real): Real;
begin
  SafeMod := A - Int(A / B) * B;
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

  NumItems  := 0;

  while not IsEof(T) do
  begin
    ReadLine(T, S);
    Val(Copy(S, 8, 255), I, Error);

    Monkeys[NumMonkeys].Activity := 0;

    ReadLine(T, S);
    S := Copy(S, 19, 255);
    while Length(S) <> 0 do
    begin
      Val(Copy(S, 1, 2), I, Error);
      Items[NumItems].Owner := NumMonkeys;
      Items[NumItems].Value := I;
      NumItems := NumItems + 1;
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

procedure Dump;
var
  I: Integer;
begin
  for I := 0 to NumMonkeys - 1 do
  with Monkeys[I] do
  begin
    GotoXY(1 + 10 * I, 5);
    Write(#27'p', I, ':', Monkeys[I].Activity:7:0, #27'q');
  end;
end;

procedure Scroll;
begin
  GotoXY(1, 7);
  Write(#27'M');
  GotoXY(1, 24);
end;

procedure Part1(var Item: TItem);
var
  I: Integer;

  procedure Round;
  var
    J: Integer;
  begin
    repeat
      J := Item.Owner;
      with Monkeys[J] do
      begin
        Activity := Activity + 1;
        case Operation of
          '+': Item.Value := Int((Item.Value + Argument) / 3);
          '*': Item.Value := Int((Item.Value * Argument) / 3);
          '^': Item.Value := Int((Item.Value * Item.Value) / 3);
        end;

        Item.Owner := Targets[SafeMod(Item.Value, Check) = 0];
      end;
    until Item.Owner < J;
  end;

begin
  Scroll;
  Write('Simulating item starting as ', Item.Value:0:0, ' from monkey ', Item.Owner, '...');

  for I := 1 to 20 do Round;
  Dump;
end;

function MultMod(A, B: Real): Real;
var
  PartA, PartMult: Real;
begin
  if (A <= 1) or (B <= 1) or ((A <= Limit) and (B <= Limit)) then
    MultMod := SafeMod(A * B, Modulus)
  else
  begin
    PartA    := Int(A / Divisor);

    PartMult := MultMod(PartA, B);

    MultMod  := SafeMod(SafeMod(PartMult * Divisor, Modulus) + 
                SafeMod(B * SafeMod(A, Divisor), Modulus), Modulus);
  end;
end;

function HashKey(var Item: TItem): Integer;
begin
  HashKey := Abs(Item.Words[0] xor Item.Words[1] xor Item.Words[2]) mod 301;
end;

procedure ClearCache;
var
  I, J: Integer;
begin
  for I := 0 to 7 do
    for J := 0 to 300 do
      Cache[I, J].Round := 0;
end;

function AccessCache(var Item: TItem; Round: Integer): Integer;
var
  I, J: Integer;
  R: Real;
begin
  I := HashKey(Item);
  J := Cache[Item.Owner, I].Round;
  while J <> 0 do
  begin
    if Cache[Item.Owner, I].Value = Item.Value then
    begin
      AccessCache := J;
      Exit;
    end;

    I := (I + 1) mod 301;
    J := Cache[Item.Owner, I].Round;
  end;

  Cache[Item.Owner, I].Round := Round;
  Cache[Item.Owner, I].Value := Item.Value;

  AccessCache := 0;
end;


procedure Part2(var Item: TItem);
var
  I, Length, Cycles, Start, Rest: Integer;
  A, B: array[0..7] of Real;

  procedure Round;
  var
    J: Integer;   
  begin
    repeat
      J := Item.Owner;
      with Monkeys[J] do
      begin
        Activity := Activity + 1;
        case Operation of
          '+': Item.Value := SafeMod(Item.Value + Argument, Modulus);
          '*': Item.Value := SafeMod(Item.Value * Argument, Modulus);
          '^': Item.Value := MultMod(Item.Value, Item.Value);
        end;

        Item.Owner := Targets[SafeMod(Item.Value, Check) = 0];
      end;
    until Item.Owner < J;
  end;

begin
  Scroll;
  Write('Simulating item starting as ', Item.Value:0:0, ' from monkey ', Item.Owner, '...');

  ClearCache;

  I := 0;
  repeat
    Round;
    I := I + 1;
    Start := AccessCache(Item, I);
  until Start <> 0;
 
  Length := I - Start;
  Rest := (10000 - Start) mod Length;

  Dump;
  Scroll;
  Write('-> 1st cycle complete. Length is ', Length, ' rounds (', Start, '-', I, '), item is now ', Item.Value:0:0, '.');

  for I := 0 to 7 do
    A[I] := Monkeys[I].Activity;

  for I := 1 to Rest do
    Round;

  Dump;

  for I := 0 to 7 do
    B[I] := Monkeys[I].Activity;

  for I := Rest + 1 to Length do
    Round;

  Cycles := (10000 - Start) / Length - 2;

  Dump;
  Scroll;
  Write('-> 2nd cycle complete. Fast forward ', Cycles, ' cycles plus ', Rest, ' individual rounds.');

  for I := 0 to 7 do
    Monkeys[I].Activity := Monkeys[I].Activity + (Monkeys[I].Activity - A[I]) * Cycles + (B[I] - A[I]);

  Dump;
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

  Scroll;
  Write('--- Part 1 ---');
  Scroll;

  for I := 0 to NumItems - 1 do
    Part1(Items[I]);

  GotoXY(1, 3);
  Write('Part 1: ', GetBusiness:0:0);

  Load;
  Dump;

  Scroll;
  Scroll;
  Write('--- Part 2 ---');
  Scroll;

  GotoXY(61, 3);
  Write('Modulus: ', Modulus:0:0);

  for I := 0 to NumItems - 1 do
    Part2(Items[I]);

  GotoXY(21, 3);
  Write('Part 2: ', GetBusiness:0:0);

  GotoXY(1, 6);
  Write(#27'J'#27'e');
end.
