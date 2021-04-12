## cargar librerías e importar raw data afiliados
library(tidyverse)
library(readxl)
library(lubridate)
library(janitor)

cnae2009_raw <- read_xls("data/dictionaries/estructura_cnae2009.xls")


## limpiar nombres columnas y eliminar blancos extra
cnae2009_raw2 <- cnae2009_raw %>% 
    clean_names() %>% 
    mutate(titulo_cnae2009=str_trim(titulo_cnae2009))


## obtener data frame con secciones - Nivel primero codigo alfabético de 1 dígito
cnae2009_1digito <- cnae2009_raw2 %>% 
    filter(str_detect(cod_cnae2009, "[A-Z]")) %>% 
    select(cnae2009_seccion_1digito_cod=cod_cnae2009, cnae2009_seccion_1digito_nombre=titulo_cnae2009)


## obtener data frame con divisiones - Nivel segundo codigo numérico de 2 dígitos
cnae2009_2digitos <- cnae2009_raw2 %>% 
    filter(str_detect(cod_cnae2009, "^[0-9]{2}$")) %>% 
    select(cnae2009_division_2digitos_cod=cod_cnae2009, cnae2009_division_2digitos_nombre=titulo_cnae2009)


## obtener data frame con grupos - Nivel tercero codigo numérico de 3 dígitos
cnae2009_3digitos <- cnae2009_raw2 %>% 
    filter(str_detect(cod_cnae2009, "^[0-9]{3}$")) %>% 
    select(cnae2009_grupo_3digitos_cod=cod_cnae2009, cnae2009_grupo_3digitos_nombre=titulo_cnae2009)


## obtener data frame con clases - Nivel cuarto codigo numérico de 4 dígitos
cnae2009_4digitos <- cnae2009_raw2 %>% 
    filter(str_detect(cod_cnae2009, "^[0-9]{4}$")) %>% 
    select(codintegr, cnae2009_clase_4digitos_cod=cod_cnae2009, cnae2009_clase_4digitos_nombre=titulo_cnae2009) %>% 
    mutate(cnae2009_grupo_3digitos_cod=str_sub(codintegr, 2, 4),
           cnae2009_division_2digitos_cod=str_sub(codintegr, 2, 3),
           cnae2009_seccion_1digito_cod=str_sub(codintegr, 1, 1))


## unir diferentes data frames para crear archivo tidy data
tidy_data1 <- left_join(cnae2009_4digitos, cnae2009_3digitos,
                        by = "cnae2009_grupo_3digitos_cod")

tidy_data2 <- left_join(tidy_data1, cnae2009_2digitos,
                        by = "cnae2009_division_2digitos_cod")

tidy_data_final <- left_join(tidy_data2, cnae2009_1digito,
                        by = "cnae2009_seccion_1digito_cod") %>% 
    select(cnae2009_seccion_1digito_cod, cnae2009_seccion_1digito_nombre,
           cnae2009_division_2digitos_cod, cnae2009_division_2digitos_nombre,
           cnae2009_grupo_3digitos_cod, cnae2009_grupo_3digitos_nombre,
           cnae2009_clase_4digitos_cod, cnae2009_clase_4digitos_nombre, cnae2009_clase_4digitos_codint=codintegr)


write_csv(tidy_data_final, "data/dictionaries/cnae2009_tidy.csv")

