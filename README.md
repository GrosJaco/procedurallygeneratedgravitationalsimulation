# Procedurally Generated Gravitational Simulation

A Godot 4.6 2D space flight simulation where a fictional, procedurally generated solar system is created with celestial bodies of varying sizes and masses. Players can construct modular spacecraft and pilot them across dynamic gravitational fields.

## Features

- **Orbital Mechanics & Gravity Simulation**: Custom 2D celestial physics with orbital mechanics, Keplerian orbits, and dynamic Sphere of Influence (SOI) transitions between stars, planets, and deep space.
- **Modular Ship Construction**: Vehicle Assembly Building (VAB) featuring snap-to-node part placement, part categories, and blueprint-based ship instantiation.
- **Dynamic Flight Physics**: Real-time dry mass and wet mass calculations based on attached components, fuel consumption, thrust vectors, and reaction wheel torque.
- **Celestial System Generator**: Generates stars and planets with dynamic shaders, corona hazard zones, and custom orbit paths.
- **HUD & Navigation**: Flight telemetry showing current SOI influence, altitude, and relative/absolute velocity, plus an interactive full-system orbital map view.

## Controls

| Key / Input | Action |
| --- | --- |
| `Up` | Main Engine Throttle |
| `Left` / `Right` | Reaction Wheel Rotation |
| `S` | Kill Linear Velocity (Debug Brake) |
| `M` | Toggle System Map View |
| `Mouse Wheel` | Camera Zoom In / Zoom Out |

## Getting Started

### Prerequisites
- [Godot Engine 4.4+](https://godotengine.org/) (Project uses Godot 4.6 features and `.uid` metadata).

### Running the Project
1. Clone this repository:
   ```bash
   git clone https://github.com/GrosJaco/procedurallygeneratedgravitationalsimulation.git
   ```
2. Open the Godot Project Manager.
3. Click **Import** and select the `project.godot` file in this directory.
4. Open the project and press **F5** (or Run) to play the main level (`levels/main.tscn`).

