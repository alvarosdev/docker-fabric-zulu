<img src="assets/logo_margins.png" align="center" width="300" />

# Fabric Server on Zulu OpenJDK

A lightweight, optimized Docker image for running a [Fabric](https://fabricmc.net/) Minecraft server. It uses **Azul Zulu OpenJDK** (Alpine Linux) for performance and sets optimal Java flags automatically.

## 🚀 Quick Start

The easiest way to run the server is using **Docker Compose**.

1. Create a `docker-compose.yml` file:

```yaml
services:
  minecraft:
    image: ghcr.io/als3bas/zulu-fabricmc:latest
    container_name: fabricserver
    restart: unless-stopped
    ports:
      - "25565:25565"
    volumes:
      - ./minecraft_data:/data
    environment:
      # Memory allocation (Default: 5G)
      - MEMORYSIZE=4G
      # Timezone (optional)
      - TZ=America/Santiago
```

2. Start the server:
```bash
docker-compose up -d
```

3. **That's it!** The server will download the latest compatible Fabric version (defined in the image) and start.

---

## 📂 Managing Files (Mods, Configs, Worlds)

Your server data is stored in the `./minecraft_data` folder (relative to your `docker-compose.yml`).

- **Add Mods**: Drop `.jar` files into `./minecraft_data/mods`.
- **World**: Your world files are in `./minecraft_data/world`.
- **Properties**: Edit `./minecraft_data/server.properties` to change game settings.

After adding mods or changing configurations, restart the server:
```bash
docker-compose restart
```

---

## ⚙️ Configuration

You can configure the server using Environment Variables in your `docker-compose.yml`.

| Variable | Default | Description |
| :--- | :--- | :--- |
| `MEMORYSIZE` | `5G` | Amount of RAM allocated to the server (e.g., `2G`, `4096M`). |
| `PUID` | `-` | User ID to own the files (useful for Linux/macOS permission issues). |
| `PGID` | `-` | Group ID to own the files. |

### Note on Permissions (Linux User?)
If you cannot edit files in the `minecraft_data` folder, set `PUID` and `PGID` to your local user's ID.
Run `id $USER` in your terminal to find your IDs (usually 1000).

```yaml
environment:
  - PUID=1000
  - PGID=1000
```

---

## 🛠️ Build it yourself (Optional)

If you want to build the image locally instead of using the pre-built one:

```bash
docker build -t my-fabric-server .
```

Or just use the `docker-compose.yml` included in this repo (uncomment the build section).


