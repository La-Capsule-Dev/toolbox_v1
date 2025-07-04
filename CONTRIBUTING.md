# 🤝 Guide de contribution

Merci de vouloir contribuer à ce projet open source 🙏

Ce guide explique comment contribuer de manière claire, efficace et respectueuse pour tous.

---

## ⚙️ Pré-requis techniques

Assure-toi d’avoir installé :

-   [Node.js](https://nodejs.org) (v22.x LTS recommandé)
-   Rust
-   Tauri CLI : `cargo install tauri-cli`
-   Un éditeur type [VSCode](https://code.visualstudio.com) avec support TypeScript / Rust

---

## 🧪 Tester en local

1. Fork puis clone ce repo :

    ```bash
    git clone https://github.com/La-Capsule-Dev/toolbox_v1.git
    cd toolbox_v1
    ```

2. Installe les dépendances et lance le projet :

    ```bash
    npm install
    npm run tauri dev
    ```

---

## 🌱 Création de branches

-   Ne travail **jamais** sur `main` ou `dev`

-   Crée une branche à partir de `dev` :

    ```bash
    git checkout dev
    git pull
    git checkout -b feature/<nom_de_ta_feature>
    ```

-   Nomme bien ta branche :

    -   `feature/<nom>` pour une nouvelle fonctionnalité

    -   `fix/<nom>` pour une correction de bug

    -   `doc/<nom>` pour de la documentation

    -   `refactor/<nom>` pour du nettoyage de code

---

## 🧹 Formatage & standards

Avant de commit, vérifie que ton code est propre :

```bash
npm run lint
npm run format
```

Tu peux aussi configurer _Prettier_ et _ESLint_ dans ton éditeur.

---

## ✅ Checklist pour une PR

-   ◻️ La branche cible est bien `dev`

-   ◻️ Le code a été testé en local

-   ◻️ La PR est claire, avec un titre explicite et une description utile

-   ◻️ Les commentaires inutiles ont été sipprimés

-   ◻️ Le code suit le style du projet

---

## 💬 Discuter avant de coder

Si tu veux :

-   Proposer une grosse feature

-   Repenser un comportement

-   Ajouter une dépendance externe

Merci d'**ouvrir une issue** d'abord, pour en discuter avec l'équipe.

---

## 🧠 Besoin d'aide ?

Tu peux nous contacter via :

-   Les issues GitHub

-   Discussions

Merci encore de ton intérêt pour ce projet ! ❤️

---
