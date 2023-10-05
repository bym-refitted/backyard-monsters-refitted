package com.smartfoxserver.v2.core
{
   import flash.events.Event;
   
   public class SFSEvent extends BaseEvent
   {
      
      public static const HANDSHAKE:String = "handshake";
      
      public static const UDP_INIT:String = "udpInit";
      
      public static const CONNECTION:String = "connection";
      
      public static const PING_PONG:String = "pingPong";
      
      public static const SOCKET_ERROR:String = "socketError";
      
      public static const CONNECTION_LOST:String = "connectionLost";
      
      public static const CONNECTION_RETRY:String = "connectionRetry";
      
      public static const CONNECTION_RESUME:String = "connectionResume";
      
      public static const CONNECTION_ATTEMPT_HTTP:String = "connectionAttemptHttp";
      
      public static const CONFIG_LOAD_SUCCESS:String = "configLoadSuccess";
      
      public static const CONFIG_LOAD_FAILURE:String = "configLoadFailure";
      
      public static const LOGIN:String = "login";
      
      public static const LOGIN_ERROR:String = "loginError";
      
      public static const LOGOUT:String = "logout";
      
      public static const ROOM_ADD:String = "roomAdd";
      
      public static const ROOM_REMOVE:String = "roomRemove";
      
      public static const ROOM_CREATION_ERROR:String = "roomCreationError";
      
      public static const ROOM_JOIN:String = "roomJoin";
      
      public static const ROOM_JOIN_ERROR:String = "roomJoinError";
      
      public static const USER_ENTER_ROOM:String = "userEnterRoom";
      
      public static const USER_EXIT_ROOM:String = "userExitRoom";
      
      public static const USER_COUNT_CHANGE:String = "userCountChange";
      
      public static const PUBLIC_MESSAGE:String = "publicMessage";
      
      public static const PRIVATE_MESSAGE:String = "privateMessage";
      
      public static const OBJECT_MESSAGE:String = "objectMessage";
      
      public static const MODERATOR_MESSAGE:String = "moderatorMessage";
      
      public static const ADMIN_MESSAGE:String = "adminMessage";
      
      public static const EXTENSION_RESPONSE:String = "extensionResponse";
      
      public static const ROOM_VARIABLES_UPDATE:String = "roomVariablesUpdate";
      
      public static const USER_VARIABLES_UPDATE:String = "userVariablesUpdate";
      
      public static const ROOM_GROUP_SUBSCRIBE:String = "roomGroupSubscribe";
      
      public static const ROOM_GROUP_SUBSCRIBE_ERROR:String = "roomGroupSubscribeError";
      
      public static const ROOM_GROUP_UNSUBSCRIBE:String = "roomGroupUnsubscribe";
      
      public static const ROOM_GROUP_UNSUBSCRIBE_ERROR:String = "roomGroupUnsubscribeError";
      
      public static const PLAYER_TO_SPECTATOR:String = "playerToSpectator";
      
      public static const PLAYER_TO_SPECTATOR_ERROR:String = "playerToSpectatorError";
      
      public static const SPECTATOR_TO_PLAYER:String = "spectatorToPlayer";
      
      public static const SPECTATOR_TO_PLAYER_ERROR:String = "spectatorToPlayerError";
      
      public static const ROOM_NAME_CHANGE:String = "roomNameChange";
      
      public static const ROOM_NAME_CHANGE_ERROR:String = "roomNameChangeError";
      
      public static const ROOM_PASSWORD_STATE_CHANGE:String = "roomPasswordStateChange";
      
      public static const ROOM_PASSWORD_STATE_CHANGE_ERROR:String = "roomPasswordStateChangeError";
      
      public static const ROOM_CAPACITY_CHANGE:String = "roomCapacityChange";
      
      public static const ROOM_CAPACITY_CHANGE_ERROR:String = "roomCapacityChangeError";
      
      public static const ROOM_FIND_RESULT:String = "roomFindResult";
      
      public static const USER_FIND_RESULT:String = "userFindResult";
      
      public static const INVITATION:String = "invitation";
      
      public static const INVITATION_REPLY:String = "invitationReply";
      
      public static const INVITATION_REPLY_ERROR:String = "invitationReplyError";
       
      
      public function SFSEvent(param1:String, param2:Object)
      {
         super(param1);
         this.params = param2;
      }
      
      override public function clone() : Event
      {
         return new SFSEvent(this.type,this.params);
      }
      
      override public function toString() : String
      {
         return formatToString("SFSEvent","type","bubbles","cancelable","eventPhase","params");
      }
   }
}
