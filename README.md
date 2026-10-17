# Rise Mode Temp 6 Linux Driver (Refatorado & Aprimorado)

Driver experimental para Linux do display USB do air cooler **Rise Mode Temp 6 Pro**.

O dispositivo usa um controlador HID da Semico/Ocypus e aparece no Linux como:

```text
1a2c:4984 SEMICO USB Gaming Keyboard
```

O driver é responsável por enviar as seguintes informações ao display:

- Temperatura da CPU (com detecção automática inteligente de sensores)
- Potência aproximada do pacote CPU em watts, via Intel RAPL, quando disponível

---

## Melhorias e Novidades desta Versão Refatorada

1. **Detecção Automática e Inteligente de Sensores (Intel & AMD Ryzen):**

- O script `rise_temp6.py` identifica automaticamente o sensor de temperatura disponível no sistema (`k10temp`, `zenpower`, `coretemp`, `cpu_thermal`, etc.).
- Não é mais necessário especificar um sensor fixo no serviço (como `--sensor coretemp`). O script seleciona o correto por conta própria.
- Suporte nativo a processadores AMD Ryzen e Intel sem dor de cabeça.

2. **Resiliência e Tratamento de Erros:**

- Tratamento robusto na busca por substrings e rótulos de sensores para evitar exceções em distribuições Linux variadas.

3. **Instalador e Regras Udev Robustos (`install.sh` & `99-rise-temp6.rules`):**

- Adicionada regra explícita no udev (`ATTR{authorized}="1"`) para evitar que o kernel bloqueie ou deixe portas USB não autorizadas.
- Feedback visual aprimorado com cores no terminal e validação prévia de dependências.

4. **Otimização do Serviço Systemd (`rise-temp6.service`):**

- Serviço simplificado, sem parâmetros fixos de sensores, permitindo portabilidade total entre diferentes configurações de hardware.

---

## Requisitos

No Ubuntu/Debian:

```bash
sudo apt install python3 python3-psutil
```

## Instalação

Clone o repositório e execute o instalador como root:

```bash
sudo ./install.sh
```

O instalador cuida de copiar os arquivos, configurar as regras do udev e habilitar o serviço systemd automaticamente.

---

## Uso Manual

Listar dispositivos HID disponíveis:

```bash
sudo ./rise_temp6.py list
```

Executar a atualização contínua (com detecção automática de temperatura):

```bash
sudo ./rise_temp6.py watch --interval 1
```

_(Nota: Caso queira testar uma temperatura ou sensor específico manualmente, você ainda pode usar parâmetros opcionais como `--temp 55` ou `--sensor k10temp`)._

---

## Gerenciamento do Serviço

Verificar status:

```bash
sudo systemctl status rise-temp6.service
```

Ver logs em tempo real:

```bash
sudo journalctl -u rise-temp6.service -f
```

Reiniciar o serviço:

```bash
sudo systemctl restart rise-temp6.service
```

Parar o serviço:

```bash
sudo systemctl stop rise-temp6.service
```

---

## Desinstalação

Para remover completamente o driver e todas as configurações do sistema:

```bash
sudo ./uninstall.sh
```

---

## Notas

- O dispositivo se identifica como teclado HID, mas a interface usada pelo display é a interface `1`.
- O script usa `HidD_SetFeature` equivalente via `ioctl(HIDIOCSFEATURE)` em `/dev/hidraw`.
- Este projeto não é oficial da Rise Mode, Semico ou Ocypus.
