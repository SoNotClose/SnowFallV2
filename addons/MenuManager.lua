local MenuManager = {}

function MenuManager:SetLibrary(Library)
    self.Library = Library
end

function MenuManager:BuildMenuSection(Tab)
    local Library = self.Library
    assert(Library, "MenuManager: call SetLibrary before BuildMenuSection")

    local TabBox = Tab:AddLeftTabbox()
    local MenuTab = TabBox:AddTab("Menu")
    local NotifTab = TabBox:AddTab("Notifications")

    MenuTab:AddToggle("LowercaseMode", {
        Text = "Lowercase Mode";
        Default = Library.LowercaseMode or false;
        Callback = function(val)
            Library:SetLowercaseMode(val)
        end;
    })

    MenuTab:AddToggle("CustomCursor", {
        Text = "Custom Cursor";
        Default = Library.ShowCustomCursor or false;
        Callback = function(val)
            Library.ShowCustomCursor = val
        end;
    })

    local CursorDepbox = MenuTab:AddDependencyBox()

    CursorDepbox:AddDropdown("CursorType", {
        Text = "Cursor Type";
        Values = { "Mouse", "Dot", "Plus" };
        Default = Library.CursorType or "Mouse";
        Callback = function(val)
            Library.CursorType = val
        end;
    })

    CursorDepbox:SetupDependencies({ { Library.Toggles.CustomCursor, true } })

    MenuTab:AddDivider()

    MenuTab:AddToggle("ControllerSupport", {
        Text = "Controller Support";
        Default = Library.ControllerSupport or false;
        Callback = function(val)
            Library.ControllerSupport = val
        end;
    })

    local ControllerDepbox = MenuTab:AddDependencyBox()

    ControllerDepbox:AddDropdown("ControllerNavigation", {
        Text = "Controller Navigation";
        Values = { "Dpad", "Joystick" };
        Default = "Dpad";
        Callback = function(val)
            Library.ControllerNavigation = val
        end;
    })

    ControllerDepbox:SetupDependencies({ { Library.Toggles.ControllerSupport, true } })

    MenuTab:AddDivider()

    MenuTab:AddLabel("Menu Bind"):AddKeyPicker("MenuBind", {
        Default = "RightShift";
        NoUI = true;
        Text = "Menu Bind";
    })

    Library.ToggleKeybind = Library.Options.MenuBind

    NotifTab:AddToggle("NotificationForceColor", {
        Text = "Force Color";
        Default = Library.NotificationForceColor or false;
        Callback = function(val)
            Library.NotificationForceColor = val
        end;
    })

    local ColorDepbox = NotifTab:AddDependencyBox()

    ColorDepbox:AddColorPicker("NotifAccentColor", {
        Text = "Accent Color";
        Default = Library.NotificationAccentColor or Color3.fromRGB(120, 120, 200);
        Callback = function(val)
            Library.NotificationAccentColor = val
        end;
    })

    ColorDepbox:AddColorPicker("NotifOutlineColor", {
        Text = "Outline Color";
        Default = Library.NotificationOutlineColor or Color3.fromRGB(60, 60, 80);
        Callback = function(val)
            Library.NotificationOutlineColor = val
        end;
    })

    ColorDepbox:AddColorPicker("NotifFontColor", {
        Text = "Font Color";
        Default = Library.NotificationFontColor or Color3.fromRGB(255, 255, 255);
        Callback = function(val)
            Library.NotificationFontColor = val
        end;
    })

    ColorDepbox:SetupDependencies({ { Library.Toggles.NotificationForceColor, true } })

    NotifTab:AddDivider()

    NotifTab:AddToggle("NotificationAnimatedBar", {
        Text = "Animated Bar";
        Default = Library.NotificationAnimatedBar ~= false;
        Callback = function(val)
            Library.NotificationAnimatedBar = val
        end;
    })

    NotifTab:AddSlider("NotificationPositionX", {
        Text = "Position X";
        Default = Library.NotificationPositionX or 50;
        Min = 0; Max = 100; Rounding = 0;
        Compact = true;
        Callback = function(val)
            Library.NotificationPositionX = val
            Library:UpdateNotificationAreas()
        end;
    }):AddSlider("NotificationPositionY", {
        Text = "Position Y";
        Default = Library.NotificationPositionY or 50;
        Min = 0; Max = 100; Rounding = 0;
        Compact = true;
        Callback = function(val)
            Library.NotificationPositionY = val
            Library:UpdateNotificationAreas()
        end;
    })

    NotifTab:AddDropdown("NotificationAlignment", {
        Text = "Alignment";
        Values = { "Left", "Right", "Center" };
        Default = Library.NotificationAlignment or "Center";
        Callback = function(val)
            Library.NotificationAlignment = val
        end;
    })

    NotifTab:AddDropdown("NotificationBarSide", {
        Text = "Bar Side";
        Values = { "Left", "Top", "Right", "Bottom" };
        Default = Library.NotificationBarSide or "Left";
        Callback = function(val)
            Library.NotificationBarSide = val
        end;
    })

    NotifTab:AddDivider()

    local TestInput = NotifTab:AddInput("TestNotifMessage", {
        Text = "Test Message";
        Default = "Hello world!";
        Numeric = false;
        Finished = false;
    })

    NotifTab:AddButton({
        Text = "Send Notification";
        Func = function()
            Library:Notify({ Title = "Test"; Description = TestInput.Value or "Hello world!"; Time = 4 })
        end;
    })

    return TabBox
end

return MenuManager
