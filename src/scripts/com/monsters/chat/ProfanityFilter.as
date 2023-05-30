package com.monsters.chat
{
   public class ProfanityFilter
   {
      
      private static const filters:Array = [/([5s][\W_]*)+?[\W_]*(h[\W_]*)+?[\W_]*([1i][\W_]*)+?[\W_]*([7t][\W_]*)+?[\W_]*(((([5sz][\W_]*)+?|(d[\W_]*)+?)[\W_]*)|(([3e][\W_]*)+?[\W_]*(([5sz][\W_]*)+?|(d[\W_]*)+?|(r[\W_]*)+?)[\W_]*)|(([1i][\W_]*)+?[\W_]*(n[\W_]*)+?[\W_]*([69g][\W_]*)+?[\W_]*))?/gi,/(b[\W_]*)+?[\W_]*([1i][\W_]*)+?[\W_]*([7t][\W_]*)+?[\W_]*(c[\W_]*)+?[\W_]*(h[\W_]*)+?[\W_]*(((([5sz][\W_]*)+?|(d[\W_]*)+?)[\W_]*)|(([3e][\W_]*)+?[\W_]*(([5sz][\W_]*)+?|(d[\W_]*)+?|(r[\W_]*)+?)[\W_]*)|(([1i][\W_]*)+?[\W_]*(n[\W_]*)+?[\W_]*([69g][\W_]*)+?[\W_]*))?/gi,/(b[\W_]*)+?[\W_]*([1l][\W_]*)+?[\W_]*([0o][\W_]*)+?[\W_]*(w[\W_]*)+?[\W_]*([jJ][\W_]*)+?[\W_]*([0o][\W_]*)+?[\W_]*(b[\W_]*)+?[\W_]*(((([5sz][\W_]*)+?|(d[\W_]*)+?)[\W_]*)|(([3e][\W_]*)+?[\W_]*(([5sz][\W_]*)+?|(d[\W_]*)+?|(r[\W_]*)+?)[\W_]*)|(([1i][\W_]*)+?[\W_]*(n[\W_]*)+?[\W_]*([69g][\W_]*)+?[\W_]*))?/gi,/(d[\W_]*)+?[\W_]*([1i][\W_]*)+?[\W_]*([1l][\W_]*)+?[\W_]*(d[\W_]*)+?[\W_]*([0o][\W_]*)+?[\W_]*(((([5sz][\W_]*)+?|(d[\W_]*)+?)[\W_]*)|(([3e][\W_]*)+?[\W_]*(([5sz][\W_]*)+?|(d[\W_]*)+?|(r[\W_]*)+?)[\W_]*)|(([1i][\W_]*)+?[\W_]*(n[\W_]*)+?[\W_]*([69g][\W_]*)+?[\W_]*))?/gi,/(f[\W_]*)+?[\W_]*(u[\W_]*)+?[\W_]*(c[\W_]*)+?[\W_]*(k[\W_]*)+?[\W_]*(((([5sz][\W_]*)+?|(d[\W_]*)+?)[\W_]*)|(([3e][\W_]*)+?[\W_]*(([5sz][\W_]*)+?|(d[\W_]*)+?|(r[\W_]*)+?)[\W_]*)|(([1i][\W_]*)+?[\W_]*(n[\W_]*)+?[\W_]*([69g][\W_]*)+?[\W_]*))?/gi,/(m[\W_]*)+?[\W_]*([4@a][\W_]*)+?[\W_]*([5s][\W_]*)+?[\W_]*([7t][\W_]*)+?[\W_]*([3e][\W_]*)+?[\W_]*(r[\W_]*)+?[\W_]*(b[\W_]*)+?[\W_]*([4@a][\W_]*)+?[\W_]*([7t][\W_]*)+?[\W_]*([3e][\W_]*)+?[\W_]*(((([5sz][\W_]*)+?|(d[\W_]*)+?)[\W_]*)|(([3e][\W_]*)+?[\W_]*(([5sz][\W_]*)+?|(d[\W_]*)+?|(r[\W_]*)+?)[\W_]*)|(([1i][\W_]*)+?[\W_]*(n[\W_]*)+?[\W_]*([69g][\W_]*)+?[\W_]*))?/gi,/(n[\W_]*)+?[\W_]*([1i][\W_]*)+?[\W_]*([69g][\W_]*)+?[\W_]*([69g][\W_]*)+?[\W_]*([3e][\W_]*)+?[\W_]*(r[\W_]*)+?[\W_]*(((([5sz][\W_]*)+?|(d[\W_]*)+?)[\W_]*)|(([3e][\W_]*)+?[\W_]*(([5sz][\W_]*)+?|(d[\W_]*)+?|(r[\W_]*)+?)[\W_]*)|(([1i][\W_]*)+?[\W_]*(n[\W_]*)+?[\W_]*([69g][\W_]*)+?[\W_]*))?/gi,/(n[\W_]*)+?[\W_]*([1i][\W_]*)+?[\W_]*([69g][\W_]*)+?[\W_]*([69g][\W_]*)+?[\W_]*([4@a][\W_]*)+?[\W_]*(((([5sz][\W_]*)+?|(d[\W_]*)+?)[\W_]*)|(([3e][\W_]*)+?[\W_]*(([5sz][\W_]*)+?|(d[\W_]*)+?|(r[\W_]*)+?)[\W_]*)|(([1i][\W_]*)+?[\W_]*(n[\W_]*)+?[\W_]*([69g][\W_]*)+?[\W_]*))?/gi,/\b[4@a]r[5s][3e]h[0o][1l][3e]s?\b/gi,/\b[4@a][5s][5s]h[0o][1l][3e]s?\b/gi,/\bb[0o][1i][0o][1l][4@a][5s]\b/gi,/\bc[4@a]wks?\b/gi,/\bc[0o]cks?\b/gi,/\bc[0o]ck[-][5s]uck[3e]rs?\b/gi,/\bc[0o]ckf[4@a]c[3e]s?\b/gi,/\bc[0o]ckh[3e][4@a]ds?\b/gi,/\bc[0o]ckmunch(es)?\b/gi,/\bc[0o]ckmunch[3e]rs?\b/gi,/\bc[0o]ck[5s]uck[3e]rs?\b/gi,/\bc[0o]ck[5s]uk[4@a]s?\b/gi,/\bc[0o]ck[5s]ukk[4@a]s?\b/gi,/\bc[0o]kmunch[3e]rs?\b/gi,/\bc[0o]k[5s]uck[4@a]s?\b/gi,/\bcun[7t]s?\b/gi,/\bd[1i]ckh[3e][4@a]ds?\b/gi,/\bd[0o][69g][69g][1i]n[69g]?\b/gi,/\bd[0o]nk[3e]yr[1i]bb[3e]rs?\b/gi,/\bf[4@a]nny\b/gi,/\bf[4@a]nnyf[1l][4@a]p[5s]?\b/gi,/\bf[4@a]nnyfuck[3e]rs?\b/gi,/\bf[4@a]nyy\b/gi,/\bf[4@a][7t][4@a][5s][5s](es)?\b/gi,/\bp[3e]n[1i][5s](es)?\b/gi,/\b[5s]k[4@a]nks?\b/gi,/\b[5s]k[4@a]nkr[4@a][69g]\b/gi,/\b[7t]w[4@a][7t]\b/gi,/\b[7t]w[4@a][7t][7t]y\b/gi,/\bv[4@a][69g][1i]n[4@a]\b/gi,/\br[4@a]p[1i][5s][7t][5s]?\b/gi,/\br[4@a]p[3e]r[5s]\b/gi,/\br[4@a]p[1i]n[69g]\b/gi,/\br[4@a]p[3e][drs]?\b/gi,/\bc[0o][0o]ns?\b/gi,/\bh[0o]m[0o]s?\b/gi,/\b[5s]p[1i]c\b/gi,/\bch[1i]nk\b/gi,/\bbun[69g]\b/gi,/\bc[4@a]m[3e][1l][ ]+?j[0o]ck[3e]y\b/gi,/\bc[0o][0o][1l][1i][3e]\b/gi,/\bcun[7t][-][3e]y[3e]d\b/gi,/\bd[1i]nk\b/gi,/\b[69g][0o][0o]k\b/gi,/\bn[1i][69g][1l][3e][7t]\b/gi,/\bp[0o]rch[ ]+?m[0o]nk[3e]y\b/gi,/\bsh[yi]t\b/gi,/\bfuk\b/gi,/\bfukt\b/gi,/\bkkk\b/gi];
       
      
      public function ProfanityFilter()
      {
         super();
      }
      
      public static function filterMessage(param1:String) : String
      {
         var _loc2_:RegExp = null;
         for each(_loc2_ in filters)
         {
            param1 = param1.replace(_loc2_,replaceFunction);
         }
         return param1;
      }
      
      private static function replaceFunction() : String
      {
         return arguments[0].replace(/\S/g,"*");
      }
   }
}
