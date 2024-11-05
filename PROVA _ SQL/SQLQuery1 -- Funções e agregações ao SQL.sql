
-- VIEW
-- View simples, obtém os dados das aulas, os alunos dessas aulas, para verificar se a área de atuação do professor condiz com a área que era pra ser ensinada na aula.
-- Útil para verificar atuação dos professores e a coerência das aulas.
CREATE VIEW vw_área_professores AS
SELECT
	AULAS.Id_aula,
	AULAS.Id_aluno,
	AULAS.Área AS 'Área Aula',
	PROFESSORES.Nome,
	PROFESSORES.Área AS 'Área professor'
FROM AULAS
JOIN PROFESSORES ON AULAS.Id_professor = PROFESSORES.Id_professor

SELECT * FROM vw_área_professores



-- SUBQUERY
--Essa subquery vai realizar uma consulta para puxar apenas os dados dos alunos que tiveram aula com o professor de nome 'Joaõ', podendo ser usada para puxar dados de alunos 
--que tiveram aula com outros professores, bastando apenas mudar o nome na subquery.
--Útil para verificar dados sobre os professores quanto aos alunos e vice-versa.

SELECT *
FROM ALUNOS
WHERE Id_aluno IN (
	SELECT Id_aluno
	FROM AULAS
	WHERE Id_professor = (SELECT Id_professor FROM PROFESSORES WHERE Nome = 'João')
	
);


-- CTEs (Common Table Expressions)

WITH Consulta_detalhada AS (
	SELECT
		AULAS.Id_aluno,
		AULAS.Área,
		AULAS.data_aula,
		AULAS.Id_professor
	FROM 
		AULAS
	INNER JOIN ALUNOS
		ON AULAS.Id_aluno = ALUNOS.Id_aluno
	INNER JOIN PROFESSORES
		ON AULAS.Id_professor = PROFESSORES.Id_professor
)

SELECT
Id_aluno,
Área,
data_aula,
Id_professor

FROM ConsultaDetalhada
ORDER BY data_aula


-- Window Functions
-- Essa Window Function separa e organiza os professores de acordo com o salários deles, através da tabela criada 'Agrupamento Salarial', a consulta
-- faz com que os professores pertencam a um grupo único, relacionado exclusivamente ao seu salário.
-- Útil para agregações de ranking e comparações entre eles.

	SELECT
Id_professor,
Nome,
Salário,
NTILE(10) OVER (ORDER BY Salário DESC) AS 'Agrupamento Salarial'
FROM
    PROFESSORES
WHERE Nome IS NOT NULL;

-- Functions
-- Essa função é muito simples e vai calcular a idade do aluno, através de uma variável '@DATANASC' e sua diferença quanto a data atual, pega através do 'GETDATE()'
-- e com uma operação básica de subtração o programa calculae nos devolve dentro da função 'CalcularIdade'.
-- Útil para verificação da faixa etária dos estudantes.

CREATE FUNCTION CalcularIdade (@DATANASC DATE)
RETURNS INT
AS
BEGIN
    RETURN DATEDIFF(YEAR, @DATANASC, GETDATE());
END;

SELECT Nome, dbo.CalcularIdade(data_nasc) AS Idade
FROM ALUNOS;

-- Loops
-- Nesse loop o programa primeiro calcula o total de alunos, após isso é criado um loop onde se conta a quantidade de aulas para cada 'Id_aluno' que for igual a varáivel '@idAluno',
-- contando assim apenas as aulas dos alunos calculados no total, fazendo um count para cada Id que for igual a sua respectiva varíavel, contando assim
-- as aulas concluídas de cada aluno
-- Útil para monitorar a presença dos alunos e as a quantidade de aulas para cada um
-- Aqui ele vai calcular o total de alunos
DECLARE @idAluno INT
SET @idAluno = 1;
DECLARE @totalAlunos INT;
DECLARE @totalAulas INT;
SELECT @totalAlunos = COUNT(*) FROM ALUNOS;
PRINT @totalAlunos

WHILE @idAluno <= @totalAlunos
BEGIN
    -- dita o número de aulas para cada aluno contado dentro do loop anterior
    SELECT @totalAulas = COUNT(*)
    FROM AULAS
    WHERE Id_aluno = @idAluno;
    
    PRINT 'ALuno dono do Id ' + CAST(@idAluno AS VARCHAR) + ' possui ' + CAST(@totalAulas AS VARCHAR) + ' aulas concluídas.';

    SET @idAluno = @idAluno + 1;
END;


-- Procedures
-- Não finalizado, varívael 'Não declarada' ( sinceramente não entendi )

IF EXISTS (SELECT 1 FROM SYS.objects WHERE TYPE = 'P' AND NAME = 'Consulta_procedure')
	BEGIN
		DROP PROCEDURE Consulta_procedure
	END
GO

CREATE PROCEDURE Consulta_procedure
	@idAula INT
AS	

SELECT  
	Id_aula,
	data_aula,
	b.nome AS Paciente,
	c.nome AS Médico

FROM AULAS AS a
INNER JOIN ALUNOS AS b
ON a.Id_aluno = b.Id_aluno
INNER JOIN PROFESSORES AS c
ON a.Id_professor = c.Id_professor
WHERE Id_aula = @idAula

GO

EXEC Consulta_procedure


-- Triggers
-- Triggers são como gatilhos que são ativados antes, depois ou durante uma ação dentro do seu código SQL SERVER
-- Nesse cao o gatilho é ativado após um novo aluno ser adicionado, ele gera uma varívael que se equivale ao nome do aluno adcionado e exibe a mensagem
-- '@Nome adicionado com sucesso!!'
-- Útil para proteção de certos dados e para avisos ao alterar tabelas.

CREATE OR ALTER TRIGGER Aluno_adicionado
ON ALUNOS 
AFTER INSERT --Ocorre depois do dado ser inserido ou alterado
AS
BEGIN
	DECLARE @Nome VARCHAR(50);
	SELECT @Nome = Nome FROM ALUNOS ORDER BY Id_aluno ASC;

	PRINT @Nome + ' adicionado com sucesso!!'
END
GO

INSERT INTO ALUNOS (Id_aluno, Nome, CPF, Area_estudo, Sexo, data_nasc, endereço ) VALUES
('5', 'Sarah', '987.789.123.08', 'Front-End', 'F', '23/04/2002', 'Rua Pablo 100')