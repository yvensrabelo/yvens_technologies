#!/bin/bash

# ============================================================================
# YVENS_TECHNOLOGIES v2.0 - Instalador Inteligente
# ============================================================================
# Sistema otimizado de instalação sob demanda com workspace dinâmico
# curl -sSL https://raw.githubusercontent.com/yvensrabelo/yvens_technologies_v2/main/install.sh | bash
# ============================================================================

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Função para log colorido
log() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Banner v2.0
show_banner() {
    clear
    log $CYAN "╔════════════════════════════════════════════════════════════════╗"
    log $CYAN "║                                                                ║"
    log $CYAN "║              🏢 YVENS_TECHNOLOGIES v2.0 🏢                     ║"
    log $CYAN "║                                                                ║"
    log $CYAN "║          Hub Inteligente - Instalação Sob Demanda             ║"
    log $CYAN "║                                                                ║"
    log $CYAN "║    \"Configuração Personalizada, Performance Otimizada\"        ║"
    log $CYAN "║                                                                ║"
    log $CYAN "╚════════════════════════════════════════════════════════════════╝"
    echo ""
    log $GREEN "🌟 Bem-vindo ao Sistema Inteligente YVENS_TECHNOLOGIES"
    log $BLUE "📅 $(date)"
    log $YELLOW "⚡ Acesso rápido • 🎯 Instalação sob demanda • 🛠️ Configuração modular"
    echo ""
}

# Verificar pré-requisitos básicos
check_basic_requirements() {
    log $CYAN "🔍 Verificando pré-requisitos básicos..."
    
    local missing_tools=()
    
    # Essenciais para descriptografia
    for tool in curl openssl tar; do
        if ! command -v $tool &> /dev/null; then
            missing_tools+=("$tool")
        fi
    done
    
    if [ ${#missing_tools[@]} -ne 0 ]; then
        log $RED "❌ Ferramentas obrigatórias não encontradas:"
        for tool in "${missing_tools[@]}"; do
            log $RED "   • $tool"
        done
        echo ""
        log $YELLOW "📋 Instale as ferramentas necessárias e tente novamente"
        exit 1
    fi
    
    log $GREEN "✅ Pré-requisitos básicos atendidos"
    echo ""
}

# Baixar hub criptografado (otimizado)
download_encrypted_hub() {
    log $CYAN "📦 Baixando YVENS_TECHNOLOGIES v2.0..."
    
    local repo_url="https://raw.githubusercontent.com/yvensrabelo/yvens_technologies/main/yvens_hub.enc"
    local encrypted_file="yvens_hub.enc"
    
    # Download com indicador de progresso
    if curl -L --progress-bar "$repo_url" -o "$encrypted_file" 2>/dev/null; then
        if [ -f "$encrypted_file" ] && [ -s "$encrypted_file" ]; then
            local size=$(du -h "$encrypted_file" | cut -f1)
            log $GREEN "✅ Hub v2.0 baixado com sucesso ($size)"
        else
            log $RED "❌ Erro: arquivo baixado está corrompido"
            exit 1
        fi
    else
        log $RED "❌ Erro ao baixar YVENS_TECHNOLOGIES v2.0"
        log $YELLOW "   Verifique sua conexão com a internet"
        exit 1
    fi
    echo ""
}

# Descriptografar e criar workspace básico
decrypt_and_setup_workspace() {
    log $CYAN "🔓 Descriptografando YVENS_TECHNOLOGIES v2.0..."
    log $BLUE "🔑 Digite a SENHA MASTER para acessar YVENS_TECHNOLOGIES:"
    log $YELLOW "   (Solicite a senha ao proprietário do hub)"
    echo ""
    # Verificar se stdin está conectado ao terminal
    if [ -t 0 ]; then
        # Terminal interativo normal
        read -s -p "🔐 Senha: " master_password
    else
        # Executando via pipe (curl | bash) - tentar múltiplas abordagens
        if [ -r /dev/tty ]; then
            read -s -p "🔐 Senha: " master_password < /dev/tty
        else
            # Fallback: tentar stdin direto (para ambientes automatizados)
            echo "🔐 Digite a senha e pressione Enter:"
            read master_password
        fi
    fi
    # Remover qualquer quebra de linha no final da senha
    master_password=$(printf '%s' "$master_password" | tr -d '\n\r')
    echo ""
    echo ""
    
    local temp_tar="yvens_hub_temp.tar.gz"
    
    # Descriptografar com senha
    if openssl enc -aes-256-cbc -d -salt -in "yvens_hub.enc" -out "$temp_tar" -pass pass:"$master_password" 2>/dev/null; then
        echo ""
        log $GREEN "✅ Hub descriptografado com sucesso!"
        
        # Extrair estrutura
        log $BLUE "📦 Extraindo estrutura do hub..."
        if tar -xzf "$temp_tar"; then
            log $GREEN "✅ Estrutura extraída"
            
            # Limpeza automática
            rm "$temp_tar" "yvens_hub.enc"
            
            # Criar workspace básico automaticamente
            create_basic_workspace
            
        else
            log $RED "❌ Erro ao extrair estrutura!"
            rm -f "$temp_tar"
            exit 1
        fi
    else
        log $RED "❌ Senha incorreta ou arquivo corrompido!"
        rm -f "$temp_tar"
        exit 1
    fi
}

# Criar workspace básico (ÚNICA AÇÃO AUTOMÁTICA)
create_basic_workspace() {
    log $CYAN "🚧 Criando workspace básico..."
    
    # Verificar se já existe
    if [ -d "me-de-um-nome" ]; then
        log $GREEN "✅ Workspace 'me-de-um-nome' já existe"
    else
        # Criar estrutura básica do workspace
        mkdir -p "me-de-um-nome"/{src,docs,config}
        
        # Arquivo README básico do workspace
        cat > "me-de-um-nome/README.md" << EOF
# 🚧 Workspace YVENS_TECHNOLOGIES

Este é seu workspace de desenvolvimento. Será renomeado para o nome do seu projeto.

## 📁 Estrutura Inicial:
- \`src/\` - Código fonte do projeto
- \`docs/\` - Documentação
- \`config/\` - Configurações

## 🛠️ Próximos passos:
1. Defina o nome do seu projeto
2. Escolha as ferramentas necessárias  
3. Configure seu ambiente de desenvolvimento

**Workspace será personalizado baseado no seu tipo de projeto!**
EOF
        
        log $GREEN "✅ Workspace básico criado"
    fi
    echo ""
}

# Menu de tipos de projeto
show_project_menu() {
    log $BOLD $CYAN "🎯 QUE TIPO DE PROJETO DESEJA CRIAR?"
    log $CYAN "===================================="
    echo ""
    
    log $GREEN "1. 🌐 Site/WebApp"
    log $BLUE "   • Frontend moderno (React, Vue, etc)"
    log $BLUE "   • Backend integrado" 
    log $BLUE "   • APIs pré-configuradas"
    echo ""
    
    log $GREEN "2. 🔌 API/Microserviço"
    log $BLUE "   • FastAPI, Express, ou similar"
    log $BLUE "   • Documentação automática"
    log $BLUE "   • Testes integrados"
    echo ""
    
    log $GREEN "3. 📱 Mobile App"
    log $BLUE "   • React Native ou Flutter"
    log $BLUE "   • APIs nativas configuradas"
    log $BLUE "   • Cross-platform ready"
    echo ""
    
    log $GREEN "4. 🎯 Projeto BMAD Completo"
    log $BLUE "   • Metodologia BMAD estruturada"
    log $BLUE "   • Planejamento agentic"
    log $BLUE "   • Context-engineered development"
    echo ""
    
    log $GREEN "5. 🔧 Configuração Personalizada"
    log $BLUE "   • Você escolhe cada componente"
    log $BLUE "   • Máxima flexibilidade"
    echo ""
    
    log $GREEN "0. ❌ Sair"
    echo ""
}

# Configurar projeto baseado no tipo
setup_project() {
    local project_type=$1
    
    # Solicitar nome do projeto
    echo ""
    log $CYAN "📝 Nome do seu projeto:"
    read -p "Digite o nome (ex: MeuSiteEcommerce): " project_name
    
    if [ -z "$project_name" ]; then
        log $RED "❌ Nome do projeto é obrigatório"
        return 1
    fi
    
    # Renomear workspace
    if [ -d "me-de-um-nome" ]; then
        mv "me-de-um-nome" "$project_name"
        log $GREEN "✅ Workspace renomeado para: $project_name"
    else
        mkdir -p "$project_name"
        log $GREEN "✅ Workspace $project_name criado"
    fi
    
    echo ""
    
    # Configuração baseada no tipo
    case $project_type in
        1) setup_webapp "$project_name" ;;
        2) setup_api "$project_name" ;;
        3) setup_mobile "$project_name" ;;
        4) setup_bmad_complete "$project_name" ;;
        5) setup_custom "$project_name" ;;
    esac
}

# Configuração para WebApp
setup_webapp() {
    local project_name=$1
    log $CYAN "🌐 Configurando projeto WebApp: $project_name"
    echo ""
    
    # Perguntas específicas para webapp
    ask_component "Instalar MCPs para desenvolvimento web?" "mcps_web"
    ask_component "Configurar APIs de frontend?" "apis_frontend"  
    ask_component "Copiar suas credenciais?" "credentials"
    ask_component "Instalar subagentes de desenvolvimento web?" "subagents_web"
    
    # Instalação condicional
    install_selected_components "$project_name"
    
    # Estrutura específica webapp
    setup_webapp_structure "$project_name"
}

# Configuração para API
setup_api() {
    local project_name=$1
    log $CYAN "🔌 Configurando projeto API: $project_name"
    echo ""
    
    ask_component "Instalar MCPs para desenvolvimento de API?" "mcps_api"
    ask_component "Configurar APIs externas?" "apis_external"
    ask_component "Copiar suas credenciais?" "credentials"  
    ask_component "Instalar subagentes de backend?" "subagents_backend"
    
    install_selected_components "$project_name"
    setup_api_structure "$project_name"
}

# Configuração para Mobile
setup_mobile() {
    local project_name=$1
    log $CYAN "📱 Configurando projeto Mobile: $project_name"
    echo ""
    
    ask_component "Instalar MCPs para desenvolvimento mobile?" "mcps_mobile"
    ask_component "Configurar APIs móveis?" "apis_mobile"
    ask_component "Copiar suas credenciais?" "credentials"
    ask_component "Instalar subagentes mobile?" "subagents_mobile"
    
    install_selected_components "$project_name"
    setup_mobile_structure "$project_name"
}

# Configuração BMAD completa
setup_bmad_complete() {
    local project_name=$1
    log $CYAN "🎯 Configurando projeto BMAD completo: $project_name"
    echo ""
    
    log $YELLOW "📋 Projeto BMAD inclui TODOS os componentes:"
    
    # BMAD = tudo instalado
    INSTALL_MCPS="yes"
    INSTALL_APIS="yes" 
    INSTALL_CREDENTIALS="yes"
    INSTALL_SUBAGENTS="yes"
    INSTALL_BMAD="yes"
    
    install_selected_components "$project_name"
    setup_bmad_structure "$project_name"
}

# Configuração personalizada
setup_custom() {
    local project_name=$1
    log $CYAN "🔧 Configuração personalizada: $project_name"
    echo ""
    
    ask_component "Instalar MCPs?" "mcps"
    ask_component "Configurar APIs?" "apis"
    ask_component "Aplicar metodologia BMAD?" "bmad"
    ask_component "Copiar suas credenciais?" "credentials"
    ask_component "Instalar subagentes?" "subagents"
    
    install_selected_components "$project_name"
    setup_custom_structure "$project_name"
}

# Função para perguntar sobre componentes
ask_component() {
    local question=$1
    local component=$2
    
    read -p "$(echo -e "${BLUE}$question (y/N): ${NC}")" answer
    case $answer in
        [Yy]* ) 
            eval "INSTALL_${component^^}=yes"
            log $GREEN "  ✅ $component será instalado"
            ;;
        * ) 
            eval "INSTALL_${component^^}=no"
            log $YELLOW "  ⏭️  $component será ignorado"
            ;;
    esac
    echo ""
}

# Instalar componentes selecionados
install_selected_components() {
    local project_name=$1
    
    log $CYAN "🔧 Instalando componentes selecionados..."
    echo ""
    
    # MCPs
    if [[ "${INSTALL_MCPS:-no}" == "yes" || "${INSTALL_MCPS_WEB:-no}" == "yes" || "${INSTALL_MCPS_API:-no}" == "yes" || "${INSTALL_MCPS_MOBILE:-no}" == "yes" ]]; then
        install_mcps "$project_name"
    fi
    
    # APIs
    if [[ "${INSTALL_APIS:-no}" == "yes" || "${INSTALL_APIS_FRONTEND:-no}" == "yes" || "${INSTALL_APIS_EXTERNAL:-no}" == "yes" || "${INSTALL_APIS_MOBILE:-no}" == "yes" ]]; then
        install_apis "$project_name"
    fi
    
    # Credenciais
    if [[ "${INSTALL_CREDENTIALS:-no}" == "yes" ]]; then
        copy_credentials "$project_name"
    fi
    
    # Subagentes
    if [[ "${INSTALL_SUBAGENTS:-no}" == "yes" || "${INSTALL_SUBAGENTS_WEB:-no}" == "yes" || "${INSTALL_SUBAGENTS_BACKEND:-no}" == "yes" || "${INSTALL_SUBAGENTS_MOBILE:-no}" == "yes" ]]; then
        install_subagents "$project_name"
    fi
    
    # BMAD
    if [[ "${INSTALL_BMAD:-no}" == "yes" ]]; then
        install_bmad "$project_name"
    fi
}

# Instalar MCPs (modular)
install_mcps() {
    local project_name=$1
    log $BLUE "🔌 Instalando MCPs..."
    
    if [ -f "ferramentas/mcps/install-mcps.sh" ]; then
        cd "ferramentas/mcps"
        chmod +x install-mcps.sh
        ./install-mcps.sh
        cd - > /dev/null
        log $GREEN "  ✅ MCPs instalados"
    else
        log $YELLOW "  ⚠️  Script de MCPs não encontrado"
    fi
    echo ""
}

# Instalar APIs (modular)  
install_apis() {
    local project_name=$1
    log $BLUE "🌐 Configurando APIs..."
    
    if [ -d "ferramentas/apis" ]; then
        cp -r ferramentas/apis "$project_name/"
        log $GREEN "  ✅ Configurações de API copiadas"
    else
        log $YELLOW "  ⚠️  Configurações de API não encontradas"
    fi
    echo ""
}

# Copiar credenciais (modular)
copy_credentials() {
    local project_name=$1
    log $BLUE "🔑 Copiando credenciais..."
    
    if [ -d "ferramentas/credenciais" ] && [ "$(ls -A ferramentas/credenciais)" ]; then
        cp -r ferramentas/credenciais "$project_name/"
        log $GREEN "  ✅ Credenciais copiadas"
    else
        log $YELLOW "  ⚠️  Credenciais não encontradas ou vazias"
    fi
    echo ""
}

# Instalar subagentes (modular)
install_subagents() {
    local project_name=$1
    log $BLUE "🤖 Instalando subagentes..."
    
    if [ -f "ferramentas/subagentesclaude/download-subagents.sh" ]; then
        cd "ferramentas/subagentesclaude"
        chmod +x download-subagents.sh
        ./download-subagents.sh
        
        # Copiar para projeto
        if [ -d "agents" ]; then
            mkdir -p "../../$project_name/.claude"
            cp -r agents "../../$project_name/.claude/"
            log $GREEN "  ✅ Subagentes instalados"
        fi
        
        cd - > /dev/null
    else
        log $YELLOW "  ⚠️  Script de subagentes não encontrado"
    fi
    echo ""
}

# Instalar BMAD (modular)
install_bmad() {
    local project_name=$1
    log $BLUE "🎯 Instalando metodologia BMAD..."
    
    if [ -f "BMAD/install-bmad.sh" ]; then
        cd "BMAD"
        chmod +x install-bmad.sh
        ./install-bmad.sh
        
        # Copiar para projeto
        if [ -d "bmad-ecosystem" ]; then
            cp -r bmad-ecosystem "../$project_name/"
            log $GREEN "  ✅ BMAD instalado"
        fi
        
        cd - > /dev/null
    else
        log $YELLOW "  ⚠️  BMAD não encontrado"
    fi
    echo ""
}

# Estruturas específicas dos projetos
setup_webapp_structure() {
    local project_name=$1
    
    mkdir -p "$project_name"/{frontend,backend,docs,tests}
    
    cat > "$project_name/README.md" << EOF
# 🌐 $project_name - WebApp

Projeto WebApp configurado com YVENS_TECHNOLOGIES v2.0

## 📁 Estrutura:
- \`frontend/\` - Interface do usuário
- \`backend/\` - API e lógica de servidor  
- \`docs/\` - Documentação do projeto
- \`tests/\` - Testes automatizados

## 🛠️ Ferramentas instaladas:
- MCPs para desenvolvimento web
- APIs pré-configuradas
- Subagentes especializados

**Projeto pronto para desenvolvimento!** 🚀
EOF

    log $GREEN "✅ Estrutura WebApp configurada"
}

setup_api_structure() {
    local project_name=$1
    
    mkdir -p "$project_name"/{api,docs,tests,config}
    
    cat > "$project_name/README.md" << EOF
# 🔌 $project_name - API/Microserviço

API configurada com YVENS_TECHNOLOGIES v2.0

## 📁 Estrutura:
- \`api/\` - Endpoints e lógica
- \`docs/\` - Documentação da API
- \`tests/\` - Testes da API
- \`config/\` - Configurações

**API pronta para desenvolvimento!** 🚀
EOF

    log $GREEN "✅ Estrutura API configurada"
}

setup_mobile_structure() {
    local project_name=$1
    
    mkdir -p "$project_name"/{app,assets,docs,tests}
    
    cat > "$project_name/README.md" << EOF
# 📱 $project_name - Mobile App

App móvel configurado com YVENS_TECHNOLOGIES v2.0

## 📁 Estrutura:
- \`app/\` - Código do aplicativo
- \`assets/\` - Imagens e recursos
- \`docs/\` - Documentação
- \`tests/\` - Testes do app

**App pronto para desenvolvimento!** 🚀
EOF

    log $GREEN "✅ Estrutura Mobile configurada"
}

setup_bmad_structure() {
    local project_name=$1
    
    mkdir -p "$project_name"/{planning,development,quality,deploy}
    
    cat > "$project_name/README.md" << EOF
# 🎯 $project_name - Projeto BMAD

Projeto estruturado com metodologia BMAD completa

## 📁 Estrutura BMAD:
- \`planning/\` - Análise e arquitetura
- \`development/\` - Desenvolvimento context-engineered  
- \`quality/\` - Testes e QA
- \`deploy/\` - Deploy e produção

## 🛠️ TODOS os componentes instalados:
- MCPs, APIs, Credenciais, Subagentes, BMAD

**Projeto BMAD completo!** 🎯
EOF

    log $GREEN "✅ Estrutura BMAD configurada"
}

setup_custom_structure() {
    local project_name=$1
    
    mkdir -p "$project_name"/{src,config,docs}
    
    cat > "$project_name/README.md" << EOF
# 🔧 $project_name - Configuração Personalizada

Projeto personalizado com YVENS_TECHNOLOGIES v2.0

## 📁 Estrutura:
- \`src/\` - Código fonte
- \`config/\` - Configurações
- \`docs/\` - Documentação

**Configuração personalizada concluída!** ✨
EOF

    log $GREEN "✅ Estrutura personalizada configurada"
}

# Resumo final
show_final_summary() {
    local project_name=$1
    
    echo ""
    log $GREEN "🎉 CONFIGURAÇÃO COMPLETA!"
    log $GREEN "========================="
    echo ""
    
    log $CYAN "📋 Projeto criado: $BOLD$project_name$NC"
    
    # Mostrar o que foi instalado
    echo ""
    log $BLUE "🛠️ Componentes instalados:"
    [[ "${INSTALL_MCPS:-no}" == "yes" || "${INSTALL_MCPS_WEB:-no}" == "yes" || "${INSTALL_MCPS_API:-no}" == "yes" || "${INSTALL_MCPS_MOBILE:-no}" == "yes" ]] && log $GREEN "   ✅ MCPs"
    [[ "${INSTALL_APIS:-no}" == "yes" || "${INSTALL_APIS_FRONTEND:-no}" == "yes" || "${INSTALL_APIS_EXTERNAL:-no}" == "yes" || "${INSTALL_APIS_MOBILE:-no}" == "yes" ]] && log $GREEN "   ✅ APIs"
    [[ "${INSTALL_CREDENTIALS:-no}" == "yes" ]] && log $GREEN "   ✅ Credenciais"
    [[ "${INSTALL_SUBAGENTS:-no}" == "yes" || "${INSTALL_SUBAGENTS_WEB:-no}" == "yes" || "${INSTALL_SUBAGENTS_BACKEND:-no}" == "yes" || "${INSTALL_SUBAGENTS_MOBILE:-no}" == "yes" ]] && log $GREEN "   ✅ Subagentes"
    [[ "${INSTALL_BMAD:-no}" == "yes" ]] && log $GREEN "   ✅ BMAD Method"
    
    echo ""
    log $CYAN "🚀 Próximos passos:"
    log $YELLOW "   1. cd $project_name"
    log $YELLOW "   2. Leia o README.md do projeto"
    log $YELLOW "   3. Comece o desenvolvimento!"
    echo ""
    
    log $CYAN "🎯 Seu projeto YVENS_TECHNOLOGIES v2.0 está pronto!"
    echo ""
}

# Menu principal
main_menu() {
    while true; do
        show_project_menu
        read -p "🎯 Escolha o tipo de projeto (0-5): " choice
        echo ""
        
        case $choice in
            1|2|3|4|5)
                if setup_project $choice; then
                    show_final_summary "$project_name"
                    break
                fi
                ;;
            0)
                log $CYAN "👋 Instalação cancelada"
                exit 0
                ;;
            *)
                log $RED "❌ Opção inválida. Digite um número de 0 a 5."
                read -p "Pressione Enter para continuar..."
                ;;
        esac
    done
}

# Função principal
main() {
    # Criar diretório temporário para instalação
    local install_dir="yvens_v2_install_$(date +%s)"
    mkdir "$install_dir"
    cd "$install_dir"
    
    # Executar fluxo otimizado
    show_banner
    check_basic_requirements
    download_encrypted_hub
    decrypt_and_setup_workspace
    
    # Menu interativo
    main_menu
    
    # Limpeza final não necessária - usuário fica com o projeto
    log $GREEN "🎉 YVENS_TECHNOLOGIES v2.0 - Instalação concluída!"
    echo ""
}

# Tratar interrupção
trap 'echo ""; log $RED "❌ Instalação interrompida pelo usuário"; exit 1' INT

# Executar
main "$@"