# Abstract

En los últimos años ha ocurrido un resurgimiento de la carrera espacial motivado especialmente por empresas comerciales. Sus aeronaves son equipadas con una multitud de sensores, siendo uno de ellos las cámaras hiperespectrales. Este tipo de cámaras toma imágenes en cientos de bandas espectrales diferentes, con el objetivo de proporcionar información sobre el terreno.
A causa del gran tamaño de estas imágenes, estas son enviadas a la tierra para su procesado, con el consecuente uso de red. Preferentemente estas imágenes deberían procesarse o comprimirse in situ para enviar solo una fracción de los datos obtenidos. Dados el entorno espacial y la rigidez y facilidad de ser paralelizado de este tipo de algoritmos, las FPGAs o ASICs se postulan como un sistema óptimo para su implementación.
Este trabajo presenta una implementación sobre FPGAs del algoritmo detector Reed-Xiaoli de anomalías para imagenes hiperespectrales. Para su implementación se ha realizado un análisis de las operaciones del algoritmo, centrada en una implementación en punto flotante y otra en fijo, sus requisitos en lógica, y de las repercusiones que tienen ciertas decisiones con la precisión que se alcanza. Finalmente se presenta una implementación óptima.


# Introduction

## motivaciones y objetivos

La navegación espacial cumple muchos objetivos, el más obvio siendo recopilar información acerca de nuestro planeta y lo que le rodea. Para ello se crean sensores capaces de recopilar información, como por ejemplo antenas o telescopios que son usados tanto desde la Tierra como enviados a bordo de naves espaciales. Uno de ellos son las cámaras hiperespectrales, que toman fotos en cientos de bandas distintas. Estos datos permiten encontrar objetos, detectar materiales o identificar procesos. A medida que la tecnología avanza, estos sensores evolucionan requeriendo de soluciones de procesado acordes para interpretar los datos o comprimirlos y enviarlos a tierra.

El objetivo de este trabajo es la implementación de uno de estos algoritmos de forma que resulte preferenta el procesado en la aeronave frente a la transmisión de los datos crudos. Para ello se estudiarán tanto diferentes tipos de algoritmos como de plataformas.

## antecedentes
https://eprints.ucm.es/15828/1/T33468.pdf
https://www.researchgate.net/publication/220243592_Fast_real-time_onboard_processing_of_hyperspectral_imagery_for_detection_and_classification
https://public.lanl.gov/jt/Papers/onboard-post.pdf

En el trabajo realizado por "los chavales que hicieron lo mismo" se realiza un estudio del mismo algoritmo sobre una fpga similar. El resultado es positivo con una reduccion del tiempo de calculo frente a soluciones basadas en software. El estudio se realizó sin embargo solo sobre subconjuntos de los datos y nunca sobre una imagen completa.

En https://public.lanl.gov/jt/Papers/onboard-post.pdf se propone el procesado de los datos a bordo de una FPGA. Uno de los pasos de este procesado es también el algoritmo RX que se implementará en este trabajo.

### imagenes hiperespectrales
Las imagenes hiperespectrales son imagenes en las que un espectro continuo es meddo para cada pixel. 
Estos espectros o bandas forman en su conjunto una especie de huella para cada pixelque permite reconocer materiales, diferentes tipos de vegetación, depostos minerales o contaminantes.

https://www.researchgate.net/figure/USGS-map-showing-the-location-of-different-minerals-in-the-Cuprite-mining-district-in_fig5_263532555
En la imagen se puede observar como las imagenes hiperespectrales permiten la deteccion de minerales sobre la corteza terrestre.

En este tipo de imagenes podemos hablar de tres tipos de resoluciones espacial, temporal y espectral, siendo este ultimo unico en este tipo de camaras. Local se refiere a la cantidad de metros cubiertos por cada pixel, por lo que para una misma cámara podrá cambiar de una imagen a otra. Resolucion temporal se refiere a la cantidad de imagenes que es capaz de tomar una camara por unidad de tiempo, por lo que será principalmente relevante en el momento de captura de la foto. La ultima resolucion, la espetral, se refiere a la separacion entre differentes longitudes de onda medidos en un rango determinado, es decir cuantas mas bandas capturadas en un rango menor, mayor será la resolución espectral.
https://www.sciencedirect.com/topics/computer-science/hyperspectral-image


Diferentes sensores tienen diferentes resoluciones. En este trabajo se han tomado como ejemplo los sensores de los projectos Hydice y Aviris.
Hydice: Bands 	210
Spectrum [nm] 	400-2500
Spat.Res. [m] 	0-0 
Aviris:
Spectral range: 360 - 2500 nm with a total of 224 bands. 
667\*667 px
20m -> 12km


### hardware reconfigurable

Field Programmable Gate Arrays (FPGAs) are semiconductor devices that are based around a matrix of configurable logic blocks (CLBs) connected via programmable interconnects. FPGAs can be reprogrammed to desired application or functionality requirements after manufacturing. This feature distinguishes FPGAs from Application Specific Integrated Circuits (ASICs), which are custom manufactured for specific design tasks. (he copiado este bloque de texto clavado de Xilinx).

Esta flexibilidad permite diseñar circuitos más ajustados a los algoritmos y en el caso de el procesamiento de imagenes con mucho más ancho de banda que plataformas de uso general como cpus y gpus:
ejemplo de operacion por watt
https://arxiv.org/pdf/1906.11879.pdf-
Además, estos circuitos pueden ser protegidos frente a radiaciones y a la vez, la posibilidad de diseñar una logica propia facilita la inclusión de metodos de correccion o comprobacion de errores propios.
Estas ventajas son compartidas tanto por FPGAs como ASICs.

Las ASICs proporcionan la misma flexibilidad que las fpga a la hora del diseño pero su rigidez a la hora de fabricacion les permite lograr un mejor rendimiento al solo incluir la logica expecifica del diseño, sin embargo, su coste en projectos de pequeña a mediana escala resulta prohibitivo. Además, la felixibilidad de las FPGA permite la reconfiguración ya en la nave, permitiendo el uso de diferentes algoritmos o el parcheo de bugs. (Mars Climate Orbiter)
Además, puesto que la mayoría de algoritmos implementan almacenamiento u operaciones matemáticas de precisión alta, los fabricantes de FPGA incluyen ciertos bloques prefabricados en el circuito, que aunque quitan cierta flexibilidad proporcionan mejor rendimiento que la misma lógica en CLBs. Estos bloques son principalmente memorias RAM y DSPs que permiten variedad de operaciones, entre ellas multiplicaciones o acumulaciones. Así se permite implementar algoritmos de alto rendimiento donde sería imposible usando solo logica y acercan las FPGA un poco al ambito de las ASIC.
[https://www.researchgate.net/figure/Heterogeneous-FPGA-platform-depicting-general-configurable-resources-hard-blocks-and_fig2_265125404]


### detección de anomalías

La cantidad de datos que contienen estas imagenes y su gran variedad de usos da lugar a muchos tipos de algoritmos diferentes https://www.hindawi.com/journals/jece/2013/908906/

La deteccion de anomalias es un tipo especial de tecnicas de deteccion de objetivos sin informacion previa de los objetivos. El principal obejtivo de este tipo de algoritmos es la deteccion de valores atípicos dentro de un conjunto de datos. La principal ventaja es que al no necesitar informacion previa de los obejtivos tampoco son necesarias correciones atmosfericas o radiometricas de ningun tipo.



## plan de trabajo
Primero se realizará una implementación del algoritmo en software en punto flotante que será validada con programas comerciales como ENVI o Hyspy. Sobre esta base se diseccionarán los algoritmos para poder estudiarlos y acercarlos en la medida de lo posible a su implementación en hardware. A la vez, se estudiárá la posible conversión de estas operaciones a punto fijo puesto que las fpgas tienen mejor rendimiento en ellas que las operaciones en ounto flotante. Este estudio incluye limitaciones de los DSP de la fpga y cual es la precision requerida para cada una de las operaciones para minimizar la acumulacion de errores en la medida de lo posible. Estos cambios se transferirán a la FPGA para analizar la mejora de rendimiento entre estos dos tipos de aritmetica.


## algoritmo RX
Dentro de la deteccion de anomalias, el algoritmo Rx es el mas usado y es conocido como el benchamrk de este tipo de algoritmos.
El algoritmo Reed Xiaoli extrae los objetivos, es decir pixeles o regiones, que sean espectralmente distintos a sus circundantes o al conjunto de datos completo. Para que RX sea efectivo, las anomalias deben ser lo suficientemente pequeñas relativamente al fondo. Los resultados del algoritmo son no ambiguos.
Además, aunque bandas o datos erroneos en el algoritmo se muestran como anomalos, no afectan a la deteccion de las anomalias reales.

Explicar un poquito el algoritmo en detalle.
(copiar el algoritmo rx de molero)


## estrategia de transformación de aritmética entera
Una vez hecha la implementación en software se cambiará el tipo de datos de punto flotante a entero con 64 bits. Con este cambio se podrán observar en que pasos del algoritmo se pierde precisión por llegar a los limites representables con enteros con esa resolución -tanto por ser números cercanos al cero como llegar a los valores máximos y mínimos- y se intentará mejorar la precisión multiplicando y dividiendo por potencias de dos. Estas operaciones resultan triviales en una FPGA. Este proceso se repetirá limitando los bits, es decir, la precisión de los enteros hasta alcanzar los menores posibles antes de perder precisión de forma definitiva. Con los valores de precisión obtenidos se observará la precisión que otorgan a su vez los DSP de la FPGA. Aquí se muestra una tabla con el número de DSP que necesita una multiplicación según la precisión de sus operandos.
Con los datos obtenidos de precisión y de uso de tejido, se elegirá una precisión para cada operación manteniendo estos dos valores en equilibrio.
Aquí toca mencionar, que la operación con diferencia más sensible a la perdida de precisión e introducción de errores es la inversa, específicamente la división. Aquí se ha tenido especial cuidado tanto que se realizan diferentes desplazamientos según el paso en el que se realiza esta división.

## validación y precisión
Mira, aquí ni idea que escribir y no ha sido por no echarle ganas.

# implementación en FPGA del algoritmo RX
## visión general del sistema
La camara proporciona los pixeles de la imagen por bandas. Las primeras operaciones a realizar con estos datos son calcular la media, con ella la deviación y con esta la covarianza. Dadas la relativa simpleza de estas operaciones pero sus altos requisitos en memoria, estas tres operaciones son realizadas en una CPU y sus resultados enviados a la FPGA. La FPGA comenzará el cálculo de las operaciones posteriores solo cuando tenga los resultados completos de la covarianza.
Los datos calculados por la CPU son introducidos en la FPGA a traves de FIFOs.
La FPGA calculará entonces la inversa de la matriz. Mientras tanto la CPU tendrá que escribir las medias calculadas y los valores que había recibido anteriormente de la cámara, uno por uno. Cuando termine la inversa, la FPGA realizará las dos últimas multiplicaciones de matrices y guardará los datos resultantes de cada pixel en un búfer circular en donde los mantendrá de mayor a menor, descartando estos últimos para quedarse con los más anómalos. Con el ultimo pixel procesado, la FPGA escribirá estas anomalias en otra fifo para ser leida por la CPU.

## explicación por módulos
### control
[Aquí introducir un gráfico de un bus]
[Y un diagrama de estados]
El módulo superior sirve para controlar los modulos inferiores, tanto para controlar el transpaso de datos entre ellos como para arbitrar el acceso a las RAMS y las FIFOs que comunican con la CPU.

Cabe mencionar que también realiza ciertas comprobaciones en la escritura de la covarianza para asegurar que la primera división de la inversa no se realiza con un 0, es decir, que la posicion 0, 0 en la matriz de covarianzas es /= 0.

### inversa
La inversa es con diferencia el módulo más complejo, con más gasto de recursos y con mayor susceptibilidad a introducción de errores. Por tanto, se ha hecho especial bincapién en su diseño.

Elección del algoritmo.
Antes de empezar la implementación se han estudiado varios algoritmos para realizar la inversa. 
Otros estudios como el de este señor han llegado a la misma conclusión.
Decomposión QR:
La decomposicion QR descompone la matriz A en el producto de dos matrices A = QR, siendo Q una matriz ortogonal y R una matriz triangular superior. A−1=R−1Q−1=R−1QT and R−1 Con esta matriz triangular resulta sencillo calcular la inversa. La conclusión de este estudio ha sido que la decomposicion QR puede ser beneficiosa mientras que se cuente con un modulo de multiplicacion matricial potente o varios modulos que puedan ser ejecutados de forma simultanea. Sin embargo, no aprovecha las ventajas proporcionadas por nuestro sistema como pueden ser un tamaño de matrices determinado.

Inversa por Gauss:
El metodo dde Gauss Jordan dicta que si tenemos una matriz A que puede ser transformada en la matriz identidad a través de operaciones elementales, estas mismas operaciones tranforman la matriz identidad en A-1. Puesto que es posible ejecutar estas operaciones de golpe e un fila entera y las operaciones entre filas son independientes, este metodo es fácilmente paralelizable.
A rasgos generales, la ejecucion del algoritmo transcurre tal que:
	Se genera una matriz identidad
	Se realizan las mismas operaciones sobre ambas matrices
	El resultado se encuentra en la matriz generada


Las operaciones elementales se realizan en 3 pasos, primero se transforma la matriz A en forma con triangulo superior, luego se resuelve el triangulo inferior para transformarla en diagonal y finalmente se divide la matriz entre si misma para conseguir la forma row echelon.
También es posible convertir una fila a row echelon directamente realizando los 3 pasos seguidos, pero esta forma no permite la misma granularidad que permitirá más tarde reducir la acumulacion de error.

Optimizaciones del algoritmo de cara a hardware.
Las operaciones a realizar en los tres pasos son similares, así que con el fin de ahorrar recursos se han implementado sobre la misma lógica. Existe un proceso superior con los contadores para controlar el orden de su ejecución. (counter_proc).

Para mejorar el rendimiento del modulo, las operaciones sobre la matriz A y la matriz I se ejecutan de forma simultanea. Además, mientras las operaciones de una fila se encuentran procesandose, las siguientes filas son procesadas. La unica espera ocurre cuando se necesita el resultado de una fila para el procesado de las siguientes. Esto es similar a loop unrolling. Para ello, se usan varios procesos para controlar la lectura, la escritura y la captura de la fila que actua como pivote (write_proc y capture_i_proc).
Como se puede observar en el algoritmo, el elemento [i] es usado dos veces. Para poder realizar operaciones sobre filas posteriores sin retrasar lecturas, es necesario guardar este dato en una memoria auxiliar y leerlo en el momento en el que se vuelva a necesitar. Esta memoria está construida a partir de una fifo temp_convj.

Además, se puede obervar que el algoritmo exige una comprobacion de un valor en la fila pivote y una psoible rotacion de filas. Este valor es posteriormente el dividendo, por lo que un 0 provocaría un fallo en el cálculo. En este diseño se ha optado por una tabla de renombramiento con el fin de minimizar las latencias en el caso del trueque. Estas comprobaciones se realizan a partir de la primera escritura. Al realizar las comprobaciones en las escrituras, se puede encontrar una fila válida simplemente observando las siguientes escrituras. Esta tabla de escrituras es local, por lo que los resultados tienen que ser reordenados antes de salir del modulo. Puesto que estos trueques solo ocurren en el calculo del triangulo superior, se puede aprovechar el triangulo inferior para reordenarlos. Esto también acontece en la escritura. Los resultados de este reordenamiento van a ser correctos siempre y cuando ambas filas que necesiten ser rotadas se encuentren en el pipeline de procesamiento, que en el caso de  punto fijo tiene aproximandamente un tamaño de 80. Resultados experimentales muestran que rara vez hay que rotar filas (aunque lo suficiente como para ser recomendabke la inclusión de un metodo que lidie con ello), pero que estas rotaciones rara vez exceden más una o dos posiciones en adelante.

En la transofrmación a aritmetica de punto fijo se descubrió que este calculo es que más error llega a introducir en los resultados finales del algoritmo, por lo tanto se ha hecho estudio exhaustivo en  sobre como minimizarlo. En la siguiente tabla se puede ver el uso de DSP frente a su precision. El objetivo ha sido encontrar el mejor balance entre DSP y menor error introducido en la operacion.
Para poder aprovechar este balance, ha sido necesario reducir los valores en los que la precision limitada producia desbordamientos y aumentar valores pequeños apra otorgales mas peso en las operaciones. Además, al realizar las operaciones de generacion de identidad, triangulo superior, inferior y diagonal de forma separada, se ha podido colocar diferentes multiplicadores para aumentar la precision todavia más. Estas operaciones se encuentran en el proceso (shift_proc)
Tabla con los resultados con todo en 1, con la generacion de identidad en 29, y con todo metido. 

Por ultimo, cabe decir que existe un error en la generacion de divisores de Xilinx. Cuando se introducen numeros cerca del limite de precision se pierde el control del signo. Por lo tanto se ha colocado un modulo antes de la divison que convierte todos los operandos introducidos en positivos y guarda su posicion en el pipeline. En el momento de producirse los resultados, se comprueba el tag en el pipeline, se calcula el negativo y se sustituye si es neesario. El proceso es divisor_proc.

### Mean subtract
El modulo de mean subtract simplemente realiza la resta de la media a la matriz de pixeles orginal. Este calculo es la deviacion. Aunque ya había sido calculada por la cpu, merece la pena implementarla en la fpga en el caso de que la cpu deba deshechar la deviacion por falta de memoria pero pueda volver a obtener la imagen original de la camra. El calculo de la media si que se requiere puesto que su tamaño es mucho menor.
El modulo recibe los elementos desde el modulo superior. Los primeros que son la media son guardados en una ram que es tratada como un buffer circular, y los elementos que le siguen son restados directamente y devueltos al modulo superior de nuevo.


### Matrix multiplication
N bandas
M pixeles
https://www.harrisgeospatial.com/docs/RXAnomalyDetection.html
This module performs the multiplication between the deviation and inverse matrixes.
rx(x) = (x − µ) T K −1
N×N (x − µ)
K −1
N×N
being the inverse matrix with a dimension of N × N,
(x − µ) being the deviation of a pixel a dimension of N × 1 and
(x − µ) T its transpose, with a dimension of 1 × N.
The inverse gets read directly from the inverse module's output BRAM and the deviation
matrix from two FIFOS written by the CPU. The result gets written back to another FIFO.
In this step, the inverse matrix gets e?ectively multiplied by a unique pixel across all
bands. Through row reduction, a single value for this pixel is recovered which can then be
mapped to a 2d image.
Since the operands are heterogeneous, use is made of the associative law on matrix
products that dictates that:
A ∗ (B ∗ C) = (A ∗ B) ∗ C
to optimize the operation.
Following will be a comparison of the ?rst required multiplication in both methods:
(x − µ) T K −1
N×N : A row from the inverse and the whole column of the deviation
get read, each element multiplied with its correspondent and all products added
together. If stalls were to be avoided, this sum would need to be computed every
cycle, which can easily be achieved with an adder tree.
Figure 1.1: First proposed method for the computation of a single pixel: red, blue and
green represent data processed in the ?rst, second and third cycles respectively. Note that
the entire deviation data of that pixel gets used every cycle
K −1
N×N (x − µ): The inverse gets also read row by row, but the deviation matrix
only by elements. Each element of the ?rst row of the matrix gets multiplied with
the ?rst element of the deviation, the result accumulated, and continued with the
next pair row/element. This goes for N cycles, that is, a whole inverse matrix
and a whole pixel in the deviation matrix. The result is N accumulated values
which get ?ushed every N cycles, which ends up being the same throughput as
the former method
Figure 1.2: Second proposed method: red, blue and green represent data processed in the
?rst, second and third cycles respectively. Here only an element of the deviation data gets
accessed each cycle.
While both methods have equivalent cost in time -the former has the added latency of
the adder tree, the latter the latency of the accumulators- and also similar cost in DSP
usage, data input by row is less taxing on the CPU and its FIFO structure can be reused
for the second multiplication. Henceforth, the second approach was chosen.
The second multiplication is similar in both steps, a 1×N by N ×1 multiplication. One
operand comes every cycle and each N cycles all products get added together. This sum is
realized through an accumulator.
The module contains three subprocesses:
 ?rst_mac reads the inverse and performs its multiplication with the ?rst FIFO. The
products are then accumulated till a whole pixel has been computed.
 second_mac stores the results of ?rst_mac in registers and performs the multiplication
with the second FIFO, with the result being accumulated. Every cycle, the registers
are shifted so a new multiplication is done.
 write_proc controls the writing of the results from second_mac to the result FIFO.

### sorter
 El sorter recibe un valor y un par de coordenadas cada n_bandas ciclos. Estos valores son escritos en una memoria ram que actua como una lista ordenada. Cada valor introducido es comparado con la cabeza de la lista, el valor más alto guardado y el otro es guardado en una variable temporal y comparada con el segundo valor en la lista, así sucesivamente. Puesto que se recibe un valor cada n_bandas, el numero maximo de valores posibles a almacenar en esta lista es también n_bandas. El resto de valores son deshechados. Cuando se ha introducido el ultimo valor, el modulo comunica los pixeles más altos, es decir, más anomalos, al modulo superior para que estos sean comunicados a la cpu.
### ejecucion paso a paso
que tengo que poner aqui

# resutados experimentales
## plataforma reconfigurabke
## conjunto de images hiperespectrales
## evaluacion de las anomalias detectadas
## evaluacion del rendimiento

# conclusiones

#bibliografia