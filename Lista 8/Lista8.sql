-- Crie uma função que tenha como saída a quantidade de veículos com valor maior que R$
--  10000,00 . Mostre como utilizar a função.

CREATE OR REPLACE FUNCTION  vecMore1500()
RETURNS bigint AS $$
BEGIN
        RETURN (select count(*) from veiculo v where v.valor > 1500);
END;
$$  LANGUAGE plpgsql

select vecMore1500() as qtdVeiculos

-- Crie uma função que tenha como saída o valor do salário mais alto dos funcionários nascidos em
-- 1970. Mostre como utilizar a função.

CREATE OR REPLACE FUNCTION  salaryBigger()
RETURNS numeric AS $$
BEGIN
        RETURN (select max(salario) from funcionario f
				where TO_CHAR(f.data_nascimento, 'YYYY') like '1970');
END;
$$  LANGUAGE plpgsql

select salarybigger();

-- Crie uma função que tenha como saída a média dos valores dos veículos da categoria SUV.
-- Mostre como utilizar a função.  
  
CREATE OR REPLACE FUNCTION  avgValueBySub()
RETURNS numeric AS $$
BEGIN
        return (select avg(v.valor) from veiculo v 
		join categoria c on c.codigo = v.cod_categoria
		where c.nome like'SUV');
			   
END;
$$  LANGUAGE plpgsql

select avgValueBySub() as "Média dos SUV";

-- Crie uma função que retorne o número de veículos de uma categoria, a partir do nome da
--  categoria (parâmetro de entrada) . Mostre como utilizar a função.

  
CREATE OR REPLACE FUNCTION  vecByCatName(name varchar)
RETURNS bigint AS $$
BEGIN
        return (select count(*) from veiculo v 
		join categoria c on c.codigo = v.cod_categoria
		where c.nome like name);
			   
END;
$$  LANGUAGE plpgsql

SELECT vecByCatName('SUV') as qtdVeiculoPorCategoria

-- Crie uma função que tenha como saída o valor do salário mais alto dos funcionários nascidos em
-- um ano indicado como entrada na função (Parâmetro de entrada) . Mostre como utilizar a função.
  
CREATE OR REPLACE FUNCTION  salaryBiggerByYear(year varchar )
RETURNS numeric AS $$
BEGIN
        return (select max(salario) from funcionario where (TO_CHAR(data_nascimento, 'YYYY') like year));
			   
END;
$$  LANGUAGE plpgsql

select salarybiggerByYear('1940') as "maior salário por nascimento"


-- Crie uma função que tenha como saída a quantidade de concessionárias de uma montadora
-- indicada como entrada da função. Mostre como utilizar a função



CREATE OR REPLACE FUNCTION  concByMont(montName varchar)
RETURNS bigint AS $$
BEGIN
        return (select count(*) from concessionaria c
		join montadora mont on mont.codigo = c.cod_montadora
		where mont.nome ILIKE montName);
END;
$$  LANGUAGE plpgsql

select concByMont('Montadora Triassíco') as "Quantidade de concessionária por montadora"



















