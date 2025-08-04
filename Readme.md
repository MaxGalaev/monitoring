### Сервер мониторинга. Prometheus + Grafana в Docker.

Сервер мониторинга создается в `Proxmox` с использованием `Terraform`. На сервере устанавливается `Docker` через `Ansible` роль. В `Docker` с помощью `docker compose` устанавливаются 2 сервиса - `Prometheus` и `Grafana`.
