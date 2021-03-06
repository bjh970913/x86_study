%include "init.inc"

segment .text
section .text

[extern printk]
[extern TimerHandler]
[extern schedule]
[extern KeyboardHandler]
[extern FloppyHandler]
[extern print_hex]
[extern IgnorableInterrupt]
[extern SystemCallEntry]
[extern H_isr_00]
[extern H_isr_01]
[extern H_isr_02]
[extern H_isr_03]
[extern H_isr_04]
[extern H_isr_05]
[extern H_isr_06]
[extern H_isr_07]
[extern H_isr_08]
[extern H_isr_09]
[extern H_isr_10]
[extern H_isr_11]
[extern H_isr_12]
[extern H_isr_13]
[extern H_isr_14]
[extern H_isr_15]
[extern H_isr_17]

[global LoadIDT]
[global EnablePIC]

[global isr_ignore]
[global isr_32_timer]
[global isr_33_keyboard]
[global isr_38_floppy]
[global isr_128_soft_int]
[global isr_00]
[global isr_01]
[global isr_02]
[global isr_03]
[global isr_04]
[global isr_05]
[global isr_06]
[global isr_07]
[global isr_08]
[global isr_09]
[global isr_10]
[global isr_11]
[global isr_12]
[global isr_13]
[global isr_14]
[global isr_15]
[global isr_17]

LoadIDT:
    push ebp
    mov ebp, esp

    mov [idtr], word 256*8-1
    mov [idtr_addr], dword IDT_BASE

    lidt [idtr]

    pop ebp
    ret

EnablePIC:
    mov al, 0xBC ;  1011 1100
    ; mov al, 0xBD ;  1111 1101 ; 키보드만
    out 0x21, al
    sti
    ret

isr_ignore:
    push gs
    push fs
    push es
    push ds
    pushad

    mov ax, SysDataSelector
    mov DS, ax
    mov ES, ax
    mov FS, ax
    mov GS, ax

    mov al, 0x20
    out 0x20, al

    call IgnorableInterrupt

    popad
    pop ds
    pop es
    pop fs
    pop gs

    iret

isr_32_timer:
    push gs
    push fs
    push es
    push ds
    pushad

    mov ax, SysDataSelector
    mov DS, ax
    mov ES, ax
    mov FS, ax
    mov GS, ax

    mov al, 0x20
    out 0x20, al

    call TimerHandler
    call schedule

    popad
    pop ds
    pop es
    pop fs
    pop gs

    iret
isr_33_keyboard:
    push gs
    push fs
    push es
    push ds
    pushad

    mov cx, SysDataSelector
    mov DS, cx
    mov ES, cx
    mov FS, cx
    mov GS, cx

    mov al, 0x20
    out 0x20, al

    xor eax, eax
    in al, 0x60

    push eax
    call KeyboardHandler
    add esp, 0x04

    popad
    pop ds
    pop es
    pop fs
    pop gs
    
    iret
isr_38_floppy:
    push gs
    push fs
    push es
    push ds
    pushad

    mov ax, SysDataSelector
    mov DS, ax
    mov ES, ax
    mov FS, ax
    mov GS, ax

    mov al, 0x20
    out 0x20, al

    call FloppyHandler

    popad
    pop ds
    pop es
    pop fs
    pop gs

    iret
isr_128_soft_int:
jmp $
    push gs
    push fs
    push es
    push ds
    pushad

    push eax
    mov ax, SysDataSelector
    mov DS, ax
    mov ES, ax
    mov FS, ax
    mov GS, ax
    pop eax

    call SystemCallEntry

    popad
    pop ds
    pop es
    pop fs
    pop gs

    iret
isr_00:
    push gs
    push fs
    push es
    push ds
    pushad

    mov ax, SysDataSelector
    mov DS, ax
    mov ES, ax
    mov FS, ax
    mov GS, ax

    call H_isr_00

    popad
    pop ds
    pop es
    pop fs
    pop gs

    iret
isr_01:
    push gs
    push fs
    push es
    push ds
    pushad

    mov ax, SysDataSelector
    mov DS, ax
    mov ES, ax
    mov FS, ax
    mov GS, ax

    call H_isr_01

    popad
    pop ds
    pop es
    pop fs
    pop gs

    iret
isr_02:
    push gs
    push fs
    push es
    push ds
    pushad

    mov ax, SysDataSelector
    mov DS, ax
    mov ES, ax
    mov FS, ax
    mov GS, ax

    call H_isr_02

    popad
    pop ds
    pop es
    pop fs
    pop gs

    iret
isr_03:
    push gs
    push fs
    push es
    push ds
    pushad

    mov ax, SysDataSelector
    mov DS, ax
    mov ES, ax
    mov FS, ax
    mov GS, ax

    call H_isr_03

    popad
    pop ds
    pop es
    pop fs
    pop gs

    iret
isr_04:
    push gs
    push fs
    push es
    push ds
    pushad

    mov ax, SysDataSelector
    mov DS, ax
    mov ES, ax
    mov FS, ax
    mov GS, ax

    call H_isr_04

    popad
    pop ds
    pop es
    pop fs
    pop gs

    iret
isr_05:
    push gs
    push fs
    push es
    push ds
    pushad

    mov ax, SysDataSelector
    mov DS, ax
    mov ES, ax
    mov FS, ax
    mov GS, ax

    call H_isr_05

    popad
    pop ds
    pop es
    pop fs
    pop gs

    iret
isr_06:
    push gs
    push fs
    push es
    push ds
    pushad

    mov ax, SysDataSelector
    mov DS, ax
    mov ES, ax
    mov FS, ax
    mov GS, ax

    call H_isr_06

    popad
    pop ds
    pop es
    pop fs
    pop gs

    iret
isr_07:
    push gs
    push fs
    push es
    push ds
    pushad

    mov ax, SysDataSelector
    mov DS, ax
    mov ES, ax
    mov FS, ax
    mov GS, ax

    call H_isr_07

    popad
    pop ds
    pop es
    pop fs
    pop gs

    iret
isr_08:
    push gs
    push fs
    push es
    push ds
    pushad

    mov ax, SysDataSelector
    mov DS, ax
    mov ES, ax
    mov FS, ax
    mov GS, ax

    call H_isr_08

    popad
    pop ds
    pop es
    pop fs
    pop gs

    iret
isr_09:
    push gs
    push fs
    push es
    push ds
    pushad

    mov ax, SysDataSelector
    mov DS, ax
    mov ES, ax
    mov FS, ax
    mov GS, ax

    call H_isr_09

    popad
    pop ds
    pop es
    pop fs
    pop gs

    iret
isr_10:
    push gs
    push fs
    push es
    push ds
    pushad

    mov ax, SysDataSelector
    mov DS, ax
    mov ES, ax
    mov FS, ax
    mov GS, ax

    call H_isr_10

    popad
    pop ds
    pop es
    pop fs
    pop gs

    iret
isr_11:
    push gs
    push fs
    push es
    push ds
    pushad

    mov ax, SysDataSelector
    mov DS, ax
    mov ES, ax
    mov FS, ax
    mov GS, ax

    call H_isr_11

    popad
    pop ds
    pop es
    pop fs
    pop gs

    iret
isr_12:
    push gs
    push fs
    push es
    push ds
    pushad

    mov ax, SysDataSelector
    mov DS, ax
    mov ES, ax
    mov FS, ax
    mov GS, ax

    call H_isr_12

    popad
    pop ds
    pop es
    pop fs
    pop gs

    iret
isr_13:
    push gs
    push fs
    push es
    push ds
    pushad

    mov ax, SysDataSelector
    mov DS, ax
    mov ES, ax
    mov FS, ax
    mov GS, ax

    call H_isr_13

    popad
    pop ds
    pop es
    pop fs
    pop gs

    iret
isr_14:
    push gs
    push fs
    push es
    push ds
    pushad

    mov ax, SysDataSelector
    mov DS, ax
    mov ES, ax
    mov FS, ax
    mov GS, ax

    call H_isr_14

    popad
    pop ds
    pop es
    pop fs
    pop gs

    iret
isr_15:
    push gs
    push fs
    push es
    push ds
    pushad

    mov ax, SysDataSelector
    mov DS, ax
    mov ES, ax
    mov FS, ax
    mov GS, ax

    call H_isr_15

    popad
    pop ds
    pop es
    pop fs
    pop gs

    iret
isr_17:
    push gs
    push fs
    push es
    push ds
    pushad

    mov ax, SysDataSelector
    mov DS, ax
    mov ES, ax
    mov FS, ax
    mov GS, ax

    call H_isr_17

    popad
    pop ds
    pop es
    pop fs
    pop gs

    iret

segment .data

idtr:
    dw 256*8-1
idtr_addr:
    dd IDT_BASE
