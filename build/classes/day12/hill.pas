program Hill;

{$I /Users/joerg/Projekte/pl0/lib/Files.pas}

var
  Map: array [0..47] of array [0..63] of Char;

  Cost: array [0..47] of array [0..63] of Integer;

  QueueX, QueueY: array [0..3071] of Integer;

  QueueCount: Integer;

  Height, Width: Integer;

  OriginX, OriginY: Integer;

procedure Load;
var
  T: Text;
  S: TString;
  H: Char;
  I: Integer;
begin
  Assign(T, 'INPUT   .TXT');
  Reset(T);

  Height := 0;

  while not IsEof(T) do
  begin
    ReadLine(T, S);
    for I := 0 to Length(S) - 1 do
    begin
      H := S[I + 1];

      Cost[Height][I] := 9999;

      if H = 'S' then
      begin
        OriginX := Height;
        OriginY := I;
        WriteLn('Origin is at ', OriginX:2, ',', OriginY:2, '.');
        H := 'a';
      end
      else if H = 'E' then
      begin
        WriteLn('Target is at ', Height:2, ',', I:2, '.');
        H := 'z';
        Cost[Height][I] := 0;
        QueueX[0] := Height;
        QueueY[0] := I;
        QueueCount := 1;
      end;

      Map[Height][I] := H;
    end;

    Height := Height + 1;
  end;

  Width := Length(S);

  Close(T);

  WriteLn;
end;

procedure Update(X, Y: Integer; H: Char; C: Integer);
begin
  if Ord(H) <= Ord(Map[X][Y]) + 1 then
    if C + 1 < Cost[X][Y] then
    begin
      Cost[X][Y] := C + 1;
      QueueX[QueueCount] := X;
      QueueY[QueueCount] := Y;
      QueueCount := QueueCount + 1;
    end;
end;

procedure Think;
var
  I, J, C: Integer;
  H: Char;
begin
  QueueCount := QueueCount - 1;
  I := QueueX[QueueCount];
  J := QueueY[QueueCount];

    begin
      H := Map[I][J];
      C := Cost[I][J];

      if I > 0 then 
        Update(I - 1, J, H, C);

      if I < Height - 1 then
        Update(I + 1, J, H, C);

      if J > 0 then
        Update(I, J - 1, H, C);

      if J < Width - 1 then
        Update(I, J + 1, H, C);
    end;
end;

var
  I, J, K, Best, BestX, BestY: Integer;

begin
  WriteLn;
  WriteLn('*** AoC 2022.10 Hill Climbing Algorithm ***');
  WriteLn;

  Load;

  K := 0;

  while QueueCount > 0 do
  begin
    Think;
    K := K + 1;
    if K = 100 then
    begin
      Write('.');
      K := 0;
    end;
  end;

  WriteLn;
  WriteLn;
  WriteLn('Part 1: Trail starting at ', OriginX:2, ',', OriginY:2, ' has cost ', Cost[OriginX][OriginY]);

  Best := 32767;
  BestX := -1;
  BestY := -1;        
        
  for I := 0 to Height - 1 do
    for J := 0 to Width - 1 do
    begin
      if (Map[I][J] = 'a') and (Cost[I][J] < Best) then
      begin
        Best := Cost[I][J];
        BestX := I;
        BestY := J;
      end;
    end;
    
  WriteLn('Part 2: Trail starting at ', BestX:2, ',', BestY:2, ' has cost ', Best);
  WriteLn;
end.
    
