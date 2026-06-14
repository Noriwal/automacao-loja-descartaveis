# Instruções para Importar Fluxos no N8N

Para importar os fluxos de trabalho (workflows) no N8N, siga os passos abaixo:

1.  **Acesse a Interface do N8N:** Abra seu navegador e vá para `http://seu_ip_vps:5678` (substitua `seu_ip_vps` pelo IP ou domínio do seu servidor).

2.  **Faça Login:** Insira seu nome de usuário e senha configurados durante a primeira inicialização do N8N.

3.  **Crie um Novo Workflow ou Importe:**
    *   **Para criar um novo workflow:** Clique em `New` no canto superior esquerdo e selecione `Workflow`.
    *   **Para importar um workflow existente:** Se você tiver um arquivo JSON de um workflow, clique em `New` > `Workflow` e, em seguida, clique no ícone de "Upload" (seta para cima) ou arraste e solte o arquivo JSON na área de trabalho.

4.  **Configure os Nós:**
    *   **Webhook:** Adicione um nó `Webhook` e configure-o para receber requisições POST no caminho `/webhook/evolution`. Este será o endpoint que a Evolution API chamará.
    *   **Credenciais:** Certifique-se de que as credenciais para a Evolution API e OpenAI estejam configuradas corretamente em `Settings` > `Credentials`.
    *   **Nós da OpenAI:** Configure os nós `Chat Completions`, `Whisper`, `TTS` e `Vision` com suas respectivas credenciais e modelos.
    *   **Nós de Banco de Dados:** Configure os nós de banco de dados para interagir com o PostgreSQL, utilizando as credenciais e o schema definidos.

5.  **Ative o Workflow:** Após configurar todos os nós e testar o fluxo, clique no botão `Active` no canto superior direito para ativar o workflow. Isso fará com que ele comece a escutar os webhooks e processar as mensagens.

**Exemplo de Estrutura de Workflow (JSON):**

Você pode exportar workflows do N8N como arquivos JSON. Um exemplo de workflow para o recebimento de mensagens de texto pode ser:

```json
{
  "nodes": [
    {
      "parameters": {
        "path": "webhook/evolution",
        "httpMethod": "POST",
        "responseMode": "lastNode",
        "options": {}
      },
      "name": "Webhook Evolution API",
      "type": "n8n-nodes-base.webhook",
      "typeVersion": 1,
      "position": [250, 300]
    },
    {
      "parameters": {
        "model": "gpt-4o",
        "messages": [
          {
            "role": "system",
            "content": "{{ $("Prompt do Agente").data.text }}"
          },
          {
            "role": "user",
            "content": "{{ $("Webhook Evolution API").json.body.messages[0].body }}"
          }
        ],
        "options": {}
      },
      "name": "OpenAI GPT",
      "type": "n8n-nodes-base.openAiChatCompletion",
      "typeVersion": 1,
      "position": [500, 300]
    },
    {
      "parameters": {
        "chatId": "{{ $("Webhook Evolution API").json.body.messages[0].from }}",
        "text": "{{ $("OpenAI GPT").json.choices[0].message.content }}",
        "options": {}
      },
      "name": "Enviar Resposta WhatsApp",
      "type": "n8n-nodes-base.whatsappSendText",
      "typeVersion": 1,
      "position": [750, 300]
    }
  ],
  "connections": {
    "Webhook Evolution API": [
      [
        "OpenAI GPT",
        0
      ]
    ],
    "OpenAI GPT": [
      [
        "Enviar Resposta WhatsApp",
        0
      ]
    ]
  ]
}
```

**Observação:** Este é um exemplo simplificado. Os workflows reais podem ser mais complexos, envolvendo nós de banco de dados, lógica condicional e outros serviços da OpenAI (Whisper, TTS, Vision).
