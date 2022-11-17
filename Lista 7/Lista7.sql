CREATE FUNCTION somagato(meow integer, gato integer)
RETURNS integer AS $$
DECLARE saida integer;
BEGIN
        saida = meow + gato;
		
        RETURN saida;
END;
$$  LANGUAGE plpgsql
  
select somagato(2,5)


CREATE OR REPLACE FUNCTION  avgbrabo(meow float, gato float, cachorro float)
RETURNS float AS $$
DECLARE saida float;
BEGIN
        saida = (meow+gato+cachorro)/3;
		
        RETURN saida;
END;
$$  LANGUAGE plpgsql
  
select avgbrabo(0.1,0.2, 0.3)

CREATE OR REPLACE FUNCTION calculaidade(nasc integer)
RETURNS integer AS $$
DECLARE saida integer;
BEGIN
        saida = (extract(year from CURRENT_DATE) - nasc);
		saida = 365*saida;
        RETURN saida;
END;
$$  LANGUAGE plpgsql
  
select calculaidade(2002)