
# Análise de Dados da Netflix usando SQL

![Logo da Netflix](https://upload.wikimedia.org/wikipedia/commons/0/08/Netflix_2015_logo.svg)

## Visão Geral
Este projeto envolve uma análise exploratória de dados do catálogo da Netflix utilizando **PostgreSQL**. O objetivo é extrair insights sobre tipos de conteúdo, distribuições geográficas, tendências temporais e classificações, respondendo a 15 perguntas estratégicas de negócio (DQL).

## Dataset
Os dados utilizados neste projeto foram extraídos do Kaggle (https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download). O dataset contém informações sobre:
- **v_id_netflix**: ID único do título.
- **v_tipo_netflix**: Categoria (Filme ou TV Show).
- **v_titulo_netflix**: Nome da obra.
- **v_diretor_netflix**: Diretor(es).
- **v_elenco_netflix**: Atores principais.
- **v_pais_netflix**: País de produção.
- **v_dataadd_netflix**: Data de adição à plataforma.
- **v_anoLanc_netflix**: Ano original de lançamento.
- **v_avaliacao_netflix**: Classificação indicativa (Rating).
- **v_duracao_netflix**: Duração em minutos ou temporadas.
- **v_genero_netflix**: Categorias/Gêneros.
- **v_descricao_netflix**: Sinopse do conteúdo.

## Perguntas de Negócio Resolvidas (15 Desafios de DQL)

1. **Contagem de Conteúdo:** Quantidade de Filmes vs. Shows de TV.
2. **Classificação Comum:** A classificação (rating) mais frequente para cada tipo de conteúdo.
3. **Lançamentos por Ano:** Lista de filmes lançados em um ano específico (ex: 2020).
4. **Top Países:** Os 5 países com maior volume de títulos.
5. **Maior Duração:** Identificação do filme mais longo do catálogo.
6. **Conteúdo Recente:** Títulos adicionados nos últimos 5 anos.
7. **Busca por Diretor:** Filmes e séries dirigidos por diretores específicos (ex: 'Rajiv Chilaka').
8. **Séries Longas:** Listagem de TV Shows com mais de 5 temporadas.
9. **Contagem por Gênero:** Distribuição de títulos por categoria/gênero.
10. **Análise Índia:** Média de lançamentos anuais na Índia e o Top 5 anos de destaque.
11. **Documentários:** Listagem de todos os filmes do gênero 'Documentaries'.
12. **Dados Ausentes:** Identificação de conteúdos sem diretor listado.
13. **Ator Específico:** Contagem de participações de um ator (ex: 'Salman Khan') nos últimos 10 anos.
14. **Estrelas da Índia:** Top 10 atores com mais participações em produções indianas.
15. **Categorização de Conteúdo:** Rotulagem entre 'Good Content' e 'Bad Content' baseada em palavras-chave na descrição.

## Ferramentas e Conceitos Utilizados
- **Banco de Dados:** PostgreSQL.
- **Manipulação de Strings:** `SPLIT_PART`, `TRIM`, `STRING_TO_ARRAY`.
- **Funções de Agregação:** `COUNT`, `ROUND`, `GROUP BY`.
- **Lógica de Expansão:** `UNNEST` para tratar colunas com múltiplos valores.
- **Datas:** `TO_DATE`, `CURRENT_DATE`, `INTERVAL` e `EXTRACT`.
- **Condicionais:** `CASE WHEN` para criação de novas categorias.

## Como Executar
1. Clone este repositório.
2. Importe o arquivo CSV para sua instância do PostgreSQL.
3. Execute o script `schema.sql` para criar a estrutura das tabelas.
4. Execute o script `solutions.sql` para visualizar as análises.
