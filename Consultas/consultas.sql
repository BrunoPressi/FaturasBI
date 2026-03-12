--- Gasto total por titular
select titulares.nome_cartao as titular, 
		round(sum(transacoes.valor_brl), 2) + round(sum(transacoes.valor_usd * cotacao_brl), 2) as gasto_total_brl
from titulares
inner join transacoes on titulares.id_titular = transacoes.id_titular
where transacoes.valor_brl > 0 or transacoes.valor_usd > 0
group by titulares.nome_cartao;

--- Gasto total por titular por mês
select titulares.nome_cartao as titular, 
		round(sum(transacoes.valor_brl), 2) + round(sum(transacoes.valor_usd * cotacao_brl), 2) as gasto_total_brl, datas_compra.mes
from titulares
inner join transacoes on titulares.id_titular = transacoes.id_titular
inner join datas_compra on transacoes.id_data = datas_compra.id_data
where transacoes.valor_brl > 0 or transacoes.valor_usd > 0
group by titulares.nome_cartao, datas_compra.mes
order by datas_compra.mes;

--- Gasto por categoria (TOP 10)
select categorias.nome_categoria, 
		round(sum(transacoes.valor_brl), 2) + round(sum(transacoes.valor_usd * cotacao_brl), 2) as gasto_total_brl
from categorias
inner join transacoes on categorias.id_categoria = transacoes.id_categoria
where transacoes.valor_brl > 0 or transacoes.valor_usd > 0
group by categorias.nome_categoria
order by gasto_total_brl desc
limit 10;

--- Comparativo entre titulares (valor médio por transação, quantidade de transações)
select titulares.nome_cartao as titular, 
		round(avg(transacoes.valor_brl), 2) + round(avg(transacoes.valor_usd * cotacao_brl), 2) as valor_gasto_por_transacao_brl,
		count(transacoes) as quantidade_transacoes
from titulares
inner join transacoes on titulares.id_titular = transacoes.id_titular
where transacoes.valor_brl > 0 or transacoes.valor_usd > 0
group by titulares.nome_cartao;

--- Principais estabelecimentos por valor (top 15)
select estabelecimentos.nome_estabelecimento, 
		round(sum(transacoes.valor_brl), 2) + round(sum(transacoes.valor_usd * cotacao_brl), 2) as gasto_total_brl
from estabelecimentos
inner join transacoes on estabelecimentos.id_estabelecimento = transacoes.id_estabelecimento
where transacoes.valor_brl > 0 or transacoes.valor_usd > 0
group by estabelecimentos.nome_estabelecimento
order by gasto_total_brl desc
limit 15;
















