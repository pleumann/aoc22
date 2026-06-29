program Pause;

var
  S, Err: Integer;

begin
  if ParamCount = 0 then
    Halt(1);
  Val(ParamStr(1), S, Err);
  if Err <> 0 then
    Halt(1);
    
  {$ifdef SYS_AGON}
  WriteLn; // CP/M prints a newline at the end, Agon doesn't.
  {$endif}

  Delay(S * 1000);  
end.
