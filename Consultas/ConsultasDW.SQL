--- Gasto total por titular.
select dim_titular.nome_cartao as titular,
	(
		coalesce(sum(valor_brl) filter (where valor_brl > 0),0)
		+ 
		coalesce(sum(valor_usd * cotacao_brl) filter (where valor_usd > 0), 0)
	)::numeric::money as gasto_total_brl
from dim_titular
inner join fato_transacao on dim_titular.id_titular = fato_transacao.id_titular
group by dim_titular.nome_cartao;

--- Gasto total por titular por mês.
select dim_titular.nome_cartao as titular, 
	(
		coalesce(sum(valor_brl) filter (where valor_brl > 0), 0)
		+ 
		coalesce(sum((valor_usd * cotacao_brl)) filter (where valor_usd > 0), 0)
	)::numeric::money as gasto_total_brl, 
	dim_data.mes
from dim_titular
inner join fato_transacao on dim_titular.id_titular = fato_transacao.id_titular
inner join dim_data on fato_transacao.id_data = dim_data.id_data
group by dim_titular.nome_cartao, dim_data.mes
order by dim_data.mes;

--- Gasto por categoria (TOP 10)
select dim_categoria.nome_categoria, 
	(
		coalesce(sum(valor_brl) filter (where valor_brl > 0), 0)
		+ 
		coalesce(sum(valor_usd * cotacao_brl) filter (where valor_usd > 0), 0)
	)::numeric::money as gasto_total_brl
from dim_categoria
inner join fato_transacao on dim_categoria.id_categoria = fato_transacao.id_categoria
group by dim_categoria.nome_categoria
order by gasto_total_brl desc
limit 10;

--- Comparativo entre titulares (valor médio por transação, quantidade de transações)
select dim_titular.nome_cartao as titular, 
	avg(
		coalesce(valor_brl, 0)
		+ 
		coalesce(valor_usd * cotacao_brl, 0)
	) filter (where valor_brl > 0 or valor_usd > 0)::numeric::money as valor_medio_por_transacao_brl,
	count(fato_transacao.id_transacao) as quantidade_transacoes
from dim_titular
inner join fato_transacao on dim_titular.id_titular = fato_transacao.id_titular
group by dim_titular.nome_cartao;

--- Evolução mensal do total gasto (série temporal).
select dim_data.mes, 
	(
		coalesce(sum(valor_brl) filter (where valor_brl > 0), 0)
		+ 
		coalesce(sum(valor_usd * cotacao_brl) filter (where valor_usd > 0), 0)
	)::numeric::money as total_gasto
from fato_transacao
inner join dim_data on fato_transacao.id_data = dim_data.id_data
group by dim_data.mes
order by dim_data.mes;

--- Principais estabelecimentos por valor (top 15)
select dim_estabelecimento.nome_estabelecimento,
    (
        coalesce(sum(valor_brl) filter (where valor_brl > 0), 0)
        +
        coalesce(sum(valor_usd * cotacao_brl) filter (where valor_usd > 0), 0)
    )::numeric::money as gasto_total_brl
from dim_estabelecimento
inner join fato_transacao on dim_estabelecimento.id_estabelecimento = fato_transacao.id_estabelecimento
group by dim_estabelecimento.nome_estabelecimento
order by gasto_total_brl desc
limit 15;

--- Comportamento de parcelamento: quantidade de compras à vista vs parceladas.
select 
	count(total_parcelas) filter (where total_parcelas > 1) as compras_parceladas,
	count(total_parcelas) filter (where total_parcelas = 1) as compras_a_vista
from fato_transacao;

--- Dia da semana com mais transações ou maior volume.
select count(*) as qtd_transacoes, dim_data.dia_semana
from fato_transacao
inner join dim_data on fato_transacao.id_data = dim_data.id_data
group by dim_data.dia_semana
order by qtd_transacoes desc
limit 1;

--- Estornos e créditos: total e impacto por titular.
select dim_titular.nome_cartao,
	(
		coalesce(sum(valor_brl) filter (where valor_brl < 0), 0)
		+
		coalesce(sum(valor_usd) filter (where valor_usd < 0), 0)
		)::numeric::money as total_estornos
from dim_titular
inner join fato_transacao on dim_titular.id_titular = fato_transacao.id_titular
group by dim_titular.nome_cartao;

--- Estornos e créditos: total e impacto por categoria.
select dim_categoria.nome_categoria,
	(
		coalesce(sum(valor_brl) filter (where valor_brl < 0), 0)
		+
		coalesce(sum(valor_usd) filter (where valor_usd < 0), 0)
		)::numeric::money as total_estornos
from dim_categoria
inner join fato_transacao on dim_categoria.id_categoria = fato_transacao.id_categoria
group by dim_categoria.nome_categoria
order by total_estornos asc;
