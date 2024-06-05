.include "movimiento_astronauta.s"
.equ SCREEN_WIDTH,   640
.equ SCREEN_HEIGHT,  480
.equ BITS_PER_PIXEL, 32

.equ GPIO_BASE,    0x3f200000
.equ GPIO_GPFSEL0, 0x00
.equ GPIO_GPLEV0,  0x34

.globl main

// Bucle infinito para la animacion 

// Funcion normal 
main:
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

