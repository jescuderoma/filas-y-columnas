# Distribución anual de los nacimientos por meses (1975-2019)

Código, datasets, análisis exploratorio de datos y gráficos para el artículo [*Los 'beberoños' de los millennials*]() publicado en mi newsletter personal [FILAS Y COLUMNAS](https://filasycolumnas.substack.com/).

---

## Raw data y fuentes

La fuente original de los datos es la **Estadística de Nacimientos**, a la que he accedido a través del [servicio API JSON](https://www.ine.es/dyngs/DataLab/manual.html?cid=45) del Instituto Nacional de Estadística (INE). El proceso ETL está detallado [en este script](scripts/data_tidying.R). 

---

## Análisis exploratorio de datos

El análisis exploratorio de datos se realizó en R Markdown. El código figura [en este script](scripts/exploratory_data_analysis.Rmd).

---

## Gráficos finales

El código para la elaboración y producción de los gráficos finales con la librería. ggplot2 está detallado [en este script](scripts/graficos_definitivos.R).





