<p align="center">
  <img width="50%" src="./server/public/assets/readme/refitted-large.png">
</p>

<br />
<br />

![Koa.JS](https://img.shields.io/badge/Koa.JS-%23121011.svg?style=for-the-badge)
![NodeJS](https://img.shields.io/badge/node.js-6DA55F?style=for-the-badge&logo=node.js&logoColor=white)
![TypeScript](https://img.shields.io/badge/typescript-%23007ACC.svg?style=for-the-badge&logo=typescript&logoColor=white)
![SQLite](https://img.shields.io/badge/sqlite-%2307405e.svg?style=for-the-badge&logo=sqlite&logoColor=white)
![ActionScript](https://img.shields.io/badge/ActionScript-%23DD0031.svg?style=for-the-badge)
![Flash](https://img.shields.io/badge/Flash-%23CF4647.svg?style=for-the-badge)

## Repo Information
We are running a lightweight [Koa](https://koajs.com/) server written in [TypeScript](https://www.typescriptlang.org/), with an [SQLite](https://www.sqlite.org/index.html) database leveraging [MikroORM](https://mikro-orm.io/), as our ORM of choice. The client is written in [ActionScript 3](https://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/index.html) and uses [Adobe FlashPlayer](https://www.adobe.com/products/flashplayer/end-of-life.html) to display its content. 

This repository contains the entire modified SWF (Shockwave Flash) client files, along with the corresponding server component rebuilt from the ground up for Kixeye's 2010 Flash client, Backyard Monsters. The client is running on version 128.5690.

<br>

## 🚀 How to Play
We recommend to run the game in the native Flash Player 32, included in the root of this repository. However, you can also play by using [Ruffle](https://ruffle.rs/) for either Web or Desktop.

<br>

## Server setup

1. Clone this repository and checkout the develop branch:

```bash
git clone http://178.32.125.55:25590/monkey-patch/backyard-monsters-refitted
```

<br />

2. Follow the instructions carefully on our [server setup & configuration](/monkey-patch/backyard-monsters-refitted/wiki/Server-%26-Database-Setup) Wiki page.

<br />

## Client Setup

1. Follow the instructions carefully on our [client setup & configuration](/monkey-patch/backyard-monsters-refitted/wiki/Client-Setup%2C-IntelliSense-%26-Configuration) Wiki page.

2. To contribute you will need to copy your changes to the src directory. If you are wondering why we are using this horrible workflow please see [CONTRIBUTING.md](./CONTRIBUTING.md) for more information. If you are able to figure out how to compile directly to swf without unlinking all assets, please let us know.

<br />

## Releases

You can find the most recent release of the game here: [backyard-monsters-refitted-stable](/monkey-patch/backyard-monsters-refitted/releases)
