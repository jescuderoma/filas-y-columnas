# cargar librerías
library(tidyverse)
library(lubridate)
library(ggplot2)
library(viridis)
library(forcats)
library(janitor)
library(Hmisc)
library(gganimate)


# importar datos simplificados de la Encuesta de Condiciones de Vida 2008-2020 y crear columnas de generaciones
datos <- read_csv("data/edad_primer_trabajo_tidy.csv",
                  col_types = cols(.default = col_character(),
                                   PB010 = col_integer(),
                                   PB040 = col_double(),
                                   PB140 = col_double(),
                                   PL190 = col_double())) %>%
    mutate(nacimiento=case_when(
        PB140<=1939 ~ 1939, ### 1939 = nacidos en 1939 o antes
        TRUE ~ PB140),
        generacion=case_when(
            nacimiento<=1945 ~ "Silenciosa\n(<1946)",
            nacimiento>=1946 & nacimiento<=1965 ~ "Boomers\n(1946-1965)",
            nacimiento>=1966 & nacimiento<=1980 ~ "Generación X\n(1966-1980)",
            nacimiento>=1981 & nacimiento<=1995 ~ "Millennials\n(1981-1995)",
            nacimiento>=1996 ~ "Zeta\n(>1995)",
        ))

datos$generacion <- factor(datos$generacion, levels = c("Silenciosa\n(<1946)", "Boomers\n(1946-1965)",
                                                           "Generación X\n(1966-1980)", "Millennials\n(1981-1995)",
                                                           "Zeta\n(>1995)"))


# generar data frame con datos de la ECV 2020
datos2020 <- datos %>%
    filter(PB010=="2020", !is.na(PL190))


# gráfico box plot por generaciones para ECV 2020
ggplot(datos2020,
       aes(x = generacion, y = PL190, group = generacion, weight = PB040, fill = generacion)) +
    geom_boxplot(varwidth = TRUE, outlier.shape = NA, boxlty = 0, colour = I("grey80"), fatten = 3) +
    scale_y_continuous(breaks = seq(8,32,4), limits = c(8,32)) +
    scale_fill_viridis(option="plasma", direction = 1, discrete = TRUE) +
    theme_minimal() +
    theme(text = element_text(family = "Open Sans"),
          plot.title = element_text(face = "bold", size = 18, color = "grey10"),
          plot.subtitle = element_text(size = 14, color = "grey30"),
          plot.caption = element_text(size = 11, face = "italic", color = "grey30", hjust=c(0, 1)),
          axis.title = element_text(size = 14, color = "grey30"),
          axis.text = element_text(size = 14, color = "grey30"),
          legend.text = element_text(size = 11, color = "grey40"),
          strip.text = element_text(size = 12, face = "bold", color = "grey10"),
          plot.margin = margin(10, 20, 10, 20),
          plot.title.position = "plot",
          plot.caption.position = "plot",
          legend.title = element_blank(),
          legend.position = "none",
          panel.grid.major.x = element_blank(),
          panel.grid.minor.x = element_blank(),
          panel.grid.major.y = element_line(size = .5),
          panel.grid.minor.y = element_line(size = .5, linetype = "longdash"),
          axis.ticks = element_blank()) +
    labs(title="A qué edad tuvieron el primer trabajo las diferentes generaciones",
         subtitle = "El ancho de las cajas es proporcional al tamaño de cada generación (personas de 16 o más años en 2020)",
         caption=c("Fuente: Encuesta de Condiciones de Vida 2020, INE", "Elaborado por Jesús Escudero (@jescuderoma) | https://filasycolumnas.substack.com/"),
         x = "", y = "")

ggsave("graficos/edad_trabajo_generaciones.jpg", width = 30, height = 18, units = "cm")


# gráfico box plot por año de nacimiento para ECV 2020
ggplot(datos2020,
       aes(x = nacimiento, y = PL190, group = nacimiento, weight = PB040, fill = generacion)) +
    geom_boxplot(varwidth = TRUE, coef = 0, outlier.shape = NA, boxlty = 0, colour = I("white"), fatten = 3) +
    scale_y_continuous(breaks = seq(12,24,4), limits = c(11,24)) +
    scale_x_continuous(breaks = seq(1940,2000,5)) +
    scale_fill_viridis(option="plasma", direction = 1, discrete = TRUE) +
    theme_minimal() +
    theme(text = element_text(family = "Open Sans"),
          plot.title = element_text(face = "bold", size = 18, color = "grey10"),
          plot.subtitle = element_text(size = 14, color = "grey30"),
          plot.caption = element_text(size = 11, face = "italic", color = "grey30", hjust=c(0, 1)),
          axis.title = element_text(size = 14, color = "grey30"),
          axis.text = element_text(size = 13, color = "grey40"),
          legend.text = element_text(size = 12, color = "grey40"),
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
    labs(title="La primera experiencia laboral se ha retrasado de los 16 a los 20 años en medio siglo",
         subtitle = "Edad mediana y rango intercuartílico de la edad del primer trabajo por año de nacimiento\n1939 = Nacidos en 1939 o antes",
         caption=c("Fuente: Encuesta de Condiciones de Vida 2020, INE", "Elaborado por Jesús Escudero (@jescuderoma) | https://filasycolumnas.substack.com/"),
         x = "Año de nacimiento", y = "")

ggsave("graficos/edad_trabajo_nacimiento.jpg", width = 30, height = 18, units = "cm")
