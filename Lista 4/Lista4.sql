Pô, me disseram que era até segunda... hoje ainda é segunda (carinha triste)

-- 1
select c.nome as categoria, AVG(v.valor) as media from veiculo v
JOIN categoria c ON c.codigo = v.cod_categoria
GROUP BY c.nome


-- 2
select count(*) as qtdVeiculos, m.nome as montadora from veiculo v
JOIN montadora m ON m.codigo = v.cod_montadora
GROUP BY m.nome
HAVING count(*) > 1

-- 3
SELECT * FROM (
select min(f.salario) from funcionario f
JOIN funcao fu ON fu.codigo = f.cod_funcao
GROUP BY fu.descricao) as salario ORDER BY salario desc

-- 4

select sum(v.valor) as valorTotal from veiculo v
JOIN concessionaria c ON c.codigo = v.codigo
GROUP BY c

-- 5

select * from veiculo v
JOIN categoria c ON c.codigo = v.cod_categoria
JOIN montadora m ON m.codigo = v.cod_montadora
JOIN funcionario f ON m.codigo = f.cod_montadora
WHERE c.nome like 'Medieval'
AND
m.nome ~ 'u'
AND
LENGTH(m.nome) > 4
AND
f.nome = 'Tonho'

-- 6

select v.nome from veiculo v
where (select min(v.valor) from veiculo v) = v.valor

-- 7
select * from funcionario f where (SELECT date_part('year', f.data_contratacao)) = (SELECT date_part('year', now()))

-- 8
select * from funcionario f where f.salario = (select max(f.salario) from funcionario f);

-- 9
select m.nome as montadora, f.nome as funcionario from funcionario f
JOIN montadora m ON m.codigo = f.cod_montadora
ORDER BY m.nome asc, f.nome desc