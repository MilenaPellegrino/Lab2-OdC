	//.include "help.s"
	.include "drawings.s"

	.equ SCREEN_WIDTH,   640
	.equ SCREEN_HEIGH,   480
	.equ BITS_PER_PIXEL, 32

	.equ GPIO_BASE,    0x3f200000
	.equ GPIO_GPFSEL0, 0x00
	.equ GPIO_GPLEV0,  0x34

	.globl main

main:
	// x0 contiene la direccion base del framebuffer
	mov x20, x0 // Guarda la dirección base del framebuffer en x20

	//---------------- CODE HERE ------------------------------------
	// Color de fondo: azul oscuro 
	#0F061B
	movz x10, 0x0f06, lsl 16
	movk x10, 0x1b, lsl 00

	mov x2, SCREEN_HEIGH         // Y Size
loop1:
	mov x1, SCREEN_WIDTH         // X Size
loop0:
	stur w10,[x0]  // Colorear el pixel N
	add x0,x0,4    // Siguiente pixel
	sub x1,x1,1    // Decrementar contador X
	cbnz x1,loop0  // Si no terminó la fila, salto
	sub x2,x2,1    // Decrementar contador Y
	cbnz x2,loop1  // Si no es la última fila, salto


	// Trato de pintar pixeles en pantalla:
	mov x3, 185 		// Coordenada x donde lo voy a pintar
	mov x4, 240		// Coordenada y donde lo voy a pintar
	mov w10, 0xFFFFFF	//EL color del pixel que voy a pintar
	bl pintar_pixel

	mov x3, 455		// Coordenada x donde lo voy a pintar
	mov x4, 240		// Coordenada y donde lo voy a pintar
	mov w10, 0xFFFFFF	//EL color del pixel que voy a pintar
	bl pintar_pixel

	mov x3, 320		// Coordenada x donde lo voy a pintar
	mov x4, 105		// Coordenada y donde lo voy a pintar
	mov w10, 0xFFFFFF	//EL color del pixel que voy a pintar
	bl pintar_pixel

	mov x3, 320		// Coordenada x donde lo voy a pintar
	mov x4, 375		// Coordenada y donde lo voy a pintar
	mov w10, 0xFFFFFF	//EL color del pixel que voy a pintar
	bl pintar_pixel
	
	// Trato  con la funcion del rectangulo 
	mov x3, 540 	// Coordenada en x 
	mov x4, 380		// Coordenada en y 
	mov x1, 100		// Ancho del recntagulo
	mov x2, 100		// Altura del recntagulo = ancho del rectangulo para hacer un cuadrado
	mov w10, 0xFFFFFF 
	bl dibujar_rectangulo

	// Trato de dibujar una circunsferencia 
	mov x3, 320 		// Coor x del centro de la circun
	mov x4, 240		// Coord y del centro de la circuns 
	mov x5, 150		// Radio de la circuns 
	mov w10, 0xFFFFFF  // COLOR 
	bl dibujar_circulo

	// Trato de dibujar la estrell 1 
	mov x2, 100
	mov x1, 200
	bl dibujar_estrella1



	// Ejemplo de uso de gpios
	mov x9, GPIO_BASE

	// Atención: se utilizan registros w porque la documentación de broadcom
	// indica que los registros que estamos leyendo y escribiendo son de 32 bits

	// Setea gpios 0 - 9 como lectura
	str wzr, [x9, GPIO_GPFSEL0]

	// Lee el estado de los GPIO 0 - 31
	ldr w10, [x9, GPIO_GPLEV0]

	// And bit a bit mantiene el resultado del bit 2 en w10 (notar 0b... es binario)
	// al inmediato se lo refiere como "máscara" en este caso:
	// - Al hacer AND revela el estado del bit 2
	// - Al hacer OR "setea" el bit 2 en 1
	// - Al hacer AND con el complemento "limpia" el bit 2 (setea el bit 2 en 0)
	and w11, w10, 0b00000010

	// si w11 es 0 entonces el GPIO 1 estaba liberado
	// de lo contrario será distinto de 0, (en este caso particular 2)
	// significando que el GPIO 1 fue presionado

	//---------------------------------------------------------------
	// Infinite Loop

InfLoop:
	b InfLoop
