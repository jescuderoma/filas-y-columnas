## cargar librerías e importar raw data afiliados
library(tidyverse)
library(lubridate)
library(janitor)

afiliados_raw <- read_csv("data/raw/afiliados_medios.csv", skip = 2,
                          locale = locale(encoding = "ISO-8859-1"))


## data tidying
afiliados_tidy <- afiliados_raw %>%
    # eliminar filas con NA
    filter(!is.na(`Régimen`)) %>%
    # reordenar y crear una columna con CNAE
    pivot_longer(names_to = "cnae_nombre", values_to = "afiliados_medios", cols = 3:92) %>% 
    clean_names() %>% 
    # separar columna de CNAE en dos, código y nombre
    mutate(cnae_cod=str_sub(cnae_nombre, 1,2),
           cnae_nombre=str_trim(str_split(cnae_nombre, "[0-9]{2}", simplify=TRUE)[,2])) %>% 
    select(fecha, cnae_cod, cnae_nombre, afiliados_medios, regimen) %>% 
    # reordenar y crear columnas de régimen general y autónomos
    pivot_wider(names_from = "regimen", values_from = "afiliados_medios") %>% 
    # limpiar y cambiar nombres de columnas
    clean_names() %>% 
    select(fecha, cnae_cod, cnae_nombre, afiliados_medios_reg_general=reg_general,
           afiliados_medios_autonomos=r_e_autonomos) %>% 
    # crear columna de afiliados_medios_total con la suma de reg_general y autonomos
    mutate(afiliados_medios_total=afiliados_medios_reg_general+afiliados_medios_autonomos) %>% 
    # crear columna de fecha con formato YYYY-MM-DD
    mutate(fecha=dmy(str_c("01 ", fecha))) %>% 
    filter(cnae_cod!="No" & cnae_cod!="ME")

write_csv(afiliados_tidy, "data/tidy/afiliados_medios_sectores_tidy.csv")


