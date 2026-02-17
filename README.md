# Volcanic Terraformation

<img src="thumbnail.png" alt="Thumbnail" style="max-width: 400px; display: block; margin: 0 auto;">
<br/>

A Factorio Space Age mod that introduces a two-stage terraforming process for converting lava into buildable terrain on Vulcanus.

Expand your industrial operations across volcanic landscapes through hazardous suppression and structural reinforcement. This mod bridges the gap between early-game lava restrictions and late-game Foundation technology, requiring careful planning and planetary resource coordination.

**Status:** In Development

---

## Project Structure

```
volcanic-terraformation/
├── info.json                    # Mod metadata (REQUIRED)
├── data.lua                     # Prototype definitions
├── changelog.txt                # Version history
├── thumbnail.png                # 144x144px mod icon
├── locale/
│   └── en/
│       └── locale.cfg           # English translations
├── docs/
│   └── requirements.md         # Detailed mod requirements
└── README.md                    # This file
```

## Development Setup

### Prerequisites

- Factorio 2.0+ with Space Age expansion
- Lua development environment (VS Code recommended)

### Local Testing

1. **Manual Installation**
   - Copy or symlink the mod folder to your Factorio mods directory:
     - Windows: `%APPDATA%\Factorio\mods\`
     - macOS: `~/Library/Application Support/factorio/mods/`
     - Linux: `~/.factorio/mods/`
   - The folder should be named `volcanic-terraformation_0.1.0` (or match version in `info.json`)

2. **Testing**
   - Launch Factorio
   - Enable the mod in the mods menu
   - Start a new game or load an existing save
   - The mod should load without errors (currently a no-op mod)

### Packaging

To create a mod zip file for distribution:

```bash
git archive --format zip --prefix volcanic-terraformation_0.1.0/ --output volcanic-terraformation_0.1.0.zip HEAD
```

Or manually zip the mod folder, ensuring it's named `{mod-name}_{version}.zip`.

### Development Tools

**Recommended VS Code Extensions:**
- Factorio Modding Tool Kit (FMTK) - Debug adapter, JSON validation, Lua support
- Lua Language Server - Better Lua editing experience

**Testing Frameworks:**
- [FactorioTest](https://github.com/GlassBricks/FactorioTest) - In-game testing framework
- [Faketorio](https://luarocks.org/modules/jasonmiles/faketorio) - Unit testing library

**Resources:**
- [Factorio Lua API Documentation](https://lua-api.factorio.com/latest/)
- [Factorio Mod Portal](https://mods.factorio.com/)
- [Factorio Modding Wiki](https://wiki.factorio.com/Modding)

## Current Status

This mod is currently in bootstrap phase with a no-op data stage. The mod structure is set up and ready for prototype implementation.

See [docs/requirements.md](docs/requirements.md) for detailed feature specifications.

## License

[To be determined]
