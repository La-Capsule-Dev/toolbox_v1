# 🛠️ Toolbox Linux - Reconditionement

Une application open source construite avec **Tauri (Rust + React)** pour faciliter le **diagnostic et la remise en état de PC** (UC et portables).

L’objectif est d’aider les **reconditionneurs** à analyser et tester rapidement le matériel via une interface simple et portable (format `.AppImage`).

---

## ✨ Fonctionnalités principales

-   Analyse catégorisée du système _(OS, CPU, GPU, Ram, disques, ...)_

-   Stress test matériel

-   Destructions de données sur supports de stockage de masse

-   Clone d'images système

-   Protocole didactique étape par étape

-   Lancement de scripts Bash via l'interface

-   App compilée en `.AppImage`, portable sur n'importe quelle distro Linux

-   Multi-contributeurs, projet open-source collaboratif

---

## 📸 Captures d'écran

> _Ajouter screenshot(s)_

---

## 🚀 Installation

### 📦 Via AppImage (recommandé pour utilisateur finaux)

1. Télécharge le fichier `.AppImage` depuis la section [Releases]()

2. Rends le fichier exécutable :

    ```bash
    chmod +x Toolbox.AppImage
    ```

3. Lance l'application :

    ```bash
    ./Toolbox.AppImage
    ```

---

### 💻 Pour les développeurs (build local)

**Prérequis :**

-   Node.js (v22.x LTS recommandé)

-   Rust

-   Tauri CLI :

    ```bash
    cargo install tauri-cli
    ```

**Cloner le projet :**

```bash
git clone https://github.com/La-Capsule-Dev/toolbox_v1.git
cd toolbox_v1
npm install
```

**Lancer en dev :**

```bash
npm run tauri dev
```

---

## 🤝 Contribuer

Les contributions sont les bienvenues !

Merci de lire le fichier `CONTRIBUTING.md` avant de proposer une PR

### 🧱 Structure des branches

| Branche     | Rôle                                        |
| ----------- | ------------------------------------------- |
| `main`      | Code stable, utilisé pour les releases      |
| `dev`       | Intégration continue des nouvelles features |
| `feature/*` | Pour les nouvelles features                 |

---

### 🧳 Scripts disponibles

| Fonction     | Commande Bash lancée               |
| ------------ | ---------------------------------- |
| Analyse CPU  | `lscpu`                            |
| Info GPU     | `lspci`                            |
| Test mémoire | `stress-ng --vm 2 --vm-bytes 128M` |

---

## 📄 License

Ce projet est sous license **GNU - GENERAL PUBLIC LICENSE**. Voir le fichier `LICENSE` pour plus de détails.

---

## 📫 Contact / communauté

-   👨‍💻 Créé par : [La Capsule]()

-   💌 Suggestions, bugs : ouvre une _issue_

-   🙌 Associations partenaires : _a compléter_

---
