package com.auth
{
    import flash.display.Sprite;
    import flash.display.CapsStyle;
    import flash.display.JointStyle;
    import flash.display.LineScaleMode;
    import flash.text.TextField;
    import flash.text.TextFieldType;
    import flash.text.TextFieldAutoSize;
    import flash.text.AntiAliasType;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.ui.MouseCursor;
    import flash.ui.Mouse;
    import flash.text.TextFormat;
    import flash.filters.DropShadowFilter;
    import flash.display.Bitmap;
    import flash.display.Loader;
    import flash.net.URLRequest;
    import flash.events.FocusEvent;
    import flash.text.TextFormatAlign;
    import flash.system.LoaderContext;
    import flash.geom.Rectangle;
    import flash.events.IOErrorEvent;
    import flash.utils.Timer;
    import flash.events.TimerEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.SharedObject;
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

        private var uiRoot:Sprite;

        private var navContainer:Sprite;

        private var selectField:Sprite;

        private var selectInput:Sprite;
        private static const FORM_WIDTH:Number = 450;
        private static const FORM_HEIGHT:Number = 600;

        private var dropdownMenu:Sprite;

        private var usernameInput:TextField;

        
        private var usernameBorder:Sprite;
        private var emailBorder:Sprite;
        private var passwordBorder:Sprite;
        private var baseEmailY:Number;
        private var basePasswordY:Number;
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

        private var authLinkContainer:Sprite;

        private var defaultText:TextField;

        private var hasAccountFormat:TextFormat;

        private var button:Sprite;

        private var buttonText:TextField;

        private var image:Bitmap;

        private var loader:Loader;

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

        // Remember Email (local-only)
        private static const REMEMBER_SO_NAME:String = "bymr_authprefs";
        private static const REMEMBER_SO_PATH:String = "/";
        private static const REMEMBER_EMAIL_KEY:String = "remember_email";
        private static const REMEMBER_ENABLED_KEY:String = "remember_enabled";

        private var rememberEmailEnabled:Boolean = false;
        private var rememberEmailErrorReported:Boolean = false;

        // Checkbox UI (no plaintext checkbox chars)
        private var rememberEmailRow:Sprite;
        private var rememberEmailBox:Sprite;
        private var rememberEmailCheck:Sprite;
        private var rememberEmailLabel:TextField;

        public function AuthForm()
        {
            addEventListener(Event.ADDED_TO_STAGE, formAddedToStageHandler);

            // Load remembered email state early so it can prefill the Email field when created
            var remembered:Object = loadRememberEmail();
            rememberEmailEnabled = Boolean(remembered.enabled);
            if (rememberEmailEnabled && remembered.email is String)
            {
                emailValue = String(remembered.email);
            }

            GLOBAL.eventDispatcher.addEventListener("initError", function(event:Event):void
                {
                    errMessage.text = GLOBAL.initError;
                    // If loadingContainer is present, refresh the loading screen to update the title
                    if (loadingContainer && loadingContainer.parent)
                    {
                        Loading();
                    }
                });

            checkContentLoadedTimer = new Timer(1000);
            checkContentLoadedTimer.addEventListener(TimerEvent.TIMER, checkContentLoaded);
            checkContentLoadedTimer.start();
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
            try
            {
                if (stage)
                    stage.color = BACKGROUND;
            }
            catch (e:Error)
            {
                this.graphics.beginFill(BACKGROUND);
                this.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
                this.graphics.endFill();
            }

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

            // Root container to isolate auth UI bounds (prevents drift from checkbox/errors)
            uiRoot = new Sprite();
            addChild(uiRoot);

            var formWidth:Number = FORM_WIDTH;
            var formHeight:Number = FORM_HEIGHT;

            languages = KEYS.supportedLanguagesJson;
            selectInput = createSelectInput();
            uiRoot.addChild(selectInput);
            selectInput.x = 20;
            selectInput.y = 10;

            HeaderTitle();
            uiRoot.addChild(navContainer);

            formContainer.graphics.drawRect(0, 0, formWidth, formHeight);
            formContainer.x = 155;
            formContainer.y = 45;
            uiRoot.addChild(formContainer);

            // Y-position for the first input field
            startY = 345;

            // Get image asset
            this.loader = new Loader();
            this.loader.load(new URLRequest(GLOBAL.cdnUrl + "assets/popups/C5-LAB-150.png"));
            this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
            this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent):void
                {
                });

            usernameInput = createBlock(0, 0, "Username");
            emailInput = createBlock(350, 35, "Email");
            passwordInput = createBlock(350, 35, "Password", true);
            emailBorder = CreateBorder(emailInput);
            passwordBorder = CreateBorder(passwordInput);

            // Remember the design-time positions so we can reflow the layout cleanly
            // when switching between Login and Register.
            baseEmailY = emailInput.y;
            basePasswordY = passwordInput.y;

            // Remember email checkbox (login form only)
            if (!isRegisterForm)
            {
                createRememberEmailToggle();
            }

            // Create button
            submitButton = createButton();
            submitButton.x = passwordInput.x + (passwordInput.width - submitButton.width) / 2;
            submitButton.y = startY + 28;
            formContainer.addChild(submitButton);
            submitButton.addEventListener(MouseEvent.CLICK, submitButtonClickHandler);

            // Link
            FormNavigate();
            // This ensures Login fields are shifted up immediately on first load (not only after toggling).
            updateState();
        }

        private function Loading():void
        {
            // Remove previous loadingContainer if present
            if (loadingContainer && loadingContainer.parent)
            {
                loadingContainer.parent.removeChild(loadingContainer);
            }

            loadingContainer = new Sprite();
            addChild(loadingContainer);

            var contentWidth:Number = 400;

            // Create title
            var loadingTitle:TextField = new TextField();
            var titleFormat:TextFormat = new TextFormat();
            titleFormat.font = "Groboldov";
            titleFormat.size = 32;
            titleFormat.color = WHITE;
            titleFormat.align = TextFormatAlign.CENTER;
            loadingTitle.defaultTextFormat = titleFormat;
            loadingTitle.text = GLOBAL.versionMismatch ? "New Update Available!" : "Connecting to the server";
            loadingTitle.width = contentWidth;
            loadingTitle.height = 38;
            loadingTitle.x = 0;
            loadingTitle.selectable = false;
            loadingTitle.embedFonts = true;
            loadingTitle.antiAliasType = AntiAliasType.ADVANCED;
            loadingTitle.autoSize = TextFieldAutoSize.NONE;

            // Create description (only for non-version mismatch)
            var loadingDesc:TextField;
            if (!GLOBAL.versionMismatch)
            {
                loadingDesc = new TextField();
                var descFormat:TextFormat = new TextFormat();
                descFormat.font = "Verdana";
                descFormat.size = 14;
                descFormat.color = LIGHT_GRAY;
                descFormat.align = TextFormatAlign.CENTER;
                loadingDesc.defaultTextFormat = descFormat;
                loadingDesc.htmlText = "<font color='#ffffff'>Taking a while? Check our </font><font color='#00CDB8'><u>#server-status</u></font><font color='#ffffff'> on Discord.</font>";
                loadingDesc.width = contentWidth;
                loadingDesc.height = 28;
                loadingDesc.x = 0;
                loadingDesc.y = 50; // Fixed position
                loadingDesc.selectable = false;
                loadingDesc.embedFonts = true;
                loadingDesc.antiAliasType = AntiAliasType.ADVANCED;
                loadingDesc.autoSize = TextFieldAutoSize.NONE;
                mousePointerCursor(loadingDesc);
                loadingDesc.addEventListener(MouseEvent.CLICK, DiscordLink);
                loadingContainer.addChild(loadingDesc);
            }

            // Create error message
            errMessage = new TextField();
            var errFormat:TextFormat = new TextFormat();
            errFormat.font = "Verdana";
            errFormat.size = 16;
            errFormat.color = RED;
            errFormat.align = TextFormatAlign.CENTER;
            errFormat.leading = 5;
            errMessage.defaultTextFormat = errFormat;
            errMessage.htmlText = GLOBAL.initError;
            errMessage.width = contentWidth;
            errMessage.x = 0;
            errMessage.wordWrap = true;
            errMessage.multiline = true;
            errMessage.embedFonts = true;
            errMessage.antiAliasType = AntiAliasType.ADVANCED;
            errMessage.autoSize = TextFieldAutoSize.LEFT;

            // Position elements based on version mismatch
            if (GLOBAL.versionMismatch)
            {
                loadingTitle.y = 140;
                errMessage.y = 190;

                var updateImageLoader:Loader = new Loader();
                updateImageLoader.load(new URLRequest(GLOBAL.serverUrl + "assets/popups/fantastic.png"));
                updateImageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void
                    {
                        var img:Bitmap = Bitmap(updateImageLoader.content);
                        img.x = (contentWidth - img.width) / 2;
                        img.y = 0;
                        loadingContainer.addChildAt(img, 0);
                    });
            }
            else
            {
                // Positions for normal loading (no image)
                loadingTitle.y = 0;
                errMessage.y = 90;
            }

            // Add elements to container
            loadingContainer.addChild(loadingTitle);
            loadingContainer.addChild(errMessage);

            var scale:Number = 2.2;
            loadingContainer.scaleX = loadingContainer.scaleY = scale;

            if (stage)
            {
                loadingContainer.x = 0;
                loadingContainer.y = 50;
            }
            else
            {
                loadingContainer.x = 200;
                loadingContainer.y = 200;
            }
        }

        public static function DiscordLink(param1:Event = null):void
        {
            GLOBAL.gotoURL("https://discord.gg/bymrefitted");
        }

        private function HeaderTitle():void
        {
            var navWidth:Number = 800;
            var navHeight:Number = 50;

            navContainer.graphics.drawRect(0, 0, navWidth, navHeight);
            navContainer.x = -20;
            navContainer.y = 50;

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

            // Use design width to avoid bounds drift from dynamic children.
            input.x = (FORM_WIDTH - input.width) / 2;
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

            // Prefill Email if enabled
            if (placeholder == "Email" && rememberEmailEnabled && emailValue != "" && emailValue != "Email")
            {
                input.text = emailValue;
                input.setTextFormat(inputTextFormat);
            }
            else
            {
                input.text = placeholder;
                input.setTextFormat(placeholderTextFormat);
            }

            if (isPassword)
                input.displayAsPassword = true;

            if (placeholder)
            {
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
        // Remember Email: full-row checkbox + label
        private function createRememberEmailToggle():void
        {
            if (rememberEmailRow) return;

            rememberEmailRow = new Sprite();
            rememberEmailRow.buttonMode = true;
            rememberEmailRow.useHandCursor = true;
            rememberEmailRow.mouseChildren = false;

            rememberEmailBox = new Sprite();
            rememberEmailRow.addChild(rememberEmailBox);

            rememberEmailCheck = new Sprite();
            rememberEmailRow.addChild(rememberEmailCheck);

            rememberEmailLabel = new TextField();
            rememberEmailLabel.selectable = false;
            rememberEmailLabel.mouseEnabled = false;
            rememberEmailLabel.embedFonts = true;
            rememberEmailLabel.antiAliasType = AntiAliasType.NORMAL;
            rememberEmailLabel.autoSize = TextFieldAutoSize.NONE;
            rememberEmailLabel.multiline = false;
            rememberEmailLabel.wordWrap = false;

            var tf:TextFormat = new TextFormat();
            tf.font = "Verdana";
            tf.size = 14;
            tf.color = WHITE;
            rememberEmailLabel.defaultTextFormat = tf;
            updateRememberEmailLabel();
            rememberEmailRow.addChild(rememberEmailLabel);

            rememberEmailRow.addEventListener(MouseEvent.CLICK, onRememberEmailToggleClick);
            formContainer.addChild(rememberEmailRow);

            // Initial draw/position (safe even before other controls exist)
            redrawRememberEmailToggle();
            rememberEmailRow.x = (passwordInput != null) ? passwordInput.x : 0;
            rememberEmailRow.y = (passwordInput != null) ? (passwordInput.y + passwordInput.height + 14) : 0;

            // If other controls exist already, reflow them.
            layoutAuthControls();
        }

        private function updateRememberEmailLabel():void
        {
            if (!rememberEmailLabel) return;

            var label:String = KEYS.Get("auth_remember_email");
            // Fallback for missing translation keys
            if (!label || label == "" || label == "auth_remember_email")
            {
                label = "Remember email";
            }
            rememberEmailLabel.text = label;
        }

        private function redrawRememberEmailToggle():void
        {
            if (!rememberEmailRow) return;

            var rowW:Number = (passwordInput != null) ? passwordInput.width : 350;
            var rowH:Number = 34;

            rememberEmailRow.graphics.clear();
            // Invisible full-row hit area (no background/outline)
            rememberEmailRow.graphics.beginFill(0x000000, 0);
            rememberEmailRow.graphics.drawRect(0, 0, rowW, rowH);
            rememberEmailRow.graphics.endFill();



            var boxSize:Number = 20;
            var boxX:Number = 10;
            var boxY:Number = (rowH - boxSize) / 2;

            rememberEmailBox.graphics.clear();
            rememberEmailBox.graphics.lineStyle(1, rememberEmailEnabled ? PRIMARY : WHITE, rememberEmailEnabled ? 1 : 0.35);
            if (rememberEmailEnabled)
            {
                rememberEmailBox.graphics.beginFill(PRIMARY, 1);
            }
            else
            {
                rememberEmailBox.graphics.beginFill(0x000000, 0);
            }
            rememberEmailBox.graphics.drawRoundRect(0, 0, boxSize, boxSize, 6, 6);
            rememberEmailBox.graphics.endFill();
            rememberEmailBox.x = boxX;
            rememberEmailBox.y = boxY;

            rememberEmailCheck.graphics.clear();
            rememberEmailCheck.graphics.lineStyle(3, WHITE, 1, false, LineScaleMode.NORMAL, CapsStyle.ROUND, JointStyle.ROUND);
            rememberEmailCheck.graphics.moveTo(4, 10);
            rememberEmailCheck.graphics.lineTo(8, 14);
            rememberEmailCheck.graphics.lineTo(16, 5);
            rememberEmailCheck.visible = rememberEmailEnabled;
            rememberEmailCheck.x = boxX;
            rememberEmailCheck.y = boxY;

            updateRememberEmailLabel();
            rememberEmailLabel.x = boxX + boxSize + 12;
            rememberEmailLabel.width = Math.max(0, rowW - rememberEmailLabel.x - 12);
            rememberEmailLabel.height = rowH;
            rememberEmailLabel.y = Math.max(0, (rowH - rememberEmailLabel.textHeight) / 2 - 2);

            // Prevent long translations from expanding container bounds and shifting layout.
            rememberEmailRow.scrollRect = new Rectangle(0, 0, rowW, rowH);
        }

        private function onRememberEmailToggleClick(event:MouseEvent):void
        {
            rememberEmailEnabled = !rememberEmailEnabled;
            redrawRememberEmailToggle();

            var current:String = (emailInput != null) ? emailInput.text : emailValue;
            if (current == "Email") current = "";

            saveRememberEmail(current, rememberEmailEnabled);
            layoutAuthControls();
        }

        private function reportRememberEmailError(message:String):void
        {
            if (rememberEmailErrorReported) return;
            rememberEmailErrorReported = true;

            try
            {
                GLOBAL.Message(message);
            }
            catch (e:Error)
            {
                // Ignore UI errors; this is best-effort reporting.
            }
        }

        private function layoutAuthControls():void
        {
            if (!formContainer || !passwordInput || !submitButton) return;

            var y:Number = passwordInput.y + passwordInput.height + 14;

            // If we have a password validation error field, place controls under it.
            if (passwordErrorText && passwordErrorText.parent == formContainer && passwordErrorText.text != "")
            {
                y = passwordErrorText.y + passwordErrorText.height + 10;
            }

            if (!isRegisterForm)
            {
                if (!rememberEmailRow)
                {
                    createRememberEmailToggle();
                }
                if (rememberEmailRow && rememberEmailRow.parent != formContainer)
                {
                    formContainer.addChild(rememberEmailRow);
                }

                rememberEmailRow.x = passwordInput.x;
                rememberEmailRow.y = y;

                y = rememberEmailRow.y + rememberEmailRow.height + 18;
            }
            else
            {
                if (rememberEmailRow && rememberEmailRow.parent)
                {
                    rememberEmailRow.parent.removeChild(rememberEmailRow);
                }
                y += 10;
            }

            submitButton.x = passwordInput.x + (passwordInput.width - submitButton.width) / 2;
            submitButton.y = y;

            if (authLinkContainer)
            {
                authLinkContainer.x = passwordInput.x + (passwordInput.width - authLinkContainer.width) / 2;
                authLinkContainer.y = submitButton.y + submitButton.height + 15;
            }
        }

        private function loadRememberEmail():Object
        {
            var result:Object = { enabled: false, email: "" };
            try
            {
                var so:SharedObject = SharedObject.getLocal(REMEMBER_SO_NAME, REMEMBER_SO_PATH);
                if (so && so.data)
                {
                    result.enabled = Boolean(so.data[REMEMBER_ENABLED_KEY]);
                    result.email = (so.data[REMEMBER_EMAIL_KEY] is String) ? String(so.data[REMEMBER_EMAIL_KEY]) : "";
                }
            }
            catch (e:Error)
            {
                reportRememberEmailError("Failed to load saved email: " + e);
            }

            // Guard against corrupt/invalid saved data
            if (result.enabled && result.email != "" && !isValidEmail(String(result.email)))
            {
                result.enabled = false;
                result.email = "";
            }

            return result;
        }

        private function saveRememberEmail(email:String, enabled:Boolean):void
        {
            try
            {
                var so:SharedObject = SharedObject.getLocal(REMEMBER_SO_NAME, REMEMBER_SO_PATH);
                if (!so || !so.data) return;

                so.data[REMEMBER_ENABLED_KEY] = enabled;

                // Only persist a real, non-empty email.
                if (enabled && email != "" && isValidEmail(email))
                {
                    so.data[REMEMBER_EMAIL_KEY] = email;
                }
                else
                {
                    delete so.data[REMEMBER_EMAIL_KEY];
                }

                so.flush();
            }
            catch (e:Error)
            {
                reportRememberEmailError("Failed to save email: " + e);
            }
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
            // Remove old container if it exists (e.g., after state toggles/rebuilds)
            if (authLinkContainer && authLinkContainer.parent)
            {
                authLinkContainer.parent.removeChild(authLinkContainer);
            }

            authLinkContainer = new Sprite();
            authLinkContainer.buttonMode = true;
            authLinkContainer.useHandCursor = true;
            authLinkContainer.mouseChildren = false;

            hasAccountText = new TextField();
            hasAccountText.autoSize = TextFieldAutoSize.LEFT;
            hasAccountText.x = 0;

            hasAccountFormat = new TextFormat();
            hasAccountFormat.size = 16;
            updateLinkColour();
            updateLinkText();

            hasAccountText.y = 0;
            authLinkContainer.addChild(hasAccountText);

            mousePointerCursor(authLinkContainer);

            formContainer.addChild(authLinkContainer);
            authLinkContainer.addEventListener(MouseEvent.CLICK, function(event:Event)
                {
                    isRegisterForm = !isRegisterForm;
                    updateState();
                });

            layoutAuthControls();
        }


        private function updateFormFields():void
        {
            // Make Login use the vertical space that Register reserves for the username field.
            // This keeps the topmost visible input closer to the image in both modes.
            var usernameH:Number = 35;
            var gap:Number = 20;
            var loginShift:Number = usernameH + gap;

            // baseEmailY/basePasswordY are captured in handleContentLoaded().

            if (isRegisterForm)
            {
                // Restore base positions before placing the username field above Email.
                emailInput.y = baseEmailY;
                passwordInput.y = basePasswordY;

                if (emailBorder)
                {
                    emailBorder.x = emailInput.x;
                    emailBorder.y = emailInput.y + emailInput.height;
                }
                if (passwordBorder)
                {
                    passwordBorder.x = passwordInput.x;
                    passwordBorder.y = passwordInput.y + passwordInput.height;
                }

                // Re-seat existing error labels (if any) under their fields.
                if (emailErrorText && emailErrorText.parent == formContainer && emailErrorText.text != "")
                {
                    emailErrorText.y = emailInput.y + emailInput.height + 5;
                }
                if (passwordErrorText && passwordErrorText.parent == formContainer && passwordErrorText.text != "")
                {
                    passwordErrorText.y = passwordInput.y + passwordInput.height + 5;
                }

                // Show username field on register
                usernameInput.visible = true;
                usernameInput.mouseEnabled = true;
                usernameInput.tabEnabled = true;

                usernameInput.width = 350;
                usernameInput.height = 35;
                usernameInput.x = 50;
                usernameInput.y = emailInput.y - usernameInput.height - gap;

                // Ensure we don't stack multiple borders when toggling views
                if (usernameBorder && usernameBorder.parent)
                {
                    usernameBorder.parent.removeChild(usernameBorder);
                }
                usernameBorder = CreateBorder(usernameInput);

                // Hide/remove remember email on register view
                if (rememberEmailRow && rememberEmailRow.parent)
                {
                    rememberEmailRow.parent.removeChild(rememberEmailRow);
                }
            }
            else
            {
                // Hide username field on login
                usernameInput.visible = false;
                usernameInput.mouseEnabled = false;
                usernameInput.tabEnabled = false;
                usernameInput.width = 0;
                usernameInput.height = 0;

                if (usernameBorder && usernameBorder.parent)
                {
                    usernameBorder.parent.removeChild(usernameBorder);
                }

                // Pull Login fields up so the topmost input sits where the Register username sits.
                emailInput.y = baseEmailY - loginShift;
                passwordInput.y = basePasswordY - loginShift;

                if (emailBorder)
                {
                    emailBorder.x = emailInput.x;
                    emailBorder.y = emailInput.y + emailInput.height;
                }
                if (passwordBorder)
                {
                    passwordBorder.x = passwordInput.x;
                    passwordBorder.y = passwordInput.y + passwordInput.height;
                }

                // Re-seat existing error labels (if any) under their fields.
                if (emailErrorText && emailErrorText.parent == formContainer && emailErrorText.text != "")
                {
                    emailErrorText.y = emailInput.y + emailInput.height + 5;
                }
                if (passwordErrorText && passwordErrorText.parent == formContainer && passwordErrorText.text != "")
                {
                    passwordErrorText.y = passwordInput.y + passwordInput.height + 5;
                }

                // Ensure checkbox exists on login view
                if (!rememberEmailRow)
                {
                    createRememberEmailToggle();
                }
                else if (!rememberEmailRow.parent)
                {
                    formContainer.addChild(rememberEmailRow);
                }
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
                // Persist remembered email only on successful submit attempt (client-side)
                if (!isRegisterForm)
                {
                    var current:String = emailValue;
                    if (current == "Email") current = "";
                    saveRememberEmail(current, rememberEmailEnabled);
                }

                if (isRegisterForm)
                {
                    if (isUsernameValid)
                    {
                        var newUser:Array = [["username", usernameValue], ["email", emailValue], ["password", passwordValue], ["last_name", ""], ["pic_square", ""]];

                        new URLLoaderApi().load(GLOBAL._apiURL + "player/register", newUser, registerNewUser, function(event:IOErrorEvent):void
                            {
                                GLOBAL.Message("An error occurred during registration on the server.");
                            });
                    }
                    else
                    {
                        GLOBAL.Message("<b>Usernames must be:</b><br><br>• At least 2 characters long.<br>• No longer than 12 characters.<br>• Can only include numbers and letters.");
                    }
                }
                else
                {
                    new URLLoaderApi().load(GLOBAL._apiURL + "bm/getnewmap", null, postAuthDetails, function(event:IOErrorEvent):void
                        {
                            GLOBAL.Message("We cannot connect you to the server at this time. Please try again later or check our server status.");
                        });
                }
            }
            else
            {
                if (!isEmailValid)
                {
                    showErrorMessage(emailInput, "Please enter a valid email address");
                }
                if (!isPasswordValid)
                {
                    showErrorMessage(passwordInput, "Password must be at least 8 characters long, contain at least 1 uppercase letter, and 1 special character");
                }
                if (!isUsernameValid && isRegisterForm)
                {
                    GLOBAL.Message("<b>Usernames must be:</b><br><br>• At least 2 characters long.<br>• No longer than 12 characters.<br>• Can only include numbers and letters.");
                }
            }
        }

        private function postAuthDetails(serverData:Object):void
        {
            LOGIN.OnGetNewMap(serverData, [["email", emailValue], ["password", passwordValue]]);
        }

        private function registerNewUser(serverData:Object):void
        {
            if (serverData.hasOwnProperty("error"))
            {
                GLOBAL.Message(serverData.error);
                return;
            }
            GLOBAL.Message("You have successfully registered an account. Please login to continue.");
            isRegisterForm = false;
            updateState();
        }

        private function isValidUsername(username:String):Boolean
        {
            var pattern:RegExp = /^[a-zA-Z0-9_]+$/;
            return username.length >= 2 && username.length <= 12 && pattern.test(username);
        }

        private function isValidEmail(email:String):Boolean
        {
            var emailPattern:RegExp = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/;
            return emailPattern.test(email);
        }

        private function isValidPassword(password:String):Boolean
        {
            var passwordRegex:RegExp = /^(?=.*[A-Z])(?=.*[\W_])(?=.{8,})/;
            return passwordRegex.test(password);
        }
        private function clearErrorMessages():void
        {
            if (emailErrorText && emailErrorText.parent)
            {
                emailErrorText.parent.removeChild(emailErrorText);
            }
            if (passwordErrorText && passwordErrorText.parent)
            {
                passwordErrorText.parent.removeChild(passwordErrorText);
            }

            if (emailErrorText) emailErrorText.text = "";
            if (passwordErrorText) passwordErrorText.text = "";

            layoutAuthControls();
        }
        private function showErrorMessage(inputField:TextField, errorMessage:String):void
        {
            // Remove any existing error field for this input to prevent stacking/overlap.
            if (inputField == emailInput && emailErrorText && emailErrorText.parent)
            {
                emailErrorText.parent.removeChild(emailErrorText);
            }
            else if (inputField == passwordInput && passwordErrorText && passwordErrorText.parent)
            {
                passwordErrorText.parent.removeChild(passwordErrorText);
            }

            var errorText:TextField = new TextField();
            errorText.textColor = RED;
            errorText.x = inputField.x;
            errorText.y = inputField.y + inputField.height + 5;
            errorText.width = inputField.width;
            errorText.multiline = true;
            errorText.wordWrap = true;
            errorText.htmlText = errorMessage;

            // Fit height to content (minimum helps avoid zero-height edge cases).
            errorText.height = Math.max(18, errorText.textHeight + 10);

            formContainer.addChild(errorText);

            if (inputField == emailInput)
            {
                emailErrorText = errorText;
            }
            else if (inputField == passwordInput)
            {
                passwordErrorText = errorText;
            }

            // Reflow controls so errors never overlap the checkbox/button.
            layoutAuthControls();
        }

        public function updateState():void
        {
            updateFormFields();
            updateButtonText();
            updateButtonColor();
            updateLinkText();
            updateLinkColour();

            if (rememberEmailRow)
            {
                redrawRememberEmailToggle();
            }

            layoutAuthControls();
        }

        public function disposeUI():void
        {
            if (selectInput && selectInput.parent)
            {
                selectInput.parent.removeChild(selectInput);
            }

// Remove event listeners
            submitButton.removeEventListener(MouseEvent.CLICK, submitButtonClickHandler);

            if (rememberEmailRow)
            {
                rememberEmailRow.removeEventListener(MouseEvent.CLICK, onRememberEmailToggleClick);
            }

            // Remove display objects
            formContainer.removeChild(submitButton);
            formContainer.removeChild(emailInput);
            formContainer.removeChild(passwordInput);
            if (formContainer && formContainer.parent)
            {
                formContainer.parent.removeChild(formContainer);
            }

            if (rememberEmailRow && rememberEmailRow.parent)
            {
                rememberEmailRow.parent.removeChild(rememberEmailRow);
            }

            if (image)
            {
                image.bitmapData.dispose();
                formContainer.removeChild(image);
            }
            // Clean up resources
            loader.unload();
            loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onImageLoaded);

            submitButton = null;
            emailInput = null;
            passwordInput = null;
            image = null;
            loader = null;
            selectInput = null;

            rememberEmailRow = null;
            rememberEmailBox = null;
            rememberEmailCheck = null;
            rememberEmailLabel = null;

            if (formContainer.parent)
            {
                formContainer.parent.removeChild(formContainer);
            }
        }

    }
}
