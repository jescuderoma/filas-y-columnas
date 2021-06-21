## cargar librerías
library(tidyverse)
library(readxl)
library(lubridate)
library(janitor)


## definir opciones para que los números no aparezcan con formato científico
options(scipen = "999")


## importar datos de la hoja ERTE por Sectores de actividad desde octubre de 2020

erte_2021_05 <- read_xlsx("data/raw/seguridad_social/2021-05_afiliacion_seguridad_social.xlsx",
                          sheet = "ERTE por Sectores de Actividad", skip = 5, col_names = FALSE) %>% 
    # elegir las columnas del bloque Totales - Acumulados durante el mes
    select(1:2, 29:34) %>% 
    clean_names() %>% 
    rename(cnae_cod = x1, cnae_nombre = x2, ccc_ultimo_dia = x29, ccc_media_mes = x30,
           trabajadores_erte_ultimo_dia = x31, trabajadores_erte_media_mes = x32,
           hombres_erte_ultimo_dia = x33, mujeres_erte_ultimo_dia = x34) %>% 
    # eliminar fila en blanco y fila final con el sumatorio total
    filter(!is.na(cnae_nombre)) %>% 
    # crear columna de fecha en formato YYYY-MM-DD
    mutate(fecha=as.Date("2021-05-01"))

erte_2021_04 <- read_xlsx("data/raw/seguridad_social/2021-04_afiliacion_seguridad_social.xlsx",
                          sheet = "ERTE por Sectores de Actividad", skip = 5, col_names = FALSE) %>% 
    # elegir las columnas del bloque Totales - Acumulados durante el mes
    select(1:2, 29:34) %>% 
    clean_names() %>% 
    rename(cnae_cod = x1, cnae_nombre = x2, ccc_ultimo_dia = x29, ccc_media_mes = x30,
           trabajadores_erte_ultimo_dia = x31, trabajadores_erte_media_mes = x32,
           hombres_erte_ultimo_dia = x33, mujeres_erte_ultimo_dia = x34) %>% 
    # eliminar fila en blanco y fila final con el sumatorio total
    filter(!is.na(cnae_nombre)) %>% 
    # crear columna de fecha en formato YYYY-MM-DD
    mutate(fecha=as.Date("2021-04-01"))

erte_2021_03 <- read_xlsx("data/raw/seguridad_social/2021-03_afiliacion_seguridad_social.xlsx",
                   sheet = "ERTE por Sectores de Actividad", skip = 5, col_names = FALSE) %>% 
    # elegir las columnas del bloque Totales - Acumulados durante el mes
    select(1:2, 29:34) %>% 
    clean_names() %>% 
    rename(cnae_cod = x1, cnae_nombre = x2, ccc_ultimo_dia = x29, ccc_media_mes = x30,
           trabajadores_erte_ultimo_dia = x31, trabajadores_erte_media_mes = x32,
           hombres_erte_ultimo_dia = x33, mujeres_erte_ultimo_dia = x34) %>% 
    # eliminar fila en blanco y fila final con el sumatorio total
    filter(!is.na(cnae_nombre)) %>% 
    # crear columna de fecha en formato YYYY-MM-DD
    mutate(fecha=as.Date("2021-03-01"))


erte_2021_02 <- read_xlsx("data/raw/seguridad_social/2021-02_afiliacion_seguridad_social.xlsx",
                          sheet = "ERTE por Sectores de Actividad", skip = 5, col_names = FALSE) %>% 
    # elegir las columnas del bloque Totales - Acumulados durante el mes
    select(1:2, 29:34) %>% 
    clean_names() %>% 
    rename(cnae_cod = x1, cnae_nombre = x2, ccc_ultimo_dia = x29, ccc_media_mes = x30,
           trabajadores_erte_ultimo_dia = x31, trabajadores_erte_media_mes = x32,
           hombres_erte_ultimo_dia = x33, mujeres_erte_ultimo_dia = x34) %>% 
    # eliminar fila en blanco y fila final con el sumatorio total
    filter(!is.na(cnae_nombre)) %>% 
    # crear columna de fecha en formato YYYY-MM-DD
    mutate(fecha=as.Date("2021-02-01"))


erte_2021_01 <- read_xlsx("data/raw/seguridad_social/2021-01_afiliacion_seguridad_social.xlsx",
                            sheet = "ERTE por Sectores de Actividad", skip = 5, col_names = FALSE) %>% 
    # elegir las columnas del bloque Totales - Acumulados durante el mes
    select(1:2, 29:34) %>% 
    clean_names() %>% 
    rename(cnae_cod = x1, cnae_nombre = x2, ccc_ultimo_dia = x29, ccc_media_mes = x30,
           trabajadores_erte_ultimo_dia = x31, trabajadores_erte_media_mes = x32,
           hombres_erte_ultimo_dia = x33, mujeres_erte_ultimo_dia = x34) %>% 
    # eliminar fila en blanco y fila final con el sumatorio total
    filter(!is.na(cnae_nombre)) %>% 
    # crear columna de fecha en formato YYYY-MM-DD
    mutate(fecha=as.Date("2021-01-01"))


erte_2020_12 <- read_xlsx("data/raw/seguridad_social/2020-12_afiliacion_seguridad_social.xlsx",
                          sheet = "ERTE por Sectores de Actividad", skip = 5, col_names = FALSE) %>% 
    # elegir las columnas del bloque Totales - Acumulados durante el mes
    select(1:2, 29:34) %>% 
    clean_names() %>% 
    rename(cnae_cod = x1, cnae_nombre = x2, ccc_ultimo_dia = x29, ccc_media_mes = x30,
           trabajadores_erte_ultimo_dia = x31, trabajadores_erte_media_mes = x32,
           hombres_erte_ultimo_dia = x33, mujeres_erte_ultimo_dia = x34) %>%
    # eliminar fila en blanco y fila final con el sumatorio total
    filter(!is.na(cnae_nombre)) %>% 
    # crear columna de fecha en formato YYYY-MM-DD
    mutate(fecha=as.Date("2020-12-01"))


erte_2020_11 <- read_xlsx("data/raw/seguridad_social/2020-11_afiliacion_seguridad_social.xlsx",
                          sheet = "ERTE por Sectores de Actividad", skip = 5, col_names = FALSE) %>% 
    # elegir las columnas del bloque Totales - Acumulados durante el mes
    select(1:2, 29:34) %>% 
    clean_names() %>% 
    rename(cnae_cod = x1, cnae_nombre = x2, ccc_ultimo_dia = x29, ccc_media_mes = x30,
           trabajadores_erte_ultimo_dia = x31, trabajadores_erte_media_mes = x32,
           hombres_erte_ultimo_dia = x33, mujeres_erte_ultimo_dia = x34) %>%
    # eliminar fila en blanco y fila final con el sumatorio total
    filter(!is.na(cnae_nombre)) %>% 
    # crear columna de fecha en formato YYYY-MM-DD
    mutate(fecha=as.Date("2020-11-01"))


erte_2020_10 <- read_xlsx("data/raw/seguridad_social/2020-10_afiliacion_seguridad_social.xlsx",
                          sheet = "ERTE por Sectores de Actividad", skip = 5, col_names = FALSE) %>% 
    # elegir las columnas del bloque Totales - Acumulados durante el mes
    select(1:2, 29:34) %>% 
    clean_names() %>% 
    rename(cnae_cod = x1, cnae_nombre = x2, ccc_ultimo_dia = x29, ccc_media_mes = x30,
           trabajadores_erte_ultimo_dia = x31, trabajadores_erte_media_mes = x32,
           hombres_erte_ultimo_dia = x33, mujeres_erte_ultimo_dia = x34) %>% 
    # eliminar fila en blanco y fila final con el sumatorio total
    filter(!is.na(cnae_nombre)) %>% 
    # crear columna de fecha en formato YYYY-MM-DD
    mutate(fecha=as.Date("2020-10-01"))


## unir data frames desde octubre de 2020
erte_desde_octubre2020 <- bind_rows(erte_2020_10, erte_2020_11, erte_2020_12,
                                    erte_2021_01, erte_2021_02, erte_2021_03,
                                    erte_2021_04, erte_2021_05)


## importar datos de la hoja ERTE por Sectores de actividad entre junio y septiembre de 2020

erte_2020_09 <- read_xlsx("data/raw/seguridad_social/2020-09_afiliacion_seguridad_social.xlsx",
                          sheet = "ERTE por Sectores de Actividad", skip = 5, col_names = FALSE) %>% 
    # elegir las columnas del bloque Totales - Acumulados durante el mes
    select(1:2, 17:22) %>% 
    clean_names() %>% 
    rename(cnae_cod = x1, cnae_nombre = x2, ccc_ultimo_dia = x17, ccc_media_mes = x18,
           trabajadores_erte_ultimo_dia = x19, trabajadores_erte_media_mes = x20,
           hombres_erte_media_mes = x21, mujeres_erte_media_mes = x22) %>% 
    # eliminar fila en blanco y fila final con el sumatorio total
    filter(!is.na(cnae_nombre)) %>% 
    # crear columna de fecha en formato YYYY-MM-DD
    mutate(fecha=as.Date("2020-09-01"))


erte_2020_08 <- read_xlsx("data/raw/seguridad_social/2020-08_afiliacion_seguridad_social.xlsx",
                          sheet = "ERTE por Sectores de Actividad", skip = 5, col_names = FALSE) %>% 
    # elegir las columnas del bloque Totales - Acumulados durante el mes
    select(1:2, 17:22) %>% 
    clean_names() %>% 
    rename(cnae_cod = x1, cnae_nombre = x2, ccc_ultimo_dia = x17, ccc_media_mes = x18,
           trabajadores_erte_ultimo_dia = x19, trabajadores_erte_media_mes = x20,
           hombres_erte_media_mes = x21, mujeres_erte_media_mes = x22) %>% 
    # eliminar fila en blanco y fila final con el sumatorio total
    filter(!is.na(cnae_nombre)) %>% 
    # crear columna de fecha en formato YYYY-MM-DD
    mutate(fecha=as.Date("2020-08-01"))


erte_2020_07 <- read_xlsx("data/raw/seguridad_social/2020-07_afiliacion_seguridad_social.xlsx",
                          sheet = "ERTE por Sectores de Actividad", skip = 5, col_names = FALSE) %>% 
    # elegir las columnas del bloque Totales - Acumulados durante el mes
    select(1:2, 17:22) %>% 
    clean_names() %>% 
    rename(cnae_cod = x1, cnae_nombre = x2, ccc_ultimo_dia = x17, ccc_media_mes = x18,
           trabajadores_erte_ultimo_dia = x19, trabajadores_erte_media_mes = x20,
           hombres_erte_ultimo_dia = x21, mujeres_erte_ultimo_dia = x22) %>% 
    # eliminar fila en blanco y fila final con el sumatorio total
    filter(!is.na(cnae_nombre)) %>% 
    # crear columna de fecha en formato YYYY-MM-DD
    mutate(fecha=as.Date("2020-07-01"))


erte_2020_06 <- read_xlsx("data/raw/seguridad_social/2020-06_afiliacion_seguridad_social.xlsx",
                          sheet = "ERTE por Sectores de Actividad", skip = 5, col_names = FALSE) %>% 
    # elegir las columnas del bloque Totales - Acumulados durante el mes
    select(1:2, 17:22) %>% 
    clean_names() %>% 
    rename(cnae_cod = x1, cnae_nombre = x2, ccc_ultimo_dia = x17, ccc_media_mes = x18,
           trabajadores_erte_ultimo_dia = x19, trabajadores_erte_media_mes = x20,
           hombres_erte_ultimo_dia = x21, mujeres_erte_ultimo_dia = x22) %>% 
    # eliminar fila en blanco y fila final con el sumatorio total
    filter(!is.na(cnae_nombre)) %>% 
    # crear columna de fecha en formato YYYY-MM-DD
    mutate(fecha=as.Date("2020-06-01"))


erte_2020_05 <- read_xlsx("data/raw/seguridad_social/2020-05_afiliacion_seguridad_social.xlsx",
                          sheet = "ERTE por Sectores de Actividad", skip = 5, col_names = FALSE) %>% 
    # elegir las columnas del bloque Totales - Acumulados durante el mes
    select(1:2, 17:22) %>% 
    clean_names() %>% 
    rename(cnae_cod = x1, cnae_nombre = x2, ccc_ultimo_dia = x17, ccc_media_mes = x18,
           trabajadores_erte_ultimo_dia = x19, trabajadores_erte_media_mes = x20,
           hombres_erte_ultimo_dia = x21, mujeres_erte_ultimo_dia = x22) %>% 
    # eliminar fila en blanco y fila final con el sumatorio total
    filter(!is.na(cnae_nombre)) %>% 
    # crear columna de fecha en formato YYYY-MM-DD
    mutate(fecha=as.Date("2020-05-01"))


## unir data frames desde mayo hasta septiembre de 2020
erte_mayo_septiembre_2020 <- bind_rows(erte_2020_05, erte_2020_06, erte_2020_07, erte_2020_08, erte_2020_09)


## importar datos de la hoja ERTE Sectores de abril de 2020

erte_2020_04 <- read_xlsx("data/raw/seguridad_social/2020-04_afiliacion_seguridad_social.xlsx",
                          sheet = "ERTE Sectores", skip = 2, col_names = FALSE) %>% 
    # elegir las columnas del bloque Totales - Acumulados durante el mes
    clean_names() %>% 
    rename(cnae_nombre = x1, trabajadores_erte_media_mes = x2) %>% 
    # eliminar fila en blanco y fila final con el sumatorio total
    filter(cnae_nombre!="TOTALES") %>% 
    # crear columna de fecha en formato YYYY-MM-DD
    mutate(fecha=as.Date("2020-04-01"))


## crear tidy dataset
erte_tidy <- bind_rows(erte_2020_04, erte_mayo_septiembre_2020, erte_desde_octubre2020) %>% 
    select(fecha, cnae_cod, cnae_nombre, ccc_ultimo_dia, ccc_media_mes, trabajadores_erte_ultimo_dia,
           trabajadores_erte_media_mes, hombres_erte_ultimo_dia, mujeres_erte_ultimo_dia, hombres_erte_media_mes, mujeres_erte_media_mes)


## homogeneizar cnae_nombre de Actividades de los hogares como productores...
erte_tidy2 <- erte_tidy %>% 
    mutate(cnae_nombre=case_when(
        cnae_nombre=="Actividades de los hogares como pr de bienes y ser para uso propio" ~ "Actividades de los hogares como productores de bienes y servicios para uso propio",
        TRUE ~ cnae_nombre
    ))


## obtener cnae_cod para cnae sin codigo
codigos <- erte_tidy2 %>% 
    group_by(cnae_cod, cnae_nombre) %>% 
    summarise(valor=n()) %>% 
    select(-valor) %>% 
    filter(!is.na(cnae_cod))


erte_tidy_final <- left_join(erte_tidy2, codigos,
                             by = "cnae_nombre") %>% 
    select(fecha, cnae_cod=cnae_cod.y, cnae_nombre:mujeres_erte_media_mes)

write_csv(erte_tidy_final, "data/tidy/erte_sectores_tidy.csv")
