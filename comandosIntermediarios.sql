SELECT * FROM categoria

SELECT * FROM curso WHERE categoria_id IN(1,2);

SELECT * FROM curso WHERE categoria_id IN(
    SELECT id FROM categoria WHERE nome NOT LIKE'% %'
);

SELECT categoria.nome AS categoria,
        COUNT(curso.id) as numero_cursos
    FROM categoria
    JOIN curso ON curso.categoria_id = categoria.id
GROUP BY categoria;

SELECT categoria,
       numero_cursos
    FROM (
            SELECT categoria.nome AS categoria,
                COUNT(curso.id) as numero_cursos
            FROM categoria
            JOIN curso ON curso.categoria_id = categoria.id
        GROUP BY categoria
    ) AS categoria_cursos
  WHERE numero_cursos > 3;

SELECT categoria,
       numero_cursos
    FROM (
            SELECT categoria.nome AS categoria,
                COUNT(curso.id) as numero_cursos
            FROM categoria
            JOIN curso ON curso.categoria_id = categoria.id
        GROUP BY categoria
    ) AS categoria_cursos
  WHERE numero_cursos >= 3
  ORDER BY numero_cursos ASC;

    SELECT curso.nome,
         COUNT(aluno_curso.aluno_id) numero_alunos
    FROM curso
    JOIN aluno_curso ON aluno_curso.curso_id = curso.id
GROUP BY 1
     HAVING COUNT(aluno_curso.aluno_id) > 2
ORDER BY numero_alunos DESC;

SELECT (primeiro_nome || ultimo_nome) AS nome_completo,
    ((NOW()::DATE - data_nascimento) / 365) as idade
  FROM aluno;

SELECT (primeiro_nome || ultimo_nome) AS nome_completo,
    AGE(data_nascimento) AS idade
  FROM aluno;

SELECT (primeiro_nome || ultimo_nome) AS nome_completo,
    EXTRACT(YEAR FROM AGE(data_nascimento)) AS idade
  FROM aluno;

CREATE VIEW vw_cursos_por_categoria
    AS SELECT categoria.nome AS categoria,
       COUNT(curso.id) as numero_cursos
   FROM categoria
   JOIN curso ON curso.categoria_id = categoria.id
GROUP BY categoria;

SELECT categoria
    FROM vw_cursos_por_categoria AS categoria_cursos
  WHERE numero_cursos > 3;

SELECT categoria.id AS categoria_id, vw_cursos_por_categoria.*
    FROM vw_cursos_por_categoria
    JOIN categoria ON categoria.nome = vw_cursos_por_categoria.categoria;