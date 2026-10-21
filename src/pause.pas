program Pause;

var
  S, Err, I, OldX, OldY: Integer;

begin
  if ParamCount = 0 then
    Halt(1);
  Val(ParamStr(1), S, Err);
  if Err <> 0 then
    Halt(1);
    
  {$ifdef SYS_AGON}
  WriteLn; // CP/M prints a newline at the end, Agon doesn't.

  OldX := WhereX;
  OldY := WhereY;

  GotoXY(1, 25);
  ClrEos;
  GotoXY(22, 27);
  Write(' https://github.com/pleumann/aoc22');
  GotoXY(22, 29);
  Write('https://github.com/pleumann/pasta80');
  GotoXY(OldX, OldY);
  {$endif}

  Halt;
 
  for I := 1 to S do
  begin
    Write('.');
    Delay(1000);
  end;
end.
