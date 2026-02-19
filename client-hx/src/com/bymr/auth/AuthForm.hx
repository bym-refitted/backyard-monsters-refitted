package com.bymr.auth;

import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormatAlign;
import openfl.text.TextFieldType;
import openfl.text.TextFieldAutoSize;
import openfl.text.AntiAliasType;
import openfl.events.MouseEvent;
import openfl.events.Event;
import openfl.ui.MouseCursor;
import openfl.ui.Mouse;
import openfl.events.MouseEvent;
import openfl.text.TextFormat;
import openfl.display.Bitmap;
import openfl.display.Loader;
import openfl.net.URLRequest;
import openfl.events.FocusEvent;
import openfl.text.TextFormatAlign;
import openfl.events.IOErrorEvent;
import openfl.utils.Timer;
import openfl.events.TimerEvent;

import com.bymr.hx.HaxeLib.GLOBAL;
import com.bymr.hx.HaxeLib.LOGGER;

// TODO: This file needs a complete refactor. It is currently very messy and hard to read.
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

    private var startY:Number;

    private var verticalSpacingBetweenBlocks:Number = 0;

    private var BLACK:uint = 0x000000;

    private var WHITE:uint = 0xFFFFFF;

    private var RED:uint = 0xFF0000;

    private var BACKGROUND:uint = 0x1D232A;

    private var LIGHT_GRAY:uint = 0xC9C9C9;

    private var PRIMARY:uint = 0x004DE5;

    private var SECONDARY:uint = 0x00CDB8;

    private var checkContentLoadedTimer:Timer;

    private var languages:Array;

    private var background:Sprite;

    private var contentContainer:Sprite;

    private const DESIGN_WIDTH:Number = 760;

    private const DESIGN_HEIGHT:Number = 670;

    public function AuthForm()
    {
        background = new Sprite();
        addChild(background);

        contentContainer = new Sprite();
        addChild(contentContainer);

        addEventListener(Event.ADDED_TO_STAGE, formAddedToStageHandler);

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
            if (loadingContainer && loadingContainer.parent)
            {
                contentContainer.removeChild(loadingContainer);
            }
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

        drawBackground();
        centerContent();
        stage.addEventListener(Event.RESIZE, onStageResize);

        if (!GLOBAL.textContentLoaded && !GLOBAL.supportedLangsLoaded)
        {
            Loading();
        }
        else
        {
            // If text content is already loaded, proceed with UI setup
            if (loadingContainer && loadingContainer.parent)
            {
                contentContainer.removeChild(loadingContainer);
            }
            handleContentLoaded();
        }
    }

    private function onStageResize(event:Event):void
    {
        drawBackground();
        centerContent();
        GLOBAL.RefreshScreen();
        GLOBAL.ResizeLayer(GLOBAL._layerTop);
    }

    private function drawBackground():void
    {
        // slight hack but its only 2-lines of shit
        var offsetX:Number = -(stage.stageWidth - DESIGN_WIDTH) / 2;
        var offsetY:Number = -(stage.stageHeight - DESIGN_HEIGHT) / 2;
        background.graphics.clear();
        background.graphics.beginFill(BACKGROUND);
        background.graphics.drawRect(offsetX, offsetY, stage.stageWidth, stage.stageHeight);
        background.graphics.endFill();
    }

    private function centerContent():void
    {
        contentContainer.x = 0;
        contentContainer.y = 0;
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
        contentContainer.addChild(selectInput);
        selectInput.x = 20;
        selectInput.y = 10;

        HeaderTitle();
        contentContainer.addChild(navContainer);

        formContainer.graphics.drawRect(0, 0, formWidth, formHeight);
        formContainer.x = 155;
        formContainer.y = 45;
        contentContainer.addChild(formContainer);

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
        // Remove previous loadingContainer if present
        if (loadingContainer && loadingContainer.parent)
        {
            loadingContainer.parent.removeChild(loadingContainer);
        }

        loadingContainer = new Sprite();
        contentContainer.addChild(loadingContainer);

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

        // Fixed container position
        loadingContainer.x = 200;
        loadingContainer.y = 200;
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
    private function createRichText(text:String, color:uint):TextField
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

    private function createSelectInput(defaultOption:String = "English"):Sprite
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
        var selectedLanguage:String = event.currentTarget.text;
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
        linkContainer.addEventListener(MouseEvent.CLICK, function(event:Event):void
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
                showErrorMessage(passwordInput, "Password must be at least 8 characters long, contain at least 1 uppercase\nletter, and 1 special character");
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
        emailErrorText.text = "";
        passwordErrorText.text = "";
    }

    private function showErrorMessage(inputField:TextField, errorMessage:String):void
    {
        var errorText:TextField = new TextField();
        errorText.htmlText = errorMessage;
        errorText.textColor = RED;
        errorText.x = inputField.x;
        ;
        errorText.y = inputField.y + inputField.height + 5;
        errorText.width = inputField.width + 100;
        errorText.height = 40;
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
        if (stage)
        {
            stage.removeEventListener(Event.RESIZE, onStageResize);
        }

        // Stop timer
        if (checkContentLoadedTimer)
        {
            checkContentLoadedTimer.stop();
            checkContentLoadedTimer.removeEventListener(TimerEvent.TIMER, checkContentLoaded);
        }

        // Remove event listeners
        if (submitButton)
            submitButton.removeEventListener(MouseEvent.CLICK, submitButtonClickHandler);

        // Dispose bitmap data to free memory
        if (image)
            image.bitmapData.dispose();

        // Unload loader
        if (loader)
        {
            loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onImageLoaded);
            loader.unload();
        }

        // Clear background graphics
        if (background)
            background.graphics.clear();

        if (this.parent)
            this.parent.removeChild(this);
    }

}