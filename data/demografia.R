basedosdados::set_billing_id("rapid-pact-400813")

query <- "
WITH 
dicionario_V1022 AS (
    SELECT
        chave AS chave_V1022,
        valor AS descricao_V1022
    FROM `basedosdados.br_ibge_pnadc.dicionario`
    WHERE
        TRUE
        AND nome_coluna = 'V1022'
        AND id_tabela = 'microdados'
),
dicionario_V2007 AS (
    SELECT
        chave AS chave_V2007,
        valor AS descricao_V2007
    FROM `basedosdados.br_ibge_pnadc.dicionario`
    WHERE
        TRUE
        AND nome_coluna = 'V2007'
        AND id_tabela = 'microdados'
),
dicionario_V2010 AS (
    SELECT
        chave AS chave_V2010,
        valor AS descricao_V2010
    FROM `basedosdados.br_ibge_pnadc.dicionario`
    WHERE
        TRUE
        AND nome_coluna = 'V2010'
        AND id_tabela = 'microdados'
)
SELECT 
    dados.ano,
    dados.trimestre,
    dados.sigla_uf,
    descricao_V1022 AS situacao_domicilio,
    descricao_V2007 AS sexo,
    dados.V2009 AS idade,
    descricao_V2010 AS cor_raca,
    SUM(dados.V1027) AS populacao_total
FROM `basedosdados.br_ibge_pnadc.microdados` AS dados
LEFT JOIN dicionario_V1022
    ON dados.V1022 = chave_V1022
LEFT JOIN dicionario_V2007
    ON dados.V2007 = chave_V2007
LEFT JOIN dicionario_V2010
    ON dados.V2010 = chave_V2010
WHERE dados.trimestre = 1
GROUP BY 
    dados.ano,
    dados.trimestre,
    dados.sigla_uf,
    situacao_domicilio,
    sexo,
    idade,
    cor_raca
ORDER BY 
    dados.ano,
    dados.trimestre,
    dados.sigla_uf,
    populacao_total DESC
"

demog <- basedosdados::read_sql(query, billing_project_id = get_billing_id())

library(dplyr)
library(lubridate)

demog <- demog |> 
  dplyr::mutate(
    ano = case_when(
      trimestre == 1 ~ lubridate::make_date(ano, 3, 31),   # 31/Mar
      trimestre == 2 ~ lubridate::make_date(ano, 6, 30),   # 30/Jun
      trimestre == 3 ~ lubridate::make_date(ano, 9, 30),   # 30/Set
      trimestre == 4 ~ lubridate::make_date(ano, 12, 31)   # 31/Dez
    )
  ) |> 
  dplyr::mutate(
    across(
      c(sigla_uf, situacao_domicilio, sexo, cor_raca),
      as.factor
    )
  )

saveRDS(demog, "data/demografia.RDS")

