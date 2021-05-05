## cargar librerías e importar datos
library(tidyverse)
library(ggplot2)
library(viridis)
library(scales)
library(directlabels)

tidy_data <- read_csv("data/tidy/autoubicacion_edades_tidy.csv")

tidy_data$grupo_edad <- factor(tidy_data$grupo_edad,
                               levels = c("65 y más años", "55-64", "45-54", "35-44", "25-34", "18-24"))


## gráfico de evolución de la autoubicación ideológica media por edades
autoubicacion_media_edad <- tidy_data %>% 
    filter(autoubicacion%in%c(1,2,3,4,5,6,7,8,9,10)) %>% 
    group_by(fecha, estudio, grupo_edad) %>% 
    summarise(autoubicacion_media = round(mean(autoubicacion),2),
              desviacion_tipica = round(sd(autoubicacion),2)) %>% 
    filter(!is.na(grupo_edad))

ggplot(autoubicacion_media_edad,
       aes(x = fecha, y = autoubicacion_media, group = grupo_edad, color = grupo_edad, label = grupo_edad)) +
    geom_smooth(size = 1.5, span = 0.15, se = FALSE) +
    annotate("segment", x = as.Date("2018-01-01"), xend = as.Date("2021-01-01"), y = 4.55, yend = 4.8, size = 1.1, colour = "#6baed6", linetype = "dashed", arrow=arrow(length=unit(0.30,"cm"), type = "closed")) +
    annotate("segment", x = as.Date("2017-01-01"), xend = as.Date("2021-01-01"), y = 5.3, yend = 4.95, size = 1.1, colour = "#fb6a4a", linetype = "dashed", arrow=arrow(length=unit(0.30,"cm"), type = "closed")) +
    annotate("text", x = as.Date("2019-01-01"), y = 4.7, label = "Más derecha", color = "#6baed6", angle = 47) +
    annotate("text", x = as.Date("2019-07-01"), y = 5.16, label = "Más izquierda", color = "#fb6a4a", angle = -50) +
    scale_color_viridis(discrete = TRUE, option = "plasma", direction = 1) +
    scale_y_continuous(breaks = seq(4, 5.4, 0.2), limits = c(4,5.4), labels = label_number(decimal.mark = ",", accuracy = 0.1L)) +
    scale_x_date(date_breaks = "4 years", date_labels = "%Y") +
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
          panel.grid.major.x = element_line(size = .5),
          panel.grid.minor.x = element_line(size = .5, linetype = "longdash"),
          panel.grid.major.y = element_line(size = .5),
          panel.grid.minor.y = element_line(size = .5, linetype = "longdash"),
          axis.ticks = element_blank()) +
    labs(title="La brecha ideológica entre los jubilados y el resto de edades se está estrechando desde 2017",
         subtitle="Autoubicacion ideológica media por grupos de edad (1: Extrema izquierda - 10: Extrema derecha)\nLas curvas se han suavizado mediante geom_smooth(span = 0.15)",
         caption=c("Fuente: Elaboración propia a partir de microdatos del CIS", "Elaborado por Jesús Escudero (@jescuderoma) | https://filasycolumnas.substack.com/"),
         x = "", y = "")

ggsave("graficos/autoubicacion_media_edades.png", width = 30, height = 18, units = "cm")


## gráfico de porcentaje de personas según el grupo ideológico
distribucion_ubicacion <- tidy_data %>% 
    filter(autoubicacion_grupo!="-99") %>% 
    group_by(fecha, estudio, autoubicacion_grupo) %>% 
    summarise(encuestados=n()) %>% 
    mutate(encuestados_pct=encuestados/(sum(encuestados)))

colores_ideologia <- c("#a50f15", "#fb6a4a", "#FADA24", "#6baed6", "#08519c", "#404040")

ggplot(distribucion_ubicacion,
       aes(x = fecha, y = encuestados_pct, group = autoubicacion_grupo, color = autoubicacion_grupo)) +
    geom_smooth(size = 1.5, span = 0.15, se = FALSE) +
    scale_color_manual(values = colores_ideologia) +
    scale_y_continuous(labels = label_percent(decimal.mark = ",", accuracy = 1L)) +
    scale_x_date(date_breaks = "4 years", date_labels = "%Y") +
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
          panel.grid.major.x = element_line(size = .5),
          panel.grid.minor.x = element_line(size = .5, linetype = "longdash"),
          panel.grid.major.y = element_line(size = .5),
          panel.grid.minor.y = element_line(size = .5, linetype = "longdash"),
          axis.ticks = element_blank()) +
    labs(title="El porcentaje de españoles que declara su ideología política ha aumentado desde 2017",
         subtitle="% de encuestados que se autoubica en cada grupo ideológico. Las curvas se han suavizado mediante geom_smooth(span = 0.15)",
         caption=c("Fuente: Elaboración propia a partir de microdatos del CIS", "Elaborado por Jesús Escudero (@jescuderoma) | https://filasycolumnas.substack.com/"),
         x = "", y = "")

ggsave("graficos/distribucion_autoubicacion.png", width = 30, height = 18, units = "cm")


## gráfico de porcentaje de personas según el grupo ideológico por edades
distribucion_ubicacion_edad <- tidy_data %>% 
    filter(autoubicacion_grupo!="-99" & grupo_edad!="-99") %>% 
    group_by(fecha, estudio, grupo_edad, autoubicacion_grupo) %>% 
    summarise(encuestados=n()) %>% 
    mutate(encuestados_pct=encuestados/(sum(encuestados)))

ggplot(distribucion_ubicacion_edad,
       aes(x = fecha, y = encuestados_pct, group = grupo_edad, color = grupo_edad)) +
    geom_smooth(size = 1.5, span = 0.15, se = FALSE) +
    scale_color_viridis(discrete = TRUE, option = "plasma", direction = 1) +
    scale_y_continuous(labels = label_percent(decimal.mark = ",", accuracy = 1L)) +
    scale_x_date(date_breaks = "8 years", date_labels = "%Y") +
    facet_wrap(~autoubicacion_grupo) +
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
          panel.grid.major.x = element_line(size = .5),
          panel.grid.minor.x = element_line(size = .5, linetype = "longdash"),
          panel.grid.major.y = element_line(size = .5),
          panel.grid.minor.y = element_line(size = .5, linetype = "longdash"),
          axis.ticks = element_blank()) +
    labs(title="Las personas con ideologías a contracorriente de su grupo de edad salen del armario",
         subtitle="% de encuestados que se autoubica en cada grupo ideológico por grupos de edad\nLas curvas se han suavizado mediante geom_smooth(span = 0.15)",
         caption=c("Fuente: Elaboración propia a partir de microdatos del CIS", "Elaborado por Jesús Escudero (@jescuderoma) | https://filasycolumnas.substack.com/"),
         x = "", y = "")

ggsave("graficos/distribucion_autoubicacion_edades.png", width = 30, height = 18, units = "cm")
