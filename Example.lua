local repo = "https://raw.githubusercontent.com/SoNotClose/SnowFallV2/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local MenuManager = loadstring(game:HttpGet(repo .. "addons/MenuManager.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Options = Library.Options
local Toggles = Library.Toggles

local Window = Library:CreateWindow({
    Title = "Example",
    Center = true,
    AutoShow = true,
    Resizable = true,
    NotifySide = "Middle",
    TabPadding = 8,
    MenuFadeTime = 0.2,
})

local Tabs = {
    Main       = Window:AddTab("Main"),
    UISettings = Window:AddTab("UI Settings"),
}

local SubTabs = {
    Elements = Tabs.Main:AddTab("Elements"),
    Features = Tabs.Main:AddTab("Features"),
}

-- Elements subtab
local ElemLeft = SubTabs.Elements:AddLeftGroupbox("Controls")

ElemLeft:AddToggle("MyToggle", {
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

ElemLeft:AddSlider("MySlider", {
    Text = "Slider",
    Default = 50,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Callback = function(val)
        print("MySlider:", val)
    end,
})

ElemLeft:AddSlider("SubSliderA", {
    Text = "Width",
    Default = 50,
    Min = 0,
    Max = 100,
    Rounding = 0,
}):AddSlider("SubSliderB", {
    Text = "Height",
    Default = 50,
    Min = 0,
    Max = 100,
    Rounding = 0,
})

ElemLeft:AddSlider("SubSliderCompactA", {
    Text = "X",
    Default = 0,
    Min = -100,
    Max = 100,
    Rounding = 1,
    Compact = true,
}):AddSlider("SubSliderCompactB", {
    Text = "Y",
    Default = 0,
    Min = -100,
    Max = 100,
    Rounding = 1,
    Compact = true,
})

ElemLeft:AddInput("MyInput", {
    Text = "Input",
    Default = "",
    Numeric = false,
    Finished = false,
    Placeholder = "Type here...",
    Callback = function(val)
        print("MyInput:", val)
    end,
})

ElemLeft:AddDivider()

local MainBtn = ElemLeft:AddButton({
    Text = "Send Notification",
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

ElemLeft:AddDivider()

ElemLeft:AddLabel("Keybind"):AddKeyPicker("MyKeybind", {
    Default = "MB2",
    Mode = "Toggle",
    Text = "My Feature",
    NoUI = false,
    Callback = function(val)
        print("MyKeybind state:", val)
    end,
})

local ElemRight = SubTabs.Elements:AddRightGroupbox("Color Pickers")

ElemRight:AddLabel("Standard"):AddColorPicker("StandardColor", {
    Default = Color3.fromRGB(100, 180, 255),
    Title = "Standard Color",
    Transparency = 0,
    Callback = function(val)
        print("StandardColor:", val)
    end,
})

ElemRight:AddLabel("Gradient"):AddColorPicker("GradientColor", {
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

-- Features subtab
local FeatLeft = SubTabs.Features:AddLeftGroupbox("Dropdowns")

FeatLeft:AddDropdown("SingleDrop", {
    Text = "Single Select",
    Values = { "Alpha", "Beta", "Gamma", "Delta" },
    Default = 1,
    Callback = function(val)
        print("SingleDrop:", val)
    end,
})

FeatLeft:AddDropdown("SearchDrop", {
    Text = "Searchable",
    Values = { "Apple", "Banana", "Cherry", "Date", "Elderberry", "Fig", "Grape" },
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
    Callback = function()
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

local FeatRight = SubTabs.Features:AddRightGroupbox("Dependency Box")

FeatRight:AddToggle("DepControl", {
    Text = "Enable Features",
    Default = false,
})

local Depbox = FeatRight:AddDependencyBox()

Depbox:AddSlider("DepSlider", {
    Text = "Feature Strength",
    Default = 50,
    Min = 0,
    Max = 100,
    Rounding = 0,
})

Depbox:AddDropdown("DepDropdown", {
    Text = "Feature Mode",
    Default = 1,
    Values = { "Mode A", "Mode B", "Mode C" },
})

local SubDepbox = Depbox:AddDependencyBox()

SubDepbox:AddToggle("SubDepToggle", {
    Text = "Sub Feature",
    Default = false,
})

SubDepbox:SetupDependencies({ { Options.DepDropdown, "Mode B" } })
Depbox:SetupDependencies({ { Toggles.DepControl, true } })

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
    Library.Unloaded = true
    print("Unloaded!")
end)

-- UI Settings tab — MenuManager always builds first
MenuManager:SetLibrary(Library)
MenuManager:BuildMenuSection(Tabs.UISettings)

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuBind", "LanguageSelect" })

ThemeManager:SetFolder("MyScriptHub")
SaveManager:SetFolder("MyScriptHub/specific-game")

SaveManager:BuildConfigSection(Tabs.UISettings)
ThemeManager:ApplyToTab(Tabs.UISettings)

-- Register UI labels for language support
-- Tabs and subtabs use SetName callbacks so the button resizes with the new text
Library:RegisterLabel("Tab_Main",     Tabs.Main.ButtonLabel,         function(t) Tabs.Main:SetName(t) end)
Library:RegisterLabel("Tab_UI",       Tabs.UISettings.ButtonLabel,   function(t) Tabs.UISettings:SetName(t) end)
Library:RegisterLabel("SubTab_Elems", SubTabs.Elements.ButtonLabel,  function(t) SubTabs.Elements:SetName(t) end)
Library:RegisterLabel("SubTab_Feats", SubTabs.Features.ButtonLabel,  function(t) SubTabs.Features:SetName(t) end)
-- Groupbox titles are full-width so they don't need resizing
Library:RegisterLabel("Group_Controls",    ElemLeft.TitleLabel)
Library:RegisterLabel("Group_Colors",      ElemRight.TitleLabel)
Library:RegisterLabel("Group_Dropdowns",   FeatLeft.TitleLabel)
Library:RegisterLabel("Group_DepBox",      FeatRight.TitleLabel)

-- Define translations for example elements
Library:SetupLanguage("es", {
    Tab_Main           = "Principal",
    Tab_UI             = "Configuración UI",
    SubTab_Elems       = "Elementos",
    SubTab_Feats       = "Funciones",
    Group_Controls     = "Controles",
    Group_Colors       = "Selectores de Color",
    Group_Dropdowns    = "Listas",
    Group_DepBox       = "Caja de Dependencias",
    MyToggle           = { Text = "Palanca" },
    MySlider           = { Text = "Deslizador" },
    SubSliderA         = { Text = "Ancho" },
    SubSliderB         = { Text = "Altura" },
    SubSliderCompactA  = { Text = "X" },
    SubSliderCompactB  = { Text = "Y" },
    MyInput            = { Text = "Entrada" },
    SingleDrop         = { Text = "Selección única",    Values = { "Alpha", "Beta", "Gamma", "Delta" } },
    SearchDrop         = { Text = "Buscable",           Values = { "Manzana", "Plátano", "Cereza", "Dátil", "Saúco", "Higo", "Uva" } },
    MultiDrop          = { Text = "Selección múltiple", Values = { "Rojo", "Verde", "Azul", "Amarillo" } },
    PlayerDrop         = { Text = "Seleccionar jugador" },
    DepControl         = { Text = "Activar funciones" },
    DepSlider          = { Text = "Intensidad" },
    DepDropdown        = { Text = "Modo",               Values = { "Modo A", "Modo B", "Modo C" } },
    SubDepToggle       = { Text = "Sub función" },
})

Library:SetupLanguage("fr", {
    Tab_Main           = "Principal",
    Tab_UI             = "Paramètres UI",
    SubTab_Elems       = "Éléments",
    SubTab_Feats       = "Fonctionnalités",
    Group_Controls     = "Contrôles",
    Group_Colors       = "Sélecteurs de couleur",
    Group_Dropdowns    = "Listes",
    Group_DepBox       = "Boîte de dépendances",
    MyToggle           = { Text = "Interrupteur" },
    MySlider           = { Text = "Curseur" },
    SubSliderA         = { Text = "Largeur" },
    SubSliderB         = { Text = "Hauteur" },
    SubSliderCompactA  = { Text = "X" },
    SubSliderCompactB  = { Text = "Y" },
    MyInput            = { Text = "Saisie" },
    SingleDrop         = { Text = "Sélection unique",    Values = { "Alpha", "Bêta", "Gamma", "Delta" } },
    SearchDrop         = { Text = "Recherchable",        Values = { "Pomme", "Banane", "Cerise", "Datte", "Sureau", "Figue", "Raisin" } },
    MultiDrop          = { Text = "Sélection multiple",  Values = { "Rouge", "Vert", "Bleu", "Jaune" } },
    PlayerDrop         = { Text = "Choisir joueur" },
    DepControl         = { Text = "Activer fonctions" },
    DepSlider          = { Text = "Intensité" },
    DepDropdown        = { Text = "Mode",                Values = { "Mode A", "Mode B", "Mode C" } },
    SubDepToggle       = { Text = "Sous-fonction" },
})

-- Language dropdown — added to MenuManager's global MenuTab
MenuManager.MenuTab:AddDivider()
MenuManager.MenuTab:AddDropdown("LanguageSelect", {
    Text = "Language",
    Values = { "English", "Español", "Français" },
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
