# importar librerías
library(tidyverse)
library(plyr)


# guardar los ficheros transversales de microdatos P en formato csv de la ECV 2008-2020
# en una única carpeta e importarlos creando un único data frame
mydir <- "data/raw/transversales/originales/personas_data" # elegir carpeta donde están todos los csv a importar
myfiles <-  list.files(path=mydir, pattern="*.csv", full.names=TRUE)
adultos_data <- ldply(myfiles, read_csv)


# guardar los ficheros transversales de microdatos D en formato csv de la ECV 2008-2020
# en una única carpeta e importarlos creando un único data frame
mydir <- "data/raw/transversales/originales/hogares_basic" # elegir carpeta donde están todos los csv a importar
myfiles <-  list.files(path=mydir, pattern="*.csv", full.names=TRUE)
hogares_basic <- ldply(myfiles, read_csv)


# simplificar el data frame de hogares_basic
hogares_simple <- hogares_basic %>% 
  select(DB010, DB030, DB040, DB100) %>% 
  mutate(DB030 = as.character(DB030))
rm(hogares_basic)


# obtener columna hogar a partir de columna de persona (PB030-2 dígitos de la derecha) y traer características del hogar
adultos_data <- adultos_data %>% 
  mutate(PB030_bis = PB030) %>% 
  separate(PB030_bis, into = c("DB030", "PB030_a"), sep = -2) %>% 
  select(PB010:PB030, DB030, PB030_a, PB040:PL280_F)

adultos_data_final <- left_join(adultos_data, hogares_simple,
                                by = c("DB030", "PB010"="DB010")) %>% 
  select(PB010:PB040_F, DB040, DB100, PB100:PL280_F)


# simplificar data frames con columnas de interés
data_simple <- adultos_data_final %>% 
  select(PB010:PY200G_F, -c(PB020, PB040_F, PB100:PB120_F)) # Eliminar columnas de módulo anuales y columnas específicas: País, Mes y año entrevista y Flags, Minutos entrevista, Minutos flag
rm(adultos_data_final)


# guardar los microdatos transversales para adultos de la ECV 2008-2020
write_csv(data_simple,"data/output/00_adultos_transversales.csv")