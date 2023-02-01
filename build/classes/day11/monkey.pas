program Monkey;

{$I /Users/joerg/Projekte/pl0/lib/Files.pas}

type
  TMonkey = record
    Items: array[0..63] of Real;
    Count: Integer;

    OpType: Char;
    OpArg: Real;
    Test: Real;

    IfTrue, IfFalse: Integer;

    Activity: Real;
  end;

const
  Inspect: Integer = 1;

var
  Monkeys: array[0..7] of TMonkey;

  Factor: Real;

  Total: Integer;

procedure Init(var Monkey: TMonkey);
begin
  with Monkey do
  begin
    Count := 0;
    Activity := 0;
  end;
end;

procedure Push(var Monkey: TMonkey; R: Real);
begin
  with Monkey do
  begin
    Items[Count] := R;
    Count := Count + 1;
  end;
end;

function Pop(var Monkey: TMonkey): Real;
begin
  with Monkey do
  begin
    Count := Count - 1;
    Pop := Items[Count];
    Activity := Activity + 1;
  end;
end;

function IsEmpty(var Monkey: TMonkey): Boolean;
begin
  IsEmpty := Monkey.Count = 0;
end;

procedure Load;
var
  I, P, Error: Integer;
  S: TString;
  T: Text;
begin
  Total := 0;

  Assign(T, 'EXAMPLE .TXT');
  Reset(T);

  Factor := 1;

  while not IsEof(T) do
  begin
    ReadLine(T, S);
    Val(Copy(S, 8, 255), I, Error);

    Init(Monkeys[Total]);

    ReadLine(T, S);
    S := Copy(S, 19, 255);
    while Length(S) <> 0 do
    begin
      Val(Copy(S, 1, 2), I, Error);
      Push(Monkeys[Total], I);
      S := Copy(S, 5, 255);
    end;

    ReadLine(T, S);
    Monkeys[Total].OpType := S[24];
    S := Copy(S, 26, 255);
    if S = 'old' then I := -1 else Val(S, I, Error);
    Monkeys[Total].OpArg := I;

    ReadLine(T, S);
    Val(Copy(S, 22, 255), I, Error);
    Monkeys[Total].Test := I;
    Factor := Factor * I;
    
    ReadLine(T, S);
    Val(Copy(S, 30, 255), Monkeys[Total].IfTrue, Error);

    ReadLine(T, S);
    Val(Copy(S, 31, 255), Monkeys[Total].IfFalse, Error);

    ReadLine(T, S);
    
    Total := Total + 1;
  end;

  Close(T);

  WriteLn(Total, ' monkeys, factor is ', Factor:0:0);
  WriteLn;
end;

procedure Dump;
var
  I, J: Integer;
begin
  for I := 0 to Total - 1 do
    with Monkeys[I] do
    begin
      WriteLn('--- Monkey ', I, ' ---');
      WriteLn('  Activity: ', Monkeys[I].Activity:0:0);
      WriteLn('  (new=old ', Monkeys[I].OpType, Monkeys[I].OpArg:0:0, ', test=', Monkeys[I].Test:0:0, ', true=', Monkeys[I].IfTrue, ', false=', Monkeys[I].IfFalse);
      Write('  Items: ', Monkeys[I].Count, ' [');
      for J := 0 to Monkeys[I].Count - 1 do Write(Monkeys[I].Items[J]:0:0, ' ');
      WriteLn(']');
      WriteLn;
    end;
end;

(*
unsigned int multMod(unsigned int a, unsigned int b, unsigned int M) {
    const unsigned int k = 0xffff;
    if (a <= 1 || b <= 1 || (a <= k && b <= k)) {
        return (a * b) % M;
    }
    assert(a < M && b < M);
    printf("multMod(%u, %u, %u)\n", a, b, M);
    unsigned int divisor = 0xffffffff / M;
    assert(divisor > 1);
    unsigned int partA = a / divisor;
    unsigned int partMult = multMod(partA, b, M);
    return ((partMult*divisor % M) + ((b * (a % divisor)) % M)) % M;
}
*)

function MultMod(A, B, M: Real): Real;
var
  K, Divisor, PartA, PartMult: Real;
begin
  K := 65535.0;                                     (* 100000.0 instead? *)

  if (A <= 1) or (B <= 1) or ((A <= K) and (B <= K)) then
    MultMod := (A * B) mod M
  else
  begin
    Assert((A < M) and (B < M));
    WriteLn('MultMod(', A:0:0, ', ', B:0:0, ', ', M:0:0, ')');
    Divisor := Int(4294967295.0 / M);               (* 10000000000.0 instead? *)
    Assert(Divisor > 1.0);
    PartA := Int(A / Divisor);
    PartMult := MultMod(PartA, B, M);
    MultMod := ((PartMult * Divisor mod M) + ((B * (A mod Divisor)) mod M)) mod M;
  end;
end;

procedure Simulate(Part: Integer);
var
  I, J, K: Integer;
  R: Real;
begin
  for I := 0 to Total - 1 do
  begin
    while not IsEmpty(Monkeys[I]) do
    begin
      R := Pop(Monkeys[I]);

      if Monkeys[I].OpType = '+' then
      begin
        if Monkeys[I].OpArg = -1 then 
          R := R + R
        else
          R := R + Monkeys[I].OpArg;
      end
      else if Monkeys[I].OpType = '*' then
      begin
        if Part = 1 then
        begin
          if Monkeys[I].OpArg = -1 then 
            R := R * R
          else
            R := R * Monkeys[I].OpArg;
        end
        else
        begin
          if Monkeys[I].OpArg = -1 then 
            R := MultMod(R, R, Factor)
          else
            R := MultMod(R, Monkeys[I].OpArg, Factor);
        end
      end
      else WriteLn('Invalid OpType ', Monkeys[I].OpType);

      if Part = 1 then
        R := Int(R / 3)
      else
        R := R mod Factor;

      if R mod Monkeys[I].Test = 0 then
        K := Monkeys[I].IfTrue
      else
        K := Monkeys[I].IfFalse;

      Push(Monkeys[K], R);
    end;
  end;
end;

var
  I: Integer;

begin
  Load;
  
  Dump;

  for I := 1 to 10000 do
  begin
    (* WriteLn('Round ', I); *)
    Simulate(2);

    if I = Inspect then
    begin
      WriteLn('After ', I, ' rounds');
      Dump;
      if Inspect = 1 then Inspect := 20 else if Inspect = 20 then Inspect := 1000 else Inspect := Inspect + 1000;
    end;
  end;

  WriteLn;

  Dump;
end.
