## cargar librerías e importar tidy data
library(ggplot2)
library(gganimate)
library(viridis)
library(scales)

source("scripts/data_tidying.R")


## gráfico resumen evolución nacimientos meses
ggplot(tidy_data,
       aes(x = ano, y = nacidos_mes_pct, color = nacidos_mes_pct)) +
    geom_segment(color = "grey10", x = 1972, xend = 2022, y = 0.08333, yend = 0.08333, size = .75) +
    annotate("text", x = 1975, y = 0.069, label="1975", color="grey40", hjust = 0) +
    annotate("text", x = 2019, y = 0.069, label="2019", color="grey40", hjust = 1) +
    geom_line(size = 1) +
    geom_smooth(colour = "dodgerblue1", se = FALSE, size = 1.3) +
    facet_wrap(~mes, ncol = 12) +
    ylim (0.0685, 0.0965) +
    scale_color_viridis(option="magma", direction = 1) +
    scale_x_continuous(breaks=c(1975, 2019)) +
    scale_y_continuous(breaks=seq(0.07,0.095,0.005), labels = label_percent(decimal.mark = ",", accuracy = 0.1L)) +
    theme_minimal() +
    theme(text = element_text(family = "Open Sans"),
          plot.title = element_text(face = "bold", size = 18, color = "grey10"),
          plot.subtitle = element_text(size = 14, color = "grey30"),
          plot.caption = element_text(size = 11, face = "italic", color = "grey30", hjust=c(0, 1)),
          axis.title = element_text(size = 14, color = "grey30"),
          axis.text.y = element_text(size = 11, color = "grey40"),
          axis.text.x = element_blank(),
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
    labs(title="Los millennials cumplen años en primavera; sus hijos, en el 'veroño'",
         subtitle="Distribución mensual de los nacimientos en cada año (1975-2019). La línea negra representa la distribución uniforme (8,333% = 1/12)",
         caption=c("Fuente: Estadística de Nacimientos, INE", "Elaborado por Jesús Escudero (@jescuderoma) | https://filasycolumnas.substack.com/"),
         x = "", y = "")

ggsave("graficos/evolucion_anual_meses.png", width = 30, height = 18, units = "cm")


## gráfico comparativa mayo vs. octubre
mayo_octubre <- tidy_data %>% 
    filter(mes%in%c("may", "oct")) %>% 
    mutate(mes = month(fecha, label = TRUE, abbr = FALSE))


ggplot(mayo_octubre,
       aes(x = ano, y = nacidos_mes_pct, color = mes)) + 
    geom_segment(color = "grey10", x = 1972, xend = 2022, y = 0.08333, yend = 0.08333, size = .75) +
    geom_smooth(se = FALSE, size = 1.3, linetype = "dashed") +
    geom_line(size = 1.5) +
    scale_x_continuous(breaks=c(1975, 1985, 1995, 2005, 2015)) +
    scale_y_continuous(breaks=seq(0.08,0.095,0.005), limits = c(0.08, 0.095), labels = label_percent(decimal.mark = ",", accuracy = 0.1L)) +
    scale_colour_manual(values = c("#2d205d", "#cf735f")) +
    theme_minimal() +
    theme_minimal() +
    theme(plot.title = element_text(face = "bold", size = 18, color = "grey10"),
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
          legend.key.width =  unit(5, "lines"),
          panel.grid.major.x = element_blank(),
          panel.grid.minor.x = element_blank(),
          panel.grid.major.y = element_line(size = .5),
          panel.grid.minor.y = element_line(size = .5, linetype = "longdash"),
          axis.ticks = element_blank()) +
    labs(title="Octubre, el nuevo mes favorito de las parejas para tener bebés",
         subtitle="% de nacimientos en mayo y octubre (1975-2019). La línea negra representa la distribución uniforme (8,333% = 1/12)",
         caption=c("Fuente: Estadística de Nacimientos, INE", "Elaborado por Jesús Escudero (@jescuderoma) | https://filasycolumnas.substack.com/"),
         x = "", y = "")

ggsave("graficos/comparativa_mayo_octubre.png", width = 30, height = 18, units = "cm")


## gráfico comparativa abril-mayo vs. septiembre-octubre
abril_septiembre <- tidy_data %>% 
    select(ano, mes, nacidos_mes_pct) %>% 
    filter(mes%in%c("abr", "may", "sep", "oct")) %>% 
    pivot_wider(names_from = "mes", values_from = "nacidos_mes_pct") %>% 
    mutate(abril_mayo=abr+may,
           septiembre_octubre=sep+oct) %>% 
    select(ano, abril_mayo, septiembre_octubre) %>% 
    pivot_longer(names_to = "mes", values_to = "nacidos_mes_pct", cols = 2:3)

ggplot(abril_septiembre,
       aes(x = ano, y = nacidos_mes_pct, color = mes)) + 
    geom_segment(color = "grey10", x = 1972, xend = 2022, y = 0.166, yend = 0.166, size = .75) +
    geom_smooth(se = FALSE, size = 1.3, linetype = "dashed") +
    geom_line(size = 1.5) +
    scale_x_continuous(breaks=c(1975, 1985, 1995, 2005, 2015)) +
    scale_y_continuous(breaks=seq(0.155,0.1825,0.005), limits = c(0.155, 0.1825), labels = label_percent(decimal.mark = ",", accuracy = 0.1L)) +
    scale_colour_manual(values = c("#2d205d", "#cf735f")) +
    theme_minimal() +
    theme_minimal() +
    theme(plot.title = element_text(face = "bold", size = 18, color = "grey10"),
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
          legend.key.width =  unit(5, "lines"),
          panel.grid.major.x = element_blank(),
          panel.grid.minor.x = element_blank(),
          panel.grid.major.y = element_line(size = .5),
          panel.grid.minor.y = element_line(size = .5, linetype = "longdash"),
          axis.ticks = element_blank()) +
    labs(title="Cada año nacen menos bebés en primavera",
         subtitle="Distribución de los nacimientos en cada año (1975-2019). La línea negra representa la distribución uniforme (16,666% = 2/12)",
         caption=c("Fuente: Estadística de Nacimientos, INE", "Elaborado por Jesús Escudero (@jescuderoma) | https://filasycolumnas.substack.com/"),
         x = "", y = "")

ggsave("graficos/comparativa_abril_septiembre.png", width = 30, height = 18, units = "cm")


## gráfico evolución nacimientos diciembre
diciembre <- tidy_data %>% 
    filter(mes=="dic") %>% 
    mutate(mes = month(fecha, label = TRUE, abbr = FALSE))

ggplot(diciembre,
       aes(x = ano, y = nacidos_mes_pct, color = mes)) + 
    geom_segment(color = "grey10", x = 1972, xend = 2022, y = 0.08333, yend = 0.08333, size = .75) +
    geom_line(size = 1.5) +
    geom_curve(x = 2013, xend = 2010.3, y = 0.0888, yend = 0.0896, colour = "grey10") +
    annotate("text", x = 2012, y = 0.0887, label = "Diciembre fue el mes con\nmás partos del año 2010", colour = "grey10", hjust = 0, vjust = 1) +
    scale_x_continuous(breaks=c(1975, 1985, 1995, 2005, 2015)) +
    scale_y_continuous(breaks=seq(0.07,0.09,0.005), limits = c(0.0725, 0.09), labels = label_percent(decimal.mark = ",", accuracy = 0.1L)) +
    scale_colour_manual(values = "#2d205d") +
    theme_minimal() +
    theme_minimal() +
    theme(plot.title = element_text(face = "bold", size = 18, color = "grey10"),
          plot.subtitle = element_text(size = 14, color = "grey30"),
          plot.caption = element_text(size = 11, face = "italic", color = "grey30", hjust=c(0, 1)),
          axis.title = element_text(size = 14, color = "grey30"),
          axis.text = element_text(size = 11, color = "grey40"),
          strip.text = element_text(size = 12, face = "bold", color = "grey10"),
          plot.margin = margin(10, 20, 10, 20),
          plot.title.position = "plot",
          plot.caption.position = "plot",
          legend.position = "none",
          legend.title = element_blank(),
          legend.key.width =  unit(5, "lines"),
          panel.grid.major.x = element_blank(),
          panel.grid.minor.x = element_blank(),
          panel.grid.major.y = element_line(size = .5),
          panel.grid.minor.y = element_line(size = .5, linetype = "longdash"),
          axis.ticks = element_blank()) +
    labs(title="El fin del cheque-bebé adelantó miles de nacimientos en diciembre de 2010",
         subtitle="% de nacimientos en diciembre (1975-2019). La línea negra representa la distribución uniforme (8,333% = 1/12)",
         caption=c("Fuente: Estadística de Nacimientos, INE", "Elaborado por Jesús Escudero (@jescuderoma) | https://filasycolumnas.substack.com/"),
         x = "", y = "")

ggsave("graficos/evolucion_diciembre.png", width = 30, height = 18, units = "cm")


## gráfico evolución nacimientos enero
enero <- tidy_data %>% 
    filter(mes=="ene") %>% 
    mutate(mes = month(fecha, label = TRUE, abbr = FALSE))

ggplot(enero,
       aes(x = ano, y = nacidos_mes_pct, color = mes)) + 
    geom_segment(color = "grey10", x = 1972, xend = 2022, y = 0.08333, yend = 0.08333, size = .75) +
    geom_line(size = 1.5) +
    geom_curve(x = 2018.5, xend = 2014.3, y = 0.0861, yend = 0.0888, colour = "grey10") +
    annotate("text", x = 2014, y = 0.089, label = "Desde 2018, cuando empezó a aumentar\nla duración de los permisos de paternidad,\ncada vez se registran más partos en enero", colour = "grey10", hjust = 1, vjust = 1) +
    scale_x_continuous(breaks=c(1975, 1985, 1995, 2005, 2015)) +
    scale_y_continuous(breaks=seq(0.07,0.09,0.005), limits = c(0.0775, 0.09), labels = label_percent(decimal.mark = ",", accuracy = 0.1L)) +
    scale_colour_manual(values = "#2d205d") +
    theme_minimal() +
    theme_minimal() +
    theme(plot.title = element_text(face = "bold", size = 18, color = "grey10"),
          plot.subtitle = element_text(size = 14, color = "grey30"),
          plot.caption = element_text(size = 11, face = "italic", color = "grey30", hjust=c(0, 1)),
          axis.title = element_text(size = 14, color = "grey30"),
          axis.text = element_text(size = 11, color = "grey40"),
          strip.text = element_text(size = 12, face = "bold", color = "grey10"),
          plot.margin = margin(10, 20, 10, 20),
          plot.title.position = "plot",
          plot.caption.position = "plot",
          legend.position = "none",
          legend.title = element_blank(),
          legend.key.width =  unit(5, "lines"),
          panel.grid.major.x = element_blank(),
          panel.grid.minor.x = element_blank(),
          panel.grid.major.y = element_line(size = .5),
          panel.grid.minor.y = element_line(size = .5, linetype = "longdash"),
          axis.ticks = element_blank()) +
    labs(title="Los nacimientos en enero han crecido a raíz del aumento de los permisos de paternidad",
         subtitle="% de nacimientos en enero (1975-2019). La línea negra representa la distribución uniforme (8,333% = 1/12)",
         caption=c("Fuente: Estadística de Nacimientos, INE", "Elaborado por Jesús Escudero (@jescuderoma) | https://filasycolumnas.substack.com/"),
         x = "", y = "")

ggsave("graficos/evolucion_enero.png", width = 30, height = 18, units = "cm")




