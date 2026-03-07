# Pineapple Party

Interactive 3D fruit viewer with deformation tools and OpenSCAD export.

## Quick start

```
python3 -m http.server 8765
```

Open http://localhost:8765 in your browser. No install or build step needed.

## Features

**7 fruit models**: Pineapple, pear, dragonfruit, banana, durian, watermelon wedge, starfruit.

**12 sliders**: Extrude, squeeze, roll, smush, galumph, throb, wibble, splay, melt, sulpherate, disco, invert.

**4 deformation tools**: Grab (drag bumps), inflate (push outward), pinch (pull inward), spike (shoot outward). Adjustable brush radius.

**Animation timeline**: Play/pause, scrub, adjustable playback speed and direction.

**SCAD export**: Click "Export SCAD" to download a `.scad` file that matches the current on-screen state — body mesh, bump positions, leaf poses, and all slider effects are captured as a snapshot.

## How it works

Single HTML file using [Three.js](https://threejs.org/) (loaded from CDN). Each fruit is built from a body mesh (lathe, sphere, hull chain, etc.), surface bumps, and leaf/crown decorations. Sliders and deform tools modify positions and scales each frame. The SCAD exporter reads the live mesh data to produce a faithful OpenSCAD reproduction.
