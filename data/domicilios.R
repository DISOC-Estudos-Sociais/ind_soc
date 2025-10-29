library(PNADcIBGE)
library(survey)
library(dplyr)
library(purrr)

# Função atualizada para baixar e processar
baixar_base <- function(ano) {
  dados <- get_pnadc(year = ano, interview = 1, design = FALSE)
  
  # Selecionar colunas e adicionar ano
  dados_processados <- dados %>%
    select(Ano, UF, Capital, RM_RIDE, V1022, V1023, V1031, starts_with("S01"))
  
  return(dados_processados)
}

# Aplicar a função para todos os anos e concatenar
painel_completo <- 2016:2024 %>%
  map_df(baixar_base)

# Visualizar resultado
cat("Dimensões do painel final:", nrow(painel_completo), "linhas x", ncol(painel_completo), "colunas\n")
head(painel_completo)