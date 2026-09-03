package com.monsters.chat.impl.ws
{
   /**
    * What a row in the alliance feed represents, mirroring the server's
    * AllianceMessageType enum.
    *
    * Anything other than MESSAGE is a shout: a server-composed sentence about a
    * membership change, drawn as a centred system row with no name line. The
    * server sends the finished text, as the original did - none of its shout
    * strings ever lived in the client.
    */
   public final class AllianceMessageType
   {
      public static const MESSAGE:String = "message";
      public static const JOINED:String = "joined";
      public static const LEFT:String = "left";
      public static const KICKED:String = "kicked";
      public static const PROMOTED:String = "promoted";
      public static const CREATED:String = "created";
      public static const RELATIONSHIP:String = "relationship";

      public function AllianceMessageType()
      {
         super();
      }
   }
}
