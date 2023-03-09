-- Create table "aluno" to store student data
CREATE TABLE aluno (
    id SERIAL PRIMARY KEY, -- Auto-incrementing primary key column
    primeiro_nome VARCHAR(255) NOT NULL, -- First name, required (not null)
    ultimo_nome VARCHAR(255) NOT NULL, -- Last name, required (not null)
    data_nascimento DATE NOT NULL -- Date of birth, required (not null)
);

-- Create table "categoria" to store course categories
CREATE TABLE categoria (
    id SERIAL PRIMARY KEY, -- Auto-incrementing primary key column
    nome VARCHAR(255) NOT NULL UNIQUE -- Category name, required and must be unique
);

-- Create table "curso" to store course details and their associated category
CREATE TABLE curso (
    id SERIAL PRIMARY KEY, -- Auto-incrementing primary key column
    nome VARCHAR(255) NOT NULL, -- Course name, required (not null)
    categoria_id INTEGER NOT NULL REFERENCES categoria(id) -- ID of the category this course belongs to, required and references the "id" column in the "categoria" table
);

-- Create a table to manage the many-to-many relationship between students and courses
CREATE TABLE aluno_curso (
    aluno_id INTEGER NOT NULL REFERENCES aluno(id), -- Student ID, required and references the "id" column in the "aluno" tabel
    curso_id INTEGER NOT NULL REFERENCES curso(id), -- Course ID, required and references the "id" column in the "curso" tabel
    PRIMARY KEY (aluno_id, curso_id) -- Combination of student and course IDs is unique and forms the primary key
);

-- Add sample data to the "aluno" table
INSERT INTO aluno (primeiro_nome, ultimo_nome, data_nascimento) VALUES 
    ('Vinicius', 'Dias', '1997-10-15'),
    ('Patricia', 'Freitas', '1986-10-25'),
    ('Diogo', 'Oliveira', '1984-08-27'),
    ('Maria', 'Rosa', '1985-01-01');

-- Add sample data to the "categoria" table
INSERT INTO categoria (nome) VALUES 
    ('Front-end'),
    ('Programação'),
    ('Bancos de dados'),
    ('Data Science');

-- Add sample data to the "curso" table, including the ID of the category each course belongs to
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
    
-- Associate some students with certain courses
INSERT INTO aluno_curso VALUES (1, 4), (1, 11), (2, 1), (2, 2), (3, 4), (3, 3), (4, 4), (4, 6), (4, 5);

-- Show all records from the "categoria" table
SELECT * FROM categoria; 

-- Update the name of a category based on its ID
UPDATE categoria SET nome = 'Ciência de Dados' WHERE id = 4;

-- Select all student records along with their associated course IDs
SELECT *
    FROM aluno
    JOIN aluno_curso ON aluno_curso.aluno_id = aluno.id;
   
-- Select all student records along with their associated course IDs and the course names themselves
SELECT *
    FROM aluno
    JOIN aluno_curso ON aluno_curso.aluno_id = aluno.id
    JOIN curso ON curso.id = aluno_curso.curso_id;
  
-- Select each student's first and last name along with a count of how many courses they're associated with,
-- then order the results by decreasing number of courses
SELECT aluno.primeiro_nome,
       aluno.ultimo_nome,
       COUNT(curso.id) numero_cursos
    FROM aluno
    JOIN aluno_curso ON aluno_curso.aluno_id = aluno.id
    JOIN curso ON curso.id = aluno_curso.curso_id
GROUP BY aluno.primeiro_nome, aluno.ultimo_nome
ORDER BY numero_cursos DESC;

/* Seleciona o nome do curso com mais alunos matriculados */
SELECT curso.nome,
COUNT(aluno_curso.aluno_id) numero_alunos
FROM curso
JOIN aluno_curso ON aluno_curso.curso_id = curso.id
GROUP BY 1
ORDER BY numero_alunos DESC
LIMIT 1;

/* Seleciona o nome da categoria cujos cursos possuem a maior média de matrículas por curso */
SELECT categoria.nome, AVG(numero_matriculas) media_matriculas_por_curso
FROM (
SELECT categoria_id, curso.id id_curso, COUNT(aluno_curso.aluno_id) numero_matriculas
FROM curso
JOIN categoria ON categoria.id = curso.categoria_id
JOIN aluno_curso ON aluno_curso.curso_id = curso.id
GROUP BY categoria_id, id_curso
) subconsulta
JOIN categoria ON categoria.id = subconsulta.categoria_id
GROUP BY categoria.nome
ORDER BY media_matriculas_por_curso DESC
LIMIT 1;

/* Seleciona o nome do aluno que está matriculado em mais cursos */
SELECT aluno.primeiro_nome, aluno.ultimo_nome, COUNT() AS quantidade_cursos FROM aluno_curso
JOIN aluno ON aluno.id = aluno_curso.aluno_id
GROUP BY aluno.id
ORDER BY quantidade_cursos DESC
LIMIT 1;

/* Seleciona o nome da categoria com menos cursos */
SELECT categoria.nome, COUNT(curso.id) AS quantidade_cursos FROM categoria
LEFT JOIN curso ON categoria.id = curso.categoria_id
GROUP BY categoria.id
ORDER BY quantidade_cursos ASC
LIMIT 1;

/* Seleciona o nome dos alunos que não estão matriculados em nenhum curso */
SELECT aluno.primeiro_nome, aluno.ultimo_nome
FROM aluno WHERE NOT EXISTS (
SELECT * FROM aluno_curso
WHERE aluno_curso.aluno_id = aluno.id
);

/* Seleciona o nome dos cursos em que pelo menos um aluno está cadastrado naquele curso e os outros alunos daquele curso têm matrícula somente no próprio curso. */
SELECT curso.nome FROM curso
WHERE EXISTS (
SELECT * FROM aluno_curso
WHERE aluno_curso.curso_id = curso.id AND curso.id NOT IN (
SELECT curso_id FROM aluno_curso
GROUP BY curso_id
HAVING COUNT() > 1
)
);