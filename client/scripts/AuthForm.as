package
{
    import flash.display.Sprite;
    import flash.text.TextField;
    import flash.text.TextFormatAlign;
    import flash.text.TextFieldType;
    import flash.text.TextFieldAutoSize;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import flash.ui.MouseCursor;
    import flash.ui.Mouse;
    import flash.events.MouseEvent;
    import flash.text.TextFormat;
    import flash.filters.DropShadowFilter;
    import flash.display.Bitmap;
    import flash.display.Loader;
    import flash.net.URLRequest;
    import flash.events.FocusEvent;
    import flash.text.TextFormatAlign;
    import flash.system.LoaderContext;
    import flash.events.IOErrorEvent;

    public class AuthForm extends Sprite
    {

        private var isRegisterForm:Boolean = false;

        private var formContainer:Sprite;

        private var usernameInput:TextField;

        private var emailInput:TextField;

        private var passwordInput:TextField;

        private var usernameValue:String = "";

        private var emailValue:String = "";

        private var passwordValue:String = "";

        private var emailErrorText:TextField;

        private var passwordErrorText:TextField;

        private var checkbox:Checkbox;

        private var rememberText:TextField;

        private var submitButton:Sprite;

        private var hasAccountText:TextField;

        private var hasAccountFormat:TextFormat;

        private var button:Sprite;

        private var buttonText:TextField;

        private var image:Bitmap;

        private var loader:Loader;

        private var centerX:Number;

        private var centerY:Number;

        private var startY:Number;

        private var verticalSpacingBetweenBlocks:Number = 0;

        private var BLACK:uint = 0x000000;

        private var WHITE:uint = 0xFFFFFF;

        private var RED:uint = 0xFF0000;

        private var STAGE_BG:uint = 0xF5F5F5;

        private var LIGHT_GRAY = 0xC9C9C9;

        private var PRIMARY:uint = 0xE9D34F;

        public function AuthForm()
        {
            addEventListener(Event.ADDED_TO_STAGE, formAddedToStageHandler);
        }

        public function formAddedToStageHandler(event:Event):void
        {
            removeEventListener(Event.ADDED_TO_STAGE, formAddedToStageHandler);
            stage.color = STAGE_BG;

            // Global Initialization
            formContainer = new Sprite();
            usernameInput = new TextField();
            emailInput = new TextField();
            passwordInput = new TextField();
            emailErrorText = new TextField();
            buttonText = new TextField();
            passwordErrorText = new TextField();
            rememberText = new TextField();
            checkbox = new Checkbox();
            hasAccountText = new TextField();

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
            var context:LoaderContext = new LoaderContext();
            context.checkPolicyFile = true;
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
            loader.load(new URLRequest(GLOBAL.serverUrl + "assets/bym-refitted-assets/refitted-logo.png"), context);
            loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, handleNetworkError);

            usernameInput = createBlock(0, 0, "Username");
            emailInput = createBlock(350, 35, "Email");
            passwordInput = createBlock(350, 35, "Password", true);

            // Create Checkbox & Remember Me text
            checkbox.x = 60;
            checkbox.y = startY + 3;
            formContainer.addChild(checkbox);
            checkbox.addEventListener(Checkbox.CHECK_EVENT, onRememberUser);
            checkbox.buttonMode = true;
            checkbox.useHandCursor = true;
            checkbox.mouseChildren = false;
            onMouseHoverEffect(checkbox);

            rememberText.x = 80;
            rememberText.y = startY;

            var rememberMeFormat:TextFormat = new TextFormat();
            rememberMeFormat.size = 14;
            rememberMeFormat.color = BLACK;
            rememberText.defaultTextFormat = rememberMeFormat;
            rememberText.text = "Remember Me?";
            formContainer.addChild(rememberText);
            updateCheckboxVisibility();

            // Create button
            submitButton = createButton();
            submitButton.x = (formContainer.width - submitButton.width) / 2;
            submitButton.y = startY + 28;
            formContainer.addChild(submitButton);
            submitButton.addEventListener(MouseEvent.CLICK, submitButtonClickHandler);

            // Link
            createLink();
        }

        private function onRememberUser(event:Event):void
        {
            if (checkbox.Checked)
            {
                GLOBAL.Message("<b>Reminder:</b> checking this box will keep you logged into your account, however, it is considered <b>less secure.</b>");
                LOGIN.sharedObject.data.remembered = true;
            }
            else
            {
                LOGIN.sharedObject.data.remembered = false;
            }
        }

        private function onImageLoaded(event:Event):void
        {
            image = Bitmap(loader.content);

            image.x = (formContainer.width - image.width) / 2 + 160;
            image.y = 20;
            image.scaleX = 0.5;
            image.scaleY = 0.5;
            formContainer.addChild(image);
        }

        // Function to create and position input fields
        private function createBlock(width:Number, height:Number, placeholder:String = "", isPassword:Boolean = false):TextField
        {
            var input:TextField = createInputField(width, height, placeholder, isPassword);
            formContainer.addChild(input);

            input.x = (formContainer.width - input.width) / 2;
            input.y = startY;

            input.addEventListener(Event.CHANGE, function(event:Event):void
                {
                    if (placeholder == "Email")
                    {
                        emailValue = input.text;
                    }
                    else if (placeholder == "Password")
                    {
                        passwordValue = input.text;
                    }
                    else if (placeholder == "Username")
                    {
                        usernameValue = input.text;
                    }
                });

            // Gap between each block
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

            input.defaultTextFormat = inputTextFormat;

            // Placeholder
            var placeholderTextFormat:TextFormat = new TextFormat();
            placeholderTextFormat.size = 16;
            placeholderTextFormat.color = LIGHT_GRAY;
            placeholderTextFormat.leftMargin = inputMargin;
            placeholderTextFormat.rightMargin = inputMargin;

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

        private function createButton():Sprite
        {
            button = new Sprite();
            updateButtonColor();
            button.buttonMode = true;
            button.useHandCursor = true;
            button.mouseChildren = false;

            buttonText = new TextField();
            buttonText.textColor = WHITE;
            buttonText.width = button.width;
            buttonText.height = button.height;
            buttonText.selectable = false;
            buttonText.mouseEnabled = false;

            // Set alignment properties
            var textFormat:TextFormat = new TextFormat();
            textFormat.size = 16;
            textFormat.align = TextFormatAlign.CENTER;
            buttonText.defaultTextFormat = textFormat;
            updateButtonText();

            buttonText.autoSize = TextFieldAutoSize.CENTER;
            buttonText.x = (button.width - buttonText.width) / 2;
            buttonText.y = (button.height - buttonText.height) / 2;
            onMouseHoverEffect(button);

            button.addChild(buttonText);

            return button;
        }

        private function createLink():void
        {
            var linkContainer:Sprite = new Sprite();
            linkContainer.buttonMode = true;
            linkContainer.useHandCursor = true;
            linkContainer.mouseChildren = false;

            hasAccountText = new TextField();
            hasAccountText.autoSize = TextFieldAutoSize.LEFT;
            hasAccountText.x = linkContainer.width / 2;

            hasAccountFormat = new TextFormat();
            hasAccountFormat.size = 14;
            updateLinkColour();
            updateLinkText();

            hasAccountText.y = 0;
            linkContainer.addChild(hasAccountText);

            // Position the text container beneath the button
            linkContainer.x = (formContainer.width - linkContainer.width) / 2;
            linkContainer.y = submitButton.y + submitButton.height + 15; // Adjust the vertical position
            onMouseHoverEffect(linkContainer);

            formContainer.addChild(linkContainer);
            linkContainer.addEventListener(MouseEvent.CLICK, function(event:Event)
                {
                    isRegisterForm = !isRegisterForm;
                    updateUI();
                });
        }

        private function updateFormFields():void
        {
            if (isRegisterForm)
            {
                usernameInput.width = 350;
                usernameInput.height = 35;
                usernameInput.x = 50;
                usernameInput.y = emailInput.y - usernameInput.height - 20;
            }
            else
            {
                usernameInput.width = 0;
                usernameInput.height = 0;
            }
        }

        private function updateLinkText():void
        {
            hasAccountText.text = isRegisterForm ? "Already have an account? Login here." : "Don't have an account? Register here.";
        }

        private function updateLinkColour():void
        {
            hasAccountFormat.color = isRegisterForm ? BLACK : PRIMARY;
            hasAccountText.defaultTextFormat = hasAccountFormat;
            hasAccountText.setTextFormat(hasAccountFormat);
        }

        private function updateButtonText():void
        {
            button.graphics.beginFill(isRegisterForm ? PRIMARY : BLACK);
            buttonText.text = isRegisterForm ? "Register".toUpperCase() : "Login".toUpperCase();
        }

        private function updateButtonColor():void
        {
            // button.graphics.clear();
            button.graphics.beginFill(isRegisterForm ? BLACK : PRIMARY);
            button.graphics.drawRect(0, 0, 350, 50);
            button.graphics.endFill();
        }

        private function updateCheckboxVisibility():void
        {
            if (isRegisterForm)
            {
                checkbox.visible = false;
                rememberText.visible = false;
            }
            else
            {
                checkbox.visible = true;
                rememberText.visible = true;
            }
        }

        private function onMouseHoverEffect(element:Sprite):void
        {
            element.addEventListener(MouseEvent.ROLL_OVER, function(e:MouseEvent):void
                {
                    Mouse.cursor = MouseCursor.BUTTON;
                });

            element.addEventListener(MouseEvent.ROLL_OUT, function(e:MouseEvent):void
                {
                    Mouse.cursor = MouseCursor.AUTO;
                });
        }

        private function submitButtonClickHandler(event:MouseEvent):void
        {
            clearErrorMessages();

            var isUsernameValid:Boolean = isValidUsername(usernameValue);
            var isEmailValid:Boolean = isValidEmail(emailValue);
            var isPasswordValid:Boolean = isValidPassword(passwordValue);

            if (isEmailValid && isPasswordValid)
            {
                if (isRegisterForm)
                {
                    if (isUsernameValid)
                    {
                        var newUser:Array = [["username", usernameValue], ["email", emailValue], ["password", passwordValue], ["last_name", ""], ["pic_square", ""]];
                        new URLLoaderApi().load(GLOBAL._apiURL + "player/register", newUser, registerNewUser, handleNetworkError);
                    }
                    else
                    {
                        GLOBAL.Message("<b>Usernames must be:</b><br><br>• At least 2 characters long.<br>• No longer than 15 characters.<br>• Can only include numbers, letters, and underscores.");
                    }
                }
                else
                {
                    new URLLoaderApi().load(GLOBAL._apiURL + "bm/getnewmap", null, postAuthDetails, handleNetworkError);
                }
            }
            else
            {
                if (!isEmailValid)
                {
                    showErrorMessage(emailInput, "Invalid email format");
                }
                if (!isPasswordValid)
                {
                    showErrorMessage(passwordInput, "Password must be at least 8 characters");
                }
                if (!isUsernameValid && isRegisterForm)
                {
                    GLOBAL.Message("<b>Usernames must be:</b><br><br>• At least 2 characters long.<br>• No longer than 15 characters.<br>• Can only include numbers, letters, and underscores.");
                }
            }
        }

        private function postAuthDetails(serverData:Object):void
        {
            LOGIN.OnGetNewMap(serverData, [["email", emailValue], ["password", passwordValue]]);
        }

        private function registerNewUser(serverData:Object):void
        {
            GLOBAL.Message("<b>Congratulations!</b> Your account has been successfully created, you can now login.<br><br>As a new member of Backyard Monsters Refitted, we're excited to have you on board!");
            isRegisterForm = false;
            updateUI();
        }

        public function handleNetworkError(event:Event):void
        {
            GLOBAL.Message("Hmm.. it seems we cannot connect you to the server at this time. Please try again later or check our server status.");
        }

        private function isValidUsername(username:String):Boolean
        {
            var pattern:RegExp = /^[a-zA-Z0-9_]+$/;
            return username.length >= 2 && username.length <= 15 && pattern.test(username);
        }

        private function isValidEmail(email:String):Boolean
        {
            var emailPattern:RegExp = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/;
            return emailPattern.test(email);
        }

        private function isValidPassword(password:String):Boolean
        {
            return password.length >= 8;
        }

        private function clearErrorMessages():void
        {
            emailErrorText.text = "";
            passwordErrorText.text = "";
        }

        private function showErrorMessage(inputField:TextField, errorMessage:String):void
        {
            var errorText:TextField = new TextField();
            errorText.text = errorMessage;
            errorText.textColor = RED;
            errorText.x = inputField.x;
            ;
            errorText.y = inputField.y + inputField.height;
            errorText.width = inputField.width;
            errorText.height = errorText.textHeight + 3;
            formContainer.addChild(errorText);

            if (inputField == emailInput)
            {
                emailErrorText = errorText;
            }
            else if (inputField == passwordInput)
            {
                passwordErrorText = errorText;
            }
        }

        public function updateUI():void
        {
            updateFormFields();
            updateButtonText();
            updateButtonColor();
            updateCheckboxVisibility();
            updateLinkText();
            updateLinkColour();
        }

        public function disposeUI():void
        {
            // Remove event listeners
            submitButton.removeEventListener(MouseEvent.CLICK, submitButtonClickHandler);
            checkbox.Remove();

            // Remove display objects
            formContainer.removeChild(submitButton);
            formContainer.removeChild(emailInput);
            formContainer.removeChild(passwordInput);
            formContainer.removeChild(image);
            formContainer.removeChild(checkbox);
            removeChild(formContainer);

            // Clean up resources
            loader.unload();
            loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onImageLoaded);

            submitButton = null;
            emailInput = null;
            passwordInput = null;
            image = null;
            loader = null;

            if (formContainer.parent)
            {
                formContainer.parent.removeChild(formContainer);
            }
        }

    }
}