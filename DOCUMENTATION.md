## SNOWFALLS DOCUMENTATION

---

### Setup

Load the library and addons at the top of your script.

```lua
local repo = "https://raw.githubusercontent.com/SoNotClose/SnowFallV2/main/"
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
- Title: String — main title shown in the header
- SubTitle: String *(optional)* — smaller text displayed below the title, same side as Title
- GameTitle: String *(optional)* — secondary label on the opposite side of the header (e.g. game name)
- TitleSide: String *(optional)* — side the title aligns to: `"Left"` (default), `"Right"`, `"Middle"`
- GameSide: String *(optional)* — side GameTitle aligns to: `"Right"` (default), `"Left"`, `"Middle"`
- Center: Boolean — spawn the window in the center of the screen
- AutoShow: Boolean — show UI immediately on creation
- Resizable: Boolean — allow the user to resize the window
- Size: UDim2 *(optional)* — starting window size (defaults to 550×600)
- Position: UDim2 *(optional)* — starting position (overridden when Center is true)
- AnchorPoint: Vector2 *(optional)* — anchor point for the window frame
- NotifySide: String — default notification side: `"Left"`, `"Right"`, `"Middle"`
- TabPadding: Number — pixel spacing between tab buttons
- MenuFadeTime: Number — fade animation duration in seconds
- ShowCustomCursor: Boolean — show the library's custom cursor
- UnlockMouseWhileOpen: Boolean — unlock the mouse when the UI is open
- BackgroundImage: String *(optional)* — asset ID to display as a background image behind the UI

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
    BackgroundImage      = "rbxassetid://0",
})
```

---

### Library Properties

These are set directly on the `Library` table before or after creating the window.

**Controller Support**
- `Library.ControllerSupport` — Boolean, enable gamepad/controller navigation (default `false`)
- `Library.ControllerNavType` — `"Dpad"` or `"Joystick"` — how the controller navigates the UI
- `Library.ControllerNavSensitivity` — Number — joystick navigation sensitivity (default `5`)

**Tab Sizing**
- `Library.IgnoreTabSizes` — Boolean — force all tabs to the same width (default `false`)
- `Library.TabSize` — Number — minimum tab width multiplier used when `IgnoreTabSizes` is true (default `5`)
- `Library.IgnoreLimit` — Number — max tabs shown before the tab bar scrolls (default `6`)

**Misc**
- `Library.LowercaseMode` — Boolean — render all UI text in lowercase (default `false`)
- `Library.MenuMark` — Boolean — show a draggable script-name watermark in the corner (default `false`)
- `Library.SafeMode` — Boolean — extra safety checks for unstable environments (default `false`)

**Usage**
```lua
Library.ControllerSupport      = true
Library.ControllerNavType      = "Dpad"
Library.ControllerNavSensitivity = 5

Library.IgnoreTabSizes = true
Library.TabSize        = 6

Library.LowercaseMode = true
Library.MenuMark      = true
```

---

### Tabs

Tabs are the main way to separate each section of your UI. The order is determined by the order in which `Window:AddTab()` is called.

**Args**
- Name: String

**Usage**
```lua
local Tabs = {
    Main       = Window:AddTab("Main"),
    UISettings = Window:AddTab("UI Settings"),
}
```

---

### SubTabs

SubTabs split a Tab into multiple nested sections rendered as a secondary tab bar inside the tab. The order is determined by the order `Tab:AddTab()` is called.

**Args**
- Name: String

**Usage**
```lua
local SubTabs = {
    Elements = Tabs.Main:AddTab("Elements"),
    Features = Tabs.Main:AddTab("Features"),
}
```

---

### Groupboxes

Groupboxes are containers that hold UI elements. Each tab (or subtab) has a left and right column.

**Args**
- Name: String — the title displayed at the top of the groupbox

**Usage**
```lua
local LeftGroup  = Tabs.Main:AddLeftGroupbox("Controls")
local RightGroup = Tabs.Main:AddRightGroupbox("Info")

-- Inside a SubTab:
local SubLeft  = SubTabs.Elements:AddLeftGroupbox("Controls")
local SubRight = SubTabs.Elements:AddRightGroupbox("Color Pickers")
```

---

### Tabbox

A Tabbox is a mini tab strip embedded inside a groupbox. Use it when you want to further split a single column into tabbed sections.

**Args**
- (none — Tabbox is created from a groupbox)

**Tab Args**
- Name: String

**Usage**
```lua
local MyTabbox = LeftGroup:AddTabbox()
local BoxTab1  = MyTabbox:AddTab("Section A")
local BoxTab2  = MyTabbox:AddTab("Section B")

-- Add elements directly to the tabbox tab:
BoxTab1:AddToggle("TabToggle", { Text = "Option" })
```

---

### Toggle

A Toggle is an on/off switch. It is stored in `Library.Toggles` by its index key.

**Args**
- Index: String — unique key used to access via `Toggles.MyKey`
- Text: String — label shown next to the toggle
- Default: Boolean — starting state
- Tooltip: String *(optional)* — hover description
- Callback: Function — called with the new value when changed

**Usage**
```lua
LeftGroup:AddToggle("MyToggle", {
    Text     = "Enable Feature",
    Default  = false,
    Tooltip  = "Turns the feature on or off",
    Callback = function(val)
        print("Toggle is now:", val)
    end,
})

-- Read value anywhere:
print(Toggles.MyToggle.Value)

-- Set value programmatically:
Toggles.MyToggle:SetValue(true)
```

---

### Slider

A Slider lets the user pick a number within a range. Stored in `Library.Options`.

**Args**
- Index: String
- Text: String
- Default: Number — starting value
- Min: Number — minimum value
- Max: Number — maximum value
- Rounding: Number — decimal places (0 = integers)
- Compact: Boolean *(optional)* — smaller inline style for sub-slider pairs
- Tooltip: String *(optional)*
- Callback: Function

**Usage**
```lua
LeftGroup:AddSlider("MySlider", {
    Text     = "Speed",
    Default  = 50,
    Min      = 0,
    Max      = 200,
    Rounding = 0,
    Callback = function(val)
        print("Speed:", val)
    end,
})

-- Read value:
print(Options.MySlider.Value)

-- Set value:
Options.MySlider:SetValue(100)
```

**Sub-Sliders** — chain two sliders side-by-side on one row:
```lua
LeftGroup:AddSlider("SliderWidth", {
    Text = "Width", Default = 50, Min = 0, Max = 100, Rounding = 0,
}):AddSlider("SliderHeight", {
    Text = "Height", Default = 50, Min = 0, Max = 100, Rounding = 0,
})

-- Compact style for very short labels:
LeftGroup:AddSlider("PosX", {
    Text = "X", Default = 0, Min = -100, Max = 100, Rounding = 1, Compact = true,
}):AddSlider("PosY", {
    Text = "Y", Default = 0, Min = -100, Max = 100, Rounding = 1, Compact = true,
})
```

---

### Dropdown

A Dropdown lets the user select one or more values from a list. Stored in `Library.Options`.

**Args**
- Index: String
- Text: String
- Values: Table — list of string options
- Default: Number — index of the default selected item (1-based)
- Multi: Boolean *(optional)* — allow multiple selections
- Searchable: Boolean *(optional)* — shows a search box inside the dropdown
- SpecialType: String *(optional)* — `"Player"` auto-populates with current players
- ExcludeLocalPlayer: Boolean *(optional)* — used with `SpecialType = "Player"`
- Tooltip: String *(optional)*
- Callback: Function

**Usage**
```lua
-- Single select:
LeftGroup:AddDropdown("MyDropdown", {
    Text     = "Choose Mode",
    Values   = { "Mode A", "Mode B", "Mode C" },
    Default  = 1,
    Callback = function(val)
        print("Selected:", val)
    end,
})

-- Multi-select:
LeftGroup:AddDropdown("MyMultiDrop", {
    Text   = "Pick Colors",
    Values = { "Red", "Green", "Blue" },
    Default = 1,
    Multi  = true,
    Callback = function()
        print("Selection changed")
    end,
})

-- Searchable:
LeftGroup:AddDropdown("MySearchDrop", {
    Text       = "Find Item",
    Values     = { "Apple", "Banana", "Cherry", "Date" },
    Default    = 1,
    Searchable = true,
    Callback   = function(val) print(val) end,
})

-- Player list:
LeftGroup:AddDropdown("PlayerSelect", {
    Text                = "Target Player",
    SpecialType         = "Player",
    ExcludeLocalPlayer  = false,
    Callback            = function(val) print(val) end,
})

-- Read value:
print(Options.MyDropdown.Value)

-- Set value:
Options.MyDropdown:SetValue("Mode B")

-- Update list at runtime:
Options.MyDropdown:SetValues({ "New A", "New B" })
```

---

### Button

A Button triggers a function when clicked. Supports a nested Sub Button.

**Args**
- Text: String
- Func: Function — called on click
- DoubleClick: Boolean *(optional)* — require double-click to fire (for Sub Buttons)

**Usage**
```lua
local MyButton = LeftGroup:AddButton({
    Text = "Do Something",
    Func = function()
        print("Clicked!")
    end,
})

-- Sub Button (appears indented below the parent):
MyButton:AddButton({
    Text        = "Dangerous Action",
    Func        = function() print("Sub clicked!") end,
    DoubleClick = true,
})
```

---

### Input

A text Input field. Stored in `Library.Options`.

**Args**
- Index: String
- Text: String — label
- Default: String — initial text
- Numeric: Boolean — only allow number input
- Finished: Boolean — fire Callback only when Enter is pressed (vs every keystroke)
- Placeholder: String — grey hint text shown when empty
- Tooltip: String *(optional)*
- Callback: Function

**Usage**
```lua
LeftGroup:AddInput("MyInput", {
    Text        = "Player Name",
    Default     = "",
    Numeric     = false,
    Finished    = true,
    Placeholder = "Enter name...",
    Callback    = function(val)
        print("Input:", val)
    end,
})

-- Read value:
print(Options.MyInput.Value)
```

---

### Label

A plain text label row. Can have addons chained onto it (ColorPicker, KeyPicker).

**Args**
- Text: String

**Usage**
```lua
LeftGroup:AddLabel("This is a label")

-- Labels are commonly used as a prefix for addon elements:
LeftGroup:AddLabel("Keybind"):AddKeyPicker("MyBind", { ... })
LeftGroup:AddLabel("Color"):AddColorPicker("MyColor", { ... })
```

---

### Divider

A horizontal line used to visually separate groups of elements.

**Args**
- (none)

**Usage**
```lua
LeftGroup:AddDivider()
```

---

### Blank

An invisible spacer row that adds vertical padding.

**Args**
- (none)

**Usage**
```lua
LeftGroup:AddBlank()
```

---

### ColorPicker (Addon)

A ColorPicker is chained onto a Toggle or Label. Supports solid colors and optional gradient mode. Stored in `Library.Options`.

**Args**
- Index: String
- Default: Color3 or ColorSequence — starting color (use ColorSequence for gradients)
- Title: String — popup window title
- Transparency: Number — 0 to 1 initial transparency
- AllowGradient: Boolean *(optional)* — enable gradient editing mode
- Tooltip: String *(optional)*
- Callback: Function — called with Color3 (or ColorSequence for gradients)

**Usage**
```lua
-- Chained onto a Toggle:
LeftGroup:AddToggle("GlowToggle", {
    Text = "Glow",
    Default = false,
}):AddColorPicker("GlowColor", {
    Default      = Color3.fromRGB(255, 80, 80),
    Title        = "Glow Color",
    Transparency = 0,
    Callback     = function(val)
        print("Color:", val)
    end,
})

-- Chained onto a Label:
RightGroup:AddLabel("Outline Color"):AddColorPicker("OutlineColor", {
    Default = Color3.fromRGB(100, 180, 255),
    Title   = "Outline Color",
    Callback = function(val) end,
})

-- Gradient color picker:
RightGroup:AddLabel("Gradient"):AddColorPicker("GradColor", {
    Default = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Color3.fromRGB(255, 80, 80)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(80, 255, 80)),
        ColorSequenceKeypoint.new(1,   Color3.fromRGB(80, 80, 255)),
    }),
    Title         = "Gradient Color",
    AllowGradient = true,
    Callback      = function(val) print("Gradient:", val) end,
})

-- Read value:
print(Options.GlowColor.Value)

-- Set value:
Options.GlowColor:SetValueRGB(Color3.fromRGB(0, 255, 0))
```

---

### KeyPicker (Addon)

A KeyPicker is chained onto a Label. Lets the user bind a key or mouse button to a feature. Stored in `Library.Options`.

**Args**
- Index: String
- Default: String — key name (e.g. `"F"`, `"MB2"`, `"LeftShift"`)
- Mode: String — `"Toggle"` (press to flip state) or `"Hold"` (active while held)
- Text: String — label shown in the keybind list UI
- NoUI: Boolean — hide from the keybind list if true
- Tooltip: String *(optional)*
- Callback: Function — called with the current active state (boolean)

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

-- Read state:
print(Options.FlyBind.Value)
```

---

### DependencyBox

A DependencyBox is a container that is only visible when specified elements match expected values. Elements inside will be hidden automatically when the condition is false.

**Args**
- (none — created from a groupbox)

**SetupDependencies Args**
- Conditions: Table — array of `{ element, expectedValue }` pairs (all must match)

**Usage**
```lua
RightGroup:AddToggle("EnableAdvanced", {
    Text    = "Enable Advanced",
    Default = false,
})

local DepBox = RightGroup:AddDependencyBox()

DepBox:AddSlider("AdvStrength", {
    Text = "Strength", Default = 50, Min = 0, Max = 100, Rounding = 0,
})

DepBox:AddDropdown("AdvMode", {
    Text    = "Mode",
    Values  = { "Mode A", "Mode B", "Mode C" },
    Default = 1,
})

-- Show DepBox only when EnableAdvanced == true:
DepBox:SetupDependencies({ { Toggles.EnableAdvanced, true } })

-- Nested dependency (visible only when AdvMode == "Mode B"):
local SubDep = DepBox:AddDependencyBox()
SubDep:AddToggle("SubOption", { Text = "Sub Option", Default = false })
SubDep:SetupDependencies({ { Options.AdvMode, "Mode B" } })
```

---

### Watermark

A small text overlay displayed in a corner of the screen, commonly used for FPS or script name.

**Usage**
```lua
-- Show/hide:
Library:SetWatermarkVisibility(true)

-- Update text (call every frame for live FPS):
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
    Library:SetWatermark(("MyScript | %d fps"):format(math.floor(FPS)))
end)
```

---

### Notifications

Popup toast messages displayed on-screen. Position and style are configured via MenuManager's notification settings.

**Usage**
```lua
-- Full options:
Library:Notify({
    Title       = "Alert",
    Description = "Something happened.",
    Time        = 5,
})

-- Shorthand (message, duration):
Library:Notify("Quick message", 3)
```

---

### OnUnload

Register a cleanup callback that runs when the UI is destroyed or the script is unloaded.

**Usage**
```lua
Library:OnUnload(function()
    Library.Unloaded = true
    -- stop loops, disconnect events, etc.
    print("UI unloaded")
end)
```

---

### MenuManager

MenuManager adds a built-in UI Settings tab containing controls for theme, keybind list, notification position, window opacity, and more.

**Usage**
```lua
-- Always build MenuManager first before ThemeManager/SaveManager:
MenuManager:SetLibrary(Library)
MenuManager:BuildMenuSection(Tabs.UISettings)

-- After BuildMenuSection you can add custom elements to the menu tab:
MenuManager.MenuTab:AddDivider()
MenuManager.MenuTab:AddToggle("MyMenuOption", { Text = "Option", Default = false })
```

**Available globals after BuildMenuSection**
- `MenuManager.MenuTab` — the main settings groupbox
- `MenuManager.NotifTab` — the notification settings groupbox
- `MenuManager.TabBox` — the tabbox containing MenuTab and NotifTab

---

### ThemeManager

ThemeManager provides a theme selector and color customisation UI. Must be set up after MenuManager.

**Usage**
```lua
ThemeManager:SetLibrary(Library)
ThemeManager:SetFolder("MyScriptHub")       -- folder name for saved themes
ThemeManager:ApplyToTab(Tabs.UISettings)    -- renders into this tab
```

---

### SaveManager

SaveManager handles saving and loading config files per-game. Must be set up after MenuManager and ThemeManager.

**Usage**
```lua
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()           -- don't save theme in config files
SaveManager:SetIgnoreIndexes({ "MenuBind", "LanguageSelect" })  -- skip these keys
SaveManager:SetFolder("MyScriptHub/game-name")
SaveManager:BuildConfigSection(Tabs.UISettings)
```

---

### Language System

The language system lets you translate every UI element (toggles, sliders, dropdowns, labels, groupbox titles, tab names) at runtime.

---

#### SetupLanguage

Register a translation table for a language code. Can be called multiple times for the same code — entries are merged, not replaced.

**Args**
- langCode: String — short code like `"es"`, `"fr"`, `"de"`
- translations: Table — keys map to element indexes or registered label keys

**Element translation format**
```lua
MyToggleIndex  = { Text = "Translated Label" }
MyDropdownIndex = { Text = "Translated Label", Values = { "Option 1", "Option 2" } }
```

**Usage**
```lua
Library:SetupLanguage("es", {
    -- Elements (by their Index string):
    MyToggle  = { Text = "Palanca" },
    MySlider  = { Text = "Deslizador" },
    MyDrop    = { Text = "Lista", Values = { "Alfa", "Beta", "Gamma" } },

    -- Registered label keys (see RegisterLabel):
    Tab_Main       = "Principal",
    Group_Controls = "Controles",
})
```

---

#### SetLanguage

Switch the active language. Pass `nil` to restore original English text.

**Args**
- langCode: String or nil

**Usage**
```lua
Library:SetLanguage("es")   -- switch to Spanish
Library:SetLanguage("fr")   -- switch to French
Library:SetLanguage(nil)    -- restore defaults
```

---

#### RegisterLabel

Register a UI text instance (tab button, groupbox title, etc.) under a key so it can be translated via `SetupLanguage`.

**Args**
- key: String — must match a key in your translation tables
- instance: TextLabel — the label whose `.Text` will be updated
- applyFn: Function *(optional)* — called with the new text string instead of setting `.Text` directly; required for tabs and subtabs so the button frame resizes

**Usage**
```lua
-- Tab buttons need applyFn so the frame resizes with the new text:
Library:RegisterLabel("Tab_Main",     Tabs.Main.ButtonLabel,       function(t) Tabs.Main:SetName(t) end)
Library:RegisterLabel("Tab_UI",       Tabs.UISettings.ButtonLabel, function(t) Tabs.UISettings:SetName(t) end)

-- SubTab buttons:
Library:RegisterLabel("SubTab_Elems", SubTabs.Elements.ButtonLabel, function(t) SubTabs.Elements:SetName(t) end)
Library:RegisterLabel("SubTab_Feats", SubTabs.Features.ButtonLabel, function(t) SubTabs.Features:SetName(t) end)

-- Groupbox titles are full-width so they don't need a resize callback:
Library:RegisterLabel("Group_Controls", ElemLeft.TitleLabel)
Library:RegisterLabel("Group_Colors",   ElemRight.TitleLabel)
```

---

#### Full Language Example

```lua
-- 1. Register all translatable labels after creating tabs/groups:
Library:RegisterLabel("Tab_Main",        Tabs.Main.ButtonLabel,        function(t) Tabs.Main:SetName(t) end)
Library:RegisterLabel("SubTab_Elements", SubTabs.Elements.ButtonLabel, function(t) SubTabs.Elements:SetName(t) end)
Library:RegisterLabel("Group_Controls",  ElemLeft.TitleLabel)

-- 2. Define translations:
Library:SetupLanguage("es", {
    Tab_Main         = "Principal",
    SubTab_Elements  = "Elementos",
    Group_Controls   = "Controles",
    MyToggle         = { Text = "Palanca" },
    MySlider         = { Text = "Deslizador" },
    MyDrop           = { Text = "Lista", Values = { "Alfa", "Beta", "Gamma" } },
})

-- 3. Add a language picker (e.g. inside MenuManager.MenuTab):
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
local repo        = "https://raw.githubusercontent.com/SoNotClose/SnowFallV2/main/"
local Library     = loadstring(game:HttpGet(repo .. "Library.lua"))()
local MenuManager = loadstring(game:HttpGet(repo .. "addons/MenuManager.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager  = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Options = Library.Options
local Toggles = Library.Toggles

local Window = Library:CreateWindow({
    Title        = "My Script",
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

local LeftGroup = Tabs.Main:AddLeftGroupbox("Controls")

LeftGroup:AddToggle("FeatureToggle", {
    Text     = "Enable Feature",
    Default  = false,
    Callback = function(val) print(val) end,
})

-- Watermark
Library:SetWatermarkVisibility(true)
Library:SetWatermark("My Script")

-- Unload handler
Library:OnUnload(function()
    Library.Unloaded = true
end)

-- Addons (always in this order)
MenuManager:SetLibrary(Library)
MenuManager:BuildMenuSection(Tabs.UISettings)

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuBind" })
ThemeManager:SetFolder("MyScriptHub")
SaveManager:SetFolder("MyScriptHub/game-name")

SaveManager:BuildConfigSection(Tabs.UISettings)
ThemeManager:ApplyToTab(Tabs.UISettings)
```


