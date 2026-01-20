# Questão 01: Oficina Mecânica

1. Registrar vendas de peças
2. Registrar consertos de automóveis e a data desses consertos
3. Registrar dados do cliente (nome e CPF)
4. Registrar as peças disponíveis em estoque e o valor de cada peça
5. Registrar a quantidade de peças utilizadas em um conserto
6. Registrar dados do automóvel (placa, cor e modelo)
7. Registrar dados do funcionário responsável pelo conserto

# Questão 02: Gerenciar Unidades no Shopping

1. Registrar unidades do shopping (número do andar, metragem quadrada, valor atual do aluguel e categoria)
2. Registrar dados do proprietário de cada unidade (nome e CPF)
3. Registrar a associação entre unidade e proprietário
4. Registrar faturas mensais de cada unidade
5. Registrar dados das faturas (data de vencimento, data de pagamento, status da fatura e valor do aluguel no momento da fatura)
6. Registrar os horários de funcionamento de cada unidade
7. Registrar dados do funcionamento por dia da semana (dia da semana, horário de abertura e horário de fechamento)

# Questão 03: Zoológico

1. Registrar todos os animais disponíveis no zoológico e a quantidade por espécie.
2. Registrar os funcionários do zoológico, incluindo vendedores de ingressos e cuidadores de animais.
3. Registrar a relação entre cuidadores e animais, onde cada cuidador pode ser responsável por vários animais e cada animal possui apenas um cuidador.
4. Registrar vendas de ingressos com base em tipos de ingresso, variando por preço e faixa etária (idade mínima e máxima).
5. Registrar a data da venda e o valor total da venda.
6. Registrar clientes que realizam compras de ingressos.
7. Registrar a quantidade de ingressos adquiridos por um cliente em uma única venda.

# Questão 04: Reservas de Salas

1. Registrar os prédios disponíveis para locação de salas.
2. Registrar as salas existentes em cada prédio.
3. Registrar dados das salas, incluindo número identificador e valor de locação.
4. Registrar dados dos clientes que realizam a locação (nome e CPF).
5. Registrar as reservas de salas realizadas pelos clientes.
6. Registrar a data de entrada e a data de saída de cada reserva.
7. Registrar o valor total da locação de cada reserva.

# Questão 05: Empresa de Logística

1. Registrar dados dos fornecedores (CNPJ e nome).
2. Registrar dados dos fabricantes (apenas o nome).
3. Registrar a relação de fornecimento, onde cada fornecedor pode fornecer produtos de mais de um fabricante.
4. Registrar o cadastro de produtos vinculados aos seus respectivos fornecedores.
5. Registrar a relação direta entre o produto e o fabricante que o produziu.
6. Registrar os lotes e sua numeração identificadora.
7. Registrar a composição dos lotes, onde cada lote pode conter muitos produtos.

# Questão 06: Sistema Pizzaria

1. Registrar dados do cliente (nome, telefone e endereço para fazer as entregas).
2. Registrar dados de todas as pizzas disponíveis (nome da pizza e descrição mais detalhada).
3. Registrar os tamanhos das pizzas e os preços correspondentes conforme o tamanho.
4. Registrar a associação entre pizza e tamanho através de uma entidade associativa (cardápio) para definir o valor de cada combinação.
5. Registrar dados de toda a compra (valor total da compra, data e hora).
6. Registrar a relação entre o pedido e os itens escolhidos através de uma entidade (tem_pedido) que registre a quantidade adquirida.
7. Registrar quais pizzas e de quais tamanhos cada cliente comprou em cada pedido realizado.

# Questão 07: Internação no Hospital

1. Registrar os dados dos pacientes como nome, CPF e data de nascimento.
2. Registrar os dados do responsável do paciente caso ele seja menor de idade, sendo que cada paciente poderá ter apenas um responsável.
3. Registrar dados das consultas dos pacientes, onde diariamente os médicos vão até os quartos para fazer a consulta diária com cada paciente em uma cama.
4. Registrar todos os quartos disponíveis no hospital, sua numeração e em qual andar o quarto está.
5. Registrar todas as camas que estão dentro dos quartos.
6. Registrar todas as informações de remédios passados pelos médicos para cada paciente durante as consultas diárias, armazenando o remédio, a data de início e a data final.
7. Registrar se um paciente mudou de um quarto para outro e os dados do médico.
8. Do médico armazenar nome e documento (CRM)

# Questão 08: Plataforma de Filmes

1. O sistema deve permitir o armazenamento dos dados fundamentais do cliente, incluindo nome, e-mail único, senha criptografada e um campo booleano para indicar se a conta está ativa ou inativa.
2. Deve ser possível cadastrar diferentes categorias de planos. Cada plano deve ter um nome, um valor de assinatura específico e uma regra de negócio que defina a quantidade máxima de IPs (dispositivos) permitidos simultaneamente.
3. O sistema deve permitir que cada conta de cliente gerencie múltiplas telas (perfis). Para cada tela, devem ser registrados o nome de exibição e o identificador/caminho do ícone de avatar escolhido.
4. Deve-se registrar a forma de pagamento preferencial que o cliente utilizará para as cobranças mensais. Isso inclui o armazenamento seguro de números de cartões (crédito/débito) ou chaves Pix que estiverem marcadas como ativas para o faturamento recorrente
5. O sistema deve gerar faturas para cada conta, contendo obrigatoriamente a data de vencimento e o status do pagamento.
6. Como regra de integridade, a entidade Fatura deve registrar o valor exato cobrado e a forma de pagamento utilizada no ato da transação. Esses dados devem ser independentes de alterações futuras na tabela de Planos ou de trocas de cartão pelo cliente, garantindo a precisão do histórico financeiro e de auditoria.

# Questão 09: Rede Social

1. O sistema deve permitir o cadastro de usuários, armazenando informações como nome, data de nascimento, e-mail e senha.
2. Os usuários devem poder criar postagens, contendo texto, imagem e localização. As postagens poderão ser classificadas em diferentes tipos, como reels ou stories.
3. O sistema deve permitir que os usuários comentem nas postagens, registrando o texto do comentário, bem como a data e a hora em que foi realizado.
4. Deve ser possível registrar as marcações de pessoas em postagens, permitindo identificar quais usuários foram mencionados.
5. O sistema deve permitir o registro de curtidas nas postagens, sendo que cada curtida pode possuir diferentes tipos de reações, como like, coração e tristeza.

# Questão 10: Sistema Farmácia:

1. O sistema deve permitir gerenciar as vendas realizadas e também dados de fornecedores, como os preços dos remédios fornecidos por eles.
2. Deve permitir registrar os dados dos remédios disponíveis, como nome, descrição da bula, valor e quantidade de unidades no estoque.
3. Deve armazenar os dados do cliente, como CPF e nome.
4. O sistema deve permitir registrar todos os remédios vendidos para todos os clientes cadastrados no sistema; deve ser registrado se o remédio possui uma receita ou não, e a data da compra.
5. Deve armazenar dados de fornecedores, ou seja, quem fornece os medicamentos para esta farmácia, como CNPJ, nome do fornecedor e quais remédios ele fornece com os preços de cada fornecedor.

# Questão 11: Sistema Cinema
1. Este sistema deve ser permitir gerenciar o cadastro de clientes que são as pessoas que vão assistir aos filmes, elas devem apresentar o seu RG e o nome para verificar se são maiores de idade e registrar que essa pessoa assistiu à determinado filme.
2. Um cliente pode comprar mais de um ingresso.
3. Deve permitir também o registro de filmes existentes nesse cinema como o seu nome, categoria e faixa etária.
4. Deve ser armazenado os dados das salas disponíveis para assistir aos filmes como o número da sala, descrição da sala categoria da sala exemplo: se ela é uma sala vip ou uma sala específica para assistir 3D.
5. Deve guardar as informações do filme como horários, valores de ingressos ou seja deve permitir fazer o cadastro do cliente quando ele chega no cinema e poder gerar então através dos dados cadastrados no sistema qual filme ele vai assistir, qual horário e qual preço para que tudo isso seja guardado e administrado pelo gerente deste setor.