CREATE TABLE Clientes (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    telefone VARCHAR(20),
    email VARCHAR(100) UNIQUE
);

CREATE TABLE Veiculos (
    id_veiculo INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT NOT NULL,
    modelo VARCHAR(100) NOT NULL,
    placa VARCHAR(10) UNIQUE NOT NULL,
    ano INT CHECK (ano >= 1900),
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente)
);

CREATE TABLE Funcionarios (
    id_funcionario INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    cargo VARCHAR(50),
    salario DECIMAL(10,2) CHECK (salario > 0)
);

CREATE TABLE Pecas (
    id_peca INT PRIMARY KEY AUTO_INCREMENT,
    descricao VARCHAR(255) NOT NULL,
    preco DECIMAL(10,2) CHECK (preco >= 0)
);

CREATE TABLE Fornecedores (
    id_fornecedor INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    telefone VARCHAR(20)
);
CREATE TABLE Ordens_Servico (
    id_ordem INT PRIMARY KEY AUTO_INCREMENT,
    id_veiculo INT NOT NULL,
    data_abertura DATE NOT NULL,
    status ENUM('Aberta', 'Em andamento', 'Finalizada') DEFAULT 'Aberta',
    FOREIGN KEY (id_veiculo) REFERENCES Veiculos(id_veiculo)
);
CREATE TABLE Servicos (
    id_servico INT PRIMARY KEY AUTO_INCREMENT,
    descricao VARCHAR(255) NOT NULL,
    preco DECIMAL(10,2) CHECK (preco >= 0)
);

CREATE TABLE Ordem_Servico_Servico (
    id_ordem INT,
    id_servico INT,
    PRIMARY KEY (id_ordem, id_servico),
    FOREIGN KEY (id_ordem) REFERENCES Ordens_Servico(id_ordem),
    FOREIGN KEY (id_servico) REFERENCES Servicos(id_servico)
);

CREATE TABLE Ordem_Servico_Funcionario (
    id_ordem INT,
    id_funcionario INT,
    PRIMARY KEY (id_ordem, id_funcionario),
    FOREIGN KEY (id_ordem) REFERENCES Ordens_Servico(id_ordem),
    FOREIGN KEY (id_funcionario) REFERENCES Funcionarios(id_funcionario)
);
CREATE TABLE Ordem_Servico_Pecas (
    id_ordem INT,
    id_peca INT,
    quantidade INT CHECK (quantidade > 0),
    PRIMARY KEY (id_ordem, id_peca),
    FOREIGN KEY (id_ordem) REFERENCES Ordens_Servico(id_ordem),
    FOREIGN KEY (id_peca) REFERENCES Pecas(id_peca)
);
-- Inserindo Clientes
INSERT INTO Clientes (nome, telefone, email) VALUES 
('João Silva', '21999999999', 'joao@email.com'),
('Maria Oliveira', '21888888888', 'maria@email.com');

-- Inserindo Veículos
INSERT INTO Veiculos (id_cliente, modelo, placa, ano) VALUES
(1, 'Honda Civic', 'ABC-1234', 2018),
(2, 'Toyota Corolla', 'XYZ-5678', 2020);

-- Inserindo Funcionários
INSERT INTO Funcionarios (nome, cargo, salario) VALUES
('Carlos Mecânico', 'Mecânico', 3500.00),
('Ana Souza', 'Mecânica', 3800.00);

-- Inserindo Servicos
INSERT INTO Servicos (descricao, preco) VALUES
('Troca de óleo', 150.00),
('Alinhamento e balanceamento', 200.00),
('Revisão completa', 500.00);

-- Inserindo Pecas
INSERT INTO Pecas (descricao, preco) VALUES
('Óleo sintético 5W30', 50.00),
('Filtro de óleo', 30.00),
('Pneu Michelin', 500.00);

-- Criando Ordens de Servico
INSERT INTO Ordens_Servico (id_veiculo, data_abertura, status) VALUES
(1, '2025-02-01', 'Finalizada'),
(2, '2025-02-10', 'Em andamento');

-- Associando Servicos às Ordens de Servico
INSERT INTO Ordem_Servico_Servico (id_ordem, id_servico) VALUES
(1, 1), -- Troca de óleo na OS 1
(1, 2), -- Alinhamento e balanceamento na OS 1
(2, 3); -- Revisão completa na OS 2

-- Associando Funcionários às Ordens de Servico
INSERT INTO Ordem_Servico_Funcionario (id_ordem, id_funcionario) VALUES
(1, 1), -- Carlos trabalhou na OS 1
(1, 2), -- Ana trabalhou na OS 1
(2, 2); -- Ana trabalhou na OS 2

-- Associando Pecas às Ordens de Servico
INSERT INTO Ordem_Servico_Pecas (id_ordem, id_peca, quantidade) VALUES
(1, 1, 1), -- 1 óleo sintético na OS 1
(1, 2, 1), -- 1 filtro de óleo na OS 1
(2, 3, 4); -- 4 pneus na OS 2
SELECT c.nome AS Cliente, v.modelo AS Veiculo, s.descricao AS Servico, os.data_abertura
FROM Clientes c
JOIN Veiculos v ON c.id_cliente = v.id_cliente
JOIN Ordens_Servico os ON v.id_veiculo = os.id_veiculo
JOIN Ordem_Servico_Servico oss ON os.id_ordem = oss.id_ordem
JOIN Servicos s ON oss.id_servico = s.id_servico
WHERE c.nome = 'João Silva';
SELECT os.id_ordem, 
       SUM(s.preco) AS Total_Servicos, 
       SUM(p.preco * osp.quantidade) AS Total_Pecas,
       (SUM(s.preco) + SUM(p.preco * osp.quantidade)) AS Total_OS
FROM Ordens_Servico os
LEFT JOIN Ordem_Servico_Servico oss ON os.id_ordem = oss.id_ordem
LEFT JOIN Servicos s ON oss.id_servico = s.id_servico
LEFT JOIN Ordem_Servico_Pecas osp ON os.id_ordem = osp.id_ordem
LEFT JOIN Pecas p ON osp.id_peca = p.id_peca
GROUP BY os.id_ordem;
SELECT f.nome AS Mecânico, COUNT(osf.id_ordem) AS Total_Servicos
FROM Funcionarios f
JOIN Ordem_Servico_Funcionario osf ON f.id_funcionario = osf.id_funcionario
GROUP BY f.nome
ORDER BY Total_Servicos DESC;
SELECT c.nome AS Cliente, 
       SUM(s.preco + (p.preco * osp.quantidade)) AS Total_Gasto
FROM Clientes c
JOIN Veiculos v ON c.id_cliente = v.id_cliente
JOIN Ordens_Servico os ON v.id_veiculo = os.id_veiculo
LEFT JOIN Ordem_Servico_Servico oss ON os.id_ordem = oss.id_ordem
LEFT JOIN Servicos s ON oss.id_servico = s.id_servico
LEFT JOIN Ordem_Servico_Pecas osp ON os.id_ordem = osp.id_ordem
LEFT JOIN Pecas p ON osp.id_peca = p.id_peca
GROUP BY c.nome
ORDER BY Total_Gasto DESC;
SELECT s.descricao AS Servico, SUM(s.preco) AS Receita
FROM Servicos s
JOIN Ordem_Servico_Servico oss ON s.id_servico = oss.id_servico
GROUP BY s.descricao
ORDER BY Receita DESC;
