# ⚡ switch-llm

Gerenciador interativo de providers de LLM para o **Claude Code**. Troque entre diferentes provedores de IA (GLM, DeepSeek, MiniMax, OpenRouter, Sakana AI e outros) diretamente pelo terminal, sem precisar editar arquivos manualmente.

---

## 🎥 Demo

![demo](demo.gif)

> Vídeo completo: [demo.mp4](https://github.com/AndersonHaas/switch-llm/raw/main/demo.mp4)

---

## ✨ Funcionalidades

- Menu interativo com navegação por setas no terminal
- Troca de provider com um clique — reinicie o Claude Code para aplicar
- Gerenciador de modelos para o OpenRouter (adicionar, editar, excluir)
- Restauração rápida para as configurações originais do Claude Code
- Validação de JSON antes de aplicar qualquer configuração
- Suporte ao Sakana AI via proxy local (ccr)
- Não armazena suas API keys — cada usuário configura as suas

---

## 📦 Instalação

### macOS / Linux

```bash
git clone https://github.com/AndersonHaas/switch-llm.git
cd switch-llm
bash install.sh
```

Abra um novo terminal e teste:

```bash
provider
```

### Windows

```powershell
git clone https://github.com/AndersonHaas/switch-llm.git
cd switch-llm
.\install.ps1
```

> **Requisito:** Python 3.8 ou superior instalado e disponível no PATH.

---

## 🚀 Como usar

Digite `provider` no terminal para abrir o menu:

```
  ⚡ Provider Manager — Claude Code
  Ativo: Claude (Autenticado)
  ─────────────────────────────────────

  Claude (Autenticado) ✓
  deepseek
  glm
  minimax-api
  minimax-token
  openrouter  ▸
  sakana
  ───────────────────────────────────
  + Novo provider
  ✎ Editar provider
  ✗ Excluir provider
  ↩ Restaurar original
  ✕ Sair

  ↑↓ navegar   Enter confirmar   q sair
```

> O símbolo `▸` ao lado de **openrouter** indica que ele possui um submenu de modelos.

| Tecla | Ação |
|-------|------|
| `↑` `↓` | Navegar pelos itens |
| `Enter` | Selecionar / confirmar |
| `q` | Sair / voltar |

### Comandos diretos (sem abrir o menu)

```bash
provider glm              # ativa o GLM diretamente
provider deepseek         # ativa o DeepSeek
provider list             # lista todos os providers disponíveis
provider current          # mostra o provider ativo
provider edit deepseek    # edita as configurações do DeepSeek
provider reset            # restaura o Claude Code original
```

---

## 🔑 Configurando suas API keys

Após instalar, edite cada provider para adicionar sua chave:

```bash
provider edit glm
provider edit deepseek
provider edit minimax-api
provider edit minimax-token
provider edit openrouter
provider edit sakana
```

Cada arquivo tem este formato — preencha `ANTHROPIC_AUTH_TOKEN` com sua chave:

```json
{
  "env": {
    "ANTHROPIC_BASE_URL": "https://api.exemplo.com/anthropic",
    "ANTHROPIC_AUTH_TOKEN": "<SUBSTITUA PELO SEU TOKEN>",
    "ANTHROPIC_API_KEY": "",
    "ANTHROPIC_MODEL": "nome-do-modelo"
  }
}
```

---

## 🌐 Providers incluídos

| Provider | URL base | Modelos padrão | Requer |
|----------|----------|----------------|--------|
| **GLM** (Z.AI) | `https://api.z.ai/api/anthropic` | glm-5.2, glm-4.5-air | API key Z.AI |
| **DeepSeek** | `https://api.deepseek.com/anthropic` | deepseek-v4-pro, deepseek-v4-flash | API key DeepSeek |
| **MiniMax API** | `https://api.minimax.io/anthropic` | MiniMax-M3, MiniMax-M2.7-highspeed | API key MiniMax |
| **MiniMax Token** | `https://api.minimax.io/anthropic` | MiniMax-M3, MiniMax-M2.7-highspeed | Token MiniMax |
| **OpenRouter** | `https://openrouter.ai/api` | qualquer modelo do OpenRouter | API key OpenRouter |
| **Sakana AI** | `http://127.0.0.1:8080` (proxy local) | fugu-ultra, fugu | API key Sakana + ccr |

---

## 🔀 OpenRouter — gerenciando modelos

O OpenRouter dá acesso a centenas de modelos. No menu, selecione **openrouter ▸** para abrir o submenu:

```
  ⚡ OpenRouter — modelos
  ─────────────────────────────────────

  moonshotai-kimi-k2.7-code
  ───────────────────────────────────
  + Adicionar modelo
  ✎ Editar modelo
  ✗ Excluir modelo
  ↩ Voltar
```

- **+ Adicionar modelo** — cole o ID do modelo (ex: `deepseek/deepseek-chat`) e o apelido é gerado automaticamente substituindo `/` por `-`
- **✎ Editar modelo** — atualizar o ID de um modelo existente
- **✗ Excluir modelo** — remover da lista

Os modelos ficam salvos em `~/.claude/providers/openrouter-models/` como arquivos JSON individuais.

---

## 🐟 Sakana AI — configuração com proxy (ccr)

O Sakana AI usa uma API proprietária incompatível com o formato Anthropic. Para contornar isso, o switch-llm usa o **[claude-code-router (ccr)](https://github.com/musistudio/claude-code-router)** como proxy local que converte as chamadas automaticamente.

### Instalando o ccr

```bash
npm install -g claude-code-router
```

### Configurando o ccr para Sakana

Crie o arquivo `~/.claude-code-router/config.json` com sua chave da Sakana AI:

```json
{
  "providers": [
    {
      "name": "sakana",
      "api_base_url": "https://api.sakana.ai/v1",
      "api_key": "<SUBSTITUA PELO SEU TOKEN>",
      "models": ["fugu-ultra", "fugu"]
    }
  ],
  "Router": {
    "default": "sakana,fugu-ultra",
    "background": "sakana,fugu",
    "think": "sakana,fugu-ultra",
    "longContext": "sakana,fugu-ultra"
  }
}
```

> **Fugu Ultra** = modelo mais poderoso (equivalente ao Opus)  
> **Fugu** = modelo rápido (equivalente ao Sonnet/Haiku)

### Como funciona

Quando você ativa o provider **sakana**, o switch-llm:
1. Atualiza o config do ccr com o roteamento correto
2. Inicia o ccr automaticamente em `http://127.0.0.1:8080`
3. Configura o Claude Code para usar o proxy local

---

## ➕ Adicionando um novo provider

No menu, escolha **+ Novo provider**, digite o nome e preencha o arquivo que será aberto:

```json
{
  "env": {
    "ANTHROPIC_BASE_URL": "https://url-do-provider.com/anthropic",
    "ANTHROPIC_AUTH_TOKEN": "<SUBSTITUA PELO SEU TOKEN>",
    "ANTHROPIC_API_KEY": "",
    "API_TIMEOUT_MS": "3000000",
    "ANTHROPIC_MODEL": "nome-do-modelo",
    "ANTHROPIC_DEFAULT_SONNET_MODEL": "nome-do-modelo",
    "ANTHROPIC_DEFAULT_OPUS_MODEL": "nome-do-modelo",
    "ANTHROPIC_DEFAULT_HAIKU_MODEL": "nome-do-modelo-rapido"
  },
  "autoUpdatesChannel": "latest"
}
```

---

## 🔄 Atualizando

Para receber novos providers e modelos:

```bash
cd switch-llm
git pull
bash install.sh
```

---

## 📋 Requisitos

- Python 3.8+
- Claude Code instalado
- Terminal com suporte a cores (iTerm2, Terminal.app, Windows Terminal, etc.)
- **Para Sakana AI:** Node.js + `npm install -g claude-code-router`

---

## 📄 Licença

MIT
