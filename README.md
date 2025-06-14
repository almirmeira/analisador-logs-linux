🛡️ ANALISADOR DE LOGS LINUX - UMA SOLUÇÃO SIMPLES

Um script Bash poderoso e direto ao ponto para análise de eventos de autenticação no Linux. Compatível com ambientes locais e remotos (SSH), ideal para sysadmins, analistas SOC, auditores e estudantes de cibersegurança.
---
🎯 Objetivo

Automatizar a extração e análise de eventos de autenticação em sistemas Linux com base nos logs do arquivo `/var/log/auth.log`. O script detecta:

- Acessos bem e mal sucedidos via SSH
- Sessões abertas e encerradas localmente (tty, gdm, su, sudo)
- Tentativas de elevação de privilégio
- Falhas de autenticação

---

🛠️ Funcionalidades

| Categoria         | Detecta                                                                  |
|-------------------|--------------------------------------------------------------------------|
| SSH               | Logins bem/mal sucedidos (`Accepted password`, `Failed password`)        |
| Sessões Locais    | `session opened` / `session closed`                                      |
| `sudo`            | Comandos executados com privilégio                                       |
| `su`              | Troca de usuário local com autenticação                                  |
| Falhas PAM        | `authentication failure` (independente do meio de login)                 |

---

📦 Requisitos

- Ubuntu/Debian com `/var/log/auth.log` ativo
- Permissão de leitura dos logs (executar com `sudo` é recomendado)
- Terminal Bash

---

## 🚀 Instalação

Abra um terminal que execute bash

git clone https://github.com/almirmeira/analisador-logs-linux.git
cd analisador-logs-linux
chmod +x analisador.sh

▶️ Como usar
sudo ./analisador.sh

Exibir relatório gerado
cat relatorio_autenticacao.txt

📁 Saída esperada

Arquivo relatorio_autenticacao.txt com seções como:
[1] SSH - TENTATIVAS DE LOGIN INVÁLIDAS:
[2] SSH - LOGINS BEM SUCEDIDOS:
[3] SESSÕES ABERTAS (local + remoto):
[4] SESSÕES ENCERRADAS:
[5] USO DO SUDO:
[6] USO DO SU:
[7] FALHAS DE AUTENTICAÇÃO (PAM):

📌 Exemplo de aplicação
- Verificar se houve tentativas de brute force SSH
- Identificar se usuários utilizaram sudo ou su de forma inesperada
- Auditar sessões abertas e encerradas por usuários específicos
- Automatizar coleta e análise de logs em ambientes corporativos

🙌 Contribuições
Sugestões e pull requests são muito bem-vindos!
- Você pode propor melhorias como:
- Exportação para JSON/CSV
- Envio automático por e-mail ou webhook
- Filtros por usuário, IP, data

👨🏽‍💻 Autor
Almir Meira
🔗 github.com/almirmeira

📜 Licença
Distribuído sob a licença MIT. Consulte LICENSE para mais detalhes.
