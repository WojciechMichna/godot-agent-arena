# godot-agent-arena

A Docker container that runs the Godot Engine with noVNC and Apache Guacamole, making it accessible directly from a web browser — built specifically for testing browser-based AI agents.

## What is this?

This project spins up a Docker container with Godot 4.6.2 running inside a virtual display (Xvfb), exposed via two different browser access methods:

- **noVNC** (lightweight, websocket-based) — connect directly on port `9488`
- **Apache Guacamole** (full remote desktop gateway) — connect on port `8080`

You open a browser, connect to the container, and get a fully interactive Godot editor — no local installation needed.

## Why two access methods?

Testing revealed that **the access method matters for AI agent performance**. Guacamole renders the remote session differently than noVNC, and some agents handle one much better than the other. In particular, Copilot performs significantly better when connected through Guacamole compared to noVNC.

## Purpose

This is a testbed for evaluating how well **browser-based AI agents** can operate as general-purpose GUI automation tools. The agents being tested:

- **Copilot** (Edge)
- **Comet** (Perplexity)
- **Claude in Chrome** (Anthropic)

The workflow: start the container, open Godot in the browser, and instruct a browser agent to click through the editor and build a project from scratch.

## Demo Videos

### Copilot (Edge)
#### Guacamole
[Edge Copilot Guacamole Fail.webm](https://github.com/user-attachments/assets/f949dbdc-1b41-4f3a-92fa-576b1edeeb52)
#### NoVnc
[Edge Copilot NoVNC Fail.webm](https://github.com/user-attachments/assets/44a28a63-3d1f-4236-b4bd-a8ebd9f61823)


### Claude in Chrome (Anthropic)
#### Guacamole
[Chrome Sonnet Guacamole Fail.webm](https://github.com/user-attachments/assets/623bf8ca-c37a-4ec7-b68d-3c33a79ecedf)
### NoVnc
[Chrome Sonnet NoVnc Fail.webm](https://github.com/user-attachments/assets/e4450d92-cd44-4687-ae92-6c17302be0ca)

### Comet (Perplexity)
#### Sonnet
[Comet Sonet NoVnc OK.webm](https://github.com/user-attachments/assets/61bd42e6-2c8b-4805-bd40-c3f948c7ae79)
#### Gemini
[Comet Gemini NoVnc OK.webm](https://github.com/user-attachments/assets/360726df-4240-444f-85d9-f81a5cf50c7d)
#### Sonar
##### Guacamole
[Comet Sonar Guacamole OK.webm](https://github.com/user-attachments/assets/5691d212-5519-46ac-9cca-495f7aba1b81)
##### NoVnc
[Comet Sonar NoVnc.webm](https://github.com/user-attachments/assets/55c2c270-2c14-457f-999b-b569b476211f)



### Running multiple agents in parallel
[Parallel execution.webm](https://github.com/user-attachments/assets/84b9bb5c-a215-4ce4-afc0-8b51d4976dbe)


## Key Features

- **Browser-accessible Godot** — two access methods: noVNC (lightweight) and Guacamole (higher fidelity).
- **GPU support** — optional GPU-accelerated builds (`Dockerfile_gpu`) for rendering-heavy tasks.
- **Multiple simultaneous containers** — auto-assigned ports let you run several containers in parallel, each with a different browser agent.
- **Shared project directory** — `godot_projects/` is mounted into every container for easy comparison of results.

## Quick Start

### Pre-built image (no build required)

The image is available on Docker Hub — you can skip the build step entirely:

```
docker pull 0wojciechmichna/vnc_godot:0.1       # CPU version
docker pull 0wojciechmichna/vnc_godot:0.1-gpu   # GPU version
```

All the start scripts (`start_docker.bat`, `check_and_start_docker.bat`) already reference this image, so just clone the repo and run.

### Single container (noVNC)

```bash
cd VncDockerGodot
start_docker.bat           # pulls from Docker Hub and starts on ports 9488 (noVNC) + 5900 (VNC)
```

Open `http://localhost:9488` in your browser. VNC password: `123123`

### Single container (Guacamole)

```bash
cd VncDockerGodot
start_guacamole.bat        # starts Guacamole gateway on port 8080
start_docker.bat           # start the Godot container
```

Open `http://localhost:8080` and connect to the VNC session through Guacamole.

### Running multiple containers in parallel

The `check_and_start_docker.bat` script (in the root directory) automatically detects running containers and assigns the next available port pair:

```bash
# Terminal 1 — starts vnc_docker_1 on ports 9488 / 5900
check_and_start_docker.bat

# Terminal 2 — starts vnc_docker_2 on ports 9489 / 5901
check_and_start_docker.bat

# Terminal 3 — starts vnc_docker_3 on ports 9490 / 5902
check_and_start_docker.bat
```

Now you can point three different browser agents at three different URLs simultaneously:

| Agent             | Container      | noVNC URL                  |
|-------------------|----------------|----------------------------|
| Copilot (Edge)    | vnc_docker_1   | `http://localhost:9488`    |
| Claude in Chrome  | vnc_docker_2   | `http://localhost:9489`    |
| Comet (Perplexity)| vnc_docker_3   | `http://localhost:9490`    |

Each agent works in its own isolated Godot instance. The shared `godot_projects/` volume lets you compare what each agent produced.

### Using docker-compose (recommended for parallel runs)

Instead of running `check_and_start_docker.bat` multiple times, you can use `docker-compose.yml` to spin up any number of Godot instances with a single command:

```bash
cd VncDockerGodot

# Start 3 instances + Guacamole
docker compose up -d --scale godot=3

# Need more? Scale up to 8
docker compose up -d --scale godot=8

# Done testing? Shut everything down
docker compose down
```

Docker automatically assigns ports from the range `9488–9499` (noVNC) and `5900–5911` (VNC). To see which container got which port:

```bash
docker compose ps
```

Guacamole is always available at `http://localhost:8080`.

## How `godot_projects/` works

The `godot_projects/` folder is the shared seed directory mounted into every container. On startup, the entrypoint script copies its contents into the container so that Godot opens with an existing project ready to go.

This enables an iterative evolutionary workflow:

1. Place your current project state in `godot_projects/`
2. Spin up multiple containers — each agent gets the same starting point
3. Let every agent work on the project independently
4. Compare the results, pick the best one
5. Copy the winner back into `godot_projects/`
6. Repeat

This way you can evolve a Godot project over multiple rounds, always selecting the best agent output as the seed for the next iteration — survival of the fittest, but for AI-generated game projects.

## Connection Credentials

| Service    | Password  |
|------------|-----------|
| VNC/noVNC  | `123123`  |

## Project Structure

```
godot-agent-arena/
├── .gitignore
├── Dockerfile                   # Standard CPU build
├── Dockerfile_gpu               # GPU-accelerated build
├── entrypoint.sh                # Container entrypoint (runs boot scripts)
├── 78-start-vnc.sh              # Starts Xvfb + x11vnc + noVNC
├── 78-start-vnc-gpu.sh          # Same but with GPU rendering
├── 79-start-godot.sh            # Starts Godot in the virtual display
├── 79-start-godot-gpu.sh        # Same but with GPU rendering
├── build_vnc.bat                # Build script (CPU)
├── build_vnc_gpu.bat            # Build script (GPU)
├── start_docker.bat             # Single-container start
├── start_docker_gpu.bat         # Single-container start (GPU)
├── start_guacamole.bat          # Starts Apache Guacamole gateway
├── check_and_start_docker.bat   # Launcher with auto port assignment (parallel)
├── docker-compose.yml           # Multi-instance setup (scale godot=N)
├── godot_projects/              # Seed projects copied into containers on startup
└── guacamole_config/            # Guacamole configuration (contents gitignored)
```
