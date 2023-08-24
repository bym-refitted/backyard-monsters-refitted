package
{
    import flash.display.Sprite;
    import flash.text.TextField;
    import flash.text.TextFieldType;
    import flash.text.TextFieldAutoSize;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import flash.display.DisplayObjectContainer;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;
    import flash.filters.DropShadowFilter;
    import flash.display.Bitmap;
    import flash.display.Loader;
    import flash.net.URLRequest;

    public class AuthForm extends Sprite
    {
        private var background:Sprite;

        private var emailInput:TextField;

        private var passwordInput:TextField;

        private var loader:Loader;

        public function AuthForm()
        {
            addEventListener(Event.ADDED_TO_STAGE, formAddedToStageHandler);
        }

        public function formAddedToStageHandler(event:Event):void
        {
            removeEventListener(Event.ADDED_TO_STAGE, formAddedToStageHandler);

            // Get center point of stage
            var centerX:Number = stage.stageWidth / 2;
            var centerY:Number = stage.stageHeight / 2;

            loader = new Loader();
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
            loader.load(new URLRequest("http://localhost:3001/assets/bym-refitted-assets/refitted-logo.png"));

            // Create input fields
            emailInput = createInputField(350, 30, "Email");
            passwordInput = createInputField(350, 30, "Password", true);
        
            emailInput.x = centerX - emailInput.width / 2;
            emailInput.y = centerY - emailInput.height;
            passwordInput.x = centerX - passwordInput.width / 2;
            passwordInput.y = centerY + 10;

            addChild(emailInput);
            addChild(passwordInput);

            // Create a button
            var submitButton:Sprite = createButton("Submit");
            submitButton.x = centerX - submitButton.width / 2;
            submitButton.y = centerY + 50;
            addChild(submitButton);

            // Add a click event handler to the button
            submitButton.addEventListener(MouseEvent.CLICK, submitButtonClickHandler);
        }

        private function onImageLoaded(event:Event):void
        {
            var image:Bitmap = Bitmap(loader.content);

            var centerX:Number = stage.stageWidth / 2;

            image.x = centerX - image.width / 2 + 150;
            image.scaleX = 0.5;
            image.scaleY = 0.5;
            addChild(image);
        }

        private function createInputField(width:Number, height:Number, label:String = "", isPassword:Boolean = false):TextField
        {
            var textField:TextField = new TextField();

            if (isPassword)
                textField.displayAsPassword = true;

            textField.background = true;
            textField.backgroundColor = 0xFFFFFF;
            textField.type = TextFieldType.INPUT;
            textField.border = true;
            textField.borderColor = 0xDDDDDD;
            textField.width = width;
            textField.height = height;

            var textFormat:TextFormat = new TextFormat();
            textFormat.size = 16;
            textField.defaultTextFormat = textFormat;

            // Create a drop shadow filter
            var dropShadow:DropShadowFilter = new DropShadowFilter();
            dropShadow.color = 0x000000;
            dropShadow.angle = 45;
            dropShadow.distance = 4;
            dropShadow.blurX = dropShadow.blurY = 4;
            dropShadow.alpha = 0.2;
            dropShadow.quality = 1;

            textField.filters = [dropShadow];

            return textField;
        }

        private function createButton(label:String):Sprite
        {
            var button:Sprite = new Sprite();
            button.graphics.beginFill(0x3366CC);
            button.graphics.drawRect(0, 0, 350, 30);
            button.graphics.endFill();

            var labelField:TextField = new TextField();
            labelField.text = label;
            labelField.textColor = 0xFFFFFF;
            labelField.width = button.width;
            labelField.height = button.height;
            labelField.selectable = false;
            labelField.mouseEnabled = false;

            // Set alignment properties
            var textFormat:TextFormat = new TextFormat();
            textFormat.align = TextFormatAlign.CENTER;
            labelField.defaultTextFormat = textFormat;

            labelField.autoSize = TextFieldAutoSize.CENTER;
            labelField.x = (button.width - labelField.width) / 2;
            labelField.y = (button.height - labelField.height) / 2;

            button.addChild(labelField);

            return button;
        }

        private function submitButtonClickHandler(event:MouseEvent):void
        {

            // new URLLoaderApi().load(GLOBAL._apiURL + "player/recorddebugdata", logger, handleLoadSuccessful, handleLoadError);

            new URLLoaderApi().load(GLOBAL._apiURL + "bm/getnewmap", null, attachAuthCredentials);
            
        }

        private function attachAuthCredentials(serverData:Object) {
            var emailValue:String = emailInput.text;
            var passwordValue:String = passwordInput.text;
            
            LOGIN.OnGetNewMap(serverData, [["email", emailValue], ["password", passwordValue]]);
        }

    }
}