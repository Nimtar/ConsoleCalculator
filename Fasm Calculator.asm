format PE console

entry start
include 'win32a.inc'

section '.data' data readable writable

        msg1 db "Test %d",0dh,0ah,0

        entr db 'Enter %s ',0
        _1st db 'A:',0
        _2nd db 'B:',0
        _3rd db 'operation:',0
        infinity db 'infinity (well, this is a moot point...)', 0
        res db 'result: %d',0
        res2 db 'integer part %d',0
        nullsimbol db  ' ',0
        res3 db '/%d',0
        itpt db ' %d',0
        nthn db '%d',0
        point db ',',0
        A dd ?
        B dd ?
        C dd ?

section '.text' code readable executable

start:

cinvoke printf, entr,_1st
cinvoke scanf, itpt, A
cinvoke printf, entr,_2nd
cinvoke scanf, itpt, B
cinvoke printf, entr,_3rd


mov eax, '1'

invoke getch
cmp eax,43   ; '+' sign code
jnz @notAdd
        mov ecx, [A]
        add ecx, [B]
        cinvoke printf, res, ecx
        jmp @finish
@notAdd:

cmp eax,45   ; '-' sign code
jnz @notSub
        mov ecx, [A]
        sub ecx, [B]
        cinvoke printf, res, ecx
        jmp @finish

@notSub:

cmp eax,42   ; '*' sign code
jnz @notMul
        mov ecx, [A]
        imul ecx, [B]
        cinvoke printf, res, ecx
        jmp @finish
@notMul:


cmp eax,37   ; '/' sign code
jnz @notDiv
; Gives the answer as an integer quotient and a remainder,
; if remainder not equal to zero
        mov eax, [A]
        mov ecx, [B]
        mov edx, 0

        cmp [B], 0
        jnz @fractionNotZero
                cinvoke printf, infinity
                jmp @finish
        @fractionNotZero:

        div ecx
        mov [C], edx
        cinvoke printf, res, eax
        cinvoke printf, itpt, [C]
        cinvoke printf, res3, [B]
        jmp @finish
@notDiv:

cmp eax,47   ; '%' code sign
jnz @notDiv2
; Gives answer as a decmal fraction with comma as decimal separator
; and exactly 4 digits after separtator
        mov eax, [A]
        mov ecx, [B]
        mov edx, 0

        cmp [B], 0
        jnz @fractionNotZero2
                cinvoke printf, infinity
                jmp @finish
        @fractionNotZero2:

        div ecx
        mov [C], edx
        cinvoke printf, res, eax
        cinvoke printf, point            ;prints decimal separator

        mov ebx, 0
        @loop:
                mov eax, [C]
                mov ecx, [B]
                imul eax, 10
                mov edx, 0
                div ecx
                mov [C], edx
                cinvoke printf, nthn, eax
                add ebx, 1
        cmp ebx, 4                       ;number of digits in fractional part
        jnz @loop

        jmp @finish
@notDiv2:

@finish:
invoke getch    ;waiting for any key pressed
invoke ExitProcess, 0

section '.idata' import data readable
library kernel,'kernel32.dll',\
msvcrt,'msvcrt.dll'

import kernel,\
ExitProcess,'ExitProcess'

import msvcrt,\
printf,'printf',\
scanf,'scanf',\
getch,'_getch'
