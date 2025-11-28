


use restaurante;

CREATE OR REPLACE VIEW resumo_pedido AS
SELECT
    p.id_pedido              AS id_pedido,
    p.quantidade             AS quantidade,
    p.data_pedido            AS data_pedido,
    c.nome                   AS nome_cliente,
    c.email                  AS email_cliente,
    f.nome                   AS nome_funcionario,
    pr.nome                  AS nome_produto,
    pr.preco                 AS preco_produto
FROM pedidos p
LEFT JOIN clientes c
       ON p.id_cliente = c.id_cliente
LEFT JOIN funcionarios f
       ON p.id_funcionario = f.id_cliente
LEFT JOIN produtos pr
       ON p.id_produto = pr.id_produto;
       
       
       
SELECT
    id_pedido,
    nome_cliente,
    quantidade * preco_produto AS total_pedido
FROM resumo_pedido;
      

USE restaurante;

CREATE OR REPLACE VIEW resumo_pedido AS
SELECT
    p.id_pedido              AS id_pedido,
    p.quantidade             AS quantidade,
    p.data_pedido            AS data_pedido,
    c.nome                   AS nome_cliente,
    c.email                  AS email_cliente,
    f.nome                   AS nome_funcionario,
    pr.nome                  AS nome_produto,
    pr.preco                 AS preco_produto,
    (p.quantidade * pr.preco) AS total
FROM pedidos p
LEFT JOIN clientes c
       ON p.id_cliente = c.id_cliente
LEFT JOIN funcionarios f
       ON p.id_funcionario = f.id_cliente
LEFT JOIN produtos pr
       ON p.id_produto = pr.id_produto;
       
       
SELECT
    id_pedido,
    nome_cliente,
    total AS total_pedido
FROM resumo_pedido;


EXPLAIN
SELECT
    id_pedido,
    nome_cliente,
    total AS total_pedido
FROM resumo_pedido;


DELIMITER //

CREATE FUNCTION BuscaIngredientesProduto (p_id_produto INT)
RETURNS TEXT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_ingredientes TEXT;

    SELECT ingredientes
      INTO v_ingredientes
    FROM info_produtos
    WHERE id_produto = p_id_produto
    LIMIT 1;

    RETURN v_ingredientes;
END //

DELIMITER ;
       
      
SELECT BuscaIngredientesProduto(10) AS ingredientes_produto_10;

DELIMITER //

CREATE FUNCTION mediaPedido(p_id_pedido INT)
RETURNS VARCHAR(100)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_total_pedido DECIMAL(10,2);
    DECLARE v_media DECIMAL(10,2);
    DECLARE v_msg VARCHAR(100);

    -- total do pedido informado
    SELECT quantidade * preco
      INTO v_total_pedido
    FROM pedidos
    WHERE id_pedido = p_id_pedido;

    -- média de total de todos os pedidos
    SELECT AVG(quantidade * preco)
      INTO v_media
    FROM pedidos;

    IF v_total_pedido > v_media THEN
        SET v_msg = 'Total do pedido acima da média';
    ELSEIF v_total_pedido < v_media THEN
        SET v_msg = 'Total do pedido abaixo da média';
    ELSE
        SET v_msg = 'Total do pedido igual à média';
    END IF;

    RETURN v_msg;
END //

DELIMITER ;

      
      
SELECT mediaPedido(5) AS resultado_pedido_5;

SELECT mediaPedido(6) AS resultado_pedido_6;
