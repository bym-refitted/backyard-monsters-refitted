import { Request, Response } from "express";
import { User } from "../models/user.model";
import { ORMContext } from "../server";
import bcrypt from "bcrypt";
import JWT from "jsonwebtoken";

const login = async (req: Request, res: Response) => {
  try {
    const { email, password } = req.body;
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

        // Collect the values from the user table
        const {
          userid,
          username,
          last_name,
          pic_square,
          timeplayed,
          email,
          stats,
          friendcount,
          sessioncount,
          addtime,
          app_id,
          tpid,
          bookmarks,
          _isFan,
          sendgift,
          sendinvite,
        } = user;

        // return logged in user data 
        return res.status(200).json({
          error: 0,
          version: 128,
          token,
          userid,
          username,
          last_name,
          pic_square,
          timeplayed,
          email,
          stats,
          friendcount,
          sessioncount,
          addtime,
          mapversion: 3,
          mailversion: 1,
          soundversion: 1,
          languageversion: 8,
          app_id,
          tpid,
          currency_url: "",
          bookmarks,
          _isFan,
          sendgift,
          sendinvite,
          language: "en",
          h: "someHashValue",
        });
      }
      res.status(401).json({ error: "Password does not match." });
    });
  } catch (error) {
    return res.status(500).json({ error });
  }
};

export default login;
