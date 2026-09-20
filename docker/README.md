# Run the learning period with Docker

Install [Docker Engine](https://docs.docker.com/engine/install/) on Linux or
Docker Desktop on macOS/Windows (run these scripts from WSL 2 on Windows).
Docker must be running. If Docker reports permission denied on Linux, prefix
host Docker commands and the build/run scripts with `sudo`.

## 1. Build the image

From this repository:

```bash
bash docker/build.sh
```

The image installs ROS 2 Humble, compiler/colcon tools, and dependencies from
all package manifests, including vision, PCL, and the Foxglove bridge.
Only this repository is sent to Docker; host build artifacts are excluded.
The default platform is AMD64. For native ARM64 use
`PLATFORM=linux/arm64 bash docker/build.sh`.
Rebuild the image when package dependencies change.

## 2. Start the container and compile

```bash
bash docker/run.sh
```

Inside the container:

```bash
colcon build --symlink-install --executor sequential
source /ros2_ws/install/setup.bash
ros2 run talker talker_node
```

The container contains only the learning-period repository under `/ros2_ws/src`.
Source edits are shared with the host. Build/install/log directories stay inside
the container, avoiding conflicts with native builds. After editing code, stop
your node, rerun `colcon build`, and source the workspace again.

## 3. Open another terminal

On the host, while the first container is still running:

```bash
docker exec -it software-learning-period bash
```

ROS and the compiled workspace are sourced automatically. For example:

```bash
ros2 topic echo /talker_pose
```

Use `docker exec` for additional terminals, rather than starting another container.

## 4. Run the traffic city

Inside the container, after compiling:

```bash
ros2 launch transit_sim transit_sim.launch.py
```

In another container terminal opened using `docker exec`:

```bash
python3 /ros2_ws/src/software-learning-period/traffic-sim/transit_sim/scripts/drive_city.py
```

Connect Foxglove on your host to `ws://localhost:8765`, then import
`traffic-sim/transit_sim/config/transit_city.json` from this repository.
See the [sim guide](../traffic-sim/transit_sim/README.md) for visualization details.
The scripts expose this port on localhost; GUI/X11 forwarding for RViz is not configured.

## Stopping and restarting

Stop nodes with Ctrl+C and type `exit` in the original container shell.
The container is removed when that shell exits: source edits persist, but compiled
artifacts and packages installed manually inside the container do not.
Run `bash docker/run.sh` and compile again next time. Add permanent dependencies
to package manifests and rebuild the image.

`IMAGE` overrides the image tag for both scripts; `CONTAINER_NAME` overrides the
run script's container name. The separate state-machine exercise requires the
additional repository described in [its instructions](../state_machines/README.md).
