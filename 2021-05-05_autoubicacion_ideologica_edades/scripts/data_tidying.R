## cargar librerías
library(tidyverse)
library(lubridate)


## importar raw data y convertirlo en tidy data

tidy_data <- read_tsv("data/raw/FID_2264.txt",
                     col_names = c("estudio", "ano_mes", "ano", "mes", "numentr", "edad", "autoubicacion")) %>% 
    mutate(fecha = ymd(str_c(ano_mes,"01")), # crear variable de fecha en formato YYYY-MM-DD
           grupo_edad = case_when( # crear variable de grupo de edad
               edad >=18 & edad <= 24 ~ "18-24",
               edad >=25 & edad <= 34 ~ "25-34",
               edad >=35 & edad <= 44 ~ "35-44",
               edad >=45 & edad <= 54 ~ "45-54",
               edad >=55 & edad <= 64 ~ "55-64",
               edad >=65 & edad <= 98 ~ "65 y más años",
               edad == -99 | edad == "99" ~ "No contesta"),
           fecha_nacimiento = ano-edad, # crear variable de fecha nacimiento
           decada_nacimiento = case_when( # crear variable de década de nacimiento
               fecha_nacimiento < 1941 ~ "1940 y antes",
               fecha_nacimiento >= 1941 & fecha_nacimiento <= 1950 ~ "1941-1950",
               fecha_nacimiento >= 1951 & fecha_nacimiento <= 1960 ~ "1951-1960",
               fecha_nacimiento >= 1961 & fecha_nacimiento <= 1970 ~ "1961-1970",
               fecha_nacimiento >= 1971 & fecha_nacimiento <= 1980 ~ "1971-1980",
               fecha_nacimiento >= 1981 & fecha_nacimiento <= 1990 ~ "1981-1990",
               fecha_nacimiento >= 1991 & fecha_nacimiento <= 2000 ~ "1991-2000",
               fecha_nacimiento >= 2001 ~ "2001 y después"),
           autoubicacion_grupo = case_when(
               autoubicacion == 1 | autoubicacion == 2 ~ "1-2 (Extrema izquierda)",
               autoubicacion == 3 | autoubicacion == 4 ~ "3-4 (Izquierda)",
               autoubicacion == 5 | autoubicacion == 6 ~ "5-6 (Centro)",
               autoubicacion == 7 | autoubicacion == 8 ~ "7-8 (Derecha)",
               autoubicacion == 9 | autoubicacion == 10 ~ "9-10 (Extrema derecha)",
               autoubicacion == 98 | autoubicacion== 88 | autoubicacion == 99 | autoubicacion == -99 ~ "No sabe/No contesta"
           )) %>% 
    arrange(fecha) %>% 
    select(estudio, fecha, ano_mes:edad, grupo_edad, fecha_nacimiento, decada_nacimiento, autoubicacion, autoubicacion_grupo)


write.csv(tidy_data, "data/tidy/autoubicacion_edades_tidy.csv", fileEncoding = "UTF-8", row.names = FALSE)
