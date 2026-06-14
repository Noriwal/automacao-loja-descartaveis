# Documentação do Projeto: Automação Loja Descartáveis

## 1. Visão Geral do Projeto

### Resumo Executivo

Este projeto visa implementar um agente de atendimento e vendas automatizado via WhatsApp para uma loja de descartáveis (copos, embalagens, talheres, etc.). A solução será construída utilizando a Evolution API para integração com o WhatsApp, o N8N para orquestração dos fluxos de conversação e a inteligência artificial da OpenAI (GPT, Whisper, TTS, Vision) para proporcionar respostas naturais, amigáveis e funcionalidades avançadas como busca de produtos por imagem e interação por áudio. Toda a infraestrutura será hospedada em um servidor virtual privado (VPS) na Hostinger.

### Requisitos do Agente

O agente de atendimento e vendas terá as seguintes funcionalidades principais:

-   **Atendimento Conversacional via WhatsApp:** Interação contínua com os clientes através da plataforma WhatsApp, utilizando a Evolution API.
-   **Orquestração de Fluxos:** Gerenciamento e automação dos diálogos e processos de vendas através do N8N.
-   **Respostas Naturais e Amigáveis:** Utilização do modelo GPT da OpenAI para gerar respostas contextuais, personalizadas e com uma linguagem natural.
-   **Interação por Áudio:** Capacidade de transcrever mensagens de áudio recebidas (Whisper) e responder em formato de áudio (TTS), proporcionando uma experiência mais acessível e dinâmica.
-   **Busca de Produtos por Imagem:** Os clientes poderão enviar fotos de produtos, e o agente utilizará o GPT Vision para identificar itens similares no catálogo da loja.
-   **Informações Detalhadas de Produtos:** Fornecimento de descrições, imagens e preços dos produtos do catálogo.
-   **Catálogo de Produtos:** Um catálogo inicial com aproximadamente 100 produtos, com estrutura para fácil expansão.
-   **Categorias de Produtos:** Organização dos produtos em categorias como copos descartáveis, embalagens, talheres, com flexibilidade para adicionar novas categorias.
-   **Personalidade do Agente:** O nome e a personalidade do agente serão definidos pelo cliente, permitindo customização da marca.

## 2. Arquitetura do Sistema

```mermaid
graph TD
    A[Cliente WhatsApp] --> B(WhatsApp Business API via Evolution API)
    B --> C(N8N - Orquestrador de Fluxos)
    C --> D{OpenAI GPT - Chat Completions}
    C --> E{OpenAI Whisper - Transcrição de Áudio}
    C --> F{OpenAI TTS - Geração de Áudio}
    C --> G{OpenAI GPT Vision - Análise de Imagem}
    C --> H[Banco de Dados - Catálogo de Produtos, Histórico de Conversas]
    D --> C
    E --> C
    F --> C
    G --> C
    H --> C
    C --> B
    B --> A
    SubGraph Hostinger VPS
        B
        C
        H
    End
```

**Explicação da Arquitetura:**

1.  **Cliente WhatsApp:** O ponto de partida da interação, onde o cliente envia mensagens de texto ou áudio, ou imagens.
2.  **WhatsApp Business API via Evolution API:** A Evolution API atua como a ponte entre o WhatsApp e o restante do sistema, recebendo as mensagens dos clientes e enviando as respostas do agente. Ela é responsável por gerenciar a comunicação com a plataforma WhatsApp.
3.  **N8N - Orquestrador de Fluxos:** O N8N é o coração da automação. Ele recebe os webhooks da Evolution API, interpreta o tipo de mensagem (texto, áudio, imagem), e orquestra os fluxos de trabalho. Ele decide qual serviço da OpenAI deve ser acionado e como interagir com o banco de dados.
4.  **OpenAI GPT - Chat Completions:** Utilizado para processar mensagens de texto, gerar respostas conversacionais e amigáveis, e entender a intenção do usuário.
5.  **OpenAI Whisper - Transcrição de Áudio:** Acionado quando o cliente envia uma mensagem de áudio. Transcreve o áudio para texto, que é então processado pelo GPT.
6.  **OpenAI TTS - Geração de Áudio:** Utilizado para converter as respostas textuais do GPT em áudio, que é então enviado de volta ao cliente via Evolution API, quando a interação inicial foi por áudio.
7.  **OpenAI GPT Vision - Análise de Imagem:** Ativado quando o cliente envia uma imagem. O GPT Vision analisa a imagem para identificar produtos ou características, que são usadas para buscar no catálogo.
8.  **Banco de Dados:** Armazena o catálogo de produtos (nome, descrição, preço, categoria, URL da imagem, tags) e o histórico de conversas para manter o contexto e personalizar o atendimento.

## 3. Stack Tecnológica

A seguir, as tecnologias e serviços que compõem a solução:

| Categoria         | Tecnologia/Serviço | Descrição                                                                                                 |
| :---------------- | :----------------- | :-------------------------------------------------------------------------------------------------------- |
| **Plataforma de Mensagens** | WhatsApp           | Principal canal de comunicação com os clientes.                                                           |
| **Gateway WhatsApp** | Evolution API      | Solução para integração programática com o WhatsApp Business API.                                         |
| **Orquestração/Automação** | N8N                | Ferramenta de automação de fluxos de trabalho (workflow automation) para conectar os diferentes serviços. |
| **Inteligência Artificial** | OpenAI GPT         | Modelo de linguagem para geração de texto e compreensão de linguagem natural.                             |
|                   | OpenAI Whisper     | Modelo de IA para transcrição de fala para texto.                                                         |
|                   | OpenAI TTS         | Modelo de IA para conversão de texto para fala.                                                           |
|                   | OpenAI GPT Vision  | Modelo de IA para análise e compreensão de imagens.                                                       |
| **Hospedagem**    | Hostinger VPS      | Servidor Virtual Privado para hospedar a Evolution API, N8N e o banco de dados.                           |
| **Contêineres**   | Docker             | Plataforma para empacotar e executar aplicações em contêineres isolados.                                  |
|                   | Docker Compose     | Ferramenta para definir e executar aplicações Docker multi-contêineres.                                   |
| **Banco de Dados** | PostgreSQL/MySQL   | Sistema de gerenciamento de banco de dados relacional para armazenar dados de produtos e conversas.       |

## 4. Estrutura do Banco de Dados

### Schema SQL

```sql
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
```

**Explicação do Schema:**

-   **`categories`**: Armazena as categorias dos produtos, permitindo uma organização hierárquica e fácil filtragem.
-   **`products`**: Contém todos os detalhes dos produtos, incluindo nome, descrição, preço, categoria, URL da imagem e um campo `tags` crucial para a busca por imagem (GPT Vision) e por palavras-chave. O `image_url` deve apontar para uma imagem acessível publicamente.
-   **`conversations`**: Registra cada interação entre o cliente e o agente, mantendo um histórico completo. Isso é vital para manter o contexto da conversa, personalizar o atendimento e para futuras análises. Inclui o ID do WhatsApp do cliente, o tipo de remetente (cliente ou agente), o tipo de mensagem (texto, áudio, imagem) e o conteúdo. O `original_media_url` é útil para reprocessamento ou auditoria de mídias.

## 5. Fluxos do N8N

O N8N será configurado com diversos fluxos de trabalho (workflows) para gerenciar as interações com os clientes. Cada fluxo será acionado por um webhook da Evolution API e orquestrará as chamadas para a OpenAI e o banco de dados.

### 5.1. Recebimento de Mensagem de Texto → Processamento GPT → Resposta

**Gatilho:** Webhook da Evolution API (mensagem de texto recebida).

**Fluxo:**
1.  **Webhook:** Recebe a mensagem de texto do cliente via Evolution API.
2.  **Armazenar Conversa:** Salva a mensagem do cliente no banco de dados (`conversations`).
3.  **Preparar Prompt:** Constrói um prompt para o GPT, incluindo a mensagem do cliente e o histórico recente da conversa (para contexto).
4.  **Chamar OpenAI GPT:** Envia o prompt para o modelo GPT (Chat Completions) para gerar uma resposta.
5.  **Processar Resposta:** Extrai a resposta do GPT.
6.  **Armazenar Conversa:** Salva a resposta do agente no banco de dados (`conversations`).
7.  **Enviar Resposta:** Envia a resposta de texto de volta ao cliente via Evolution API.

### 5.2. Recebimento de Áudio → Transcrição (Whisper) → Processamento GPT → Geração de Áudio (TTS) → Envio

**Gatilho:** Webhook da Evolution API (mensagem de áudio recebida).

**Fluxo:**
1.  **Webhook:** Recebe a mensagem de áudio do cliente (URL do arquivo de áudio) via Evolution API.
2.  **Baixar Áudio:** Baixa o arquivo de áudio da URL fornecida.
3.  **Chamar OpenAI Whisper:** Envia o arquivo de áudio para o modelo Whisper para transcrição.
4.  **Armazenar Conversa:** Salva a transcrição do áudio do cliente no banco de dados (`conversations`).
5.  **Preparar Prompt:** Constrói um prompt para o GPT, incluindo a transcrição do áudio e o histórico recente da conversa.
6.  **Chamar OpenAI GPT:** Envia o prompt para o modelo GPT (Chat Completions) para gerar uma resposta de texto.
7.  **Chamar OpenAI TTS:** Envia a resposta de texto do GPT para o modelo TTS para gerar um arquivo de áudio.
8.  **Upload de Áudio:** Faz o upload do arquivo de áudio gerado para um serviço de armazenamento (ex: S3, ou o próprio VPS se configurado para servir arquivos estáticos) e obtém uma URL pública.
9.  **Armazenar Conversa:** Salva a resposta do agente (texto e URL do áudio) no banco de dados (`conversations`).
10. **Enviar Resposta:** Envia a URL do áudio gerado de volta ao cliente via Evolution API.

### 5.3. Recebimento de Imagem → Análise (GPT Vision) → Busca no Catálogo → Resposta com Produto Similar

**Gatilho:** Webhook da Evolution API (mensagem de imagem recebida).

**Fluxo:**
1.  **Webhook:** Recebe a imagem do cliente (URL do arquivo de imagem) via Evolution API.
2.  **Baixar Imagem:** Baixa o arquivo de imagem da URL fornecida.
3.  **Chamar OpenAI GPT Vision:** Envia a imagem para o modelo GPT Vision com um prompt para descrever a imagem e identificar possíveis produtos ou características relevantes.
4.  **Armazenar Conversa:** Salva a descrição da imagem do cliente no banco de dados (`conversations`).
5.  **Processar Descrição:** Extrai palavras-chave ou descrições do resultado do GPT Vision.
6.  **Buscar no Catálogo:** Realiza uma busca no banco de dados (`products`) usando as palavras-chave/descrições e o campo `tags` para encontrar produtos similares.
7.  **Preparar Resposta:** Se produtos similares forem encontrados, formata uma resposta com os detalhes dos produtos (nome, descrição, preço, imagem).
8.  **Chamar OpenAI GPT (Opcional):** Pode-se usar o GPT para refinar a resposta ou adicionar um toque mais conversacional.
9.  **Armazenar Conversa:** Salva a resposta do agente no banco de dados (`conversations`).
10. **Enviar Resposta:** Envia a resposta (texto e/ou imagens dos produtos) de volta ao cliente via Evolution API.

### 5.4. Consulta de Produto por Nome/Categoria

**Gatilho:** Mensagem de texto do cliente que indica intenção de busca por produto (identificada pelo GPT no fluxo 5.1).

**Fluxo (sub-fluxo do 5.1):**
1.  **Identificação de Intenção:** O GPT (no fluxo 5.1) identifica que o cliente deseja consultar um produto por nome ou categoria.
2.  **Extrair Parâmetros:** O GPT extrai o nome do produto ou a categoria da mensagem do cliente.
3.  **Buscar no Banco de Dados:** Consulta a tabela `products` (e `categories`) no banco de dados usando os parâmetros extraídos.
4.  **Preparar Resposta:** Formata uma resposta com os detalhes dos produtos encontrados (nome, descrição, preço, imagem).
5.  **Chamar OpenAI GPT (Opcional):** Pode-se usar o GPT para refinar a resposta ou adicionar um toque mais conversacional.
6.  **Armazenar Conversa:** Salva a resposta do agente no banco de dados (`conversations`).
7.  **Enviar Resposta:** Envia a resposta de texto (e/ou imagens dos produtos) de volta ao cliente via Evolution API.

### 5.5. Envio de Imagem de Produto (pelo Agente)

**Gatilho:** Resposta do GPT que inclui a necessidade de enviar uma imagem de produto (ex: após uma busca bem-sucedida).

**Fluxo (sub-fluxo do 5.1 ou 5.3):**
1.  **Identificação de Necessidade:** O GPT (ou o fluxo de busca por imagem) determina que uma imagem de produto deve ser enviada.
2.  **Obter URL da Imagem:** Recupera a `image_url` do produto do banco de dados.
3.  **Enviar Imagem:** Utiliza a Evolution API para enviar a imagem do produto ao cliente.
4.  **Armazenar Conversa:** Registra o envio da imagem no histórico de conversas (`conversations`).

## 6. Configuração da Evolution API

### 6.1. Instalação e Configuração na Hostinger (VPS)

A Evolution API pode ser instalada via Docker. Assumindo um ambiente Linux (Ubuntu) na Hostinger VPS.

1.  **Acesso SSH:** Conecte-se à sua VPS via SSH.
    ```bash
    ssh usuario@seu_ip_vps
    ```
2.  **Instalar Docker e Docker Compose:** Se ainda não estiverem instalados, siga os passos:
    ```bash
    sudo apt update
    sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update
    sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
    sudo usermod -aG docker $USER
    newgrp docker
    ```
3.  **Criar Diretório para Evolution API:**
    ```bash
    mkdir -p ~/evolution-api
    cd ~/evolution-api
    ```
4.  **Baixar `docker-compose.yml` da Evolution API:** Consulte a documentação oficial da Evolution API para obter o `docker-compose.yml` mais recente. Um exemplo básico pode ser:
    ```yaml
    # Exemplo de docker-compose.yml para Evolution API
    version: '3.8'
    services:
      evolution:
        image: evolutionapi/evolution:latest
        container_name: evolution-api
        restart: always
        ports:
          - "8080:8080" # Porta padrão da Evolution API
        environment:
          # Variáveis de ambiente importantes
          - API_KEY=sua_chave_api_segura
          - API_SECRET=seu_segredo_api_seguro
          - WEBHOOK_URL=http://seu_ip_vps:N8N_PORTA/webhook/evolution # URL do webhook do N8N
          # Outras configurações conforme a documentação da Evolution API
        volumes:
          - ./data:/app/data # Persistência de dados
    ```
    **Importante:** Substitua `sua_chave_api_segura`, `seu_segredo_api_seguro` e `http://seu_ip_vps:N8N_PORTA/webhook/evolution` pelos valores reais. A `WEBHOOK_URL` será o endpoint do N8N que receberá as mensagens do WhatsApp.

5.  **Iniciar Evolution API:**
    ```bash
    docker compose up -d
    ```
    Verifique se o contêiner está rodando:
    ```bash
    docker ps
    ```
6.  **Acessar Interface Web da Evolution API:** Abra seu navegador e acesse `http://seu_ip_vps:8080`. Você precisará escanear o QR Code com seu WhatsApp para conectar uma instância.

## 7. Configuração do N8N

### 7.1. Instalação e Configuração na Hostinger (VPS)

O N8N também pode ser instalado via Docker. Recomenda-se usar Docker Compose para facilitar o gerenciamento.

1.  **Criar Diretório para N8N:**
    ```bash
    mkdir -p ~/n8n
    cd ~/n8n
    ```
2.  **Criar `docker-compose.yml` para N8N:**
    ```yaml
    # Exemplo de docker-compose.yml para N8N
    version: '3.8'
    services:
      n8n:
        image: n8n:latest
        container_name: n8n
        restart: always
        ports:
          - "5678:5678" # Porta padrão do N8N
        environment:
          - N8N_HOST=localhost # Ou seu_ip_vps se for acessar diretamente
          - N8N_PORT=5678
          - N8N_PROTOCOL=http
          - WEBHOOK_URL=http://seu_ip_vps:5678/
          - GENERIC_TIMEZONE=America/Sao_Paulo # Ajuste conforme sua timezone
          - TZ=America/Sao_Paulo
          # Configurações de banco de dados para persistência (opcional, mas recomendado)
          # - DB_TYPE=postgres
          # - DB_POSTGRES_HOST=postgres_db
          # - DB_POSTGRES_DATABASE=n8n
          # - DB_POSTGRES_USER=n8n
          # - DB_POSTGRES_PASSWORD=n8n_password
        volumes:
          - ./data:/home/node/.n8n # Persistência de dados e configurações
        # depends_on:
        #   - postgres_db # Se estiver usando banco de dados externo

      # Exemplo de serviço de banco de dados PostgreSQL para N8N (descomente se for usar)
      # postgres_db:
      #   image: postgres:13
      #   container_name: n8n_postgres_db
      #   restart: always
      #   environment:
      #     - POSTGRES_DB=n8n
      #     - POSTGRES_USER=n8n
      #     - POSTGRES_PASSWORD=n8n_password
      #   volumes:
      #     - ./postgres_data:/var/lib/postgresql/data
    ```
    **Importante:** Substitua `seu_ip_vps` e ajuste a `WEBHOOK_URL` e `GENERIC_TIMEZONE` conforme necessário. Para produção, é altamente recomendado configurar um banco de dados persistente para o N8N (PostgreSQL ou MySQL), descomentando as seções relevantes no `docker-compose.yml` e configurando as variáveis de ambiente.

3.  **Iniciar N8N:**
    ```bash
    docker compose up -d
    ```
    Verifique se o contêiner está rodando:
    ```bash
    docker ps
    ```
4.  **Acessar Interface Web do N8N:** Abra seu navegador e acesse `http://seu_ip_vps:5678`. Na primeira vez, você será guiado para criar um usuário e senha.

### 7.2. Configuração de Credenciais no N8N

Dentro do N8N, você precisará configurar as credenciais para a Evolution API e a OpenAI.

1.  **Credencial Evolution API:**
    -   Vá para `Settings` > `Credentials`.
    -   Clique em `New Credential`.
    -   Procure por `Evolution API` ou use `HTTP Request` para configurar manualmente.
    -   Insira a `API Key` e `API Secret` que você definiu no `docker-compose.yml` da Evolution API.
    -   O `Base URL` será `http://localhost:8080` (se o N8N e Evolution estiverem na mesma máquina e se comunicando via rede Docker) ou `http://seu_ip_vps:8080`.

2.  **Credencial OpenAI:**
    -   Vá para `Settings` > `Credentials`.
    -   Clique em `New Credential`.
    -   Procure por `OpenAI API`.
    -   Insira sua `API Key` da OpenAI. Você pode obtê-la em [platform.openai.com](https://platform.openai.com/).

## 8. Configuração da OpenAI

Para este projeto, serão utilizadas as seguintes APIs da OpenAI:

-   **Chat Completions API (GPT):** Para o atendimento conversacional, geração de respostas e compreensão da intenção do usuário. Modelos recomendados: `gpt-4o`, `gpt-4-turbo` ou `gpt-3.5-turbo` (para menor custo).
-   **Whisper API:** Para transcrição de mensagens de áudio enviadas pelos clientes.
-   **Text-to-Speech (TTS) API:** Para converter as respostas textuais do agente em áudio, quando necessário.
-   **GPT Vision API:** Para análise de imagens enviadas pelos clientes e identificação de produtos no catálogo. Este é um recurso do modelo `gpt-4o` ou `gpt-4-turbo` com capacidade de visão.

Você precisará de uma chave de API da OpenAI, que pode ser gerada e gerenciada em [platform.openai.com/api-keys](https://platform.openai.com/api-keys).

## 9. Prompt do Agente

O prompt system é crucial para definir a personalidade e o comportamento do agente GPT. Ele será configurado no nó da OpenAI no N8N.

```
Você é um assistente de vendas e atendimento ao cliente amigável e prestativo para a loja de descartáveis "Loja Descartáveis". Seu nome é [Nome do Agente]. Seu principal objetivo é ajudar os clientes a encontrar produtos, fornecer informações detalhadas, responder a perguntas e auxiliar no processo de compra. Mantenha um tom de voz cordial, profissional e sempre ofereça ajuda adicional.

**Instruções:**
-   Sempre responda em português brasileiro.
-   Seja conciso, mas informativo.
-   Quando um cliente perguntar sobre um produto, tente identificar o nome ou a categoria e ofereça-se para buscar no catálogo.
-   Se o cliente enviar uma imagem, mencione que você está analisando a imagem para encontrar produtos similares.
-   Se não conseguir encontrar um produto ou responder a uma pergunta, peça desculpas e ofereça alternativas ou a opção de falar com um atendente humano (se aplicável).
-   Mantenha o contexto da conversa. Se o cliente já perguntou sobre um tipo de produto, use isso para refinar futuras buscas.
-   Não invente informações sobre produtos. Se não tiver certeza, diga que vai verificar.
-   Evite jargões técnicos. Use uma linguagem simples e clara.
-   Sempre finalize a interação perguntando se há algo mais em que possa ajudar.

**Informações do Catálogo (Exemplo - o N8N injetará os dados reais aqui):
**
```json
[
  {
    "id": 1,
    "name": "Copo Descartável 200ml",
    "description": "Copo plástico transparente ideal para água e refrigerante. Pacote com 100 unidades.",
    "price": 12.50,
    "category": "Copos Descartáveis",
    "tags": "copo, plástico, transparente, 200ml, água, refrigerante"
  },
  {
    "id": 2,
    "name": "Embalagem para Bolo Pequeno",
    "description": "Embalagem de plástico com tampa articulada, ideal para fatias de bolo ou doces pequenos. Pacote com 50 unidades.",
    "price": 25.00,
    "category": "Embalagens",
    "tags": "embalagem, bolo, doce, plástico, pequena, fatia"
  }
]
```

**Histórico da Conversa (Exemplo - o N8N injetará o histórico real aqui):
**
```json
[
  {"role": "user", "content": "Olá, você tem copos para festa?"},
  {"role": "assistant", "content": "Olá! Sim, temos diversos tipos de copos descartáveis para festa. Você procura algo específico, como copos coloridos ou de um tamanho em particular?"}
]
```

**Mensagem Atual do Usuário:**
{user_message}
```

**Placeholder:**
-   `[Nome do Agente]`: Será substituído pelo nome escolhido para o agente (ex: "Manu", "Bot da Loja").
-   `{user_message}`: Será substituído pela mensagem atual do cliente.
-   O N8N será responsável por injetar dinamicamente as `Informações do Catálogo` (filtradas por relevância) e o `Histórico da Conversa` no prompt antes de enviá-lo à OpenAI.

## 10. Guia de Deploy

Este guia detalha os passos para realizar o deploy completo da solução na Hostinger VPS utilizando Docker Compose.

### 10.1. Pré-requisitos

-   Hostinger VPS com Ubuntu (ou outra distribuição Linux compatível com Docker).
-   Acesso SSH à VPS.
-   Docker e Docker Compose instalados (conforme Seção 6.1).
-   Conta na OpenAI com chave de API ativa.
-   Conta na Evolution API (ou instância self-hosted configurada).

### 10.2. Estrutura de Diretórios na VPS

Recomenda-se a seguinte estrutura de diretórios para organizar os serviços:

```
/home/ubuntu/
├── evolution-api/
│   ├── docker-compose.yml
│   └── data/ (para persistência da Evolution API)
├── n8n/
│   ├── docker-compose.yml
│   └── data/ (para persistência do N8N)
│   └── postgres_data/ (se usar PostgreSQL para N8N)
└── automacao-loja-descartaveis/ (diretório para scripts de inicialização, etc.)
```

### 10.3. Passos do Deploy

1.  **Conectar via SSH:**
    ```bash
    ssh usuario@seu_ip_vps
    ```
2.  **Atualizar Sistema e Instalar Docker/Docker Compose:** Siga os passos da Seção 6.1 se ainda não o fez.

3.  **Configurar Evolution API:**
    a.  Crie o diretório e o `docker-compose.yml` conforme a Seção 6.1.
    b.  Edite o `docker-compose.yml` da Evolution API com sua `API_KEY`, `API_SECRET` e, **muito importante**, a `WEBHOOK_URL` apontando para o N8N (ex: `http://seu_ip_vps:5678/webhook/evolution`).
    c.  Inicie o serviço:
        ```bash
        cd ~/evolution-api
        docker compose up -d
        ```
    d.  Acesse a interface web da Evolution API (`http://seu_ip_vps:8080`) e conecte sua instância do WhatsApp.

4.  **Configurar N8N:**
    a.  Crie o diretório e o `docker-compose.yml` conforme a Seção 7.1.
    b.  Edite o `docker-compose.yml` do N8N. Se for usar um banco de dados persistente (altamente recomendado), descomente as seções do PostgreSQL e ajuste as variáveis de ambiente.
    c.  Inicie o serviço:
        ```bash
        cd ~/n8n
        docker compose up -d
        ```
    d.  Acesse a interface web do N8N (`http://seu_ip_vps:5678`) e configure seu usuário e senha.
    e.  Configure as credenciais para Evolution API e OpenAI no N8N (Seção 7.2).

5.  **Criar Fluxos no N8N:**
    a.  No N8N, crie um novo workflow.
    b.  Adicione um nó `Webhook` e configure-o para receber requisições POST no caminho `/webhook/evolution`. Este será o endpoint que a Evolution API chamará.
    c.  Conecte este `Webhook` aos nós de lógica para processar mensagens de texto, áudio e imagem, conforme detalhado na Seção 5.
    d.  Configure os nós da OpenAI (Chat Completions, Whisper, TTS, Vision) usando as credenciais criadas.
    e.  Configure os nós de banco de dados para interagir com o PostgreSQL/MySQL (se estiver usando um).
    f.  Ative o workflow.

6.  **Configurar Banco de Dados (se não for via Docker Compose do N8N):**
    Se você optar por um banco de dados separado (não gerenciado pelo `docker-compose.yml` do N8N), instale-o e configure-o. Por exemplo, para PostgreSQL:
    ```bash
    sudo apt install postgresql postgresql-contrib -y
    sudo -i -u postgres
    createuser --interactive
    createdb --interactive
    exit
    ```
    Crie as tabelas `categories`, `products` e `conversations` usando o schema SQL da Seção 4.

7.  **Popular Catálogo de Produtos:** Insira os ~100 produtos iniciais e suas categorias no banco de dados `products` e `categories`.

### 10.4. Considerações de Segurança

-   **Firewall:** Configure o firewall da VPS (ex: `ufw`) para permitir apenas as portas necessárias (SSH, 8080 para Evolution API, 5678 para N8N, e portas do banco de dados se acessível externamente).
-   **Variáveis de Ambiente:** Nunca exponha chaves de API diretamente no código ou em repositórios públicos. Use variáveis de ambiente ou segredos do Docker.
-   **HTTPS:** Para acesso público ao N8N ou Evolution API, considere configurar um proxy reverso (Nginx ou Caddy) com certificados SSL (Let's Encrypt) para habilitar HTTPS.

## 11. Estrutura de Custos Estimada

Esta é uma estimativa de custos mensais, que pode variar significativamente dependendo do volume de uso e dos planos de cada serviço.

| Serviço           | Item de Custo                                | Estimativa Mensal (USD) | Observações                                                                                                                               |
| :---------------- | :------------------------------------------- | :---------------------- | :---------------------------------------------------------------------------------------------------------------------------------------- |
| **Hostinger VPS** | Plano KVM 2 ou KVM 4 (2-4 vCPU, 4-8 GB RAM)  | 10 - 30                 | Suficiente para hospedar Evolution API, N8N e banco de dados. O custo varia com os recursos.                                              |
| **OpenAI**        | GPT-4o (tokens de entrada/saída)             | 5 - 50+                 | Varia muito com o volume de mensagens e complexidade das interações. GPT-3.5-turbo é mais barato.                                         |
|                   | Whisper API (áudio para texto)               | 1 - 10+                 | Baseado na duração do áudio transcrito.                                                                                                   |
|                   | TTS API (texto para áudio)                   | 1 - 10+                 | Baseado na quantidade de texto convertido para áudio.                                                                                     |
|                   | GPT Vision API (análise de imagem)           | 5 - 20+                 | Custo por imagem analisada, dependendo da resolução e complexidade.                                                                       |
| **Evolution API** | Licença/Serviço (se não for self-hosted)     | 0 - 50+                 | Se for self-hosted, o custo é apenas da VPS. Se usar um serviço gerenciado, pode haver uma taxa mensal.                                 |
| **N8N**           | Open Source (self-hosted)                    | 0                       | O N8N é open source e pode ser self-hosted sem custo de licença. O custo é apenas da infraestrutura.                                     |
| **Domínio/SSL**   | Registro de Domínio e Certificado SSL        | 1 - 10                  | Opcional, mas recomendado para um acesso profissional e seguro (HTTPS).                                                                   |
| **Total Estimado**|                                              | **17 - 170+**           | Esta é uma estimativa ampla. O custo real dependerá do uso e das escolhas de serviço.                                                    |
