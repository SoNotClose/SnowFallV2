-- read doc
local repo = "https://raw.githubusercontent.com/SoNotClose/SnowFallV2/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local MenuManager = loadstring(game:HttpGet(repo .. "addons/MenuManager.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Options = Library.Options
local Toggles = Library.Toggles

local Window = Library:CreateWindow({
    Title = "Example",
	TitleSide = "Middle"
	-- GameTitle = "" -- also has a side
    Center = true,
    AutoShow = true,
    Resizable = true,
    NotifySide = "Middle",
    TabPadding = 8,
    MenuFadeTime = 0.2,
})

local Tabs = {
    Main        = Window:AddTab("Main"),
    Features    = Window:AddTab("Features"),
    UISettings  = Window:AddTab("UI Settings"),
}

-- Main tab
local LeftGroup = Tabs.Main:AddLeftGroupbox("Controls")

LeftGroup:AddToggle("MyToggle", {
    Text = "Toggle",
    Default = false,
    Callback = function(val)
        print("MyToggle:", val)
    end,
}):AddColorPicker("ToggleColor", {
    Default = Color3.fromRGB(255, 80, 80),
    Title = "Toggle Color",
    Transparency = 0,
    Callback = function(val)
        print("ToggleColor:", val)
    end,
})

LeftGroup:AddSlider("MySlider", {
    Text = "Slider",
    Default = 50,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Compact = false,
    Callback = function(val)
        print("MySlider:", val)
    end,
})

LeftGroup:AddSlider("SubSliderExample", {
    Text = "Width",
    Default = 50,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Compact = false,
}):AddSlider("SubSliderExample2", {
    Text = "Height",
    Default = 50,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Compact = false,
})

LeftGroup:AddSlider("SubSliderCompact", {
    Text = "X",
    Default = 0,
    Min = -100,
    Max = 100,
    Rounding = 1,
    Compact = true,
}):AddSlider("SubSliderCompact2", {
    Text = "Y",
    Default = 0,
    Min = -100,
    Max = 100,
    Rounding = 1,
    Compact = true,
})

LeftGroup:AddInput("MyInput", {
    Text = "Input",
    Default = "",
    Numeric = false,
    Finished = false,
    Placeholder = "Type here...",
    Callback = function(val)
        print("MyInput:", val)
    end,
})

LeftGroup:AddDivider()

local MainBtn = LeftGroup:AddButton({
    Text = "Notify",
    Func = function()
        Library:Notify({ Title = "Example"; Description = "Button clicked!"; Time = 3 })
    end,
})

MainBtn:AddButton({
    Text = "Sub Button",
    Func = function()
        Library:Notify("Sub button clicked!", 3)
    end,
    DoubleClick = true,
})

LeftGroup:AddDivider()

LeftGroup:AddLabel("Keybind"):AddKeyPicker("MyKeybind", {
    Default = "MB2",
    Mode = "Toggle",
    Text = "My Feature",
    NoUI = false,
    Callback = function(val)
        print("MyKeybind state:", val)
    end,
    ChangedCallback = function(key, mods)
        print("MyKeybind changed:", key, table.unpack(mods or {}))
    end,
})

-- Right groupbox
local RightGroup = Tabs.Main:AddRightGroupbox("Color Pickers")

RightGroup:AddLabel("Standard Picker"):AddColorPicker("StandardColor", {
    Default = Color3.fromRGB(100, 180, 255),
    Title = "Standard Color",
    Transparency = 0,
    Callback = function(val)
        print("StandardColor:", val)
    end,
})

RightGroup:AddLabel("Gradient Picker"):AddColorPicker("GradientColor", {
    Default = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 80, 80)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(80, 255, 80)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 80, 255)),
    }),
    Title = "Gradient Color",
    AllowGradient = true,
    Callback = function(val)
        print("GradientColor:", val)
    end,
})

RightGroup:AddDivider()

RightGroup:AddToggle("DepControl", { Text = "Dependency Control", Default = false })

local Depbox = RightGroup:AddDependencyBox()

Depbox:AddSlider("DepSlider", {
    Text = "Dep Slider",
    Default = 25,
    Min = 0,
    Max = 100,
    Rounding = 0,
})

Depbox:AddDropdown("DepDropdown", {
    Text = "Dep Dropdown",
    Values = { "Option A", "Option B", "Option C" },
    Default = 1,
})

Depbox:SetupDependencies({ { Toggles.DepControl, true } })

-- Features tab
local FeatLeft = Tabs.Features:AddLeftGroupbox("Dropdowns")

FeatLeft:AddDropdown("SingleDrop", {
    Text = "Single Select",
    Values = { "A", "B", "C", "D" },
    Default = 1,
    Searchable = false,
    Callback = function(val)
        print("SingleDrop:", val)
    end,
})

FeatLeft:AddDropdown("SearchDrop", {
    Text = "Searchable",
    Values = { "A", "B", "C", "D", "E", "F", "G" },
    Default = 1,
    Searchable = true,
    Callback = function(val)
        print("SearchDrop:", val)
    end,
})

FeatLeft:AddDropdown("MultiDrop", {
    Text = "Multi Select",
    Values = { "Red", "Green", "Blue", "Yellow" },
    Default = 1,
    Multi = true,
    Callback = function(val)
        print("MultiDrop changed")
    end,
})

FeatLeft:AddDropdown("PlayerDrop", {
    Text = "Player Select",
    SpecialType = "Player",
    ExcludeLocalPlayer = false,
    Callback = function(val)
        print("PlayerDrop:", val)
    end,
})

local FeatRight = Tabs.Features:AddRightTabbox()
local Tab1 = FeatRight:AddTab("Sliders")
local Tab2 = FeatRight:AddTab("Labels")

Tab1:AddSlider("FormatSlider", {
    Text = "Custom Display",
    Default = 0,
    Min = 0,
    Max = 10,
    Rounding = 0,
    FormatDisplayValue = function(slider, val)
        if val == 0 then return "Off" end
        if val == slider.Max then return "Max" end
    end,
})

Tab1:AddSlider("HideMaxSlider", {
    Text = "Hide Max",
    Default = 5,
    Min = 0,
    Max = 100,
    Rounding = 0,
    HideMax = true,
})

Tab2:AddLabel("This is a short label")
Tab2:AddLabel("This label\nspans multiple\nlines!", true)

-- Watermark
Library:SetWatermarkVisibility(true)

local FrameTimer = tick()
local FrameCount = 0
local FPS = 60

game:GetService("RunService").RenderStepped:Connect(function()
    FrameCount += 1
    if tick() - FrameTimer >= 1 then
        FPS = FrameCount
        FrameTimer = tick()
        FrameCount = 0
    end
    Library:SetWatermark(("Example | %d fps"):format(math.floor(FPS)))
end)

Library:OnUnload(function()
    print("Unloaded!")
    Library.Unloaded = true
end)

MenuManager:SetLibrary(Library)
MenuManager:BuildMenuSection(Tabs.UISettings)

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuBind" })

ThemeManager:SetFolder("MyScriptHub")
SaveManager:SetFolder("MyScriptHub/specific-game")

SaveManager:BuildConfigSection(Tabs.UISettings)
ThemeManager:ApplyToTab(Tabs.UISettings)
