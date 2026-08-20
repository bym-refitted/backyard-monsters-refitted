package com.monsters.utils
{
   public class HtmlTextUtils
   {

      public function HtmlTextUtils()
      {
         super();
      }

      /**
       * Strips any trailing <br> tags from html, then appends exactly `breaks` of them.
       * Used to guarantee consistent section spacing (e.g. single break within a section,
       * double break between sections) regardless of what the preceding content left behind.
       */
      public static function EnsureBreaks(html:String, breaks:int) : String
      {
         while(html.substr(html.length - 4) == "<br>")
         {
            html = html.substr(0,html.length - 4);
         }
         var i:int = 0;
         while(i < breaks)
         {
            html += "<br>";
            i++;
         }
         return html;
      }
   }
}
