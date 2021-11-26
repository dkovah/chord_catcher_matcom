## **Matcom Game Festival II - Proyecto "Chord Catcher"**

### **Sinopsis**

Un extraño portal se ha abierto, y han comenzado a aparecer unas criaturas que parecen reaccionar solo ante la música y la comida elaborada. Todos los restaurantes, cafés y pizzerías del mundo están en peligro ante esta nueva amenaza, y solo el Maestro de Acordes puede detenerlos.

### **Idea detrás del proyecto**

El núcleo central de la idea es desarrollar un videojuego de estilo y mecánicas similar al conocido "Piano Tiles", el cual se basa en una serie de niveles independientes con un total de vidas universal, y para jugar cada nivel se consume una vida (estas se recargan con el tiempo hasta alcanzar el máximo posible). La jugabilidad de los niveles consiste en un grupo de notas que van cayendo de forma vertical y el jugador debe tocarlas antes de que alcancen el borde inferior de la pantalla. El juego comienza con un solo nivel disponible, y para desbloquear cada uno de los otros niveles es necesario alcanzar un puntaje mínimo (total de notas "tocadas" antes de perder) en un nivel anterior. Sin embargo, a estas mecánicas clásicas se les realizan una serie de cambios importantes:

\-    La melodía, en lugar de obtenerse a partir de música clásica o canciones populares, es generada de forma procedural usando el algoritmo de colapso de la función de onda. Para introducir variedad entre los diferentes niveles, y ya que no existen melodías predefinidas, cada uno es generado sobre escalas y progresiones de acordes diferentes. La melodía es generada "on the fly", con lo que los niveles pasan a ser infinitos sin perder la variedad, a diferencia del resto de videojuegos estilo "Piano Tiles" en los cuales cada nivel reproduce en bucle la misma melodía.

\-    La estética deja de lado el tradicional estilo de piano e instrumentos musicales para centrarse en una ambientación más "rpg", sustituyendo las notas que caen por enemigos que avanzan en varios carriles.

\-    Se introduce una historia, la cual avanza cada nivel y es desarrollada a partir de diálogos en escenas introductorias de los niveles.

\-    Se introducen algunos cambios menores en las mecánicas, como la disminución a de los carriles a tres y la introducción de vidas independientes en cada nivel (además del tradicional sistema de vidas universales, que se recargan con el tiempo y son necesarias para jugar, que ahora pasa a nombrarse "energía")

### Implementación del algoritmo de colapso de la función de onda para la generación de melodías de forma procedural

#### **Identificación de las reglas**

Para obtener melodías usando el algoritmo de colapso de la función de onda, lo primero es generar una especie de "base de conocimientos", es decir, establecer una serie de reglas las cuales dada una nota o secuencia de notas sea capaz de identificar las siguientes con cierto valor de certeza. Para ello se ha realizado una implementación sencilla que recibe una secuencia de notas (una melodía hecha por un ser humano) y le asigna a cada nota de la melodía una serie de pesos para cada una de las otras notas en cuatro posiciones respecto a la nota original: dos notas por delante y dos notas por detrás y teniendo en cuenta la duración de cada nota (es decir, dos notas con la misma altura pero diferente duración se consideran notas diferentes). Estos pesos se asignan sumando cada vez que aparece cada nota en relación a la nota original en la posición que se está calculando. Por ejemplo, en la secuencia:

[
   [C4, 64],
   [E4, 64],
   [G4, 64],
   [E4, 64],
   [G4, 64],
   [D4, 64],
   [B3, 128],
   [C4, 64],
   [D4, 64],
   [E4, 64],
   [F4, 64],
   [G4, 64],
   [E4, 64],
   [C4, 128],
 ]

Teniendo en cuenta la nota "C4" con una duración de 64 ticks, la nota "E4" con una duración de 64 ticks aparece una sola vez en la posición "1" (o sea, inmediatamente después), por lo que en la base de conocimientos final la entrada correspondiente quedaría: 

[C4, 64][1][[E4, 64]] = 1

Donde [C4, 64] es un diccionario con las cuatro llaves, [-2, -1, 1, 2] las cuales representan las cuatro posiciones que se están teniendo en cuenta con respecto a esa nota, y cada una de las cuales accede a su vez un diccionario que posee como llaves cada una de las otras posibles notas de la secuencia y como valor la cantidad de veces que dicha nota aparece en la posición correspondiente a la nota en cuestión.

#### **Generación de la melodía**

Una vez identificadas las reglas, se procede a generar la melodía siguiendo los siguientes pasos:

\-    Se genera un arreglo en el cual cada posición corresponde a otro arreglo con todas las posibles notas de la base de conocimientos (es decir, todas las notas se encuentran en un estado de **superposición**).

\-    Se selecciona una posición al azar del arreglo y se **colapsa** seleccionando una nota al azar.

\-    Se **propagan los cambios** en ambas direcciones (hacia delante y hacia atrás en el arreglo) con respecto a la nota seleccionada. Para ello, se toman las tres notas más probables en cada una de cuatro posibles posiciones con respecto a la nota original y se **colapsa** la posición en una de ellas teniendo en cuenta la probabilidad de dichas notas (no se selecciona siempre la más probable, pero es la que mayor probabilidad tiene de ser seleccionada).

\-    Se **propagan los cambios** de nuevo en ambas direcciones, y se repite el proceso hasta que todas las posiciones del arreglo han sido colapsadas.

#### **Armonización**

Para asegurar que los niveles suenen relativamente "bien" para los usuarios, se ha optado por generar la base de conocimientos de cada nivel a partir de melodías compuestas sobre progresiones de acordes simples y con pocas notas, de manera tal que una vez que las secuencias melódicas son generadas y comiencen a reproducirse (a medida que el usuario toque a los enemigos que van apareciendo en pantalla) sea suficiente con un fondo de secuencias de díadas (dos notas a la vez) las cuales, en conjunto con las notas generadas por el algoritmo, conformen los acordes de la progresión. 

Para el primer nivel, por ejemplo, se utiliza la progresión `I - V - I` sobre una escala mayor construida sobre C4 (es decir, una escala de do mayor), por lo que se reproducen de fondo constantemente díadas correspondientes a cada uno de estos acordes, y siendo que la melodía generada por el algoritmo fue obtenida a partir de una melodía original simple construida sobre esta progresión y utilizando solo estos acordes, cada vez que el usuario toque un enemigo al mismo tiempo que suena una de las díadas es bastante probable de que el acorde generado sea `I` o `V` (dominante o tónica).

