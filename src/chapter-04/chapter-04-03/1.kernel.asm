%include "init.inc"

[org 0x10000]
[bits 32]

PM_Start:
    mov bx, SysDataSelector
    mov ds, bx
    mov es, bx
    mov fs, bx
    mov gs, bx
    mov ss, bx
    lea esp, [PM_Start]

    mov edi, 0
    lea esi, [msgPMode]
    call printf

    cld
    mov ax, SysDataSelector
    mov es, ax
    xor eax, eax
    xor ecx, ecx
    mov ax, 256
    mov edi, 0

loop_idt:
    lea esi, [idt_ignore]
    mov cx, 8
    rep movsb
    dec ax
    jnz loop_idt

    mov edi, 8*0x20
    lea esi, [idt_timer]
    mov cx, 8
    rep movsb

    mov edi, 8*0x21
    lea esi, [idt_keyboard]
    mov cx, 8
    rep movsb

    lidt [idtr]

    mov al, 0xfc  ;; OCW(1) 11111100 -> Allow IRQ#1 (which is keyboard)
    out 0x21, al

    sti             ; 인터럽트 활성화

    jmp $

printf:
    push eax
    push es
    mov ax, VideoSelector
    mov es, ax
printf_loop:
    mov al, byte [esi]
    mov byte [es:edi], al
    inc edi
    mov byte [es:edi], 0x06
    inc esi
    inc edi
    or al, al
    jz printf_end
    jmp printf_loop
printf_end:
    pop es
    pop eax
    ret

msgPMode db "We are in Protected Mode", 0
msg_isr_ignore db "This is an ignorable interrupt", 0
msg_isr_32_timer db "A_This is the timer interrupt", 0
msg_isr_33_keyboard db "A_This Keyboard interrupt", 0

idtr:
    dw 256*8-1
    dd 0


;************************************
;***  interrupt Service Routines  ***
;************************************

isr_ignore:
    push gs
    push fs
    push es
    push ds
    pushad
    pushfd

    mov al, 0x20
    out 0x20, al

    mov ax, VideoSelector
    mov es, ax
    mov edi, (80*2 * 2)
    lea esi, [msg_isr_ignore]
    call printf

    popfd
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
    pushfd

    mov al, 0x20
    out 0x20, al

    mov ax, VideoSelector
    mov es, ax
    mov edi, (80*2 * 4)
    lea esi, [msg_isr_32_timer]
    inc byte [msg_isr_32_timer]
    call printf

    popfd
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
    pushfd

    in al, 0x60
    mov byte [msg_isr_33_keyboard], al

    mov al, 0x20
    out 0x20, al

    mov ax, VideoSelector
    mov es, ax
    mov edi, (80*2 * 6)
    lea esi, [msg_isr_33_keyboard]
    ; inc byte [msg_isr_33_keyboard]
    call printf

    popfd
    popad
    pop ds
    pop es
    pop fs
    pop gs

    iret

;************************************
;***             IDT              ***
;************************************

idt_ignore:
    dw isr_ignore
    dw SysCodeSelector
    db 0
    db 0x8e
    dw 0x0001

idt_timer:
    dw isr_32_timer
    dw SysCodeSelector
    db 0
    db 0x8e
    dw 0x0001

idt_keyboard:
    dw isr_33_keyboard
    dw SysCodeSelector
    db 0
    db 0x8e
    dw 0x0001

times 512 - ( $ - $$ ) db 0
