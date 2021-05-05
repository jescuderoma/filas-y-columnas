# Tiempo de los ocupados en su trabajo actual (2005-2020)

Código y gráficos para el artículo [*El auge del empleo paracaidista*](https://filasycolumnas.substack.com/p/el-auge-del-empleo-paracaidista-) publicado en mi newsletter personal [FILAS Y COLUMNAS](https://filasycolumnas.substack.com/).


---

## Raw data y fuentes

La fuente original de los datos son los [microdatos trimestrales de la Encuesta de Población Activa (EPA)](https://www.ine.es/dyngs/INEbase/es/operacion.htm?c=Estadistica_C&cid=1254736176918&menu=resultados&idp=1254735976595#!tabs-1254736030639) del INE para el período 2005-2020. El proceso de unión y limpieza de todos los archihvos trimestrales está detallado [en este script](https://github.com/jescuderoma/microdatos-epa/blob/master/scripts/01_importar_combinar_microdatos.R). El archivo resultante, de más de 10,5 millones de filas y 93 variables, no se ha compartido en GitHub por su peso (2,8 GB).

---

## Gráficos finales

El código para la elaboración y producción de los gráficos finales con la librería ggplot2 está detallado [en este script](scripts/exploratory_data_analysis.R).
