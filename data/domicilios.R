library(PNADcIBGE)
library(survey)

baixar_base <- function(ano) {
  nome_objeto <- paste0("dados_", ano)
  dados <- get_pnadc(year = ano, interview = 1, design = FALSE)
  assign(nome_objeto, dados, envir = .GlobalEnv)
  return(invisible(dados))
}

for (ano in 2016:2024){
  baixar_base(ano)
}
