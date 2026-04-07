# Diesel Plasma Lab

---

## Português

Base inicial do projeto Diesel Plasma Lab para:

- restaurar a máquina após formatação
- replicar o ambiente em outra máquina
- organizar assets, tema e scripts
- servir de base futura para ISO

### Estrutura

- assets/icons/
- hosts/hal/
- scripts/
- themes/color-schemes/
- users/hal/plasma/
- users/hal/gtk/

### Conteúdo atual

- hosts/hal/configuration.nix
- hosts/hal/hardware-configuration.nix
- arquivos principais do Plasma
- arquivos GTK principais
- esquema de cores DieselOSLab.colors
- ícone do launcher
- script de aplicação do tema
- script de backup do estado atual
- script de restore

### Fluxo recomendado

Backup do estado atual:
cd /mnt/vmstore/projetos/Diesel-Plasma-Lab
bash ./scripts/backup-current-state.sh

Restaurar a máquina:
cd /mnt/vmstore/projetos/Diesel-Plasma-Lab
bash ./scripts/restore-current-state.sh

### Observação importante

O script de restore copia os arquivos para o lugar certo, mas o rebuild do NixOS continua sendo manual de propósito, para manter revisão e segurança antes da aplicação.

---

## English

Initial base of the Diesel Plasma Lab project for:

- restoring the machine after formatting
- replicating the environment on another machine
- organizing assets, theme and scripts
- serving as a future base for an ISO

### Structure

- assets/icons/
- hosts/hal/
- scripts/
- themes/color-schemes/
- users/hal/plasma/
- users/hal/gtk/

### Current contents

- hosts/hal/configuration.nix
- hosts/hal/hardware-configuration.nix
- main Plasma files
- main GTK files
- DieselOSLab.colors color scheme
- launcher icon
- theme apply script
- current state backup script
- restore script

### Recommended workflow

Backup current state:
cd /mnt/vmstore/projetos/Diesel-Plasma-Lab
bash ./scripts/backup-current-state.sh

Restore the machine:
cd /mnt/vmstore/projetos/Diesel-Plasma-Lab
bash ./scripts/restore-current-state.sh

### Important note

The restore script copies the files to the correct locations, but the NixOS rebuild remains intentionally manual, so the configuration can still be reviewed before applying it.

---

## Français

Base initiale du projet Diesel Plasma Lab pour :

- restaurer la machine après formatage
- reproduire l’environnement sur une autre machine
- organiser les assets, le thème et les scripts
- servir de base future pour une ISO

### Structure

- assets/icons/
- hosts/hal/
- scripts/
- themes/color-schemes/
- users/hal/plasma/
- users/hal/gtk/

### Contenu actuel

- hosts/hal/configuration.nix
- hosts/hal/hardware-configuration.nix
- fichiers principaux de Plasma
- fichiers GTK principaux
- schéma de couleurs DieselOSLab.colors
- icône du lanceur
- script d’application du thème
- script de sauvegarde de l’état actuel
- script de restauration

### Flux recommandé

Sauvegarder l’état actuel :
cd /mnt/vmstore/projetos/Diesel-Plasma-Lab
bash ./scripts/backup-current-state.sh

Restaurer la machine :
cd /mnt/vmstore/projetos/Diesel-Plasma-Lab
bash ./scripts/restore-current-state.sh

### Remarque importante

Le script de restauration copie les fichiers vers les bons emplacements, mais la reconstruction de NixOS reste volontairement manuelle afin de permettre une révision avant l’application.

---

## Español

Base inicial del proyecto Diesel Plasma Lab para:

- restaurar la máquina después de formatear
- replicar el entorno en otra máquina
- organizar assets, tema y scripts
- servir como base futura para una ISO

### Estructura

- assets/icons/
- hosts/hal/
- scripts/
- themes/color-schemes/
- users/hal/plasma/
- users/hal/gtk/

### Contenido actual

- hosts/hal/configuration.nix
- hosts/hal/hardware-configuration.nix
- archivos principales de Plasma
- archivos principales de GTK
- esquema de colores DieselOSLab.colors
- icono del lanzador
- script para aplicar el tema
- script de respaldo del estado actual
- script de restauración

### Flujo recomendado

Respaldar el estado actual:
cd /mnt/vmstore/projetos/Diesel-Plasma-Lab
bash ./scripts/backup-current-state.sh

Restaurar la máquina:
cd /mnt/vmstore/projetos/Diesel-Plasma-Lab
bash ./scripts/restore-current-state.sh

### Nota importante

El script de restauración copia los archivos a los lugares correctos, pero la reconstrucción de NixOS sigue siendo manual a propósito, para permitir revisión antes de aplicarla.
