# Título del proyecto

Descripción del proyecto

---

## Raw data y fuentes

- ***Afiliados medios mensuales:*** Los [datos en bruto](data/raw/afiliados_medios.csv) proceden de la [Estadística de afiliados en alta laboral](https://w6.seg-social.es/PXWeb/pxweb/es/Afiliados%20en%20alta%20laboral/) de la Seguridad Social, en concreto la *tabla 12m_02 Afi. Med.* de la subcarpeta de Afiliados medios.

- ***ERTE medios mensuales:*** Los [datos](data/raw/seguridad_social) proceden de los archivos Excel que el Ministerio de Inclusión, Seguridad Social y Migraciones publica junto a las notas de prensa y presentaciones con el balance mensual de los datos de afiliación, parados registrados y demandantes de empleos. Estos son los enlaces de descarga con los datos de cada mes:
    - [Marzo 2021](https://prensa.inclusion.gob.es/WebPrensaInclusion/downloadFile.do?tipo=documento&id=4.016&idContenido=4.165)
    - [Febrero 2021](https://prensa.inclusion.gob.es/WebPrensaInclusion/downloadFile.do?tipo=documento&id=4.000&idContenido=4.139)
    - [Enero 2021](https://prensa.inclusion.gob.es/WebPrensaInclusion/downloadFile.do?tipo=documento&id=3.982&idContenido=4.086)
    - [Diciembre 2020](https://prensa.inclusion.gob.es/WebPrensaInclusion/downloadFile.do?tipo=documento&id=3.963&idContenido=4.056)
    - [Noviembre 2020](https://prensa.inclusion.gob.es/WebPrensaInclusion/downloadFile.do?tipo=documento&id=3.943&idContenido=4.017)
    - [Octubre 2020](https://prensa.inclusion.gob.es/WebPrensaInclusion/downloadFile.do?tipo=documento&id=3.924&idContenido=4.092)
    - [Septiembre 2020](https://prensa.inclusion.gob.es/WebPrensaInclusion/downloadFile.do?tipo=documento&id=3.907&idContenido=3.948)
    - [Agosto 2020](https://prensa.inclusion.gob.es/WebPrensaInclusion/downloadFile.do?tipo=documento&id=3.888&idContenido=3.908)
    - [Julio 2020](https://prensa.inclusion.gob.es/WebPrensaInclusion/downloadFile.do?tipo=documento&id=3.876&idContenido=3.887)
    - [Junio 2020](https://prensa.inclusion.gob.es/WebPrensaInclusion/downloadFile.do?tipo=documento&id=3.854&idContenido=3.839)
    - [Mayo 2020](https://prensa.inclusion.gob.es/WebPrensaInclusion/downloadFile.do?tipo=documento&id=3.825&idContenido=3.796)
    - [Abril 2020](https://prensa.inclusion.gob.es/WebPrensaInclusion/downloadFile.do?tipo=documento&id=3.798&idContenido=3.731)
    
    
- ***Clasificación CNAE-2009:*** El [archivo original](https://www.ine.es/daco/daco42/clasificaciones/cnae09/estructura_cnae2009.xls) procede del Instituto Nacional de Estadística (INE).

---

## Tidy data

### Afiliados medios mensuales

El script [data_tidying_afiliados.R](scripts/data_tidying_afiliados.R) detalla el codigo del proceso ETL para obtener el tidy dataset [afiliados_medios_sectores_tidy.csv](data/tidy/afiliados_medios_sectores_tidy.csv). Estas son las variables del dataset:

Variable|Descripción|Tipo
----|-----------|:--:
`fecha`|Mes de los datos en formato YYYY-MM-DD|Date
`cnae_cod`|Código de la división CNAE-2009 a dos dígitos|Character
`cnae_nombre`|Nombre de la división CNAE-2009 a dos dígitos|Character
`afiliados_medios_reg_general`|Afiliados medios mensuales en el Régimen General|Double
`afiliados_medios_autonomos`|Afiliados medios mensuales en el RETA|Double
`afiliados_medios_total`|Afiliados medios mensuales totales|Double


### ERTE medios mensuales

El script [data_tidying_erte.R](scripts/data_tidying_erte.R) detalla el codigo del proceso ETL para obtener el tidy dataset [erte_sectores_tidy.csv](data/tidy/erte_sectores_tidy.csv). Estas son las variables del dataset:

Variable|Descripción|Tipo
----|-----------|:--:
`fecha`|Mes de los datos en formato YYYY-MM-DD|Date
`cnae_cod`|Código de la división CNAE-2009 a dos dígitos|Character
`cnae_nombre`|Nombre de la división CNAE-2009 a dos dígitos|Character
`ccc_ultimo_dia`|Códigos de Cuenta de Cotización con ERTE activos (último día del mes)|Integer
`ccc_media_mes`|Códigos de Cuenta de Cotización con ERTE activos (media mensual)|Double
`trabajadores_erte_ultimo_dia`|Trabajadores en ERTE (último día del mes)|Integer
`trabajadores_erte_media_mes`|Trabajadores en ERTE (media mensual)|Double
`hohmbres_erte_ultimo_dia`|Hombres en ERTE (último día del mes)|Integer
`mujeres_erte_ultimo_dia`|Mujeres en ERTE (último día del mes)|Integer
`hombres_erte_media_mes`|Hombres en ERTE (media mensual), agosto y septiembre 2020|Double
`mujeres_erte_media_es`|Mujeres en ERTE (media mensual), agosto y septiembre 2020|Double


### Clasificación CNAE-2009

El script [data_tidying_cnae2009.R](scripts/data_tidying_cnae2009.R) detalla el codigo del proceso ETL para obtener el tidy dataset [cnae2009_tidy.csv](data/dictionaries/cnae2009_tidy.csv). Estas son las variables del dataset:

Variable|Descripción|Tipo
----|-----------|:--:
`cnae2009_seccion_1digito_cod`|Código de la sección CNAE-2009 a un dígito|Character
`cnae2009_seccion_1digito_nombre`|Nombre de la sección CNAE-2009 a un dígito|Character
`cnae2009_division_2digitos_cod`|Código de la división CNAE-2009 a dos dígitos|Character
`cnae2009_division_2digitos_nombre`|Nombre de la división CNAE-2009 a dos dígitos|Character
`cnae2009_grupo_3digitos_cod`|Código del grupo CNAE-2009 a tres dígitos|Character
`cnae2009_grupo_3digitos_nombre`|Nombre del grupo CNAE-2009 a tres dígito|Character
`cnae2009_clase_4digitos_cod`|Código de la clase CNAE-2009 a cuatro dígitos|Character
`cnae2009_clase_4digitos_nombre`|Nombre de la clase CNAE-2009 a cuatro dígitos|Character
`cnae2009_clase_4digitos_codint`|Código completo de la clase CNAE-2009|Character




