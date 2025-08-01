# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a LÖVE (Love2D) game project called "Playground" - a 2D game engine framework built with Lua. The project appears to be exploring game development concepts including roguelike, souls-like, and Nintendo-style mechanics as outlined in `playdoc.md`.

## Development Commands

### Building and Running
```bash
# Build the game (creates build/playground.love)
make love

# Run the game directly
make run

# On Windows, use PowerShell script instead:
.\make.ps1 run

# Build for web (requires npm)
make love.js
```

### Development Tools
```bash
# Run linting on Lua files
make lint

# Run validation and lint checks
make validate

# Run tests
make test

# Clean build artifacts
make clean

# Generate contributors list (requires Python venv)
make contributors
```

### Platform-Specific Builds
```bash
# Build binaries for all platforms
make binaries

# Individual platform builds:
make build/hawkthorne-win32.zip
make build/hawkthorne-win64.zip
make build/hawkthorne-macos.zip
make build/hawkthorne-linux.AppImage
```

## Architecture

### Core Structure
- **Entry Point**: `src/main.lua` - Sets up Love2D callbacks and initializes the game
- **Configuration**: `src/conf.lua` - Love2D configuration (window size, modules, etc.)
- **Game State Management**: Uses `vendor/gamestate.lua` for scene transitions
- **Update Loop**: `src/update.lua` - Main game update screen with loading/transition logic

### Key Systems
- **CLI System**: `src/system/cli.lua` - Command-line argument parsing with extensive debug options
- **Frame Pacing**: `src/system/frame_pacer.lua` - Frame rate monitoring and visualization
- **Collision**: `src/system/collider.lua` - Physics/collision detection system
- **Window Management**: `src/ui/window.lua` - UI and window handling
- **Video System**: `src/system/video.lua` - Graphics and rendering utilities

### Scenes
- Scene-based architecture using gamestate pattern
- Scenes located in `src/scenes/` (intro_scene.lua, pause_scene.lua)
- Scene transitions handled through gamestate switching

### Vendor Dependencies
- **gamestate.lua**: State management
- **cliargs.lua**: Command-line argument parsing
- **TEsound.lua**: Audio management
- **vector.lua**: Vector mathematics

## Development Workflow

### Testing and Debugging
- Use `--test` flag to run unit tests
- Debug options available via CLI: `--debug`, `--bbox` for bounding boxes
- Character and level selection: `--character=NAME`, `--level=NAME`
- Position jumping: `--position=X,Y`, `--door=NAME`

### Code Standards
- Lua files are linted using custom script
- Vendor code is excluded from linting
- Test files are excluded from linting
- Use nearest-neighbor filtering for pixel art graphics

## Platform Support
- Cross-platform Love2D game (Windows, macOS, Linux)
- Web deployment via love.js
- AppImage support for Linux distribution
- PowerShell build script for Windows development