## Esquema Conceitual para Banco de Dados

### Objetivo

Refinar o modelo de banco de dados para incluir:
1. **Clientes PJ e PF**: Uma conta deve ser PJ ou PF, mas não pode ter ambas as informações.
2. **Pagamentos**: Permitir múltiplas formas de pagamento por pedido.
3. **Entregas**: Incluir status e código de rastreio para cada entrega.

### Entidades e Relacionamentos

1. **Clientes**
   - **Clientes**: Armazena informações básicas dos clientes.
   - **Clientes_PJ**: Armazena informações específicas dos clientes PJ.
   - **Clientes_PF**: Armazena informações específicas dos clientes PF.
2. **Pedidos**: Armazena informações dos pedidos realizados.
3. **Pagamentos**: Armazena as diferentes formas de pagamento associadas a um pedido.
4. **Entregas**: Armazena informações de entrega, incluindo status e código de rastreio.

### Modelo Conceitual

![Esquema Conceitual](https://example.com/esquema_conceitual.png)

### Descrição das Entidades

#### Clientes
- **Clientes**: 
  - `id_cliente` (PK)
  - `nome`
  - `endereco`
  - `tipo_cliente` (PJ, PF)

- **Clientes_PJ**:
  - `id_cliente` (PK, FK)
  - `cnpj`
  - `razao_social`

- **Clientes_PF**:
  - `id_cliente` (PK, FK)
  - `cpf`
  - `data_nascimento`

#### Pedidos
- **Pedidos**:
  - `id_pedido` (PK)
  - `id_cliente` (FK)
  - `data_pedido`
  - `total`

#### Pagamentos
- **Pagamentos**:
  - `id_pagamento` (PK)
  - `id_pedido` (FK)
  - `forma_pagamento`
  - `valor`

#### Entregas
- **Entregas**:
  - `id_entrega` (PK)
  - `id_pedido` (FK)
  - `status`
  - `codigo_rastreio`

### Relacionamentos

1. **Clientes**:
   - Um cliente pode ser PJ ou PF, mas não ambos.
   - `Clientes` se relaciona com `Clientes_PJ` e `Clientes_PF` via `id_cliente`.

2. **Pedidos**:
   - Um pedido é feito por um cliente (`id_cliente` como FK em `Pedidos`).

3. **Pagamentos**:
   - Um pedido pode ter múltiplas formas de pagamento (`id_pedido` como FK em `Pagamentos`).

4. **Entregas**:
   - Um pedido tem uma entrega associada (`id_pedido` como FK em `Entregas`).

### Exemplo de Implementação SQL

```sql
CREATE TABLE Clientes (
    id_cliente INT PRIMARY KEY,
    nome VARCHAR(100),
    endereco VARCHAR(255),
    tipo_cliente CHAR(2) CHECK (tipo_cliente IN ('PJ', 'PF'))
);

CREATE TABLE Clientes_PJ (
    id_cliente INT PRIMARY KEY,
    cnpj VARCHAR(14),
    razao_social VARCHAR(100),
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente)
);

CREATE TABLE Clientes_PF (
    id_cliente INT PRIMARY KEY,
    cpf VARCHAR(11),
    data_nascimento DATE,
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente)
);

CREATE TABLE Pedidos (
    id_pedido INT PRIMARY KEY,
    id_cliente INT,
    data_pedido DATE,
    total DECIMAL(10, 2),
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente)
);

CREATE TABLE Pagamentos (
    id_pagamento INT PRIMARY KEY,
    id_pedido INT,
    forma_pagamento VARCHAR(50),
    valor DECIMAL(10, 2),
    FOREIGN KEY (id_pedido) REFERENCES Pedidos(id_pedido)
);

CREATE TABLE Entregas (
    id_entrega INT PRIMARY KEY,
    id_pedido INT,
    status VARCHAR(50),
    codigo_rastreio VARCHAR(100),
    FOREIGN KEY (id_pedido) REFERENCES Pedidos(id_pedido)
);
```

### Consultas Exemplo

Para listar todos os pedidos, formas de pagamento e status de entrega:

```sql
SELECT 
    p.id_pedido,
    c.nome,
    pg.forma_pagamento,
    pg.valor,
    e.status,
    e.codigo_rastreio
FROM 
    Pedidos p
JOIN 
    Clientes c ON p.id_cliente = c.id_cliente
LEFT JOIN 
    Pagamentos pg ON p.id_pedido = pg.id_pedido
LEFT JOIN 
    Entregas e ON p.id_pedido = e.id_pedido;
```

Este modelo conceitual oferece uma estrutura clara e organizada para o gerenciamento de clientes, pagamentos e entregas, conforme os requisitos do desafio.
