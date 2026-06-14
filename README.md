# 🤖 Automação Loja Descartáveis

Agente de atendimento e vendas via WhatsApp para loja de descartáveis, utilizando **Evolution API**, **N8N** e **OpenAI GPT**.

## 📋 Sobre o Projeto

Sistema de automação de atendimento ao cliente via WhatsApp que:

- Responde dúvidas sobre produtos (descrição, preço, disponibilidade)
- Envia imagens dos produtos do catálogo
- Responde em áudio quando o cliente envia áudio
- Identifica produtos similares a partir de imagens enviadas pelo cliente
- Atendimento natural e amigável usando GPT

## 🏗️ Arquitetura

```
WhatsApp → Evolution API → N8N → OpenAI GPT
                                    ↕
                              PostgreSQL (Catálogo)
```

## 📁 Estrutura do Repositório

```
├── README.md                 # Este arquivo
├── docker-compose.yml        # Deploy completo (Evolution API + N8N + PostgreSQL + Redis)
├── .env.example              # Variáveis de ambiente necessárias
├── docs/
│   ├── PROJETO.md            # Documentação completa do projeto
│   └── prompt-agente.md      # Prompt do agente GPT
├── database/
│   ├── schema.sql            # Schema do banco de dados
│   └── seed.sql              # Dados iniciais (produtos de exemplo)
└── n8n/
    └── README.md             # Instruções para importar fluxos no N8N
```

## 🚀 Quick Start

1. Clone o repositório
2. Copie `.env.example` para `.env` e preencha as variáveis
3. Execute `docker-compose up -d`
4. Acesse o N8N e configure os fluxos
5. Conecte o WhatsApp pela Evolution API

## 📖 Documentação

Consulte a [documentação completa](docs/PROJETO.md) para instruções detalhadas de instalação, configuração e uso.

## 🛠️ Stack Tecnológica

| Componente | Tecnologia |
|---|---|
| Mensageria WhatsApp | Evolution API |
| Orquestração | N8N |
| IA Conversacional | OpenAI GPT-4 |
| Transcrição de Áudio | OpenAI Whisper |
| Geração de Áudio | OpenAI TTS |
| Análise de Imagem | OpenAI GPT-4 Vision |
| Banco de Dados | PostgreSQL |
| Cache | Redis |
| Hospedagem | Hostinger VPS |
| Containerização | Docker + Docker Compose |

## 📄 Licença

Projeto privado - Todos os direitos reservados.
