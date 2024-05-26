.include "help.s"
.equ SCREEN_WIDTH, 		640
.equ SCREEN_HEIGH, 		480	

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

    // Dibujo cuadradito arriba a la izquierda

    
ret
