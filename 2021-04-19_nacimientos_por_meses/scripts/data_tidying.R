## cargar librerías
library(tidyverse)
library(lubridate)
library(jsonlite)
library(janitor)


## importar datos de la API del INE
datos_total_nacional <- fromJSON("https://servicios.ine.es/wstempus/js/ES/DATOS_TABLA/6525?date=:") %>% 
    clean_names() %>% 
    filter(cod=="MNP17451")
    

tidy_data_mes <- bind_rows(datos_total_nacional$data) %>% 
    clean_names() %>% 
    select(mes=fk_periodo, ano=anyo, valor) %>% 
    mutate(mes=str_pad(mes, 2, pad = "0"),
           fecha=dmy(str_c("01", mes, ano)),
           mes_nombre=month(fecha, label=TRUE, abbr = TRUE),
           ano = as.integer(ano)) %>% 
    select(fecha, mes=mes_nombre, ano, nacidos_mes=valor) %>% 
    arrange(fecha)


tidy_data_ano <- tidy_data_mes %>% 
    group_by(ano) %>% 
    summarise(nacidos_ano=sum(nacidos_mes))


tidy_data <- left_join (tidy_data_mes, tidy_data_ano,
                        by = "ano") %>% 
    mutate(nacidos_mes_pct = round(nacidos_mes/nacidos_ano, 4)) %>% 
    group_by(ano) %>% 
    mutate(etiqueta = case_when(
        nacidos_mes==max(nacidos_mes) | nacidos_mes==min(nacidos_mes) ~ nacidos_mes_pct
    ))


rm(datos_total_nacional)
rm(tidy_data_mes)
rm(tidy_data_ano)
