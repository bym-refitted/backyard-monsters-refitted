<img  width="100%" src="https://i.imgur.com/M0aw8WF.jpg">

![Redis](https://img.shields.io/badge/ActionScript-%23DD0031.svg?style=for-the-badge)
![Gulp](https://img.shields.io/badge/Flash-%23CF4647.svg?style=for-the-badge)

## Repo Information
This repository includes all the modified client files for Kixeye's 2010 Flash game, Backyard Monsters. The game is running version 128.5690 and has been reconstructed to work without official Kixeye servers, which where shutdown sometime after December 2020 when Flash was removed from all major browsers.

<br />

## AS3 Developer Help Wanted:
Please see the [CONTRIBUTING.md](https://gitlab.com/monkey-patch/backyard-monsters-refitted/-/blob/main/CONTRIBUTING.md) file for more information.

<br />

## Server setup

1. Clone or fork this repo:

```bash
 git clone https://gitlab.com/monkey-patch/backyard-monsters-refitted
```

<br />

2. Copy & paste the example.env file and rename the new file to .env. Configure the PORT.

<br />

3. Open a terminal inside the server directory: <code>cd server</code>

<br />

4. Install the required Node dependencies: <code>npm i</code>

<br />

5. Compile and run the application: <code>npm run serve</code>

<br />

If everything runs fine, you can open the admin dashboard at http://localhost:3001

<br />

## Running the game / Decompiler setup


1. Download and install the JPEXS Flash Decompiler tool here:
https://github.com/jindrapetrik/jpexs-decompiler/releases

<br />

2. Navigate to Advanced Settings > Paths and set the following paths.
   <br />
 - Flash Player projector path: found at <code>./flashplayer_32.exe</code>
   <br />
 - Flash Player projector content debugger path: found at <code>./flashplayer_32.exe</code>
   <br />
 - PlayerGlobal (.swc) path: found at <code>./playerglobal.swc</code>

<br />

3. To contribute you will need to copy your changes to the src directory. If you are wondering why we are using this horrible workflow please see [CONTRIBUTING.md](https://gitlab.com/monkey-patch/backyard-monsters-refitted/-/blob/main/CONTRIBUTING.md) for more information. If you are able to figure out how to compile directly to swf without unlinking all assets, please let us know
 

4. You can find the most recent release of the game here: [backyard-monsters-refitted-stable](https://gitlab.com/monkey-patch/backyard-monsters-refitted/-/releases)  
