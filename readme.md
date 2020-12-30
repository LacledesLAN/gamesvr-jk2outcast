# Jedi Knight II: Jedi Outcast Dedicated Server in Docker

Star Wars Jedi Knight II: Jedi Outcast is a first and third-person shooter video game, released in 2002 for multiple platforms. A Nintendo Switch and PlayStation 4 ports were released in September 2019.

![Jedi Knight II: Jedi Outcast Banner Image](https://raw.githubusercontent.com/LacledesLAN/gamesvr-jk2outcast/main/.misc/banner.jpg)

This repository is maintained by [Laclede's LAN](https://lacledeslan.com). Its contents are intended to be bare-bones and used as a stock server. For an example of building a customized server from this Docker image browse the related child-project [gamesvr-jk2outcast-freeplay](https://github.com/LacledesLAN/gamesvr-jk2outcast-freeplay). If any documentation is unclear or it has any issues please see [CONTRIBUTING.md](./CONTRIBUTING.md).

## Important Notes

* This docker image uses the [JK2MV](https://github.com/mvdevs/jk2mv) community-made patch to improve, secure, and modernize the game server.
* This server requires the addition of content files `assets0.pk3`, `assets1.pk3`, `assets2.pk3`, `assets5.pk3` from the retail version of the game to work.

> All example commands and the VSCode tasks assume there's a `./base/` directory on the docker host that contains the required asset files.

## Linux

### Download

```shell
docker pull lacledeslan/gamesvr-jk2outcast
```

### Run Simple, Interactive Server

```shell
docker run -it --rm -p 207080:207080/tcp -p 207080:207080/udp -v ./base/assets0.pk3:/app/base/assets0.pk3 -v ./base/assets1.pk3:/app/base/assets1.pk3 -v ./base/assets2.pk3:/app/base/assets2.pk3 -v ./base/assets5.pk3:/app/base/assets5.pk3 lacledeslan/gamesvr-jk2outcast ./jk2mvded +exec server.cfg;
```

## Getting Started with Game Servers in Docker

[Docker](https://docs.docker.com/) is an open-source project that bundles applications into lightweight, portable, self-sufficient containers. For a crash course on running Dockerized game servers check out [Using Docker for Game Servers](https://github.com/LacledesLAN/README.1ST/blob/master/GameServers/DockerAndGameServers.md). For tips, tricks, and recommended tools for working with Laclede's LAN Dockerized game server repos see the guide for [Working with our Game Server Repos](https://github.com/LacledesLAN/README.1ST/blob/master/GameServers/WorkingWithOurRepos.md). You can also browse all of our other Dockerized game servers: [Laclede's LAN Game Servers Directory](https://github.com/LacledesLAN/README.1ST/tree/master/GameServers)
