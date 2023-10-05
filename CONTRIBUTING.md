## 📝 Guidelines
- If possible, try to keep modifications made to the binary (SWF) to a minimum, as it is impossible to see what has been changed in a pull request.

- Ideally, most of the changes should be made to the server responses that the game expects in <code>server/src/controllers</code>

- There may be times when we need to make changes to the binary, if this is the case, your changes must be made in the <code>src</code> folder as reference, this folder holds all the game files (decompiled) -  we will then compile the binary on our end and update on git to ensure that the changes you made are working as expected.</br></br>
<b>Example:</b> You fixed something in the <code>BASE.as</code> file within the game's binary. Make sure you go to the <code>src</code> folder and update that change there also, as this is what will be in your pull reqeust!

<br/>

## 🔌 How to push code changes
- First, make sure you checkout directly from the branch you intend to make changes to, your branch name should be formatted like so: <b>feature/whatever_change_you_made</b>

- Make sure you include a meaningful commit message! If you find yourself with more than 3 commits, please ensure to squash your commits into one.

- Raise a pull request to merge your changes into the desired branch.

- Please <b>DO NOT</b> include the game's binary in your pull request, as mentioned any changes you make should be in <code>src</code>

<br/>