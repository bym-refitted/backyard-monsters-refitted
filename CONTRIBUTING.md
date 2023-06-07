## 📝 Guidelines
- If possible, try to keep modifications made to the binary (SWF) to a minimum, as it is impossible to see what has been changed in a pull request.

- Ideally, most of the changes should be made to the server responses that the game expects in <code>server/src/app.routes.ts</code>

- There may be times when we need to make changes to the binary, if this is the case, your changes must be made in the <code>src</code> folder as reference, this folder holds all the game files (decompiled) -  we will then compile the binary on our end and update on git to ensure that the changes you made are working as expected.</br></br>
<b>Example:</b> You fixed something in the <code>BASE.as</code> file within the game's binary. Make sure you go to the <code>src</code> folder and update that change there also, as this is what will be in your pull reqeust!

<br/>

## 🔌 How to push code changes
- First, make sure you checkout directly from the develop branch, your branch name should be formatted like so: <b>feature/whatever_change_you_made</b>

- Make sure your commit message includes: your branch name in its title, and please make the commit description meaningful!

- Raise a pull request to merge your changes into the 'develop' branch.

- Please <b>DO NOT</b> include the game's binary in your pull request, as mentioned any changes you make should be in <code>src</code>

<br/>

## 👨‍💻 AS3 Developer help wanted:
If you are someone who has extensive knowledge of working with <b>Apache Flex (Display Lists, AS3, MXML)</b> we would love your help.
<br/>
<br/>
<b>Problem statement:</b> 
<br/>
Currently, we do not have a great workflow system, as evident from relying on modifying the binary directly. Our objective is to try and work with the code directly in the [Moonshine IDE](https://moonshine-ide.com/). We have made attempts to try get the game to work with Moonshine using Flex Browser Project (SWF) and Flex Desktop Project, however, we are facing issues that we have little knowledge of in regards to display lists, mxml layout files, etc.
<br/>
<br/>
Essentially, the game is running fine without any issues when using the JPEXS decompiler to directly edit the binary, but running the game in the same environment using the IDE gives these issues, as the SWF output seems to be different. Here are some issues that we are encountering:

- In GAME.as <code>this.parent</code> is returning null. We believe this has something to do with the display list hierarchy.
- In GAME.as <code>loaderInfo</code> and <code>Security.allowDomain(u)</code> are referencing a null object reference, this can be commented out for now.
- In GLOBAL.as the variables for width and height in the <code>RefreshScreen()</code> function are referencing a null object reference 
- We need to ensure that all resource assets (e.g. images, fonts, sprites) are packaged correctly.

Any and all help is extremely appreciated on these issues.