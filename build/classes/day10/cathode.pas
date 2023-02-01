program Cathode;

{$I /Users/joerg/Projekte/pl0/lib/Files.pas}

const
  Cycle:     Integer = 0;     (* Current cycle              *)
  X:         Integer = 1;     (* Register value             *)
  V:         Integer = 0;     (* Value for "delayed add"    *)
  WaitState: Boolean = False; (* For 2-cycle instructions   *)
  Signal:    Integer = 0;     (* Sum of signal strengths    *)
  MeasureAt: Integer = 20;    (* Next data point to measure *)
  BeamPos:   Integer = 1;     (* Current beam position      *)

var
  T: Text;
  S: String;
  Error: Integer;

begin
  WriteLn;
  WriteLn('*** AoC 2022.10 Cathode-Ray Tube ***');
  WriteLn;

  Assign(T, 'INPUT   .TXT');
  Reset(T);

  ReadLine(T, S);
  repeat
    Cycle := Cycle + 1;
    
    (* Signal strength measurement (part 1) *)
    if Cycle = MeasureAt then
    begin
      Signal := Signal + Cycle * X;
      if MeasureAt <= 180 then MeasureAt := MeasureAt + 40;
    end;

    (* CRT output generation (part 2) *)
    if (X >= BeamPos - 2) and (X <= BeamPos) then
      Write('#')
    else
      Write(' ');

    BeamPos := BeamPos + 1;
    if BeamPos = 41 then
    begin
      BeamPos := 1;
      WriteLn;
    end;

    (* Instruction handling *)
    if WaitState then
    begin
      X := X + V;
      WaitState := False;
    end
    else
    begin
      if Copy(S, 1, 4) = 'addx' then
      begin
        Val(Copy(S, 6, 3), V, Error);
        WaitState := True;
      end;
      
      ReadLine(T, S);
    end;
  until IsEof(T);

  Close(T);

  WriteLn;
  WriteLn;
  WriteLn('Signal strengths: ', Signal);
  WriteLn;
end.
