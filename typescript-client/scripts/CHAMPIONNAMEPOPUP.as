package
{
   import flash.events.MouseEvent;
   
   public class CHAMPIONNAMEPOPUP extends GUARDIANNAMEPOPUP_CLIP
   {
       
      
      public function CHAMPIONNAMEPOPUP()
      {
         var _loc2_:String = null;
         super();
         tTitle.htmlText = "<b>" + "CONGRATULATIONS!" + "</b>";
         tDescription.htmlText = "<b>" + "You can now start raising your Champion. What will you name him?" + "<b>";
         var _loc1_:int = CREATURES._guardian._type;
         mcGuard.gotoAndStop((_loc1_ - 1) * 6 + 1);
         tInput.text = CHAMPIONCAGE._guardians[_loc1_].description;
         bAction.SetupKey("btn_accept");
         bAction.addEventListener(MouseEvent.CLICK,this.Accept);
         bAction.Highlight = false;
         SOUNDS.Play("levelup");
         if(CREATURES._guardian)
         {
            if(!CREATURES._guardian._name)
            {
               _loc2_ = String(CHAMPIONCAGE._guardians["G" + CREATURES._guardian._type].name);
               CREATURES._guardian._name = _loc2_;
            }
         }
      }
      
      public function Accept(param1:MouseEvent) : void
      {
         if(tInput.text.length > 12)
         {
            GLOBAL.Message("The name needs to be 12 characters or less.");
            return;
         }
         var _loc2_:String = tInput.text;
         if(_loc2_.length < 1)
         {
            _loc2_ = String(CHAMPIONCAGE._guardians["G" + CREATURES._guardian._type].name);
            tInput.text = _loc2_;
         }
         CREATURES._guardian._name = _loc2_;
         POPUPS.Next();
         CHAMPIONCAGE.Hide(null);
         BASE.Save();
      }
      
      public function Hide() : void
      {
         var _loc1_:String = String(CHAMPIONCAGE._guardians["G" + CREATURES._guardian._type].name);
         CREATURES._guardian._name = _loc1_;
         CHAMPIONCAGE.Hide();
      }
   }
}
