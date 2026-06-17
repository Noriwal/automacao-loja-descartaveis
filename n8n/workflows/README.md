# Workflows N8N - Loja Descartaveis

Este diretório contém fluxos importáveis para iniciar a automação da loja de descartáveis no N8N.

## Ordem recomendada de importação

1. `loja-descartaveis-atendimento-basico.json`
   - Recebe texto da Evolution API.
   - Gera resposta com GPT.
   - Envia resposta ao WhatsApp.

2. `02-catalogo-produtos.json`
   - Consulta produtos no PostgreSQL.
   - Busca por nome, categoria ou tags.

3. `05-memoria-conversa.json`
   - Salva mensagens na tabela `conversations`.
   - Recupera histórico para contexto do GPT.

4. `03-audio-whisper-tts.json`
   - Recebe áudio.
   - Transcreve com Whisper.
   - Responde com GPT.
   - Gera áudio com TTS.

5. `04-imagem-vision-catalogo.json`
   - Recebe imagem.
   - Analisa com GPT Vision.
   - Busca produto similar no catálogo.

6. `06-atendimento-humano.json`
   - Detecta pedido de atendente humano.
   - Registra handoff.
   - Prepara resposta de transferência.

## Uso dos nós da Evolution API

A intenção do projeto é usar os nós da Evolution API dentro do N8N. Como o nome interno do node pode variar de acordo com o pacote instalado, alguns fluxos deixam nós marcados como:

- `Enviar resposta via Evolution API Node`
- `Enviar audio via Evolution API Node`
- `Enviar handoff via Evolution API Node`

Substitua esses nós pelo node da Evolution API instalado no seu N8N, normalmente nas ações equivalentes a:

- Enviar mensagem de texto
- Enviar imagem/mídia
- Enviar áudio
- Buscar ou baixar mídia recebida

## Variáveis necessárias no ambiente do N8N

Configure estas variáveis no `.env` e garanta que o serviço `n8n` receba todas elas:

```env
EVOLUTION_API_URL=http://evolution:8080
EVOLUTION_API_KEY=troque_pela_chave_da_evolution
EVOLUTION_INSTANCE=loja-descartaveis
OPENAI_API_KEY=troque_pela_chave_openai
POSTGRES_DB=automacao_loja_descartaveis
POSTGRES_USER=user
POSTGRES_PASSWORD=password
```

## Credenciais necessárias no N8N

Crie as credenciais abaixo antes de ativar os workflows:

1. PostgreSQL Loja
   - Host: `postgres_db`
   - Database: valor de `POSTGRES_DB`
   - User: valor de `POSTGRES_USER`
   - Password: valor de `POSTGRES_PASSWORD`
   - Port: `5432`

2. OpenAI
   - Pode ser via credencial nativa do N8N ou variável `OPENAI_API_KEY` usada nos HTTP Request.

3. Evolution API
   - Configure no node comunitário/oficial da Evolution API, usando a URL e a chave da instância.

## Observação importante

Os arquivos são templates funcionais para importação e ajustes. Após importar, revise os campos de credenciais e substitua os nós marcados como Evolution API Node pelo node exato disponível na sua instalação do N8N.
