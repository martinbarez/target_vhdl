# Abstract

En los últimos años se puede observar un resurgimiento de la carrera espacial motivado especialmente por empresas comerciales. Sus aeronaves son equipadas una multitud de sensores, siendo uno de ellos las cámaras hiperespectrales. Este tipo de cámaras toma imágenes en cientos de bandas espectrales diferentes, con el objetivo de proporcionar información sobre el terreno.
A causa del gran tamaño de estas imágenes, estas son enviadas a la tierra para su procesado, con el consecuente uso de red. Preferentemente estas imágenes deberían procesarse o comprimirse in situ para enviar solo una parte de los datos obtenidos. Dados el entorno espacial y la rigidez y facilidad de ser paralelizado de este tipo de algoritmos, las FPGAs o ASICs se postulan como un sistema óptimo para su implementación.
Este trabajo presenta una implementación sobre FPGAs del algoritmo detector Reed-Xiaoli de anomalías para imagenes hiperespectrales. Para su implementación se ha realizado un análisis de las operaciones del algoritmo, centrada en una implementación en punto flotante y otra en fijo, sus requisitos en lógica, y de las repercusiones que tienen ciertas decisiones con la precisión que se alcanza. Finalmente se presenta una implementación óptima.


# Introduction

## motivaciones y objetivos

La navegación espacial cumple muchos objetivos, el más obvio siendo recopilar información acerca de nuestro planeta y lo que le rodea. Para ello se crean sensores capaces de recopilar información, como por ejemplo antenas o telescopios que son usados tanto desde la Tierra como enviados a bordo de naves espaciales. Uno de ellos son las cámaras hiperespectrales, que toman fotos en cientos de bandas distintas. Estos datos permiten encontrar objetos, detectar materiales o identificar procesos. A medida que la tecnología avanza, estos sensores evolucionan requeriendo de soluciones de procesado acordes para interpretar los datos o comprimirlos y enviarlos a tierra.

El objetivo de este trabajo es la implementación de uno de estos algoritmos de forma que resulte preferenta el procesado en la aeronave. Para ello se estudiarán diferentes tipos tanto de algoritmos como de plataformas.

## antecedentes
https://eprints.ucm.es/15828/1/T33468.pdf
https://www.researchgate.net/publication/220243592_Fast_real-time_onboard_processing_of_hyperspectral_imagery_for_detection_and_classification
https://public.lanl.gov/jt/Papers/onboard-post.pdf
Literalmente todos el procesamiento se realiza en fpgas. Claro que tengo que escribir algo pero no se me ocurre nada ahora.

### imagenes hiperespectrales
Las camaras hiperespectrales son el producto de la convergencia de dos disciplinas, la espectrometria y la toma de imaganes remotas de las superfecies planetarias. La espectroscopia es el estudio de la luz emitida o reflejada por materiales y su variacion en energia con la longitud de onda. Aplicado al campo de la deteccion remota, permite el reconocimiento de materiales en la superficie terrestre como vegetación, depostos minerales o contaminantes.

https://www.researchgate.net/figure/USGS-map-showing-the-location-of-different-minerals-in-the-Cuprite-mining-district-in_fig5_263532555
En la imagen se puede observar como las imagenes hiperespectrales permiten la deteccion de minerales sobre la corteza terrestre

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

Las ASICs proporcionan la misma flexibilidad que las fpga a la hora del diseño pero su rigidez a la hora de fabricacion les permite lograr un mejor rendimiento al solo incluir la logica del diseño, sin embargo, su coste es prohibitivo incluso a gran escala. Además, la felixibilidad de las FPGA permite la reconfiguración ya en la nave, permitiendo el uso de diferentes algoritmos.
Además, puesto que la mayoría de algoritmos implementan almacenamiento u operaciones matemáticas de precisión alta, los fabricantes de FPGA incluyen ciertos bloques prefabricados en el circuito, que aunque quitan cierta flexibilidad proporcionan mejor rendimiento que la misma lógica en CLBs. Estos bloques son principalmente memorias RAM y DSPs que permiten variedad de operaciones, entre ellas multiplicaciones o acumulaciones. Así se permite implementar algoritmos de alto rendimiento donde sería imposible usando solo logica y acercan las FPGA un poco al ambito de las ASIC.


### detección de anomalías

La cantidad de datos que contienen estas imagenes y su gran variedad de usos da lugar a muchos tipos de algoritmos diferentes https://www.hindawi.com/journals/jece/2013/908906/

La deteccion de anomalias es un tipo especial de tecnicas de deteccion de objetivos sin informacion previa de los objetivos. El principal obejtivo de este tipo de algoritmos es la deteccion de valores atípicos dentro de un conjunto de datos. La principal ventaja es que al no necesitar informacion previa de los obejtivos tampoco son necesarias correciones atmosfericas o radiometricas de ningun tipo.



## plan de trabajo
Primero se realizará una implementación del algoritmo en software en punto flotante que será validada con programas comerciales como ENVI o Hyspy. Sobre esta base se diseccionarán los algoritmos para poder estudiarlos y acercarlos en la medida de lo posible a su implementación en hardware.

Una vez el diseño final esté fijado, se procederá a su implementación en FPGA.
Con la implementación en FPGA hecha, se volverá al software donde se estudiará su conversión a punto fijo y la precisión requerida en cada una de las operaciones del algoritmo y como minimizarla manteniendo el error lo más pequeño posible.
Una vez hecho el estudio, se transferirán los cambios realizados en software de vuelta a la implementación en hardware para su evaluación.


## algoritmo RX
Dentro de la deteccion de anomalias, el algoritmo Rx es el mas usado  y es conocido como el benchamrk de este tipo de algoritmos.
El algoritmo Reed Xiaoli extrae los objetivos, es decir pixeles o regiones, que sean espectralmente distintos a sus circundantes o al conjunto de datos completo. Para que RX sea efectivo, las anomalias deben ser lo suficientemente pequeñas relativamente al fondo. Los resultados del algoritmo son no ambiguos.
Además, aunque bandas o datos erroneos en el algoritmo se muestran como anomalos, no afectan a la deteccion de las anomalias reales.

Explicar un poquito el algoritmo en detalle.


## estrategia de transformación de aritmética entera
Una vez hecha la implementación en software se cambiará el tipo de datos de punto flotante a entero con 64 bits. Con este cambio se podrán observar en que pasos del algoritmo se pierde precisión por llegar a los limites representables con enteros con esa resolución -tanto por ser números cercanos al cero como llegar a los valores máximos y mínimos- y se intentará mejorar la precisión multiplicando y dividiendo por potencias de dos. Estas operaciones resultan triviales en una FPGA. Este proceso se repetirá limitando los bits, es decir, la precisión de los enteros hasta alcanzar los menores posibles antes de perder precisión de forma definitiva. Con los valores de precisión obtenidos se observará la precisión que otorgan a su vez los DSP de la FPGA. Aquí se muestra una tabla con el número de DSP que necesita una multiplicación según la precisión de sus operandos.
Con los datos obtenidos de precisión y de uso de tejido, se elegirá una precisión para cada operación manteniendo estos dos valores en equilibrio.
Aquí toca mencionar, que la operación con diferencia más sensible a la perdida de precisión e introducción de errores es la inversa, específicamente la división. Aquí se ha tenido especial cuidado tanto que se realizan diferentes desplazamientos según el paso en el que se realiza esta división.

## validación y precisión
Mira, aquí ni idea que escribir y no ha sido por no echarle ganas.

# implementación en FPGA del algoritmo RX
## visión general del sistema
La camara saca los datos de banda en banda. Las primeras operaciones con estos datos serían calcular la media, con ella la deviación y con esta la covarianza. Estas tres operaciones son relativemente simples, pero actuan sobre una gran cantidad de datos. Resulta más eficiente procesar estos datos en una cpu y enviarlos posteriormente a la FPGA que su procesado completo en esta ultima. La única operación que requiere un poco más de procesado es el calculo de la covarianza puesto que se trata de una multiplicacion de dos matrices. La FPGA esperará por lo tanto a tener esta matriz entera hasta empezar el siguiente paso.
Estos datos calculados por la CPU son introducidos en la FPGA a traves de FIFOs simples.
La FPGA calculará entonces la inversa de la matriz. Mientras tanto la CPU tendrá que escribir las medias calculadas y los valores que había recibido anteriormente de la cámara, uno por uno. Cuando termine la inversa, la FPGA realizará las do´s últimas multiplicaciones de matrices y  guardará los datos resultantes de cada pixel en un búfer circular en donde los mantendrá de mayor a menor, descartando estos últimos para quedarse con los más anómalos. Con el ultimo pixel procesado, la FPGA escribirá estas anomaias en otra fifo para ser leida por la CPU.

## explicación por módulos
### control
El módulo superior sirve como árbitro para controlar el acceso a las RAMs de cada uno de los módulos inferiores. La inversa se calcula en su modulo, cuando este cálculo ha termino este acceso pasa a ser del multiplicador de matrices. También obtiene los datos de entrada de la fifo para la covarianza y lo escribe en una RAM, y los datos de salida de los pixeles ordenados que escribe en otra fifo para su salida.

Aunque la razón se encuentra explicada en el módulo de la inversa, cabe mencionar que controla las escrituras de la covarianza para no escribir una fila en la primera fila de la RAM en la que se encuentre un 0 en la primera posición.

### inversa
La inversa es con diferencia el módulo más complejo, con más gasto de recursos y con mayor susceptibilidad a introducción de errores. 

Elección del algoritmo.
Antes de empezar la implementación se han estudiado varios algoritmos para realizar la inversa. Han sido varios algoritmos por de composición de QR y la inversa de gauss. La conclusión ha sido que, aunque la descomposición de QR puede ser beneficiosa mientras se cuente con un módulo potente de multiplicación matricial. En nuestro caso, donde el tamaño de las matrices viene determinado, podemos acelerar y simplificar el proceso realizando operaciones en filas completas como es por gauss.
Dentro de las operaciones de Gauss, es posible intercalarlas o realizar tres pasos diferentes bien definidos. En este caso, se prefirió está segunda forma puesto que simplificaba el código y permitía realizar ajustes más finos que se traducen finalmente en errores menores. Se proporciona código en Python de estas tres implementaciones.

El método de gauss jordan ocurre en estos tres pasos:
	Triangulo superior
	inferior
	diagonal
Cada uno de estos pasos se realiza más o menos de la siguiente manera.
Como se puede observar, sobre la misma línea de datos se realizan una división, una multiplicación y una resta.
Puesto que hay una división, es posible que en cierto momento se vaya a dividir por cero. Este caso solo puede darse en el primer paso, es decir, la construcción del triángulo superior y la solución es simplemente la rotación de esta fila con una fila en la que no se encuentre el cero. Esto se ha implementado en la FPGA a través de renombrado de registros. Si no se encuentra una fila valida, la operación se marca como fallida y se vuelve al estado inicial del módulo.
Para simplificar el diseño y predecir estos casos para no perder ciclos buscando una división valida, los ceros son detectados al escribir los resultados de la operación anterior. Cuando se encuentra un 0 en la primera fila escrita como resultado de un ciclo, que va a ser el divisor del ciclo siguiente, se empiezan a leer los divisores de todas las filas escritas, cuando se encuentra uno valido, la dirección de las filas se escribe en una tabla de renombrado para ser leídas en el orden correcto. Puesto que la primera división de todas no es resultado de ninguna operación, es necesario otro mecanismo de control. Esto se realiza en el módulo que lee de las FIFOs de la CPU a la RAM, donde solo se escribe en la primera fila una fila si no contiene un 0.
Puesto que la tabla de renombrado es local al módulo de la inversa, es necesario reordenar las filas. Aprovechándonos de que solo pueden darse casos de 0 en la división en el triángulo superior, este renombramiento tiene lugar en el triángulo inferior. Las filas son leídas según su tabla de renombrado, pero son escritas en el orden "correcto". Esto es posible ya que antes de que se escriba la primera fila reordenada, aproximadamente 50 de ellas en el caso de punto flotante, y 80 en el caso de punto fijo se encuentran ya cargadas correctamente en el pipeline. Una escritura en una fila no leída todavía provocaría un error, pero dada la pequeña probabilidad de encontrar un 0 en la covarianza, y menor todavía de encontrar 80 seguidos, es asumible. Esta simplificación permite mantener esta tabla de renombrados de forma local y evita tener un módulo más entre órdenes y direcciones de lectura lo que sumaría latencia.
El módulo en si ha sido optimizado para realizar lecturas de los datos y empezar la siguiente operación lo antes posible. Un cortocircuito entre los datos que se van a escribir y la siguiente operación no es posible ya que se requiere de una escritura para poder escribirlos, y un cambio dinámico de si se escribe o se cortocircuita complicaría notablemente el diseño, lo que al fin y al cabo solo dificulta otras optimizaciones más sensibles e introduce bugs.

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
### ejecucion paso a paso

# resutados experimentales
## plataforma reconfigurabke
## conjunto de images hiperespectrales
## evaluacion de las anomalias detectadas
## evaluacion del rendimiento

# conclusiones

#bibliografia