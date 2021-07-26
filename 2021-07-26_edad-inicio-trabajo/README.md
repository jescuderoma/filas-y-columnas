# Edad mediana del primer trabajo por generaciones

Código y gráficos para el artículo [*El primer escalón hacia la vida adulta cada vez llega más tarde*](https://filasycolumnas.substack.com/p/el-primer-escalon-hacia-la-vida-adulta) publicado en mi newsletter personal [FILAS Y COLUMNAS](https://filasycolumnas.substack.com/).

---

## Raw data y fuentes

Los datos en bruto proceden de la [Estdística de Condiciones de Vida](https://www.ine.es/dyngs/INEbase/es/operacion.htm?c=Estadistica_C&cid=1254736176807&menu=ultiDatos&idp=1254735976608) que el INE publica cada año. En concreto, la información original es el [fichero transversal P de microdatos](https://www.ine.es/dyngs/INEbase/es/operacion.htm?c=Estadistica_C&cid=1254736176807&menu=resultados&idp=1254735976608#!tabs-1254736195153) de la Encuesta de Condiciones de Vida 2008-2020, correspondiente a los adultos (16 o más años).

El proceso de unión y limpieza de los microdatos anuales de adultos (16 o más años) de la ECV 2008-2020 en un único archivo está detallado [en este script](scripts/data_tidying.R). El diseño de registro y el diccionario de variables está [disponible en este enlace](https://www.ine.es/metodologia/t25/dise%C3%B1o_registro_ecv.pdf).

Del archivo resultante se han seleccionado las columnas necesarias para el artículo, dando lugar al tidy dataset [edad_primer_trabajo_tidy.csv](data/tidy/edad_primer_trabajo_tidy.csv). Estas son las variables del dataset:

Variable|Descripción|Tipo
----|-----------|:--:
`PB010`|Año de la Encuesta de Condiciones de Vida|Integer
`PB030`|Identificación transversal de la persona (completo)|Character
`DB030`|Identificación transversal del hogar|Character
`PB030_a`|Identificación transversal de la persona (nº de orden a dos dígitos)|Character
`PB040`|Factor de ponderación|Double
`DB040`|Región/Comunidad autónoma del hogar|Character
`DB100`|Grado de urbanización|Character
`PB140`|Año de nacimiento de la persona encuestada|Double
`PB140_F`|No consta o variable completada|Character
`PL190`|Edad en la que empezó a trabajar regularmente|Double
`PL190_F`|No ha trabajado nunca, no consta o variable completada|Character
`nacimiento`|Año de nacimiento de la persona encuestada (1939 = 1939 o antes)|Double
`generacion`|Generación a la que pertenece la persona encuestada|Factor

---

## Gráficos finales

El código para la elaboración y producción de los gráficos finales con la librería ggplot2 está detallado [en este script](scripts/graficos_definitivos.R).
