#!/bin/bash

# ============================================================================
# YVENS ALL - Backup completo do sistema
# ============================================================================
# Salva TUDO incluindo PROJETO_ATUAL e projetos experimentais
# ============================================================================

set -e

# Cores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
NC='\033[0m'

log() {
    echo -e "${1}${2}${NC}"
}

# Banner
echo ""
log $PURPLE "╔════════════════════════════════════════════════════════════════╗"
log $PURPLE "║                    YVENS ALL - Backup Total                    ║"
log $PURPLE "║                  Salvando TODO o ambiente de trabalho          ║"
log $PURPLE "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Verificar se está na pasta correta
if [ ! -d "FERRAMENTAS" ]; then
    log $RED "❌ Execute este comando dentro da pasta yvens_technologies!"
    exit 1
fi

log $BLUE "📦 Preparando backup completo..."
echo ""

# Listar o que será salvo
log $CYAN "📋 Analisando conteúdo:"
if [ -d "PROJETO_ATUAL" ] && [ "$(ls -A PROJETO_ATUAL)" ]; then
    PROJETO_SIZE=$(du -sh PROJETO_ATUAL | cut -f1)
    log $GREEN "   ✅ PROJETO_ATUAL: $PROJETO_SIZE"
else
    log $YELLOW "   ⚠️  PROJETO_ATUAL: Vazio"
fi

if [ -d "FERRAMENTAS" ]; then
    FERRAMENTAS_SIZE=$(du -sh FERRAMENTAS | cut -f1)
    log $GREEN "   ✅ FERRAMENTAS: $FERRAMENTAS_SIZE"
fi

if [ -d "ACOPLAMENTOS" ] && [ "$(ls -A ACOPLAMENTOS)" ]; then
    ACOPLAMENTOS_SIZE=$(du -sh ACOPLAMENTOS | cut -f1)
    log $GREEN "   ✅ ACOPLAMENTOS: $ACOPLAMENTOS_SIZE"
else
    log $YELLOW "   ⚠️  ACOPLAMENTOS: Vazio"
fi

# Verificar projetos salvos (PROJETO_*)
PROJETOS_SALVOS=$(ls -d PROJETO_* 2>/dev/null | grep -v PROJETO_ATUAL || true)
if [ ! -z "$PROJETOS_SALVOS" ]; then
    log $CYAN "   📁 Projetos salvos:"
    for proj in $PROJETOS_SALVOS; do
        PROJ_SIZE=$(du -sh "$proj" | cut -f1)
        log $GREEN "      • $proj: $PROJ_SIZE"
    done
fi
echo ""

# Criar arquivo temporário com TUDO
TEMP_TAR="yvens_hub_temp_all.tar.gz"

log $YELLOW "🔧 Compactando TODO o ambiente..."
tar -czf "$TEMP_TAR" \
    --exclude="*.sh" \
    --exclude="*.enc" \
    --exclude=".git" \
    --exclude="node_modules" \
    --exclude="*.log" \
    --exclude="test_*" \
    --exclude=".DS_Store" \
    FERRAMENTAS/ ACOPLAMENTOS/ BMAD/ PROJETO_ATUAL/ PROJETO_* README.md SYSTEM_GUIDE.md VERSION 2>/dev/null || \
tar -czf "$TEMP_TAR" \
    --exclude="*.sh" \
    --exclude="*.enc" \
    --exclude=".git" \
    --exclude="node_modules" \
    --exclude="*.log" \
    --exclude="test_*" \
    --exclude=".DS_Store" \
    FERRAMENTAS/ ACOPLAMENTOS/ BMAD/ PROJETO_ATUAL/ README.md SYSTEM_GUIDE.md VERSION

if [ ! -f "$TEMP_TAR" ]; then
    log $RED "❌ Erro ao criar arquivo compactado!"
    exit 1
fi

SIZE=$(du -h "$TEMP_TAR" | cut -f1)
log $GREEN "✅ Backup completo: $SIZE"
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
log $YELLOW "🔒 Criptografando backup completo..."
if echo "$MASTER_PASSWORD" | openssl enc -aes-256-cbc -salt -in "$TEMP_TAR" -out yvens_hub.enc -pass stdin; then
    log $GREEN "✅ Backup criptografado com sucesso!"
    rm "$TEMP_TAR"
else
    log $RED "❌ Erro na criptografia!"
    rm "$TEMP_TAR"
    exit 1
fi
echo ""

# Git operations
log $BLUE "📤 Enviando backup completo para GitHub..."
echo ""

git add yvens_hub.enc
git add -u  # Adiciona arquivos modificados

log $CYAN "📝 Mensagem do commit:"
read -p "Digite a mensagem (ou Enter para padrão): " COMMIT_MSG

if [ -z "$COMMIT_MSG" ]; then
    COMMIT_MSG="🎯 Backup: Complete workspace with experiments"
fi

git commit -m "$COMMIT_MSG"
git push origin main

log $GREEN "✅ Backup completo enviado para GitHub!"

echo ""
log $GREEN "🎉 YVENS ALL concluído!"
log $CYAN "   Backup completo salvo incluindo:"
log $GREEN "   • FERRAMENTAS ✅"
log $GREEN "   • ACOPLAMENTOS ✅"
log $GREEN "   • BMAD ✅"
log $GREEN "   • PROJETO_ATUAL ✅"
if [ ! -z "$PROJETOS_SALVOS" ]; then
    log $GREEN "   • Projetos salvos ✅"
fi
echo ""
log $YELLOW "⚠️  Lembre-se: Este backup inclui TODOS os experimentos!"
log $BLUE "💡 Use 'yvens push' para salvar apenas ferramentas/acoplamentos"
echo ""