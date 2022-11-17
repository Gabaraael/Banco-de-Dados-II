
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


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- 1) Crie uma trigger com a seguinte regra: Não é permitido aumento para os salários dos
-- funcionários.

create or replace function ex1()
returns trigger as $$
begin
	if new.salario > old.salario then
		new.salario = old.salario;
	end if;

	return new;
END
$$
language plpgsql;
 

create trigger trigger_01 before update on funcionario
for each row execute procedure ex1();

update funcionario set salario = 1500 where codigo = 1

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 2) Crie uma trigger com a seguinte regra: Ao inserir um veículo, caso o valor do veículo seja maior
-- que o maior valor dos veículos já cadastrados, atualize o valor para 88% do maior valor dos
-- veículos.

create or replace function ex2()
returns trigger as $$
begin  	
	if new.valor > (SELECT max(valor)FROM veiculo) then		
		new.valor = (new.valor*0.88);	 
	end if;  	
	return new;
end
$$
language plpgsql;

create trigger trigger_02 before insert on veiculo
for each row execute procedure ex2();



----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 3) Crie uma trigger com a seguinte regra: Ao excluir uma função, tudo que é vinculado a função deve
-- ser excluído antes.


create or replace function ex3()
		returns trigger as $$
	begin  	
		delete from funcionario where cod_funcao = old.codigo ;
		return old;
	end
	$$
	language plpgsql;


create trigger trigger_03 before delete on funcao
for each row execute procedure ex3();	


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 4) Crie uma trigger com a seguinte regra: Ao excluir uma concessionária, tudo que é vinculado a
-- concessionária deve ser excluído antes.

create or replace function ex4()
		returns trigger as $$
	begin  	
		delete from veiculo_concessionaria where cod_concessionaria = old.codigo ;
		return old;
	end
	$$
	language plpgsql;


create trigger trigger_04 before delete on concessionaria
for each row execute procedure ex4();	

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 5) Crie uma trigger com a seguinte regra: Antes de remover uma categoria, todos os veículos que
-- possuem esta categoria devem ser transferidos para a categoria principal, que é a de nome 'SUV'.

create or replace function ex5()
		returns trigger as $$
	begin  	
		update veiculo set cod_categoria = (select codigo from categoria where nome ilike 'SUV') where cod_categoria = old.codigo;
		return old;
	end
	$$
	language plpgsql;



create trigger trigger_05 before delete on categoria
for each row execute procedure ex5();	


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- 6) Modifique a trigger do exercício número dois para atender a seguinte regra: Ao modificar um
-- veículo (inserir ou atualizar os dados), caso o valor do veículo seja maior que o maior valor dos
-- veículos já cadastrados, atualize o valor para 88% do maior valor dos veículos.

create or replace function ex6()
returns trigger as $$
begin  	
	if new.valor > (SELECT max(valor)FROM veiculo) then		
		new.valor = (new.valor*0.88);	 
	end if;  	
	return new;
end
$$
language plpgsql;


create trigger trigger_02 before insert or update on veiculo
for each row execute procedure ex6();


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 7) Crie uma trigger com a seguinte regra: Concessionárias fundadas antes do ano 2000 não podem
-- ser cadastradas.

create or replace function ex7()
returns trigger as $$
begin  		
	if((TO_CHAR(new.data_fundacao, 'YYYY')::INTEGER) < 2000 ) THEN			 	
	RAISE NOTICE 'Concessionárias fundadas antes do ano 2000 não podem ser cadastradas';
	return null;
	end if;
	return new;
	
end
$$
language plpgsql;

insert into concessionaria(nome, cnpj, data_fundacao, contato, rua, cep, cod_montadora) VALUES
('MEOW2', '14322234332', CURRENT_DATE-30000, '443423212', 'Rua Dinosauria', '23213233312', 1);

create trigger trigger_07 before insert on concessionaria
for each row execute procedure ex7();