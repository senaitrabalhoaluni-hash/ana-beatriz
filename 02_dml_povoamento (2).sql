
-- =====================================================
-- ARQUIVO: 01_ddl_estrutura_e_seguranca.sql
-- PROJETO: Sistema Omnichannel
-- OBJETIVO: Criar estrutura e configurar acessos
-- =====================================================

CREATE DATABASE IF NOT EXISTS omnichannel_db;
USE omnichannel_db;

-- 1. Tabela de clientes
CREATE TABLE IF NOT EXISTS clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    telefone VARCHAR(20),
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Tabela de produtos
CREATE TABLE IF NOT EXISTS produtos (
    id_produto INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    preco DECIMAL(10,2) NOT NULL,
    estoque_atual INT NOT NULL DEFAULT 0,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT chk_produto_preco CHECK (preco >= 0),
    CONSTRAINT chk_produto_estoque CHECK (estoque_atual >= 0)
);

-- 3. Tabela de canais de atendimento
CREATE TABLE IF NOT EXISTS canais (
    id_canal INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL UNIQUE,
    descricao VARCHAR(200)
);

-- 4. Tabela de pedidos
CREATE TABLE IF NOT EXISTS pedidos (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_canal INT NOT NULL,
    data_pedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM(
        'Pendente',
        'Processando',
        'Concluido',
        'Cancelado'
    ) NOT NULL DEFAULT 'Pendente',
    CONSTRAINT fk_pedido_cliente
        FOREIGN KEY (id_cliente)
        REFERENCES clientes(id_cliente),
    CONSTRAINT fk_pedido_canal
        FOREIGN KEY (id_canal)
        REFERENCES canais(id_canal)
);

-- 5. Tabela de itens dos pedidos
CREATE TABLE IF NOT EXISTS itens_pedido (
    id_item INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL,
    id_produto INT NOT NULL,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_item_pedido
        FOREIGN KEY (id_pedido)
        REFERENCES pedidos(id_pedido),
    CONSTRAINT fk_item_produto
        FOREIGN KEY (id_produto)
        REFERENCES produtos(id_produto),
    CONSTRAINT chk_item_quantidade CHECK (quantidade > 0),
    CONSTRAINT chk_item_preco CHECK (preco_unitario >= 0)
);

-- 6. Tabela de interações de atendimento
CREATE TABLE IF NOT EXISTS atendimentos (
    id_atendimento INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_canal INT NOT NULL,
    data_atendimento TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    assunto VARCHAR(150) NOT NULL,
    descricao TEXT,
    status ENUM(
        'Aberto',
        'Em andamento',
        'Resolvido'
    ) NOT NULL DEFAULT 'Aberto',
    CONSTRAINT fk_atendimento_cliente
        FOREIGN KEY (id_cliente)
        REFERENCES clientes(id_cliente),
    CONSTRAINT fk_atendimento_canal
        FOREIGN KEY (id_canal)
        REFERENCES canais(id_canal)
);

-- =====================================================
-- CONTROLE DE ACESSO (DCL)
-- =====================================================

-- Usuário de consulta: pode apenas visualizar dados
CREATE USER IF NOT EXISTS
    'atendente_omni'@'localhost'
    IDENTIFIED BY 'Troque_Esta_Senha_123!';

GRANT SELECT ON omnichannel_db.*
TO 'atendente_omni'@'localhost';

-- Usuário operacional: pode consultar e registrar dados
CREATE USER IF NOT EXISTS
    'operador_omni'@'localhost'
    IDENTIFIED BY 'Troque_Esta_Senha_456!';

GRANT SELECT, INSERT, UPDATE
ON omnichannel_db.*
TO 'operador_omni'@'localhost';

-- Conferência das permissões
SHOW GRANTS FOR 'atendente_omni'@'localhost';
SHOW GRANTS FOR 'operador_omni'@'localhost';

-- =====================================================
-- FIM DO SCRIPT DDL/DCL
-- =====================================================
