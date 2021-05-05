# Autoubicación ideológica por grupos de edad

Código y gráficos para el artículo [*El colectivo NS/NC, en peligro de extinción*](https://filasycolumnas.substack.com/p/el-colectivo-nsnc-en-peligro-de-extincion) publicado en mi newsletter personal [FILAS Y COLUMNAS](https://filasycolumnas.substack.com/).

---

## Raw data y fuentes

La fuente original de los datos es el **Centro de Investigaciones Sociológicas (CIS)**, a los que he accedido a través del [Fichero Integrado de Datos (FID)](http://analisis.cis.es/fid/fid.jsp). El archivo original está disponible [en esta ubicación](data/raw/FID_2264.txt) y el diccionario de variables, [en esta otra](data/dictionaries/FID_2264_STR.txt).

---

## Tidy data

El script [data_tidying.R](scripts/data_tidying.R) detalla el codigo del proceso ETL para obtener el tidy dataset [autoubicacion_edades_tidy.csv](data/tidy/autoubicacion_edades_tidy.csv). Estas son las variables del dataset:

Variable|Descripción|Tipo
----|-----------|:--:
`estudio`|Número del estudio del CIS|Number
`fecha`|Mes del estudio en formato YYYY-MM-DD|Date
`ano_mes`|Año y mes del estudio|Number
`ano`|Año del estudio|Number
`mes`|Mes del estudio|Number
`numentr`|Identificador único de la persona entrevistada|Number
`edad`|Edad en años del entrevistado|Number
`grupo_edad`|Grupo de edad del entrevistado|Character
`fecha_nacimiento`|Año de nacimiento obtenido tras restar la edad al año del estudio|Number
`decada_nacimiento`|Década de nacimiento a partir del año de nacimiento obtenido|Character
`autoubicacion`|Autoubicación ideológica del entrevistado|Number
`autoubicacion_grupo`|Grupo ideológico a partir de la autoubicación declarada|Character

---

## Análisis exploratorio de datos

El análisis exploratorio de datos se realizó en R Markdown. El código figura [en este script](scripts/exploratory_data_analysis.Rmd).

---

## Gráficos finales

El código para la elaboración y producción de los gráficos finales con la librería ggplot2 está detallado [en este script](scripts/graficos_definitivos.R).

