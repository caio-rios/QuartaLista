#Questão 1 - https://github.com/caio-rios/QuartaLista

#Questão 2 Ponto 1 - Use a função read_xlsx do pacote readxl para carregar 
#                    os dados do PNUD

setwd("C:/Users/kibca/Desktop/dados_encontro_2_ufpe")
require(readxl)
pnud <- read_xlsx("atlas2013_dadosbrutos_pt.xlsx", sheet = "MUN 91-00-10")
pnud_pe <- pnud[pnud$UF == "26", ]

#Questão 2 Ponto 2 - Não deve haver docente com mais de 70 anos ou com 
#                    menos de 18 anos

load("docentes_pe_censo_escolar_2016.RData")
