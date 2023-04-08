{$L bigint.asm}

type
  BigInt = array[0..7] of Byte;

const
  BigMin: BigInt = (0, 0, 0, 0, 0, 0, 0, 0);
  BigMax: BigInt = (255, 255, 255, 255, 255, 255, 255, 127);
  BigOne: BigInt = (1, 0, 0, 0, 0, 0, 0, 0);
  BigTen: BigInt = (10, 0, 0, 0, 0, 0, 0, 0);

procedure BigAdd(var X, Y: BigInt); register; external 'bigadd';
procedure BigSub(var X, Y: BigInt); register; external 'bigsub';
procedure BigMul(var X, Y: BigInt); register; external 'bigmul';
procedure BigDiv(var X, Y, Z: BigInt); register; external 'bigdiv';

function BigCmp(var X, Y: BigInt): Integer;
var
  I: Integer;
  B: Byte;
begin
  for B := 7 downto 0 do
  begin
    I := X[B] - Y[B];
    if I <> 0 then
    begin 
      BigCmp := I; 
      Exit;
    end;
  end;

  BigCmp := 0;
end;

procedure BigVal(S: TString; var X: BigInt);
var
  B: Byte;
  Y: BigInt;
  I, J: Integer;
begin
  X := BigMin;

  if Length(S) < 3 then
  begin
    Val(S, I, J);
    X[0] := I;
    Exit;
  end;

  Y := BigMin;

  for B := 1 to Length(S) do
  begin
    BigMul(X, BigTen);
    Y[0] := Ord(S[B]) - 48;
    BigAdd(X, Y); 
  end;
end;

procedure BigStr(X: BigInt; var S: TString);
var
  Y: BigInt;
begin
  S := '';

  repeat
    BigDiv(X, BigTen, Y);
    S := '' + Char(48 + Y[0]) + S;
  until BigCmp(X, BigMin) = 0;
end;
