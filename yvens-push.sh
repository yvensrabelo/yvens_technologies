#!/bin/bash

# ============================================================================
# YVENS PUSH - Salva apenas ferramentas e acoplamentos
# ============================================================================
# Atualiza o hub no GitHub mantendo PROJETO_ATUAL local
# ============================================================================

set -e

# Cores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

log() {
    echo -e "${1}${2}${NC}"
}

# Banner
echo ""
log $CYAN "╔════════════════════════════════════════════════════════════════╗"
log $CYAN "║                    YVENS PUSH - Hub Update                     ║"
log $CYAN "║                  Salvando ferramentas e acoplamentos           ║"
log $CYAN "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Verificar se está na pasta correta
if [ ! -d "FERRAMENTAS" ] || [ ! -d "ACOPLAMENTOS" ]; then
    log $RED "❌ Execute este comando dentro da pasta yvens_technologies!"
    exit 1
fi

log $BLUE "📦 Preparando hub para atualização..."
echo ""

# Criar arquivo temporário excluindo PROJETO_ATUAL
TEMP_TAR="yvens_hub_temp_push.tar.gz"

log $YELLOW "🔧 Compactando estrutura (excluindo PROJETO_ATUAL)..."
tar -czf "$TEMP_TAR" \
    --exclude="PROJETO_ATUAL" \
    --exclude="*.sh" \
    --exclude="*.enc" \
    --exclude=".git" \
    --exclude="*.log" \
    --exclude="test_*" \
    FERRAMENTAS/ ACOPLAMENTOS/ BMAD/ README.md SYSTEM_GUIDE.md VERSION

if [ ! -f "$TEMP_TAR" ]; then
    log $RED "❌ Erro ao criar arquivo compactado!"
    exit 1
fi

SIZE=$(du -h "$TEMP_TAR" | cut -f1)
log $GREEN "✅ Hub compactado: $SIZE"
echo ""

# Solicitar senha
log $BLUE "🔐 Digite a SENHA MASTER para criptografar:"
read -s -p "🔑 Senha: " MASTER_PASSWORD
echo ""
echo ""

if [ -z "$MASTER_PASSWORD" ]; then
    log $RED "❌ Senha não pode ser vazia!"
    rm "$TEMP_TAR"
    exit 1
fi

# Criptografar
log $YELLOW "🔒 Criptografando hub..."
if echo "$MASTER_PASSWORD" | openssl enc -aes-256-cbc -salt -in "$TEMP_TAR" -out yvens_hub.enc -pass stdin; then
    log $GREEN "✅ Hub criptografado com sucesso!"
    rm "$TEMP_TAR"
else
    log $RED "❌ Erro na criptografia!"
    rm "$TEMP_TAR"
    exit 1
fi
echo ""

# Git operations
log $BLUE "📤 Enviando para GitHub..."
echo ""

# Verificar mudanças
if git diff --quiet yvens_hub.enc 2>/dev/null; then
    log $YELLOW "⚠️  Nenhuma alteração detectada no hub"
else
    git add yvens_hub.enc
    git add -u  # Adiciona arquivos modificados
    
    log $CYAN "📝 Mensagem do commit:"
    read -p "Digite a mensagem (ou Enter para padrão): " COMMIT_MSG
    
    if [ -z "$COMMIT_MSG" ]; then
        COMMIT_MSG="🔧 Update: Hub tools and components"
    fi
    
    git commit -m "$COMMIT_MSG"
    git push origin main
    
    log $GREEN "✅ Hub atualizado no GitHub!"
fi

echo ""
log $GREEN "🎯 YVENS PUSH concluído!"
log $CYAN "   • FERRAMENTAS: Salvo ✅"
log $CYAN "   • ACOPLAMENTOS: Salvo ✅"
log $CYAN "   • BMAD: Salvo ✅"
log $YELLOW "   • PROJETO_ATUAL: Mantido local ⚠️"
echo ""
log $BLUE "💡 Use 'yvens all' para salvar tudo incluindo PROJETO_ATUAL"
echo ""