package
{
    import flash.display.Sprite;
    import flash.text.TextField;
    import flash.text.TextFieldType;
    import flash.text.TextFieldAutoSize;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import flash.text.TextFormat;
    import flash.filters.DropShadowFilter;
    import flash.display.Bitmap;
    import flash.display.Loader;
    import flash.net.URLRequest;
    import flash.events.FocusEvent;

    public class AuthForm extends Sprite
    {
        private var background:Sprite;

        private var emailValue:String;

        private var passwordValue:String;

        private var loader:Loader;

        private var centerX:Number;

        private var centerY:Number;

        private var startY:Number;

        private var verticalSpacingBetweenBlocks:Number = 0;

        private var BLACK:uint = 0x000000;

        private var WHITE:uint = 0xFFFFFF;

        private var LIGHT_GRAY:uint = 0xF5F5F5;

        private var PRIMARY:uint = 0xE9D34F;

        public function AuthForm()
        {
            addEventListener(Event.ADDED_TO_STAGE, formAddedToStageHandler);
        }

        public function formAddedToStageHandler(event:Event):void
        {
            removeEventListener(Event.ADDED_TO_STAGE, formAddedToStageHandler);

            stage.color = LIGHT_GRAY;

            // Form
            var formContainer:Sprite = new Sprite();
            var formWidth:Number = 450;
            var formHeight:Number = 600;
            var formRadius:Number = 16;

            formContainer.graphics.beginFill(WHITE);
            formContainer.graphics.drawRoundRect(0, 0, formWidth, formHeight, formRadius, formRadius);
            formContainer.graphics.endFill();
            formContainer.x = (stage.stageWidth - formContainer.width) / 2;
            formContainer.y = (stage.stageHeight - formContainer.height) / 2;

            // Create a drop shadow filter
            var dropShadow:DropShadowFilter = new DropShadowFilter();
            dropShadow.color = BLACK;
            dropShadow.angle = 45;
            dropShadow.distance = 5;
            dropShadow.blurX = dropShadow.blurY = 14;
            dropShadow.alpha = 0.15;
            dropShadow.quality = 1;

            formContainer.filters = [dropShadow];

            addChild(formContainer);

            // Get center point of stage
            centerX = stage.stageWidth / 2;
            centerY = stage.stageHeight / 2;

            // Calculate starting y position to center content
            startY = centerY;

            loader = new Loader();
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(event:Event):void
                {
                    onImageLoaded(event, formContainer);
                });
            loader.load(new URLRequest("http://localhost:3001/assets/bym-refitted-assets/refitted-logo.png"));

            // Create inputs within the container
            createBlock(formContainer, 350, 35, "Email");
            createBlock(formContainer, 350, 35, "Password", true);

            // Create button
            var submitButton:Sprite = createButton("LOG IN");
            submitButton.x = (formContainer.width - submitButton.width) / 2;
            submitButton.y = startY;
            formContainer.addChild(submitButton);

            // Add a click event handler to the button
            submitButton.addEventListener(MouseEvent.CLICK, submitButtonClickHandler);
        }

        private function onImageLoaded(event:Event, formContainer:Sprite):void
        {
            var image:Bitmap = Bitmap(loader.content);

            image.x = (formContainer.width - image.width) / 2 + 160; // temporary centering...
            image.y = 20;
            image.scaleX = 0.5;
            image.scaleY = 0.5;
            formContainer.addChild(image);
        }

        // Function to create and position inputs
        function createBlock(formContainer:Sprite, width:Number, height:Number, placeholder:String = "", isPassword:Boolean = false):TextField
        {
            var input:TextField = createInputField(width, height, placeholder, isPassword);
            formContainer.addChild(input);

            // Position input vertically as a block
            input.x = (formContainer.width - input.width) / 2;
            input.y = startY;

            // Add event listener to capture input value
            input.addEventListener(Event.CHANGE, function(event:Event):void
                {
                    if (placeholder == "Email")
                    {
                        emailValue = input.text; // Update email input value
                    }
                    else if (placeholder == "Password")
                    {
                        passwordValue = input.text; // Update password input value
                    }
                });

            // Adjusts the values between each block
            startY += input.height + 20;

            return input;
        }

        private function createInputField(width:Number, height:Number, placeholder:String = "", isPassword:Boolean = false):TextField
        {
            var input:TextField = new TextField();

            input.background = true;
            input.backgroundColor = WHITE;
            input.type = TextFieldType.INPUT;
            input.border = true;
            input.borderColor = 0xDDDDDD;
            input.width = width;
            input.height = height;

            var inputMargin:Number = 10;

            // Normal input
            var inputTextFormat:TextFormat = new TextFormat();
            inputTextFormat.size = 16;
            inputTextFormat.color = BLACK;
            inputTextFormat.leftMargin = inputMargin;
            inputTextFormat.rightMargin = inputMargin;
            inputTextFormat.leading = (input.height - inputTextFormat.size) / 2;
            input.defaultTextFormat = inputTextFormat;

            // Placeholder
            var placeholderTextFormat:TextFormat = new TextFormat();
            placeholderTextFormat.size = 16;
            placeholderTextFormat.color = 0xC9C9C9;
            placeholderTextFormat.leftMargin = inputMargin;
            inputTextFormat.rightMargin = inputMargin;
            placeholderTextFormat.leading = (input.height - placeholderTextFormat.size) / 2;
            input.text = placeholder;
            input.setTextFormat(placeholderTextFormat);

            if (isPassword)
                input.displayAsPassword = true;

            if (placeholder)
            {
                input.text = placeholder;

                input.addEventListener(FocusEvent.FOCUS_IN, function(event:FocusEvent):void
                    {
                        if (input.text == placeholder)
                        {
                            input.text = "";
                            input.setTextFormat(inputTextFormat);
                        }
                    });

                input.addEventListener(FocusEvent.FOCUS_OUT, function(event:FocusEvent):void
                    {
                        if (input.text == "")
                        {
                            input.text = placeholder;
                            input.setTextFormat(placeholderTextFormat);
                        }
                    });
            }

            return input;
        }

        private function createButton(label:String):Sprite
        {
            var button:Sprite = new Sprite();
            button.graphics.beginFill(PRIMARY);
            button.graphics.drawRect(0, 0, 350, 50);
            button.graphics.endFill();

            var buttonText:TextField = new TextField();
            buttonText.text = label;
            buttonText.textColor = WHITE;
            buttonText.width = button.width;
            buttonText.height = button.height;
            buttonText.selectable = false;
            buttonText.mouseEnabled = false;

            // Set alignment properties
            var textFormat:TextFormat = new TextFormat();
            textFormat.size = 24;
            textFormat.align = "center";
            buttonText.defaultTextFormat = textFormat;

            buttonText.autoSize = TextFieldAutoSize.CENTER;
            buttonText.x = (button.width - buttonText.width) / 2;
            buttonText.y = (button.height - buttonText.height) / 2;

            button.addChild(buttonText);

            return button;
        }

        private function submitButtonClickHandler(event:MouseEvent):void
        {
            new URLLoaderApi().load(GLOBAL._apiURL + "bm/getnewmap", null, attachAuthCredentials);
        }

        private function attachAuthCredentials(serverData:Object)
        {
            LOGIN.OnGetNewMap(serverData, [["email", emailValue], ["password", passwordValue]]);
        }

    }
}