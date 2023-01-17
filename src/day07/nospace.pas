program NoSpace;

{$I /Users/joerg/Projekte/pl0/lib/files.pas}

procedure Solve;
const
  Total = 70000000.0;
  Needed = 30000000.0;
var
  Used, Avail, Missing, Small: Real;
  T: Text;
  S: String;
  BestName: TString;
  BestSize: Real;
  SmallSum: Real;

  function Traverse(Dir: TString; Pass: Integer): Real;
  var
    Size, R: Real;
    P, Err: Integer;
    S: TString;
  begin          
    WriteLn(#27'APass ', Pass, ': '#27'p', Dir, '':(64-Length(Dir)), #27'q');

    Size := 0;

    while not IsEof(T) do
    begin
      ReadLine(T, S);
      if S = '$ cd ..' then
        Break
      else if Copy(S, 1, 4) = '$ cd' then
      begin
        Size := Size + Traverse(Dir + '/' + Copy(S, 6, 255), Pass);
        WriteLn(#27'APass ', Pass, ': '#27'p', Dir, '':(64-Length(Dir)), #27'q');
      end
      else if Copy(S, 1, 4) = '$ ls' then
        begin (* Nothing *) end
      else
      begin
        P := Pos(' ', S);
        S := Copy(S, 1, P - 1);
        if S <> 'dir' then
        begin
          Val(S, R, Err);
          Size := Size + R; 
        end;
      end;
    end;

    if Pass = 1 then
    begin
      if Size < 100000.0 then SmallSum := SmallSum + Size;
    end
    else (* Pass = 2 *) if (Size >= Missing) and (Size <= BestSize) then
    begin
      BestSize := Size;
      BestName := Dir;
    end;

    Traverse := Size;  
  end;

begin
  WriteLn;
  WriteLn;

  SmallSum := 0;

  Assign(T, 'INPUT   .TXT');
  Reset(T);
  ReadLine(T, S);
  Used := Traverse('', 1);
  Close(T);

  Avail := Total - Used;
  Missing := Needed - Avail;

  WriteLn;
  WriteLn('Disk size: ', Total:8:0, ' bytes');
  WriteLn('Allocated: ', Used:8:0, ' bytes');
  WriteLn('Available: ', Avail:8:0, ' bytes');
  WriteLn;
  WriteLn('Update size is ', Needed:0:0, ' bytes, so we need to find ', Missing:0:0, ' bytes.');
  WriteLn;
  WriteLn;

  BestSize := 999999999.0;

  Assign(T, 'INPUT   .TXT');
  Reset(T);
  ReadLine(T, S);
  Used := Traverse('', 2);
  Close(T);

  WriteLn;
  WriteLn('Deleting directory ', BestName, ' will free ', BestSize:0:0, ' bytes.');
  WriteLn;
  WriteLn('Part 1: ', SmallSum:8:0);
  WriteLn('Part 2: ', BestSize:8:0);
end;

begin
  Write(#27'f');

  ClrScr;

  WriteLn('*** AoC 2022.07 No Space Left On Device ***');

  Solve;

  Write(#27'e');
end.
