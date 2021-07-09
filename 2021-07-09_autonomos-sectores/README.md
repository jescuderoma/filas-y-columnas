# Trabajadores autónomos por actividades económicos

Código y gráficos para el artículo [**]() publicado en mi newsletter personal [FILAS Y COLUMNAS](https://filasycolumnas.substack.com/).

---

## Raw data y fuentes

Los [datos en bruto](https://github.com/jescuderoma/filas-y-columnas/blob/main/2021-04-12_erte-afiliados-sectores/data/raw/afiliados_medios.csv) proceden de la [Estadística mensual de afiliados medios por régimen y actividad económica](https://w6.seg-social.es/PXWeb/pxweb/es/Afiliados%20en%20alta%20laboral/Afiliados%20en%20alta%20laboral__Afiliados%20Medios/12m_02%20Afi.%20Med.%20(R.%20General%20y%20RETA)%20CNAE-09%20desde%202009%20por%20R%C3%A9gimen%20y%20Actividad%20Econ%C3%B3mica.px/) de la Seguridad Social.
---

## Tidy data

El script [data_tidying.R](https://github.com/jescuderoma/filas-y-columnas/blob/main/2021-04-12_erte-afiliados-sectores/scripts/data_tidying_afiliados.R) detalla el codigo del proceso ETL para obtener el tidy dataset [afiliados_medios_sectores_tidy.csv](https://github.com/jescuderoma/filas-y-columnas/blob/main/2021-04-12_erte-afiliados-sectores/data/tidy/afiliados_medios_sectores_tidy.csv). Estas son las variables del dataset:

Variable|Descripción|Tipo
----|-----------|:--:
`fecha`|Mes de los datos en formato YYYY-MM-DD|Date
`cnae_cod`|Código de la división CNAE-2009 a dos dígitos|Character
`cnae_nombre`|Nombre de la división CNAE-2009 a dos dígitos|Character
`afiliados_medios_reg_general`|Afiliados medios mensuales en el Régimen General|Double
`afiliados_medios_autonomos`|Afiliados medios mensuales en el RETA|Double
`afiliados_medios_total`|Afiliados medios mensuales totales|Double

---

## Análisis exploratorio de datos

El análisis exploratorio de datos se realizó en R Markdown. El código figura [en este script](scripts/exploratory_data_analysis.Rmd).

---

## Gráficos finales

El código para la elaboración y producción de los gráficos finales con la librería ggplot2 está detallado [en este script](scripts/graficos_definitivos.R).

