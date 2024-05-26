
.equ SCREEN_WIDTH, 		640
.equ SCREEN_HEIGH, 		480	

// Calcular la direccion de un pixel
// Parametros: x3 = x, x4 = y. Representan las coordenadas dle pixel que queremos calcular

dir_pixel: 
    mov x0, SCREEN_WIDTH    // Guardamos en x0 el ancho de la pantalla
    mul x0, x0, x4      // Multiplicamos x0 = 640 * x4 = y para obtener la posicion vertical del pixel (en terminos de las filas)
    add x0, x3, x0      // A lo anterior le sumamos x3 = x para obtener la posicion horizonal en termino de las columnas 
    lsl x0, x0, 2       // MUltiplicamos lo que nos dio por 4, ya que en el framebuffer cada pixel ocupa 4bytes (32bits)
    add x0, x0, x20     // Le sumamos la direccion base del framebuffer para obtener la direccion completa del pixel en memoria 
ret


// Pintar un pixel por pantalla 
// Prametros x3 = x, x4 = y, w10 = color del pixel que vayamos a pintar 

pintar_pixel: 

    // Primero verifiquemos que las coordenadas esten dentro de la pantalla: 
    cmp x3, #640    // Si me pase por derecha en x 
    b.ge invalid_coordinates
    cmp x3, #0      // Si me fui de rango por izquierda en x 
    b.lt invalid_coordinates
    cmp x4, #480    // Si me fui de rango por arriba en y 
    b.ge invalid_coordinates
    cmp x4, #0      // Si me fui de rango por abajo en y
    b.lt invalid_coordinates

    // Si las direcciones pasadas como parametro son validas: 
    // Calculo la direccion del pixel: 
    sub sp, sp, #16     // Reservamos 16bytes en el stack pointer (en la pila) para guardar los dos registros. Hacemos la resta ya que en esta arquitectura la pila crece hacia abajo 
    stp x29, x30, [sp, #0]  // Guardamos los registros x29 y x30 en la pila
    bl dir_pixel    // Llamamos a la funcion para obtener la direccion en memoria del pixel 
    
    ldp x29, x30, [sp, #0]  // Restauramos los registros dx29 y x30
    add sp, sp, #16     // LIberamos espacio en la pila 

    // Pintamos ell pixel:
    str w10, [x0]   // Almacena el color en la dirección calculada por dir_pixel 
ret 

invalid_coordinates:
ret     // Ver si hacer otra cosa al pasar una coordenada fuera de rango


// Dibujar un rectangulo por pantalla 
// Parametros: x3 = x, x4 = y, ancho del rectangulo = x1, altura del rectangulo = x2, color = w10

dibujar_rectangulo: 
	sub SP, SP, 8   // Reservamos espacio en la pila 						
	stur X30, [SP, 0]   // Guardamos el valor de x30 en la pila
	bl dir_pixel    // Calcula la direccion de memoria del primer pixel del rectangulo    			
	ldr X30, [SP, 0]					 			
	add SP, SP, 8   // Liberamos el espacio de la pila utilizado 						
	mov x9, x2		// x9 contiene la altura del rectangulo		
	mov x13, x0	    // EN x13 guardamos la direccion de memoria dle primer pixel del rectangulo						
	rectLoop:
		mov x11, x1     // Guardamos en x11 el ancho del rectangulo
		mov x12, x13	//x12 guarda la direccion de memoria del primer pixel de la fila actual 			
		pintarFila:
			stur w10, [x13]     // Guardamos el color del pixel				
			add x13, x13, 4	    // Avanzamos al siguiente pixel (4bytes, ya que cada pixel ocupa 32bits)	
			sub x11, x11, 1		// Restamos uno al contador de ancho para pintar el resto    	
			cbnz x11, pintarFila    // Si no estoy en el final de la fila, vuelvo a pintar el otro pixel
			mov x13, x12				//si llegue al final de la fila, restauramos la dirección de memoria del primer píxel de la fila actual, o sea me paro en el primer pixel
            
            // Longitud de una fila= Num de pıxeles por fila × Tamano de cada pıxel en bytes = 640×4 = 2560 bytes
			add x13, x13, 2560			// sumo 2560, lo que nos salta a la fila de abajo
			sub x9, x9, 1				// como salte a la fila de abajo, resto uno a la altura
			cbnz x9, rectLoop	    // si no termine de pintar la ultima fila, vuelvo a pintar una fila
ret

// DIBUJAR UN CIRCULO POR PANTALLA
// Parametros: x3 = coordenada x del centro, x4 = coordenada y del centro, x5 = radio,  w10 = color
// Aclaracion: Codigo ideado a traves de la idea del algoritmo de Bresenham
dibujar_circulo:
    sub sp, sp, 8
    stur x30, [sp, 0]

    mov x23, x3     // En x23 guardo la coordenada x 
    mov x24, x4     //  En  x24 guardo la coordenada y

    mov x13, xzr			// x13 representa el desplazamiento en el eje x, lo inicializo en 0
    mov x14, x5				// x14 guarda el desplazamiento en el eje y, lo inicializo con el valor del radio
    mov x15, 1				// x15 va a representar el error para trazar correctamente el circulo (algoritmo de Bresenham) 
	sub x15, x15, x5    // Error inicial restando el radio del circulo

loop_circulo: 
	mov x3, x23     // Guardo en x3, mi coordenada x inicial					
	add x3, x3, x13     // sumo a mi coordenada x inicial el desplazamiento en x que hice
	mov x4, x24
	add x4, x4, x14			// sumo a mi coordenada y incial el desplamienot en y
	bl pintar_pixel     // Pinto el pixel en esas coordenadas con desplazamiento

    // Hago lo mismo para las otras combinaciones
	mov x3, x23     
	add x3, x3, x14      // medio de x + y
	mov x4, x24
	add x4, x4, x13      // medio de y + x				
	bl pintar_pixel

	mov x3, x23
	sub x3, x3, x14    // medio de x - y
	mov x4, x24
	add x4, x4, x13    // medio de y + x
	bl pintar_pixel

	mov x3, x23
	sub x3, x3, x13   // med_x - x
	mov x4, x24
	add x4, x4, x14   // med_y + y
	bl pintar_pixel

	mov x3, x23
	sub x3, x3, x13  // med_x - x
	mov x4, x24
	sub x4, x4, x14  // med_y - y
	bl pintar_pixel

	mov x3, x23
	sub x3, x3, x14  // med_x- y
	mov x4, x24
	sub x4, x4, x13  // med_y - x
	bl pintar_pixel

	mov x3, x23
	add x3, x3, x14  // med_x + y
	mov x4, x24
	sub x4, x4, x13  // med_y - x
	bl pintar_pixel

	mov x3, x23
	add x3, x3, x13		// med_x + x
	mov x4, x24
	sub x4, x4, x14  // med_y - y
	bl pintar_pixel

	cmp x15, xzr
	b.lt true
    
    // Actualizamos las variables segun las condiciones del algoritmo 
	sub x14, x14, 1  // y = y-1
	add x16, x13, x13	//x16 = (2 * x)
	add x17, x14, x14  // x17 = (2 * y)
	add x15, x15, x16  // x15 = error + (2 * x)
	sub x15, x15, x17	// x15 = error + (2 * x) - (2 * y)
	add x15, x15, 1		//x15 = error + (2 * x) - (2 * y) + 1
	b end


true: add x16, x13, x13  // x16 = (2 * x)
	add x15, x15, x16  // x15 = error + (2 * x)
	add x15, x15, 1   // x15 = error + (2 * x) + 1

end:add x13, x13, 1
	subs x9, x13, x14
	b.lt loop_circulo

// Liberamos los recursos utilizados 
ldr x30, [sp, 0]
add sp, sp, 8
ret	




