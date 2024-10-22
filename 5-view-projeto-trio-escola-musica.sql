-- View 1 - vw_musicos_ativos
create view vw_musicos_ativos as
select mus.nome as "Nome do Músico", mus.cpf as "CPF do Músico", mus.nacionalidade as "Nacionalidade", 
    count(des.Sinfonia_idSinfonia) as "Quantidade de Sinfonias" 
	from Musico mus 
		left join Desempenha des on mus.cpf = des.Musico_cpf 
			group by mus.cpf, mus.nome, mus.nacionalidade 
				order by count(des.Sinfonia_idSinfonia) desc;

-- View 2 - vw_sinfonias_populares
create view vw_sinfonias_populares as
select sin.nome as "Nome da Sinfonia", sin.compositor as "Compositor", 
    count(ors.Orquestra_idOrquestra) as "Quantidade de Orquestras" 
	from Sinfonia sin 
		left join OrquestraSinfonia ors on sin.idSinfonia = ors.Sinfonia_idSinfonia 
			group by sin.idSinfonia, sin.nome, sin.compositor 
				order by count(ors.Orquestra_idOrquestra) desc;
                
-- View 3 - vw_media_idade_orquestra
create view vw_media_idade_orquestra as
select orq.nome as "Nome da Orquestra", orq.pais as "País da Orquestra", 
    format(avg(timestampdiff(year, mus.dataNasc, curdate())), 1, 'de_DE') as "Média de Idade" 
	from Orquestra orq 
		join Musico mus on orq.idOrquestra = mus.Orquestra_idOrquestra 
			group by orq.idOrquestra, orq.nome, orq.pais 
				order by avg(timestampdiff(year, mus.dataNasc, curdate())) desc;

-- View 4 - vw_musicos_instrumento
create view vw_musicos_instrumento as
select ins.nome as "Nome do Instrumento", ins.tipo as "Tipo do Instrumento", mus.nome as "Nome do Músico",
    mus.nacionalidade as "Nacionalidade do Músico"
	from Instrumento ins
		left join Musico mus on ins.idInstrumento = mus.Instrumento_idInstrumento
			order by ins.nome asc, mus.nome asc;

-- View 5 - vw_musicos_nacionalidade
create view vw_musicos_nacionalidade as
select mus.nacionalidade as "Nacionalidade", count(*) as "Quantidade de Músicos"
	from Musico mus
		group by mus.nacionalidade
			order by count(*) desc;

-- View 6 - vw_funcoes_desempenhadas
create view vw_funcoes_desempenhadas as
select fun.nome as "Nome da Função", count(des.Funcao_idFuncao) as "Quantidade de Músicos"
	from Funcao fun
		left join Desempenha des on fun.idFuncao = des.Funcao_idFuncao
			group by fun.idFuncao, fun.nome
				order by count(des.Funcao_idFuncao) desc; 

-- View 7 - vw_musicos_sem_funcao
create view vw_musicos_sem_funcao as
select mus.nome as "Nome do Músico", mus.cpf as "CPF do Músico", nacionalidade as "Nacionalidade",
    ins.nome as "Nome do Instrumento"
	from Musico mus
		left join Desempenha des on mus.cpf = des.Musico_cpf
		left join Instrumento ins on mus.Instrumento_idInstrumento = ins.idInstrumento
			where des.idDesempenha is null
				order by mus.nome asc;

-- View 8 - vw_instrumentos_antigos_uso
create view vw_instrumentos_antigos_uso as
select ins.nome as "Nome do Instrumento", ins.tipo as "Tipo do Instrumento", ins.fabricante as "Fabricante",
    ins.datFabricacao as "Data de Fabricação"
	from Instrumento ins
		where ins.status = 'Em uso'
			order by ins.datFabricacao asc, ins.nome asc;
            
-- View 9 - vw_sinfonias_mais_musicos
create view vw_sinfonias_mais_musicos as
select sin.nome as "Nome da Sinfonia", sin.compositor as "Compositor",
    count(distinct des.Musico_cpf) as "Quantidade de Músicos"
	from Sinfonia sin
		join Desempenha des on sin.idSinfonia = des.Sinfonia_idSinfonia
			group by sin.idSinfonia, sin.nome, sin.compositor
				order by count(distinct des.Musico_cpf) desc, sin.nome asc;

-- View 10 - vw_musicos_ativos_orquestra
create view vw_musicos_ativos_orquestra as
select orq.nome as "Nome da Orquestra", orq.pais as "País da Orquestra",
    count(mus.cpf) as "Quantidade de Músicos Ativos"
	from Orquestra orq
		join Musico mus on orq.idOrquestra = mus.Orquestra_idOrquestra
			where mus.status = 'ativo'
				group by orq.idOrquestra, orq.nome, orq.pais
					order by count(mus.cpf) desc, orq.nome asc;

