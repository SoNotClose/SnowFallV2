# SnowFall V2 — Complete Reference

> **SnowFall V2** is a fully-featured Roblox Luau UI library designed for script hubs and exploits.  
> It provides tabs, groupboxes, a rich element set, themes, config saving, panic, and a language system —  
> all in a clean, consistent API.

---

## Table of Contents

| # | Section |
|---|---------|
| 1 | [Quick Start](#quick-start) |
| 2 | [Full Setup](#full-setup) |
| 3 | [Window](#window) |
| 4 | [Library Properties](#library-properties) |
| 5 | [Library Methods](#library-methods) |
| 6 | [Panic System](#panic-system) |
| 7 | [Language System](#language-system) |
| 8 | [Tabs & SubTabs](#tabs--subtabs) |
| 9 | [Groupboxes & Tabboxes](#groupboxes--tabboxes) |
| 10 | [Elements](#elements) |
| 11 | [Addons (Chaining)](#addons-chaining) |
| 12 | [DependencyBox](#dependencybox) |
| 13 | [Notifications](#notifications) |
| 14 | [Dialogs](#dialogs) |
| 15 | [ThemeManager](#thememanager) |
| 16 | [SaveManager](#savemanager) |
| 17 | [MenuManager](#menumanager) |
| 18 | [Icons](#icons) |
| 19 | [Tooltips](#tooltips) |
| 20 | [Events & Hooks](#events--hooks) |

---

## Quick Start

The bare minimum to get a working UI:

```lua
local repo    = "https://raw.githubusercontent.com/SoNotClose/SnowFallV2/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()

local Window = Library:CreateWindow({
    Title    = "My Script",
    Center   = true,
    AutoShow = true,
})

local Tab   = Window:AddTab("Main")
local Group = Tab:AddLeftGroupbox("Settings")

Group:AddToggle("MyFeature", {
    Text    = "Enable Feature",
    Default = false,
    Callback = function(val)
        print("Feature:", val)
    end,
})
```

---

## Full Setup

A complete setup that includes all optional addons:

```lua
local repo         = "https://raw.githubusercontent.com/SoNotClose/SnowFallV2/main/"
local Library      = loadstring(game:HttpGet(repo .. "Library.lua"))()
local MenuManager  = loadstring(game:HttpGet(repo .. "addons/MenuManager.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager  = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Options = Library.Options
local Toggles = Library.Toggles

-- ── 1. Create the window ──────────────────────────────────────────────────────
local Window = Library:CreateWindow({
    Title        = "My Script",
    SubTitle     = "v1.0",
    GameTitle    = "Game Name",
    Center       = true,
    AutoShow     = true,
    Resizable    = true,
    MenuFadeTime = 0.2,
    ShowCustomCursor     = true,
    UnlockMouseWhileOpen = true,
})

-- ── 2. Build tabs ─────────────────────────────────────────────────────────────
local Tabs = {
    Main      = Window:AddTab("Main",      "home"),
    Combat    = Window:AddTab("Combat",    "sword"),
    Visuals   = Window:AddTab("Visuals",   "eye"),
    Misc      = Window:AddTab("Misc",      "settings"),
    UISettings = Window:AddTab("UI Settings"),
}

-- ── 3. Wire up addons ─────────────────────────────────────────────────────────
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
MenuManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()
SaveManager:SetSubFolder("MyScript")   -- saves configs in MyScript/

ThemeManager:SetFolder("MyScript")
ThemeManager:ApplyTheme("Default")

-- ── 4. Build UI sections ──────────────────────────────────────────────────────
local MainLeft  = Tabs.Main:AddLeftGroupbox("Features")
local MainRight = Tabs.Main:AddRightGroupbox("Config")

-- Your elements go here ...

-- ── 5. Build addon config/menu tabs ──────────────────────────────────────────
ThemeManager:BuildThemeSection(Tabs.UISettings)
SaveManager:BuildConfigSection(Tabs.UISettings)
MenuManager:BuildMenuSection(Tabs.UISettings)
```

> **Note:** Always call `SaveManager:BuildConfigSection` and `MenuManager:BuildMenuSection`
> **after** building all your game-specific tabs, so auto-save hooks fire for all registered
> toggles and options.

---

## Window

`Library:CreateWindow(Info)` — creates the root UI frame. Returns a `Window` object.

### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `Title` | `string` | `""` | Main title shown in the header bar |
| `SubTitle` | `string` | `nil` | Smaller secondary text on the same side as Title |
| `GameTitle` | `string` | `nil` | Secondary label on the opposite side (e.g. game name) |
| `TitleSide` | `"Left"/"Right"/"Middle"` | `"Left"` | Which side Title+SubTitle anchor to |
| `GameSide` | `"Left"/"Right"/"Middle"` | `"Right"` | Which side GameTitle anchors to |
| `Center` | `boolean` | `false` | Spawn in screen center (overrides Position) |
| `AutoShow` | `boolean` | `false` | Show the window immediately without a keybind |
| `Resizable` | `boolean` | `false` | Allow the user to drag-resize the window |
| `AllowPanic` | `boolean` | `false` | Enable the Panic toggle section in MenuManager |
| `Size` | `UDim2` | `UDim2.new(0,550,0,600)` | Initial window size |
| `Position` | `UDim2` | `nil` | Initial position (ignored if `Center = true`) |
| `AnchorPoint` | `Vector2` | `nil` | Anchor point for Position |
| `NotifySide` | `"Left"/"Right"/"Middle"` | `"Left"` | Default side for notifications |
| `TabPadding` | `number` | `8` | Pixel gap between tab buttons |
| `MenuFadeTime` | `number` | `0.2` | Open/close fade duration in seconds |
| `ShowCustomCursor` | `boolean` | `true` | Enable the custom Drawing cursor |
| `UnlockMouseWhileOpen` | `boolean` | `false` | Unlock mouse from Roblox lock while menu is open |
| `BackgroundImage` | `string` | `nil` | Asset ID string for a background image |
| `DragMode` | `string` | `"Window"` | Drag behaviour: `"Window"` or `"TopBar"` |

### Methods

```lua
Window:SetWindowTitle("New Title")
Window:SetBackgroundImage("rbxassetid://12345678")

-- Add a dialog popup (see Dialogs section)
local dialog = Window:AddDialog("MyDialog", { ... })
```

### Example

```lua
local Window = Library:CreateWindow({
    Title        = "SnowFall",
    SubTitle     = "by me",
    GameTitle    = "Blox Fruits",
    TitleSide    = "Left",
    GameSide     = "Right",
    Center       = true,
    AutoShow     = true,
    Resizable    = true,
    AllowPanic   = true,
    MenuFadeTime = 0.15,
    ShowCustomCursor     = true,
    UnlockMouseWhileOpen = true,
    Size         = UDim2.fromOffset(600, 650),
})
```

---

## Library Properties

Set directly on `Library` before or after `CreateWindow`. Changes take effect immediately.

### Colors & Theming

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `Library.AccentColor` | `Color3` | `Color3.fromRGB(103,93,190)` | Primary accent — used by highlights, borders, icons |
| `Library.BackgroundColor` | `Color3` | dark grey | Window background |
| `Library.MainColor` | `Color3` | mid grey | Element backgrounds |
| `Library.OutlineColor` | `Color3` | dark outline | Element borders |
| `Library.FontColor` | `Color3` | white | All text |
| `Library.Font` | `Enum.Font` | `GothamSemibold` | Global font |
| `Library.IconColor` | `Color3\|nil` | `nil` | Icon tint (`nil` = follow AccentColor per icon) |

> **Tip — icon color priority:** The effective color for any tab icon is resolved in order:
> 1. The `IconColor` argument passed directly to the element (per-element override)
> 2. `Library.IconColor` (global override, only if not `nil`)
> 3. `Library.AccentColor` (automatic fallback)
>
> Leave `Library.IconColor = nil` (the default) to let all icons follow your accent colour
> automatically, while still allowing individual elements to pin their own colour.

### Custom Cursor

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `Library.ShowCustomCursor` | `boolean` | `true` | Enable the custom Drawing-based cursor |
| `Library.CursorType` | `string` | `"Mouse"` | `"Mouse"` / `"Dot"` / `"Plus"` |
| `Library.CursorColor` | `Color3\|nil` | `nil` | Cursor colour (`nil` = follow AccentColor) |
| `Library.CursorDotScale` | `number` | `5` | Dot radius in pixels |
| `Library.CursorDotOutline` | `boolean` | `false` | Draw outline ring around dot |
| `Library.CursorDotOutlineThickness` | `number` | `1` | Dot outline thickness px |
| `Library.CursorPlusSpacing` | `number` | `2` | Gap from center to each bar |
| `Library.CursorPlusTopBar` | `boolean` | `true` | Show top arm of plus cursor |
| `Library.CursorPlusRightBar` | `boolean` | `true` | Show right arm |
| `Library.CursorPlusLeftBar` | `boolean` | `true` | Show left arm |
| `Library.CursorPlusBottomBar` | `boolean` | `true` | Show bottom arm |
| `Library.CursorPlusOutline` | `boolean` | `false` | Draw outline behind each bar |
| `Library.CursorPlusOutlineThickness` | `number` | `1` | Plus outline thickness px |

### Controller

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `Library.ControllerSupport` | `boolean` | `false` | Enable gamepad navigation |
| `Library.ControllerNavType` | `string` | `"Dpad"` | `"Dpad"` or `"Joystick"` |
| `Library.ControllerNavSensitivity` | `number` | `5` | Joystick navigation sensitivity |

### Tab Sizing

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `Library.IgnoreTabSizes` | `boolean` | `false` | Force all tab buttons to the same width |
| `Library.TabSize` | `number` | `5` | Width multiplier when `IgnoreTabSizes = true` |
| `Library.IgnoreLimit` | `number` | `6` | Tab count before the tab bar scrolls |
| `Library.IgnoreSubTabSizes` | `boolean` | `false` | Force uniform sub-tab button widths |

### Tab Animations

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `Library.TabSwitchAnimation` | `string` | `"None"` | `"None"` / `"Fade"` / `"SlideUp"` / `"SlideDown"` / `"SlideLeft"` / `"SlideRight"` / `"Scale"` / `"Bounce"` / `"Elastic"` |
| `Library.TabSwitchAnimationTime` | `number` | `0.18` | Animation duration in seconds |

### Notifications

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `Library.NotificationPositionX` | `number` | `50` | Screen X % (0–100) |
| `Library.NotificationPositionY` | `number` | `50` | Screen Y % (0–100) |
| `Library.NotificationAlignment` | `string` | `"Center"` | `"Left"` / `"Right"` / `"Center"` |
| `Library.NotificationBarSide` | `string` | `"Left"` | `"Left"` / `"Top"` / `"Right"` / `"Bottom"` |
| `Library.NotificationAnimatedBar` | `boolean` | `true` | Animated countdown bar |
| `Library.NotificationForceColor` | `boolean` | `false` | Force custom notification colors |
| `Library.NotificationAccentColor` | `Color3` | `Color3.fromRGB(120,120,200)` | Notification accent |
| `Library.NotificationOutlineColor` | `Color3` | `Color3.fromRGB(60,60,80)` | Notification outline |
| `Library.NotificationFontColor` | `Color3` | white | Notification text |
| `Library.LimitNotifications` | `boolean` | `false` | Cap visible notifications |
| `Library.MaximumNotifications` | `number` | `5` | Max visible when `LimitNotifications = true` |

### Panic System

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `Library.AllowPanic` | `boolean` | `false` | Show Panic UI in MenuManager. Set automatically by `RegisterPanic = true` or `Library:PanicFuncs()` |
| `Library.PanicFunctions` | `table` | `{}` | Read-only list of Toggle objects that `Library:Panic()` will disable |

### Misc

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `Library.LowercaseMode` | `boolean` | `false` | Convert all labels to lowercase |
| `Library.SafeMode` | `boolean` | `false` | Wrap callbacks in pcall |
| `Library.NotifyOnError` | `boolean` | `false` | Show a notification on `SafeCallback` errors |
| `Library.CurrentLanguage` | `string\|nil` | `nil` | *(read-only)* Active language code, e.g. `"es"` |
| `Library.ActiveTab` | `string` | — | *(read-only)* Currently visible tab name |
| `Library.Toggled` | `boolean` | — | *(read-only)* Whether the menu is currently open |
| `Library.Unloaded` | `boolean` | — | *(read-only)* Set to `true` after `Library:Unload()` |

---

## Library Methods

### UI Control

```lua
-- Toggle the menu open/closed
Library:Toggle()          -- flip current state
Library:Toggle(true)      -- force open
Library:Toggle(false)     -- force closed

-- Immediately destroy the entire library
Library:Unload()

-- Register a callback that fires when Library:Unload() is called
Library:OnUnload(function()
    -- cleanup connections, drawing objects, etc.
end)
```

### Notifications

```lua
-- Simple string notification
Library:Notify("Hello!")
Library:Notify("Hello!", 3)         -- 3 second timeout

-- Full table form
Library:Notify({
    Title       = "My Script",
    Description = "Feature enabled!",
    Time        = 5,
    Icon        = "check",          -- optional icon name
    IconColor   = Color3.new(0,1,0), -- optional icon color override
})
```

### Lowercase Mode

```lua
-- Toggle lowercase rendering of all labels
Library:SetLowercaseMode(true)
Library:SetLowercaseMode(false)
```

### Panic System

```lua
-- Disable all registered panic toggles
Library:Panic()

-- Register toggle IDs for panic from a list
-- Sets Library.AllowPanic = true automatically
Library:PanicFuncs({ "SpeedHack", "Fly", "AimBot" })
```

### Notification Area

```lua
-- Call after changing NotificationPositionX/Y to reposition
Library:UpdateNotificationAreas()
```

### Color Utilities

```lua
-- Get a slightly darker version of a Color3
local darker = Library:GetDarkerColor(Color3.fromRGB(100, 100, 200))
```

### Attempt Save

```lua
-- Manually trigger SaveManager auto-save (no-op if no autosave config is set)
Library:AttemptSave()
```

### Safe Callback

```lua
-- Calls func(a, b, c) with error protection if Library.SafeMode = true
Library:SafeCallback(func, a, b, c)
```

### Language

```lua
-- Register translations for a language code
Library:SetupLanguage("fr", { ... })   -- see Language System section

-- Apply a registered language (or nil to reset to original)
Library:SetLanguage("fr")
Library:SetLanguage(nil)   -- revert to default
```

### Advanced

```lua
-- Register a label TextLabel for the language system
Library:RegisterLabel("MyLabel_key", myTextLabel)

-- Add a UI instance to the color registry (auto-updates on theme change)
Library:AddToRegistry(frame, { BackgroundColor3 = "AccentColor" })

-- Hook element hover highlight
Library:OnHighlight(hoverDetect, colorTarget,
    { BorderColor3 = "AccentColor" },   -- on hover
    { BorderColor3 = "OutlineColor" }   -- on leave
)
```

---

## Panic System

The Panic system lets you instantly disable a set of dangerous toggles via a keybind.

### Method 1 — `RegisterPanic = true` on a Toggle

The cleanest approach: declare panic membership at the toggle itself.

```lua
Group:AddToggle("SpeedHack", {
    Text         = "Speed Hack",
    Default      = false,
    RegisterPanic = true,    -- ← auto-registers; sets AllowPanic = true
    Callback = function(val)
        -- ...
    end,
})

Group:AddToggle("Fly", {
    Text         = "Fly",
    Default      = false,
    RegisterPanic = true,
    Callback = function(val)
        -- ...
    end,
})
```

### Method 2 — `Library:PanicFuncs(names)`

Bulk-register by toggle index after all toggles are created:

```lua
Group:AddToggle("SpeedHack", { ... })
Group:AddToggle("Fly",       { ... })
Group:AddToggle("AimBot",    { ... })

Library:PanicFuncs({ "SpeedHack", "Fly", "AimBot" })
-- Library.AllowPanic is now true; panic UI appears in MenuManager
```

### Method 3 — Manual

```lua
Library.AllowPanic = true
table.insert(Library.PanicFunctions, Library.Toggles.SpeedHack)
```

### Triggering Panic

- **Keybind** — the `PanicBind` key picker in MenuManager (default `Delete`) fires `Library:Panic()` when `PanicArmed` toggle is on.
- **Panic button** — double-click the Panic button in the Menu tab.
- **Code** — `Library:Panic()` anywhere.

```lua
Library:Panic()   -- disables all registered panic toggles
```

> **Note:** The Panic button in MenuManager is **disabled** (greyed out) when no panic
> functions are registered. It enables automatically when at least one toggle is added via
> `RegisterPanic = true` or `Library:PanicFuncs()`.

---

## Language System

SnowFall supports runtime language switching. Elements keep their original text stored;
switching a language applies all registered translations.

### Registering Translations

```lua
Library:SetupLanguage("es", {
    -- Toggle by index
    SpeedHack = { Text = "Velocidad" },

    -- Dropdown with translated values
    SpeedMode = { Text = "Modo de velocidad", Values = { "Caminar", "Correr", "Volar" } },

    -- Label (string key registered via Library:RegisterLabel)
    MyGroupTitle = "Mi Grupo",
})
```

### Applying a Language

```lua
Library:SetLanguage("es")   -- Spanish
Library:SetLanguage("fr")   -- French
Library:SetLanguage(nil)    -- Reset to original English
```

### Reading the Active Language

```lua
print(Library.CurrentLanguage)   -- "es", "fr", or nil
```

### Full Example

```lua
Library:SetupLanguage("fr", {
    SpeedHack  = { Text = "Vitesse" },
    Fly        = { Text = "Vol" },
    SpeedSlider = { Text = "Multiplicateur de vitesse" },
    WeaponList  = { Text = "Arme", Values = { "Pistolet", "Fusil", "Couteau" } },
})
Library:SetupLanguage("es", {
    SpeedHack  = { Text = "Velocidad" },
    Fly        = { Text = "Volar" },
    SpeedSlider = { Text = "Multiplicador de velocidad" },
    WeaponList  = { Text = "Arma", Values = { "Pistola", "Rifle", "Cuchillo" } },
})

-- Switch later
Library:SetLanguage("fr")
```

### Language Hooks

```lua
-- React when the language changes
Library:OnLanguageChanged(function(langCode)
    print("Language set to:", langCode)
end)
```

> **SaveManager integration:** When a config is loaded that was saved with a different
> language, SaveManager shows a dialog:
> *"This configuration was saved with the language 'ES'. Would you like to switch to it?"*
> The user picks **Yes** or **No**. The config objects are always applied regardless of the choice.

---

## Tabs & SubTabs

### Tabs

Tabs are the top-level navigation buttons along the top of the window.

```lua
local Tab = Window:AddTab(Name, IconName)
```

| Parameter | Type | Description |
|-----------|------|-------------|
| `Name` | `string` | Label for the tab button |
| `IconName` | `string` (optional) | Icon to show beside the label (see [Icons](#icons)) |

#### Methods

```lua
Tab:ShowTab()               -- switch to this tab
Tab:HideTab()               -- hide this tab (removes from visible bar)
Tab:SetName("New Name")     -- rename and resize the button
Tab:SetLayoutOrder(3)       -- reorder the button position
```

#### Read-only State

```lua
print(Library.ActiveTab)    -- name of the currently visible tab
```

#### Example

```lua
local Tabs = {
    Main    = Window:AddTab("Main",    "home"),
    Combat  = Window:AddTab("Combat",  "sword"),
    Visuals = Window:AddTab("Visuals", "eye"),
    Misc    = Window:AddTab("Misc",    "settings"),
}
```

### SubTabs

SubTabs add a second navigation row **inside** a tab.

```lua
local SubTab = Tab:AddTab(Name, IconName)
```

#### Methods

```lua
SubTab:ShowTab()
SubTab:HideTab()
SubTab:SetName("New Name")
```

#### Read-only State

```lua
print(Library.ActiveSubTab)   -- name of the currently visible sub-tab
```

#### Example

```lua
local CombatTabs = {
    Aim      = Tabs.Combat:AddTab("Aim",      "crosshair"),
    Movement = Tabs.Combat:AddTab("Movement", "run"),
    Misc     = Tabs.Combat:AddTab("Misc"),
}

-- SubTab groupboxes
local AimLeft  = CombatTabs.Aim:AddLeftGroupbox("Aim Settings")
local AimRight = CombatTabs.Aim:AddRightGroupbox("Targets")
```

---

## Groupboxes & Tabboxes

### Groupboxes

Every tab/subtab has two columns (left and right). Groupboxes fill those columns.

```lua
local LeftGroup  = Tab:AddLeftGroupbox("Title")
local RightGroup = Tab:AddRightGroupbox("Title")
```

Elements are stacked inside a groupbox via `AddToggle`, `AddButton`, etc.

#### Exposed Label

```lua
-- Register the groupbox title for language translations
Library:RegisterLabel("MyGroup_title", LeftGroup.TitleLabel)
```

### Tabbox (mini tab strip inside a column)

Embed an additional tab strip inside a groupbox column.

```lua
-- Left-aligned tabbox inside a tab column
local Tabbox = Tab:AddLeftTabbox()
-- Right-aligned:
local Tabbox = Tab:AddRightTabbox()
-- Inside a groupbox (full-width):
local Tabbox = LeftGroup:AddTabbox()

-- Add pages to the tabbox
local Page1 = Tabbox:AddTab("Options")
local Page2 = Tabbox:AddTab("Advanced")

-- Elements go on the pages
Page1:AddToggle("SomeToggle", { ... })
Page2:AddSlider("SomeSlider", { ... })
```

> **Tip:** `AddLeftTabbox()` / `AddRightTabbox()` return a tabbox that spans the full height
> of their column. Use these for the MenuManager and ThemeManager panels.

---

## Elements

All elements live inside a Groupbox, a Tabbox page, or a DependencyBox.

---

### Toggle

A simple on/off checkbox.

```lua
Groupbox:AddToggle(Idx, Info)
```

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `Text` | `string` | — | Label text |
| `Default` | `boolean` | `false` | Initial state |
| `Callback` | `function(val)` | `nil` | Fires when the value changes |
| `Disabled` | `boolean` | `false` | Start disabled (greyed out) |
| `Visible` | `boolean` | `true` | Initial visibility |
| `RegisterPanic` | `boolean` | `false` | Auto-add to `Library.PanicFunctions`; sets `AllowPanic = true` |
| `Tooltip` | `string` | `nil` | Hover tooltip text |
| `DisabledTooltip` | `string` | `nil` | Tooltip shown only when disabled |

#### Methods

```lua
local t = Groupbox:AddToggle("Fly", { Text = "Fly", Default = false })

t:SetValue(true)          -- set value programmatically (fires callback)
t:SetDisabled(true)       -- disable/enable
t:SetVisible(false)       -- show/hide
t.Value                   -- read current value (boolean)

-- Hook a listener (returns a connection object)
local conn = t:OnChanged(function()
    print("New value:", t.Value)
end)
conn:Disconnect()         -- remove listener
```

#### Examples

```lua
-- Basic toggle
Group:AddToggle("SpeedHack", {
    Text    = "Speed Hack",
    Default = false,
    Callback = function(val)
        -- val is true/false
    end,
})

-- Panic-registered toggle
Group:AddToggle("Fly", {
    Text          = "Fly",
    Default       = false,
    RegisterPanic = true,   -- will be disabled by Panic button
    Callback = function(val) end,
})

-- With tooltip
Group:AddToggle("ESPBoxes", {
    Text    = "ESP Boxes",
    Default = true,
    Tooltip = "Draw boxes around players",
    Callback = function(val) end,
})
```

---

### Button

A clickable button. Supports double-click confirmation and icons.

```lua
Groupbox:AddButton(Info)
-- or
Groupbox:AddButton(Text, Callback)     -- shorthand
```

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `Text` | `string` | — | Button label |
| `Func` | `function()` | — | Callback on click (or double-click if `DoubleClick = true`) |
| `DoubleClick` | `boolean` | `false` | Require a second click within ~1 s to fire |
| `Disabled` | `boolean` | `false` | Start disabled |
| `Visible` | `boolean` | `true` | Initial visibility |
| `Tooltip` | `string` | `nil` | Hover tooltip |
| `IconName` | `string` | `nil` | Icon to show beside text |
| `IconSide` | `"Left"/"Right"` | `"Left"` | Which side the icon appears on |
| `IconColor` | `Color3` | `nil` | Override icon color (nil = follow AccentColor) |

#### Methods

```lua
local btn = Groupbox:AddButton({ Text = "Teleport", Func = function() end })
btn:SetDisabled(true)
btn:SetVisible(false)
```

#### Example

```lua
-- Simple button
Group:AddButton("Teleport to Spawn", function()
    -- run action
end)

-- Double-click (safe delete)
Group:AddButton({
    Text        = "Delete Character",
    DoubleClick = true,
    Func        = function()
        game.Players.LocalPlayer.Character:Destroy()
    end,
})

-- Button with icon
Group:AddButton({
    Text     = "Copy Position",
    IconName = "clipboard",
    Func     = function()
        setclipboard(tostring(game.Players.LocalPlayer.Character.PrimaryPart.Position))
    end,
})
```

---

### Slider

A numeric range input.

```lua
Groupbox:AddSlider(Idx, Info)
```

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `Text` | `string` | — | Label text |
| `Default` | `number` | — | Initial value |
| `Min` | `number` | — | Minimum value |
| `Max` | `number` | — | Maximum value |
| `Rounding` | `number` | `0` | Decimal places (0 = integer) |
| `Suffix` | `string` | `nil` | Unit appended to display (e.g. `"px"`, `"%"`) |
| `Compact` | `boolean` | `false` | Compact display mode (no separate value label) |
| `Callback` | `function(val)` | `nil` | Fires on change |
| `Disabled` | `boolean` | `false` | Start disabled |
| `Visible` | `boolean` | `true` | Initial visibility |
| `Tooltip` | `string` | `nil` | Hover tooltip |

#### Methods

```lua
local s = Groupbox:AddSlider("WalkSpeed", { ... })
s:SetValue(25)
s:SetDisabled(true)
s.Value   -- current number
```

#### Example

```lua
Group:AddSlider("WalkSpeed", {
    Text     = "Walk Speed",
    Default  = 16,
    Min      = 1,
    Max      = 100,
    Rounding = 0,
    Suffix   = " st/s",
    Callback = function(val)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = val
    end,
})

Group:AddSlider("FOV", {
    Text     = "FOV",
    Default  = 70,
    Min      = 1,
    Max      = 120,
    Rounding = 1,
    Compact  = true,
    Callback = function(val)
        workspace.CurrentCamera.FieldOfView = val
    end,
})
```

---

### Dropdown

A single-select or multi-select dropdown list.

```lua
Groupbox:AddDropdown(Idx, Info)
```

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `Text` | `string` | — | Label text |
| `Values` | `table` | — | List of string options |
| `Default` | `any` | `1` | Initial selected value (string, or index) |
| `AllowNull` | `boolean` | `false` | Allow no selection (`nil` value) |
| `Multi` | `boolean` | `false` | Multi-select mode |
| `Searchable` | `boolean` | `false` | Show a search box inside the list |
| `SpecialType` | `"Player"/"Team"` | `nil` | Auto-populate with player/team names |
| `ExcludeLocalPlayer` | `boolean` | `false` | When `SpecialType = "Player"`, exclude self |
| `ReturnInstanceInstead` | `boolean` | `false` | Return Player/Team Instance instead of name |
| `MaxVisibleDropdownItems` | `number` | `8` | Clamp 4–16 visible items before scrolling |
| `Callback` | `function(val)` | `nil` | Fires on selection change |
| `Disabled` | `boolean` | `false` | Start disabled |
| `Visible` | `boolean` | `true` | Initial visibility |
| `Tooltip` | `string` | `nil` | Hover tooltip |
| `DisabledValues` | `table` | `{}` | Values that are shown but unselectable |

#### Methods

```lua
local d = Groupbox:AddDropdown("Weapon", { ... })

d:SetValue("AK47")          -- set a single value
d:SetValue({ "AK47", "M4" }) -- set multi-select
d:SetValues({ "AK47", "M4", "Pistol" }) -- update the option list
d:SetDisabled(true)
d.Value                     -- string (single) or table of strings (multi)
```

#### Examples

```lua
-- Simple dropdown
Group:AddDropdown("HitPart", {
    Text   = "Hit Part",
    Values = { "Head", "Torso", "Random" },
    Default = "Head",
    Callback = function(val) end,
})

-- Multi-select
Group:AddDropdown("IgnoreList", {
    Text   = "Ignore Players",
    Values = { "PlayerA", "PlayerB", "PlayerC" },
    Multi  = true,
    AllowNull = true,
    Callback = function(selected)
        -- selected is a table: { "PlayerA" = true, ... }
    end,
})

-- Auto-populated player list
Group:AddDropdown("Target", {
    Text        = "Target Player",
    SpecialType = "Player",
    AllowNull   = true,
    Callback = function(player)
        -- player is a Player Instance when ReturnInstanceInstead = true
    end,
    ReturnInstanceInstead = true,
})
```

---

### ColorPicker

An HSV color picker with optional gradient editing and transparency.

```lua
Groupbox:AddColorPicker(Idx, Info)
-- ColorPickers are usually chained from a Toggle or Label:
Toggle:AddColorPicker(Idx, Info)
Label:AddColorPicker(Idx, Info)
```

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `Title` | `string` | — | Shown inside the picker popup |
| `Default` | `Color3\|ColorSequence` | `Color3.new(1,1,1)` | Initial color or gradient |
| `Transparency` | `number` | `0` | Initial transparency (0–1) |
| `Callback` | `function(val, transparency)` | `nil` | Fires on change |
| `AllowGradient` | `boolean` | `false` | Enable gradient editing mode |

#### Gradient Mode

When `AllowGradient = true`, the picker shows a gradient preview bar below the color controls.

- **Click the gradient bar** — selects the nearest colour stop and opens the colour picker for it.
- **"+" button** (next to the "Gradient" label) — inserts a new stop at the midpoint to the right of the selected stop.
- **Drag a stop handle** — repositions the stop along the gradient.
- **Right-click a stop handle** — deletes that stop (minimum 2 stops always remain).
- **Right-click the colour preview square** — opens a context menu: copy/paste gradient, copy stop hex/RGB.

The `Callback` receives a `ColorSequence` value instead of a `Color3` when in gradient mode.

#### Methods

```lua
local cp = Toggle:AddColorPicker("AimColor", { ... })

cp:SetValueRGB(Color3.fromRGB(255, 0, 0))                -- set by Color3
cp:SetValue({ Hue, Sat, Vib }, Transparency)              -- set by HSV table
cp:SetValue(ColorSequence.new(...))                        -- set gradient (AllowGradient only)
cp:SetDisabled(true)
cp.Value                                                   -- Color3 or ColorSequence
cp.Transparency                                            -- number 0–1
```

#### Examples

```lua
-- Simple color picker chained to a toggle
Group:AddToggle("ESPEnabled", {
    Text = "ESP",
    Default = false,
    Callback = function(val) end,
}):AddColorPicker("ESPColor", {
    Title    = "ESP Color",
    Default  = Color3.fromRGB(255, 50, 50),
    Callback = function(color)
        -- update ESP color
    end,
})

-- With transparency
Group:AddToggle("Chams", { Text = "Chams", Default = false, Callback = function() end })
    :AddColorPicker("ChamsColor", {
        Title        = "Chams Color",
        Default      = Color3.fromRGB(0, 120, 255),
        Transparency = true,
        Callback = function(color, transparency)
            -- transparency = 0 (fully opaque) to 1 (fully transparent)
        end,
    })

-- Gradient mode
Group:AddColorPicker("SkyGradient", {
    Title        = "Sky Gradient",
    Default      = ColorSequence.new(Color3.fromRGB(0,0,0), Color3.fromRGB(100,100,255)),
    AllowGradient = true,
    Callback = function(sequence)
        -- sequence is a ColorSequence
    end,
})
```

---

### KeyPicker

A keybind input. Supports toggle and hold modes, modifier keys, and optional UI visibility.

```lua
Label:AddKeyPicker(Idx, Info)
Toggle:AddKeyPicker(Idx, Info)
```

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `Text` | `string` | — | Shown in the keybind prompt |
| `Default` | `string` | — | Default key name, e.g. `"F"`, `"Delete"` |
| `Mode` | `"Toggle"/"Hold"/"Press"` | `"Toggle"` | How the keybind fires |
| `NoUI` | `boolean` | `false` | Hide the keybind box from the UI |
| `SyncToggleState` | `boolean` | `false` | When `Mode = "Toggle"`, sync the key state to the parent Toggle value |
| `Callback` | `function()` | `nil` | Fires when the bind is activated |
| `ChangedCallback` | `function(key)` | `nil` | Fires when the bound key changes |
| `Disabled` | `boolean` | `false` | Start disabled |
| `Visible` | `boolean` | `true` | Initial visibility |

#### Modes

| Mode | Behaviour |
|------|-----------|
| `"Toggle"` | Press key → toggle the bound toggle on/off |
| `"Hold"` | Hold key → true; release → false (fires Callback with state) |
| `"Press"` | Single press → fire Callback once |

#### Methods

```lua
local kp = Label:AddKeyPicker("FeatureBind", { ... })

kp:SetValue({ "F", "Toggle", {} })   -- { key, mode, modifiers }
kp:SetDisabled(true)
kp.Value       -- key name string
kp.Mode        -- mode string
kp.Modifiers   -- table of modifier key names
```

#### Example

```lua
-- Keybind visible in UI, synced to a toggle
Group:AddToggle("Fly", {
    Text    = "Fly",
    Default = false,
    Callback = function(val) end,
}):AddKeyPicker("FlyBind", {
    Text             = "Fly",
    Default          = "F",
    Mode             = "Toggle",
    SyncToggleState  = true,
})

-- Hidden keybind (MenuBind pattern)
Group:AddLabel("Menu Bind"):AddKeyPicker("MenuBind", {
    Default = "RightShift",
    NoUI    = true,
    Text    = "Menu Bind",
})
Library.ToggleKeybind = Library.Options.MenuBind

-- Press mode keybind
Group:AddLabel("Teleport"):AddKeyPicker("TpBind", {
    Default  = "T",
    Mode     = "Press",
    Callback = function()
        -- teleport action
    end,
})
```

---

### Input

A text input box.

```lua
Groupbox:AddInput(Idx, Info)
```

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `Text` | `string` | — | Label shown above the box |
| `Default` | `string` | `""` | Initial text |
| `Numeric` | `boolean` | `false` | Only allow numeric characters |
| `Finished` | `boolean` | `false` | Fire Callback only when Enter is pressed (vs. every keystroke) |
| `Placeholder` | `string` | `nil` | Placeholder text when empty |
| `Callback` | `function(text)` | `nil` | Fires on input |
| `Disabled` | `boolean` | `false` | Start disabled |
| `Visible` | `boolean` | `true` | Initial visibility |
| `Tooltip` | `string` | `nil` | Hover tooltip |

#### Methods

```lua
local inp = Groupbox:AddInput("PlayerName", { ... })
inp:SetValue("NewText")
inp.Value   -- current string
```

#### Example

```lua
Group:AddInput("ServerPort", {
    Text        = "Port",
    Default     = "8080",
    Numeric     = true,
    Finished    = true,
    Placeholder = "Enter port...",
    Callback = function(text)
        print("Port set to:", text)
    end,
})
```

---

### Label

A static text line. Can also be used as an anchor to chain Addons (KeyPicker, ColorPicker).

```lua
Groupbox:AddLabel(Text, DoesWrap)
```

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `Text` | `string` | — | Label content |
| `DoesWrap` | `boolean` | `false` | Allow text wrapping to multiple lines |

#### Methods

```lua
local lbl = Groupbox:AddLabel("Hello World")
lbl:SetText("Updated text")
```

#### Chaining Addons

```lua
Groupbox:AddLabel("Keybind"):AddKeyPicker("MyBind", { ... })
Groupbox:AddLabel("Color"):AddColorPicker("MyColor", { ... })
```

---

### Divider

A horizontal rule to visually separate element groups.

```lua
Groupbox:AddDivider()
```

No parameters. Just inserts a thin horizontal line.

---

## Addons (Chaining)

Most interactive elements support chaining additional controls via `:AddColorPicker()` and `:AddKeyPicker()`.
The addon appears inline with the parent element, right-aligned.

### ColorPicker Addon

```lua
Toggle:AddColorPicker(Idx, Info)
Label:AddColorPicker(Idx, Info)
```

Any `ColorPicker` fields apply. The picker is registered in `Library.Options[Idx]`.

### KeyPicker Addon

```lua
Toggle:AddKeyPicker(Idx, Info)
Label:AddKeyPicker(Idx, Info)
```

Any `KeyPicker` fields apply. Picker registered in `Library.Options[Idx]`.

### Chaining Multiple Addons

```lua
Group:AddToggle("Feature", {
    Text    = "Feature",
    Default = false,
    Callback = function(val) end,
})
    :AddColorPicker("FeatureColor", {
        Title    = "Color",
        Default  = Color3.fromRGB(255, 100, 0),
        Callback = function(color) end,
    })
    :AddKeyPicker("FeatureBind", {
        Text    = "Feature",
        Default = "G",
        Mode    = "Toggle",
    })
```

---

## DependencyBox

A container that shows or hides its children based on the state of other elements.

```lua
local Depbox = Groupbox:AddDependencyBox()

-- or nested (DependencyBox inside a DependencyBox)
local InnerDepbox = Depbox:AddDependencyBox()
```

Add elements to the depbox just like a groupbox:

```lua
Depbox:AddToggle("SubToggle", { ... })
Depbox:AddSlider("SubSlider", { ... })
Depbox:AddDropdown("SubDropdown", { ... })
```

### SetupDependencies

After adding all children, declare the visibility condition:

```lua
Depbox:SetupDependencies({
    { Library.Toggles.SomeToggle, true },       -- visible when SomeToggle = true
    { Library.Options.SomeDropdown, "Value" },  -- visible when SomeDropdown = "Value"
})
```

Each entry is `{ element, expectedValue }`. All conditions must match for the depbox to be visible (AND logic).

### Full Example

```lua
Group:AddToggle("UseCustomSpeed", {
    Text    = "Custom Speed",
    Default = false,
    Callback = function(val) end,
})

local SpeedDepbox = Group:AddDependencyBox()

SpeedDepbox:AddSlider("CustomSpeed", {
    Text    = "Walk Speed",
    Default = 16,
    Min = 1, Max = 200, Rounding = 0,
    Callback = function(val) end,
})
SpeedDepbox:AddDropdown("SpeedMode", {
    Text   = "Speed Mode",
    Values = { "Walk", "Run", "Sprint" },
    Default = "Walk",
    Callback = function(val) end,
})

local SpeedModeDepbox = SpeedDepbox:AddDependencyBox()
SpeedModeDepbox:AddSlider("SprintMultiplier", {
    Text = "Sprint Multiplier", Default = 2, Min = 1, Max = 5, Rounding = 1,
    Callback = function(val) end,
})
SpeedModeDepbox:SetupDependencies({ { Library.Options.SpeedMode, "Sprint" } })

SpeedDepbox:SetupDependencies({ { Library.Toggles.UseCustomSpeed, true } })
```

---

## Notifications

```lua
-- Simple (string, optional timeout)
Library:Notify("Done!")
Library:Notify("Done!", 3)

-- Full options
Library:Notify({
    Title       = "My Script",           -- bold heading
    Description = "Feature activated!",  -- body text
    Time        = 5,                      -- seconds (default 5)
    Icon        = "check",               -- optional icon (see Icons section)
    IconColor   = Color3.new(0, 1, 0),  -- override icon color
    SoundId     = "rbxassetid://0",     -- optional sound
    Persist     = false,                 -- if true, stays until manually dismissed
})
```

### Notification Position

Notifications are placed at `(NotificationPositionX%, NotificationPositionY%)` of the screen.

```lua
Library.NotificationPositionX = 95    -- near right edge
Library.NotificationPositionY = 50    -- vertically centered
Library.NotificationAlignment = "Right"
Library.NotificationBarSide   = "Bottom"
Library:UpdateNotificationAreas()
```

---

## Dialogs

Modal dialogs block interaction with the rest of the UI.

```lua
local dialog = Window:AddDialog(Idx, Info)
```

| Field | Type | Description |
|-------|------|-------------|
| `Title` | `string` | Bold heading |
| `Description` | `string` | Body text (wraps) |
| `TitleColor` | `Color3` | Override title text color |
| `DescriptionColor` | `Color3` | Override description text color |
| `OutsideClickDismiss` | `boolean` | Close when clicking outside |
| `AutoDismiss` | `boolean` | Auto-close when any button is clicked (default `true`) |
| `FooterButtons` | `table` | Pre-declared buttons (see below) |

### Footer Buttons

```lua
dialog:AddFooterButton(ButtonIdx, {
    Title    = "Confirm",
    Variant  = "Primary",    -- "Primary" | "Secondary" | "Destructive" | "Ghost"
    WaitTime = 3,            -- seconds before the button becomes active
    Order    = 1,            -- layout order
    Callback = function(dialog)
        -- dialog is the Dialog object
        -- dialog:Dismiss() is called automatically unless AutoDismiss = false
    end,
})
```

### Full Example

```lua
local dialog = Window:AddDialog("ConfirmReset", {
    Title       = "Reset Settings",
    Description = "Are you sure you want to reset all settings? This cannot be undone.",
    OutsideClickDismiss = false,
    AutoDismiss = false,
})

dialog:AddFooterButton("Cancel", {
    Title   = "Cancel",
    Variant = "Secondary",
    Order   = 1,
    Callback = function(d)
        d:Dismiss()
    end,
})
dialog:AddFooterButton("Confirm", {
    Title    = "Reset",
    Variant  = "Destructive",
    WaitTime = 2,   -- must wait 2 seconds before clicking
    Order    = 2,
    Callback = function(d)
        -- reset logic here
        d:Dismiss()
    end,
})
```

### Methods

```lua
dialog:Dismiss()                           -- close the dialog
dialog:SetTitle("New Title")
dialog:SetDescription("New Description")
dialog:SetButtonDisabled("ButtonIdx", true)
dialog:RemoveFooterButton("ButtonIdx")
dialog:Resize()                            -- recalculate layout
```

---

## ThemeManager

The ThemeManager addon adds a fully-featured theme UI to your script.

### Setup

```lua
ThemeManager:SetLibrary(Library)
ThemeManager:SetFolder("MyScript")    -- saves themes in MyScript/themes/
ThemeManager:ApplyTheme("Default")   -- apply built-in theme on start
```

### Building the UI Section

```lua
ThemeManager:BuildThemeSection(Tabs.UISettings)
```

This adds a "Themes" groupbox with:
- Theme list dropdown (built-in and custom)
- Accent / Background / Main / Outline / Font color pickers
- Save / Load / Delete custom theme buttons
- Animated rainbow/gradient theme toggle

### API

```lua
ThemeManager:ApplyTheme("Default")     -- apply a named built-in theme
ThemeManager:ApplyTheme("Midnight")
ThemeManager:ApplyTheme("Rose")

ThemeManager:SaveCustomTheme("MyTheme")
ThemeManager:LoadCustomTheme("MyTheme")
```

---

## SaveManager

The SaveManager addon provides JSON-based config persistence.

### Setup

```lua
SaveManager:SetLibrary(Library)
SaveManager:SetFolder("MyScript")       -- root folder (default "LinoriaLibSettings")
SaveManager:SetSubFolder("configs")     -- optional subfolder inside root/settings/
SaveManager:IgnoreThemeSettings()       -- don't save theme colors (handled by ThemeManager)
```

### Manual Save & Load

```lua
local ok, err = SaveManager:Save("myconfig")
if not ok then warn("Save failed:", err) end

local ok, err = SaveManager:Load("myconfig")
if not ok then warn("Load failed:", err) end

SaveManager:Delete("myconfig")

local list = SaveManager:RefreshConfigList()  -- returns table of config names
```

### Building the UI Section

```lua
SaveManager:BuildConfigSection(Tabs.UISettings)
```

Adds a "Configuration" groupbox with:
- Config name input + create button
- Config list dropdown + load / overwrite / delete / refresh buttons
- Autosave and autoload pickers
- Reset autosave / autoload buttons

### Ignoring Specific Keys

```lua
SaveManager:SetIgnoreIndexes({ "MySlider", "SomeToggle" })
```

### Language Saving

SaveManager automatically saves the active language in the config JSON.
When loading a config whose saved language differs from the current language,
a dialog appears:

> *"This configuration was saved with the language 'ES'. Would you like to switch to it?"*
>
> **Yes — apply language** / **No — keep current**

The config objects are always applied regardless of the choice.

### Parser Reference

Internally, SaveManager registers parsers for each element type.
Supported types: `Toggle`, `Slider`, `Dropdown`, `ColorPicker` (including gradients), `KeyPicker`, `Input`.

---

## MenuManager

The MenuManager addon adds a standard "Menu" and "Notifications" UI in your UI Settings tab.

### Setup

```lua
MenuManager:SetLibrary(Library)
```

### Building the Section

```lua
local TabBox = MenuManager:BuildMenuSection(Tabs.UISettings)
```

This creates a left-aligned tabbox with two pages:

#### Menu Page
- **Lowercase Mode** toggle
- **Custom Cursor** toggle + color picker (cursor color)
- **Cursor Type** dropdown: Mouse / Dot / Plus
  - Dot sub-options: scale, outline, outline thickness
  - Plus sub-options: spacing, individual bars, outline, outline thickness
- **Controller Support** toggle
  - Controller Navigation dropdown (Dpad / Joystick)
- **Menu Bind** label + key picker
- **Panic** section (only when `Library.AllowPanic = true`):
  - Panic Armed toggle + keybind
- **Unload** button (double-click)
- **Panic** button (double-click; disabled when no panic functions registered)

#### Notifications Page
- Force Color toggle + accent / outline / font color pickers
- Animated Bar toggle
- Bar Side dropdown
- Position X slider + Position Y slider (compact)
- Alignment dropdown
- Test Message input + Send Notification button

### Methods

```lua
-- After building, these are accessible on the MenuManager object:
MenuManager.MenuTab     -- the Menu page object
MenuManager.NotifTab    -- the Notifications page object
MenuManager.TabBox      -- the outer tabbox
MenuManager.PanicButton -- the Panic button (use :SetDisabled to control it)
```

### Full Usage Example

```lua
ThemeManager:BuildThemeSection(Tabs.UISettings)
SaveManager:BuildConfigSection(Tabs.UISettings)
MenuManager:BuildMenuSection(Tabs.UISettings)
```

---

## Icons

Icons appear alongside tab buttons, sub-tab buttons, and buttons via `IconName`.

### Usage

```lua
-- Tab icon
local Tab = Window:AddTab("Combat", "sword")

-- SubTab icon
local SubTab = Tab:AddTab("Aim", "crosshair")

-- Button icon
Group:AddButton({
    Text     = "Copy",
    IconName = "clipboard",
    IconSide = "Left",   -- "Left" | "Right"
})
```

### Icon Color Priority

1. `IconColor` on the element call — per-element override
2. `Library.IconColor` — global override (set to `nil` by default)
3. `Library.AccentColor` — automatic fallback (default when both above are `nil`)

```lua
-- All icons follow AccentColor (default behaviour)
Library.IconColor = nil

-- Force all icons to a specific color globally
Library.IconColor = Color3.fromRGB(255, 255, 255)

-- Per-element icon color
Window:AddTab("Main", "home")            -- follows AccentColor
Window:AddTab("Debug", "bug", Color3.fromRGB(255, 80, 80))  -- pinned red
```

### Available Icons

Below is the full icon set. Pass the key string as `IconName`.

```
home          search        settings       gear
user          users         star           heart
check         x             plus           minus
arrow-up      arrow-down    arrow-left     arrow-right
chevron-up    chevron-down  chevron-left   chevron-right
eye           eye-off       lock           unlock
bell          bell-off      info           warning
alert         error         question       help
trash         delete        edit           pencil
save          copy          clipboard      paste
upload        download      refresh        sync
link          external      share          send
mail          message       chat           comment
phone         camera        image          video
music         volume        volume-mute    volume-low
play          pause         stop           skip
rewind        fast-forward  shuffle        repeat
folder        file          document       code
terminal      database      server         cloud
wifi          bluetooth     signal         battery
monitor       laptop        phone          tablet
gamepad       controller    keyboard       mouse
crosshair     sword         shield         bomb
gun           knife         bow            axe
run           walk          jump           fly
map           pin           compass        navigation
clock         timer         calendar       date
sun           moon          weather        snow
fire          water         earth          wind
skull         ghost         robot          alien
flag          tag           bookmark       label
grid          list          menu           sidebar
maximize      minimize      fullscreen     window
zoom-in       zoom-out      fit            crop
rotate        flip          move           drag
filter        sort          group          stack
chart         graph         bar-chart      pie-chart
dollar        coin          gem            trophy
gift          bag           cart           store
wrench        hammer        drill          tool
bulb          idea          rocket         plane
car           truck         bike           boat
```

> **Note:** Not all icons may be loaded in every environment. If an icon name is not found,
> the element renders as if no icon was specified.

---

## Tooltips

Any element that accepts a `Tooltip` field will show a hover tooltip.

```lua
Group:AddToggle("Aimbot", {
    Text    = "Aimbot",
    Default = false,
    Tooltip = "Automatically aim at the nearest player",
    Callback = function(val) end,
})

Group:AddButton({
    Text            = "Panic",
    DoubleClick     = true,
    Tooltip         = "Double-click to disable all features",
    DisabledTooltip = "No panic functions registered",
    Func            = function() Library:Panic() end,
})
```

A `DisabledTooltip` can also be provided — it shows only when the element is in its disabled state.

---

## Events & Hooks

### OnChanged

Listen for any element's value change:

```lua
local toggle = Groupbox:AddToggle("Fly", { ... })
local conn = toggle:OnChanged(function()
    print("Fly is now:", toggle.Value)
end)

-- Remove when done
conn:Disconnect()
```

### OnUnload

Register cleanup logic:

```lua
Library:OnUnload(function()
    RunService:UnbindFromRenderStep("MyStep")
    connection:Disconnect()
    Library.Unloaded = true
end)
```

### GiveSignal

All RBXScriptConnections created inside the library should use `Library:GiveSignal()` so
they are properly disconnected on `Library:Unload()`:

```lua
Library:GiveSignal(
    RunService.Heartbeat:Connect(function()
        -- runs until library unloads
    end)
)
```

### OnLanguageChanged

```lua
Library:OnLanguageChanged(function(langCode)
    if langCode == "fr" then
        -- update any non-registered labels
    end
end)
```

---

## Complete Full Example

A comprehensive end-to-end script demonstrating all major features:

```lua
local repo         = "https://raw.githubusercontent.com/SoNotClose/SnowFallV2/main/"
local Library      = loadstring(game:HttpGet(repo .. "Library.lua"))()
local MenuManager  = loadstring(game:HttpGet(repo .. "addons/MenuManager.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager  = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Options = Library.Options
local Toggles = Library.Toggles

-- ── Window ────────────────────────────────────────────────────────────────────
local Window = Library:CreateWindow({
    Title        = "SnowFall Demo",
    SubTitle     = "v2.0",
    GameTitle    = "My Game",
    Center       = true,
    AutoShow     = true,
    Resizable    = true,
    AllowPanic   = false,   -- will be set to true automatically when RegisterPanic toggles are added
    MenuFadeTime = 0.2,
})

-- ── Tabs ──────────────────────────────────────────────────────────────────────
local Tabs = {
    Combat    = Window:AddTab("Combat",    "sword"),
    Visuals   = Window:AddTab("Visuals",   "eye"),
    Misc      = Window:AddTab("Misc",      "settings"),
    UISettings = Window:AddTab("UI"),
}

-- ── SubTabs ───────────────────────────────────────────────────────────────────
local CombatSubs = {
    Aim      = Tabs.Combat:AddTab("Aim"),
    Movement = Tabs.Combat:AddTab("Movement"),
}

-- ── Groupboxes ────────────────────────────────────────────────────────────────
local AimLeft    = CombatSubs.Aim:AddLeftGroupbox("Aimbot")
local AimRight   = CombatSubs.Aim:AddRightGroupbox("Filters")
local MovLeft    = CombatSubs.Movement:AddLeftGroupbox("Speed / Jump")
local VisLeft    = Tabs.Visuals:AddLeftGroupbox("ESP")
local VisRight   = Tabs.Visuals:AddRightGroupbox("Chams")
local MiscLeft   = Tabs.Misc:AddLeftGroupbox("Utilities")
local MiscRight  = Tabs.Misc:AddRightGroupbox("Info")

-- ── Aimbot ────────────────────────────────────────────────────────────────────
AimLeft:AddToggle("Aimbot", {
    Text          = "Aimbot",
    Default       = false,
    RegisterPanic = true,
    Callback = function(val)
        -- aimbot logic
    end,
}):AddKeyPicker("AimbotBind", {
    Text    = "Aimbot",
    Default = "Q",
    Mode    = "Hold",
})

AimLeft:AddDivider()

AimLeft:AddSlider("AimbotFOV", {
    Text     = "FOV",
    Default  = 80,
    Min = 1, Max = 360, Rounding = 0,
    Suffix   = "°",
    Callback = function(val) end,
})

AimLeft:AddSlider("AimbotSmoothing", {
    Text     = "Smoothing",
    Default  = 5,
    Min = 0, Max = 20, Rounding = 1,
    Callback = function(val) end,
})

AimLeft:AddDropdown("AimbotPart", {
    Text    = "Hit Part",
    Values  = { "Head", "Torso", "Nearest" },
    Default = "Head",
    Callback = function(val) end,
})

-- Filters on right
AimRight:AddDropdown("AimbotTarget", {
    Text        = "Target",
    SpecialType = "Player",
    AllowNull   = true,
    Callback = function(player) end,
    ReturnInstanceInstead = true,
})

AimRight:AddToggle("AimbotTeamCheck", {
    Text    = "Team Check",
    Default = true,
    Callback = function(val) end,
})

-- ── Movement ─────────────────────────────────────────────────────────────────
MovLeft:AddToggle("SpeedHack", {
    Text          = "Speed Hack",
    Default       = false,
    RegisterPanic = true,
    Callback = function(val) end,
})

local SpeedDepbox = MovLeft:AddDependencyBox()
SpeedDepbox:AddSlider("WalkSpeed", {
    Text     = "Walk Speed",
    Default  = 16,
    Min = 1, Max = 200, Rounding = 0,
    Callback = function(val)
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = val
        end
    end,
})
SpeedDepbox:SetupDependencies({ { Toggles.SpeedHack, true } })

MovLeft:AddDivider()

MovLeft:AddToggle("Fly", {
    Text          = "Fly",
    Default       = false,
    RegisterPanic = true,
    Callback = function(val) end,
}):AddKeyPicker("FlyBind", {
    Text    = "Fly",
    Default = "F",
    Mode    = "Toggle",
    SyncToggleState = true,
})

-- ── ESP ───────────────────────────────────────────────────────────────────────
VisLeft:AddToggle("ESPEnabled", {
    Text    = "Enable ESP",
    Default = false,
    Callback = function(val) end,
}):AddColorPicker("ESPColor", {
    Title    = "ESP Color",
    Default  = Color3.fromRGB(255, 50, 50),
    Callback = function(color) end,
})

local ESPDepbox = VisLeft:AddDependencyBox()
ESPDepbox:AddToggle("ESPBoxes",     { Text = "Boxes",    Default = true, Callback = function() end })
ESPDepbox:AddToggle("ESPNames",     { Text = "Names",    Default = true, Callback = function() end })
ESPDepbox:AddToggle("ESPDistance",  { Text = "Distance", Default = false, Callback = function() end })
ESPDepbox:SetupDependencies({ { Toggles.ESPEnabled, true } })

-- ── Chams ─────────────────────────────────────────────────────────────────────
VisRight:AddToggle("ChamsEnabled", {
    Text    = "Enable Chams",
    Default = false,
    Callback = function(val) end,
}):AddColorPicker("ChamsColor", {
    Title        = "Chams Color",
    Default      = Color3.fromRGB(0, 80, 255),
    Transparency = true,
    Callback = function(color, transparency) end,
})

-- ── Misc ──────────────────────────────────────────────────────────────────────
MiscLeft:AddButton({
    Text        = "Rejoin Server",
    DoubleClick = true,
    Tooltip     = "Double-click to rejoin",
    Func = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId)
    end,
})

MiscLeft:AddInput("ServerNote", {
    Text        = "Note",
    Default     = "",
    Placeholder = "Write anything...",
    Callback = function(text) end,
})

MiscLeft:AddDivider()

MiscLeft:AddLabel("Panic Bind"):AddKeyPicker("CustomPanic", {
    Default  = "End",
    Mode     = "Press",
    Callback = function()
        Library:Panic()
    end,
})

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
MenuManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()
SaveManager:SetSubFolder("SnowFallDemo")
ThemeManager:SetFolder("SnowFallDemo")
ThemeManager:ApplyTheme("Default")

ThemeManager:BuildThemeSection(Tabs.UISettings)
SaveManager:BuildConfigSection(Tabs.UISettings)
MenuManager:BuildMenuSection(Tabs.UISettings)

Library:SetupLanguage("es", {
    Aimbot          = { Text = "Apuntador" };
    AimbotFOV       = { Text = "Campo de visión" };
    AimbotSmoothing = { Text = "Suavidad" };
    AimbotPart      = { Text = "Parte objetivo", Values = { "Cabeza", "Torso", "Más cercana" } };
    SpeedHack       = { Text = "Truco de velocidad" };
    WalkSpeed       = { Text = "Velocidad" };
    Fly             = { Text = "Volar" };
    ESPEnabled      = { Text = "Activar ESP" };
})

Library:OnUnload(function()
    Library.Unloaded = true
    -- disconnect your connections here
end)
```
