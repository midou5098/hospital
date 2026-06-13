<div align="center">

# Pyhsics Engine

### A tiny 2D physics sandbox built from scratch with Python, Pygame, math, and SQLite.

![Python](https://img.shields.io/badge/Python-3.x-3776ab?style=for-the-badge&logo=python&logoColor=white)
![Pygame](https://img.shields.io/badge/Pygame-2D%20engine-22c55e?style=for-the-badge)
![SQLite](https://img.shields.io/badge/SQLite-persistence-2563eb?style=for-the-badge&logo=sqlite&logoColor=white)
![Physics](https://img.shields.io/badge/Physics-AABB%20%2B%20Impulse-7c3aed?style=for-the-badge)
![Status](https://img.shields.io/badge/status-learning%20sandbox-f97316?style=for-the-badge)

![Window](window.png)

</div>

---

## What Is This?

**Pyhsics Engine** is a compact interactive physics playground where rectangular bodies fall, collide, bounce, and respond to mouse dragging. It is built around a simple but real physics loop: forces change acceleration, acceleration changes velocity, velocity changes position, and collisions are solved with AABB overlap checks plus impulse response.

The project is small enough to understand in one sitting, but it already includes the foundations of a real 2D simulation engine:

| Layer | What it does |
| --- | --- |
| `app.py` | Runs the Pygame window, event loop, panels, buttons, and object creation flow. |
| `source.py` | Defines UI widgets, physics bodies, world simulation, collisions, dragging, rendering, and SQLite persistence. |
| `database/data.db` | Stores user-created objects so they can load again on startup. |
| `window.png` | Visual panel asset used by the slide-out menu. |

---

## Highlights

| Feature | Description |
| --- | --- |
| Gravity | Every dynamic body receives downward force each frame. |
| Dynamic bodies | Moving rectangles have mass, velocity, acceleration, restitution, color, and name. |
| Static bodies | Floor, ceiling, and walls stay fixed while still colliding with objects. |
| AABB collisions | Rectangle overlap is detected on the X and Y axes. |
| Impulse response | Objects bounce using relative velocity, inverse mass, and restitution. |
| Mouse dragging | Dragged objects follow the cursor using a spring-like force. |
| Object inspector | Right-click an object to view its name, mass, and color. |
| Add-object panel | Create objects from the in-app menu using name, mass, and Pygame color. |
| SQLite save/load | Newly added objects are written to `database/data.db`. |

---

## Visual Flow

```text
Pygame Events
     |
     v
Input + UI Handling
     |
     v
Apply Forces -> Integrate Motion -> Detect Collisions -> Resolve Impulses
     |
     v
Render World + Slide-out Panel
     |
     v
Persist New Objects
```

---

## Physics Core

The simulation is intentionally clear and direct.

### Force Integration

Dynamic objects receive forces, convert them into acceleration, then update velocity and position using delta time:

```python
self.vx += dt * self.ax
self.vy += dt * self.ay
self.x += dt * self.vx
self.y += dt * self.vy
```

### AABB Collision Detection

Collisions are detected by checking rectangle overlap:

```text
overlap_x = min(a.right, b.right) - max(a.left, b.left)
overlap_y = min(a.bottom, b.bottom) - max(a.top, b.top)
```

The smallest overlap axis becomes the collision normal.

### Impulse Resolution

When two bodies move toward each other, the engine computes an impulse using:

- Relative velocity
- Collision normal
- Inverse mass
- Restitution

That impulse changes each body's velocity, producing a bounce.

---

## Controls

| Action | Control |
| --- | --- |
| Drag a dynamic object | Left mouse button |
| Release dragged object | Release left mouse button |
| Inspect an object | Right mouse button |
| Open add-object menu | `menu` button |
| Close side panel | `X` button |
| Type into a field | Click field, then type |
| Delete text | Backspace |

---

## Add Objects In-App

Open the menu and enter:

| Field | Example | Notes |
| --- | --- | --- |
| `name` | `box01` | Short object label. |
| `mass` | `1200` | Must be an integer. |
| `color` | `yellow` | Must be a valid Pygame color name. |

Valid color examples:

```text
red
blue
green
yellow
purple
orange
white
black
```

When added, the object is inserted into the running world and saved into SQLite.

---

## Run It

### 1. Go to the project

```bash
cd /home/bro/my-creations/pyhsics-engine
```

### 2. Create a virtual environment

```bash
python3 -m venv .venv
source .venv/bin/activate
```

### 3. Install dependencies

`requirements.txt` is currently empty, but the app imports `pygame` and `numpy`.

```bash
pip install pygame numpy
```

### 4. Launch the sandbox

```bash
python app.py
```

---

## Repository Map

```text
pyhsics-engine/
|-- app.py              # Main app, event loop, starter objects, menu flow
|-- source.py           # Button, textzone, object, world, physics, SQLite
|-- window.png          # Slide-out side panel image
|-- database/
|   `-- data.db         # SQLite database containing saved objects
|-- objects.db          # Empty database file, currently unused
|-- requirements.txt    # Placeholder dependency file
`-- README.md           # This documentation
```

---

## SQLite Persistence

The active database is:

```text
database/data.db
```

It contains:

```sql
CREATE TABLE "objects" (
    "name" TEXT NOT NULL,
    "mass" INTEGER NOT NULL,
    "color" TEXT NOT NULL
);
```

At startup, saved rows are loaded as dynamic objects. During runtime, newly created objects are inserted into the table.

---

## Current Limits

This is a learning-focused engine, so the simple design is part of the point.

| Limit | Why it matters |
| --- | --- |
| Rectangles only | No circles, polygons, or rotated bodies yet. |
| Pairwise collision checks | Works fine for small scenes, but not optimized for many objects. |
| Friction not fully solved | Objects store friction, but contact friction is not yet part of impulse resolution. |
| Absolute database path | `source.py` currently opens the database with a machine-specific path. |
| Empty requirements file | Dependencies should be added before sharing. |
| Class named `object` | Works, but shadows Python's built-in `object` type. |

---

## Roadmap

- Add circle bodies.
- Add rotated rectangles or polygon collision.
- Add friction impulses.
- Add pause, reset, and clear-world buttons.
- Add object editing and deletion.
- Move the database path to a project-relative path.
- Fill `requirements.txt`.
- Add broad-phase collision detection.
- Add tests for collisions and database persistence.
- Rename `object` to `PhysicsBody`.

---

## Built With

![Python](https://img.shields.io/badge/Python-application%20logic-3776ab?style=flat-square&logo=python&logoColor=white)
![Pygame](https://img.shields.io/badge/Pygame-rendering%20%2B%20input-22c55e?style=flat-square)
![SQLite](https://img.shields.io/badge/SQLite-local%20database-2563eb?style=flat-square&logo=sqlite&logoColor=white)
![Math](https://img.shields.io/badge/Math-vectors%20%2B%20impulses-7c3aed?style=flat-square)

---

## Why This Project Is Useful

This repo is a practical base for learning how small game engines work. It touches the full loop: input, simulation, collision, rendering, UI, and persistence. Because the code is compact, it is also a good place to experiment with new physics features without getting buried in a large framework.

---

## License

No license file is currently included. Add one before publishing or distributing the project.
