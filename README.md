# XRay pour Minecraft (TLauncher) — activable / désactivable

Pack de ressources qui rend **invisibles les blocs de terrain** (pierre, terre,
deepslate, netherrack, etc.) pour laisser apparaître **les minerais, grottes et
structures**. Tu l'actives ou le désactives quand tu veux.

Fichiers :
| Fichier | Rôle |
|---|---|
| `XRay.zip` | Le pack de ressources |
| `XRay-ON.bat` | Active le X-Ray (copie le pack + l'ajoute à `options.txt`) |
| `XRay-OFF.bat` | Désactive le X-Ray (retire le pack de `options.txt`) |
| `toggle-xray.ps1` | Le moteur utilisé par les deux .bat |

> À utiliser sur **ta propre partie / ton serveur** avec l'accord des autres joueurs.
> Sur les serveurs publics, l'anti-triche peut bannir l'usage du X-Ray.

---

## Méthode 1 — les boutons ON / OFF (le plus simple)

1. **Ferme Minecraft** (sinon le jeu écrase `options.txt` en quittant).
2. Double-clic sur **`XRay-ON.bat`** → le pack est activé.
3. Lance Minecraft : le pack est déjà sélectionné.
4. Pour couper : ferme Minecraft, double-clic sur **`XRay-OFF.bat`**.

Une sauvegarde de ton ancien `options.txt` est faite à côté
(`options.txt.xray.bak`).

---

## Méthode 2 — via le jeu (aucun script)

1. Copie `XRay.zip` dans :
   `%APPDATA%\.minecraft\resourcepacks\`
2. Dans Minecraft : `Options` → `Packs de ressources…`
3. Déplace **XRay** vers la colonne de droite pour **activer**, à gauche pour
   **désactiver**. Clique sur `Terminé`.

C'est l'interrupteur on/off natif du jeu.

---

## Comment ça marche

Le pack remplace les **modèles de blocs** des blocs de terrain par un modèle
utilisant une texture **entièrement transparente** (`xray_empty.png`).
Les minerais ne sont pas touchés → ils restent visibles. Résultat : on voit à
travers la roche.

Blocs rendus invisibles : stone, cobblestone, deepslate, granite, diorite,
andesite, tuff, calcite, dripstone, dirt, sand, red_sand, gravel, clay,
netherrack, end_stone, bedrock, obsidian, blackstone, terracotta, stone_bricks,
grass_block, mycelium, podzol, sandstone, red_sandstone, etc.

---

## Compatibilité

- `pack.mcmeta` : `pack_format 34` avec `supported_formats [6, 34]`
  → fonctionne de **1.16.x à 1.21.x** (testé pour 1.16.5 et 1.21.1).
- Si le jeu affiche « pack incompatible » (anciennes versions), clique sur
  **Oui / Continuer** : le pack se charge quand même.

---

## Notes

- L'eau, la lave et les feuilles restent visibles (repères).
- Sur un monde **moddé**, les blocs de mods ne sont pas affectés.
- Ce pack ne modifie **aucun fichier de jeu** : il ne touche que l'affichage.
- Placement des minerais : le X-Ray ne fait que *voir* ; il ne génère rien.
