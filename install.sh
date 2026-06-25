#!/bin/bash

set -e

PROVIDERS_DIR="$HOME/.claude/providers"
BIN_DIR="$HOME/.local/bin"

echo ""
echo "  ⚡ Instalando switch-llm..."
echo ""

# Cria diretórios
mkdir -p "$PROVIDERS_DIR/openrouter-models"
mkdir -p "$BIN_DIR"

# Copia o script
cp provider "$BIN_DIR/provider"
chmod +x "$BIN_DIR/provider"

# Copia providers (sem sobrescrever configs existentes)
for f in providers/*.json; do
  name=$(basename "$f")
  dest="$PROVIDERS_DIR/$name"
  if [ ! -f "$dest" ]; then
    cp "$f" "$dest"
    echo "  + $name"
  else
    echo "  ~ $name (já existe, mantido)"
  fi
done

# Copia modelos do OpenRouter
for f in providers/openrouter-models/*.json; do
  [ -f "$f" ] || continue
  name=$(basename "$f")
  dest="$PROVIDERS_DIR/openrouter-models/$name"
  if [ ! -f "$dest" ]; then
    cp "$f" "$dest"
    echo "  + openrouter-models/$name"
  fi
done

# Adiciona ~/.local/bin ao PATH se necessário
SHELL_RC=""
if [ -n "$ZSH_VERSION" ] || [ "$(basename "$SHELL")" = "zsh" ]; then
  SHELL_RC="$HOME/.zshrc"
elif [ -n "$BASH_VERSION" ] || [ "$(basename "$SHELL")" = "bash" ]; then
  SHELL_RC="$HOME/.bashrc"
fi

if [ -n "$SHELL_RC" ] && ! grep -q 'HOME/.local/bin' "$SHELL_RC" 2>/dev/null; then
  echo '' >> "$SHELL_RC"
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$SHELL_RC"
  echo "  + PATH configurado em $SHELL_RC"
fi

echo ""
echo "  ✓ Instalação concluída!"
echo ""
echo "  Próximos passos:"
echo "  1. Abra um novo terminal (ou rode: source ~/.zshrc)"
echo "  2. Digite: provider"
echo "  3. Edite cada provider para adicionar sua API key"
echo ""
