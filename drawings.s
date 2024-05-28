.include "help.s"
.equ SCREEN_WIDTH, 		640
.equ SCREEN_HEIGH, 		480	


// ====== DIBUJAR ESTRELLA TIPO 1 ======
// Parametros: x3 = x, x4 = y, w10 = color
// Tamano  estatico (por ahora) (hecha con dos triangulos)

dibujar_estrella: 
	sub sp, sp, 8
	stur x30, [sp, 0]
	mov x1, 10
	mov x9, x1
	bl dibujar_triangulo3
	
	add x3, x3, 10
	add x4, x4, 5

	mov x1, x9
	bl dibujar_triangulo3_inv

ldr x30, [sp, 0]
add sp, sp, 8
ret
// ====== FIN DE DIBUJAR ESTRELLA TIPO 1 ======


// ====== DIBUJAR PLANETA TIERRA ======
// Parametros: x3 -> x | x4 ->y | x5 -> radio 
// Aclaraciones: (x3, x4) son las coordenadas del centro del circulo

draw_earth: 
	sub sp, sp, 8
	stur x30, [sp, 0]

	// Circulo grande general 
	movz w10, 0x7DAA       // Carga los 16 bits menos significativos
	movk w10, 0x22, lsl 16
	bl pintar_circulo

ldr x30, [sp, 0]
add sp, sp, 8
ret
// ====== FIN PLANETA TIERRA ======


// ====== DIBUJAR SATELITE ======
// Sin paraemtro por ahora, dibujado en el mismo lugar

draw_satelite:
	sub sp, sp, 8
	stur x30, [sp, 0]
	mov w10, 0xFFFFFF	//EL color del pixel que voy a pintar

	// Circulo para redondear parte izquierda
	mov x3, 75
	mov x4, 60 
	mov x5, 10
	bl pintar_circulo	// Ver si lo puedo pintar con el bucket del isma 

	// Circulo para redondear parte derecha
	mov x3, 105
	mov x4, 60 
	mov x5, 10
	bl pintar_circulo	// Ver si lo puedo pintar con el bucket del isma 	

	// Pata de los paneles: 

	// Pata 1: Arriba a la izquierda
	mov x3, 80 		// Coordenada x donde lo voy a pintar
	mov x4,	41		// Coordenada y donde lo voy a pintar
	mov x1, 2
	mov x2, 10
	bl dibujar_rectangulo

	// Pata 2: Arriba a la derecha
	mov x3, 90 		// Coordenada x donde lo voy a pintar
	mov x4,	41		// Coordenada y donde lo voy a pintar
	mov x1, 2
	mov x2, 10
	bl dibujar_rectangulo

	// Pata 3: Abajo a la izquierda
	mov x3, 80 		// Coordenada x donde lo voy a pintar
	mov x4,	71		// Coordenada y donde lo voy a pintar
	mov x1, 2
	mov x2, 10
	bl dibujar_rectangulo

	// Pata 4: Abajo a la derecha
	mov x3, 90 		// Coordenada x donde lo voy a pintar
	mov x4,	71		// Coordenada y donde lo voy a pintar
	mov x1, 2
	mov x2, 10
	bl dibujar_rectangulo

	// Paneles:

	// Panel de arriba
	mov x3, 75 		// Coordenada x donde lo voy a pintar
	mov x4,	31		// Coordenada y donde lo voy a pintar
	mov x1, 22
	mov x2, 15
	bl dibujar_rectangulo

	// Panel de abajo
	mov x3, 75 		// Coordenada x donde lo voy a pintar
	mov x4,	75		// Coordenada y donde lo voy a pintar
	mov x1, 22
	mov x2, 15
	bl dibujar_rectangulo

	// Circulito de la punta 
	mov x3, 115
	mov x4, 60 
	mov x5, 4
	bl pintar_circulo	// Ver si lo puedo pintar con el bucket del isma 	


	// Rectangulos de la cola:

	// Primer recntagulito (el largito)
	mov x3, 63 		// Coordenada x donde lo voy a pintar
	mov x4,	55		// Coordenada y donde lo voy a pintar
	mov x1, 2		// Ancho
	mov x2, 9		// Altura 
	bl dibujar_rectangulo

	// Segundo recntagulito (el cortito)
	mov x3, 61 		// Coordenada x donde lo voy a pintar
	mov x4,	57		// Coordenada y donde lo voy a pintar
	mov x1, 3		// Ancho
	mov x2, 5		// Altura 
	bl dibujar_rectangulo

	// Antena: 

	// Circulo grande general
	mov x3, 41
	mov x4, 59 
	mov x5, 20
	bl pintar_circulo	// Ver si lo puedo pintar con el bucket del isma 	

	// Recatngulo para tapar la parte del circulo y que quede un semicirculo
	// Tener en cuenta si se cambia el color del fondo 
	movz w10, 0x0f06, lsl 16
	movk w10, 0x1b, lsl 00
	mov x3, 17 		// Coordenada x donde lo voy a pintar
	mov x4,	27		// Coordenada y donde lo voy a pintar
	mov x1, 35		// Ancho
	mov x2, 55		// Altura 
	bl dibujar_rectangulo

	// Rectangulo para terminar el semicirculo
	mov w10, 0xFFFFFF
	mov x3, 52 		// Coordenada x donde lo voy a pintar
	mov x4,	42		// Coordenada y donde lo voy a pintar
	mov x1, 1		// Ancho
	mov x2, 35		// Altura 
	bl dibujar_rectangulo

	// Rectangulo para finalizar la cola de la antena
	mov x3, 42 		// Coordenada x donde lo voy a pintar
	mov x4,	58		// Coordenada y donde lo voy a pintar
	mov x1, 10		// Ancho
	mov x2, 3		// Altura 
	bl dibujar_rectangulo

	// Circulito pra terminar la cola
	mov x3, 41
	mov x4, 59 
	mov x5, 3
	bl pintar_circulo	// Ver si lo puedo pintar con el bucket del isma 

	// Parametros del rectangulo obase del satelite 
	mov x3, 70 		// Coordenada x donde lo voy a pintar
	mov x4,	51		// Coordenada y donde lo voy a pintar
	mov x1, 40		// Ancho
	mov x2, 20		// Altura
	bl dibujar_rectangulo

ldr x30, [sp, 0]
add sp, sp, 8
ret
// ====== FIN SATELITE ======






















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
