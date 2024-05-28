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
	
<<<<<<< HEAD
	// RECORDATORIOS: Tratar de ver porque dibujar_estrella no se pinta del color que quiero

=======
	mov x3, 300
	mov x4, 300
	mov w10, 0xFFFFFF
>>>>>>> 8a923674543fe46910d40676ff3eb0ef4959f2e2
	bl draw_satelite

	mov x3, 320
	mov x4, 240
	mov x5, 150
<<<<<<< HEAD
	bl draw_earth 

	//Dibuja saturno
	movz x10,0xb6,lsl 16
	movk x10,0x8355,lsl 00
	bl dibujar_circulo
	mov x3,320
	mov x4,240
	bl bucket
	add x5,x3,150
	sub x3,x3,150
	movz x10,0xa7,lsl 16
	movk x10,0x7c53,lsl 00
	bl bridge
	add x3,x3,3
	sub x5,x5,3
	sub x4,x4,30
	bl bridge
	sub SP,SP,8
	stur x3,[SP]
	mov x3,320
	add x4,x4,30
	bl bucket
	ldur x3,[SP]
	add SP,SP,8
	add x4,x4,30
	bl bridge
	add x3,x3,10
	sub x5,x5,10
	sub x4,x4,90
	bl bridge
	add x4,x4,120
	bl bridge
	//Termina saturno
=======
	bl draw_saturn
>>>>>>> 8a923674543fe46910d40676ff3eb0ef4959f2e2


InfLoop:
    b InfLoop

