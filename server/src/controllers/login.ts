import { User } from "../models/user.model";
import { ORMContext } from "../server";
import bcrypt from "bcrypt";
import JWT from "jsonwebtoken";
import { FilterFrontendKeys } from "../utils/FrontendKey";
import { Controller } from "../utils/Controller";
import z from "zod";

const UserLoginSchema = z.object({
  email: z.string(),
  password: z.string(),
});



// TODO:
// 1. Fix clientside error system
//    - Improve the Controller type to force a return of clientside error
// 2. Use FrontendKey for save
// 3. Create auth middleware
//    - add token to requests. JWT? Bearer?
//    - Redis / store session token in sqlite -^^^^^
//  4. Clientside ability to skip the login - Default login credentials for dev? 
// 


export const login: Controller = async (req, res) => {
  try {
    const { email, password } = UserLoginSchema.parse(req.body);
    let user = await ORMContext.em.findOne(User, { email });

    // No user found
    if (!user) return res.status(404).json({ error: "Could not find user." });

    // Verify the provided password with the stored hashed password
    bcrypt.compare(password, user.password, (error, isMatch) => {
      if (error)
        return res
          .status(500)
          .json({ error: "An error occurred while comparing passwords." });

      if (isMatch) {
        const token = JWT.sign(
          { userId: user.userid },
          process.env.SECRET_KEY,
          {
            expiresIn: "30d",
          }
        );

        const filteredUser = FilterFrontendKeys(user);
        // return logged in user data
        return res.status(200).json({
          error: 0,
          version: 128,
          token,
          mapversion: 3,
          mailversion: 1,
          soundversion: 1,
          languageversion: 8,
          app_id: "2de76fv89",
          tpid: "t76fbxXsw",
          currency_url: "",
          language: "en",
          h: "someHashValue",
          ...filteredUser,
        });
      }
      res.status(401).json({ error: "Password does not match." });
    });
  } catch (error) {
    return res.status(500).json({ error });
  }
};
