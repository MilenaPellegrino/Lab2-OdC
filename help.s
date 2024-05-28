
.equ SCREEN_WIDTH, 		640
.equ SCREEN_HEIGH, 		480	

// CONVENCIONES DE USO DE VARIABLES: 
///////		x = x3, y = x4
///////		dato del color = w10 
/////// 	anchos = x1, alturas = x2 

// ========   CALCULAR LA DIRECCION DE UN PIXEL   ======== 
// Parametros: x3 = x, x4 = y. Representan las coordenadas dle pixel que queremos calcular

dir_pixel: 
    mov x0, SCREEN_WIDTH    // Guardamos en x0 el ancho de la pantalla
    mul x0, x0, x4      // Multiplicamos x0 = 640 * x4 = y para obtener la posicion vertical del pixel (en terminos de las filas)
    add x0, x3, x0      // A lo anterior le sumamos x3 = x para obtener la posicion horizonal en termino de las columnas 
    lsl x0, x0, 2       // MUltiplicamos lo que nos dio por 4, ya que en el framebuffer cada pixel ocupa 4bytes (32bits)
    add x0, x0, x20     // Le sumamos la direccion base del framebuffer para obtener la direccion completa del pixel en memoria 
ret

// ========   FIN CALCULAR DIRECCION DE UN PIXEL  ======== 

// ========   PINTAR UN PIXEL EN LA PANTALLA  ======== 
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
    str w10, [x0]   	// Almacena el color en la dirección calculada por dir_pixel 
ret 

invalid_coordinates:
ret   // Ver si hacer otra cosa al pasar una coordenada fuera de rango

// ========   FIN DE PINTAR UN PIXEL EN LA PANTALLA  ======== 

// ========   DIBUJAR RECTANGULO EN LA PANTALLA  ======== 
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

// ========   FIN DE DIBUJAR RECTANGULO EN LA PANTALLA  ======== 

// ========   PINTAR UNA FILA EN LA PANTALLA  ======== 
// VER PORQUE NO LO PINTA BIEN (no funciona el color)
// PARAMETROS: x3 = x, x4 = y, X6 = tamano, w10 = color
pintar_fila:
	mov x16, x30
	mov x10, x6		   // x10 = contador = tamano 
loop_fila:
	bl pintar_pixel    // Pintamos el pixel
	add x3, x3, 1     // Avanzamos al siguiente
	sub x10, x10, 1   // Restamos al contador
	cmp xzr, x10      // Comparamos el contador ocn 0
	b.lt loop_fila      // si es menor o igual que 0 terminamos
	sub x3, x3, x6    // Reseteo de la coordenada x
	ret x16

// ========   FIN DE PINTAR UNA FILA EN LA PANTALLA  ======== 

// ========   TRIANGULO TIPO 1  ======== 
// PARAMETROS: x3 = x, x4 = y, (coordenadas del vertice superior) x1 = tamano, w10 = color
// ACLRACIONES: La punta del triangulo esta abajo a al derecha

dibujar_triangulo1:
sub SP, SP, 8 					
stur X30, [SP, 0]

	mov x9, x1		// Guardamos en x9 el tamano del triangulo
	mov x13, x3		// Guardamos en x13 la posicion inicial de x

	loop_trian1:
		mov x3, x13				// En x3 reseteo a la posicion inicial del triangulo para cada nueva fila
		mov x11, x1				// guardo el tamano
		add x11, x11, 1			
		sub x11, x11, x9		// Decrementamos en 1 para ir haciendo cada fila del triangulo

		pintar_trian1:
			bl pintar_pixel
			add x3, x3, 1			//sumo 1 en x
			sub x11, x11, 1			//resto 1 a x11 qye es el largo de la fila
			cbnz x11, pintar_trian1 // si no llegue al final de la fila  pinto otro pixel
			sub x13, x13, 1         // le resto 1 a la coordenada x del primer pixel de la fila almacenada en x13
			add x4, x4, 1			// sumo 1 a la coord y
			sub x9, x9, 1           // resto el contador de altura
			cbnz x9, loop_trian1 // si no llegue a la ultima fila, repito
ldr X30, [SP, 0]					 			
add SP, SP, 8	
ret

// ========   FIN TRIANGULO TIPO 1  ======== 


// ========   TRIANGULO TIPO 2  ======== 
// PARAMETROS: x3 = x, x4 = y, (x,y son las coordenadas del vertice superior) x1 = tamano, w10 color
// ACLARACIONES: La punta del triangulo esta abajo a la izquierda

dibujar_triangulo2:
sub SP, SP, 8 						
stur X30, [SP, 0]

	mov x9, x1
	mov x13, x3
	loop_trian2:
		mov x3, x13				//guardo en x13 la coordenada x del primer pixel de la fila
		mov x11, x1
			add x11, x11, 1
		sub x11, x11, x9

		pintar_trian2:
			bl pintar_pixel
			add x3, x3, 1	
			sub x11, x11, 1	
			cbnz x11, pintar_trian2
			add x4, x4, 1			
			sub x9, x9, 1     
			cbnz x9, loop_trian2
ldr X30, [SP, 0]					 			
add SP, SP, 8	
ret

// ========   FIN TRIANGULO TIPO 2  ======== 

// ========   TRIANGULO TIPO 3  ======== 
// PARAMETROS: x3 = x, x4 = y, (x,y son las coordenadas del vertice superior) x1 = tamano, w10 color
// ACLARACION: La punta esta para arriba

dibujar_triangulo3:
	mov x17, x30
    mov x24, x6
    mov x25, x1
    mov x22, x3
    mov x21, x4
	mov x6, 1  //  x4 = x22 x1 = x23
	bl pintar_pixel
loop_trian3:
	bl pintar_fila  // pintamos toda la fila
	add x4, x4, 1  
	bl pintar_fila

	add x4, x4, 1  
	sub x3, x3, 1  // Pasamos a la siguiente fila
	add x6, x6, 2  

	sub x1, x1, 1  // Restamos uno al tamano
	cmp xzr, x1    //  Si el tamano es menor que 0 terminamos
	b.lt loop_trian3  
    mov x6, x24
    mov x1, x25
	ret x17

// ========   FIN TRIANGULO TIPO 3  ======== 


// ========   TRIANGULO TIPO 3.1  ======== 
// PARAMETROS: x3 = x, x4 = y, (x,y son las coordenadas del vertice superior) x1 = tamano, w10 color
// ACLARACION: La punta esta para abajo (invertido del tipo 3)

dibujar_triangulo3_inv:
	mov x17, x30
    mov x24, x6 //guardar x6 y x1 para devolverselo al final
    mov x25, x1
	mov x6, 1
	bl pintar_pixel
loop_trian3_inv:
	bl pintar_fila 
	sub x4, x4, 1  
	bl pintar_fila
	sub x4, x4, 1  
	sub x3, x3, 1  
	add x6, x6, 2  
	sub x1, x1, 1  
	cmp xzr, x1   
	b.lt loop_trian3_inv     
    mov x6, x24
    mov x1, x25 
	ret x17

// ========   FIN TRIANGULO TIPO 3.1  ======== 

// ========   DIBUJAR CIRCULO POR LA PANTALLA  ======== 
// Parametros: x3 = coordenada x del centro, x4 = coordenada y del centro, x5 = radio,  w10 = color
// Aclaracion: Codigo ideado a traves de la idea del algoritmo de Bresenham
dibujar_circulo:
    sub sp, sp, 8
    stur x30, [sp, 0]
	sub SP,SP,8
	stur x4,[SP]
	sub SP,SP,8
	stur x3,[SP]

    mov x23, x3     // En x23 guardo la coordenada x 
    mov x24, x4     // En x24 guardo la coordenada y

    mov x13, xzr            // x13 representa el desplazamiento en el eje x, lo inicializo en 0
    mov x14, x5             // x14 guarda el desplazamiento en el eje y, lo inicializo con el valor del radio
    mov x15, 1              // x15 va a representar el error para trazar correctamente el circulo (algoritmo de Bresenham) 
    sub x15, x15, x5        // Error inicial restando el radio del circulo

loop_circulo: 
    // 8 combinaciones para pintar el círculo
    mov x3, x23
    add x3, x3, x13
    mov x4, x24
    add x4, x4, x14
    bl pintar_pixel

    mov x3, x23
    add x3, x3, x14
    mov x4, x24
    add x4, x4, x13
    bl pintar_pixel

    mov x3, x23
    sub x3, x3, x14
    mov x4, x24
    add x4, x4, x13
    bl pintar_pixel

    mov x3, x23
    sub x3, x3, x13
    mov x4, x24
    add x4, x4, x14
    bl pintar_pixel

    mov x3, x23
    sub x3, x3, x13
    mov x4, x24
    sub x4, x4, x14
    bl pintar_pixel

    mov x3, x23
    sub x3, x3, x14
    mov x4, x24
    sub x4, x4, x13
    bl pintar_pixel

    mov x3, x23
    add x3, x3, x14
    mov x4, x24
    sub x4, x4, x13
    bl pintar_pixel

    mov x3, x23
    add x3, x3, x13
    mov x4, x24
    sub x4, x4, x14
    bl pintar_pixel

    // Actualizamos el error y los desplazamientos
    cmp x15, xzr
    b.lt actualizar_error_menor

    sub x14, x14, 1          // y = y - 1
    add x16, x13, x13        // x16 = 2 * x
    add x17, x14, x14        // x17 = 2 * y
    add x15, x15, x16        // error += 2 * x
    sub x15, x15, x17        // error -= 2 * y
    add x15, x15, 1          // error += 1
    b fin_actualizacion

actualizar_error_menor:
    add x16, x13, x13        // x16 = 2 * x
    add x15, x15, x16        // error += 2 * x
    add x15, x15, 1          // error += 1

fin_actualizacion:
    add x13, x13, 1          // x = x + 1
    subs x9, x13, x14
    b.lt loop_circulo

// Liberamos los recursos utilizados 
ldur x3,[SP]
add SP,SP,8
ldur x4,[SP]
add SP,SP,8
ldr x30, [sp, 0]
add sp, sp, 8
ret  

// ========   FIN DE DIBUJAR CIRCULO POR LA PANTALLA  ======== 


// ========   PINTAR CIRCULO POR LA PANTALLA  ======== 
// parametros x3= coordenada x del centro, x4 = coordenada y del centro,  x5 = radio, w10 = color
// aclaraciones: ver porque no se pintar todo el circulo y quedan espacios

pintar_circulo:

	sub sp, sp, 8
	stur x30, [sp, 0]
		
	mov x23, x3  // Guardar coordenada x del centro
	mov x24, x4  // Guardar coordenada y del centro
		
	circleloop:
		bl dibujar_circulo  // Llama a la función para dibujar el círculo
		mov x3, x23         // Restaurar coordenada x del centro
		mov x4, x24         // Restaurar coordenada y del centro
		sub x5, x5, 1       // Decrementar radio
		cbnz x5, circleloop // Si el radio no es cero, repetir el bucle
		
	ldr x30, [sp, 0]
	add sp, sp, 8
	ret    

// ========   FIN DE PINTAR CIRCULO POR LA PANTALLA  ======== 


// ========   BUCKET PINTAR UN AREA DETERMINADA  ======== 
// Parametros: x3=coordenada x, x4=coordenada y, x10=color a pintar
bucket: 
	sub SP,SP,8  		  	//Reservamos espacio en la pila
	stur x30,[SP,0]       	//Guardamos el valor de x30 en la pila	
	sub SP,SP,8  		  	//Reservamos espacio en la pila
	stur x7,[SP,0]       	//Guardamos el valor de x7 en la pila
	sub SP,SP,8  		  	//Reservamos espacio en la pila
	stur x8,[SP,0]       	//Guardamos el valor de x8 en la pila
	sub SP,SP,8  		  	//Reservamos espacio en la pila
	stur x9,[SP,0]       	//Guardamos el valor de x9 en la pila
	movz x9,0x0,lsl 00		//Usamos x9 para llevar registro de cuanta SP es usada, lo inicializo en 0
	bl dir_pixel  			//guardamos en x0 la direccion del pixel a pintar
	ldur w7,[x0]   			//en x7 guardamos el color del pixel
	stur w10,[x0]			//Pinto el primer pixel
pixel_painter:
	sub x0,x0,2560			//ponemos en x0 la dir del pixel superior
	bl compare				//Si corresponde, compare pintara el pixel y guardara su direccion en SP
	add x0,x0,2556			//ponemos en x0 la dir del pixel anterior
	bl compare				//Si corresponde, compare pintara el pixel y guardara su direccion en SP
	add x0,x0,8				//ponemos en x0 la dir del pixel posterior
	bl compare				//Si corresponde, compare pintara el pixel y guardara su direccion en SP
	add x0,x0,2556			//ponemos en x0 la dir del pixel inferior
	bl compare				//Si corresponde, compare pintara el pixel y guardara su direccion en SP
	cbz x9,end_bucket		//Si ya se libero la SP, termino el programa
	cbnz x9,next_dir		//Si no esta liberada la SP,busco el sig pixel almacenado en SP
compare:
	ldur w8,[x0]	 		//cargamos el color del pixel a comparar en w8
	cmp w8,w7				//compara el color de w8 con el color que desea ser reemplazado
	b.eq dir_to_SP			//Si estos colores son iguales lo pinta y almacena su direccion en SP
	ret
dir_to_SP:
	stur w10,[x0]			//Pinta el pixel
	sub SP,SP,4				//Hace espacio en SP para la dir del pixel
	stur w0,[SP,0]			//Almacena la direccion del pixel en SP
	add x9,x9,1				//Suma 1 al contador de uso de SP
	ret
next_dir:
	ldur w0,[SP,0]			//Guarda en x0 el pixel almacenado en SP
	add SP,SP,4				//Libera espacio del SP
	sub x9,x9,1				//Decrementa el contador de uso de SP
	b pixel_painter			//Va a pintar el pixel
end_bucket:
	ldur x9,[SP,0]			//Devuelve el valor original de x9
	add SP,SP,8				//Libera espacio del SP
	ldur x8,[SP,0]			//Devuelve el valor original de x8
	add SP,SP,8				//Libera espacio del SP
	ldur x7,[SP,0]			//Devuelve el valor original de x7
	add SP,SP,8				//Libera espacio del SP
	ldur x30,[SP,0]			//Devuelve el valor original de x30
	add SP,SP,8				//Libera espacio del SP
	ret						//Termina la funcion
//

// ========   FIN DEL BUCKET PINTAR UN AREA DETERMINADA  ======== 

// ========   PINTAR PUENTECITOS  ======== 
// Parametros: x3=xa, x4=y, x5=xb, w10=color a pintar
// Aclaraciones: xb debe ser mayor a xa (xb>xa) y la distancia entre el xa y xb debe ser mayor a 2
bridge:
	sub SP,SP,8    			//|Reservo espacio en SP para almacenar x30
	stur x30,[SP] 			//|Almaceno x30
	sub SP,SP,8    			//|Reservo espacio en SP para almacenar x9
	stur x9,[SP] 			//|Almaceno x9
	sub SP,SP,8    			//|Reservo espacio en SP para almacenar x8
	stur x8,[SP] 			//|Almaceno x8
	sub SP,SP,8    			//|Reservo espacio en SP para almacenar x7
	stur x7,[SP] 			//|Almaceno x7
	sub SP,SP,8				//|Reservo espacio en SP para almacenar x3
	stur x3,[SP]  			//|Almaceno x3
	sub SP,SP,8    			//|Reservo espacio en SP para almacenar x30
	stur x1,[SP] 			//|Almaceno x1
	sub x7,x5,x3    		//Almaceno la distancia entre xa y xb
	add x7,x7,2				//Le sumo a la distancia 2 para contar los pixeles de los extremos
	bl dir_pixel  		  	//Almaceno la direccion del primer pixel (Inicio del puente) en x0
	add x1,x0,0				//Guardo la direccion del primer pixel en x1
	add x3,x5,0     		//Copio xb en x3 para poder usar la siguiente func
	bl dir_pixel	    	//Almaceno la direccion del segundo pixel (Fin del puente) en x0
	movz x8,0x2,lsl 00	 	//En x8 almaceno la cantidad de pixeles que quiero sean pintados de cada lado en cada altura
	add x9,x8,0				//Copio x9 en x8
bridge_painter:
	stur w10,[x1]			//Pinto el inicio del puente
	stur w10,[x0]			//Pinto el final del puente
	add x1,x1,4				//Avanzo el pixel inicial una posicion
	sub x0,x0,4     		//Retrocedo el pixel final una posicion
	sub x9,x9,1				//Resto 1 a x9
	sub x7,x7,2				//A x7 le resto dos para saber que pinte dos pixeles
	cmp x7,0x0				//Comparo x7 con 0
	b.le end_bridge			//Si x7 es menor o igual a 0, termina el programa
	cbnz x9,bridge_painter	//Si x9 no es cero vuelvo a pintar pixeles en esta linea
	b decounter_high		//Si x9 es cero baja una posicion los pixeles y establece un nuevo limite para x8
	b.gt bridge_painter		//Si no complete el puente vuelvo a pintar
decounter_high:
	add x9,x8,0        		//Copio x9 en x8
	add x8,x8,1				//Aumento el limite de pixeles a pintar para la siguiente fila
	add x0,x0,2560			//Baja el pixel final
	add x1,x1,2560			//Baja el pixel inicial
	b bridge_painter		//Vuelve a pintar
end_bridge:
	ldur x1,[SP]			//|Devuelve a x1 el valor inicial
	add SP,SP,8				//|Libero espacio del SP
	ldur x3,[SP]			//|Devuelve a x3 el valor inicial
	add SP,SP,8				//|Libero espacio del SP
	ldur x7,[SP]			//|Devuelve a x7 el valor inicial
	add SP,SP,8				//|Libero espacio del SP
	ldur x8,[SP]			//|Devuelve a x8 el valor inicial
	add SP,SP,8				//|Libero espacio del SP
	ldur x9,[SP]			//|Devuelve a x9 el valor inicial
	add SP,SP,8				//|Libero espacio del SP
	ldur x30,[SP]			//|Devuelve a x30 el valor inicial
	add SP,SP,8				//|Libero espacio del SP
	ret						//Termina la funcion
//Pone a x7,x8,x9 en 0

// ========  FIN DE PINTAR PUENTECITOS  ======== 
//
