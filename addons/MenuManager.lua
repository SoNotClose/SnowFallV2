-- very good for new poeple who dont understand lua
local MenuManager = {}

function MenuManager:SetLibrary(Library)
    self.Library = Library
end

function MenuManager:BuildMenuSection(Tab)
    local Library = self.Library
    assert(Library, "MenuManager: call SetLibrary before BuildMenuSection")

    local TabBox  = Tab:AddLeftTabbox()
    local MenuTab = TabBox:AddTab("Menu")
    local NotifTab = TabBox:AddTab("Notifications")

    MenuTab:AddToggle("LowercaseMode", {
        Text    = "Lowercase Mode";
        Default = Library.LowercaseMode or false;
        Callback = function(val)
            Library:SetLowercaseMode(val)
        end;
    })

    MenuTab:AddToggle("CustomCursor", {
        Text    = "Custom Cursor";
        Default = Library.ShowCustomCursor or false;
        Callback = function(val)
            Library.ShowCustomCursor = val
        end;
    }):AddColorPicker("CursorColor", {
        Default  = Library.CursorColor or Library.AccentColor;
        Title    = "Cursor Color";
        Callback = function(val)
            Library.CursorColor = val
        end;
    })

    local CursorDepbox = MenuTab:AddDependencyBox()

    CursorDepbox:AddDropdown("CursorType", {
        Text    = "Cursor Type";
        Values  = { "Mouse", "Dot", "Plus" };
        Default = Library.CursorType or "Mouse";
        Callback = function(val)
            Library.CursorType = val
        end;
    })

    local DotDepbox = CursorDepbox:AddDependencyBox()

    DotDepbox:AddSlider("CursorDotScale", {
        Text     = "Dot Scale";
        Default  = Library.CursorDotScale or 5;
        Min = 1; Max = 20; Rounding = 0;
        Callback = function(val)
            Library.CursorDotScale = val
        end;
    })

    DotDepbox:AddToggle("CursorDotOutline", {
        Text    = "Outline";
        Default = Library.CursorDotOutline or false;
        Callback = function(val)
            Library.CursorDotOutline = val
        end;
    })

    local DotOutlineDepbox = DotDepbox:AddDependencyBox()

    DotOutlineDepbox:AddSlider("CursorDotOutlineThickness", {
        Text     = "Outline Thickness";
        Default  = Library.CursorDotOutlineThickness or 1;
        Min = 0.1; Max = 4; Rounding = 1;
        Suffix   = "px";
        Callback = function(val)
            Library.CursorDotOutlineThickness = val
        end;
    })

    DotOutlineDepbox:SetupDependencies({ { Library.Toggles.CursorDotOutline, true } })
    DotDepbox:SetupDependencies({ { Library.Options.CursorType, "Dot" } })

    local PlusDepbox = CursorDepbox:AddDependencyBox()

    PlusDepbox:AddSlider("CursorPlusSpacing", {
        Text     = "Spacing";
        Default  = Library.CursorPlusSpacing or 2;
        Min = 0; Max = 8; Rounding = 0;
        Suffix   = "px";
        Callback = function(val)
            Library.CursorPlusSpacing = val
        end;
    })

    PlusDepbox:AddToggle("CursorPlusTopBar", {
        Text    = "Top Bar";
        Default = Library.CursorPlusTopBar ~= false;
        Callback = function(val)
            Library.CursorPlusTopBar = val
        end;
    })

    PlusDepbox:AddToggle("CursorPlusRightBar", {
        Text    = "Right Bar";
        Default = Library.CursorPlusRightBar ~= false;
        Callback = function(val)
            Library.CursorPlusRightBar = val
        end;
    })

    PlusDepbox:AddToggle("CursorPlusLeftBar", {
        Text    = "Left Bar";
        Default = Library.CursorPlusLeftBar ~= false;
        Callback = function(val)
            Library.CursorPlusLeftBar = val
        end;
    })

    PlusDepbox:AddToggle("CursorPlusBottomBar", {
        Text    = "Bottom Bar";
        Default = Library.CursorPlusBottomBar ~= false;
        Callback = function(val)
            Library.CursorPlusBottomBar = val
        end;
    })

    PlusDepbox:AddToggle("CursorPlusOutline", {
        Text    = "Outline";
        Default = Library.CursorPlusOutline or false;
        Callback = function(val)
            Library.CursorPlusOutline = val
        end;
    })

    local PlusOutlineDepbox = PlusDepbox:AddDependencyBox()

    PlusOutlineDepbox:AddSlider("CursorPlusOutlineThickness", {
        Text     = "Outline Thickness";
        Default  = Library.CursorPlusOutlineThickness or 1;
        Min = 0.1; Max = 4; Rounding = 1;
        Suffix   = "px";
        Callback = function(val)
            Library.CursorPlusOutlineThickness = val
        end;
    })

    PlusOutlineDepbox:SetupDependencies({ { Library.Toggles.CursorPlusOutline, true } })
    PlusDepbox:SetupDependencies({ { Library.Options.CursorType, "Plus" } })

    CursorDepbox:SetupDependencies({ { Library.Toggles.CustomCursor, true } })

    MenuTab:AddDivider()

    MenuTab:AddToggle("ControllerSupport", {
        Text    = "Controller Support";
        Default = Library.ControllerSupport or false;
        Callback = function(val)
            Library.ControllerSupport = val
        end;
    })

    local ControllerDepbox = MenuTab:AddDependencyBox()

    ControllerDepbox:AddDropdown("ControllerNavigation", {
        Text    = "Controller Navigation";
        Values  = { "Dpad", "Joystick" };
        Default = Library.ControllerNavType or "Dpad";
        Callback = function(val)
            Library.ControllerNavType = val
        end;
    })

    ControllerDepbox:SetupDependencies({ { Library.Toggles.ControllerSupport, true } })

    MenuTab:AddDivider()

    MenuTab:AddLabel("Menu Bind"):AddKeyPicker("MenuBind", {
        Default = "RightShift";
        NoUI    = true;
        Text    = "Menu Bind";
    })

    Library.ToggleKeybind = Library.Options.MenuBind

    NotifTab:AddToggle("NotificationForceColor", {
        Text    = "Force Color";
        Default = Library.NotificationForceColor or false;
        Callback = function(val)
            Library.NotificationForceColor = val
        end;
    }):AddColorPicker("NotifAccentColor", {
        Default  = Library.NotificationAccentColor or Color3.fromRGB(120, 120, 200);
        Title    = "Accent Color";
        Callback = function(val)
            Library.NotificationAccentColor = val
        end;
    }):AddColorPicker("NotifOutlineColor", {
        Default  = Library.NotificationOutlineColor or Color3.fromRGB(60, 60, 80);
        Title    = "Outline Color";
        Callback = function(val)
            Library.NotificationOutlineColor = val
        end;
    }):AddColorPicker("NotifFontColor", {
        Default  = Library.NotificationFontColor or Color3.fromRGB(255, 255, 255);
        Title    = "Font Color";
        Callback = function(val)
            Library.NotificationFontColor = val
        end;
    })

    NotifTab:AddDivider()

    NotifTab:AddToggle("NotificationAnimatedBar", {
        Text    = "Animated Bar";
        Default = Library.NotificationAnimatedBar ~= false;
        Callback = function(val)
            Library.NotificationAnimatedBar = val
        end;
    })

    NotifTab:AddDropdown("NotificationBarSide", {
        Text    = "Bar Side";
        Values  = { "Left", "Top", "Right", "Bottom" };
        Default = Library.NotificationBarSide or "Left";
        Callback = function(val)
            Library.NotificationBarSide = val
        end;
    })

    NotifTab:AddSlider("NotificationPositionX", {
        Text    = "Position X";
        Default = Library.NotificationPositionX or 50;
        Min = 0; Max = 100; Rounding = 0;
        Compact = true;
        Callback = function(val)
            Library.NotificationPositionX = val
            Library:UpdateNotificationAreas()
        end;
    }):AddSlider("NotificationPositionY", {
        Text    = "Position Y";
        Default = Library.NotificationPositionY or 50;
        Min = 0; Max = 100; Rounding = 0;
        Compact = true;
        Callback = function(val)
            Library.NotificationPositionY = val
            Library:UpdateNotificationAreas()
        end;
    })

    NotifTab:AddDropdown("NotificationAlignment", {
        Text    = "Alignment";
        Values  = { "Left", "Right", "Center" };
        Default = Library.NotificationAlignment or "Center";
        Callback = function(val)
            Library.NotificationAlignment = val
        end;
    })

    NotifTab:AddDivider()

    local TestInput = NotifTab:AddInput("TestNotifMessage", {
        Text        = "Test Message";
        Default     = "Hello world!";
        Numeric     = false;
        Finished    = false;
    })

    NotifTab:AddButton({
        Text = "Send Notification";
        Func = function()
            Library:Notify({ Title = "Test"; Description = TestInput.Value or "Hello world!"; Time = 4 })
        end;
    })

    local lib = Library

    lib:SetupLanguage("es", {
        LowercaseMode           = { Text = "Modo minúsculas" };
        CustomCursor            = { Text = "Cursor personalizado" };
        CursorType              = { Text = "Tipo de cursor", Values = { "Ratón", "Punto", "Cruz" } };
        CursorDotScale          = { Text = "Tamaño del punto" };
        CursorDotOutline        = { Text = "Contorno" };
        CursorDotOutlineThickness = { Text = "Grosor del contorno" };
        CursorPlusSpacing       = { Text = "Espaciado" };
        CursorPlusTopBar        = { Text = "Barra superior" };
        CursorPlusRightBar      = { Text = "Barra derecha" };
        CursorPlusLeftBar       = { Text = "Barra izquierda" };
        CursorPlusBottomBar     = { Text = "Barra inferior" };
        CursorPlusOutline       = { Text = "Contorno" };
        CursorPlusOutlineThickness = { Text = "Grosor del contorno" };
        ControllerSupport       = { Text = "Soporte de mando" };
        ControllerNavigation    = { Text = "Navegación", Values = { "Dpad", "Joystick" } };
        NotificationForceColor  = { Text = "Forzar color" };
        NotificationAnimatedBar = { Text = "Barra animada" };
        NotificationBarSide     = { Text = "Lado de barra", Values = { "Izquierda", "Arriba", "Derecha", "Abajo" } };
        NotificationPositionX   = { Text = "Posición X" };
        NotificationPositionY   = { Text = "Posición Y" };
        NotificationAlignment   = { Text = "Alineación", Values = { "Izquierda", "Derecha", "Centro" } };
        TestNotifMessage        = { Text = "Mensaje de prueba" };
    })

    lib:SetupLanguage("fr", {
        LowercaseMode           = { Text = "Mode minuscules" };
        CustomCursor            = { Text = "Curseur personnalisé" };
        CursorType              = { Text = "Type de curseur", Values = { "Souris", "Point", "Croix" } };
        CursorDotScale          = { Text = "Taille du point" };
        CursorDotOutline        = { Text = "Contour" };
        CursorDotOutlineThickness = { Text = "Épaisseur du contour" };
        CursorPlusSpacing       = { Text = "Espacement" };
        CursorPlusTopBar        = { Text = "Barre supérieure" };
        CursorPlusRightBar      = { Text = "Barre droite" };
        CursorPlusLeftBar       = { Text = "Barre gauche" };
        CursorPlusBottomBar     = { Text = "Barre inférieure" };
        CursorPlusOutline       = { Text = "Contour" };
        CursorPlusOutlineThickness = { Text = "Épaisseur du contour" };
        ControllerSupport       = { Text = "Support manette" };
        ControllerNavigation    = { Text = "Navigation", Values = { "Dpad", "Joystick" } };
        NotificationForceColor  = { Text = "Forcer couleur" };
        NotificationAnimatedBar = { Text = "Barre animée" };
        NotificationBarSide     = { Text = "Côté barre", Values = { "Gauche", "Haut", "Droite", "Bas" } };
        NotificationPositionX   = { Text = "Position X" };
        NotificationPositionY   = { Text = "Position Y" };
        NotificationAlignment   = { Text = "Alignement", Values = { "Gauche", "Droite", "Centre" } };
        TestNotifMessage        = { Text = "Message de test" };
    })

    self.MenuTab  = MenuTab
    self.NotifTab = NotifTab
    self.TabBox   = TabBox
    return TabBox
end

return MenuManager
