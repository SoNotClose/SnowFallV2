## SNOWFALLS DOCUMENTATION

---

### Setup

```lua
local repo         = "https://raw.githubusercontent.com/SoNotClose/SnowFallV2/main/"
local Library      = loadstring(game:HttpGet(repo .. "Library.lua"))()
local MenuManager  = loadstring(game:HttpGet(repo .. "addons/MenuManager.lua"))()
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
- `Library.CursorColor` Color3 — cursor color (`nil` = follow AccentColor automatically)
- `Library.IconColor` Color3 — icon tint (`nil` = follow AccentColor automatically)
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
- `Library.IgnoreSubTabSizes` Boolean — uniform sub-tab widths (default `false`)

**Notifications**
- `Library.NotificationPositionX` Number 0–100 (default `50`)
- `Library.NotificationPositionY` Number 0–100 (default `50`)
- `Library.NotificationAlignment` String — `"Left"` | `"Right"` | `"Center"`
- `Library.NotificationBarSide` String — `"Left"` | `"Top"` | `"Right"` | `"Bottom"`
- `Library.NotificationAnimatedBar` Boolean — animated progress bar (top/bottom only, default `true`)
- `Library.NotificationForceColor` Boolean
- `Library.NotificationAccentColor` Color3
- `Library.NotificationOutlineColor` Color3
- `Library.NotificationFontColor` Color3
- `Library.LimitNotifications` Boolean
- `Library.MaximumNotifications` Number

**Panic System**
- `Library.AllowPanic` Boolean — when `true`, MenuManager shows the Panic toggle+keybind section (default `false`). Set automatically by `Library:PanicFuncs()` when at least one valid toggle is registered.
- `Library.PanicFunctions` Table *(read-only)* — list of Toggle objects registered for panic. Populated by `Library:PanicFuncs()`.

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
Library.AllowPanic        = true  -- or set via Library:PanicFuncs()
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

-- Destroy the library entirely
Library:Unload()

-- Disable all toggles registered via PanicFuncs. Safe no-op if list is empty.
Library:Panic()

-- Register toggle indices that Panic() will disable.
-- Automatically sets Library.AllowPanic = true if any valid toggle is found.
Library:PanicFuncs({ "MyFeature", "AnotherToggle" })
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

-- Switch tab from code:
Tabs.Main:ShowTab()
```

**Tab with icon**
```lua
-- Tabs support icons alongside the text label.
-- See the Icons section for all available icon names.
local Tabs = {
    Main  = Window:AddTab("Main",  "home"),
    Aim   = Window:AddTab("Aim",   "crosshair"),
    ESP   = Window:AddTab("ESP",   "eye"),
    Misc  = Window:AddTab("Misc",  "settings"),
}
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

-- Switch subtab from code:
SubTabs.Features:ShowTab()
```

**SubTab with icon**
```lua
local SubTabs = {
    Combat   = Tabs.Main:AddTab("Combat",   "sword"),
    Movement = Tabs.Main:AddTab("Movement", "run"),
}
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
-- or left-aligned tabbox:
local MyTabbox = LeftGroup:AddLeftTabbox()

local BoxTab1 = MyTabbox:AddTab("Section A")
local BoxTab2 = MyTabbox:AddTab("Section B")

-- Elements go directly on the tabbox tab:
BoxTab1:AddToggle("TabToggle", { Text = "Option", Default = false })
BoxTab2:AddSlider("TabSlider", { Text = "Speed", Default = 50, Min = 0, Max = 100, Rounding = 0 })
```

**Tabbox with icons**
```lua
local Box = LeftGroup:AddTabbox()
local TabA = Box:AddTab("Aimbot",  "crosshair")
local TabB = Box:AddTab("Visuals", "eye")
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
    Default = Color3.fromRGB(255, 80, 80),
    Title   = "Glow Color",
    Callback = function(val) end,
})

LeftGroup:AddToggle("FlyToggle", {
    Text = "Fly", Default = false,
}):AddKeyPicker("FlyBind", {
    Default  = "F",
    Mode     = "Toggle",
    Text     = "Fly",
    Callback = function(val) print("Fly active:", val) end,
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
    Text   = "Colors",
    Values = { "Red", "Green", "Blue" },
    Default = 1,
    Multi   = true,
    Callback = function(selected)
        -- selected is a table of chosen values
        for _, v in pairs(selected) do print(v) end
    end,
})

-- Searchable:
LeftGroup:AddDropdown("Item", {
    Text       = "Item",
    Values     = { "Apple", "Banana", "Cherry" },
    Default    = 1,
    Searchable = true,
    Callback   = function(val) end,
})

-- Player list (auto-updates as players join/leave):
LeftGroup:AddDropdown("Target", {
    Text                = "Target",
    SpecialType         = "Player",
    ExcludeLocalPlayer  = true,
    Callback            = function(val) print("Target:", val) end,
})

-- Team list (auto-updates):
LeftGroup:AddDropdown("Team", {
    Text        = "Team",
    SpecialType = "Team",
    Callback    = function(val) end,
})

print(Options.MyDrop.Value)
```

---

### Button

Triggers a function on click. Supports a nested sub-button.

**Args**
- `Text` String
- `Func` Function — called on click
- `DoubleClick` Boolean *(optional)* — require double-click (useful for dangerous actions)
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

-- Dangerous action with double-click guard:
LeftGroup:AddButton({
    Text        = "Reset Data",
    DoubleClick = true,
    Func        = function() print("Data reset") end,
})
```

**Button with icon**
```lua
LeftGroup:AddButton({
    Text = "Teleport",
    Func = function() end,
    Icon = { Name = "arrow-right-circle" },
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

-- Numeric input:
LeftGroup:AddInput("Damage", {
    Text     = "Damage",
    Default  = "100",
    Numeric  = true,
    Finished = true,
    Callback = function(val) print(tonumber(val)) end,
})

print(Options.MyInput.Value)
```

---

### Label

A plain text label row. Primarily used as a prefix for addon elements.

**Args**
- `Text` String
- `Tooltip` String *(optional)*

**Methods**
```lua
MyLabel:SetText("Updated text")
MyLabel:SetVisible(false)
```

**Usage**
```lua
LeftGroup:AddLabel("This is a label")

-- Labels are used as a prefix to chain addons:
LeftGroup:AddLabel("Keybind"):AddKeyPicker("MyBind", { ... })
LeftGroup:AddLabel("Color"):AddColorPicker("MyColor", { ... })
LeftGroup:AddLabel("Panic"):AddKeyPicker("PanicBind", {
    Default  = "Delete",
    Mode     = "Press",
    Text     = "Panic",
    Callback = function() Library:Panic() end,
})
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

-- With transparency slider:
RightGroup:AddLabel("Fill"):AddColorPicker("FillColor", {
    Default      = Color3.fromRGB(255, 255, 255),
    Title        = "Fill Color",
    Transparency = 0.5,
    Callback     = function(val) end,
})

-- Gradient (AllowGradient = true, Default is a ColorSequence):
RightGroup:AddLabel("Gradient"):AddColorPicker("GradColor", {
    Default = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Color3.fromRGB(255, 80, 80)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(80, 255, 80)),
        ColorSequenceKeypoint.new(1,   Color3.fromRGB(80, 80, 255)),
    }),
    Title         = "Gradient",
    AllowGradient = true,
    Callback      = function(val)
        -- val is ColorSequence when AllowGradient = true
        print(val)
    end,
})

-- Gradient controls:
-- Left-click empty bar area  → add a new color stop
-- Left-click + drag a stop   → move it along the bar
-- Right-click a stop (when 3+ stops exist) → remove it

-- Right-click the color preview square → context menu:
--   Copy gradient / Paste gradient / Copy stop HEX / Copy stop RGB   (gradient mode)
--   Copy color   / Paste color   / Copy HEX       / Copy RGB         (solid mode)

print(Options.GlowColor.Value)
Options.GlowColor:SetValueRGB(Color3.fromRGB(0, 255, 0))
```

---

### KeyPicker (Addon)

Chained onto a Label or Toggle. Lets the user bind a key or mouse button. Stored in `Library.Options`.

**Args**
- `Index` String
- `Default` String — key name e.g. `"F"`, `"MB2"`, `"LeftShift"`, `"RightShift"`, `"Delete"`
- `Mode` String — `"Toggle"` | `"Hold"` | `"Always"` | `"Press"`
- `Text` String — shown in the keybind list popup
- `NoUI` Boolean — hide from the keybind list popup
- `Tooltip` String *(optional)*
- `Callback` Function — receives `(active: boolean)`

**Mode reference**
| Mode | Behavior |
|------|----------|
| `"Toggle"` | Key press toggles active state on/off |
| `"Hold"` | Active while key is held down |
| `"Always"` | Always active regardless of key |
| `"Press"` | Fires callback once per key-down. Cannot be changed to Hold/Always. Only valid on Labels and Toggles. |

**Methods**
```lua
Options.MyBind:SetValue("G")                      -- change the bound key
Options.MyBind:GetState()                         -- returns true if currently active
Options.MyBind:SetModePickerVisibility(false)     -- hide the Toggle/Hold mode selector
Options.MyBind:OnChanged(function(val) print(val) end)
Options.MyBind:OnClick(function() print("key clicked") end)
Options.MyBind:DoClick()                          -- programmatically fire the click
```

**Usage**
```lua
-- Toggle mode on a Label:
LeftGroup:AddLabel("Fly"):AddKeyPicker("FlyBind", {
    Default  = "F",
    Mode     = "Toggle",
    Text     = "Fly",
    NoUI     = false,
    Callback = function(val)
        print("Fly active:", val)
    end,
})

-- Hold mode chained on a Toggle:
LeftGroup:AddToggle("SprintToggle", {
    Text = "Sprint", Default = false,
}):AddKeyPicker("SprintBind", {
    Default  = "LeftShift",
    Mode     = "Hold",
    Text     = "Sprint",
    Callback = function(val)
        print("Sprint held:", val)
    end,
})

-- Press mode (one-shot, locked — no mode selector shown):
LeftGroup:AddLabel("Panic"):AddKeyPicker("PanicBind", {
    Default  = "Delete",
    Mode     = "Press",
    Text     = "Panic",
    Callback = function()
        Library:Panic()
    end,
})

-- NoUI = true hides from the global keybind list (good for internal binds):
LeftGroup:AddLabel("Menu"):AddKeyPicker("MenuBind", {
    Default = "RightShift",
    NoUI    = true,
    Text    = "Menu Bind",
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

-- Multiple conditions (ALL must be true simultaneously):
DepBox:SetupDependencies({
    { Toggles.EnableAdv, true },
    { Options.AdvMode,   "Mode B" },
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
    Title    = "Confirm",
    Variant  = "Primary",     -- "Primary" | "Secondary" | "Destructive" | "Ghost"
    WaitTime = 0,             -- seconds before button becomes clickable
    Order    = 0,
    Func     = function() Dialog:Dismiss() end,
})

Dialog:RemoveFooterButton("Confirm")
Dialog:SetButtonDisabled("Confirm", true)
Dialog:SetButtonOrder("Confirm", 2)

-- Add UI elements inside the dialog body:
Dialog:AddToggle("DialogToggle", { Text = "Accept Terms", Default = false })
Dialog:AddInput("DialogInput", { Text = "Reason", Default = "" })
Dialog:Resize()
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
- `Icon` String *(optional)* — asset ID
- `IconColor` Color3 *(optional)*
- `SoundId` String *(optional)*
- `Persist` Boolean *(optional)* — never auto-dismiss

**Bar behavior**
- `NotificationBarSide = "Left"` or `"Right"` — static vertical color stripe on that side
- `NotificationBarSide = "Top"` or `"Bottom"` — animated progress bar at top or bottom (if `NotificationAnimatedBar = true`)
- Bar animations only apply to top/bottom sides

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

-- Persistent notification (never auto-dismisses):
Library:Notify({
    Title       = "Warning",
    Description = "Unload before rejoining.",
    Persist     = true,
})
```

---

### Icons

Icons can be applied to tabs, sub-tabs, tabbox tabs, and buttons. The library uses an internal icon registry fetched from a remote source.

**How icons work**
- Pass an icon name string as the second argument to `AddTab()`, or as `Icon = { Name = "..." }` in button args.
- Icons appear to the left of the label text by default.
- The icon color defaults to `Library.AccentColor`. Override per-element with `IconColor`.
- `Library.IconColor` sets a global icon tint. If `nil`, all icons follow AccentColor automatically.
- Tabs and subtabs are pre-widened by 18px to accommodate the icon; the label shrinks accordingly.

**Tab / SubTab icons**
```lua
-- Second argument to AddTab() is the icon name:
local MainTab  = Window:AddTab("Main",    "home")
local AimTab   = Window:AddTab("Aim",     "crosshair")
local ESPTab   = Window:AddTab("ESP",     "eye")
local MiscTab  = Window:AddTab("Misc",    "settings")
local InfoTab  = Window:AddTab("Info",    "info")
local LogTab   = Window:AddTab("Logs",    "list")
local ItemsTab = Window:AddTab("Items",   "package")
local MapTab   = Window:AddTab("Map",     "map")
local ChatTab  = Window:AddTab("Chat",    "message-circle")
local KeysTab  = Window:AddTab("Keybinds","key")

-- SubTabs follow the same pattern:
local CombatSub  = Tabs.Main:AddTab("Combat",   "sword")
local MoveSub    = Tabs.Main:AddTab("Movement", "arrow-up-circle")
local VisualsSub = Tabs.Main:AddTab("Visuals",  "eye")
```

**Tabbox tab icons**
```lua
local Box  = LeftGroup:AddTabbox()
local TabA = Box:AddTab("Aimbot",  "crosshair")
local TabB = Box:AddTab("Visuals", "eye")
local TabC = Box:AddTab("Misc",    "settings")
```

**Button icons**
```lua
-- Icon on a button (left side by default):
LeftGroup:AddButton({
    Text = "Teleport",
    Func = function() end,
    Icon = { Name = "map-pin" },
})

-- Icon with custom color:
LeftGroup:AddButton({
    Text      = "Danger",
    Func      = function() end,
    Icon      = { Name = "alert-triangle" },
    IconColor = Color3.fromRGB(255, 60, 60),
})

-- Icon on the right side:
LeftGroup:AddButton({
    Text     = "Next",
    Func     = function() end,
    Icon     = { Name = "arrow-right" },
    IconSide = "Right",
})
```

**Global icon color override**
```lua
-- All icons follow AccentColor by default (nil = AccentColor):
Library.IconColor = nil                          -- follow AccentColor (default)
Library.IconColor = Color3.fromRGB(255, 255, 255) -- all icons white
Library.IconColor = Color3.fromRGB(200, 150, 255) -- all icons purple

-- Per-element override (only affects that element):
-- Pass IconColor in the AddButton args or in AddTab's third argument
```

**Common icon names**
```
home            settings        search          plus           minus
x               check           alert-triangle  alert-circle   info
eye             eye-off         lock            unlock         key
user            users           shield          zap            activity
crosshair       target          sword           compass        map
map-pin         navigation      arrow-up        arrow-down     arrow-left
arrow-right     arrow-up-circle arrow-right-circle             chevron-up
chevron-down    chevron-left    chevron-right   corner-up-left refresh-cw
rotate-cw       rotate-ccw      maximize        minimize       move
edit            edit-2          edit-3          trash          trash-2
save            download        upload          copy           clipboard
link            link-2          external-link   anchor         hash
code            terminal        cpu             server         database
package         box             layers          grid           list
sliders         bar-chart       bar-chart-2     pie-chart      trending-up
trending-down   clock           calendar        bell           bell-off
message-circle  message-square  mail            send           share
heart           star            bookmark        tag            flag
image           film            camera          video          music
volume          volume-1        volume-2        volume-x       mic
radio           wifi            bluetooth       battery        power
sun             moon            cloud           wind           thermometer
globe           run             log-in          log-out        repeat
shuffle         skip-back       skip-forward    play           pause
stop            fast-forward    rewind          headphones     speaker
```

---

### Panic System

The panic system lets you register toggles that get force-disabled in one key press — useful for quickly turning off all active features when needed.

**Setup**
```lua
-- Step 1 — register toggles by their index strings.
-- This also sets Library.AllowPanic = true automatically.
Library:PanicFuncs({ "AimbotEnabled", "ESPEnabled", "SpeedHack", "Noclip" })

-- Step 2 — build your window (PanicFuncs must be called after elements are created):
local Window = Library:CreateWindow({ ... })
-- ... create tabs, groupboxes, elements ...

LeftGroup:AddToggle("AimbotEnabled", { Text = "Aimbot", Default = false })
LeftGroup:AddToggle("ESPEnabled",    { Text = "ESP",    Default = false })
LeftGroup:AddToggle("SpeedHack",     { Text = "Speed",  Default = false })
LeftGroup:AddToggle("Noclip",        { Text = "Noclip", Default = false })

Library:PanicFuncs({ "AimbotEnabled", "ESPEnabled", "SpeedHack", "Noclip" })

-- Step 3 — build MenuManager. The Panic section (toggle + keybind) appears
--           automatically because Library.AllowPanic is now true.
MenuManager:SetLibrary(Library)
MenuManager:BuildMenuSection(Tabs.UISettings)
```

**What MenuManager adds when AllowPanic = true**
- A "Panic" toggle — arm the panic trigger (prevents accidental panics while you're in-menu)
- A "Panic" keybind (Press mode, locked — cannot be changed to Hold or Always)
- Pressing the bound key while the toggle is armed calls `Library:Panic()`

**Manual control**
```lua
-- Set AllowPanic manually (skips PanicFuncs):
Library.AllowPanic = true

-- Call panic directly (e.g. from a button):
Library:Panic()

-- Safe: if no toggles are registered, Panic() does nothing.
Library.PanicFunctions = {}
Library:Panic()  -- no-op
```

**Notes**
- `Library.AllowPanic = false` (default) → the Panic section is not created in MenuManager
- `Library:PanicFuncs({})` with an empty table or all-invalid names → AllowPanic stays false, Panic() stays a no-op
- Only Toggle-type elements can be registered; other types are silently skipped
- The Panic button in MenuManager (DoubleClick) always calls `Library:Panic()` regardless of AllowPanic
- `Library:Panic()` returns immediately if `PanicFunctions` is empty

---

### Draggable Label

A floating draggable text overlay. Recommended over `SetWatermark` for new scripts.

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

Adds a built-in UI Settings tab with cursor, controller, notification controls, and optional panic section.

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
- `MenuManager.MenuTab` — the Menu sub-tab (cursor, controller, keybind, panic)
- `MenuManager.NotifTab` — the Notifications sub-tab
- `MenuManager.TabBox` — the tabbox containing both

**Sections built by MenuManager**
1. Lowercase Mode toggle
2. Custom Cursor toggle + color picker
3. Cursor Type dropdown with nested dep boxes (Dot scale/outline, Plus spacing/bars/outline)
4. Controller Support toggle + nav type dropdown
5. Menu Bind label + keybind (NoUI, RightShift default)
6. **(Optional)** Panic toggle + keybind — only when `Library.AllowPanic = true`
7. Unload button (DoubleClick)
8. Panic button (DoubleClick)
9. Notifications sub-tab: Force Color, colors, Animated Bar, Bar Side, Position X/Y, Alignment, test notification

**Translations** — MenuManager registers built-in Spanish (`"es"`) and French (`"fr"`) translations for all its elements via `Library:SetupLanguage()`. You can add more languages using the same system.

---

### ThemeManager

Color theme selector and customization UI.

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
SaveManager:IgnoreThemeSettings()                              -- don't save theme in config
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
MyToggle   = { Text = "Translated label" }
MyDropdown = { Text = "Translated label", Values = { "Option 1", "Option 2" } }

-- Registered label key (tabs, groupboxes — see RegisterLabel):
Tab_Main    = "Principal"
Group_Ctrl  = "Controles"
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

### Registry / Theme System

The registry syncs UI element colors to theme keys at runtime. When a theme changes, all registered instances update automatically.

**Theme color keys**
| Key | Default |
|-----|---------|
| `MainColor` | window background |
| `SecondColor` | secondary panels |
| `ThirdColor` | tertiary panels |
| `BorderColor` | borders |
| `OutlineColor` | outlines |
| `AccentColor` | accent (matches icon/cursor color when unoverridden) |
| `FontColor` | text color |

**Add to registry manually**
```lua
-- Register a Frame to follow MainColor:
Library:AddToRegistry(someFrame, { BackgroundColor3 = "MainColor" })

-- Register a TextLabel to follow FontColor:
Library:AddToRegistry(someLabel, { TextColor3 = "FontColor" })

-- Register a UIStroke to follow AccentColor:
Library:AddToRegistry(someStroke, { Color = "AccentColor" })
```

**Get current theme color**
```lua
local accent = Library:GetColor("AccentColor")   -- returns Color3
```

---

### Unload / Cleanup

```lua
-- Register a callback that runs when the library is unloaded:
Library:OnUnload(function()
    Library.Unloaded = true
    -- stop any loops, disconnect events, etc.
end)

-- Trigger unload (destroys GUI, fires all OnUnload callbacks):
Library:Unload()
```

**Pattern for safe loops**
```lua
Library:OnUnload(function() Library.Unloaded = true end)

game:GetService("RunService").Heartbeat:Connect(function()
    if Library.Unloaded then return end
    -- your logic here
end)
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
    Main       = Window:AddTab("Main",       "home"),
    UISettings = Window:AddTab("UI Settings", "settings"),
}

local SubTabs = {
    Features = Tabs.Main:AddTab("Features", "zap"),
    Info     = Tabs.Main:AddTab("Info",     "info"),
}

local LeftGroup  = SubTabs.Features:AddLeftGroupbox("Controls")
local RightGroup = SubTabs.Features:AddRightGroupbox("Colors")

-- ── Elements ──────────────────────────────────────────────────────────────────

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
    Text = "Name", Default = "", Placeholder = "Enter...", Finished = true,
    Callback = function(val) print("Input:", val) end,
})

-- Keybind on Label
LeftGroup:AddLabel("Fly"):AddKeyPicker("FlyBind", {
    Default = "F", Mode = "Toggle", Text = "Fly",
    Callback = function(val) print("Fly:", val) end,
})

-- Keybind chained on Toggle
LeftGroup:AddToggle("SprintToggle", {
    Text = "Sprint", Default = false,
}):AddKeyPicker("SprintBind", {
    Default = "LeftShift", Mode = "Hold", Text = "Sprint",
    Callback = function(val) end,
})

-- Color picker
RightGroup:AddLabel("Color"):AddColorPicker("MyColor", {
    Default = Color3.fromRGB(255, 80, 80), Title = "Feature Color",
    Callback = function(val) print("Color:", val) end,
})

-- Color picker with transparency
RightGroup:AddLabel("Fill"):AddColorPicker("FillColor", {
    Default = Color3.fromRGB(255, 255, 255), Title = "Fill", Transparency = 0.5,
    Callback = function(val) end,
})

-- Gradient picker
RightGroup:AddLabel("Gradient"):AddColorPicker("GradColor", {
    Default = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Color3.fromRGB(255, 80, 80)),
        ColorSequenceKeypoint.new(1,   Color3.fromRGB(80, 80, 255)),
    }),
    Title = "Gradient", AllowGradient = true,
    Callback = function(val) end,
})

-- Dependency box
LeftGroup:AddToggle("AdvEnabled", { Text = "Advanced", Default = false })
local AdvDep = LeftGroup:AddDependencyBox()
AdvDep:AddSlider("AdvStr", { Text = "Strength", Default = 50, Min = 0, Max = 100, Rounding = 0 })
AdvDep:SetupDependencies({ { Toggles.AdvEnabled, true } })

-- ── Panic ─────────────────────────────────────────────────────────────────────

-- Register which toggles Panic() will disable.
-- Must be called after the toggles are created.
-- Also sets Library.AllowPanic = true, so MenuManager shows the panic section.
Library:PanicFuncs({ "MyToggle", "SprintToggle" })

-- ── Draggable label ───────────────────────────────────────────────────────────

local FpsLabel = Library:AddDraggableLabel("My Script")
local _ft, _fc, _fps = tick(), 0, 60
game:GetService("RunService").RenderStepped:Connect(function()
    _fc += 1
    if tick() - _ft >= 1 then _fps = _fc _ft = tick() _fc = 0 end
    FpsLabel:SetText(("My Script | %d fps"):format(math.floor(_fps)))
end)

-- ── Unload ────────────────────────────────────────────────────────────────────

Library:OnUnload(function()
    Library.Unloaded = true
end)

-- ── Addons (always in this order) ─────────────────────────────────────────────

MenuManager:SetLibrary(Library)
MenuManager:BuildMenuSection(Tabs.UISettings)

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuBind", "PanicBind", "LanguageSelect" })
ThemeManager:SetFolder("MyScriptHub")
SaveManager:SetFolder("MyScriptHub/game-name")

SaveManager:BuildConfigSection(Tabs.UISettings)
ThemeManager:ApplyToTab(Tabs.UISettings)

-- ── Language (optional) ───────────────────────────────────────────────────────

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

---

### Tips and Patterns

**Reading values at any time**
```lua
-- Toggles:
print(Toggles.MyToggle.Value)    -- boolean

-- Options (sliders, dropdowns, inputs, keypickers, colorpickers):
print(Options.MySlider.Value)    -- number
print(Options.MyDrop.Value)      -- string
print(Options.MyInput.Value)     -- string
print(Options.FlyBind.Value)     -- string (key name)
print(Options.MyColor.Value)     -- Color3 or ColorSequence
```

**Subscribe without replacing the main Callback**
```lua
Toggles.MyToggle:OnChanged(function(val)
    print("extra subscriber:", val)
end)

Options.MySlider:OnChanged(function(val)
    print("slider changed:", val)
end)
```

**Programmatically set values**
```lua
Toggles.MyToggle:SetValue(true)
Options.MySlider:SetValue(100)
Options.MyDrop:SetValue("Mode B")
Options.MyInput:SetValue("hello")
Options.FlyBind:SetValue("G")
Options.MyColor:SetValueRGB(Color3.fromRGB(0, 255, 0))
```

**Disable / re-enable elements**
```lua
Toggles.MyToggle:SetDisabled(true)
Options.MySlider:SetDisabled(false)
Options.MyDrop:SetDisabled(true)
```

**Hide / show elements**
```lua
Toggles.MyToggle:SetVisible(false)
Options.MySlider:SetVisible(true)
```

**Rename elements**
```lua
Toggles.MyToggle:SetText("New Label")
Options.MySlider:SetText("New Slider Label")
Options.MyDrop:SetText("New Dropdown Label")
```

**Check keybind state from code**
```lua
if Options.FlyBind:GetState() then
    -- key is active right now
end
```

**Safe heartbeat loop**
```lua
Library:OnUnload(function() Library.Unloaded = true end)

game:GetService("RunService").Heartbeat:Connect(function(dt)
    if Library.Unloaded then return end
    -- logic here
end)
```

**Panic setup with button fallback**
```lua
-- Always register panic toggles after their elements are created:
LeftGroup:AddToggle("Aimbot", { Text = "Aimbot", Default = false })
LeftGroup:AddToggle("ESP",    { Text = "ESP",    Default = false })

Library:PanicFuncs({ "Aimbot", "ESP" })
-- Library.AllowPanic is now true — MenuManager will show the panic section.
-- Pressing the panic keybind (while toggle is armed) calls Library:Panic().
-- The existing double-click Panic button in MenuManager also calls Library:Panic().
```

**Dynamic dropdown values (e.g. re-populate on refresh)**
```lua
local items = { "Apple", "Banana", "Cherry" }

LeftGroup:AddDropdown("ItemPicker", {
    Text = "Item", Values = items, Default = 1,
    Callback = function(val) print(val) end,
})

-- Later, update the list:
local newItems = { "Mango", "Strawberry" }
Options.ItemPicker:SetValues(newItems)
```

**Disable specific dropdown values**
```lua
Options.MyDrop:SetDisabledValues({ "Mode C", "Mode D" })
-- "Mode C" and "Mode D" are greyed out and unselectable
```

**Chained sub-sliders for XY or width/height pairs**
```lua
LeftGroup:AddSlider("OffX", {
    Text = "Offset X", Default = 0, Min = -500, Max = 500, Rounding = 0, Compact = true,
}):AddSlider("OffY", {
    Text = "Offset Y", Default = 0, Min = -500, Max = 500, Rounding = 0, Compact = true,
})
```

**Chained color pickers — multiple colors on one label**
```lua
-- Chain up to three color pickers from one Label or Toggle:
LeftGroup:AddLabel("Colors")
    :AddColorPicker("Color1", { Default = Color3.fromRGB(255,  80,  80), Title = "Primary" })
    :AddColorPicker("Color2", { Default = Color3.fromRGB( 80, 255,  80), Title = "Secondary" })
    :AddColorPicker("Color3", { Default = Color3.fromRGB( 80,  80, 255), Title = "Tertiary" })
```

**Deep dependency nesting**
```lua
-- CursorType == "Dot" → show Dot settings
-- Within Dot settings, DotOutline == true → show thickness slider

LeftGroup:AddDropdown("CursorType", {
    Text = "Cursor Type", Values = { "Mouse", "Dot", "Plus" }, Default = 1,
})

local DotDep = LeftGroup:AddDependencyBox()

DotDep:AddSlider("DotScale", { Text = "Dot Size", Default = 5, Min = 1, Max = 20, Rounding = 0 })

DotDep:AddToggle("DotOutline", { Text = "Outline", Default = false })

local DotOutlineDep = DotDep:AddDependencyBox()
DotOutlineDep:AddSlider("DotOutlineThick", {
    Text = "Outline Thickness", Default = 1, Min = 0.1, Max = 4, Rounding = 1, Suffix = "px"
})
DotOutlineDep:SetupDependencies({ { Toggles.DotOutline, true } })

DotDep:SetupDependencies({ { Options.CursorType, "Dot" } })
```

**Player target dropdown with callback**
```lua
LeftGroup:AddDropdown("Target", {
    Text               = "Target Player",
    SpecialType        = "Player",
    ExcludeLocalPlayer = true,
    Callback           = function(val)
        local player = game.Players:FindFirstChild(val)
        if player then
            print("Targeting:", player.DisplayName)
        end
    end,
})
```

**Persist notification (no auto-dismiss)**
```lua
Library:Notify({
    Title       = "Status",
    Description = "Feature is running.",
    Persist     = true,
})
```

**Dialog with timed button**
```lua
local Dlg = Window:AddDialog("WarnDialog", {
    Title       = "Warning",
    Description = "This action cannot be undone. Please wait before confirming.",
})

Dlg:AddFooterButton("Cancel", {
    Title   = "Cancel",
    Variant = "Secondary",
    Func    = function() Dlg:Dismiss() end,
})

Dlg:AddFooterButton("Confirm", {
    Title    = "Confirm",
    Variant  = "Destructive",
    WaitTime = 3,  -- button is disabled for 3 seconds
    Func     = function()
        print("Confirmed after wait")
        Dlg:Dismiss()
    end,
})

Dlg:Resize()
```

**SetLayoutOrder to reorder tabs**
```lua
-- Move a tab to position 1 (leftmost):
Tabs.Main:SetLayoutOrder(1)
Tabs.UISettings:SetLayoutOrder(2)
```

**Rename a tab dynamically**
```lua
Tabs.Main:SetName("Home")  -- also resizes the tab button
```

**Switch tabs from code**
```lua
Tabs.Main:ShowTab()
SubTabs.Features:ShowTab()
```

**IgnoreTabSizes — force all tabs to the same width**
```lua
Library.IgnoreTabSizes    = true   -- main tabs
Library.IgnoreSubTabSizes = true   -- sub-tabs
```

**Custom cursor with accent color tracking**
```lua
Library.ShowCustomCursor = true
Library.CursorType       = "Plus"
-- CursorColor = nil means it follows AccentColor automatically
-- Override to a fixed color:
Library.CursorColor = Color3.fromRGB(255, 100, 100)
```

**Controller support**
```lua
Library.ControllerSupport    = true
Library.ControllerNavType    = "Dpad"       -- or "Joystick"
Library.ControllerNavSensitivity = 5        -- higher = faster cursor
```

---

### Element Quick Reference

| Element | Creation | Key | Stored in |
|---------|----------|-----|-----------|
| Toggle | `group:AddToggle(idx, {})` | Index string | `Library.Toggles` |
| Slider | `group:AddSlider(idx, {})` | Index string | `Library.Options` |
| Dropdown | `group:AddDropdown(idx, {})` | Index string | `Library.Options` |
| Input | `group:AddInput(idx, {})` | Index string | `Library.Options` |
| ColorPicker | `element:AddColorPicker(idx, {})` | Index string | `Library.Options` |
| KeyPicker | `element:AddKeyPicker(idx, {})` | Index string | `Library.Options` |
| Button | `group:AddButton({})` | — | — |
| Label | `group:AddLabel(text)` | — | — |
| Divider | `group:AddDivider()` | — | — |
| Blank | `group:AddBlank()` | — | — |
| DependencyBox | `group:AddDependencyBox()` | — | — |

---

### Method Quick Reference

**Library**
```lua
Library:CreateWindow(info)             -- create and return the Window
Library:Toggle(state?)                 -- open/close UI
Library:SetLowercaseMode(bool)         -- lowercase all text
Library:UpdateNotificationAreas()      -- refresh notification position
Library:OnUnload(fn)                   -- register cleanup callback
Library:Unload()                       -- destroy the library
Library:Notify(info | msg, time?)      -- show a notification
Library:Panic()                        -- disable all PanicFunctions toggles
Library:PanicFuncs(names)              -- register toggle index strings for panic
Library:AddDraggableLabel(text)        -- create a floating draggable label
Library:SetWatermark(text)             -- (deprecated) set watermark text
Library:SetWatermarkVisibility(bool)   -- (deprecated)
Library:SetupLanguage(code, table)     -- register translations
Library:SetLanguage(code | nil)        -- switch active language
Library:RegisterLabel(key, label, fn?) -- register label for language system
Library:AddToRegistry(inst, props)     -- register instance for theme sync
Library:GetColor(key)                  -- get current theme Color3 by key
```

**Window**
```lua
Window:AddTab(name, iconName?)         -- add a main tab
Window:AddDialog(idx, info)            -- add a modal dialog
Window:SetWindowTitle(text)            -- update main title
Window:SetBackgroundImage(assetId)     -- set background image
```

**Tab / SubTab**
```lua
Tab:AddTab(name, iconName?)            -- add a sub-tab
Tab:AddLeftGroupbox(name)              -- add a left groupbox
Tab:AddRightGroupbox(name)             -- add a right groupbox
Tab:ShowTab()                          -- switch to this tab
Tab:HideTab()                          -- hide this tab
Tab:SetName(text)                      -- rename + resize button
Tab:SetLayoutOrder(n)                  -- reorder
```

**Groupbox**
```lua
group:AddToggle(idx, info)
group:AddSlider(idx, info)
group:AddDropdown(idx, info)
group:AddInput(idx, info)
group:AddButton(info)
group:AddLabel(text)
group:AddDivider()
group:AddBlank()
group:AddDependencyBox()
group:AddTabbox()
group:AddLeftTabbox()
```

**Tabbox**
```lua
tabbox:AddTab(name, iconName?)
```

**DependencyBox**
```lua
depbox:SetupDependencies({ { element, value }, ... })
depbox:AddToggle(...)    -- same as groupbox
depbox:AddSlider(...)
depbox:AddDropdown(...)
depbox:AddInput(...)
depbox:AddButton(...)
depbox:AddLabel(...)
depbox:AddDivider()
depbox:AddDependencyBox()
```

**Button**
```lua
button:AddButton(info)          -- add a sub-button
button:SetText(text)
button:SetDisabled(bool)
button:SetVisible(bool)
```

**Toggle**
```lua
toggle:SetValue(bool)
toggle:SetText(text)
toggle:SetDisabled(bool)
toggle:SetVisible(bool)
toggle:OnChanged(fn)
toggle:AddColorPicker(idx, info)
toggle:AddKeyPicker(idx, info)
```

**Slider**
```lua
slider:SetValue(n)
slider:SetMin(n)
slider:SetMax(n)
slider:SetText(text)
slider:SetPrefix(text)
slider:SetSuffix(text)
slider:SetDisabled(bool)
slider:SetVisible(bool)
slider:OnChanged(fn)
slider:AddSlider(idx, info)     -- chain a sub-slider
```

**Dropdown**
```lua
dropdown:SetValue(str)
dropdown:SetValues(table)
dropdown:SetDisabledValues(table)
dropdown:SetText(text)
dropdown:SetDisabled(bool)
dropdown:SetVisible(bool)
dropdown:OnChanged(fn)
```

**Input**
```lua
input:SetValue(str)
input:SetDisabled(bool)
input:SetVisible(bool)
input:OnChanged(fn)
```

**ColorPicker**
```lua
colorpicker:SetValue(color3 | colorsequence)
colorpicker:SetValueRGB(color3)
colorpicker:SetDisabled(bool)
colorpicker:Show()
colorpicker:Hide()
colorpicker:OnChanged(fn)
colorpicker:AddColorPicker(idx, info)   -- chain another picker
```

**KeyPicker**
```lua
keypicker:SetValue(keyName)
keypicker:GetState()                    -- returns boolean
keypicker:SetModePickerVisibility(bool)
keypicker:OnChanged(fn)
keypicker:OnClick(fn)
keypicker:DoClick()
```

**DraggableLabel**
```lua
label:SetText(text)
label:SetVisible(bool)
label:Destroy()
```

**Dialog**
```lua
dialog:Dismiss()
dialog:SetTitle(text)
dialog:SetDescription(text)
dialog:AddFooterButton(key, info)
dialog:RemoveFooterButton(key)
dialog:SetButtonDisabled(key, bool)
dialog:SetButtonOrder(key, n)
dialog:Resize()
dialog:AddToggle(idx, info)
dialog:AddInput(idx, info)
```
