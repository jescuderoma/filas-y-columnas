## cargar librerías e importar tidy data
library(tidyverse)
library(lubridate)
library(ggplot2)

tidy_data <- read_csv("data/tidy/autoubicacion_edades_tidy.csv")


## calcular evolución autoubicación media y desviación típica y compararla con
## la serie histórica de la web del CIS código A.3.06.01.004 en http://www.analisis.cis.es/cisdb.jsp

autoubicacion_media <- tidy_data %>% 
    filter(autoubicacion%in%c(1,2,3,4,5,6,7,8,9,10)) %>% 
    group_by(fecha, estudio) %>% 
    summarise(autoubicacion_media = round(mean(autoubicacion),2),
              desviacion_tipica = round(sd(autoubicacion),2))


## calcular encuestados y porcentaje que representan por grupos de autoubicación y compararlo con
## la serie histórica de la web del CIS código A.3.06.01.004 en http://www.analisis.cis.es/cisdb.jsp

distribucion_ubicacion <- tidy_data %>% 
    filter(autoubicacion_grupo!="-99") %>% 
    group_by(fecha, estudio, autoubicacion_grupo) %>% 
    summarise(encuestados=n()) %>% 
    mutate(encuestados_pct=encuestados/(sum(encuestados)))


## calcular evolución autoubicación media y desviación típica por grupos de edad y compararla con cuatro encuestas
## estudio 2016 (julio 1992): http://www.cis.es/cis/export/sites/default/-Archivos/Marginales/2000_2019/2016/cru2016edad.html
## estudio 2636 (marzo 2006): http://www.cis.es/cis/export/sites/default/-Archivos/Marginales/2620_2639/2636/Cru263600EDAD.html
## estudio 2976 (enero 2013): http://www.cis.es/cis/export/sites/default/-Archivos/Marginales/2960_2979/2976/Cru297600EDAD.html
## estudio 3292 (septiembre 2020): http://www.cis.es/cis/export/sites/default/-Archivos/Marginales/3280_3299/3292/cru3292edad.html

autoubicacion_media_edad <- tidy_data %>% 
    filter(autoubicacion%in%c(1,2,3,4,5,6,7,8,9,10)) %>% 
    group_by(fecha, estudio, grupo_edad) %>% 
    summarise(autoubicacion_media = round(mean(autoubicacion),2),
              desviacion_tipica = round(sd(autoubicacion),2)) %>% 
    filter(grupo_edad!="-99")


## calcular evolución encuestados y porcentaje por grupos de edad por grupos de autoubicacion y compararla con cuatro encuestas
## estudio 2016 (julio 1992): http://www.cis.es/cis/export/sites/default/-Archivos/Marginales/2000_2019/2016/cru2016edad.html
## estudio 2636 (marzo 2006): http://www.cis.es/cis/export/sites/default/-Archivos/Marginales/2620_2639/2636/Cru263600EDAD.html
## estudio 2976 (enero 2013): http://www.cis.es/cis/export/sites/default/-Archivos/Marginales/2960_2979/2976/Cru297600EDAD.html
## estudio 3292 (septiembre 2020): http://www.cis.es/cis/export/sites/default/-Archivos/Marginales/3280_3299/3292/cru3292edad.html

distribucion_ubicacion_edad <- tidy_data %>% 
    filter(autoubicacion_grupo!="-99" & grupo_edad!="-99") %>% 
    group_by(fecha, estudio, grupo_edad, autoubicacion_grupo) %>% 
    summarise(encuestados=n()) %>% 
    mutate(encuestados_pct=encuestados/(sum(encuestados)))

