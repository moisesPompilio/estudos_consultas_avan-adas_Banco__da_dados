SELECT *
    FROM aluno
    JOIN aluno_curso ON aluno_curso.aluno_id = aluno.id;
   /*  selec os alunos e mostrando as referencias e os cursos*/
   SELECT *
    FROM aluno
    JOIN aluno_curso ON aluno_curso.aluno_id = aluno.id
    JOIN curso ON curso.id = aluno_curso.curso_id;