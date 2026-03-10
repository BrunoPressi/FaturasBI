create table titulares (
	id_titular integer primary key,
	nome_cartao text,
	final_cartao decimal(4,0)
);

create table categorias (
	id_categoria integer primary key,
	nome_categoria text
);

create table datas_compra (
	id_data integer primary key,
	data_completa date,
	dia decimal (2,0),
	mes decimal (2,0),
	ano decimal (4,0),
	dia_semana int,
	trimestre int
);

create table transacoes (
	id_transacao integer primary key,
	id_titular int,
	id_data int,
	id_categoria int,
	valor_brl numeric(10,2),
	valor_usd numeric(10,2),
	cotacao_brl numeric(10,2),
	parcela_texto text,
	num_parcela int,
	total_parcelas int,
	foreign key (id_titular) references titulares(id_titular),
	foreign key (id_data) references datas_compra(id_data),
	foreign key (id_categoria) references categorias(id_categoria)
);
