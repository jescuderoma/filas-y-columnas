## cargar librerías
library(tidyverse)
library(lubridate)
library(ggplot2)
library(viridis)
library(forcats)
library(ggthemes)


## unir data frames ERTE y afiliados y calcular porcentajes para cada actividad
erte <- read_csv("data/tidy/erte_sectores_tidy.csv") %>% 
    select(fecha, cnae_cod, cnae_nombre, trabajadores_erte_media_mes)

afiliados <- read_csv("data/tidy/afiliados_medios_sectores_tidy.csv") %>% 
    select(-cnae_nombre)

erte_afiliados <- left_join(erte, afiliados,
                            by = c("fecha", "cnae_cod")) %>% 
    mutate(erte_afiliados_general_pct=round(trabajadores_erte_media_mes/afiliados_medios_reg_general*100,2)) %>% 
    filter(cnae_cod!="50" & !is.na(trabajadores_erte_media_mes)) # excluir el sector 50 - Transporte marítimo al tener más trabajadores en ERTE que afiliados


## producción gráfico exploratorio con evolución % ERTE sobre afiliados por sectores
ggplot(erte_afiliados,
       aes(x = fecha, y = erte_afiliados_general_pct, group = cnae_cod, color = erte_afiliados_general_pct)) +
    geom_line(size = 1) +
    facet_wrap(~cnae_cod, ncol = 7) +
    scale_color_viridis(option="magma") +
    theme_minimal() +
    theme(legend.position = "top",
          legend.title= element_blank())


## elaborar gráfico para los sectores más afectados (+20% en marzo de 2021)
erte_afiliados_sectores1 <- erte_afiliados %>% 
    filter(cnae_cod%in%c("79", "55", "92", "51", "56", "93")) %>% 
    mutate(nombre_corto=case_when(
        cnae_cod == "79" ~ "Agencias de viajes",
        cnae_cod == "51" ~ "Transporte aéreo",
        cnae_cod == "55" ~ "Hoteles y alojamientos",
        cnae_cod == "56" ~ "Hostelería",
        cnae_cod == "92" ~ "Loterías y casas de apuestas",
        cnae_cod == "93" ~ "Deporte, ocio y entretenimiento",
    ))

erte_afiliados_sectores1$nombre_corto <- factor(erte_afiliados_sectores1$nombre_corto,
                                                   levels = c("Agencias de viajes", "Transporte aéreo",
                                                              "Hoteles y alojamientos", "Loterías y casas de apuestas", 
                                                              "Hostelería", "Deporte, ocio y entretenimiento"))

ggplot(erte_afiliados_sectores1,
       aes(x = fecha, y = erte_afiliados_general_pct)) +
    annotate("rect", fill = "#FCFBBD", xmin = as.Date("2020-04-01"), xmax = as.Date("2020-06-10"), ymin = 0, ymax = 85, alpha = .4) +
    annotate("rect", fill = "#FCFBBD", xmin = as.Date("2020-09-15"), xmax = as.Date("2020-11-15"), ymin = 0, ymax = 85, alpha = .4) +
    annotate("rect", fill = "#FCFBBD", xmin = as.Date("2021-01-10"), xmax = as.Date("2021-02-25"), ymin = 0, ymax = 85, alpha = .4) +
    annotate("segment", color = "grey10", x = as.Date("2020-04-01"), xend = as.Date("2021-05-01"), y = 0, yend = 0) +
    geom_step(size = 1.5, color = "#cf735f") +
    ylim (0,85) +
    facet_wrap(~nombre_corto, ncol = 3) +
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
          legend.position = "none",
          panel.grid.major.x = element_blank(),
          panel.grid.minor.x = element_blank(),
          panel.grid.major.y = element_line(size = .5),
          panel.grid.minor.y = element_line(size = .5, linetype = "longdash"),
          axis.ticks = element_blank()) +
    labs(title="Los sectores con mayor incidencia de los ERTE (>20% en marzo 2021)",
         subtitle="% afiliados del Rég. General en ERTE (media mensual) por divisiones CNAE-2009 a dos dígitos",
         caption=c("Fuente: Ministerio de Inclusión, Seguridad Social y Migraciones", "Elaborado por Jesús Escudero (@jescuderoma) | https://filasycolumnas.substack.com/"),
         x = "", y = "")

ggsave("graficos/finales/sectores_incidencia_elevada.png", width = 30, height = 18, units = "cm")


## elaborar gráfico para los sectores afectados nivel medio (+10% en marzo de 2021)
erte_afiliados_sectores2 <- erte_afiliados %>% 
    filter(cnae_cod%in%c("90", "77", "14", "91", "18", "59")) %>% 
    mutate(nombre_corto=case_when(
        cnae_cod == "90" ~ "Arte y espectáculos",
        cnae_cod == "77" ~ "Actividades de alquiler",
        cnae_cod == "14" ~ "Confección de ropa",
        cnae_cod == "91" ~ "Bibliotecas y museos",
        cnae_cod == "18" ~ "Artes gráficas",
        cnae_cod == "59" ~ "Cine, vídeo, TV y sonido",
    ))

erte_afiliados_sectores2$nombre_corto <- factor(erte_afiliados_sectores2$nombre_corto,
                                                levels = c("Arte y espectáculos", "Bibliotecas y museos",
                                                           "Cine, vídeo, TV y sonido", "Artes gráficas",
                                                           "Actividades de alquiler", "Confección de ropa"))

ggplot(erte_afiliados_sectores2,
       aes(x = fecha, y = erte_afiliados_general_pct)) +
    annotate("rect", fill = "#FCFBBD", xmin = as.Date("2020-04-01"), xmax = as.Date("2020-06-10"), ymin = 0, ymax = 45, alpha = .4) +
    annotate("rect", fill = "#FCFBBD", xmin = as.Date("2020-09-15"), xmax = as.Date("2020-11-15"), ymin = 0, ymax = 45, alpha = .4) +
    annotate("rect", fill = "#FCFBBD", xmin = as.Date("2021-01-10"), xmax = as.Date("2021-02-25"), ymin = 0, ymax = 45, alpha = .4) +
    annotate("segment", color = "grey10", x = as.Date("2020-04-01"), xend = as.Date("2021-05-01"), y = 0, yend = 0) +
    geom_step(size = 1.5, color = "#772278") +
    ylim (0,45) +
    facet_wrap(~nombre_corto, ncol = 3) +
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
          legend.position = "none",
          panel.grid.major.x = element_blank(),
          panel.grid.minor.x = element_blank(),
          panel.grid.major.y = element_line(size = .5),
          panel.grid.minor.y = element_line(size = .5, linetype = "longdash"),
          axis.ticks = element_blank()) +
    labs(title="Los sectores con una incidencia moderada de los ERTE (>12% en marzo 2021)",
         subtitle="% afiliados del Rég. General en ERTE (media mensual) por divisiones CNAE-2009 a dos dígitos",
         caption=c("Fuente: Ministerio de Inclusión, Seguridad Social y Migraciones", "Elaborado por Jesús Escudero (@jescuderoma) | https://filasycolumnas.substack.com/"),
         x = "", y = "")

ggsave("graficos/finales/sectores_incidencia_moderadada.png", width = 30, height = 18, units = "cm")


## elaborar gráfico para los sectores afectados por encima de la media (+5% en marzo de 2021)
erte_afiliados_sectores3 <- erte_afiliados %>% 
    filter(cnae_cod%in%c("11", "03", "13", "58", "52", "46", "73", "47", "45")) %>% 
    mutate(nombre_corto=case_when(
        cnae_cod == "11" ~ "Fabricación de bebidas",
        cnae_cod == "03" ~ "Pesca y acuicultura",
        cnae_cod == "13" ~ "Industria textil",
        cnae_cod == "58" ~ "Edición",
        cnae_cod == "52" ~ "Act. auxiliares al transporte",
        cnae_cod == "46" ~ "Comercio mayorista",
        cnae_cod == "73" ~ "Publicidad y estudios de mercado",
        cnae_cod == "47" ~ "Comercio minorista",
        cnae_cod == "45" ~ "Concesionarios y talleres",
    ))

erte_afiliados_sectores3$nombre_corto <- factor(erte_afiliados_sectores3$nombre_corto,
                                                levels = c("Fabricación de bebidas", "Industria textil", "Act. auxiliares al transporte",
                                                           "Pesca y acuicultura", "Edición", "Publicidad y estudios de mercado",
                                                           "Comercio mayorista", "Comercio minorista", "Concesionarios y talleres"))

ggplot(erte_afiliados_sectores3,
       aes(x = fecha, y = erte_afiliados_general_pct)) +
    annotate("rect", fill = "#FCFBBD", xmin = as.Date("2020-04-01"), xmax = as.Date("2020-06-10"), ymin = 0, ymax = 80, alpha = .4) +
    annotate("rect", fill = "#FCFBBD", xmin = as.Date("2020-09-15"), xmax = as.Date("2020-11-15"), ymin = 0, ymax = 80, alpha = .4) +
    annotate("rect", fill = "#FCFBBD", xmin = as.Date("2021-01-10"), xmax = as.Date("2021-02-25"), ymin = 0, ymax = 80, alpha = .4) +
    annotate("segment", color = "grey10", x = as.Date("2020-04-01"), xend = as.Date("2021-05-01"), y = 0, yend = 0) +
    geom_step(size = 1.5, color = "#2d205d") +
    ylim (0,80) +
    facet_wrap(~nombre_corto, ncol = 3) +
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
          legend.position = "none",
          panel.grid.major.x = element_blank(),
          panel.grid.minor.x = element_blank(),
          panel.grid.major.y = element_line(size = .5),
          panel.grid.minor.y = element_line(size = .5, linetype = "longdash"),
          axis.ticks = element_blank()) +
    labs(title="Los sectores con una incidencia de los ERTE superior la media nacional (>5% en marzo 2021)",
         subtitle="% afiliados del Rég. General en ERTE (media mensual) por divisiones CNAE-2009 a dos dígitos",
         caption=c("Fuente: Ministerio de Inclusión, Seguridad Social y Migraciones", "Elaborado por Jesús Escudero (@jescuderoma) | https://filasycolumnas.substack.com/"),
         x = "", y = "")

ggsave("graficos/finales/sectores_incidencia_superior_media.png", width = 30, height = 24, units = "cm")



