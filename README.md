# Projeto: Data Warehouse e BI — Transações de Cartão de Crédito

  * **Curso:** Análise e Desenvolvimento de Sistemas
  * **Objetivo:** Construir um data warehouse a partir de dados reais de faturas de cartão de crédito, aplicar conceitos de ETL e desenvolver/acoplar ferramentas de análise.

-----

## 1\. Contexto e Objetivos de Aprendizagem

### 1.1 Contexto do negócio (cenário)

Uma instituição financeira disponibilizou **extratos mensais de faturas de cartão de crédito** (dados anonimizados) para que sua área de BI analise padrões de gastos, comportamento por titular/cartão, categorias e evolução no tempo. O time de BI precisa de um **data warehouse** alimentado por um processo **ETL** e de **ferramentas de análise** para apoiar decisões.

### 1.2 Objetivos de aprendizagem

Ao final do projeto, espera-se ser capaz de:

  * **Modelar** um data warehouse (modelo dimensional) a partir de fontes transacionais (CSV).
  * **Implementar** um pipeline ETL (Extract, Transform, Load) com limpeza e padronização de dados.
  * **Carregar** dados em um repositório analítico (ex.: banco relacional ou ferramenta de DW).
  * **Explorar** os dados com consultas analíticas (agregações, séries temporais, comparações).
  * **Desenvolver ou acoplar** ferramentas de análise (relatórios, dashboards, visualizações).

## 2\. Conjunto de Dados (Dataset)

### 2.1 Descrição

  * **Fonte:** 12 arquivos CSV, um por fatura mensal.
  * **Nomenclatura:** `Fatura_AAAA-MM-DD.csv` (ex.: `Fatura_2025-03-20.csv`, `Fatura_2026-02-20.csv`).
  * **Período coberto:** Março de 2025 a Fevereiro de 2026 (ajustar conforme os arquivos que você entregar).
  * **Separador:** ponto e vírgula (;).
  * **Codificação:** UTF-8 (verificar se há acentuação e caracteres especiais).

### 2.2 Estrutura do arquivo (colunas)

| Coluna              | Descrição                         | Exemplo / Observação                  |
| :-----------------: | :-------------------------------: | :-----------------------------------: |
| **Data de Compra**  | Data da transação                 | `DD/MM/AAAA`                          |
| **Nome no Cartão**  | Titular (anonimizado)             | Texto                                 |
| **Final do Cartão** | Últimos 4 dígitos do cartão       | Numérico (identificador do cartão)    |
| **Categoria**       | Categoria MCC da transação        | Ex.: “Restaurante / Lanchonete / Bar” |
| **Descrição**       | Nome do estabelecimento/operador  | Texto, pode ter caracteres especiais  |
| **Parcela**         | Parcelamento                      | “Única”, “1/3”, “2/10”, etc.          |
| **Valor (em US)**   | Valor em dólar (quando aplicável) | Numérico                              |
| **Cotação (em R$)** | Cotação usada na conversão        | Numérico                              |
| **Valor (em R$)**   | Valor em reais (moeda principal)  | Numérico (negativo = estorno/crédito) |

### 2.3 Observações para ETL

  * **Datas:** formato DD/MM/AAAA; padronizar para tipo data no DW.
  * **Valores decimais:** usar vírgula ou ponto conforme locale; padronizar para numérico.
  * **Campos vazios ou “-”:** Categoria e Descrição podem ter valores nulos ou hífens; definir regras de limpeza.
  * **Duplicidade:** uma mesma compra pode aparecer em mais de um registro (ex.: valor em US$ e valor em R$); definir regra (ex.: uma linha por transação lógica).
  * **Consistência:** Nome no Cartão + Final do Cartão formam o “cartão lógico”; manter integridade nas dimensões.

## 3\. Projeto do Data Warehouse

Sugestão de modelo em estrela (*Star Schema*) com **uma fato** e **quatro dimensões**.

### 3.1 Modelo dimensional sugerido (Star Schema)

**Tabela fato: `FATO_TRANSACAO`**

  * `id_data` (FK para `DIM_DATA`)
  * `id_titular` (FK para `DIM_TITULAR`)
  * `id_categoria` (FK para `DIM_CATEGORIA`)
  * `id_estabelecimento` (FK para `DIM_ESTABELECIMENTO`)
  * `valor_brl` (valor em R$)
  * `valor_usd` (valor em US$)
  * `cotacao_brl`
  * `parcela_texto` (ex.: “Única”, “1/3”)
  * `num_parcela` (inteiro, extraído quando “x/y”)
  * `total_parcelas` (inteiro, extraído quando “x/y”)

**Dimensões**

  * **`DIM_DATA`:** `id_data`, `data` (date), `dia`, `mês`, `trimestre`, `ano`, `dia_semana` (ou nome do dia).
  * **`DIM_TITULAR`:** `id_titular`, `nome_titular`, `final_cartao`.
  * **`DIM_CATEGORIA`:** `id_categoria`, `nome_categoria`.
  * **`DIM_ESTABELECIMENTO`:** `id_estabelecimento`, `nome_estabelecimento` (descrição da coluna “Descrição”).

### 3.2 Decisões de modelagem

  * Tratar **cada linha do CSV como um registro de transação** (uma linha = um evento na fato), ou fazer deduplicação (ex.: uma compra com valor em US$ e R$ em duas linhas).
  * **Parcelas:** manter atributos na fato (`num_parcela`, `total_parcelas`) ou criar dimensão de parcelamento.
  * **Estorno/crédito:** `valor_brl` negativo; manter na mesma fato e usar filtros/medidas nas análises.

## 4\. Pipeline ETL

### 4.1 Extract (E)

  * **Entrada:** todos os arquivos `Fatura_*.csv` em um diretório.
  * **Atividade:** ler cada CSV (encoding UTF-8, separador `;`), identificar colunas e carregar em memória ou em tabela *staging*.
  * **Ferramentas possíveis:** Python (pandas/csv), PowerShell, SSIS, Pentaho, scripts SQL (COPY/IMPORT), etc.

### 4.2 Transform (T)

  * **Datas:** converter “DD/MM/AAAA” para tipo date; derivar ano, mês, trimestre, dia da semana.
  * **Valores:** garantir tipo numérico; tratar vírgula/ponto e campos vazios.
  * **Parcela:** quebrar “1/3” em `num_parcela`=1, `total_parcelas`=3; “Única” → 1 e 1 (ou `NULL`).
  * **Chaves substitutas:** gerar IDs para `DIM_DATA`, `DIM_TITULAR`, `DIM_CATEGORIA`, `DIM_ESTABELECIMENTO` (evitar usar texto como PK no DW).
  * **Deduplicação e qualidade:** remover duplicatas (se definido); preencher categoria “-” como “Não categorizado” ou similar.
  * **Regras de negócio:** considerar apenas `valor_brl` para análises em reais; `valor_usd` e `cotação` para análises em dólar.

### 4.3 Load (L)

  * **Destino:** banco de dados (PostgreSQL, MySQL, SQL Server, SQLite) ou ferramenta de DW (ex.: dimensões e fato em tabelas).
  * **Ordem sugerida:** carregar dimensões primeiro (Data, Titular, Categoria, Estabelecimento), depois a fato.
  * **Incremental vs full:** definir se cada execução recarrega tudo (*full*) ou só novos arquivos/novos registros (*incremental*) — para o projeto, *full* é aceitável.

### 4.4 Ferramentas sugeridas (flexível)

  * **Scripts em Python:** pandas + sqlalchemy ou psycopg2 para ETL e carga.
  * **Banco:** PostgreSQL ou SQLite para entrega e portabilidade.
  * **Alternativa low-code:** Pentaho Data Integration (PDI) ou similar para desenhar o ETL.

## 5\. Análise dos Dados e Ferramentas

### 5.1 Perguntas de negócio (exemplos para relatórios/dashboards)

1.  **Gasto total por titular** no período e por mês.
2.  **Gasto por categoria** (top 10 categorias em valor).
3.  **Evolução mensal** do total gasto (série temporal).
4.  **Comparativo entre titulares** (valor médio por transação, quantidade de transações).
5.  **Principais estabelecimentos** por valor (top N).
6.  **Comportamento de parcelamento:** quantidade de compras à vista vs parceladas.
7.  **Dia da semana** com mais transações ou maior volume.
8.  **Estornos e créditos:** total e impacto por titular/categoria.

### 5.2 Ferramentas de análise (escolher ao menos uma)

  * **Desenvolver:** relatórios em SQL + planilhas (Excel/Google Sheets) ou aplicação web simples (ex.: Flask/Streamlit + gráficos).
  * **Acoplar:**
      * Metabase ou Apache Superset (open source) conectados ao DW.
      * Power BI ou Google Data Studio / Looker Studio com conexão ao banco ou CSV processado.
      * Jupyter Notebook com pandas + matplotlib/seaborn/plotly para análises exploratórias e documentadas.
