

-- ----------------------------------------------------------------------------
-- DML - POPULAÇÃO DO BANCO DE DADOS (MASSA DE TESTES)
-- Este script realiza a carga inicial respeitando a integridade referencial.
-- As inserções em 'pedidos_has_produtos' disparam automaticamente as Triggers
-- de baixa de estoque e recálculo do valor total dos pedidos.
-- ----------------------------------------------------------------------------

INSERT INTO clientes (v_nome_cliente, v_email_cliente, d_adesao_cliente) VALUES 
('Lucas Silva', 'lucas.silva@email.com', '2023-01-15 10:00:00'),
('Mariana Costa', 'mari.costa@email.com', '2023-03-20 14:30:00'),
('Rafael Souze', 'rafa.souza@email.com', '2023-06-10 09:15:00'),
('Fernanda Lima', 'fer.lima@email.com', '2023-08-05 11:45:00'),
('Thiago Rocha', 'thiago.rocha@email.com', '2023-10-12 16:20:00'),
('Beatriz Alves', 'beatriz.alves@email.com', '2024-01-22 13:10:00'),
('Gabriel Nunes', 'gabriel.nunes@email.com', '2024-03-30 17:50:00'),
('Juliana Paes', 'ju.paes@email.com', '2024-05-18 08:30:00'),
('Ricardo Melo', 'ricardo.melo@email.com', '2024-08-14 12:00:00'),
('Camila Bento', 'camila.bento@email.com', '2024-11-01 10:20:00');

INSERT INTO produtos (v_nome_produto, v_categoria_produto, v_descricao_produto, i_estoque_produto, f_precoUnitario_produto) VALUES 
('Mouse Gamer Pro', 'Acessórios', '25000 DPI, Wireless', 100, 350.00),
('Teclado Mecânico RGB', 'Acessórios', 'Switch Blue, ABNT2', 50, 480.00),
('Monitor 144Hz 24"', 'Monitores', 'Painel IPS, 1ms', 25, 1250.00),
('Headset 7.1 Surround', 'Áudio', 'Microfone com cancelamento de ruído', 40, 320.00),
('Cadeira Gamer XL', 'Móveis', 'Ergonômica, Reclinável', 15, 1800.00),
('Webcam 4K UltraHD', 'Vídeo', 'Foco automático, Microfone duplo', 30, 650.00),
('Mousepad Extra Large', 'Acessórios', 'Superfície Speed, 90x40cm', 200, 120.00),
('SSD NVMe 1TB', 'Hardware', 'Leitura 3500MB/s', 60, 450.00),
('Placa de Vídeo RTX', 'Hardware', '8GB GDDR6, Ray Tracing', 10, 3200.00),
('Gabinete Mid Tower', 'Hardware', 'Lateral Vidro Temperado', 20, 380.00);

INSERT INTO pedidos (d_data_pedido, f_valorTotal_pedido, i_id_cliente) VALUES 
('2023-12-10 10:00:00', 830.00, 1),
('2024-01-15 14:00:00', 1250.00, 2),
('2024-02-20 16:30:00', 350.00, 3),
('2025-10-05 09:00:00', 470.00, 6),
('2025-10-20 15:00:00', 120.00, 6), 
('2025-11-05 11:00:00', 3200.00, 7),
('2025-11-25 10:30:00', 450.00, 7), 
('2025-12-01 14:00:00', 1700.00, 8),
('2025-12-10 16:00:00', 470.00, 9),
('2025-12-15 11:00:00', 2250.00, 10),
('2025-12-20 09:00:00', 120.00, 10); 

INSERT INTO pedidos_has_produtos (i_id_pedido, i_id_produto, i_quantidade_pedidosHasProdutos, f_precoVenda_pedidosHasProdutos) VALUES 
(1, 1, 1, 350.00), 
(1, 2, 1, 480.00),
(2, 3, 1, 1250.00),
(3, 1, 1, 350.00),
(4, 1, 1, 350.00), 
(4, 7, 1, 120.00),
(5, 7, 1, 120.00),
(6, 9, 1, 3200.00),
(7, 8, 1, 450.00),
(8, 5, 1, 1800.00),
(9, 1, 1, 350.00), 
(9, 7, 1, 120.00),
(10, 3, 1, 1250.00), 
(10, 6, 1, 650.00), 
(10, 10, 1, 350.00),
(11, 7, 1, 120.00);
