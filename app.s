.include "drawings.s"

.equ SCREEN_WIDTH,   640
.equ SCREEN_HEIGHT,  480
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

    bl degrade

    movz x10, 0x0000, lsl 16
    movk x10, 0x0000, lsl 00

    mov x2, SCREEN_HEIGHT         // Y Size
loop1:
    mov x1, SCREEN_WIDTH         // X Size
loop0:
    stur w10,[x0]  // Colorear el pixel N
    add x0,x0,4    // Siguiente pixel
    sub x1,x1,1    // Decrementar contador X
    cbnz x1,loop0  // Si no terminó la fila, salto
    sub x2,x2,1    // Decrementar contador Y
    cbnz x2,loop1  // Si no es la última fila, salto



    // Dibujar una circunferencia 
    mov x3, 320         // Coord x del centro de la circunferencia
    mov x4, 240         // Coord y del centro de la circunferencia
    mov x5, 150    // Radio de la circuncunferencia
    mov w10, 0xFFFFFF        // COLOR
    bl dibujar_circulo

    bl fondo_estrella


InfLoop:
    b InfLoop


degrade:

    mov w11, 0x000F06 
    mov x2, 1         // Y Size
loop2:
    mov x1, SCREEN_WIDTH         // X Size
loop3:
    stur w11,[x0]  // Colorear el pixel N
    add x0,x0,4    // Siguiente pixel
    sub x1,x1,1    // Decrementar contador X
    cbnz x1,loop3  // Si no terminó la fila, salto
    sub x2,x2,1    // Decrementar contador Y
    cbnz x2,loop2  // Si no es la última fila, salto
ret

