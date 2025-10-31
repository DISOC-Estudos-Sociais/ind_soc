library(PNADcIBGE)
library(survey)
library(dplyr)
library(purrr)

# Função atualizada para baixar e processar
baixar_base <- function(ano, variaveis) {
  dados <- get_pnadc(year = ano, vars = variaveis, interview = 1, design = FALSE)
  return(dados)
}

# Seleciona variáveis
variaveis_selecionadas <- c("S01001", "S01002", "S01003", "S01004", "S01005", "S01006",
                            "S01007", "S01007A", "S01008", "S01009", "S01010", "S01011A",
                            "S01011B", "S01011C", "S01012A", "S01013", "S01014", "S010141",
                            "S010142", "S01015", "S01016A", "S01016A1", "S01016A2", "S01016A3",
                            "S01016A4", "S01016A5", "S01016B", "S01017", "S01018", "S01019",
                            "S01020", "S01020A", "S01021", "S01022", "S01023", "S01024",
                            "S01025", "S01026", "S01027", "S01028", "S01029", "S01030",
                            "S010301", "S010302", "S010303", "S010304", "S010305", "S01031",
                            "S010311", "S010312")

# Aplicar a função para todos os anos e concatenar
painel_completo <- 2016:2024 %>%
  map_df(~baixar_base(.x, variaveis_selecionadas))

saveRDS(painel_completo, "data/domicilios.RDS")
