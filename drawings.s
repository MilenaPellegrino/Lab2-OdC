.include "help.s"
.equ SCREEN_WIDTH, 		640
.equ SCREEN_HEIGH, 		480	

// Estrella 
// Parametros: x3 = x, x4 = y, w10 = color
// Tamano  estatico (por ahora)

dibujar_estrella: 
	mov x18, x30
	mov x1, 10
	mov x9, x1
	bl dibujar_triangulo3
	
	add x3, x3, 10
	add x4, x4, 5

	mov x1, x9
	bl dibujar_triangulo3_inv

	mov x1, 5

	add x3, x3, 10
	add x4, x4, 1

	bl dibujar_triangulo3
	
	add x3, x3, 5
	add x4, x4, 3

	mov x1, 5
	bl dibujar_triangulo3_inv

	ret x18

draw_sol:
	sub sp, sp, 8
	stur x30, [sp, 0]

	mov x3, SCREEN_WIDTH
		lsr x9, x3, 2
		lsr x3, x3, 1
		add x3, x3, x9

	mov x4, SCREEN_WIDTH
		lsr x4, x4, 3
	mov x5, 30
	bl pintar_circulo


	mov x1, 40
	mov x2, 40
	mov x3, SCREEN_WIDTH
		lsr x9, x3, 2
		lsr x3, x3, 1
		add x3, x3, x9
		sub x3, x3, 20
	mov x4, SCREEN_HEIGH
		lsr x4, x4, 3
	bl dibujar_rectangulo


ldr x30, [sp, 0]
add sp, sp, 8
ret

// DIBUJAR SATELITE 

draw_satelite:
	sub sp, sp, 8
	stur x30, [sp, 0]
	mov w10, 0xFFFFFF	//EL color del pixel que voy a pintar
	// Parametros: x3 = coordenada x del centro, x4 = coordenada y del centro, x5 = radio,  w10 = color
	mov x3, 75
	mov x4, 60 
	mov x5, 10

	bl dibujar_circulo
	// Parametros: x3 = x, x4 = y, ancho del rectangulo = x1, altura del rectangulo = x2, color = w10 
	mov x3, 70 		// Coordenada x donde lo voy a pintar
	mov x4,	50		// Coordenada y donde lo voy a pintar
	mov x1, 40
	mov x2, 20

	bl dibujar_rectangulo
ldr x30, [sp, 0]
add sp, sp, 8
ret





















/* 
dibujar_estrella_fugaz: 
    mov x3, 200          // Initial x coordinate
	mov x4, 200          // Initial y coordinate
	mov x1, 120          // Length of the row
	mov w10, 0xFFFF   // Color (assuming the color is passed in w10)
	bl pintar_fila      // Call the function
ret

*/
// ESTRELLA TITILANDO (PARA LA ANIMACION NO SIRVE PARA ESTO)
// desde x = x3, y = x4, de una longitud de x1 y un color w10
/* dibujar_estrella2:
	mov x10, x1			// Me guardo en x10 la longitud para ir decrementando
	mov x11, x3			// Me guardo en x11 la coordenada inicial de x (es lo que voy a ir modificando)
loop_est2:
	bl pintar_pixel		// pintamos un pixel en la coordenada (x, y). No es necesario mover variables ya que usamos los mismo registros pra obtener las coordenadas
	add x11, x11, 1		// Voy al siguiente pixel en x 
	sub x10, x10, 1		// Decremento mi contador 
	cmp x10, 0 		// if mi contador != 0 sigo pintando 
	b.ne loop_est2		// if mi contado == 0, dejo de pintar ya que pinte toda la longitud de la fila
ret  */
