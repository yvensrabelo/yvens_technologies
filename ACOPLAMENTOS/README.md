# 🔧 ACOPLAMENTOS - Biblioteca de Componentes Reutilizáveis

## 📚 O que é esta pasta?

Aqui ficam salvos componentes, módulos e funcionalidades que você desenvolveu e quer reutilizar em projetos futuros.

## 🎯 Como usar:

### Salvar um componente:
```bash
# Desenvolveu algo útil em PROJETO_ATUAL?
yvens save nome-do-componente
```

### Reutilizar em novo projeto:
```bash
# Copie de ACOPLAMENTOS para PROJETO_ATUAL
cp -r ACOPLAMENTOS/gateway-pagamento PROJETO_ATUAL/
```

## 📁 Estrutura sugerida:

```
ACOPLAMENTOS/
├── gateways/
│   ├── stripe-checkout/
│   ├── mercadopago-integration/
│   └── pix-generator/
├── auth/
│   ├── jwt-auth/
│   ├── oauth-google/
│   └── magic-link/
├── ui-components/
│   ├── animated-loader/
│   ├── responsive-navbar/
│   └── modal-system/
├── apis/
│   ├── cep-lookup/
│   ├── email-sender/
│   └── sms-notifier/
└── utils/
    ├── date-formatter/
    ├── currency-converter/
    └── validation-helpers/
```

## ✨ Benefícios:

- ♻️ **Reutilização** - Não reescreva código que já funciona
- ⚡ **Produtividade** - Acelere novos projetos
- 📈 **Evolução** - Melhore componentes ao longo do tempo
- 🎯 **Padronização** - Mantenha consistência entre projetos

## 💡 Dicas:

1. **Documente bem** - Cada componente deve ter seu README
2. **Versione** - Indique versão e data de criação
3. **Teste** - Salve apenas código testado e funcional
4. **Generalize** - Torne componentes configuráveis

## 🔄 Sincronização:

- `yvens push` - Salva ACOPLAMENTOS no GitHub
- `yvens all` - Salva tudo incluindo experimentos
- `yvens pull` - Baixa atualizações dos ACOPLAMENTOS

---

**Sua biblioteca pessoal de soluções prontas!** 🚀