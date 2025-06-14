🛡️ ANALISADOR DE LOGS LINUX - UMA SOLUÇÃO SIMPLES

> Ferramenta simples, modular e poderosa para análise de logs de autenticação no Linux. Ideal para SOCs, sysadmins, analistas de segurança e estudantes da área.

---

🎯 Objetivo

Automatizar a coleta e análise de eventos de autenticação no Linux a partir dos arquivos de log (`/var/log/auth.log` ou `/var/log/secure`), oferecendo visibilidade rápida de:

- Tentativas de login mal-sucedidas
- Logins bem-sucedidos
- Uso de `sudo`
- Sessões SSH iniciadas

---

🚀 Funcionalidades

- 🔍 **Filtro por data e/ou IP**
- 📄 **Geração de relatório em texto**
- 📦 **Exportação em JSON estruturado**
- 📧 **Envio automático por e-mail ou para API externa**

---

📦 Requisitos

- Linux com bash
- Ferramentas padrão (`grep`, `awk`, `curl`, `mail` etc.)
- Permissões para ler `/var/log/auth.log` ou `/var/log/secure`

---

⚙️ Como usar

Execute um terminal bash

git clone https://github.com/almirmeira/analisador-logs-linux.git

cd analisador-logs-linux

chmod +x analisador.sh

▶️ Execução padrão

./analisador.sh

▶️ Com filtro por data

./analisador.sh -d "Jun 14"

▶️ Com filtro por IP

./analisador.sh -i "192.168"

▶️ Com envio de relatório

EMAIL_DEST=seu@email.com ./analisador.sh
API_URL="https://suaapi.com/post" ./analisador.sh

📁 Saídas

relatorio_autenticacao.txt → Relatório legível em texto

relatorio_autenticacao.json → Versão estruturada para integrações

🔒 Considerações de Segurança

O script não realiza modificações no sistema.
Apenas lê e processa logs.
Requer privilégios para ler arquivos protegidos (use sudo se necessário).

🙌 Contribuições
Sinta-se à vontade para abrir issues, enviar pull requests ou sugerir melhorias como:
- Suporte a outros formatos de log (ex: journald)
- Detecção de brute force
- Integração com SIEMs

👨🏽‍💻 Autor
Almir Meira
GitHub: @almirmeira

📜 Licença
Distribuído sob a licença MIT. Consulte LICENSE para mais informações.
