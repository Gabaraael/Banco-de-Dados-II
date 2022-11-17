-- 1
select m.nome montadora, to_char(m.data_fundacao, 'DD/MM/YYYY') montadora_fundacao, f.nome funcionario, to_char(f.data_nascimento, 'DD/MM/YYYY') as data_nascimento, to_char(f.data_contratacao, 'DD/MM/YYYY') as data_contratacao from montadora m
join funcionario f ON f.cod_montadora = m.codigo;

-- 2
select f.nome from funcionario f where f.salario =
(select max(f.salario) from funcionario f)

-- 3
select f.nome, m.nome from funcionario f
JOIN montadora m ON m.codigo = f.cod_montadora
WHERE f.salario > (select avg(f.salario) from funcionario f);

-- 4
select to_char(f.data_contratacao, 'DD/MM/YYYY') as data_contratacao from funcionario f
where DATE_PART('day', CURRENT_DATE - f.data_contratacao) > 100

-- 5
select c.nome,  to_char(c.data_fundacao, 'YYYY') as ano_fundacao from concessionaria c
JOIN montadora m ON m.codigo = c.cod_montadora
JOIN veiculo v on v.cod_montadora = m.codigo
where (v.cor::varchar) like 'azul'

-- 6

select distinct(f.nome), to_char(f.data_contratacao, 'DD/MM/YY HH:MI:SS') as data_contratacao from funcionario f
join montadora m on m.codigo = f.cod_montadora
join veiculo v on v.cod_montadora = m.codigo
where f.nome ilike '%a'
AND
length(f.nome) >= 5
AND 
v.valor < (select avg(v.valor) from veiculo v)

-- 7 
select (exists(select * from veiculo where veiculo.nome like 'IFMS99' ));

update categoria set nome = 'SUV'

-- 8
select sum(v.valor) as soma_veiculos from categoria c
join veiculo v on v.cod_categoria = c.codigo
where c.nome in ('SUV', 'Hatch', 'Sedan')