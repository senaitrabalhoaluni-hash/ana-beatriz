-- Exemplo de Trigger de Auditoria de Preços no MySQL
DELIMITER //
CREATE TRIGGER trg_auditoria_preco
AFTER UPDATE ON produtos
FOR EACH ROW
BEGIN
IF OLD.preco <> NEW.preco THEN
INSERT INTO auditoria_preco (id_produto, preco_antigo, preco_novo, data_alteracao, usuario)
VALUES (OLD.id_produto, OLD.preco, NEW.preco, NOW(), USER());
END IF;
END //
DELIMITER ;

UPDATE produtos
SET preco = 25.00
WHERE id_produto = 1;

SELECT * FROM auditoria_preco;