.include "help.s"
.equ SCREEN_WIDTH, 		640
.equ SCREEN_HEIGH, 		480	

// ====== DIBUJAR ESTRELLA TIPO 1 ======
// Estrella de tipo 1 (cuadradito amarillo con cuadraditos en la punta)
// Parametros: x2 = x, x1 = y
// Tamano y color estaticos (por ahora)

dibujar_estrella1: 
    sub SP, SP, 8   // Reservamos espacio en la pila 						
	stur X30, [SP, 0]   // Guardamos el valor de x30 en la pila

    // Dibujo el cuadrado principal:
    mov x3, x2  // Posicion x del centro de la estrella
    mov x4, x1  // Poscion y del centro de la estrella 
    mov x1, 3  // Ancho del centro de la estrella = 10
    mov x2, 3  // Altura del centro de la estrella = 10
    //mov w10, 0xFFCF13   // Color amarillo para la estrella
    mov w10, 0xFFFFFF
    bl dibujar_rectangulo

// ====== FIN DIBUJAR ESTRELLA TIPO 1 ======


// ====== FONDO DE ESTRELLAS ======

fondo_estrella:
    sub SP,SP,8     //reservamos espacio en la pila
    stur x30,[SP]	// guardamos el valor de x3 en la pila
    mov w10, 0xFFFFFF // COLOR
//----------------filas_del_principio-------------------------
	mov x3, 600
	mov x5, 0 //reseteo el radio
	mov x4, 8 //reseteo la fila
        mov x11, 75	
        bl fila_circulos

//mismo circulo, diferente radio
    mov w10, 0xFFFF00
	mov x3, 580 // elijo la posicion en el eje x
	mov x5, 0 //reseteo el radio
	mov x4, 45 //reseteo la fila
	mov x11, 58
    bl fila_circulos

    mov w10, 0xFFFFFF
    mov x3, 580 // elijo la posicion en el eje x
	mov x5, 1 //reseteo el radio
	mov x4, 45 //reseteo la fila
	mov x11, 58
        bl fila_circulos
//hasta aca
////------------------filas_del_medio-------------------------//
	
    mov x3, 639
	mov x5, 0 //reseteo el radio
	mov x4, 70 //reseteo la fila
    mov x11, 71	
        bl fila_circulos

// mismo circulo, diferente radio
    mov w10, 0xFFFF00
	mov x3, 600 // elijo la posicion en el eje x
	mov x5, 0 //reseteo el radio
	mov x4, 110 //reseteo la fila
	mov x11, 75
        bl fila_circulos
	mov w10, 0xFFFFFF
    mov x3, 600 // elijo la posicion en el eje x
	mov x5, 1 //reseteo el radio
	mov x4, 110 //reseteo la fila
	mov x11, 75
        bl fila_circulos
// hasta aca
//
	mov x3, 630
	mov x5, 0 //reseteo el radio
	mov x4, 150 //reseteo la fila
    mov x11, 45	
        bl fila_circulos

//mismo circulo, diferente radio
    mov w10, 0xFFFF00
	mov x3, 600 // elijo la posicion en el eje x
	mov x5, 0 //reseteo el radio
	mov x4, 200 //reseteo la fila
	mov x11, 75
        bl fila_circulos

    mov w10, 0xFFFFFF
    mov x3, 600 // elijo la posicion en el eje x
	mov x5, 1 //reseteo el radio
	mov x4, 200 //reseteo la fila
	mov x11, 75
        bl fila_circulos
//hasta aca
//aca
	mov x3, 630
	mov x5, 0 //reseteo el radio
	mov x4, 250 //reseteo la fila
    mov x11, 105	
        bl fila_circulos

//mismo circulo, diferente radio
    mov w10, 0xFFFF00
	mov x3, 580 // elijo la posicion en el eje x
	mov x5, 0 //reseteo el radio
	mov x4, 300 //reseteo la fila
	mov x11, 58
        bl fila_circulos

    mov w10, 0xFFFFFF
    mov x3, 580 // elijo la posicion en el eje x
	mov x5, 1 //reseteo el radio
	mov x4, 300 //reseteo la fila
	mov x11, 58
        bl fila_circulos
//
	mov x3, 640
	mov x5, 0 //reseteo el radio
	mov x4, 360 //reseteo la fila
    mov x11, 80	
        bl fila_circulos

//---------relleno-----------//
	mov x3, 45
	mov x5, 0 //reseteo el radio
	mov x4, 245 //reseteo la fila
    mov x11, 45	
        bl fila_circulos
    mov w10, 0xFFFFFF
    mov x3, 45 // elijo la posicion en el eje x
	mov x5, 1 //reseteo el radio
	mov x4, 245 //reseteo la fila
	mov x11, 45
        bl fila_circulos
	mov x3, 20
	mov x5, 0 //reseteo el radio
	mov x4, 367 //reseteo la fila
    mov x11, 20	
        bl fila_circulos
    mov w10, 0xFFFFFF
    mov x3, 20 // elijo la posicion en el eje x
	mov x5, 1 //reseteo el radio
	mov x4, 367 //reseteo la fila
	mov x11, 20
        bl fila_circulos
//--------------------filas_fianles-----------------------------------//

    mov x3, 639
	mov x5, 0 //reseteo el radio
	mov x4, 450 //reseteo la fila
        mov x11, 71	
        bl fila_circulos

// mismo circulo, diferente radio
    mov w10, 0xFFFF00
	mov x3, 600 // elijo la posicion en el eje x
	mov x5, 0 //reseteo el radio
	mov x4, 400 //reseteo la fila
	mov x11, 75
        bl fila_circulos

    mov w10, 0xFFFFF0
    mov x3, 600 // elijo la posicion en el eje x
	mov x5, 1 //reseteo el radio
	mov x4, 400 //reseteo la fila
	mov x11, 75
        bl fila_circulos
// hasta aca

//---------------------------------------------------//
    ldur x30,[SP]   
    add SP,SP,8
ret

// ====== FIN FONDO DE ESTRELLAS ======

// ====== FILAS DE CIRCULOS ======
fila_circulos:
    add x6,x3,0
    add x7,x4,0
    add x8,x5,0
    sub SP,SP,8     //reservamos espacio en la pila
    stur x30,[SP]	// guardamos el valor de x3 en la pila

    bl dibujar_circulo
    add x3,x6,0
    add x4,x7,0
    add x5,x8,0
    sub x3, x3, x11    // Decrementa en 100 en lugar de 200
    cbnz x3, fila_circulos // Comprueba si x6 aún es positivo
    //reseteo los flags
    mov x3, 0
    mov x5, 0
    mov x4, 0
    ldur x30,[SP]   
    add SP,SP,8
ret

// ====== FIN FILAS DE CIRCULOS ======

// ====== DIBUJAR SATURNO EPICOS TO CHETAO ======
draw_saturn:
	sub SP,SP,8
	stur x30,[SP]
	add x11,x3,0
	lsr x6,x5,3
	add x7,x4,0
	add x8,x4,0
	movz x10,0xb6,lsl 16
	movk x10,0x8355,lsl 00
	bl dibujar_circulo
	movz x25,0x1,lsl 00
	bl bucket
	movz x25,0x0,lsl 00
	movz x10,0x99,lsl 16
	movk x10,0xcecc,lsl 00
	bl set_x3_x5
	bl bridge
	bl upper_bridge_and_bucket
	bl upper_bridge_and_bucket
	movz x10,0xec,lsl 16
	movk x10,0x8735,lsl 00
	bl upper_bridge_and_bucket
	movz x10,0xff,lsl 16 
	movk x10,0xd8ba,lsl 00
	bl upper_bridge_and_bucket
	movz x10,0xc8,lsl 16
	movk x10,0x4903,lsl 00
	bl upper_bridge_and_bucket
	movz x10,0x51,lsl 16
	movk x10,0x220c,lsl 00
	bl upper_bridge_and_bucket
	movz x10,0xc8,lsl 16
	movk x10,0x4903,lsl 00
	bl upper_bridge_and_bucket
	movz x10,0xc8,lsl 16
	movk x10,0x4903,lsl 00
	bl lower_bridge_and_bucket
	movz x10,0x33,lsl 16
	movk x10,0x0000,lsl 00 
	bl lower_bridge_and_bucket
	movz x10,0xe0,lsl 16
	movk x10,0xa06a,lsl 00
	bl lower_bridge_and_bucket
	movz x10,0x51,lsl 16
    movk x10,0x220c,lsl 00
	bl lower_bridge_and_bucket
	bl lower_bridge_and_bucket
	movz x10,0xc8,lsl 16
	movk x10,0x4903,lsl 00
	bl lower_bridge_and_bucket
	movz x10,0xd4,lsl 16
	movk x10,0xac0d,lsl 00
	bl lower_bridge_and_bucket
	b end_saturn
upper_bridge_and_bucket:
	sub SP,SP,8
	stur x30,[SP]
	sub x7,x7,x6
	add x4,x7,0
	add x3,x11,0
	bl set_x3_x5
	bl bridge
	add x3,x11,0
	add x4,x7,x6
	bl bucket
	ldur x30,[SP]
	add SP,SP,8
	ret
lower_bridge_and_bucket:
	sub SP,SP,8
	stur x30,[SP]
	add x8,x8,x6
	add x4,x8,0
	add x3,x11,0
	bl set_x3_x5
	bl bridge
	add x3,x11,0
	add x4,x8,0
	bl bucket
	ldur x30,[SP]
	add SP,SP,8
	ret
end_saturn:
	ldur x30,[SP]
	add SP,SP,8
	ret



set_x3_x5:
	sub SP,SP,8
	stur x30,[SP]
	sub SP,SP,8
	stur x9,[SP]
	sub SP,SP,8
	stur x8,[SP]
	sub SP,SP,8
	stur x2,[SP]
	sub SP,SP,8
	stur x1,[SP]
	bl dir_pixel
	add x5,x3,0
	add x1,x0,0
	ldur w9,[x0]
compare_x3:
	sub x0,x0,4
	ldur w8,[x0]
	cmp w8,w9
	b.eq decr_x3
	b.ne compare_x5
decr_x3:
	sub x3,x3,1
	b compare_x3
compare_x5:
	add x1,x1,4
	ldur w8,[x1]
	cmp w8,w9
	b.eq acrem_x5
	b.ne end_aux
acrem_x5:
	add x5,x5,1
	b compare_x5
end_aux:
	ldur x1,[SP]
	add SP,SP,8
	ldur x2,[SP]
	add SP,SP,8
	ldur x8,[SP]
	add SP,SP,8
	ldur x9,[SP]
	add SP,SP,8
	ldur x30,[SP]
	add SP,SP,8
	ret

// ====== FIN DEL EPICO DIBUJO DE SATURNO ======




// ====== DIBUJAR """la luna""" (con muchas comillas)======
// No la pude parametrizar 
// CORREGIR Y HACERLA MAS FACHERA

draw_moon: 
	sub sp, sp, 8
	stur x30, [sp, 0]
	mov x3, 320
	mov x4, 240
	mov x5, 150

	// Circulo grande general 
	movz w10, 0xBBBB       // Carga los 16 bits menos significativos
	movk w10, 0xBB, lsl 16
	bl dibujar_circulo
	bl bucket

	mov x3, 270
	mov x4, 170
	mov x5, 30
	// circulo chiquito a la izquierda
	movz w10, 0x7272      // Carga los 16 bits menos significativos
	movk w10, 0x72, lsl 16	
	bl dibujar_circulo
	bl bucket

	#69696D
	mov x3, 400
	mov x4, 320
	mov x5, 30
	// circulo chiquito a la izquierda
	movz w10, 0x696D      // Carga los 16 bits menos significativos
	movk w10, 0x69, lsl 16	
	bl dibujar_circulo
	bl bucket

ldr x30, [sp, 0]
add sp, sp, 8
ret

// ====== FIN de la """la luna""" ======

// ====== DIBUJAR SATELITE ======
// Sin paraemtro por ahora, dibujado en el mismo lugar

draw_satelite:
	sub sp, sp, 8
	stur x30, [sp, 0]

	// Circulo para redondear parte izquierda
	movz w10, 0xA39B      
	movk w10, 0x5C, lsl 16
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
	movz w10, 0xE1E6      
	movk w10, 0xEA, lsl 16
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
	movz w10, 0x97B0    
	movk w10, 0x41, lsl 16
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
	movz w10, 0x3A47    
	movk w10, 0x7D, lsl 16
	mov x3, 115
	mov x4, 60 
	mov x5, 4
	bl pintar_circulo	// Ver si lo puedo pintar con el bucket del isma 	


	// Rectangulos de la cola:

	// Primer recntagulito (el largito)
	movz w10, 0xE1E6      
	movk w10, 0xEA, lsl 16
	mov x3, 63 		// Coordenada x donde lo voy a pintar
	mov x4,	55		// Coordenada y donde lo voy a pintar
	mov x1, 2		// Ancho
	mov x2, 9		// Altura 
	bl dibujar_rectangulo

	// Segundo recntagulito (el cortito)
	movz w10, 0x7C8D      
	movk w10, 0x6A, lsl 16
	mov x3, 61 		// Coordenada x donde lo voy a pintar
	mov x4,	57		// Coordenada y donde lo voy a pintar
	mov x1, 3		// Ancho
	mov x2, 5		// Altura 
	bl dibujar_rectangulo

	// Antena: 

	// Circulo grande general
	movz w10, 0x3A47    
	movk w10, 0x7D, lsl 16
	mov x3, 41
	mov x4, 59 
	mov x5, 20
	bl pintar_circulo	// Ver si lo puedo pintar con el bucket del isma 	

	// Recatngulo para tapar la parte del circulo y que quede un semicirculo
	// Tener en cuenta si se cambia el color del fondo 
	movz w10, 0x0000, lsl 16
	movk w10, 0x00, lsl 00
	mov x3, 17 		// Coordenada x donde lo voy a pintar
	mov x4,	27		// Coordenada y donde lo voy a pintar
	mov x1, 35		// Ancho
	mov x2, 55		// Altura 
	bl dibujar_rectangulo

	// Rectangulo para terminar el semicirculo
	movz w10, 0xE1E6      
	movk w10, 0xEA, lsl 16
	mov x3, 52 		// Coordenada x donde lo voy a pintar
	mov x4,	42		// Coordenada y donde lo voy a pintar
	mov x1, 1		// Ancho
	mov x2, 35		// Altura 
	bl dibujar_rectangulo

	// Rectangulo para finalizar la cola de la antena
	movz w10, 0x6070      
	movk w10, 0x4F, lsl 16
	mov x3, 42 		// Coordenada x donde lo voy a pintar
	mov x4,	58		// Coordenada y donde lo voy a pintar
	mov x1, 10		// Ancho
	mov x2, 3		// Altura 
	bl dibujar_rectangulo

	// Circulito pra terminar la cola
	#DCA051
	movz w10, 0xA051    
	movk w10, 0xDC, lsl 16
	mov x3, 41
	mov x4, 59 
	mov x5, 3
	bl pintar_circulo	// Ver si lo puedo pintar con el bucket del isma 

	// Parametros del rectangulo obase del satelite 
	movz w10, 0xA39B      
	movk w10, 0x5C, lsl 16
	mov x3, 70 		// Coordenada x donde lo voy a pintar
	mov x4,	51		// Coordenada y donde lo voy a pintar
	mov x1, 40		// Ancho
	mov x2, 20		// Altura
	bl dibujar_rectangulo

ldr x30, [sp, 0]
add sp, sp, 8
ret
// ====== FIN SATELITE ======

// ====== FONDO DEGRADE FACHERO =======//

fondo_degrade:
	sub sp, sp, 8
	stur x30, [sp, 0]

	movz w10, 0x0000        // Inicializar el color a negro (0x00000000)
	mov x3, 0		        // Coordenada x donde lo voy a pintar
	mov x4, 0		        // Coordenada y donde lo voy a pintar
	mov x1, 640		        // Ancho
	mov x2, 1		        // Altura
	mov x6, 0x0000	    // Blanco máximo (0xFFFFFFFF)
	udiv x7, x6, x2	        // Incremento por fila (blanco / altura)

rectangulo_negro:
	bl dibujar_rectangulo
	add w10, w10, w7
	add x4, x4, 1        // Incrementa el color para el siguiente degradado
	add x2, x2, 1
	cmp x2, 280
	b.lt rectangulo_negro


	movz w10, 0x0000        // Inicializar el color a negro (0x00000000)
	mov x3, 0		        // Coordenada x donde lo voy a pintar
	mov x4, 280		        // Coordenada y donde lo voy a pintar
	mov x1, 640		        // Ancho
	mov x2, 1		        // Altura
	mov x6, 0x0001	    // Blanco máximo (0xFFFFFFFF)
	udiv x7, x6, x2	        // Incremento por fila (blanco / altura)

rectangulo_azul:
	bl dibujar_rectangulo
	add w10, w10, w7
	add x4, x4, 6        // Incrementa el color para el siguiente degradado
	add x2, x2, 1
	cmp x2, 200
	b.lt rectangulo_azul

ldr x30, [sp, 0]
add sp, sp, 8
ret

