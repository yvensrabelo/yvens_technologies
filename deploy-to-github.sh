#!/bin/bash

# ============================================================================
# YVENS_TECHNOLOGIES v2.0 - Deploy para GitHub
# ============================================================================
# Script para automatizar o deploy do hub v2.0 criptografado para GitHub
# ============================================================================

set -e

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

log() {
    echo -e "${1}${2}${NC}"
}

echo "🚀 YVENS_TECHNOLOGIES v2.0 - Deploy para GitHub"
echo "=============================================="
echo ""

# Verificar se estamos no diretório correto
if [ ! -f "README.md" ] || [ ! -f "encrypt-hub.sh" ]; then
    log $RED "❌ Execute este script de dentro do diretório YVENS_TECHNOLOGIES_v2/"
    exit 1
fi

# Verificar git
if ! command -v git &> /dev/null; then
    log $RED "❌ Git não encontrado!"
    exit 1
fi

log $GREEN "✅ Verificações iniciais OK"
echo ""

# Verificar se hub está criptografado
if [ ! -f "yvens_hub.enc" ]; then
    log $YELLOW "⚠️  Hub não está criptografado"
    log $BLUE "🔐 Executando criptografia primeiro..."
    
    if [ -f "encrypt-hub.sh" ]; then
        chmod +x encrypt-hub.sh
        ./encrypt-hub.sh
        echo ""
    else
        log $RED "❌ Script de criptografia não encontrado!"
        exit 1
    fi
fi

# Verificar repositório git
if [ ! -d ".git" ]; then
    log $CYAN "🔧 Inicializando repositório Git..."
    git init
    
    read -p "📝 Digite a URL do seu repositório GitHub (ex: https://github.com/usuario/yvens_technologies_v2.git): " repo_url
    
    if [ -z "$repo_url" ]; then
        log $RED "❌ URL do repositório é obrigatória"
        exit 1
    fi
    
    git remote add origin "$repo_url"
    log $GREEN "✅ Repositório Git configurado"
else
    log $GREEN "✅ Repositório Git já configurado"
    # Obter URL do remote para mostrar no final
    repo_url=$(git remote get-url origin 2>/dev/null || echo "")
fi

echo ""

# Criar .gitignore se não existir
if [ ! -f ".gitignore" ]; then
    log $BLUE "📝 Criando .gitignore..."
    cat > .gitignore << EOF
# Arquivos temporários
*.tmp
*.temp
*.log
*_temp.tar.gz
yvens_*_install_*/

# Diretórios descriptografados (não versionar)
ferramentas/
projetos/
BMAD/
me-de-um-nome/

# Arquivos sensíveis
*.key
*.pem
.env
.env.*
credentials.env
secrets/

# Cache e builds
node_modules/
dist/
build/
.cache/

# IDEs e editores
.vscode/
.idea/
*.swp
*.swo
*~
.DS_Store
Thumbs.db

# Arquivos de desenvolvimento
.dev_password_hash
.update_log

# Permitir APENAS arquivos seguros para GitHub
!README.md
!install.sh
!encrypt-hub.sh
!deploy-to-github.sh
!yvens_hub.enc
!.gitignore
!VERSION
EOF
    git add .gitignore
fi

# Criar arquivo de versão
if [ ! -f "VERSION" ]; then
    echo "2.0.0" > VERSION
fi

# Preparar commit
log $CYAN "📦 Preparando arquivos para deploy..."

# Adicionar arquivos seguros
git add README.md
git add install.sh
git add encrypt-hub.sh
git add deploy-to-github.sh
git add yvens_hub.enc
git add VERSION
git add .gitignore

echo ""
log $BLUE "📋 Arquivos que serão enviados para GitHub:"
git diff --cached --name-only
echo ""

# Verificar se há mudanças para commit
if git diff --cached --quiet; then
    log $YELLOW "⚠️  Nenhuma mudança para commit"
    log $BLUE "   Todos os arquivos já estão atualizados no GitHub"
else
    # Criar commit
    log $CYAN "💾 Criando commit..."
    commit_message="🚀 YVENS_TECHNOLOGIES v2.0 - Hub Inteligente $(date '+%Y-%m-%d %H:%M')"
    
    if git commit -m "$commit_message"; then
        log $GREEN "✅ Commit criado com sucesso"
    else
        log $RED "❌ Erro ao criar commit"
        exit 1
    fi
fi

echo ""

# Push para GitHub
log $CYAN "🌐 Enviando para GitHub..."
read -p "📤 Fazer push para o repositório remoto? (Y/n): " do_push
do_push=${do_push:-Y}

if [[ $do_push =~ ^[Yy]$ ]]; then
    # Verificar/criar branch main
    if git show-ref --verify --quiet refs/heads/main; then
        current_branch="main"
    else
        current_branch="master"
        git branch -M main
        current_branch="main"
    fi
    
    if git push -u origin $current_branch; then
        log $GREEN "✅ Deploy v2.0 realizado com sucesso!"
        echo ""
        
        # Extrair informações do repositório para URLs
        if [[ "$repo_url" =~ github.com[:/]([^/]+)/([^/.]+) ]]; then
            username="${BASH_REMATCH[1]}"
            repo_name="${BASH_REMATCH[2]%.git}"
            
            log $CYAN "🌐 YVENS_TECHNOLOGIES v2.0 - URLs Importantes:"
            log $GREEN "   📋 Repositório: https://github.com/$username/$repo_name"
            log $GREEN "   🚀 Comando Mundial: curl -sSL https://raw.githubusercontent.com/$username/$repo_name/main/install.sh | bash"
            log $GREEN "   📦 Hub Criptografado: https://raw.githubusercontent.com/$username/$repo_name/main/yvens_hub.enc"
            echo ""
            
            log $CYAN "✨ Recursos v2.0 disponíveis:"
            log $BLUE "   🎯 Instalação sob demanda"
            log $BLUE "   🛠️ Configuração modular"
            log $BLUE "   🚧 Workspace dinâmico"
            log $BLUE "   📦 5 tipos de projeto"
            log $BLUE "   🔒 Máxima segurança"
            
        else
            log $GREEN "   📋 Repositório: $repo_url"
        fi
        
        echo ""
        log $CYAN "🎯 Seu YVENS_TECHNOLOGIES v2.0 está online!"
        log $BLUE "   Usuários podem instalar com o comando único mundial"
        log $BLUE "   Sistema inteligente com instalação personalizada"
        
    else
        log $RED "❌ Erro no push para GitHub"
        log $YELLOW "   Verifique suas credenciais e permissões"
        exit 1
    fi
else
    log $YELLOW "📦 Arquivos preparados mas não enviados"
    log $BLUE "   Execute: git push -u origin main (quando estiver pronto)"
fi

echo ""

# Verificação final de integridade
log $CYAN "🔍 Verificação final:"

# Arquivos críticos
critical_files=("README.md" "install.sh" "yvens_hub.enc")
for file in "${critical_files[@]}"; do
    if git ls-files --error-unmatch "$file" &> /dev/null; then
        log $GREEN "   ✅ $file"
    else
        log $RED "   ❌ $file (não encontrado no repositório)"
    fi
done

echo ""

# Estatísticas v2.0
log $CYAN "📊 Estatísticas YVENS_TECHNOLOGIES v2.0:"
if [ -f "yvens_hub.enc" ]; then
    hub_size=$(du -h yvens_hub.enc | cut -f1)
    log $BLUE "   📦 Hub criptografado: $hub_size"
fi

log $BLUE "   🔒 Segurança: AES-256-CBC com salt"
log $BLUE "   🎯 Tipos de projeto: 5 (WebApp, API, Mobile, BMAD, Custom)"
log $BLUE "   ⚡ Acesso: 5-10 segundos (vs. vários minutos v1)"
log $BLUE "   🛠️ Instalação: Sob demanda (usuário escolhe)"
log $BLUE "   🌐 Distribuição: GitHub público"

echo ""
log $GREEN "🎉 DEPLOY YVENS_TECHNOLOGIES v2.0 CONCLUÍDO!"
log $CYAN "   Hub inteligente pronto para distribuição mundial"
echo ""

log $YELLOW "🚀 Próximos passos sugeridos:"
log $YELLOW "   1. Teste o comando mundial em ambiente limpo"
log $YELLOW "   2. Documente os tipos de projeto disponíveis"  
log $YELLOW "   3. Crie exemplos de uso para cada tipo"
log $YELLOW "   4. Considere criar versões especializadas"
echo ""