.include "movimiento_astronauta.s"
.equ SCREEN_WIDTH,   640
.equ SCREEN_HEIGHT,  480
.equ BITS_PER_PIXEL, 32

.equ GPIO_BASE,    0x3f200000
.equ GPIO_GPFSEL0, 0x00
.equ GPIO_GPLEV0,  0x34

.equ vel_meteorito, 5	// Velocidad del meteorito 
.globl main

// Bucle infinito para la animacion 
	InfLoop:
		cmp x2, 320	// Nos vamos a mover hasta donde este saturno mas o menos
		b.ge InfLoop_op_normales

			// Reiniciamos los valores de <x> y de <y>
			mov x1,0
			mov x2,0
			//eor x8,x8,1
			//mov x5,1
		InfLoop_op_normales:

		sub x7,x7,1		// Decrementamos para controlar el ritmo de la animacion 

		// Dibujamos todo lo que hay en nuestra pantalla
		bl fondo_degrade
		bl fondo_estrella

		bl dibujar_astronauta
		mov x3, 320
		mov x4, 240
		mov x5, 150
		bl draw_saturn

		mov x3, x1
		mov x4, x2
		bl draw_meteorito

		add x1, x1, 1
		add x2, x2, 1
		cbnz x7, InfLoop

		sub x1,x1,1
		sub x2,x2,1
		ldr x7,=MOV_SOL

		mov x5,0

		mov x0,0xffffff
		loop:
			sub x0,x0,1
			cbnz x0,loop
		b InfLoop


main:
<<<<<<< HEAD
	mov x2, 0	// En x2 guardamos la direccion vertical (y) que vamos a mover al meteorito 
	mov x1, 0 	// En x1 guardamos la direccion horizontal (x) que vamos a mover al meteorito
	mov x7, vel_meteorito	// Guardamos en x7 la velocidad del meteorito 
=======
    // x0 contiene la direccion base del framebuffer
    mov x20, x0 // Guarda la dirección base del framebuffer en x20

	bl margen_pantalla
	bl laberinto
	mov x3, 25
	mov x4, 435
	bl dibujar_astronauta
	bl mover_astronauta
InfLoop:
	b InfLoop

moon:
	mov x0, x20
	movz w10, 0x29, lsl 16
	movk w10, 0x2936, lsl 00 //color del fondo

	bl fondo_degrade
	bl fondo_estrella

	mov x3, 320
	mov x4, 240
	mov x5, 150
	bl draw_moon

	mov x3, 300
	mov x4, 300
	mov w10, 0xFFFFFF
	bl draw_satelite

	b InfLoop

>>>>>>> 220ce6381e58a0c77f6478edd765da026e40d1fe
