# fms-videos

Edición de videos verticales con la skill **video-use** (`.claude/skills/video-use/`).

## Entorno

- `scripts/instalar.sh` corre en cada inicio/reanudación de sesión en la nube (hook `SessionStart`) e instala `ffmpeg` y las dependencias de Python de video-use si faltan.
- La clave de ElevenLabs se lee **solo** de la variable de entorno `ELEVENLABS_API_KEY`. Nunca la pidas, nunca la escribas en un archivo ni en un `.env`, nunca la subas al repo. Si falta, avisa que hay que añadirla a las variables del entorno de la nube.

## Flujo de trabajo

1. **Descargar fuentes**: los videos fuente llegan como assets de un Release de GitHub.
   ```bash
   gh release download <tag> -D entrada/
   ```
   `entrada/` está en `.gitignore`: los videos fuente nunca se commitean.
2. **Editar** con la skill video-use (leer `.claude/skills/video-use/SKILL.md`), usando `entrada/` como carpeta de videos. Lo que la skill genera queda en `entrada/edit/`.
3. **Exportar**: copiar el `final.mp4` a `salida/` cumpliendo:
   - Códec de video **H.264** (`libx264`, `yuv420p`, audio AAC, `-movflags +faststart`).
   - Resolución **1080x1920** (vertical).
   - Tamaño **menor a 90 MB**. Si se pasa, recodificar bajando el bitrate (p. ej. `-crf` más alto o `-b:v` calculado según la duración).

   Verificar antes del commit:
   ```bash
   ffprobe -v error -select_streams v:0 -show_entries stream=codec_name,width,height -of csv=p=0 salida/<archivo>.mp4   # h264,1080,1920
   du -m salida/<archivo>.mp4                                                                                            # < 90
   ```
4. **Commit**: solo se commitea lo que está en `salida/`. No commitear nada de `entrada/` ni archivos intermedios.
