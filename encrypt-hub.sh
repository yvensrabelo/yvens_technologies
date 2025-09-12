#!/bin/bash

# ============================================================================
# YVENS_TECHNOLOGIES v2.0 - Criptografia do Hub
# ============================================================================
# Script para criptografar todo o hub v2.0 com senha master
# ============================================================================

set -e

echo "🏢 YVENS_TECHNOLOGIES v2.0 - Criptografia do Hub"
echo "==============================================="
echo ""

# Cores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log() {
    echo -e "${1}${2}${NC}"
}

# Verificar ferramentas
if ! command -v openssl &> /dev/null; then
    log $RED "❌ OpenSSL não encontrado!"
    exit 1
fi

if ! command -v tar &> /dev/null; then
    log $RED "❌ tar não encontrado!"
    exit 1
fi

log $GREEN "✅ Ferramentas disponíveis"
echo ""

log $BLUE "📦 Preparando hub v2.0 para criptografia..."

# Arquivo temporário
TEMP_TAR="yvens_hub_v2_temp.tar.gz"

# Compactar estrutura completa (excluindo scripts de criptografia)
tar -czf "$TEMP_TAR" \
    --exclude="encrypt-hub.sh" \
    --exclude="decrypt-hub.sh" \
    --exclude="*.enc" \
    --exclude=".git" \
    --exclude="*.log" \
    --exclude="yvens_*_install_*" \
    --exclude="$TEMP_TAR" \
    ferramentas/ projetos/ BMAD/ me-de-um-nome/ README.md SYSTEM_GUIDE.md VERSION

if [ ! -f "$TEMP_TAR" ]; then
    log $RED "❌ Erro ao criar arquivo compactado!"
    exit 1
fi

log $GREEN "✅ Hub compactado: $(du -h "$TEMP_TAR" | cut -f1)"
echo ""

# Usar senha padrão para demonstração
MASTER_PASSWORD="yvenstechnologies2024"

log $BLUE "🔐 Usando senha master padrão para criptografia..."
echo ""

# Criptografar com senha
if openssl enc -aes-256-cbc -salt -in "$TEMP_TAR" -out yvens_hub.enc -pass pass:"$MASTER_PASSWORD"; then
    echo ""
    log $GREEN "✅ YVENS_TECHNOLOGIES v2.0 criptografado com sucesso!"
    echo ""
    
    log $BLUE "📁 Arquivos gerados:"
    log $GREEN "   ✅ yvens_hub.enc (criptografado - seguro para GitHub)"
    log $YELLOW "   🗑️  $TEMP_TAR (temporário - será removido)"
    echo ""
    
    # Remover temporário
    rm "$TEMP_TAR"
    log $GREEN "✅ Arquivo temporário removido"
    echo ""
    
    log $BLUE "🔒 Informações importantes:"
    log $GREEN "   • Hub v2.0 protegido por AES-256-CBC"
    log $GREEN "   • Arquivo criptografado é seguro para distribuição"
    log $GREEN "   • Usuários precisarão da senha master para acesso"
    log $GREEN "   • Sistema de instalação sob demanda implementado"
    echo ""
    
else
    log $RED "❌ Erro na criptografia!"
    rm -f "$TEMP_TAR"
    exit 1
fi

log $BLUE "🚀 Próximos passos:"
log $YELLOW "   1. yvens_hub.enc pode ser enviado para GitHub"
log $YELLOW "   2. Use deploy-to-github.sh para automatizar"
log $YELLOW "   3. Teste o comando mundial: install.sh"
echo ""

log $GREEN "🎉 YVENS_TECHNOLOGIES v2.0 pronto para distribuição mundial!"