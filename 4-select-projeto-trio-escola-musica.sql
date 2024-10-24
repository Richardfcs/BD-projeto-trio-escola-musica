-- Relatório 1 - Lista dos músicos mais ativos da escola, ou seja, que participaram de mais sinfonias.
-- Trazer as colunas (Nome do Músico, CPF do Músico, Nacionalidade, Quantidade de Sinfonias),
-- ordenado pela Quantidade de Sinfonias em ordem decrescente.

select mus.nome as "Nome do Músico", mus.cpf as "CPF do Músico", mus.nacionalidade as "Nacionalidade", 
    count(des.Sinfonia_idSinfonia) as "Quantidade de Sinfonias" 
	from Musico mus 
		left join Desempenha des on mus.cpf = des.Musico_cpf 
			group by mus.cpf, mus.nome, mus.nacionalidade 
				order by count(des.Sinfonia_idSinfonia) desc;
                
-- Relatório 2 - Lista das sinfonias mais populares, ou seja, que foram executadas por mais orquestras.
-- Trazer as colunas (Nome da Sinfonia, Compositor, Quantidade de Orquestras),
-- ordenado pela Quantidade de Orquestras em ordem decrescente.

select sin.nome as "Nome da Sinfonia", sin.compositor as "Compositor", 
    count(ors.Orquestra_idOrquestra) as "Quantidade de Orquestras" 
	from Sinfonia sin 
		left join OrquestraSinfonia ors on sin.idSinfonia = ors.Sinfonia_idSinfonia 
			group by sin.idSinfonia, sin.nome, sin.compositor 
				order by count(ors.Orquestra_idOrquestra) desc;

-- Relatório 3 - Lista a média de idade dos músicos de cada orquestra,
-- trazendo as colunas (Nome da Orquestra, País da Orquestra, Média de Idade),
-- ordenado pela Média de Idade em ordem decrescente.

select orq.nome as "Nome da Orquestra", orq.pais as "País da Orquestra", 
    format(avg(timestampdiff(year, mus.dataNasc, curdate())), 1, 'de_DE') as "Média de Idade" 
	from Orquestra orq 
		join Musico mus on orq.idOrquestra = mus.Orquestra_idOrquestra 
			group by orq.idOrquestra, orq.nome, orq.pais 
				order by avg(timestampdiff(year, mus.dataNasc, curdate())) desc;
                
-- Relatório 4 - Lista os instrumentos mais utilizados nas sinfonias de Beethoven,
-- trazendo as colunas (Nome do Instrumento, Tipo do Instrumento, Quantidade de Sinfonias),
-- ordenado pela Quantidade de Sinfonias em ordem decrescente.

select ins.nome as "Nome do Instrumento", ins.tipo as "Tipo do Instrumento", 
    count(distinct des.Sinfonia_idSinfonia) as "Quantidade de Sinfonias"
	from Instrumento ins 
		join Musico mus on ins.idInstrumento = mus.Instrumento_idInstrumento 
		join Desempenha des on mus.cpf = des.Musico_cpf 
		join Sinfonia sin on des.Sinfonia_idSinfonia = sin.idSinfonia 
			where sin.compositor = 'Beethoven' 
				group by ins.idInstrumento, ins.nome, ins.tipo 
					order by count(distinct des.Sinfonia_idSinfonia) desc;

-- Relatório 5 - Lista todos os instrumentos e os músicos que os tocam,
-- trazendo as colunas (Nome do Instrumento, Tipo do Instrumento, Nome do Músico, Nacionalidade do Músico),
-- ordenado pelo Nome do Instrumento em ordem crescente e, em seguida, pelo Nome do Músico em ordem crescente.

select ins.nome as "Nome do Instrumento", ins.tipo as "Tipo do Instrumento", mus.nome as "Nome do Músico",
    mus.nacionalidade as "Nacionalidade do Músico"
	from Instrumento ins
		left join Musico mus on ins.idInstrumento = mus.Instrumento_idInstrumento
			order by ins.nome asc, mus.nome asc;
            
-- Relatório 6 - Lista as orquestras que possuem músicos inativos,
-- trazendo as colunas (Nome da Orquestra, País da Orquestra, Nome do Músico, Status do Músico),
-- ordenado pelo Nome da Orquestra em ordem crescente.

select orq.nome as "Nome da Orquestra", orq.pais as "País da Orquestra", mus.nome as "Nome do Músico",
    mus.status as "Status do Músico"
	from Orquestra orq
		join Musico mus on orq.idOrquestra = mus.Orquestra_idOrquestra
			where mus.status = 'Inativo'
				order by orq.nome asc;
                
-- Relatório 7 - Lista a quantidade de músicos por nacionalidade,
-- trazendo as colunas (Nacionalidade, Quantidade de Músicos),
-- ordenado pela Quantidade de Músicos em ordem decrescente.

select mus.nacionalidade as "Nacionalidade", count(*) as "Quantidade de Músicos"
	from Musico mus
		group by mus.nacionalidade
			order by count(*) desc;

-- Relatório 8 - Lista as funções mais desempenhadas pelos músicos,
-- trazendo as colunas (Nome da Função, Quantidade de Músicos),
-- ordenado pela Quantidade de Músicos em ordem decrescente.

select fun.nome as "Nome da Função", count(des.Funcao_idFuncao) as "Quantidade de Músicos"
	from Funcao fun
		left join Desempenha des on fun.idFuncao = des.Funcao_idFuncao
			group by fun.idFuncao, fun.nome
				order by count(des.Funcao_idFuncao) desc; 
                
-- Relatório 9 - Lista os músicos que nunca desempenharam nenhuma função em uma sinfonia,
-- trazendo as colunas (Nome do Músico, CPF do Músico, Nacionalidade, Nome do Instrumento),
-- ordenado pelo Nome do Músico em ordem crescente.

select mus.nome as "Nome do Músico", mus.cpf as "CPF do Músico", nacionalidade as "Nacionalidade",
    ins.nome as "Nome do Instrumento"
	from Musico mus
		left join Desempenha des on mus.cpf = des.Musico_cpf
		left join Instrumento ins on mus.Instrumento_idInstrumento = ins.idInstrumento
			where des.idDesempenha is null
				order by mus.nome asc;

-- Relatório 10 - Lista a quantidade de sinfonias compostas em cada período (década),
-- trazendo as colunas (Década de Composição, Quantidade de Sinfonias),
-- considerando que a data de composição é aproximada pela data de criação da orquestra que executou a sinfonia pela primeira vez,
-- ordenado pela Década de Composição em ordem crescente.

select concat(floor(year(orq.dataCriacao)/10)*10, 's') as "Década de Composição",
    count(distinct sin.idSinfonia) as "Quantidade de Sinfonias"
	from Sinfonia sin
		join OrquestraSinfonia ors on sin.idSinfonia = ors.Sinfonia_idSinfonia
		join Orquestra orq on ors.Orquestra_idOrquestra = orq.idOrquestra
			group by concat(floor(year(orq.dataCriacao)/10)*10, 's')
				order by concat(floor(year(orq.dataCriacao)/10)*10, 's') asc;

-- Relatório 11 - Lista os instrumentos mais antigos que ainda estão em uso,
-- trazendo as colunas (Nome do Instrumento, Tipo do Instrumento, Fabricante, Data de Fabricação),
-- ordenado pela Data de Fabricação em ordem crescente e, em seguida, pelo Nome do Instrumento em ordem crescente.

select ins.nome as "Nome do Instrumento", ins.tipo as "Tipo do Instrumento", ins.fabricante as "Fabricante",
    ins.datFabricacao as "Data de Fabricação"
	from Instrumento ins
		where ins.status = 'Em uso'
			order by ins.datFabricacao asc, ins.nome asc;

-- Relatório 12 - Lista os músicos que desempenharam mais de uma função na mesma sinfonia,
-- trazendo as colunas (Nome do Músico, CPF do Músico, Nome da Sinfonia, Quantidade de Funções),
-- ordenado pelo Nome do Músico em ordem crescente e, em seguida, pela Quantidade de Funções em ordem decrescente.

select mus.nome as "Nome do Músico", mus.cpf as "CPF do Músico", sin.nome as "Nome da Sinfonia", 
    count(distinct des.Funcao_idFuncao) as "Quantidade de Funções"
	from Musico mus
		join Desempenha des on mus.cpf = des.Musico_cpf
		join Sinfonia sin on des.Sinfonia_idSinfonia = sin.idSinfonia
			group by mus.cpf, mus.nome, sin.idSinfonia, sin.nome
				having count(distinct des.Funcao_idFuncao) > 1
					order by mus.nome asc, count(distinct des.Funcao_idFuncao) desc;
                    
-- caso o funcionário tenha alguma função, mas não maior que 1:

select mus.nome as "Nome do Músico", mus.cpf as "CPF do Músico", sin.nome as "Nome da Sinfonia", 
    count(distinct des.Funcao_idFuncao) as "Quantidade de Funções"
	from Musico mus
		join Desempenha des on mus.cpf = des.Musico_cpf
		join Sinfonia sin on des.Sinfonia_idSinfonia = sin.idSinfonia
			group by mus.cpf, mus.nome, sin.idSinfonia, sin.nome
				having count(distinct des.Funcao_idFuncao) > 0
					order by mus.nome asc, count(distinct des.Funcao_idFuncao) desc;

-- Relatório 13 - Lista as orquestras mais antigas de cada país,
-- trazendo as colunas (Nome da Orquestra, País da Orquestra, Data de Criação),
-- ordenado pelo País da Orquestra em ordem crescente e, em seguida, pela Data de Criação em ordem crescente.

select orq.nome as "Nome da Orquestra", orq.pais as "País da Orquestra", orq.dataCriacao as "Data de Criação"
	from Orquestra orq
		where (orq.pais, orq.dataCriacao) in (
				select orq2.pais, min(orq2.dataCriacao)
				from Orquestra orq2
				group by orq2.pais
			)
			order by orq.pais asc, orq.dataCriacao asc;

-- Relatório 14 - Lista a média de idade dos músicos por tipo de instrumento,
-- trazendo as colunas (Tipo de Instrumento, Média de Idade),
-- ordenado pela Média de Idade em ordem decrescente.

select ins.tipo as "Tipo de Instrumento",
    format(avg(timestampdiff(YEAR, mus.dataNasc, curdate())), 1, "de_DE") as "Média de Idade"
	from Instrumento ins
		join Musico mus on ins.idInstrumento = mus.Instrumento_idInstrumento
			group by ins.tipo
				order by avg(timestampdiff(YEAR, mus.dataNasc, curdate())) desc;

-- Relatório 15 - Lista as sinfonias com o maior número de músicos participantes,
-- trazendo as colunas (Nome da Sinfonia, Compositor, Quantidade de Músicos),
-- ordenado pela Quantidade de Músicos em ordem decrescente e, em seguida, pelo Nome da Sinfonia em ordem crescente.

select sin.nome as "Nome da Sinfonia", sin.compositor as "Compositor",
    count(distinct des.Musico_cpf) as "Quantidade de Músicos"
	from Sinfonia sin
		join Desempenha des on sin.idSinfonia = des.Sinfonia_idSinfonia
			group by sin.idSinfonia, sin.nome, sin.compositor
				order by count(distinct des.Musico_cpf) desc, sin.nome asc;

-- Relatório 16 - Lista, para cada tipo de instrumento, as nacionalidades mais representadas entre os músicos,
-- trazendo as colunas (Tipo de Instrumento, Nacionalidade, Quantidade de Músicos),
-- ordenado pelo Tipo de Instrumento em ordem crescente e, em seguida, pela Quantidade de Músicos em ordem decrescente.

select ins.tipo as "Tipo de Instrumento", mus.nacionalidade as "Nacionalidade",
    count(*) as "Quantidade de Músicos"
	from Musico mus
		join Instrumento ins on mus.Instrumento_idInstrumento = ins.idInstrumento
			group by ins.tipo, mus.nacionalidade
				having count(*) = (
						select max(qtd) 
						from (
							select ins2.tipo, count(*) as qtd 
							from Musico mus2
							join Instrumento ins2 on mus2.Instrumento_idInstrumento = ins2.idInstrumento
							where ins2.tipo = ins.tipo
							group by ins2.tipo, mus2.nacionalidade
						) as max_qtd
					)
					order by ins.tipo asc, count(*) desc;
                    
-- Relatório 17 - Lista a quantidade de músicos ativos em cada orquestra,
-- trazendo as colunas (Nome da Orquestra, País da Orquestra, Quantidade de Músicos Ativos),
-- ordenado pela Quantidade de Músicos Ativos em ordem decrescente e, em seguida, pelo Nome da Orquestra em ordem crescente.

select orq.nome as "Nome da Orquestra", orq.pais as "País da Orquestra",
    count(mus.cpf) as "Quantidade de Músicos Ativos"
	from Orquestra orq
		join Musico mus on orq.idOrquestra = mus.Orquestra_idOrquestra
			where mus.status = 'ativo'
				group by orq.idOrquestra, orq.nome, orq.pais
					order by count(mus.cpf) desc, orq.nome asc;

-- Relatório 18 - Lista a quantidade de instrumentos por tipo,
-- trazendo as colunas (Tipo de Instrumento, Quantidade de Instrumentos),
-- ordenado pela Quantidade de Instrumentos em ordem decrescente.

select ins.tipo as "Tipo de Instrumento", count(*) as "Quantidade de Instrumentos"
	from Instrumento ins
		group by ins.tipo
			order by count(*) desc;

-- Relatório 19 - Lista detalhadamente as funções desempenhadas por cada músico em cada sinfonia,
-- trazendo as colunas (Nome do Músico, CPF do Músico, Nome da Sinfonia, Compositor da Sinfonia, Nome da Função),
-- ordenado pelo Nome do Músico em ordem crescente, em seguida pelo Nome da Sinfonia em ordem crescente e, por fim, pelo Nome da Função em ordem crescente.

select mus.nome as "Nome do Músico", mus.cpf as "CPF do Músico", sin.nome as "Nome da Sinfonia",
    sin.compositor as "Compositor da Sinfonia", fun.nome as "Nome da Função"
	from Musico mus
		join Desempenha des on mus.cpf = des.Musico_cpf
		join Sinfonia sin on des.Sinfonia_idSinfonia = sin.idSinfonia
		join Funcao fun on des.Funcao_idFuncao = fun.idFuncao
			order by mus.nome asc, sin.nome asc, fun.nome asc;

-- Relatório 20 - Lista as sinfonias em que todas as funções cadastradas foram desempenhadas por pelo menos um músico,
-- trazendo as colunas (Nome da Sinfonia, Compositor da Sinfonia, Quantidade de Funções Desempenhadas),
-- ordenado pelo Nome da Sinfonia em ordem crescente.

select sin.nome as "Nome da Sinfonia", sin.compositor as "Compositor da Sinfonia",
    count(distinct des.Funcao_idFuncao) as "Quantidade de Funções Desempenhadas"
	from Sinfonia sin
		join Desempenha des on sin.idSinfonia = des.Sinfonia_idSinfonia
			group by sin.idSinfonia, sin.nome, sin.compositor
				having count(distinct des.Funcao_idFuncao) = (select count(*) from Funcao)
					order by sin.nome asc;
                    
-- sinfonias listadas sem terem todas as funções:
select sin.nome as "Nome da Sinfonia", sin.compositor as "Compositor da Sinfonia",
    count(distinct des.Funcao_idFuncao) as "Quantidade de Funções Desempenhadas"
	from Sinfonia sin
		join Desempenha des on sin.idSinfonia = des.Sinfonia_idSinfonia
			group by sin.idSinfonia, sin.nome, sin.compositor
					order by sin.nome asc;