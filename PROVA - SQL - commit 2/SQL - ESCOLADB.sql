CREATE DATABASE EscolaDB
USE EscolaDB


CREATE TABLE PROFESSORES(
	Id_professor VARCHAR(10) PRIMARY KEY,
	Nome VARCHAR(50),
	Endereço VARCHAR(150),
	Salário INT,
	CPF VARCHAR (14),
	data_nasc DATE,
	Sexo VARCHAR (1),
	Área VARCHAR(50),--área de atuação

);


INSERT INTO PROFESSORES (Id_professor, Nome, Endereço, Salário,CPF, data_nasc, Área, Sexo) VALUES 
('1', 'Marcos', 'Rua Almeida 100', 1700, '123.456.789.00', '12/12/1978', 'Back_end', 'M'),
('2', 'João', 'Rua Orvalho 100', 1800, '456.678.123.01', '14/04/1988', 'Front_end', 'M'),
('3', 'Sheila', 'Rua Castanha 100', 2000, '678.987.123.02', '20/01/1988', 'Banco_de_dados', 'F'),
('4', 'Paula', 'Rua Pinheiro 100', 1900,  '123.678.456.03', '04/09/1999', 'Nuvem', 'F')


-----------------------------------------------------------------------------------------------------------------------

CREATE TABLE ALUNOS (
	Id_aluno VARCHAR(10) PRIMARY KEY,
	Nome VARCHAR(50),
	CPF VARCHAR (14),
	Area_estudo VARCHAR (50),
	Sexo VARCHAR (1),
	data_nasc DATE,
	endereço VARCHAR (150)
	

);


INSERT INTO ALUNOS (Id_aluno, Nome, CPF, Area_estudo, Sexo, data_nasc, endereço ) VALUES
('1', 'Marcelo', '456.876.666.04', 'Front-End', 'M', '06/06/2005', 'Rua Carro 100'),
('2', 'Isabela', '123.321.123.05', 'Front-end', 'F', '17/09/2000', 'Rua Moto 100'),
('3', 'Julia', '567.890.123.06', 'Banco_de_dados','F', '18/10/2001', 'Rua Pedra 100'),
('4', 'Carol', '345.453.123.07', 'Nuvem', 'F', '25/12/2003', 'Rua Agua 100')

-----------------------------------------------------------------------------------------------------------

-- Aqui vão duas chaves estrangeiras
CREATE TABLE AULAS (
	Id_aula VARCHAR (10) PRIMARY KEY,
	data_aula VARCHAR(10),
	Id_professor VARCHAR(10), -- FK
	Id_aluno VARCHAR(10), -- FK
	Área VARCHAR (50),

	

);


--INSERT INTO AULAS (Id_aula, Id_aluno, Id_professor, Área, data_aula) VALUES
('10', '3', '3', 'Banco_de_dados', '10/10/2024'),
('11', '1', '2', 'Front-end', '12/10/2024'),
('12', '2', '2', 'Front-end', '12/10/2024'),
('13', '4', '4', 'Nuvem', '15/10/2024'),
('14', '4', '4', 'Nuvem', '17/10/2024')


ALTER TABLE AULAS
ADD CONSTRAINT Fk_Id_aluno FOREIGN KEY (Id_aluno)
	REFERENCES ALUNOS(Id_aluno)
--------------------------------------------------------------------------------------------------

DROP TABLE PROFESSORES
DROP TABLE ALUNOS
DROP TABLE AULAS

-- sintaxe chaves estrangeiras:
-- CONSTRAINT FK_chave_estrangeira
-- FOREING KEY (nome_da_chave_na_tabela)
-- REFERENCES Tabela(nome_da_chave_na_tabela)
