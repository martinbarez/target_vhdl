# Abstract

En los últimos años se ha observado un resurgimiento de la carrera espacial motivado especialmente por empresas comerciales. Estas aeronaves son equipadas con una gran cantidad de sensores, siendo uno de ellos las cámaras hiperespectrales. Este tipo de cámaras toma imágenes en cientos de bandas espectrales diferentes, con el objetivo de proporcionar información sobre el terreno.
A causa del gran tamaño de estas imágenes, estas son enviadas a la tierra para su procesado, con el consecuente uso de red. De manera óptima, estas imágenes deberían procesarse o comprimirse in situ para enviar solo parte de los datos obtenidos. Dados el entorno espacial, los requisitos de un sistema de este tipo y los parámetros de este tipo de operaciones como pueden ser su paralelismo y rigidez en torno a latencia y memoria, las FPGAs o ASICs se postulan como un sistema óptimo.
Este trabajo presenta una implementación sobre FPGAs del algoritmo detector Reed-Xiaoli de anomalías en este tipo de imágenes. Para su implementación se ha realizado un análisis de las operaciones del algoritmo, centrada en una implementación en punto flotante y otra en fijo, sus requisitos en lógica, y de las repercusiones que tienen ciertas decisiones con la precisión que se alcanza. Finalmente se presenta una implementación óptima.


# Introduction

Los vehículos espaciales son normalmente equipados con una gran cantidad de sensores, uno de ellos las cámaras hiperespectrales. Estas cámaras toman fotos en cientos de bandas distintas, con el objetivo de encontrar objetos, detectar materiales o identificar procesos. A medida que la tecnología avanza, estas naves son equipadas con sensores más potentes, que a su vez requieren de soluciones de procesado acordes para interpretar los datos o comprimirlos y enviarlos a tierra.
Ejemplos de estos sistemas pueden ser Hydcies o Aviris.
Las FPGAs han jugado siempre un papel importante en la industria espacial, por razones desde su resistencia a radiación hasta su bajo coste energético por operación de procesado. A medida que nuevas FPGAs llegan al mercado, nuevas aplicaciones permiten implementarse en ellas y ser traídas a la nave en vez de depender de bases terrestres.

Hyperspectral imaging deals with high dimensionality matrixes (64, 64, 169 px) in the case of hydice that were impossible to implement in a single FPGA till now. 

FPGAs have been consolidated as the go to device, as a balance of power and cost.
Standard computing platforms as CPUs use much more power, https://arxiv.org/pdf/1906.11879.pdf- While this is not a problem in earth-based stations, some spacecrafts may not be able to keep up with their requirements.
Compared to Asics, FPGAs bring field reconfigurability and faster time to launch. Field reconfigurability may not be really useful as the sensor on a spacecraft may not be upgraded, but bugs and errors can be fixed at any time. Also, they are cheaper and their difference in performance has shortened in the last years due to smaller node processes.
GPUs share a lot of the parallel capabilities as FPGAs, they still suffer from some of the same disadvantages as CPUs.

## motivaciones y objetivos
Los avances en sensores han aumentado la cantidad de datos que puede ser procesada. El envío de estos datos a la tierra satura los canales de comunicación. Una FPGA puede ser incluida en la nave para preprocesar estos datos y limitar la cantidad que tiene que ser enviada a la tierra. Los avances en FPGAs pueden permitir incluir algoritmos más complejos o mayor exactitud en esos cálculos.
El objetivo es implementar el algoritmo RX en una FPGA para analizar imágenes de un satélite en órbita.

## antecedentes
artículos del uso de FPGAs en satélites, el artículo de hace 20 años que estaba guay, el trabajo de hace un par de años de estos chavales, lo de noise reduction de carlos
Que hasta ahora se había hablado de ello, pero es gracias a nuevas y más grandes FPGAs cuando se puede hacer por fin

### imagenes hiperespectrales


### hardware reconfigurable

### detección de anomalías

la detección de anomalías es un proceso que identifica valores atípicos dentro de un conjunto de datos. En nuestro caso basado en imágenes satelitales, estos valores pueden ser minerales en el terreno, enfermedades en cultivos, estructuras artificiales. Aunque muchos de estos algoritmos han sido propuestos en la literatura, el más conocido es el RX.


## plan de trabajo
Primero se realizará una implementación del algoritmo en software que será validada con programas comerciales como ENVI o Hyspy. Sobre esta base se diseccionarán los algoritmos para poder estudiarlos y acercarlos en la medida de lo posible a su implementación en hardware.

Una vez el diseño final esté fijado, se procederá a su implementación en FPGA.
Con la implementación en FPGA hecha, se volverá al software donde se estudiará la precisión requerida en cada una de las operaciones del algoritmo y como minimizarla manteniendo el error lo más pequeño posible.
Una vez hecho el estudio, se transferirán los cambios realizados en software de vuelta a la implementación en hardware para su evaluación.


# transformación del algoritmo RX a aritmética entera


## algoritmo RX
El algoritmo RX caracteriza el fondo con un vector medio y una covarianza. El detector en si calcula la distancia entre el píxel under test y el fondo de la siguiente manera.

## estrategia de transformación de aritmética entera
Una vez hecha la implementación en software se cambiará el tipo de datos de punto flotante a entero con 64 bits. Con este cambio se podrán observar en que pasos del algoritmo se pierde precisión por llegar a los limites representables con enteros con esa resolución -tanto por ser números cercanos al cero como llegar a los valores máximos y mínimos- y se intentará mejorar la precisión multiplicando y dividiendo por potencias de dos. Estas operaciones resultan triviales en una FPGA. Este proceso se repetirá limitando los bits, es decir, la precisión de los enteros hasta alcanzar los menores posibles antes de perder precisión de forma definitiva. Con los valores de precisión obtenidos se observará la precisión que otorgan a su vez los DSP de la FPGA. Aquí se muestra una tabla con el número de DSP que necesita una multiplicación según la precisión de sus operandos.
Con los datos obtenidos de precisión y de uso de tejido, se elegirá una precisión para cada operación manteniendo estos dos valores en equilibrio.
Aquí toca mencionar, que la operación con diferencia más sensible a la perdida de precisión e introducción de errores es la inversa, específicamente la división. Aquí se ha tenido especial cuidado tanto que se realizan diferentes desplazamientos según el paso en el que se realiza esta división.
## validación y precisión
Con el fin de poder adaptar el algoritmo a diferentes sensores y a su vez testear el algoritmo con imágenes más pequeñas, se ha hecho especial hincapié en la modularidad del sistema. Vivado no ha permitido ejecutar tesbench sobre una imagen entera, solo secciones de ella. En implementación sí que se ha podido testear toda la imagen. Aquí tengo que poner graficas con más imágenes y mierdas.

# implementación en FPGA del algoritmo RX
## visión general del sistema
La cámara produce los datos de los pixeles de forma cruda. Las primeras transformaciones de estos datos serían calcular la media, la deviación y con ella la covarianza. Estas tres operaciones son muy simples, pero necesitan la matriz de la cámara entera. Puesto que trasferir todos estos datos a la FPGA solo añadiría latencia sin añadir ningún valor real, estos datos son calculados en la CPU. Una vez calculada la covarianza, esta es escrita fila por fila en FIFOs que actúan como tuberías entre la CPU y la FPGA.
La FPGA recibe un comando de start para empezar a leer esta fifo y empieza el procesado cuando ha acabado de leer todos los datos.
Posteriormente, la CPU escribirá la media y el valor de cada píxel uno por uno en una fifo diferente. En este segundo calculo no se controla el estado de llenado de las FIFOs, por lo tanto, es necesario que la CPU no pierda muchos ciclos entre empezar el cálculo y la escritura de estos datos. Por suerte, la inversa de la matriz es suficientemente larga como para permitir esto sin que dé lugar a problemas.
Después de estas operaciones, la FPGA guardará los datos resultantes de cada pixel en un búfer circular en donde los mantendrá de mayor a menor, descartando estos últimos para quedarse con los más anómalos. El numero máximo de pixeles que puede mantener es igual al número de bandas, como lo más normal es tener 30 pixeles en una imagen con 169 bandas, esto no supondrá ningún problema.

## explicación por módulos
### top_module
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