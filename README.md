# Garry's Mod Pterodactyl Docker Image

Custom Docker image for running Garry's Mod servers on Pterodactyl Panel, with built-in Git support for automatic repository management.

## Features

- ✅ Based on official `ghcr.io/ptero-eggs/games:source` image
- ✅ Pre-installed Git for repository cloning/updates
- ✅ Supports public and private GitHub repositories
- ✅ Automatic file synchronization on server startup
- ✅ All labels translated to French
- ✅ Fully configured for Pterodactyl Panel

## Quick Start

### 1. Build the Image

```bash
./build.sh
```

Or manually:
```bash
docker build -t ghcr.io/mokka/gmod-pterodactyl:latest .
```

### 2. Test Locally with Docker Compose

```bash
docker-compose up -d
```

### 3. Push to GitHub Container Registry

```bash
# First, login to GitHub
docker login ghcr.io

# Then push
./push.sh
```

## Repository Structure

```
egg/
├── Dockerfile                    # Custom Docker image definition
├── docker-compose.yml            # Local testing configuration
├── build.sh                      # Build script
├── push.sh                       # Push to GitHub script
├── egg-garry-s-mod.json         # Pterodactyl egg (French)
├── egg-garry-s-mod-x64-github.json  # Pterodactyl egg x64 (French)
└── README.md                     # This file
```

## GitHub Setup

### Create Personal Access Token

1. Go to https://github.com/settings/tokens
2. Create new token with scopes:
   - `read:packages` (download images)
   - `write:packages` (upload images)
3. Save the token

### Login to GitHub Container Registry

```bash
docker login ghcr.io
# Username: YOUR_GITHUB_USERNAME
# Password: YOUR_GITHUB_TOKEN
```

## Pterodactyl Configuration

### Update Egg File

Edit `egg-garry-s-mod-x64-github.json` and update the `docker_images` section:

```json
"docker_images": {
    "ghcr.io/mokka/gmod-pterodactyl:latest": "ghcr.io/mokka/gmod-pterodactyl:latest"
}
```

Replace `mokka` with your GitHub username.

### Import Egg into Pterodactyl

1. Go to Pterodactyl Admin Panel
2. Nests > Games > Add Egg
3. Choose "From JSON File"
4. Upload the modified egg file

## Startup Command

The image uses a simplified startup command (no need for apt-get git installation):

```bash
bash -c 'GIT_REPO_PATH=/mnt/server/git-config; if [ "$GIT_AUTO_UPDATE" = "1" ] && [ -n "$GIT_REPO" ] && command -v git &>/dev/null; then GIT_URL="$GIT_REPO"; [ -n "$GIT_TOKEN" ] && GIT_URL="https://$GIT_TOKEN@${GIT_REPO##*//*}"; if [ -d "$GIT_REPO_PATH" ]; then cd $GIT_REPO_PATH && git fetch origin && git checkout $GIT_BRANCH && git pull origin $GIT_BRANCH; else git clone --branch $GIT_BRANCH "$GIT_URL" $GIT_REPO_PATH; fi; [ -d "$GIT_REPO_PATH/garrysmod/addons" ] && cp -rf $GIT_REPO_PATH/garrysmod/addons/* /mnt/server/garrysmod/addons/ 2>/dev/null; [ -d "$GIT_REPO_PATH/garrysmod/gamemodes" ] && cp -rf $GIT_REPO_PATH/garrysmod/gamemodes/* /mnt/server/garrysmod/gamemodes/ 2>/dev/null; fi; cd /home/container && ./srcds_run -game garrysmod -console -port $SERVER_PORT +ip 0.0.0.0 +host_workshop_collection $WORKSHOP_ID +map $SRCDS_MAP +gamemode $GAMEMODE -strictportbind -norestart +sv_setsteamaccount $STEAM_TOKEN +maxplayers $MAX_PLAYERS -tickrate $TICKRATE $( [ "$LUA_REFRESH" = "1" ] || printf %s "-disableluarefresh" )'
```

## Configuration Variables

### Core Settings
- **Carte** (SRCDS_MAP): Default map - `gm_flatgrass`
- **Jeton de Compte Steam** (STEAM_TOKEN): 32-char token for public listing
- **Mode de Jeu** (GAMEMODE): `sandbox`, `terrortown`, etc.
- **Nombre Maximum de Joueurs** (MAX_PLAYERS): 1-128 (default: 32)
- **Tickrate** (TICKRATE): 1-100 (default: 22)

### GitHub Settings
- **URL du Référentiel GitHub** (GIT_REPO): Full GitHub URL `https://github.com/user/repo.git`
- **Branche GitHub** (GIT_BRANCH): Branch name (default: `main`)
- **Jeton GitHub** (GIT_TOKEN): Personal access token (for private repos)
- **Mise à Jour Automatique Git** (GIT_AUTO_UPDATE): `1` to enable auto-update on boot

### Advanced
- **Branche Bêta du Serveur** (SRCDS_BETA_BRANCH): Beta branch for Source engine
- **ID Collection Workshop** (WORKSHOP_ID): Steam Workshop collection ID
- **Actualisation Lua** (LUA_REFRESH): Enable/disable Lua code refresh

## Troubleshooting

### Build fails
```bash
# Clear Docker cache
docker system prune -a
./build.sh
```

### Authentication error
```bash
# Re-authenticate to GitHub
docker logout ghcr.io
docker login ghcr.io
```

### Server won't start
Check the startup command doesn't have unclosed quotes or syntax errors. The image should provide git automatically.

## File Locations

Inside the container:
- Server files: `/mnt/server/`
- Git cloned files: `/mnt/server/git-config/`
- Game executable: `/home/container/srcds_run`
- Addons: `/mnt/server/garrysmod/addons/`
- Gamemodes: `/mnt/server/garrysmod/gamemodes/`

## Building on Different Platforms

### Linux/Mac
```bash
./build.sh
./push.sh
```

### Windows (PowerShell)
```powershell
# Edit build.sh and push.sh for Windows paths, or use:
docker build -t ghcr.io/mokka/gmod-pterodactyl:latest .
docker push ghcr.io/mokka/gmod-pterodactyl:latest
```

## Support

For issues with:
- **Pterodactyl Panel**: https://pterodactyl.io/community
- **Garry's Mod**: https://wiki.garrysmod.com/
- **Docker**: https://docs.docker.com/

## License

Based on Pterodactyl's official game images.
