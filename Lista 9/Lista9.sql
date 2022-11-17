-- 1) Crie uma função que retorne os dados dos funcionários (todos os dados da tabela funcionario ).
--  Mostre como utilizar a função.

create or replace function allEmploye()
returns setof funcionario as $$
declare
	saida funcionario%rowtype;
begin	
	for saida in select * from funcionario func 
		loop
		return next saida;
	end loop;		
end;
$$ language plpgsql;

select * from allEmploye();























