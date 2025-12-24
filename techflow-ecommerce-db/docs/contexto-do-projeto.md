# Mini Mundo — TechFlow
O sistema da **TechFlow** gerencia um e-commerce de periféricos gamer, onde o fluxo
operacional inicia-se no cadastro de clientes, que fornecem nome, e-mail e data de
adesão à plataforma.Cada produto do catálogo possui descrição e preço unitário fixo, sendo comercializado por meio de pedidos que registram a data da transação e o valor total acumulado.
Como um pedido pode conter múltiplos produtos em quantidades variadas, existe uma
estrutura intermediária responsável por vincular cada produto ao seu respectivo pedido,
registrando o preço praticado no momento da venda, garantindo a integridade histórica
das informações mesmo em caso de alteração futura no valor do catálogo.
O banco de dados deve permitir o rastreamento do comportamento histórico dos clientes,
possibilitando identificar períodos de inatividade, desempenho de vendas por categoria
de produto e recorrência mensal de compras, informações essenciais para decisões
estratégicas de marketing e controle de estoque.

## Requisitos Funcionais
- Cadastrar clientes
- Cadastrar produtos
- Registrar pedidos
- Registrar itens de pedidos
- Consultar histórico de compras

## Regras de Negócio
- Um pedido deve estar associado a um único cliente
- Um pedido pode conter múltiplos produtos
- O preço do produto no pedido deve refletir o valor no momento da venda
- O valor total do pedido deve ser calculado automaticamente
