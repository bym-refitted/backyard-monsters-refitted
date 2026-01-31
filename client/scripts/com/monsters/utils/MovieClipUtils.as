package com.monsters.utils
{
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.FrameLabel;
   import flash.display.MovieClip;
   import flash.geom.Matrix;
   
   public class MovieClipUtils
   {
       
      
      public function MovieClipUtils()
      {
         super();
      }
      
      public static function validateFrameLabel(param1:MovieClip, param2:String) : Boolean
      {
         var _loc4_:FrameLabel = null;
         var _loc3_:Array = param1.currentLabels;
         for each(_loc4_ in _loc3_)
         {
            if(_loc4_.name === param2)
            {
               return true;
            }
         }
         return false;
      }
      
      public static function validateFrameLabels(param1:MovieClip, param2:Vector.<String>, param3:Boolean = false) : Vector.<String>
      {
         var _loc7_:FrameLabel = null;
         var _loc8_:String = null;
         var _loc9_:Boolean = false;
         var _loc4_:Vector.<String> = new Vector.<String>();
         var _loc5_:Array = param1.currentLabels;
         var _loc6_:Vector.<String> = param2;
         for each(_loc8_ in _loc6_)
         {
            for each(_loc7_ in _loc5_)
            {
               if(_loc8_ === _loc7_.name)
               {
                  _loc9_ = true;
                  break;
               }
            }
            if(_loc9_)
            {
               _loc4_.push(_loc7_.name);
            }
            else if(param3)
            {
            }
            _loc9_ = false;
         }
         return _loc4_;
      }
      
      public static function getBitmapDataFromDisplayObject(param1:DisplayObject) : BitmapData
      {
         var _loc2_:BitmapData = new BitmapData(param1.width,param1.height,true,0);
         _loc2_.draw(param1,new Matrix(1,0,0,1,param1.width * 0.5,param1.height * 0.5));
         return _loc2_;
      }
      
      public static function getItemCodes() : Vector.<String>
      {
         return Vector.<String>(["BEW","BST","BIP","ENL","SP1","SP2","SP3","SP4","BR13","BR23","BR33","BR43","CLOD","HOD","QC8","QFAN","QBOOKMARK","BR11","BR12","BR21","BR22","BR31","BR32","BR41","BR42","PRO1","PRO2","QINVITE1","QINVITE5","QINVITE10","X","PRO3","BUILDING28","BUILDING29","BUILDING30","BUILDING31","BUILDING33","BUILDING34","BUILDING35","BUILDING36","BUILDING37","BUILDING38","BUILDING39","BUILDING40","BUILDING41","BUILDING42","BUILDING43","BUILDING44","BUILDING45","BUILDING46","BUILDING47","BUILDING48","REFUND","BUILDING49","BUILDING50","BUILDING32","MUSHROOM1","MUSHROOM2","MUSHROOM3","MUSK","HOD2","HOD3","QGIFT10","QGIFT50","QGIFT100","BRTOPUP","PUMPKIN","BUILDING55","BUILDING56","BUILDING57","BUILDING58","BUILDING59","BUILDING60","BUILDING61","BUILDING62","BUILDING63","BUILDING64","BUILDING65","BUILDING66","BUILDING67","BUILDING68","BUILDING69","BUILDING70","BUILDING71","BUILDING72","BUILDING73","BUILDING74","BUILDING75","BUILDING76","BUILDING77","BUILDING78","BUILDING79","BUILDING80","BUILDING81","BUILDING82","BUILDING83","BUILDING84","BUILDING85","BUILDING86","BUILDING87","BUILDING88","BUILDING89","BUILDING90","BUILDING91","BUILDING92","BUILDING93","BUILDING94","BUILDING95","BUILDING96","BUILDING97","BUILDING98","BUILDING99","BUILDING100","BUILDING101","BUILDING102","BUILDING103","BUILDING104","BUILDING105","BUILDING106","BUILDING107","BUILDING108","BUILDING109","BUILDING110","HEVENT","BUNK","SP2x1","SP3x1","SP4x1","SP2x2","SP3x2","SP4x2","SP2x3","SP3x3","SP4x3","KIT","FIX","BLK2","BLK3","BLK4","FQ","POD","IU","BALL0","BALL1","BALL2","IUN","ITR","YRE","OTO","TOD","MOD","EXH","IPU","IFD","IEV","IHE","BLK5","MDOD","MSOD","APARMAHR","APCONQHR","APDECLHR","IB","IF","BUILDING120","BUILDING131","IBSW","BRAU","BRAB","BLK2I","BLK3I","BR11I","BR12I","BR13I","BR21I","BR22I","BR23I","BR31I","BR32I","BR33I","BR41I","BR42I","BR43I","HODI","HOD2I","HOD3I","TODI","EXHI","NCP","ENLI","HAM","HAMS","HSM","MHTOPUP"]);
      }

      public static function stopAll(mc:MovieClip):void
      {
         mc.stop();
         for (var i:int = 0; i < mc.numChildren; i++)
         {
            var child:DisplayObject = mc.getChildAt(i);

            if (child is MovieClip)
            {
               stopAll(child as MovieClip);
            }
         }
      }
   }
}
