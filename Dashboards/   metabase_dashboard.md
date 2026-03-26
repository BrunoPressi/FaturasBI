# 📊 Dashboard de Análise de Faturas de Cartão de Crédito

Dashboard e gráficos desenvolvidos utilizando **Metabase** para análise de dados de transações de cartão de crédito.

O dashboard foi organizado em **três seções principais**, cada uma focada em um tipo de análise.

---

# 📌 Parte 1 — Análise Geral de Gastos

Esta seção apresenta **4 visualizações principais** relacionadas ao comportamento geral de gastos dos titulares.

### Gráficos

* 📊 **Comparativo entre titulares**

  * Tipo: **Gráfico de barra vertical**
  * Métricas analisadas:

    * Valor médio por transação
    * Quantidade de transações por titular

* 📊 **Gastos totais por titular**

  * Tipo: **Gráfico de barra vertical**
  * Permite **filtrar por categoria de gasto** individualmente.

* 📊 **Gastos por categoria (Top 10)**

  * Tipo: **Gráfico de barra horizontal**
  * Mostra as **10 categorias com maior volume de gastos**.

* 📊 **Gastos por estabelecimento (Top 15)**

  * Tipo: **Gráfico de barra horizontal**
  * Apresenta os **15 estabelecimentos/lojas com maior volume de gastos**.

---

# 📈 Parte 2 — Análise Temporal

Esta seção apresenta **3 gráficos focados na evolução dos gastos ao longo do tempo**.

### Gráficos

* 📈 **Evolução temporal do total gasto**

  * Tipo: **Gráfico de linha**
  * Permite agrupar o período por:

    * Dia
    * Semana
    * Trimestre
    * Ano
    * Dia da semana
    * Dia do mês

* 📈 **Gasto total por titular ao longo do tempo**

  * Tipo: **Gráfico de linha**
  * Possui filtros para:

    * Período (dia, semana, trimestre, ano, etc.)
    * Um ou mais **titulares específicos**

* 📈 **Número de transações por dia da semana**

  * Tipo: **Gráfico de linha**
  * Ordenado corretamente pela sequência:

  `Seg → Ter → Qua → Qui → Sex → Sáb → Dom`

---

# 🔁 Parte 3 — Análise de Estornos e Parcelamentos

Esta seção analisa **comportamentos financeiros específicos**, como estornos e parcelamentos.

### Gráficos

* 🔄 **Estornos: total e impacto por categoria**

  * Tipo: **Gráfico de barra vertical inversa**

* 🔄 **Estornos: total e impacto por titular**

  * Tipo: **Gráfico de barra vertical inversa**

* 💳 **Comportamento de parcelamento**

  * Tipo: **Gráfico de barra vertical**
  * Comparação entre:

    * Compras **à vista**
    * Compras **parceladas**

---
