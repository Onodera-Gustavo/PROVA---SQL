	

-- VIEW
-- View simples, obt�m os dados das aulas, os alunos dessas aulas, para verificar se a �rea de atua��o do professor condiz com a �rea que era pra ser ensinada na aula.
-- �til para verificar atua��o dos professores e a coer�ncia das aulas.
CREATE VIEW vw_�rea_professores AS
SELECT
	AULAS.Id_aula,
	AULAS.Id_aluno,
	AULAS.�rea AS '�rea Aula',
	PROFESSORES.Nome,
	PROFESSORES.�rea AS '�rea professor'
FROM AULAS
JOIN PROFESSORES ON AULAS.Id_professor = PROFESSORES.Id_professor

SELECT * FROM vw_�rea_professores



-- SUBQUERY
--Essa subquery vai realizar uma consulta para puxar apenas os dados dos alunos que tiveram aula com o professor de nome 'Joa�', podendo ser usada para puxar dados de alunos 
--que tiveram aula com outros professores, bastando apenas mudar o nome na subquery.
--�til para verificar dados sobre os professores quanto aos alunos e vice-versa.

SELECT *
FROM ALUNOS
WHERE Id_aluno IN (
	SELECT Id_aluno
	FROM AULAS
	WHERE Id_professor = (SELECT Id_professor FROM PROFESSORES WHERE Nome = 'Jo�o')
	
);


-- CTEs (Common Table Expressions)
-- CTEs s�o consultas mais complexas que v�o justamente...simplificar consultas complexas, realizando a opera��o antes do pull dos resultados.
-- Essa CTE foi criada com o objetivo de mostrar todos os professor que tiveram aula com mais de um aluno.
-- �til pra simplifica��o de consultas mais complexas e uma melhor organiza��o.
WITH Consulta_det AS (
    SELECT
        COUNT(DISTINCT AULAS.Id_aluno) AS totalAlunos,
        AULAS.Id_professor
    FROM AULAS
    INNER JOIN ALUNOS ON ALUNOS.Id_aluno = AULAS.Id_aluno
    INNER JOIN PROFESSORES ON PROFESSORES.Id_professor = AULAS.Id_professor
    GROUP BY AULAS.Id_professor
)

SELECT
    PROFESSORES.Nome,
    Consulta_det.totalalunos
FROM Consulta_det
INNER JOIN PROFESSORES ON PROFESSORES.Id_professor = Consulta_det.Id_professor -- Associando o PROFESSORES.Nome
WHERE Consulta_det.totalalunos > 1;



-- Window Functions
-- Essa Window Function separa e organiza os professores de acordo com o sal�rios deles, atrav�s da tabela criada 'Agrupamento Salarial', a consulta
-- faz com que os professores pertencam a um grupo �nico, relacionado exclusivamente ao seu sal�rio.
-- �til para agrega��es de ranking e compara��es entre eles.

	SELECT
Id_professor,
Nome,
Sal�rio,
NTILE(10) OVER (ORDER BY Sal�rio DESC) AS 'Agrupamento Salarial'
FROM
    PROFESSORES
WHERE Nome IS NOT NULL;

-- Functions
-- Essa fun��o � muito simples e vai calcular a idade do aluno, atrav�s de uma vari�vel '@DATANASC' e sua diferen�a quanto a data atual, pega atrav�s do 'GETDATE()'
-- e com uma opera��o b�sica de subtra��o o programa calcula e nos devolve dentro da fun��o 'CalcularIdade'.
-- �til para verifica��o da faixa et�ria dos estudantes.

CREATE FUNCTION CalcularIdade (@DATANASC DATE)
RETURNS INT
AS
BEGIN
    RETURN DATEDIFF(YEAR, @DATANASC, GETDATE());
END;

SELECT Nome, dbo.CalcularIdade(data_nasc) AS Idade
FROM ALUNOS;

-- Loops
-- Nesse loop o programa primeiro calcula o total de alunos, ap�s isso � criado um loop onde se conta a quantidade de aulas para cada 'Id_aluno' que for igual a var�ivel '@idAluno',
-- contando assim apenas as aulas dos alunos calculados no total, fazendo um count para cada Id que for igual a sua respectiva var�avel, contando assim
-- as aulas conclu�das de cada aluno
-- �til para monitorar a presen�a dos alunos e as a quantidade de aulas para cada um
-- Aqui ele vai calcular o total de alunos
DECLARE @idAluno INT
SET @idAluno = 1;
DECLARE @totalAlunos INT;
DECLARE @totalAulas INT;
SELECT @totalAlunos = COUNT(*) FROM ALUNOS;
PRINT @totalAlunos

WHILE @idAluno <= @totalAlunos
BEGIN
    -- dita o n�mero de aulas para cada aluno contado dentro do loop anterior
    SELECT @totalAulas = COUNT(*)
    FROM AULAS
    WHERE Id_aluno = @idAluno;
    
    PRINT 'ALuno dono do Id ' + CAST(@idAluno AS VARCHAR) + ' possui ' + CAST(@totalAulas AS VARCHAR) + ' aulas conclu�das.';

    SET @idAluno = @idAluno + 1;
END;


-- Procedures
-- Uma procedure vai automatizar um processo dentro de uma consulta que seja mais complexa no banco de dados, funcionando a partir da execu��o.
-- �til para simplificar, e ajudar na velocidade quanto a consultas mais demoradas
-- Essa procedure vai puxar todas as aulas das quais um aluno tenha participado, basta apenas colocar o nome dele na execu��o.



IF EXISTS (SELECT 1 FROM SYS.objects WHERE TYPE = 'P' AND NAME = 'AulasPorAluno')
	BEGIN
		DROP PROCEDURE AulasPorAluno
	END
GO

CREATE PROCEDURE AulasPorAluno
    @Aluno VARCHAR(100)
AS    
BEGIN
    SET NOCOUNT ON;

    SELECT  
        a.Id_aula,
        a.data_aula,
        b.Nome AS Aluno,
        c.Nome AS Professor
    FROM AULAS AS a
    INNER JOIN ALUNOS AS b
        ON a.Id_aluno = b.Id_aluno
    INNER JOIN PROFESSORES AS c
        ON a.Id_professor = c.Id_professor
    WHERE b.Nome = @Aluno;
END;

EXEC AulasPorAluno --COLOQUE O NOME DO ALUNO AQUI--

-- Triggers
-- Triggers s�o como gatilhos que s�o ativados antes, depois ou durante uma a��o dentro do seu c�digo SQL SERVER
-- Nesse cao o gatilho � ativado ap�s um novo aluno ser adicionado, ele gera uma var�vael que se equivale ao nome do aluno adcionado e exibe a mensagem
-- '@Nome adicionado com sucesso!!'
-- �til para prote��o de certos dados e para avisos ao alterar tabelas.

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

INSERT INTO ALUNOS (Id_aluno, Nome, CPF, Area_estudo, Sexo, data_nasc, endere�o ) VALUES
('5', 'Sarah', '987.789.123.08', 'Front-End', 'F', '23/04/2002', 'Rua Pablo 100')
