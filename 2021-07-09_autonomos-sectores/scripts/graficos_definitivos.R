# cargar librerías
library(tidyverse)
library(lubridate)
library(ggplot2)
library(viridis)
library(scales)
library(forcats)
library(janitor)


# importar datos por actividades y obtener columna de porcentaje de autónomos sobre el total
datos_sectores <- read_csv("https://raw.githubusercontent.com/jescuderoma/filas-y-columnas/main/2021-04-12_erte-afiliados-sectores/data/tidy/afiliados_medios_sectores_tidy.csv") %>% 
    mutate(autonomos_pct=afiliados_medios_autonomos/afiliados_medios_total)

# datos generales
datos_generales <- datos_sectores %>% 
    group_by(fecha) %>% 
    summarise(afiliados_reg_general=sum(afiliados_medios_reg_general),
              afiliados_autonomos=sum(afiliados_medios_autonomos),
              afiliados_totales=sum(afiliados_medios_total)) %>% 
    mutate(autonomos_pct=afiliados_autonomos/afiliados_totales)

### obtener medianas de porcentaje de autonómos y unirlo al data frame de datos generales
datos_medianas_generales <- datos_sectores %>% 
    group_by(fecha) %>% 
    summarise(mediana_afiliados=median(autonomos_pct, na.rm = TRUE))

datos_generales <- left_join(datos_generales, datos_medianas_generales,
                             by = "fecha")

rm(datos_medianas_generales)


# gráfico general de porcentaje de autónomos (media y mediana)
media_mediana_general <- datos_generales %>% 
    select(fecha, media=autonomos_pct, mediana=mediana_afiliados) %>% 
    pivot_longer(cols = 2:3, names_to = "indicador", values_to = "porcentaje")

ggplot(media_mediana_general,
       aes(x = fecha, y = porcentaje, group = indicador, color = indicador)) +
    geom_line(size = 2, lineend = "round") +
    scale_x_date(breaks = as.Date(c("2009-01-01", "2013-01-01", "2017-01-01", "2021-01-01")), date_labels = "%Y") +
    scale_y_continuous(breaks = seq(0.08, 0.24, 0.04), limits = c(0.08,0.22), labels = label_percent(decimal.mark = ",", accuracy = 1L)) +
    scale_color_manual(values = c("#2d205d", "#cf735f")) +
    theme_minimal() +
    theme(text = element_text(family = "Open Sans"),
          plot.title = element_text(face = "bold", size = 18, color = "grey10"),
          plot.subtitle = element_text(size = 14, color = "grey30"),
          plot.caption = element_text(size = 11, face = "italic", color = "grey30", hjust=c(0, 1)),
          axis.title = element_text(size = 14, color = "grey30"),
          axis.text = element_text(size = 11, color = "grey40"),
          legend.text = element_text(size = 11, color = "grey40"),
          strip.text = element_text(size = 12, face = "bold", color = "grey10"),
          plot.margin = margin(10, 20, 10, 20),
          plot.title.position = "plot",
          plot.caption.position = "plot",
          legend.title = element_blank(),
          legend.position = "top",
          panel.grid.major.x = element_blank(),
          panel.grid.minor.x = element_blank(),
          panel.grid.major.y = element_line(size = .5),
          panel.grid.minor.y = element_line(size = .5, linetype = "longdash"),
          axis.ticks = element_blank()) +
    labs(title="El 18% de los afiliados a la Seguridad Social son autónomos",
         caption=c("Fuente: Afiliados medios a la Seguridad Social", "Elaborado por Jesús Escudero (@jescuderoma) | https://filasycolumnas.substack.com/"),
         x = "", y = "")

ggsave("graficos/afiliados_medios_general.png", width = 30, height = 18, units = "cm")


# gráfico diferencia % autónomos junio 2009-junio 2021 por actividades
autonomos_junio_2009_2021 <- datos_sectores %>% 
    filter(fecha=="2021-06-01" | fecha=="2009-06-01", afiliados_medios_total > 10000) %>% 
    select(fecha, cnae_cod, cnae_nombre, autonomos_pct) %>% 
    pivot_wider(names_from = "fecha", values_from = "autonomos_pct") %>% 
    clean_names() %>% 
    rename(junio2009 = x2009_06_01, junio2021 = x2021_06_01) %>% 
    mutate(nombre_completo = paste0(cnae_cod, " - ", cnae_nombre),
           diferencia=junio2021-junio2009,
           nombre_completo = fct_reorder(nombre_completo, junio2021),
           diferencia_cat = case_when(
               diferencia > 0 ~ "Más % de autónomos",
               diferencia < 0 ~ "Menos % de autónomos"
           ))

ggplot(autonomos_junio_2009_2021) +
    geom_segment(aes(x = junio2009, y = nombre_completo, xend = junio2021, yend = nombre_completo, color = diferencia_cat), arrow = arrow(length=unit(0.15,"cm"), ends="last", type = "closed")) +
    scale_x_continuous(limits = c(-0.05,1)) +
    theme_minimal() +
    scale_color_manual(values = c("#2d205d", "#cf735f")) +
    geom_text(aes(x=junio2009, y=nombre_completo, label = scales::percent(junio2009, decimal.mark = ",", accuracy = 0.1L)), hjust=ifelse(autonomos_junio_2009_2021$junio2009<autonomos_junio_2009_2021$junio2021, 1.2, -.2), size = 4, color = "grey30") +
    geom_text(aes(x=junio2021, y=nombre_completo, label = scales::percent(junio2021, decimal.mark = ",", accuracy = 0.1L)), hjust=ifelse(autonomos_junio_2009_2021$junio2009<autonomos_junio_2009_2021$junio2021, -.2, 1.2), size = 4, color = "grey30") +
    theme(text = element_text(family = "Open Sans"),
          plot.title = element_text(face = "bold", size = 18, color = "grey10"),
          plot.subtitle = element_text(size = 14, color = "grey30"),
          plot.caption = element_text(size = 11, face = "italic", color = "grey30", hjust=c(0, 1)),
          axis.title = element_text(size = 14, color = "grey30"),
          axis.text = element_text(size = 11.5, color = "grey40"),
          axis.text.x = element_blank(),
          legend.text = element_text(size = 11, color = "grey40"),
          strip.text = element_text(size = 12, face = "bold", color = "grey10"),
          plot.margin = margin(10, 20, 10, 20),
          plot.title.position = "plot",
          plot.caption.position = "plot",
          legend.title = element_blank(),
          legend.position = "top",
          panel.grid.major.x = element_blank(),
          panel.grid.minor.x = element_blank(),
          panel.grid.major.y = element_blank(),
          panel.grid.minor.y = element_blank(),
          axis.ticks = element_blank()) +
    labs(title="Variación del % de autónomos por actividades entre junio 2009 y junio 2021",
         subtitle="Se han excluido las actividades con menos de 10.000 afiliados totales",
         caption=c("Fuente: Afiliados medios a la Seguridad Social", "Elaborado por Jesús Escudero (@jescuderoma) | https://filasycolumnas.substack.com/"),
         x = "", y = "")

ggsave("graficos/afiliados_actividades_diferencia.png", width = 30, height = 54, units = "cm")



# gráfico actividades con mayor aumento del % de autónomos
actividades_subida <- datos_sectores %>% 
    filter(cnae_cod%in%c("90", "96", "79", "73", "14", "41", "59", "18", "53")) %>% 
    mutate(nombre_corto=case_when(
        cnae_cod == "90" ~ "Arte y espectáculos",
        cnae_cod == "96" ~ "Otros servicios personales",
        cnae_cod == "79" ~ "Agencias de viajes",
        cnae_cod == "73" ~ "Publicidad",
        cnae_cod == "14" ~ "Confección de ropa",
        cnae_cod == "41" ~ "Construcción de edificios",
        cnae_cod == "59" ~ "Cine, vídeo y TV",
        cnae_cod == "18" ~ "Artes gráficas",
        cnae_cod == "53" ~ "Actividades postales"
    ))

actividades_subida$nombre_corto <- factor(actividades_subida$nombre_corto,
                                                levels = c("Arte y espectáculos", "Otros servicios personales",
                                                           "Agencias de viajes", "Publicidad", "Confección de ropa",
                                                           "Construcción de edificios", "Cine, vídeo y TV",
                                                           "Artes gráficas", "Actividades postales"))

ggplot(actividades_subida,
       aes(x = fecha, y = autonomos_pct, group = nombre_corto)) +
    annotate("rect", fill = "#FCFBBD", xmin = as.Date("2020-03-01"), xmax = as.Date("2021-07-01"), ymin = 0, ymax = 0.6, alpha = .4) +
    geom_line(color = "#2d205d", size = 1.5, lineend = "round") +
    facet_wrap(~nombre_corto, ncol = 3) +
    theme_minimal() +
    scale_x_date(breaks = as.Date(c("2009-01-01", "2015-01-01", "2021-01-01")), date_labels = "%Y") +
    scale_y_continuous(limits = c(0,0.6), labels = label_percent(decimal.mark = ",", accuracy = 1L)) +
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
          legend.position = "top",
          panel.grid.major.x = element_blank(),
          panel.grid.minor.x = element_blank(),
          panel.grid.major.y = element_line(size = .5),
          panel.grid.minor.y = element_line(size = .5, linetype = "longdash"),
          axis.ticks = element_blank()) +
    labs(title="Las actividades económicas donde más se ha incrementado el % de autónomos",
         caption=c("Fuente: Afiliados medios a la Seguridad Social", "Elaborado por Jesús Escudero (@jescuderoma) | https://filasycolumnas.substack.com/"),
         x = "", y = "")

ggsave("graficos/actividades_subida.png", width = 30, height = 24, units = "cm")


# gráfico actividades con mayor descenso del % de autónomos
actividades_bajada <- datos_sectores %>% 
    filter(cnae_cod%in%c("01", "95", "75", "56", "63", "42")) %>% 
    mutate(nombre_corto=case_when(
        cnae_cod == "01" ~ "Agricultura y ganadería",
        cnae_cod == "95" ~ "Reparación de ordenadores y otros",
        cnae_cod == "75" ~ "Actividades veterinarias",
        cnae_cod == "56" ~ "Bares y restaurantes",
        cnae_cod == "63" ~ "Servicios de información",
        cnae_cod == "42" ~ "Ingeniería civil"
    ))

actividades_bajada$nombre_corto <- factor(actividades_bajada$nombre_corto,
                                          levels = c("Agricultura y ganadería", "Reparación de ordenadores y otros",
                                                     "Actividades veterinarias", "Bares y restaurantes",
                                                     "Servicios de información", "Ingeniería civil"))

ggplot(actividades_bajada,
       aes(x = fecha, y = autonomos_pct, group = nombre_corto)) +
    annotate("rect", fill = "#FCFBBD", xmin = as.Date("2020-03-01"), xmax = as.Date("2021-07-01"), ymin = 0, ymax = 0.91, alpha = .4) +
    geom_line(color = "#cf735f", size = 1.5, lineend = "round") +
    facet_wrap(~nombre_corto, ncol = 3) +
    theme_minimal() +
    scale_x_date(breaks = as.Date(c("2009-01-01", "2015-01-01", "2021-01-01")), date_labels = "%Y") +
    scale_y_continuous(limits = c(0,0.91), breaks = seq(0,1,0.2), labels = label_percent(decimal.mark = ",", accuracy = 1L)) +
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
          legend.position = "top",
          panel.grid.major.x = element_blank(),
          panel.grid.minor.x = element_blank(),
          panel.grid.major.y = element_line(size = .5),
          panel.grid.minor.y = element_line(size = .5, linetype = "longdash"),
          axis.ticks = element_blank()) +
    labs(title="Las actividades económicas donde más se ha reducido el % de autónomos",
         caption=c("Fuente: Afiliados medios a la Seguridad Social", "Elaborado por Jesús Escudero (@jescuderoma) | https://filasycolumnas.substack.com/"),
         x = "", y = "")

ggsave("graficos/actividades_bajada.png", width = 30, height = 18, units = "cm")

