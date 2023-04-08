program Flow;

{$I /Users/joerg/Projekte/pl0/lib/Files.pas}

type
  TPiece = array[0..3] of Integer;

  TCache = record
    case Boolean of
      True:    (Fingerprint: array[0..2] of Byte;
                NextPiece :   Byte;
                NextJet:     Integer;
                Count:       Integer;
                Height:      Integer; );
      False:   (Raw: array[0..4] of Integer; );
  end;

const
  Pieces: array[0..4] of TPiece = (
    ($3c, $00, $00, $00),
    ($10, $38, $10, $00),
    ($38, $08, $08, $00),
    ($20, $20, $20, $20),
    ($30, $30, $00, $00)
  );

  Heights: array[0..4] of Byte = (1, 3, 3, 4, 2);

  MapSize = 6144;

  CacheSize = 3001;

var
  Map: array[0..6143] of Byte;

  Jet: array[0..10099] of Char;

  JetSize, I: Integer;

  Cache: array[0..3000] of TCache;

procedure ConOut(C: Char); register;
inline (
  $4d /                 (* ld c,l           *)
  $2a / $01 / $00 /     (* ld hl,($0001)    *)
  $11 / $09 / $00 /     (* ld de, $0009     *)
  $19 /                 (* add hl,de        *)
  $e9                   (* jp (hl)          *)
);

function Max(I, J: Integer): Integer;
begin
  if I >= J then Max := I else Max := J;
end;

function SafeMod(A, B: Real): Real;
begin
  SafeMod := A - Int(A / B) * B;
end;

procedure LoadJet;
var
  T: Text;
  C: Char;
begin
  JetSize := 0;

  Assign(T, 'INPUT   .TXT');
  Reset(T);
  while not IsEof(T) do
  begin
    C := ReadChar(T);
    if C >= ' ' then
    begin
      Jet[JetSize] := C;
      Inc(JetSize);
    end;
  end;
  Close(T);
end;

procedure InitCache;
var
  I: Integer;
begin
  for I := 0 to CacheSize - 1 do
    Cache[I].Count := 0;
end;

function HashKey(var Item: TCache): Integer;
begin
  HashKey := Abs(Item.Raw[0] xor Item.Raw[1] xor Item.Raw[2] xor Item.Raw[3] xor Item.Raw[4]) mod CacheSize;
end;

function CacheEquals(var A, B: TCache): Boolean;
var
  I: Integer;
begin
  CacheEquals := False;

  for I := 0 to 2 do
    if A.Raw[I] <> B.Raw[I] then Exit;

  CacheEquals := True;
end;

function AccessCache(var Item: TCache): Boolean;
var
  I, J: Integer;
  R: Real;
begin
  I := HashKey(Item);
  J := Cache[I].Count;
  while J <> 0 do
  begin
    if CacheEquals(Cache[I], Item) then
    begin
      Item.Count := Cache[I].Count;
      Item.Height := Cache[I].Height;
      AccessCache := True;
      Exit;
    end;

    I := (I + 1) mod CacheSize;
    J := Cache[I].Count;
  end;

  Cache[I] := Item;

  AccessCache := False;
end;

procedure WriteBits(B: Byte);
var
  I: Byte;
begin
  for I := 7 downto 1 do
  begin
    if B and $80 <> 0 then
    begin
      ConOut(#27); ConOut('p');
      ConOut(' '); ConOut(' ');
      ConOut(#27); ConOut('q');
    end
    else
    begin
      ConOut(' '); ConOut(' ');
    end;

    B := B shl 1;
  end;
end;

procedure Process;
var
  I, J, M, NextJet, NextPiece, Count, Height, Delta, Position, Pause: Integer;
  MyPiece, Backup: TPiece;
  HaveCycle, Ok: Boolean;
  Item: TCache;
  Target, Count2, Cycle, Factor, A, B: Real;
  S: TString;
begin
  Map[0] := $ff;
  for I := 1 to MapSize - 1 do
    Map[I] := 0;

  Target := 0;

  Pause := 20000;

  NextJet := 0;
  NextPiece := 0;
  Count := 1;
  Height := 0;

  while True do
  begin
    Position := Height + 4;
    MyPiece := Pieces[NextPiece];
    
    GotoXY(9, 3);
    Write(Count);

    while True do
    begin
      Backup := MyPiece;

      if Jet[NextJet] = '<' then
        for I := 0 to 3 do MyPiece[I] := MyPiece[I] shl 1
      else
        for I := 0 to 3 do MyPiece[I] := MyPiece[I] shr 1;

      for I := 0 to 3 do
      begin
        if (Map[Position + I] or $0101) and MyPiece[I] <> 0 then
        begin
          MyPiece := Backup;
          Break;
        end;
      end;

      NextJet := (NextJet + 1) mod JetSize;

      I := 0;
      while (I < 4) and ((Map[Position + I - 1] and MyPiece[I]) = 0) do
        Inc(I);

      if I = 4 then Dec(Position) else
      begin
        for I := 0 to 3 do
          Map[Position + I] := Map[Position + I] or MyPiece[I];

        Height := Max(Height, Position + Heights[NextPiece] - 1);
        NextPiece := (NextPiece + 1) mod 5;

        M := Max(Height - 19, 1);

        for I := 19 downto 0 do
        begin
          GotoXY(33, 3 + 19 - I);
          WriteBits(Map[M + I]);
        end;

        GotoXY(9, 4);
        Write(Height);

        if Count = 2022 then 
        begin
          GotoXY(1, 21);
          Write('Part 1: ', Height);
        end;

        if Height >= 3 then
        begin
          if Count = 2022 then begin end;

          if Target = 0 then
          begin
            for I := 0 to 2 do Item.Fingerprint[I] := Map[Height - I];

            Item.NextJet := NextJet;
            Item.NextPiece := NextPiece;
            Item.Count := Count;
            Item.Height := Height;

            if AccessCache(Item) then
            begin
              Ok := True;
              for I := 0 to 99 do
                if Map[Height - I] <> Map[Item.Height - I] then
                begin
                  Ok := False;
                  Break;
                end;
              end;

            if Ok then
            begin
              Cycle := Count - Item.Count;
              Delta := Height - Item.Height;

              Count2 := Count;
              Factor := Int(1000000.0 * (1000000.0 / Cycle) - Count2 / Cycle);
              Target  := SafeMod(1000000.0 * SafeMod(1000000.0, Cycle) - Count, Cycle) + Count;

              GotoXY(1, 10);
              WriteLn(#27'p    Cycle detected!    '#27'q');
              WriteLn;
              WriteLn('Length: ', Cycle:0:0, ' (', Item.Count, '-', Count, ')');
              WriteLn('Height: ', Delta);
              WriteLn('Factor: ', Factor:0:0);
              WriteLn('Target: ', Target:0:0);
            end;
          end
          else if Target = Count then
          begin
            GotoXY(1, 21);

            A := SafeMod(Factor, 1000000.0) * Delta + Height;
            B := Int(Factor / 1000000.0) * Delta;

            B := B + Int(A / 1000000.0);
            A := SafeMod(A, 1000000.0);

            GotoXY(1, 22);
            Write('Part 2: ', B:0:0, A:0:0);
            Exit;
          end;
        end;

        Inc(Count);
        Break;
      end;
    end;
  end;
end;

begin
  Write(#27'f');

  ClrScr;

  WriteLn('*** AoC 2022.17 Pyroclastic Flow ***');
  WriteLn;
  WriteLn('Pieces: 0');
  WriteLn('Height: 0');


  for I := 19 downto 0 do
  begin
    GotoXY(32, 3 + I);
    Write('|              |');
  end;

  for I := 0 to 3 do
  begin
    GotoXY(55, 3 + I);  WriteBits(Pieces[0, I]);
    GotoXY(65, 6 + I);  WriteBits(Pieces[1, I]);
    GotoXY(53, 11 + I); WriteBits(Pieces[2, I]);
    GotoXY(67, 16 + I); WriteBits(Pieces[3, I]);
    GotoXY(57, 21 + I); WriteBits(Pieces[4, I]);
  end;

  InitCache;

  LoadJet;
  Process;

  GotoXY(1, 23);

  Write(#27'e');
end.
