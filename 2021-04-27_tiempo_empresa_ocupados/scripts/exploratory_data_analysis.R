## cargar librerías e importar tidy data completo de los microdatos de la EPA
library(tidyverse)
library(lubridate)
library(ggplot2)
library(gganimate)
library(janitor)
library(Hmisc)
library(viridis)
library(scales)

microdatos_epa <- read_csv("data/tidy/tidy_data_hasta_4T2020.csv")

## convertir a número columna dcom (tiempo en meses de los ocupados en la empresa del empleo principal)
microdatos_epa$dcom <- as.double(microdatos_epa$dcom)


## extraer microdatos solo para ocupados
ocupados <- microdatos_epa %>% 
    filter(!is.na(dcom)) %>% 
    select(fecha, edad5, ocup1, act1, situ, dcom, factorel) %>% 
    mutate(tiempo_empresa = case_when(
        dcom < 24 ~ "Menos de 2 años",
        dcom >= 24 & dcom < 60 ~ "2-5 años",
        dcom >= 60 & dcom < 120 ~ "5-10 años",
        dcom >= 120 & dcom < 240 ~ "10-20 años",
        dcom >= 240 & dcom < 360 ~ "20-30 años",
        dcom >= 360 ~ "30 o más años"
    ))

ocupados$tiempo_empresa <- factor(ocupados$tiempo_empresa, levels = c("Menos de 2 años", "2-5 años", "5-10 años",
                                                                      "10-20 años", "20-30 años", "30 o más años"))

rm(microdatos_epa)


## gráfico tiempo permanencia mediano en empresa actual por edades
tiempo_mediano_edades <- ocupados %>% 
    group_by(fecha, edad5) %>% 
    summarise(mediana_tiempo = wtd.quantile(dcom/12, probs = .5, weight = factorel),
              media_tiempo = wtd.mean(dcom/12, weight = factorel)) %>% 
    mutate(grupo_edad = case_when(
        edad5 == "16" ~ "16-19 años",
        edad5 == "20" ~ "20-24",
        edad5 == "25" ~ "25-29",
        edad5 == "30" ~ "30-34",
        edad5 == "35" ~ "35-39",
        edad5 == "40" ~ "40-44",
        edad5 == "45" ~ "45-49",
        edad5 == "50" ~ "50-54",
        edad5 == "55" ~ "55-59",
        edad5 == "60" ~ "60-64",
        edad5 == "65" ~ "65 y más años"
    ))

tiempo_mediano_edades$grupo_edad <- factor(tiempo_mediano_edades$grupo_edad,
                                           levels = c("65 y más años", "60-64", "55-59", "50-54", "45-49",
                                                      "40-44", "35-39", "30-34", "25-29", "20-24", "16-19 años"))


ggplot(tiempo_mediano_edades,
       aes(x = fecha, y = mediana_tiempo, group = grupo_edad, color = grupo_edad)) +
    geom_line(size = 1.5) +
    scale_color_viridis(discrete = TRUE, option = "magma", direction = 1) +
    scale_y_continuous(breaks = seq(0, 30, 5), limits = c(0,31)) +
    theme_minimal() +
    theme(text = element_text(family = "Open Sans"),
          plot.title = element_text(face = "bold", size = 18, color = "grey10"),
          plot.subtitle = element_text(size = 14, color = "grey30"),
          plot.caption = element_text(size = 11, face = "italic", color = "grey30", hjust=c(0, 1)),
          axis.title = element_text(size = 14, color = "grey30"),
          axis.text = element_text(size = 11, color = "grey40"),
          strip.text = element_text(size = 12, face = "bold", color = "grey10"),
          plot.margin = margin(10, 20, 10, 20),
          plot.title.position = "plot",
          plot.caption.position = "plot",
          legend.title = element_blank(),
          panel.grid.major.x = element_blank(),
          panel.grid.minor.x = element_blank(),
          panel.grid.major.y = element_line(size = .5),
          panel.grid.minor.y = element_line(size = .5, linetype = "longdash"),
          axis.ticks = element_blank()) +
    labs(title="La permanencia de los ocupados en las empresas ha bajado en la última década",
         subtitle="Tiempo mediano en la empresa (en años) de los ocupados por grupos de edad",
         caption=c("Fuente: Microdatos de la Encuesta de Población Activa (EPA), INE", "Elaborado por Jesús Escudero (@jescuderoma) | https://filasycolumnas.substack.com/"),
         x = "", y = "")

ggsave("graficos/finales/tiempo_mediano_empresa.png", width = 30, height = 18, units = "cm")


## gráfico tiempo permanencia mediano en empresa actual por edades según asalariados sector público o privado
tiempo_mediano_edades_sector <- ocupados %>% 
    filter(situ%in%c("07", "08")) %>% 
    filter(edad5%in%c("25", "30", "35", "40", "45", "50", "55", "60")) %>% # excluir grupos 16-24 años y >65 años por poco representativos 
    group_by(fecha, situ, edad5) %>% 
    summarise(mediana_tiempo = wtd.quantile(dcom/12, probs = .5, weight = factorel)) %>% 
    mutate(grupo_edad = case_when(
        edad5 == "16" ~ "16-19 años",
        edad5 == "20" ~ "20-24",
        edad5 == "25" ~ "25-29",
        edad5 == "30" ~ "30-34",
        edad5 == "35" ~ "35-39",
        edad5 == "40" ~ "40-44",
        edad5 == "45" ~ "45-49",
        edad5 == "50" ~ "50-54",
        edad5 == "55" ~ "55-59",
        edad5 == "60" ~ "60-64",
        edad5 == "65" ~ "65 y más años"
    ),
    situ_nombre = case_when(
        situ == "07" ~ "Asalariados sector público",
        situ == "08" ~ "Asalariados sector privado"
    ))


ggplot(tiempo_mediano_edades_sector,
       aes(x = fecha, y = mediana_tiempo, group = situ_nombre, color = situ_nombre)) +
    geom_line(size = 1.5) +
    facet_wrap(~grupo_edad, ncol = 4, scales = "free") +
    scale_color_manual(values = c("#cf735f", "#2d205d")) +
    theme_minimal() +
    theme(text = element_text(family = "Open Sans"),
          plot.title = element_text(face = "bold", size = 18, color = "grey10"),
          plot.subtitle = element_text(size = 14, color = "grey30"),
          plot.caption = element_text(size = 11, face = "italic", color = "grey30", hjust=c(0, 1)),
          axis.title = element_text(size = 14, color = "grey30"),
          axis.text = element_text(size = 11, color = "grey40"),
          strip.text = element_text(size = 12, face = "bold", color = "grey10"),
          plot.margin = margin(10, 20, 10, 20),
          plot.title.position = "plot",
          plot.caption.position = "plot",
          legend.position = "top",
          legend.title = element_blank(),
          panel.grid.major.x = element_blank(),
          panel.grid.minor.x = element_blank(),
          panel.grid.major.y = element_line(size = .5),
          panel.grid.minor.y = element_line(size = .5, linetype = "longdash"),
          axis.ticks = element_blank()) +
    labs(title="La brecha de tiempo de permanencia entre el sector público y el privado se estrecha",
         subtitle="Tiempo mediano en la empresa (en años) de los ocupados por grupos de edad y sector\nEl eje vertical Y es independiente. Se han excluido a los ocupados de 16 a 24 años y mayores de 65 años por baja representatividad",
         caption=c("Fuente: Microdatos de la Encuesta de Población Activa (EPA), INE", "Elaborado por Jesús Escudero (@jescuderoma) | https://filasycolumnas.substack.com/"),
         x = "", y = "")

ggsave("graficos/finales/tiempo_mediano_sectores.png", width = 30, height = 18, units = "cm")



## gráfico porcentaje de ocupados por edades según tiempo en la empresa actual
ocupados_tiempo_empresa <- ocupados %>% 
    group_by(fecha, edad5, tiempo_empresa) %>% 
    summarise(ocupados = round(sum(factorel), 0)) %>% 
    mutate(ocupados_pct = ocupados/sum(ocupados)) %>% 
    mutate(grupo_edad = case_when(
        edad5 == "16" ~ "16-19 años",
        edad5 == "20" ~ "20-24",
        edad5 == "25" ~ "25-29",
        edad5 == "30" ~ "30-34",
        edad5 == "35" ~ "35-39",
        edad5 == "40" ~ "40-44",
        edad5 == "45" ~ "45-49",
        edad5 == "50" ~ "50-54",
        edad5 == "55" ~ "55-59",
        edad5 == "60" ~ "60-64",
        edad5 == "65" ~ "65 y más años"
    ))


ggplot(ocupados_tiempo_empresa,
       aes(x = fecha, y = ocupados_pct, fill = fct_rev(tiempo_empresa))) +
    geom_area(stat="identity", alpha = .85, color = "white") +
    annotate("segment", y = 0.5, yend = 0.5, x = as.Date("2004-01-01"), xend = as.Date("2021-12-31")) +
    theme_minimal() +
    scale_fill_viridis(discrete = TRUE, option = "magma", direction = 1) +
    scale_colour_manual(values = "#000000") +
    scale_y_continuous(breaks = seq(0,1,0.2), labels = label_percent(decimal.mark = ",", accuracy = 1L)) +
    facet_wrap(~grupo_edad, ncol = 4) +
    theme(text = element_text(family = "Open Sans"),
          plot.title = element_text(face = "bold", size = 18, color = "grey10"),
          plot.subtitle = element_text(size = 14, color = "grey30"),
          plot.caption = element_text(size = 11, face = "italic", color = "grey30", hjust=c(0, 1)),
          axis.title = element_text(size = 14, color = "grey30"),
          axis.text = element_text(size = 11, color = "grey40"),
          strip.text = element_text(size = 12, face = "bold", color = "grey10"),
          plot.margin = margin(10, 20, 10, 20),
          plot.title.position = "plot",
          plot.caption.position = "plot",
          legend.title = element_blank(),
          panel.grid.major.x = element_blank(),
          panel.grid.minor.x = element_blank(),
          panel.grid.major.y = element_line(size = .5),
          panel.grid.minor.y = element_blank(),
          axis.ticks = element_blank()) +
    labs(title="Los trabajadores jóvenes pasan menos tiempo en las empresas que hace una década",
         subtitle="Distribución de los ocupados por tiempo en la empresa por grupos de edad",
         caption=c("Fuente: Microdatos de la Encuesta de Población Activa (EPA), INE", "Elaborado por Jesús Escudero (@jescuderoma) | https://filasycolumnas.substack.com/"),
         x = "", y = "")

ggsave("graficos/finales/ocupados_tiempo_empresa.png", width = 30, height = 18, units = "cm")

