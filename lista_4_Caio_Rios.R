library(magrittr)
library(tidyverse)
options(scipen=999)
library(ggplot2)
#Questão 1 - https://github.com/caio-rios/QuartaLista

#Questão 2 Ponto 1 - Use a função read_xlsx do pacote readxl para carregar 
#                    os dados do PNUD

setwd("C:/Users/kibca/Desktop/dados_encontro_2_ufpe")
require(readxl)
pnud <- read_xlsx("atlas2013_dadosbrutos_pt.xlsx", sheet = "MUN 91-00-10")
pnud_pe <- pnud[pnud$UF == "26", ]
pnud_pe <- pnud_pe[pnud_pe$ANO == "2010", ]

#Questão 2 Ponto 2 - Não deve haver docente com mais de 70 anos ou com 
#                    menos de 18 anos

load("docentes_pe_censo_escolar_2016.RData")
docentes_pe_selecao <- docentes_pe %>% filter(NU_IDADE >= 18, NU_IDADE <= 70)
summary(docentes_pe_selecao$NU_IDADE)

#Questão 2 Ponto 3 - Não deve haver aluno com mais de 25 anos ou com menos 
#                    de 1 ano;

load("matricula_pe_censo_escolar_2016.RData")
matricula_pe_selecao <- matricula_pe %>% filter(NU_IDADE >= 1, NU_IDADE <= 25)
summary(matricula_pe_selecao$NU_IDADE)

#Questão 2 Ponto 4 - Apresente estatísticas descritivas do número de alunos 
#                    por docente nos municípios do Estado

matricula_pe_selecao <- matricula_pe_selecao %>% group_by(ID_TURMA) %>%
  summarise(n_alunos = n())
docentes_turma <- docentes_pe_selecao %>% 
  inner_join(matricula_pe_selecao, by = "ID_TURMA")
summary(docentes_turma$n_alunos)
#Questão 2 Ponto 5 - Apresente o município com maior número de alunos por 
#                    docente e seu IDHM

pnud_idhm <- pnud_pe[ , c("Codmun7", "Município", "IDHM")]
pnud_idhm <- rename(pnud_idhm, CO_MUNICIPIO = 'Codmun7')
str(pnud_idhm)
docentes_turma <- docentes_turma %>%
  inner_join(pnud_idhm, by = "CO_MUNICIPIO")
docentes_turma <- docentes_turma %>% arrange(desc(n_alunos))
print(head(docentes_turma[ , c("Município", "n_alunos", "IDHM")]))
municipio_turma <- docentes_turma %>% group_by(Município, IDHM) %>%
  summarise(mean_alunos = mean(n_alunos))
municipio_turma <- municipio_turma %>% arrange(desc(mean_alunos))
print(head(municipio_turma))

#Resposta ao Ponto 5: O município com maior média de alunos por docente é
#                     Tupanatinga (37,7) e seu IDHM é 0,519. Porém o registro
#                     de maior turma por professor (964 alunos) é de Recife com 
#                     IDH de 0,772

#Questão 2 Ponto 6: Faça o teste do coeﬁciente de correlação linear de pearson e 
#                   apresente sua resposta

#Com número de alunos absolutos
cor.test(docentes_turma$n_alunos, docentes_turma$IDHM, method = "pearson")
#Com a média de alunos por docente por munícipio
cor.test(municipio_turma$mean_alunos, municipio_turma$IDHM, method = "pearson")

#Resposta ao Ponto 6: Coeficiente de Correlação do número absoluto de alunos 
#                     por docente foi -0,019 com p-valor < 0,000.
#                     Coeficiente de Correlação da média de alunos por docente
#                     por município foi de -0,321 com p-valor < 0,000.

#Questão 2 Ponto 7: Seu script deve salvar a base de dados criada para o cálculo 
#                   em formato .RData

setwd("C:/Users/kibca/Desktop/dados_encontro_2_ufpe/QuartaLista")
save(docentes_turma, file = "docentes_turma.RData")
save(municipio_turma, file = "municipio_turma.RData")

#Questão 3: Usando o pacote ggplot2, apresente o gráﬁco de dispersão entre as 
#           duas variáveis (número de alunos por docente e IDHM).


#Utilizando número absoluto de alunos por docente
plot <- ggplot(docentes_turma, aes(x = IDHM, y = n_alunos)) +
  geom_point()
plot
ggsave("IDHMxAlunos.png")

#Utilizando média do número de alunos por docente por município
plot2 <- ggplot(municipio_turma, aes(x = IDHM, y = mean_alunos)) +
  geom_point()
plot2
ggsave("IDHMxAlunos(média).png")
