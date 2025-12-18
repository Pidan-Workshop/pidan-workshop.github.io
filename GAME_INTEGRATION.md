# Defold Game Integration Guide

This document explains how to integrate your Defold HTML5 games into the Pidan Workshop website.

## Exporting from Defold

1. In Defold Editor, go to **Project → Bundle → HTML5**
2. Select a destination folder
3. Defold will generate several files:
   - `index.html` - Main HTML file
   - `dmengine.js` - Game engine
   - `archive_files.json` - Asset manifest
   - Game data files and assets

## Integration Steps

### 1. Create Game Directory

Create a new folder under `games/` for your game:
```
games/your-game-name/
```

### 2. Copy Defold Export Files

Copy all the exported files from Defold into your game directory:
```
games/your-game-name/
├── index.html
├── dmengine.js
├── archive_files.json
└── [other game files]
```

### 3. Modify index.html (Optional)

You may want to customize the exported `index.html`:

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your Game Name - Pidan Workshop</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            background: #000;
        }
        canvas {
            display: block;
            margin: 0 auto;
        }
    </style>
</head>
<body>
    <canvas id="canvas" tabindex="1"></canvas>
    
    <script src="dmengine.js"></script>
    <script>
        // Defold engine configuration
        var Module = {
            TOTAL_MEMORY: 256 * 1024 * 1024,
            canvas: document.getElementById('canvas'),
            // Add more configuration as needed
        };
    </script>
</body>
</html>
```

### 4. Add Game Metadata

Update `_data/games.yml` to add your game to the showcase:

```yaml
- id: your-game-name
  title:
    en: "Your Game Title"
    zh: "你的游戏标题"
  description:
    en: "A brief description of your game"
    zh: "游戏的简短描述"
  thumbnail: "/assets/images/games/your-game-thumb.jpg"
  path: "/games/your-game-name/"
  release_date: 2025-12-18
  tags: ["genre", "2d"]
  featured: true  # Set to true to show on homepage
```

### 5. Add Thumbnail Image

Add a thumbnail image (recommended: 600x400px) to:
```
assets/images/games/your-game-thumb.jpg
```

### 6. Test Locally

Run Jekyll locally to test:
```bash
bundle exec jekyll serve
```

Visit: `http://localhost:4000/games/your-game-name/`

## Tips

### Canvas Sizing

Defold exports typically use a fixed canvas size. You may want to make it responsive:

```javascript
function resizeCanvas() {
    var canvas = document.getElementById('canvas');
    var container = canvas.parentElement;
    var scale = Math.min(
        container.clientWidth / canvas.width,
        container.clientHeight / canvas.height
    );
    canvas.style.transform = `scale(${scale})`;
}

window.addEventListener('resize', resizeCanvas);
resizeCanvas();
```

### Loading Screen

Add a custom loading screen:

```html
<div id="loading-screen">
    <div class="spinner"></div>
    <p>Loading game...</p>
</div>

<script>
    Module.setStatus = function(text) {
        if (text === '') {
            document.getElementById('loading-screen').style.display = 'none';
        }
    };
</script>
```

### Back to Games Link

Add a link back to the games page:

```html
<div class="game-header">
    <a href="/en/games/">← Back to Games</a>
</div>
```

## Common Issues

### Paths Not Working

If assets aren't loading, check that paths are relative to the game directory:
```javascript
// Correct
Module.archiveLocationFilter = function(path) {
    return "./" + path;
};
```

### Memory Issues

If the game crashes, increase the memory allocation:
```javascript
var Module = {
    TOTAL_MEMORY: 512 * 1024 * 1024, // Increase from 256MB to 512MB
};
```

### Mobile Responsiveness

Add touch controls and responsive canvas sizing for mobile devices.

## Example

See the sample game at `games/sample-game/` for a complete example structure.
