CREATE TYPE cor AS ENUM ('rosa', 'verde', 'branco', 'preto', 'sexta');


create table categoria(
codigo SERIAL PRIMARY KEY,
nome VARCHAR NOT NULL
);
create table funcao(
codigo SERIAL PRIMARY KEY,
nome VARCHAR NOT NULL,
descricao VARCHAR NOT NULL
);

create table montadora(
codigo SERIAL PRIMARY KEY,
nome VARCHAR NOT NULL,
cnpj VARCHAR NOT NULL UNIQUE,
data_fundacao DATE NOT NULL
);

create table veiculo(
codigo SERIAL PRIMARY KEY,
nome VARCHAR NOT NULL,
cor cor NOT NULL,
ano int,
ativo BOOLEAN,
valor NUMERIC,
cod_categoria int REFERENCES categoria(codigo),
cod_montadora int REFERENCES montadora(codigo)
);

create table concessionaria(
codigo SERIAL PRIMARY KEY NOT NULL,
data_fundacao DATE,
contato VARCHAR NOT NULL,
cnpj VARCHAR NOT NULL UNIQUE,
nome VARCHAR NOT NULL,
cep VARCHAR NOT NULL,
rua VARCHAR NOT NULL,
cod_montadora int REFERENCES montadora(codigo)
);

create table funcionario(
codigo SERIAL PRIMARY KEY,
nome VARCHAR NOT NULL,
cpf VARCHAR NOT NULL UNIQUE,
ativo BOOLEAN,
tel VARCHAR NOT NULL,
salario NUMERIC,
data_nascimento DATE,
data_contratacao timestamp,
cod_funcao int REFERENCES funcao(codigo),
cod_montadora int REFERENCES funcao(codigo)
);

create table veiculo_concessionaria(
cod_veiculo int REFERENCES veiculo(codigo),
cod_concessionaria int REFERENCES concessionaria(codigo)
);


insert into funcao (codigo, nome, descricao) values
(1, 'Jorge', 'Mecânico');
insert into funcao (codigo, nome, descricao) values
(2, 'Malchior', 'Açougueiro');
insert into funcao (codigo, nome, descricao) values
(3, 'Pedro', 'Domador');

insert into categoria(codigo, nome) values (1,'Pré-histórico');
insert into categoria(codigo, nome) values (2,'Medieval');
insert into categoria(codigo, nome) values (3,'Paleozóico');

insert into montadora (codigo, nome, cnpj, data_fundacao) VALUES (1, 'Montadora Triassíco', '000000001', CURRENT_DATE-300000);
insert into montadora (codigo, nome, cnpj, data_fundacao) VALUES (2, 'Montadora Jurassíco', '000000002', CURRENT_DATE-300000);
insert into montadora (codigo, nome, cnpj, data_fundacao) VALUES (3, 'Montadora Cretáceo', '000000003', CURRENT_DATE-300000);

insert into concessionaria(codigo, nome, cnpj, data_fundacao, contato, rua, cep, cod_montadora) VALUES
(1, 'Concessionaria Triássico', '00000001', CURRENT_DATE-3000, '67992000', 'Rua Dinosauria', '00000001', 1);

insert into concessionaria(codigo, nome, cnpj, data_fundacao, contato, rua, cep, cod_montadora) VALUES
(2, 'Concessionaria Jurassíco', '00000002', CURRENT_DATE-4000, '67993000', 'Rua Dinosauria 2', '00000002', 2);

insert into concessionaria(codigo, nome, cnpj, data_fundacao, contato, rua, cep, cod_montadora) VALUES
(3, 'Concessionaria Cretáceo', '00000003', CURRENT_DATE-5000, '67994000', 'Rua Dinosauria 3', '00000003', 3);

insert into veiculo(codigo, nome, cor, ano, valor, ativo, cod_montadora, cod_categoria) values
(1, 'Carro do Triassíco', 'rosa', '1997', 10, TRUE, 1, 1);

insert into veiculo(codigo, nome, cor, ano, valor, ativo, cod_montadora, cod_categoria) values
(2, 'Carro do Jurassíco', 'branco', '1995', 15, TRUE, 2, 2);

insert into veiculo(codigo, nome, cor, ano, valor, ativo, cod_montadora, cod_categoria) values
(3, 'Carro do Cretáceo', 'verde', '1996', 20, TRUE, 3, 3);

insert into veiculo_concessionaria(cod_concessionaria, cod_veiculo) VALUES (1, 1);
insert into veiculo_concessionaria(cod_concessionaria, cod_veiculo) VALUES (2, 2);
insert into veiculo_concessionaria(cod_concessionaria, cod_veiculo) VALUES (3, 3);

INSERT INTO funcionario(codigo, nome, cpf, data_nascimento, data_contratacao, salario, tel, ativo, cod_funcao,
cod_montadora) VALUES (1, 'Funcionario do Triássico', '00000001', CURRENT_DATE-30000, CURRENT_DATE, '1000', '670000', TRUE, 1, 1);

INSERT INTO funcionario(codigo, nome, cpf, data_nascimento, data_contratacao, salario, tel, ativo, cod_funcao,
cod_montadora) VALUES (2, 'Funcionario do Jurássico', '00000002', CURRENT_DATE-30000, CURRENT_DATE, '1500', '640000', TRUE, 2, 2);

INSERT INTO funcionario(codigo, nome, cpf, data_nascimento, data_contratacao, salario, tel, ativo, cod_funcao,
cod_montadora) VALUES (3, 'Funcionario do Cretáceo', '00000003', CURRENT_DATE-30000, CURRENT_DATE, '2000', '650000', TRUE, 3,3 );


1) Crie uma função que retorne os seguintes dados: nome dos veículos, valor, nome da montadora e
o tempo de fundação em anos da montadora. Atenção, a sua função deve receber o nome da
categoria do veículo como parâmetro e deve apresentar na saída somente dados referentes a esta
categoria. Mostre como utilizar a função. Para implementar a função deste exercício é necessário
estudar o comando: create type. Mostre como utilizar a função.

create type tipo1 as (nome_vei varchar, valor numeric, nome_mont varchar, tempo double precision);

create or replace function ex1(nome_categoria varchar)
returns setof tipo1 as $$
declare
	saida tipo1;
begin
	for saida in select vei.nome, vei.valor, mont.nome, 
			extract (year from age(mont.data_fundacao))
				from veiculo vei
				join montadora mont on mont.codigo = vei.cod_montadora
				join categoria cat on cat.codigo = vei.cod_categoria
				where cat.nome ilike nome_categoria
		loop	
		return next saida;	
	end loop;	
end;
$$ language plpgsql;

select * from ex1('Medieval');


2 ) Crie uma função que retorne os seguintes dados: nome dos veículos, valor, nome da montadora e
o tempo de fundação em anos da montadora. Atenção, a sua função deve receber o nome da
categoria do veículo como parâmetro e deve apresentar na saída somente dados referentes a esta
categoria. Mostre como utilizar a função. Para implementar a função deste exercício é necessário
estudar o comando: setof record . Mostre como utilizar a função.

create or replace function ex2(nome_categoria varchar)
returns setof record as $$
declare
	saida record;
begin

	for saida in select vei.nome, vei.valor, mont.nome, 
			extract (year from age(mont.data_fundacao))
				from veiculo vei
				join montadora mont on mont.codigo = vei.cod_montadora
				join categoria cat on cat.codigo = vei.cod_categoria
				where cat.nome ilike nome_categoria
		loop	
		return next saida;	
	end loop;	
end;
$$ language plpgsql;

select * from ex2('medieval') as (nome_vei varchar, valor numeric, nome_mont varchar, tempo double precision);

3) Crie uma função que retorne os seguintes dados: o nome das montadoras e a média dos salários
dos seus funcionários. Mostre como utilizar a função. Para implementar a função deste exercício é
necessário estudar os comandos: setof record ou create type. Mostre como utilizar a função.

create or replace function ex3()
returns setof record as $$
declare
	saida record;
begin
	for saida in select m.nome, avg(f.salario) from montadora m 
join funcionario f on f.cod_montadora = m.codigo
group by m.nome
		loop	
		return next saida;	
	end loop;	
end;
$$ language plpgsql;

select * from ex3() as (meow varchar, meow2 numeric);

4) Crie uma função que retorne os seguintes dados: nome dos funcionários, sua data de nascimento,
data de contratação, o nome das montadoras que cada funcionário trabalha, a data de fundação e o
nome da função que o funcionário possui. Atenção, a sua função deve receber como entrada um
inteiro referente ao ano de contratação dos funcionários e apresentar os funcionários contratados
somente após este ano. Para implementar a função deste exercício é necessário estudar os
comandos: setof record ou create type. Mostre como utilizar a função.



create or replace function ex4(meow int)
returns setof record as $$
declare
	saida record;
begin
	for saida in select f.nome, f.data_nascimento, f.data_contratacao, m.nome, m.data_fundacao, fu.nome from montadora m 
join funcionario f on f.cod_montadora = m.codigo
join funcao fu on fu.codigo = f.cod_funcao
where to_char(f.data_contratacao, 'YYYY')::INTEGER > meow
		loop	
		return next saida;	
	end loop;	
end;
$$ language plpgsql;

select * from ex4(10) as (meow varchar, meow2 date, meow3 timestamp, meow4 varchar, meow5 date, meow6 varchar);

5) Considere que as funções de agregação não existem na sua versão do SGBD, ou seja, não
é permitido a sua utilização. Crie uma função que retorne a quantidade de veículos e o valor médio
dos veículos. Mostre como utilizar a função

create or replace function ex5()
returns record as $$
declare	
	meow veiculo;
	cont int;
	media numeric;
begin
	cont = 0;
	media = 0;
	for meow in select * from veiculo
		loop	
		cont = cont+1;
		media = (media+meow.valor);		
	end loop;		
	return (cont, trunc(media/cont));
end;
$$ language plpgsql;

select * from ex5() as (qtdVec int, media numeric)













