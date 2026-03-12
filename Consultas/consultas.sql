--- Gasto total por titular.
select titulares.nome_cartao as titular,
	(
		coalesce(sum(valor_brl) filter (where valor_brl > 0),0)
		+ 
		coalesce(sum(valor_usd * cotacao_brl) filter (where valor_usd > 0), 0)
	)::money as gasto_total_brl
from titulares
inner join transacoes on titulares.id_titular = transacoes.id_titular
group by titulares.nome_cartao;

--- Gasto total por titular por mês.
select titulares.nome_cartao as titular, 
	(
		coalesce(sum(valor_brl) filter (where valor_brl > 0), 0)
		+ 
		coalesce(sum((valor_usd * cotacao_brl)) filter (where valor_usd > 0), 0)
	)::money as gasto_total_brl, 
	datas_compra.mes
from titulares
inner join transacoes on titulares.id_titular = transacoes.id_titular
inner join datas_compra on transacoes.id_data = datas_compra.id_data
group by titulares.nome_cartao, datas_compra.mes
order by datas_compra.mes;

--- Gasto por categoria (TOP 10)
select categorias.nome_categoria, 
	(
		coalesce(sum(valor_brl) filter (where valor_brl > 0), 0)
		+ 
		coalesce(sum(valor_usd * cotacao_brl) filter (where valor_usd > 0), 0)
	)::money as gasto_total_brl
from categorias
inner join transacoes on categorias.id_categoria = transacoes.id_categoria
group by categorias.nome_categoria
order by gasto_total_brl desc
limit 10;

--- Comparativo entre titulares (valor médio por transação, quantidade de transações)
select titulares.nome_cartao as titular, 
	avg(
		coalesce(valor_brl, 0)
		+ 
		coalesce(valor_usd * cotacao_brl, 0)
	) filter (where valor_brl > 0 or valor_usd > 0)
	::money as valor_medio_por_transacao_brl,
	count(transacoes.id_transacao) filter (where valor_brl > 0 or valor_usd > 0) as quantidade_transacoes
from titulares
inner join transacoes on titulares.id_titular = transacoes.id_titular
group by titulares.nome_cartao;

--- Evolução mensal do total gasto (série temporal).
select datas_compra.mes, 
	(
		coalesce(sum(valor_brl) filter (where valor_brl > 0), 0)
		+ 
		coalesce(sum(valor_usd * cotacao_brl) filter (where valor_usd > 0), 0)
	)::money as total_gasto
from transacoes
inner join datas_compra on transacoes.id_data = datas_compra.id_data
group by datas_compra.mes
order by datas_compra.mes;

--- Principais estabelecimentos por valor (top 15)
select estabelecimentos.nome_estabelecimento,
    (
        coalesce(sum(valor_brl) filter (where valor_brl > 0), 0)
        +
        coalesce(sum(valor_usd * cotacao_brl) filter (where valor_usd > 0), 0)
    )::money as gasto_total_brl
from estabelecimentos
join transacoes 
    on estabelecimentos.id_estabelecimento = transacoes.id_estabelecimento
group by estabelecimentos.nome_estabelecimento
order by gasto_total_brl desc
limit 15;

--- Comportamento de parcelamento: quantidade de compras à vista vs parceladas.
select 
	count(total_parcelas) filter (where total_parcelas > 1) as compras_parceladas,
	count(total_parcelas) filter (where total_parcelas = 1) as compras_a_vista
from transacoes;

--- Dia da semana com mais transações ou maior volume.
select count(*) as qtd_transacoes, datas_compra.dia_semana
from transacoes
inner join datas_compra on transacoes.id_data = datas_compra.id_data
group by datas_compra.dia_semana
order by qtd_transacoes desc
limit 1;

--- Estornos e créditos: total e impacto por titular.
select titulares.nome_cartao,
	(
		coalesce(sum(valor_brl) filter (where valor_brl < 0), 0)
		+
		coalesce(sum(valor_usd) filter (where valor_usd < 0), 0)
		)::money as total_estornos
from titulares
inner join transacoes on titulares.id_titular = transacoes.id_titular
group by titulares.nome_cartao;

--- Estornos e créditos: total e impacto por categoria.
select categorias.nome_categoria,
	(
		coalesce(sum(valor_brl) filter (where valor_brl < 0), 0)
		+
		coalesce(sum(valor_usd) filter (where valor_usd < 0), 0)
		)::money as total_estornos
from categorias
inner join transacoes on categorias.id_categoria = transacoes.id_categoria
group by categorias.nome_categoria
order by total_estornos asc;
