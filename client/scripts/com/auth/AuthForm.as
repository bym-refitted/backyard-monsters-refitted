package com.auth
{
    import flash.display.Sprite;
    import flash.text.TextField;
    import flash.text.TextFormatAlign;
    import flash.text.TextFieldType;
    import flash.text.TextFieldAutoSize;
    import flash.text.AntiAliasType;
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
    import flash.utils.Timer;
    import flash.events.TimerEvent;
    import flash.events.SecurityErrorEvent;

    // DISCLAIMER: This is far from my best work, actually, it's quite miserable, but it works.
    // I don't really have the time, nor the patience to look deprecated best practices for
    // creating a UI with Flash/AS3. But, if you do, then by all means please spare my
    // sanity and make this better and seperate it out. Thanks.
    public class AuthForm extends Sprite
    {

        private var isRegisterForm:Boolean = false;

        private var formContainer:Sprite;

        private var borderContainer:Sprite;

        private var loadingContainer:Sprite;

        private var navContainer:Sprite;

        private var selectField:Sprite;

        private var dropdownMenu:Sprite;

        private var usernameInput:TextField;

        private var emailInput:TextField;

        private var passwordInput:TextField;

        private var usernameValue:String = "";

        private var emailValue:String = "";

        private var passwordValue:String = "";

        private var emailErrorText:TextField;

        private var passwordErrorText:TextField;

        private var errMessage:TextField;

        private var submitButton:Sprite;

        private var hasAccountText:TextField;

        private var defaultText:TextField;

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

        private var BACKGROUND:uint = 0x1D232A;

        private var LIGHT_GRAY = 0xC9C9C9;

        private var PRIMARY:uint = 0x004DE5;

        private var SECONDARY:uint = 0x00CDB8;

        private var checkContentLoadedTimer:Timer;

        private var languages:Array;

        public function AuthForm()
        {
            addEventListener(Event.ADDED_TO_STAGE, formAddedToStageHandler);
            KEYS._storageURL = GLOBAL.languageUrl;
            KEYS.GetSupportedLanguages();
            KEYS.Setup("english");

            // Start a timer every second to check if text content and supported languages are loaded from the server
            checkContentLoadedTimer = new Timer(1000);
            checkContentLoadedTimer.addEventListener(TimerEvent.TIMER, checkContentLoaded);
            checkContentLoadedTimer.start();

            KEYS.securityErrorListener(noConnection);
            KEYS.ioErrorListener(errorEvent);
        }

        private function noConnection(event:SecurityErrorEvent):void
        {
            errMessage.text = KEYS.errorMessage;
        }

        private function errorEvent(event:IOErrorEvent):void
        {
            errMessage.text = KEYS.errorMessage;
        }

        private function checkContentLoaded(event:TimerEvent):void
        {
            // True: Once we receive the language file and supported languages from the server
            // This also let's us know whether a connection has been established.
            if (GLOBAL.textContentLoaded && GLOBAL.supportedLangsLoaded)
            {
                checkContentLoadedTimer.stop();
                checkContentLoadedTimer.removeEventListener(TimerEvent.TIMER, checkContentLoaded);
                removeChild(loadingContainer);
                handleContentLoaded();
            }
            else
            {
                if (!loadingContainer.parent)
                {
                    Loading();
                }
            }
        }

        public function formAddedToStageHandler(event:Event):void
        {
            removeEventListener(Event.ADDED_TO_STAGE, formAddedToStageHandler);
            stage.color = BACKGROUND;

            if (!GLOBAL.textContentLoaded && !GLOBAL.supportedLangsLoaded)
            {
                Loading();
            }
            else
            {
                // If text content is already loaded, proceed with UI setup
                removeChild(loadingContainer);
                handleContentLoaded();
            }
        }

        private function handleContentLoaded():void
        {
            // Global Initialization
            navContainer = new Sprite();
            formContainer = new Sprite();
            usernameInput = new TextField();
            emailInput = new TextField();
            passwordInput = new TextField();
            emailErrorText = new TextField();
            buttonText = new TextField();
            passwordErrorText = new TextField();
            hasAccountText = new TextField();

            var formWidth:Number = 450;
            var formHeight:Number = 600;

            languages = KEYS.supportedLanguagesJson;
            var selectInput:Sprite = createSelectInput();
            addChild(selectInput);
            selectInput.x = 20;
            selectInput.y = 10;

            HeaderTitle();
            addChild(navContainer);

            formContainer.graphics.drawRect(0, 0, formWidth, formHeight);
            formContainer.x = (stage.stageWidth - formContainer.width) / 2;
            formContainer.y = (stage.stageHeight - formContainer.height) / 2;
            addChild(formContainer);

            // Get center point of stage
            centerX = stage.stageWidth / 2;
            centerY = stage.stageHeight / 2;

            // Calculate starting y position to center content
            startY = centerY;

            // Get image asset
            this.loader = new Loader();
            this.loader.load(new URLRequest(GLOBAL.serverUrl + "assets/popups/C5-LAB-150.png"), new LoaderContext(true));
            this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
            this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, handleNetworkError);

            usernameInput = createBlock(0, 0, "Username");
            emailInput = createBlock(350, 35, "Email");
            passwordInput = createBlock(350, 35, "Password", true);
            CreateBorder(emailInput);
            CreateBorder(passwordInput);

            // Create button
            submitButton = createButton();
            submitButton.x = (formContainer.width - submitButton.width) / 2;
            submitButton.y = startY + 28;
            formContainer.addChild(submitButton);
            submitButton.addEventListener(MouseEvent.CLICK, submitButtonClickHandler);

            // Link
            FormNavigate();
        }

        private function Loading():void
        {
            var navWidth:Number = stage.stageWidth;
            var navHeight:Number = stage.stageHeight;
            var loadingDesc:TextField = new TextField();
            var loadingDescStyle:TextFormat = new TextFormat();
            errMessage = new TextField();
            var errMessageStyle:TextFormat = new TextFormat();

            loadingContainer = new Sprite();
            addChild(loadingContainer);

            var loadingTitle:TextField = createRichText("Connecting to the server...", WHITE);

            loadingDescStyle.font = "Verdana";
            loadingDescStyle.size = 14;
            loadingDescStyle.leftMargin = 10;
            loadingDescStyle.color = WHITE;

            errMessageStyle.font = "Verdana";
            errMessageStyle.size = 14;
            errMessageStyle.leftMargin = 30;
            errMessageStyle.color = WHITE;

            loadingDesc.x = loadingTitle.x;
            loadingDesc.y = loadingTitle.y + loadingTitle.height + 15;
            loadingDesc.width = loadingTitle.width + 5;
            loadingDesc.embedFonts = true;
            loadingDesc.antiAliasType = AntiAliasType.NORMAL;
            loadingDesc.defaultTextFormat = loadingDescStyle;
            loadingDesc.htmlText = "<font color='#ffffff'>Taking a while? Check our </font><font color='#00CDB8'>#server-status</font><font color='#ffffff'> on our Discord.</font>";
            loadingDesc.selectable = false;
            loadingDesc.mouseEnabled = true;
            mousePointerCursor(loadingDesc);
            loadingDesc.addEventListener(MouseEvent.CLICK, DiscordLink);

            errMessage.x = loadingTitle.x;
            errMessage.y = loadingDesc.x + loadingDesc.height + 50;
            errMessage.width = loadingTitle.width + 5;
            errMessage.embedFonts = true;
            errMessage.antiAliasType = AntiAliasType.NORMAL;
            errMessage.defaultTextFormat = errMessageStyle;
            errMessage.htmlText = KEYS.errorMessage;

            loadingContainer.addChild(loadingTitle);
            loadingContainer.addChild(loadingDesc);
            loadingContainer.addChild(errMessage);

            loadingContainer.x = (navWidth - loadingContainer.width) / 2;
            loadingContainer.y = (navHeight - loadingContainer.height) / 2;
        }

        public static function DiscordLink(param1:Event = null):void
        {
            GLOBAL.gotoURL("https://discord.com/invite/bym");
        }

        private function HeaderTitle():void
        {
            var navWidth:Number = 800;
            var navHeight:Number = 50;

            navContainer.graphics.drawRect(0, 0, navWidth, navHeight);
            navContainer.x = (stage.stageWidth - navWidth) / 2;
            navContainer.y = 50; // Margin top

            var textContainer:Sprite = new Sprite();
            navContainer.addChild(textContainer);

            var titlePrefix:TextField = createRichText(KEYS.Get("auth_header_prefix"), WHITE);
            textContainer.addChild(titlePrefix);

            var titleSuffix:TextField = createRichText(KEYS.Get("auth_header_suffix"), SECONDARY);
            textContainer.addChild(titleSuffix);
            titleSuffix.x = titlePrefix.x + titlePrefix.width;

            textContainer.x = (navWidth - textContainer.width) / 2;
            textContainer.y = (navHeight - textContainer.height) / 2 + 30;
        }

        // Essentially creates a 'span' element.
        private function createRichText(text:String, color:String):TextField
        {
            var textField:TextField = new TextField();
            var textFormat:TextFormat = new TextFormat();
            textFormat.font = "Groboldov";
            textFormat.size = 32;
            textFormat.color = color;
            textField.embedFonts = true;
            textField.antiAliasType = AntiAliasType.NORMAL;
            textField.autoSize = TextFieldAutoSize.LEFT;
            textField.defaultTextFormat = textFormat;
            textField.text = text;
            return textField;
        }

        private function onImageLoaded(event:Event):void
        {
            image = Bitmap(loader.content);

            image.x = 150;
            image.y = 150;
            image.scaleX = 1;
            image.scaleY = 1;
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
            input.backgroundColor = BACKGROUND;
            input.type = TextFieldType.INPUT;
            input.width = width;
            input.height = height;

            // Normal input
            var inputTextFormat:TextFormat = new TextFormat();
            inputTextFormat.font = "Verdana";
            inputTextFormat.size = 14;
            inputTextFormat.color = WHITE;

            input.embedFonts = true;
            input.antiAliasType = AntiAliasType.NORMAL;
            input.defaultTextFormat = inputTextFormat;

            // Placeholder
            var placeholderTextFormat:TextFormat = new TextFormat();
            placeholderTextFormat.font = "Verdana";
            placeholderTextFormat.size = 14;
            placeholderTextFormat.color = WHITE;

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

        function createSelectInput(defaultOption:String = "English"):Sprite
        {
            selectField = new Sprite();
            var selectWidth:Number = 80;
            var selectHeight:Number = 30;
            selectField.graphics.lineStyle(1, WHITE);
            selectField.graphics.drawRect(0, 0, selectWidth, selectHeight);

            defaultText = new TextField();
            var defaultTextStyle:TextFormat = new TextFormat();
            defaultTextStyle.font = "Groboldov";
            defaultTextStyle.size = 13;

            defaultText.textColor = WHITE;
            defaultText.embedFonts = true;
            defaultText.defaultTextFormat = defaultTextStyle;
            defaultText.text = defaultOption.toLocaleUpperCase();
            defaultText.x = (selectWidth - defaultText.textWidth) / 2;
            defaultText.y = (selectHeight - defaultText.textHeight) / 2;
            mousePointerCursor(defaultText);
            selectField.addChild(defaultText);

            // Create the dropdown menu
            dropdownMenu = new Sprite();
            dropdownMenu.visible = false;
            selectField.addChild(dropdownMenu);

            // Populate the dropdown menu with options
            for (var index:int = 0; index < languages.length; index++)
            {
                var langSelectText:TextField = new TextField();
                var langSelectTextStyle:TextFormat = new TextFormat();
                langSelectTextStyle.font = "Groboldov";
                langSelectTextStyle.size = 13;

                langSelectText.embedFonts = true;
                langSelectText.textColor = WHITE;
                langSelectText.defaultTextFormat = langSelectTextStyle;
                langSelectText.text = languages[index].toLocaleUpperCase();
                langSelectText.y = index * 30;
                langSelectText.width = 200;
                langSelectText.selectable = false;
                langSelectText.antiAliasType = AntiAliasType.NORMAL;
                langSelectText.addEventListener(MouseEvent.CLICK, langSelectClickHandler);
                mousePointerCursor(langSelectText);
                dropdownMenu.addChild(langSelectText);
            }

            // Handle click events to toggle the dropdown menu visibility
            selectField.addEventListener(MouseEvent.CLICK, function(event:MouseEvent):void
                {
                    dropdownMenu.visible = !dropdownMenu.visible;
                });

            dropdownMenu.y = 50;

            return selectField;
        }

        // Function to handle language select event
        private function langSelectClickHandler(event:MouseEvent):void
        {
            var selectedLanguage = event.currentTarget.text;
            defaultText.text = selectedLanguage;
            defaultText.width = 200;
            dropdownMenu.visible = true;

            var textWidth:Number = defaultText.textWidth;
            var newSelectWidth:Number = textWidth + 23;

            selectField.graphics.clear();
            selectField.graphics.lineStyle(1, WHITE);
            selectField.graphics.drawRect(0, 0, newSelectWidth, 30);

            // Iterate over the supported languages and pass them to KEYS.Setup()
            // to grab available language file.
            for each (var language:String in languages)
            {
                if (selectedLanguage.toLocaleLowerCase() === language.toLocaleLowerCase())
                {
                    KEYS.Setup(language.toLowerCase());
                    return;
                }
            }
            KEYS.Setup("english");
        }

        private function CreateBorder(input:TextField):Sprite
        {
            borderContainer = new Sprite();
            borderContainer.graphics.lineStyle(1, WHITE);
            borderContainer.graphics.moveTo(0, 2);
            borderContainer.graphics.lineTo(input.width, 2);
            borderContainer.x = input.x;
            borderContainer.y = input.y + input.height;

            formContainer.addChild(borderContainer);
            return borderContainer;
        }

        private function createButton():Sprite
        {
            var formRadius:Number = 16;
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

            var textFormat:TextFormat = new TextFormat();
            textFormat.font = "Groboldov";
            textFormat.size = 16;
            textFormat.align = TextFormatAlign.CENTER;
            buttonText.embedFonts = true;
            buttonText.defaultTextFormat = textFormat;
            updateButtonText();

            buttonText.autoSize = TextFieldAutoSize.CENTER;
            buttonText.x = (button.width - buttonText.width) / 2;
            buttonText.y = (button.height - buttonText.height) / 2;
            mousePointerCursor(button);

            button.addChild(buttonText);

            return button;
        }

        private function FormNavigate():void
        {
            var linkContainer:Sprite = new Sprite();
            linkContainer.buttonMode = true;
            linkContainer.useHandCursor = true;
            linkContainer.mouseChildren = false;

            hasAccountText = new TextField();
            hasAccountText.autoSize = TextFieldAutoSize.LEFT;
            hasAccountText.x = linkContainer.width / 2;

            hasAccountFormat = new TextFormat();
            hasAccountFormat.size = 16;
            updateLinkColour();
            updateLinkText();

            hasAccountText.y = 0;
            linkContainer.addChild(hasAccountText);

            linkContainer.x = (formContainer.width - linkContainer.width) / 2;
            linkContainer.y = submitButton.y + submitButton.height + 15;
            mousePointerCursor(linkContainer);

            formContainer.addChild(linkContainer);
            linkContainer.addEventListener(MouseEvent.CLICK, function(event:Event)
                {
                    isRegisterForm = !isRegisterForm;
                    updateState();
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
                CreateBorder(usernameInput);
            }
            else
            {
                usernameInput.width = 0;
                usernameInput.height = 0;
                formContainer.removeChild(borderContainer);
            }
        }

        private function updateLinkText():void
        {
            hasAccountText.embedFonts = true;
            hasAccountText.antiAliasType = AntiAliasType.NORMAL;
            hasAccountText.text = isRegisterForm ? KEYS.Get("auth_login_link") : KEYS.Get("auth_register_link");
        }

        private function updateLinkColour():void
        {
            hasAccountFormat.color = isRegisterForm ? SECONDARY : PRIMARY;
            hasAccountFormat.font = "Verdana";
            hasAccountText.defaultTextFormat = hasAccountFormat;
            hasAccountText.setTextFormat(hasAccountFormat);
        }

        private function updateButtonText():void
        {
            button.graphics.beginFill(isRegisterForm ? PRIMARY : SECONDARY);
            buttonText.text = isRegisterForm ? KEYS.Get("auth_register_btn").toUpperCase() : KEYS.Get("auth_login_btn").toUpperCase();
        }

        private function updateButtonColor():void
        {
            button.graphics.beginFill(isRegisterForm ? SECONDARY : PRIMARY);
            button.graphics.drawRoundRect(0, 0, 350, 50, 12);
            button.graphics.endFill();
        }

        private function mousePointerCursor(element:*):void
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
                        new URLLoaderApi().load(GLOBAL._apiURL + "player/register", newUser, registerNewUser, handleRegisterFailure);
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
            GLOBAL.Message("<b>Congratulations!</b> Your account has been successfully created, you can now login.");
            isRegisterForm = false;
            updateState();
        }

        public function handleNetworkError(event:IOErrorEvent):void
        {
            GLOBAL.Message("Hmm.. it seems we cannot connect you to the server at this time. Please try again later or check our server status.");
        }

        public function handleRegisterFailure(event:Event):void
        {
            GLOBAL.Message("It seems this account already exists. Please try to login.");
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

        public function updateState():void
        {
            updateFormFields();
            updateButtonText();
            updateButtonColor();
            updateLinkText();
            updateLinkColour();
        }

        public function disposeUI():void
        {
            // Remove event listeners
            submitButton.removeEventListener(MouseEvent.CLICK, submitButtonClickHandler);

            // Remove display objects
            formContainer.removeChild(submitButton);
            formContainer.removeChild(emailInput);
            formContainer.removeChild(passwordInput);
            formContainer.removeChild(image);
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