.include "drawings.s"

.equ SCREEN_WIDTH,   640
.equ SCREEN_HEIGHT,  480
.equ BITS_PER_PIXEL, 32

.equ GPIO_BASE,    0x3f200000
.equ GPIO_GPFSEL0, 0x00
.equ GPIO_GPLEV0,  0x34

.globl main

main:
    // x0 contiene la direccion base del framebuffer
    mov x20, x0 // Guarda la dirección base del framebuffer en x20

    movz x10, 0x0000, lsl 16
    movk x10, 0x0000, lsl 00

    mov x2, SCREEN_HEIGHT         // Y Size
loop1:
    mov x1, SCREEN_WIDTH         // X Size
loop0:
	stur w10,[x0]  // Colorear el pixel N
	add x0,x0,4    // Siguiente pixel
	sub x1,x1,1    // Decrementar contador X
	cbnz x1,loop0  // Si no terminó la fila, salto
	sub x2,x2,1    // Decrementar contador Y
	cbnz x2,loop1  // Si no es la última fila, salto

	bl fondo_estrella
	
	mov x3, 300
	mov x4, 300
	mov w10, 0xFFFFFF
	bl draw_satelite

	mov x3, 320
	mov x4, 240
	mov x5, 150
	bl draw_saturn


InfLoop:
    b InfLoop

