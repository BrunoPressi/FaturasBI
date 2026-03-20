create table dim_titular(
	id_titular bigint primary key,
	nome_cartao text not null,
	final_cartao text not null
);

create table dim_categoria(
	id_categoria bigint primary key,
	nome_categoria text not null
);

create table dim_estabelecimento(
	id_estabelecimento bigint primary key,
	nome_estabelecimento text not null
);

create table dim_data(
	id_data bigint primary key,
	data date not null,
	dia int not null,
	mes int not null,
	trimestre int not null,
	ano int not null,
	dia_semana text not null
);

create table fato_transacao(
	id_transacao bigint primary key,
	valor_brl decimal(10,2) not null,
	valor_usd decimal(10,2) not null,
	cotacao_brl decimal(10,2) not null,
	num_parcela int not null,
	total_parcelas int not null,
	parcela_texto text not null,
	id_titular bigint,
	id_data bigint,
	id_categoria bigint,
	id_estabelecimento bigint,
	foreign key (id_titular) references dim_titular(id_titular),
	foreign key (id_data) references dim_data(id_data),
	foreign key (id_categoria) references dim_categoria(id_categoria),
	foreign key (id_estabelecimento) references dim_estabelecimento(id_estabelecimento)
);
