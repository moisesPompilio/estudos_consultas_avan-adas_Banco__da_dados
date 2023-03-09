CREATE TABLE aluno (
    id SERIAL PRIMARY KEY,
	primeiro_nome VARCHAR(255) NOT NULL,
	ultimo_nome VARCHAR(255) NOT NULL,
	data_nascimento DATE NOT NULL
);

CREATE TABLE categoria (
    id SERIAL PRIMARY KEY,
	nome VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE curso (
    id SERIAL PRIMARY KEY,
	nome VARCHAR(255) NOT NULL,
	categoria_id INTEGER NOT NULL REFERENCES categoria(id)
);

CREATE TABLE aluno_curso (
	aluno_id INTEGER NOT NULL REFERENCES aluno(id),
	curso_id INTEGER NOT NULL REFERENCES curso(id),
	PRIMARY KEY (aluno_id, curso_id)
);





iNSERT INTO aluno (primeiro_nome, ultimo_nome, data_nascimento) VALUES (
	'Vinicius', 'Dias', '1997-10-15'
), (
	'Patricia', 'Freitas', '1986-10-25'
), (
	'Diogo', 'Oliveira', '1984-08-27'
), (
	'Maria', 'Rosa', '1985-01-01'
);

INSERT INTO categoria (nome) VALUES ('Front-end'), ('Programação'), ('Bancos de dados'), ('Data Science');

INSERT INTO curso (nome, categoria_id) VALUES
	('HTML', 1),
	('CSS', 1),
	('JS', 1),
	('PHP', 2),
	('Java', 2),
	('C++', 2),
	('PostgreSQL', 3),
	('MySQL', 3),
	('Oracle', 3),
	('SQL Server', 3),
	('SQLite', 3),
	('Pandas', 4),
	('Machine Learning', 4),
	('Power BI', 4);
	
INSERT INTO aluno_curso VALUES (1, 4), (1, 11), (2, 1), (2, 2), (3, 4), (3, 3), (4, 4), (4, 6), (4, 5);



select * from categoria; 

update categoria set nome = 'Ciência de Dados' where id = 4; 
/*  selec os alunos e mostrando as referencias */
SELECT *
    FROM aluno
    JOIN aluno_curso ON aluno_curso.aluno_id = aluno.id;
   /*  selec os alunos e mostrando as referencias e os cursos*/
   SELECT *
    FROM aluno
    JOIN aluno_curso ON aluno_curso.aluno_id = aluno.id
    JOIN curso ON curso.id = aluno_curso.curso_id;
  
   
  /*  seleciona todos os alunos e mostra seu nome e uma coluna que mostra quantos cursos ele esta vinculado faz isso em ordem decrecente de numero de cursos vinculado */
SELECT aluno.primeiro_nome,
       aluno.ultimo_nome,
       COUNT(curso.id) numero_cursos
    FROM aluno
    JOIN aluno_curso ON aluno_curso.aluno_id = aluno.id
    JOIN curso ON curso.id = aluno_curso.curso_id
GROUP BY aluno.primeiro_nome, aluno.ultimo_nome
order by numero_cursos desc  ;


SELECT aluno.primeiro_nome,
       aluno.ultimo_nome,
       COUNT(aluno_curso.curso_id) numero_cursos
    FROM aluno
    JOIN aluno_curso ON aluno_curso.aluno_id = aluno.id
GROUP BY 1,2
ORDER BY numero_cursos DESC;

/*  seleciona todos os alunos e mostra seu nome e uma coluna que mostra quantos cursos ele esta vinculado faz isso em ordem decrecente de numero de cursos vinculado */
SELECT aluno.primeiro_nome,
       aluno.ultimo_nome,
       COUNT(aluno_curso.curso_id) numero_cursos
    FROM aluno
    JOIN aluno_curso ON aluno_curso.aluno_id = aluno.id
GROUP BY 1,2
ORDER BY numero_cursos DESC;



SELECT curso.nome,
       COUNT(aluno_curso.aluno_id) numero_alunos
    FROM curso
    JOIN aluno_curso ON aluno_curso.curso_id = curso.id
GROUP BY 1
ORDER BY numero_alunos desc

SELECT curso.nome,
       COUNT(aluno_curso.aluno_id) numero_alunos
    FROM curso
LEFT    JOIN aluno_curso ON aluno_curso.curso_id = curso.id
GROUP BY 1
ORDER BY numero_alunos DESC


SELECT curso.nome,

       COUNT(aluno_curso.aluno_id) numero_alunos
    FROM curso
    JOIN aluno_curso ON aluno_curso.curso_id = curso.id
GROUP BY 1
ORDER BY numero_alunos DESC
    LIMIT 1;

