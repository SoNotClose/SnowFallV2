## SNOWFALLS DOCUMENTATION

---

### Setup

```lua
local repo        = "https://raw.githubusercontent.com/SoNotClose/SnowFallV2/main/"
local Library     = loadstring(game:HttpGet(repo .. "Library.lua"))()
local MenuManager = loadstring(game:HttpGet(repo .. "addons/MenuManager.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager  = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Options = Library.Options
local Toggles = Library.Toggles
```

---

### Window

The Window is the root container for your entire UI.

**Args**
- `Title` String — main title in the header
- `SubTitle` String *(optional)* — smaller text below the title, same side
- `GameTitle` String *(optional)* — secondary label on the opposite side (e.g. game name)
- `TitleSide` String — `"Left"` (default) | `"Right"` | `"Middle"`
- `GameSide` String — `"Right"` (default) | `"Left"` | `"Middle"`
- `Center` Boolean — spawn in screen center
- `AutoShow` Boolean — show immediately on creation
- `Resizable` Boolean — allow user to resize
- `Size` UDim2 *(optional)* — starting size (default 550×600)
- `Position` UDim2 *(optional)* — starting position (overridden by Center)
- `AnchorPoint` Vector2 *(optional)*
- `NotifySide` String — `"Left"` | `"Right"` | `"Middle"`
- `TabPadding` Number — px spacing between tab buttons
- `MenuFadeTime` Number — fade duration in seconds
- `ShowCustomCursor` Boolean
- `UnlockMouseWhileOpen` Boolean
- `BackgroundImage` String *(optional)* — asset ID

**Usage**
```lua
local Window = Library:CreateWindow({
    Title        = "My Script",
    SubTitle     = "v1.0",
    GameTitle    = "Game Name",
    TitleSide    = "Left",
    GameSide     = "Right",
    Center       = true,
    AutoShow     = true,
    Resizable    = true,
    NotifySide   = "Right",
    TabPadding   = 8,
    MenuFadeTime = 0.2,
    ShowCustomCursor     = true,
    UnlockMouseWhileOpen = true,
})
```

**Methods**
```lua
Window:SetWindowTitle("New Title")
Window:SetBackgroundImage("rbxassetid://12345678")
```

---

### Library Properties

Set directly on `Library` before or after `CreateWindow`.

**Cursor**
- `Library.ShowCustomCursor` Boolean — show custom cursor (default `true`)
- `Library.CursorType` String — `"Mouse"` | `"Dot"` | `"Plus"`
- `Library.CursorColor` Color3 — cursor color (`nil` = use AccentColor)
- `Library.CursorDotScale` Number — dot radius in pixels (default `5`)
- `Library.CursorDotOutline` Boolean
- `Library.CursorDotOutlineThickness` Number (default `1`)
- `Library.CursorPlusSpacing` Number — gap from center in px (default `2`)
- `Library.CursorPlusTopBar` Boolean (default `true`)
- `Library.CursorPlusRightBar` Boolean (default `true`)
- `Library.CursorPlusLeftBar` Boolean (default `true`)
- `Library.CursorPlusBottomBar` Boolean (default `true`)
- `Library.CursorPlusOutline` Boolean
- `Library.CursorPlusOutlineThickness` Number (default `1`)

**Controller**
- `Library.ControllerSupport` Boolean (default `false`)
- `Library.ControllerNavType` String — `"Dpad"` | `"Joystick"`
- `Library.ControllerNavSensitivity` Number (default `5`)

**Tab Sizing**
- `Library.IgnoreTabSizes` Boolean — uniform tab widths (default `false`)
- `Library.TabSize` Number — min width multiplier when IgnoreTabSizes is true (default `5`)
- `Library.IgnoreLimit` Number — tabs before scrolling (default `6`)

**Notifications**
- `Library.NotificationPositionX` Number 0–100 (default `50`)
- `Library.NotificationPositionY` Number 0–100 (default `50`)
- `Library.NotificationAlignment` String — `"Left"` | `"Right"` | `"Center"`
- `Library.NotificationBarSide` String — `"Left"` | `"Top"` | `"Right"` | `"Bottom"`
- `Library.NotificationAnimatedBar` Boolean (top/bottom only)
- `Library.NotificationForceColor` Boolean
- `Library.NotificationAccentColor` Color3
- `Library.NotificationOutlineColor` Color3
- `Library.NotificationFontColor` Color3
- `Library.LimitNotifications` Boolean
- `Library.MaximumNotifications` Number

**Misc**
- `Library.LowercaseMode` Boolean
- `Library.MenuMark` Boolean — draggable name watermark
- `Library.SafeMode` Boolean
- `Library.ActiveTab` String *(read-only)* — name of the currently visible tab
- `Library.ActiveSubTab` String *(read-only)* — name of the currently visible subtab

**Usage**
```lua
Library.ControllerSupport = true
Library.ControllerNavType = "Dpad"
Library.CursorType        = "Plus"
Library.LowercaseMode     = true
```

---

### Library Methods

```lua
-- Toggle the UI open/closed (or force a state)
Library:Toggle()          -- flip
Library:Toggle(true)      -- force open
Library:Toggle(false)     -- force closed

-- Lowercase mode (also re-renders all current text)
Library:SetLowercaseMode(true)

-- Update notification area positions after changing X/Y
Library:UpdateNotificationAreas()

-- Register a cleanup callback (runs on unload/destroy)
Library:OnUnload(function()
    Library.Unloaded = true
end)
```

---

### Tabs

Tabs are the top-level sections. Order is determined by when `Window:AddTab()` is called.

**Args**
- `Name` String

**Methods**
```lua
Tab:ShowTab()              -- switch to this tab programmatically
Tab:HideTab()              -- hide this tab
Tab:SetName("New Name")    -- rename the tab button (also resizes the button)
Tab:SetLayoutOrder(3)      -- reorder the tab button
```

**Usage**
```lua
local Tabs = {
    Main       = Window:AddTab("Main"),
    UISettings = Window:AddTab("UI Settings"),
}

-- The active tab name is always available:
print(Library.ActiveTab)   -- "Main"
```

---

### SubTabs

SubTabs split a Tab into nested sections with a secondary tab bar.

**Args**
- `Name` String

**Methods**
```lua
SubTab:ShowTab()
SubTab:HideTab()
SubTab:SetName("New Name")  -- rename and resize the subtab button
```

**Usage**
```lua
local SubTabs = {
    Elements = Tabs.Main:AddTab("Elements"),
    Features = Tabs.Main:AddTab("Features"),
}

print(Library.ActiveSubTab)  -- "Elements"
```

---

### Groupboxes

Containers that hold UI elements. Every tab/subtab has a left and right column.

**Args**
- `Name` String — title at the top

**Usage**
```lua
local LeftGroup  = Tabs.Main:AddLeftGroupbox("Controls")
local RightGroup = Tabs.Main:AddRightGroupbox("Info")

-- Inside a SubTab:
local SubLeft  = SubTabs.Elements:AddLeftGroupbox("Controls")
local SubRight = SubTabs.Elements:AddRightGroupbox("Colors")
```

**Exposed properties for language system**
```lua
LeftGroup.TitleLabel   -- TextLabel of the groupbox title
```

---

### Tabbox

A mini tab strip embedded inside a column. Use when you need to further split a single column.

**Usage**
```lua
local MyTabbox = LeftGroup:AddTabbox()
-- or a left-aligned tabbox:
local MyTabbox = LeftGroup:AddLeftTabbox()

local BoxTab1 = MyTabbox:AddTab("Section A")
local BoxTab2 = MyTabbox:AddTab("Section B")

-- Elements go directly on the tabbox tab:
BoxTab1:AddToggle("TabToggle", { Text = "Option", Default = false })
```

---

### Toggle

An on/off switch. Stored in `Library.Toggles`.

**Args**
- `Index` String — key for `Toggles.MyKey`
- `Text` String
- `Default` Boolean
- `Tooltip` String *(optional)*
- `Disabled` Boolean *(optional)*
- `Callback` Function — receives `(value: boolean)`

**Methods**
```lua
Toggles.MyToggle:SetValue(true)           -- set state
Toggles.MyToggle:SetText("New Label")     -- rename
Toggles.MyToggle:SetDisabled(true)        -- grey out and block interaction
Toggles.MyToggle:SetVisible(false)        -- hide the row entirely
Toggles.MyToggle:OnChanged(function(val)  -- subscribe without replacing Callback
    print("changed to", val)
end)
```

**Usage**
```lua
LeftGroup:AddToggle("MyToggle", {
    Text     = "Enable Feature",
    Default  = false,
    Tooltip  = "Turns the feature on or off",
    Callback = function(val)
        print("Toggle:", val)
    end,
})

print(Toggles.MyToggle.Value)
Toggles.MyToggle:SetValue(true)
```

**Chaining addons** — ColorPicker or KeyPicker can be chained:
```lua
LeftGroup:AddToggle("GlowToggle", {
    Text = "Glow", Default = false,
}):AddColorPicker("GlowColor", {
    Default = Color3.fromRGB(255, 80, 80), Title = "Glow Color",
    Callback = function(val) end,
})
```

---

### Slider

A number picker within a range. Stored in `Library.Options`.

**Args**
- `Index` String
- `Text` String
- `Default` Number
- `Min` Number
- `Max` Number
- `Rounding` Number — decimal places (`0` = integers)
- `Suffix` String *(optional)* — text after value (e.g. `"px"`, `"%"`)
- `Compact` Boolean *(optional)* — smaller inline style for sub-slider pairs
- `Disabled` Boolean *(optional)*
- `Tooltip` String *(optional)*
- `Callback` Function — receives `(value: number)`

**Methods**
```lua
Options.MySlider:SetValue(75)
Options.MySlider:SetMin(10)
Options.MySlider:SetMax(200)
Options.MySlider:SetText("New Label")
Options.MySlider:SetPrefix("~")
Options.MySlider:SetSuffix("px")
Options.MySlider:SetDisabled(true)
Options.MySlider:SetVisible(false)
Options.MySlider:OnChanged(function(val) print(val) end)
```

**Usage**
```lua
LeftGroup:AddSlider("MySlider", {
    Text     = "Speed",
    Default  = 50,
    Min      = 0,
    Max      = 200,
    Rounding = 0,
    Suffix   = "%",
    Callback = function(val) print(val) end,
})

print(Options.MySlider.Value)
```

**Sub-Sliders** — chain two sliders on one row:
```lua
-- Normal (labels above bars):
LeftGroup:AddSlider("Width", {
    Text = "Width", Default = 50, Min = 0, Max = 100, Rounding = 0,
}):AddSlider("Height", {
    Text = "Height", Default = 50, Min = 0, Max = 100, Rounding = 0,
})

-- Compact (very short labels, label inside bar):
LeftGroup:AddSlider("PosX", {
    Text = "X", Default = 0, Min = -100, Max = 100, Rounding = 1, Compact = true,
}):AddSlider("PosY", {
    Text = "Y", Default = 0, Min = -100, Max = 100, Rounding = 1, Compact = true,
})
```

---

### Dropdown

Lets the user pick one or more values from a list. Stored in `Library.Options`.

**Args**
- `Index` String
- `Text` String
- `Values` Table — `{ "Option A", "Option B" }`
- `Default` Number — 1-based index of initial selection
- `Multi` Boolean *(optional)* — allow multiple selections
- `Searchable` Boolean *(optional)* — search box inside dropdown
- `AllowNull` Boolean *(optional)* — allow no selection
- `SpecialType` String *(optional)* — `"Player"` or `"Team"` for auto-populated lists
- `ExcludeLocalPlayer` Boolean *(optional)* — used with `SpecialType = "Player"`
- `Disabled` Boolean *(optional)*
- `Tooltip` String *(optional)*
- `Callback` Function — receives `(value: string)` (or table for Multi)

**Methods**
```lua
Options.MyDrop:SetValue("Mode B")                -- set selection by value
Options.MyDrop:SetValues({ "New A", "New B" })   -- replace entire list
Options.MyDrop:SetDisabledValues({ "Mode C" })   -- grey out specific entries
Options.MyDrop:SetText("New Label")              -- rename
Options.MyDrop:SetDisabled(true)                 -- disable the whole element
Options.MyDrop:SetVisible(false)
Options.MyDrop:OnChanged(function(val) print(val) end)
```

**Usage**
```lua
-- Single select:
LeftGroup:AddDropdown("MyDrop", {
    Text     = "Mode",
    Values   = { "Mode A", "Mode B", "Mode C" },
    Default  = 1,
    Callback = function(val) print(val) end,
})

-- Multi-select:
LeftGroup:AddDropdown("Colors", {
    Text  = "Colors",
    Values = { "Red", "Green", "Blue" },
    Default = 1,
    Multi = true,
    Callback = function() end,
})

-- Searchable:
LeftGroup:AddDropdown("Item", {
    Text       = "Item",
    Values     = { "Apple", "Banana", "Cherry" },
    Default    = 1,
    Searchable = true,
    Callback   = function(val) end,
})

-- Player list (auto-updates):
LeftGroup:AddDropdown("Target", {
    Text                = "Target",
    SpecialType         = "Player",
    ExcludeLocalPlayer  = true,
    Callback            = function(val) end,
})

print(Options.MyDrop.Value)
```

---

### Button

Triggers a function on click. Supports a nested sub-button.

**Args**
- `Text` String
- `Func` Function — called on click
- `DoubleClick` Boolean *(optional)* — require double-click (useful for sub-buttons)
- `Tooltip` String *(optional)*

**Methods**
```lua
MyButton:SetText("New Label")
MyButton:SetDisabled(true)
MyButton:SetVisible(false)
```

**Usage**
```lua
local MyButton = LeftGroup:AddButton({
    Text = "Do Something",
    Func = function()
        print("Clicked!")
    end,
})

-- Sub-button (indented below the parent):
MyButton:AddButton({
    Text        = "Confirm Action",
    Func        = function() print("Confirmed") end,
    DoubleClick = true,
})
```

---

### Input

A text input field. Stored in `Library.Options`.

**Args**
- `Index` String
- `Text` String — label
- `Default` String — initial text
- `Numeric` Boolean — only allow numbers
- `Finished` Boolean — fire Callback only on Enter (vs. every keystroke)
- `Placeholder` String — hint text when empty
- `ClearTextOnFocus` Boolean *(optional, default true)*
- `AllowEmpty` Boolean *(optional, default true)*
- `Disabled` Boolean *(optional)*
- `Tooltip` String *(optional)*
- `Callback` Function — receives `(value: string)`

**Methods**
```lua
Options.MyInput:SetValue("new text")   -- set the text
Options.MyInput:SetDisabled(true)      -- block editing
Options.MyInput:SetVisible(false)
Options.MyInput:OnChanged(function(val) print(val) end)
```

**Usage**
```lua
LeftGroup:AddInput("MyInput", {
    Text        = "Player Name",
    Default     = "",
    Numeric     = false,
    Finished    = true,
    Placeholder = "Enter name...",
    Callback    = function(val) print(val) end,
})

print(Options.MyInput.Value)
```

---

### Label

A plain text label row. Primarily used as a prefix for addon elements.

**Args**
- `Text` String

**Methods**
```lua
MyLabel:SetText("Updated text")
```

**Usage**
```lua
LeftGroup:AddLabel("This is a label")

-- Labels are used as a prefix to chain addons:
LeftGroup:AddLabel("Keybind"):AddKeyPicker("MyBind", { ... })
LeftGroup:AddLabel("Color"):AddColorPicker("MyColor", { ... })
```

---

### Divider

A horizontal separator line.

**Usage**
```lua
LeftGroup:AddDivider()
```

---

### Blank

An invisible spacer row.

**Usage**
```lua
LeftGroup:AddBlank()
```

---

### ColorPicker (Addon)

Chained onto a Toggle or Label. Supports solid colors and gradients. Stored in `Library.Options`.

**Args**
- `Index` String
- `Default` Color3 or ColorSequence
- `Title` String — popup title
- `Transparency` Number *(optional)* — 0–1 initial transparency, enables transparency slider
- `AllowGradient` Boolean *(optional)* — enable gradient editing
- `Disabled` Boolean *(optional)*
- `Callback` Function — receives `(color: Color3)` or `(sequence: ColorSequence)` for gradients

**Methods**
```lua
Options.MyColor:SetValueRGB(Color3.fromRGB(255, 0, 0))   -- set by Color3
Options.MyColor:SetValue(Color3.fromRGB(255, 0, 0))      -- same
Options.MyColor:SetDisabled(true)
Options.MyColor:Show()     -- open the color picker popup
Options.MyColor:Hide()     -- close the popup
Options.MyColor:OnChanged(function(val) print(val) end)
```

**Usage**
```lua
-- Solid color chained onto a Toggle:
LeftGroup:AddToggle("GlowToggle", {
    Text = "Glow", Default = false,
}):AddColorPicker("GlowColor", {
    Default      = Color3.fromRGB(255, 80, 80),
    Title        = "Glow Color",
    Transparency = 0,
    Callback     = function(val) print(val) end,
})

-- Chained onto a Label:
RightGroup:AddLabel("Outline"):AddColorPicker("OutlineColor", {
    Default  = Color3.fromRGB(100, 180, 255),
    Title    = "Outline Color",
    Callback = function(val) end,
})

-- Gradient (use ColorSequence as Default, set AllowGradient = true):
RightGroup:AddLabel("Gradient"):AddColorPicker("GradColor", {
    Default = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Color3.fromRGB(255, 80, 80)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(80, 255, 80)),
        ColorSequenceKeypoint.new(1,   Color3.fromRGB(80, 80, 255)),
    }),
    Title         = "Gradient",
    AllowGradient = true,
    Callback      = function(val) print(val) end,
})

-- Gradient controls:
-- Left-click empty bar area → add stop
-- Left-click + drag a stop → move it
-- Right-click a stop (when 3+ stops exist) → remove it

print(Options.GlowColor.Value)
Options.GlowColor:SetValueRGB(Color3.fromRGB(0, 255, 0))
```

---

### KeyPicker (Addon)

Chained onto a Label. Lets the user bind a key or mouse button. Stored in `Library.Options`.

**Args**
- `Index` String
- `Default` String — key name e.g. `"F"`, `"MB2"`, `"LeftShift"`, `"RightShift"`
- `Mode` String — `"Toggle"` | `"Hold"`
- `Text` String — shown in the keybind list popup
- `NoUI` Boolean — hide from the keybind list
- `Tooltip` String *(optional)*
- `Callback` Function — receives `(active: boolean)`

**Methods**
```lua
Options.MyBind:SetValue("G")           -- change the bound key
Options.MyBind:GetState()              -- returns true if currently active
Options.MyBind:SetModePickerVisibility(false)  -- hide the toggle/hold mode picker
Options.MyBind:OnChanged(function(val) print(val) end)
Options.MyBind:OnClick(function() print("key clicked") end)
Options.MyBind:DoClick()              -- programmatically fire the click
```

**Usage**
```lua
LeftGroup:AddLabel("Fly"):AddKeyPicker("FlyBind", {
    Default  = "F",
    Mode     = "Toggle",
    Text     = "Fly",
    NoUI     = false,
    Callback = function(val)
        print("Fly active:", val)
    end,
})

print(Options.FlyBind.Value)    -- current bound key string
Options.FlyBind:GetState()      -- true/false (active state)
```

---

### DependencyBox

A container that shows/hides based on element values. Elements inside are hidden when the condition is false.

**Usage**
```lua
LeftGroup:AddToggle("EnableAdv", { Text = "Enable Advanced", Default = false })

local DepBox = LeftGroup:AddDependencyBox()

DepBox:AddSlider("AdvStr", {
    Text = "Strength", Default = 50, Min = 0, Max = 100, Rounding = 0,
})

DepBox:AddDropdown("AdvMode", {
    Text = "Mode", Values = { "Mode A", "Mode B", "Mode C" }, Default = 1,
})

-- Visible only when EnableAdv == true:
DepBox:SetupDependencies({ { Toggles.EnableAdv, true } })

-- Multiple conditions (ALL must match):
DepBox:SetupDependencies({
    { Toggles.EnableAdv, true },
    { Options.AdvMode, "Mode B" },
})

-- Nested dep box (visible only when AdvMode == "Mode B"):
local SubDep = DepBox:AddDependencyBox()
SubDep:AddToggle("SubOpt", { Text = "Sub Option", Default = false })
SubDep:SetupDependencies({ { Options.AdvMode, "Mode B" } })
```

---

### Dialog

A modal popup window with a title, description, and footer buttons. Created from the Window object.

**Args**
- `Idx` String — unique key to reference the dialog later
- `Info` Table:
  - `Title` String
  - `Description` String
  - `TitleColor` Color3 *(optional)*
  - `DescriptionColor` Color3 *(optional)*
  - `OutsideClickDismiss` Boolean *(optional)* — close when clicking outside

**Methods**
```lua
Dialog:Dismiss()

Dialog:SetTitle("New Title")
Dialog:SetDescription("New description")

Dialog:AddFooterButton("Confirm", {
    Title       = "Confirm",
    Variant     = "Primary",     -- "Primary" | "Secondary" | "Destructive" | "Ghost"
    WaitTime    = 0,             -- seconds before button becomes clickable
    Order       = 0,
    Func        = function() Dialog:Dismiss() end,
})

Dialog:RemoveFooterButton("Confirm")
Dialog:SetButtonDisabled("Confirm", true)
Dialog:SetButtonOrder("Confirm", 2)

-- Add UI elements inside the dialog body:
Dialog:AddToggle("DialogToggle", { Text = "Accept Terms", Default = false })
Dialog:AddInput("DialogInput", { Text = "Reason", Default = "" })
```

**Usage**
```lua
local Dlg = Window:AddDialog("ConfirmDlg", {
    Title               = "Confirm Action",
    Description         = "Are you sure you want to proceed?",
    OutsideClickDismiss = true,
})

Dlg:AddFooterButton("Cancel", {
    Title   = "Cancel",
    Variant = "Secondary",
    Func    = function() Dlg:Dismiss() end,
})

Dlg:AddFooterButton("Confirm", {
    Title   = "Confirm",
    Variant = "Primary",
    Func    = function()
        print("Confirmed!")
        Dlg:Dismiss()
    end,
})

Dlg:Resize()
```

---

### Notifications

Toast messages that appear on-screen. Position and style come from MenuManager's Notifications tab.

**Args (table form)**
- `Title` String *(optional)*
- `Description` String
- `Time` Number — seconds before auto-dismiss (default `5`)
- `Icon` String *(optional)* — asset ID or icon name
- `IconColor` Color3 *(optional)*
- `SoundId` String *(optional)*
- `Persist` Boolean *(optional)* — never auto-dismiss
- `Steps` any *(optional)* — internal progress tracking

**Usage**
```lua
-- Full table form:
Library:Notify({
    Title       = "Alert",
    Description = "Something happened.",
    Time        = 5,
    Icon        = "rbxassetid://12345",
})

-- Shorthand (message, duration):
Library:Notify("Quick message", 3)
```

---

### Draggable Label

A floating draggable text overlay — recommended over `SetWatermark` for new scripts.

**Methods**
```lua
local Label = Library:AddDraggableLabel("My Script | FPS")

Label:SetText("My Script | 60 fps")
Label:SetVisible(false)
Label:Destroy()
```

**Usage**
```lua
local FpsLabel = Library:AddDraggableLabel("My Script")

local FrameTimer = tick()
local FrameCount = 0
local FPS = 60

game:GetService("RunService").RenderStepped:Connect(function()
    FrameCount += 1
    if tick() - FrameTimer >= 1 then
        FPS        = FrameCount
        FrameTimer = tick()
        FrameCount = 0
    end
    FpsLabel:SetText(("My Script | %d fps"):format(math.floor(FPS)))
end)
```

---

### Watermark *(deprecated — use AddDraggableLabel)*

```lua
Library:SetWatermarkVisibility(true)
Library:SetWatermark("My Script | 60 fps")
```

---

### MenuManager

Adds a built-in UI Settings tab with cursor, controller, and notification controls.

**Usage**
```lua
-- Always build before ThemeManager/SaveManager:
MenuManager:SetLibrary(Library)
MenuManager:BuildMenuSection(Tabs.UISettings)

-- Add custom elements after building:
MenuManager.MenuTab:AddDivider()
MenuManager.MenuTab:AddToggle("MyOption", { Text = "Option", Default = false })
```

**Globals after BuildMenuSection**
- `MenuManager.MenuTab` — the Menu tab groupbox (cursor, controller, keybind)
- `MenuManager.NotifTab` — the Notifications tab groupbox
- `MenuManager.TabBox` — the tabbox containing both

---

### ThemeManager

Color theme selector and customisation UI.

**Usage**
```lua
ThemeManager:SetLibrary(Library)
ThemeManager:SetFolder("MyScriptHub")     -- folder name for saved themes
ThemeManager:ApplyToTab(Tabs.UISettings)  -- builds the UI into this tab
```

---

### SaveManager

Saves and loads element configs per-game.

**Usage**
```lua
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()                            -- don't save theme in config
SaveManager:SetIgnoreIndexes({ "MenuBind", "LanguageSelect" }) -- skip these element keys
SaveManager:SetFolder("MyScriptHub/game-name")
SaveManager:BuildConfigSection(Tabs.UISettings)
```

---

### Language System

Translates every UI element at runtime without reloading.

---

#### SetupLanguage

Register a translation table. Multiple calls for the same code **merge** (additive).

**Args**
- `langCode` String — e.g. `"es"`, `"fr"`, `"de"`
- `translations` Table

**Translation format**
```lua
-- Element by Index key:
MyToggle    = { Text = "Translated label" }
MyDropdown  = { Text = "Translated label", Values = { "Option 1", "Option 2" } }

-- Registered label key (tabs, groupboxes — see RegisterLabel):
Tab_Main    = "Principal"
```

**Usage**
```lua
Library:SetupLanguage("es", {
    MyToggle  = { Text = "Palanca" },
    MySlider  = { Text = "Deslizador" },
    MyDrop    = { Text = "Lista", Values = { "Alfa", "Beta", "Gamma" } },
    Tab_Main  = "Principal",
    Group_Controls = "Controles",
})
```

---

#### SetLanguage

Switch the active language. Pass `nil` to restore original text.

```lua
Library:SetLanguage("es")
Library:SetLanguage("fr")
Library:SetLanguage(nil)   -- restore defaults
```

---

#### RegisterLabel

Register a UI text instance under a key so SetupLanguage can update it.

**Args**
- `key` String — matches a key in translation tables
- `instance` TextLabel
- `applyFn` Function *(optional)* — called with new text; required for tabs/subtabs so the button frame resizes

```lua
-- Tabs (need applyFn to resize the button frame):
Library:RegisterLabel("Tab_Main", Tabs.Main.ButtonLabel,
    function(t) Tabs.Main:SetName(t) end)
Library:RegisterLabel("Tab_UI", Tabs.UISettings.ButtonLabel,
    function(t) Tabs.UISettings:SetName(t) end)

-- SubTabs:
Library:RegisterLabel("Sub_Elements", SubTabs.Elements.ButtonLabel,
    function(t) SubTabs.Elements:SetName(t) end)

-- Groupboxes (full-width, no resize needed):
Library:RegisterLabel("Group_Controls", LeftGroup.TitleLabel)
Library:RegisterLabel("Group_Colors",   RightGroup.TitleLabel)
```

---

#### Full Language Example

```lua
-- 1. Register labels after creating tabs/groups
Library:RegisterLabel("Tab_Main",     Tabs.Main.ButtonLabel,       function(t) Tabs.Main:SetName(t) end)
Library:RegisterLabel("Sub_Elements", SubTabs.Elements.ButtonLabel, function(t) SubTabs.Elements:SetName(t) end)
Library:RegisterLabel("Group_Ctrl",   LeftGroup.TitleLabel)

-- 2. Define translations
Library:SetupLanguage("es", {
    Tab_Main     = "Principal",
    Sub_Elements = "Elementos",
    Group_Ctrl   = "Controles",
    MyToggle     = { Text = "Palanca" },
    MySlider     = { Text = "Deslizador" },
    MyDrop       = { Text = "Lista", Values = { "Alfa", "Beta", "Gamma" } },
})

-- 3. Language picker (inside MenuManager.MenuTab)
MenuManager.MenuTab:AddDivider()
MenuManager.MenuTab:AddDropdown("LanguageSelect", {
    Text    = "Language",
    Values  = { "English", "Español", "Français" },
    Default = 1,
    Callback = function(val)
        if val == "Español" then
            Library:SetLanguage("es")
        elseif val == "Français" then
            Library:SetLanguage("fr")
        else
            Library:SetLanguage(nil)
        end
    end,
})
```

---

### Full Script Template

```lua
local repo         = "https://raw.githubusercontent.com/SoNotClose/SnowFallV2/main/"
local Library      = loadstring(game:HttpGet(repo .. "Library.lua"))()
local MenuManager  = loadstring(game:HttpGet(repo .. "addons/MenuManager.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager  = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Options = Library.Options
local Toggles = Library.Toggles

local Window = Library:CreateWindow({
    Title        = "My Script",
    SubTitle     = "v1.0",
    Center       = true,
    AutoShow     = true,
    Resizable    = true,
    NotifySide   = "Right",
    TabPadding   = 8,
    MenuFadeTime = 0.2,
})

local Tabs = {
    Main       = Window:AddTab("Main"),
    UISettings = Window:AddTab("UI Settings"),
}

local SubTabs = {
    Features = Tabs.Main:AddTab("Features"),
    Info     = Tabs.Main:AddTab("Info"),
}

local LeftGroup  = SubTabs.Features:AddLeftGroupbox("Controls")
local RightGroup = SubTabs.Features:AddRightGroupbox("Colors")

-- Toggle
LeftGroup:AddToggle("MyToggle", {
    Text     = "Enable Feature",
    Default  = false,
    Callback = function(val) print("Toggle:", val) end,
})

-- Slider
LeftGroup:AddSlider("MySlider", {
    Text = "Speed", Default = 50, Min = 0, Max = 200, Rounding = 0,
    Callback = function(val) print("Speed:", val) end,
})

-- Dropdown
LeftGroup:AddDropdown("MyDrop", {
    Text = "Mode", Values = { "Mode A", "Mode B" }, Default = 1,
    Callback = function(val) print("Mode:", val) end,
})

-- Button
LeftGroup:AddButton({
    Text = "Fire",
    Func = function() print("Fired!") end,
})

-- Input
LeftGroup:AddInput("MyInput", {
    Text = "Name", Default = "", Placeholder = "Enter...",
    Callback = function(val) print("Input:", val) end,
})

-- Keybind
LeftGroup:AddLabel("Fly"):AddKeyPicker("FlyBind", {
    Default = "F", Mode = "Toggle", Text = "Fly",
    Callback = function(val) print("Fly:", val) end,
})

-- Color picker
RightGroup:AddLabel("Color"):AddColorPicker("MyColor", {
    Default = Color3.fromRGB(255, 80, 80), Title = "Feature Color",
    Callback = function(val) print("Color:", val) end,
})

-- Draggable label (FPS counter)
local FpsLabel = Library:AddDraggableLabel("My Script")
local _ft, _fc, _fps = tick(), 0, 60
game:GetService("RunService").RenderStepped:Connect(function()
    _fc += 1
    if tick() - _ft >= 1 then _fps = _fc _ft = tick() _fc = 0 end
    FpsLabel:SetText(("My Script | %d fps"):format(math.floor(_fps)))
end)

-- Unload
Library:OnUnload(function()
    Library.Unloaded = true
end)

-- ===== Addons (always in this order) =====
MenuManager:SetLibrary(Library)
MenuManager:BuildMenuSection(Tabs.UISettings)

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuBind", "LanguageSelect" })
ThemeManager:SetFolder("MyScriptHub")
SaveManager:SetFolder("MyScriptHub/game-name")

SaveManager:BuildConfigSection(Tabs.UISettings)
ThemeManager:ApplyToTab(Tabs.UISettings)

-- ===== Language (optional) =====
Library:RegisterLabel("Tab_Main",      Tabs.Main.ButtonLabel,        function(t) Tabs.Main:SetName(t) end)
Library:RegisterLabel("Tab_UI",        Tabs.UISettings.ButtonLabel,  function(t) Tabs.UISettings:SetName(t) end)
Library:RegisterLabel("Sub_Features",  SubTabs.Features.ButtonLabel, function(t) SubTabs.Features:SetName(t) end)
Library:RegisterLabel("Group_Ctrl",    LeftGroup.TitleLabel)
Library:RegisterLabel("Group_Colors",  RightGroup.TitleLabel)

Library:SetupLanguage("es", {
    Tab_Main     = "Principal",
    Tab_UI       = "Configuración",
    Sub_Features = "Funciones",
    Group_Ctrl   = "Controles",
    Group_Colors = "Colores",
    MyToggle     = { Text = "Activar función" },
    MySlider     = { Text = "Velocidad" },
    MyDrop       = { Text = "Modo", Values = { "Modo A", "Modo B" } },
})

MenuManager.MenuTab:AddDivider()
MenuManager.MenuTab:AddDropdown("LanguageSelect", {
    Text    = "Language",
    Values  = { "English", "Español" },
    Default = 1,
    Callback = function(val)
        Library:SetLanguage(val == "Español" and "es" or nil)
    end,
})
```
