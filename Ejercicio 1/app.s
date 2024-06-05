.include "drawings.s"

.equ SCREEN_WIDTH,   640
.equ SCREEN_HEIGHT,  480
.equ BITS_PER_PIXEL, 32

.equ GPIO_BASE,    0x3f200000
.equ GPIO_GPFSEL0, 0x00
.equ GPIO_GPLEV0,  0x34

.globl main

// Funcion normal 
main:
    // x0 contiene la direccion base del framebuffer
    mov x20, x0 // Guarda la dirección base del framebuffer en x20

	bl fondo_degrade
	bl fondo_estrella

	mov x3, 60
	mov x4, 150
	bl dibujar_astronauta

	mov x3, 458
	mov x4, 150
	bl dibujar_astronauta

	mov x3, 300
	mov x4, 300
	mov w10, 0xFFFFFF
	bl draw_satelite

	mov x3, 320
	mov x4, 240
	mov x5, 150
	bl draw_saturn

	// EMPEZAMOS A METERNOS EN EL HERMOSO Y HORRIBLE MUNDO DEL GPIO 
	//Guardamos en x9 la direccion base del GPIO 
	mov x9, GPIO_BASE	// La direccion base es diferente al del manual se debe a que es emulada
	
	// Cargamos en x12 un valor relativamente grande para poder ver la otra escena por pantalla
	ldr x12, = 0x700000


InfLoop:

