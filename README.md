<p align="center">
  <img width="80%" src="./server/public/assets/popups/base-destroyed.png">
</p>

<br />
<br />

![Koa.JS](https://img.shields.io/badge/Koa.JS-%23121011.svg?style=for-the-badge)
![NodeJS](https://img.shields.io/badge/node.js-6DA55F?style=for-the-badge&logo=node.js&logoColor=white)
![TypeScript](https://img.shields.io/badge/typescript-%23007ACC.svg?style=for-the-badge&logo=typescript&logoColor=white)
![Redis](https://img.shields.io/badge/redis-%23DD0031.svg?style=for-the-badge&logo=redis&logoColor=white)
![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)
![Postgres](https://img.shields.io/badge/postgres-%23316192.svg?style=for-the-badge&logo=postgresql&logoColor=white)
![ActionScript](https://img.shields.io/badge/ActionScript-%23DD0031.svg?style=for-the-badge)

## Repo Information
We are running a lightweight [Koa](https://koajs.com/) server written in [TypeScript](https://www.typescriptlang.org/), with a [PostgreSQL](https://www.postgresql.org/) database leveraging [MikroORM](https://mikro-orm.io/), as our ORM of choice. The client is written in [ActionScript 3](https://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/index.html) and uses [Adobe FlashPlayer](https://www.adobe.com/products/flashplayer/end-of-life.html) to display its content. 

This repository contains the entire modified SWF (Shockwave Flash) client files, along with the corresponding server component rebuilt from the ground up for Kixeye's 2010 Flash client, Backyard Monsters. The client is running on version 128.5690.

<br>

## 🚀 How to Play
We recommend to download our game launcher which can be installed from our website's [download page](https://bymrefitted.com/downloads). This will allow you to seamlessly manage what build versions of the client you play, all from one place, without worrying about manually downloading new versions. The launcher currently supports Windows (64-bit) and Linux.

<br>


## 🗄️ Server setup

The server can either be set up manually by installing the required components on your machine, or through [Docker Compose](https://github.com/bym-refitted/backyard-monsters-refitted/edit/main/README.md#-docker-deployment).

Follow the instructions carefully on our [server setup & configuration](https://github.com/bym-refitted/backyard-monsters-refitted/wiki/Server-&-Database-Setup) Wiki page.

<br />

## 💻 Client Setup
Follow the instructions carefully on our [client setup & configuration](https://github.com/bym-refitted/backyard-monsters-refitted/wiki/Client-Setup-&-Compilation) Wiki page.

To contribute you will need to copy your changes to the src directory. If you are wondering why we are using this horrible workflow please see [CONTRIBUTING.md](./CONTRIBUTING.md) for more information. If you are able to figure out how to compile directly to swf without unlinking all assets, please let us know.

<br />

## 🐳 Docker
For working with Docker directly, follow the instructions carefully on our [Docker Deployment](https://github.com/bym-refitted/backyard-monsters-refitted/wiki/Docker-Deployment) Wiki page.

<br />

## 📱 Android Setup
To compile an APK for Android follow our [Android Application Setup](https://github.com/bym-refitted/backyard-monsters-refitted/wiki/Android-Application-Setup) Wiki page.

<br />

## Preservation of digital heritage
- [Exemption to PCCPSACT](https://www.federalregister.gov/documents/2018/10/26/2018-23241/exemption-to-prohibition-on-circumvention-of-copyright-protection-systems-for-access-control), exemptions to the provision of the Digital Millennium Copyright Act (“DMCA”).
- [EFGAMP](https://efgamp.eu/), the European Federation of Video Game Archives, Museums and Preservation projects.
- [UNESCO PERSIST Programme](https://unescopersist.org/), helps ensure that digital information can continue to be accessed in the future.
- [The Internet Archive](https://archive.org/), a digital library of Internet sites and other cultural artifacts in digital form.
- [Flashpoint Archive](https://flashpointarchive.org/), the webgame preservation project.
- [Adobe Flash Player Archive](https://archive.org/download/flashplayerarchive/), the Adobe Inc. archive.org Flash Player Archive.

<br />

## License [![GPL v3](https://img.shields.io/badge/GPL%20v3-blue)](http://www.gnu.org/licenses/gpl-3.0)

```
Backyard Monsters preservation project.
Copyright (C) 2024 | The Backyard Monsters Refitted team
See the GNU General Public License <https://www.gnu.org/licenses/>.
```
