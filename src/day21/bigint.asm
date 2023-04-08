;
; Unsigned big integer math routines adapted from:
;
; Leventhal / Saville: Z80 Assembly Language Subroutines
;

;
; BigAdd: HL^ := HL^+ DE^
;
bigadd:
#local
        ld      b,8
        and     a
        ex      af,af'
bigadd1:
        ex      af,af'
        ld      a,(de)
        adc     (hl)
        ld      (hl),a
        ex      af,af'
        inc     hl
        inc     de
        djnz    bigadd1
        ret
#endlocal

;
; BigSub: HL^ := HL^ - DE^
;
bigsub:
#local
        ex      de,hl
        ld      b,8
        and     a
        ex      af,af'
bigsub1:
        ex      af,af'
        ld      a,(de)
        sbc     (hl)
        ld      (de),a
        ex      af,af'
        inc     hl
        inc     de
        djnz    bigsub1
        ret
#endlocal

;
; BigMul: HL^ := HL^ * DE^
;
bigmul:
#local
        ld      c,8
        ld      b,0
        add     hl,bc
        ex      de,hl
        ld      (mlier),hl
        ld      hl,hiprod
        add     hl,bc
        ld      (endhp),hl

        ld      l,c
        ld      h,b
        add     hl,hl
        add     hl,hl
        add     hl,hl
        inc     hl
        ld      (count),hl
zeropd:
        ld      b,c
        ld      hl,hiprod
zerolp:
        ld      (hl),0
        inc     hl
        djnz    zerolp

        and     a
loop:
        ld      b,c
        ld      hl,(endhp)
srplp:
        dec     hl
        rr      (hl)
        djnz    srplp

        ld      l,e
        ld      h,d
        ld      b,c
srailp:
        dec     hl
        rr      (hl)
        djnz    srailp

        jp      nc,deccnt

        push    de
        ld      de,(mlier)
        ld      hl,hiprod
        ld      b,c
        and     a
addlp:
        ld      a,(de)
        adc     a,(hl)
        ld      (hl),a
        inc     de
        inc     hl
        djnz    addlp
        pop     de

deccnt:
        ld      a,(count)
        dec     a
        ld      (count),a
        jp      nz,loop
        push    af
        ld      a,(count+1)
        and     a
        jp      z,exit
        dec     a
        ld      (count+1),a
        pop     af
        jp      loop
exit:
        pop     af
        ret

count:  ds      2
endhp:  ds      2
mlier:  ds      2
hiprod: ds      8
#endlocal

;
; BigDiv: HL^ := HL^ / DE^ and DE^ := HL^ % DE^
;
bigdiv:
#local
        ld      (dvend),hl
        ld      (dvsor),de
        push    bc
        ld      c,8

        ld      l,c
        ld      h,0
        add     hl,hl
        add     hl,hl
        add     hl,hl
        inc     hl
        ld      (count),hl

        ld      hl,hide1
        ld      de,hide2
        ld      b,c
        sub     a
zerolp:
        ld      (hl),a
        ld      (de),a
        inc     hl
        inc     de
        djnz    zerolp

        ld      hl,hide1
        ld      (hdeptr),hl

        ld      hl,hide2
        ld      (odeptr),hl

        ld      hl,(dvsor)
        ld      b,c
        sub     a
chkolp:
        or      (hl)
        inc     hl
        djnz    chkolp
        or      a
        jr      z,erexit

        or      a

loop:
        ld      b,c
        ld      hl,(dvend)
sllp1:
        rl      (hl)
        inc     hl
        djnz    sllp1

deccnt:
        ld      a,(count)
        dec     a
        ld      (count),a
        jr      nz,cont
        ld      a,(count+1)
        dec     a
        ld      (count+1),a
        jp      m,okexit

cont:
        ld      hl,(hdeptr)
        ld      b,c
sllp2:
        rl      (hl)
        inc     hl
        djnz    sllp2

        push    bc
        ld      a,c
        ld      (subcnt),a
        ld      bc,(odeptr)
        ld      de,(hdeptr)
        ld      hl,(dvsor)
        or      a
sublp:
        ld      a,(de)
        sbc     a,(hl)
        ld      (bc),a
        inc     hl
        inc     de
        inc     bc
        ld      a,(subcnt)
        dec     a
        ld      (subcnt),a
        jr      nz,sublp
        pop     bc

        ccf
        jr      nc,loop
        ld      hl,(hdeptr)
        ld      de,(odeptr)
        ld      (odeptr),hl
        ld      (hdeptr),de

        jp      loop

erexit:
        scf
        jp      exit

okexit:
        or      a

exit:
        ld      hl,(hdeptr)
        pop     de
        ld      bc,8
        ldir

        ret

dvend:  ds      2
dvsor:  ds      2
hdeptr: ds      2
odeptr: ds      2
count:  ds      2
subcnt: ds      1
hide1:  ds      8
hide2:  ds      8
#endlocal
