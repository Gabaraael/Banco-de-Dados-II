-- 1
SELECT mo.nome as Montadora, v.nome as veiculo from veiculo v
	INNER JOIN montadora mo on mo.codigo = v.cod_montadora;
	
-- 2
select mo.nome as Montadora, v.nome as Veiculo, c.nome as Concessionaria from veiculo v
	INNER JOIN montadora mo on mo.codigo = v.cod_montadora
	inner JOIN concessionaria c on c.cod_montadora = mo.codigo
	where v.valor > 50000 and v.valor < 199999;

-- 3
SELECT COALESCE(mo.nome, 'Independente') as Montadora, c.nome as Concessionaria from montadora mo
	RIGHT JOIN concessionaria c on c.cod_montadora = mo.codigo;
	
-- 4
SELECT COALESCE(mo.nome, 'Independente') as Montadora, COALESCE(c.nome , 'Venda Direta') as Concessionaria from montadora mo
	FULL JOIN concessionaria c on c.cod_montadora = mo.codigo;

-- 5
SELECT f.nome as funcionario, fn.descricao as funcao, mo.nome as montadora FROM funcionario f
	JOIN montadora mo ON mo.codigo = f.cod_montadora
	JOIN funcao fn ON  fn.codigo = f.cod_funcao
	ORDER BY f.nome
	LIMIT 3 OFFSET 1
	
-- 6
SELECT v.nome as veiculo, c.nome as categoria, mo.nome as montadora FROM veiculo v
	JOIN categoria c ON c.codigo = v.cod_categoria
	JOIN montadora mo ON mo.codigo = v.cod_montadora
	WHERE v.ativo = true and v.valor > 100000
	AND v.ano > 2018
	AND v.cor = 'azul'
