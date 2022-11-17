-- 1) Crie uma view que tenha como saída o nome das montadoras, data de fundação da montadora, o
-- nome dos veículos produzidos pela montadora, o nome das concessionárias vinculadas a montadora
-- e o tempo de fundação em anos das concessionárias. A data de fundação deve sair no formato DD
-- MMYYYY. Mostre como usar a view.


CREATE VIEW ex1 AS 
SELECT mont.nome as nome_montadora, to_char( mont.Data_fundacao, 'DDMMYYYY') as mont_fundacao, vei.nome as veiculo, 
	con.nome as concessionarias, extract( year from age(con.data_fundacao)) as tempo_fundacao
FROM montadora mont join veiculo vei on mont.codigo = vei.codigo_montadora 
	join concessionaria con on mont.codigo = con.codigo_montadora;

select  from ex1;


-- 2) Crie uma view que tenha como saída o nome das montadoras, tempo de fundação em dias das
-- montadoras, o nome dos seus funcionários nascidos após 1970 e o nome das suas funções. Mostre
-- como usar a view.

create view ex2 as
SELECT mont.nome as nome_montadora, current_date - mont.Data_fundacao as mont_fundacao, fu.nome as funcionario, fun.nome as funcao
from montadora mont join funcionario fu on mont.codigo = fu.codigo_montadora 
	join funcao fun on fun.codigo = fu.codigo_funcao
where extract( year from fu.data_nascimento)  1970;

select  from ex2


-- 3) Crie uma view que tenha como saída Os dados dos funcionários que possuem salário acima da
-- média dos salários dos funcionários que nasceram entre o ano de 1980 e 2000. Mostre como usar a
-- view.

create view ex3 as
select 
from funcionario fu
where fu.salario  (select avg(fu2.salario) from funcionario fu2 where extract( year from fu2.data_nascimento) between 1980 and 2000);

select  from ex3;


-- 4) Crie uma view que tenha como saída A quantidade de funcionários cadastrados por ano e a
-- média salarial destes funcionários. Arredonde a média em duas casas decimais. Ordene pelo ano a
-- saída. Mostre como usar a view.

create view ex4 as
select extract( year from (fun.data_contratacao)) as data_contratacao_ano, round(avg(fun.salario), 2) media_salario, count() as qtd
from funcionario fun
group by extract( year from (fun.data_contratacao))
order by extract( year from (fun.data_contratacao));

select  from ex4;

-- 5) Crie uma view que tenha como saída O nome das concessionárias e dos veículos ativos
-- vendidos por elas. Ordene pelo nome das concessionárias e depois dos veículos. Mostre como usar
-- a view.

create view ex5 as
select con.nome as nome_concessionaria, vei.nome as nome_veiculo
from concessionaria con join concessionaria_veiculo con_vei on con.codigo = con_vei.codigo_concessionaria
	join veiculo vei on vei.codigo = con_vei.codigo_veiculo
where vei.ativo = '1'
order by con.nome, vei.nome; 

select  from ex5;

-- 6) Remova a view criada no exercício dois.

drop view ex2








