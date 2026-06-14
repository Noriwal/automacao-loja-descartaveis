-- Tabela de Categorias de Produtos
CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    description TEXT
);

-- Tabela de Produtos
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    category_id INTEGER REFERENCES categories(id),
    image_url VARCHAR(255),
    tags TEXT, -- Tags para busca por imagem ou palavras-chave
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de Histórico de Conversas
CREATE TABLE conversations (
    id SERIAL PRIMARY KEY,
    customer_whatsapp_id VARCHAR(255) NOT NULL,
    message_id VARCHAR(255) NOT NULL UNIQUE,
    sender_type VARCHAR(50) NOT NULL, -- 'customer' ou 'agent'
    message_type VARCHAR(50) NOT NULL, -- 'text', 'audio', 'image'
    content TEXT, -- Conteúdo da mensagem (texto transcrito, descrição da imagem, etc.)
    original_media_url VARCHAR(255), -- URL do áudio ou imagem original, se aplicável
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    -- Opcional: Referência ao produto se a conversa for sobre um item específico
    product_id INTEGER REFERENCES products(id)
);

-- Índices para otimização de busca
CREATE INDEX idx_products_name ON products(name);
CREATE INDEX idx_products_category_id ON products(category_id);
CREATE INDEX idx_conversations_customer_whatsapp_id ON conversations(customer_whatsapp_id);
CREATE INDEX idx_conversations_timestamp ON conversations(timestamp);
