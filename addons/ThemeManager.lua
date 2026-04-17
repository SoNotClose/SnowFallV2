local cloneref = (cloneref or clonereference or function(instance: any)
    return instance
end)
local clonefunction = (clonefunction or copyfunction or function(func) 
    return func 
end)

local httprequest = request or http_request or (http and http.request)
local getassetfunc = getcustomasset

local HttpService: HttpService = cloneref(game:GetService("HttpService"))
local RunService: RunService = cloneref(game:GetService("RunService"))
local isfolder, isfile, listfiles = isfolder, isfile, listfiles

local assert = function(condition, errorMessage)
    if (not condition) then
        error(if errorMessage then errorMessage else "assert failed", 3)
    end
end

if typeof(clonefunction) == "function" then
    local
        isfolder_copy,
        isfile_copy,
        listfiles_copy = clonefunction(isfolder), clonefunction(isfile), clonefunction(listfiles)

    local isfolder_success, isfolder_error = pcall(function()
        return isfolder_copy("test" .. tostring(math.random(1000000, 9999999)))
    end)

    if isfolder_success == false or typeof(isfolder_error) ~= "boolean" then
        isfolder = function(folder)
            local success, data = pcall(isfolder_copy, folder)
            return (if success then data else false)
        end

        isfile = function(file)
            local success, data = pcall(isfile_copy, file)
            return (if success then data else false)
        end

        listfiles = function(folder)
            local success, data = pcall(listfiles_copy, folder)
            return (if success then data else {})
        end
    end
end

local ThemeManager = {} do
    local ThemeFields = { "FontColor", "MainColor", "AccentColor", "BackgroundColor", "OutlineColor" }
    ThemeManager.Folder = "ECLinoriaLibSettings"
    ThemeManager.Library = nil
    ThemeManager.CurrentTheme = "Default"
    ThemeManager.DefaultThemeName = "Default"

    ThemeManager.BuiltInThemes = {
        ['Default']     = { 1, { FontColor = "ffffff", MainColor = "1c1c1c", AccentColor = "0055ff", BackgroundColor = "141414", OutlineColor = "323232" } },
        ['BBot']        = { 2, { FontColor = "ffffff", MainColor = "1e1e1e", AccentColor = "7e48a3", BackgroundColor = "232323", OutlineColor = "141414" } },
        ['Fatality']    = { 3, { FontColor = "ffffff", MainColor = "1e1842", AccentColor = "c50754", BackgroundColor = "191335", OutlineColor = "3c355d" } },
        ['Jester']      = { 4, { FontColor = "ffffff", MainColor = "242424", AccentColor = "db4467", BackgroundColor = "1c1c1c", OutlineColor = "373737" } },
        ['Mint']        = { 5, { FontColor = "ffffff", MainColor = "242424", AccentColor = "3db488", BackgroundColor = "1c1c1c", OutlineColor = "373737" } },
        ['Tokyo Night'] = { 6, { FontColor = "ffffff", MainColor = "191925", AccentColor = "6759b3", BackgroundColor = "16161f", OutlineColor = "323232" } },
        ['Ubuntu']      = { 7, { FontColor = "ffffff", MainColor = "3e3e3e", AccentColor = "e2581e", BackgroundColor = "323232", OutlineColor = "191919" } },
        ['Quartz']      = { 8, { FontColor = "ffffff", MainColor = "232330", AccentColor = "426e87", BackgroundColor = "1d1b26", OutlineColor = "27232f" } },
    }

    local AnimatedThemes = { "Rainbow", "Dark Matter", "Red Inferno" }
    local AnimationConnection = nil
    local CurrentAnimatedTheme = nil
    local AnimationClock = 0

    local CurrentThemeLabel = nil
    local DefaultThemeLabel = nil

    local function UpdateThemeLabels()
        if CurrentThemeLabel then
            CurrentThemeLabel:SetText("Current Theme: " .. tostring(ThemeManager.CurrentTheme))
        end
        if DefaultThemeLabel then
            DefaultThemeLabel:SetText("Default Theme: " .. tostring(ThemeManager.DefaultThemeName))
        end
    end

    local function SetColorPickersDisabled(disabled)
        if not ThemeManager.Library then return end
        local Options = ThemeManager.Library.Options
        local colorPickerKeys = { "BackgroundColor", "MainColor", "AccentColor", "OutlineColor", "FontColor" }
        for _, key in ipairs(colorPickerKeys) do
            if Options[key] and Options[key].SetDisabled then
                Options[key]:SetDisabled(disabled)
            end
        end
    end

    local function ApplyColors(colors)
        local lib = ThemeManager.Library
        if not lib then return end

        if colors.AccentColor then
            lib.AccentColor = colors.AccentColor
            lib.AccentColorDark = lib:GetDarkerColor(colors.AccentColor)
        end
        if colors.MainColor       then lib.MainColor       = colors.MainColor       end
        if colors.BackgroundColor then lib.BackgroundColor = colors.BackgroundColor end
        if colors.OutlineColor    then lib.OutlineColor    = colors.OutlineColor    end
        if colors.FontColor       then lib.FontColor       = colors.FontColor       end

        lib:UpdateColorsUsingRegistry()
    end

    local function StopAnimation()
        if AnimationConnection then
            AnimationConnection:Disconnect()
            AnimationConnection = nil
        end
        CurrentAnimatedTheme = nil
        AnimationClock = 0
        SetColorPickersDisabled(false)
    end

    local function StartAnimation(themeName)
        StopAnimation()
        CurrentAnimatedTheme = themeName
        SetColorPickersDisabled(true)

        local lib = ThemeManager.Library

        if themeName == "Rainbow" then
            AnimationConnection = RunService.RenderStepped:Connect(function(delta)
                if not ThemeManager.Library then return end
                AnimationClock = AnimationClock + delta

                local speed = 1
                if lib.Options["ThemeManager_RainbowSpeed"] then
                    speed = lib.Options["ThemeManager_RainbowSpeed"].Value or 1
                end

                local hue    = (AnimationClock * speed * 0.1) % 1
                local accent = Color3.fromHSV(hue, 0.8, 1)
                local bgHue  = (hue + 0.5) % 1
                local bg     = Color3.fromHSV(bgHue, 0.6, 0.12)
                local main   = Color3.fromHSV(bgHue, 0.5, 0.18)
                local outline = Color3.fromHSV(hue, 0.4, 0.3)

                ApplyColors({
                    AccentColor     = accent,
                    BackgroundColor = bg,
                    MainColor       = main,
                    OutlineColor    = outline,
                })
            end)

        elseif themeName == "Dark Matter" then
            AnimationConnection = RunService.RenderStepped:Connect(function(delta)
                if not ThemeManager.Library then return end
                AnimationClock = AnimationClock + delta

                local speed = 1
                if lib.Options["ThemeManager_RainbowSpeed"] then
                    speed = lib.Options["ThemeManager_RainbowSpeed"].Value or 1
                end

                local pulse      = (math.sin(AnimationClock * speed * 0.8) + 1) / 2
                local accentHue  = 0.77
                local accent     = Color3.fromHSV(accentHue, 0.85, 0.35 + pulse * 0.55)
                local bg         = Color3.fromHSV(accentHue, 0.6,  0.04 + pulse * 0.07)
                local main       = Color3.fromHSV(accentHue, 0.5,  0.08 + pulse * 0.07)
                local outline    = Color3.fromHSV(accentHue, 0.4,  0.12 + pulse * 0.10)

                ApplyColors({
                    AccentColor     = accent,
                    BackgroundColor = bg,
                    MainColor       = main,
                    OutlineColor    = outline,
                })
            end)

        elseif themeName == "Red Inferno" then
            AnimationConnection = RunService.RenderStepped:Connect(function(delta)
                if not ThemeManager.Library then return end
                AnimationClock = AnimationClock + delta

                local speed = 1
                if lib.Options["ThemeManager_RainbowSpeed"] then
                    speed = lib.Options["ThemeManager_RainbowSpeed"].Value or 1
                end

                local pulse      = (math.sin(AnimationClock * speed * 0.6) + 1) / 2
                local accentHue  = pulse * 0.08
                local accent     = Color3.fromHSV(accentHue, 1, 1)
                local bg         = Color3.fromHSV(0.02, 0.8,  0.06 + pulse * 0.06)
                local main       = Color3.fromHSV(0.02, 0.7,  0.10 + pulse * 0.06)
                local outline    = Color3.fromHSV(accentHue, 0.6, 0.22 + pulse * 0.10)

                ApplyColors({
                    AccentColor     = accent,
                    BackgroundColor = bg,
                    MainColor       = main,
                    OutlineColor    = outline,
                })
            end)
        end
    end

    local WebThemeCache = nil

    local function FetchWebThemes()
        if WebThemeCache then return WebThemeCache end
        if not httprequest then return {} end

        local success, result = pcall(httprequest, {
            Url    = "https://api.github.com/repos/SoNotClose/SnowFallV2/contents/web/themes",
            Method = "GET",
        })

        if not success or typeof(result) ~= "table" or typeof(result.Body) ~= "string" then return {} end

        local ok, decoded = pcall(HttpService.JSONDecode, HttpService, result.Body)
        if not ok or typeof(decoded) ~= "table" then return {} end

        local themes = {}
        for _, entry in ipairs(decoded) do
            if typeof(entry.name) == "string" and entry.name:sub(-5) == ".json" then
                themes[#themes + 1] = entry.name:sub(1, -6)
            end
        end

        WebThemeCache = themes
        return themes
    end

    local function DownloadWebTheme(name)
        if not httprequest or not writefile then return false, "missing functions" end

        local url     = "https://raw.githubusercontent.com/silence-lol/Enhanced-LinoriaLib/main/extras/themes/" .. name .. ".json"
        local success, result = pcall(httprequest, { Url = url, Method = "GET" })

        if not success or typeof(result) ~= "table" or typeof(result.Body) ~= "string" then
            return false, "request failed"
        end

        local ok = pcall(HttpService.JSONDecode, HttpService, result.Body)
        if not ok then return false, "invalid JSON" end

        ThemeManager:CheckFolderTree()
        writefile(ThemeManager.Folder .. "/themes/" .. name .. ".json", result.Body)
        return true
    end

    -- local function ApplyBackgroundVideo(videoLink) ... end  (commented out - unused)

    function ThemeManager:SetLibrary(library)
        self.Library = library
    end

    function ThemeManager:GetPaths()
        local paths = {}
        local parts = self.Folder:split('/')
        for idx = 1, #parts do
            paths[#paths + 1] = table.concat(parts, '/', 1, idx)
        end
        paths[#paths + 1] = self.Folder .. '/themes'
        return paths
    end

    function ThemeManager:BuildFolderTree()
        local paths = self:GetPaths()
        for i = 1, #paths do
            local str = paths[i]
            if isfolder(str) then continue end
            makefolder(str)
        end
    end

    function ThemeManager:CheckFolderTree()
        if isfolder(self.Folder) then return end
        self:BuildFolderTree()
        task.wait(0.1)
    end

    function ThemeManager:SetFolder(folder)
        self.Folder = folder
        self:BuildFolderTree()
    end

    function ThemeManager:IsAnimatedTheme(name)
        return table.find(AnimatedThemes, name) ~= nil
    end

    function ThemeManager:ApplyTheme(theme)
        if not theme or theme == '' then return end

        if self:IsAnimatedTheme(theme) then
            StartAnimation(theme)
            ThemeManager.CurrentTheme = theme
            UpdateThemeLabels()
            return
        end

        local customThemeData = self:GetCustomTheme(theme)
        local data = customThemeData or self.BuiltInThemes[theme]
        if not data then return end

        StopAnimation()

        if self.Library.InnerVideoBackground ~= nil then
            self.Library.InnerVideoBackground.Visible = false
        end

        local scheme = customThemeData or data[2]
        for idx, col in next, scheme do
            if idx == "VideoLink" then continue end
            self.Library[idx] = Color3.fromHex(col)
            if self.Library.Options[idx] then
                self.Library.Options[idx]:SetValueRGB(Color3.fromHex(col))
            end
        end

        self:ThemeUpdate()

        ThemeManager.CurrentTheme = theme
        UpdateThemeLabels()
    end

    function ThemeManager:ThemeUpdate()
        if self.Library.InnerVideoBackground ~= nil then
            self.Library.InnerVideoBackground.Visible = false
        end

        for _, field in next, ThemeFields do
            if self.Library.Options and self.Library.Options[field] then
                self.Library[field] = self.Library.Options[field].Value
            end
        end

        self.Library.AccentColorDark = self.Library:GetDarkerColor(self.Library.AccentColor)
        self.Library:UpdateColorsUsingRegistry()
    end

    function ThemeManager:GetCustomTheme(file)
        local path = self.Folder .. '/themes/' .. file .. '.json'
        if not isfile(path) then return nil end

        local data = readfile(path)
        local success, decoded = pcall(HttpService.JSONDecode, HttpService, data)
        if not success then return nil end

        return decoded
    end

    function ThemeManager:LoadDefault()
        local theme   = 'Default'
        local content = isfile(self.Folder .. '/themes/default.txt') and readfile(self.Folder .. '/themes/default.txt')

        local isBuiltIn = true
        if content then
            if self:IsAnimatedTheme(content) then
                self.Library.Options.ThemeManager_AnimatedThemeList:SetValue(content)
                ThemeManager.DefaultThemeName = content
                UpdateThemeLabels()
                StartAnimation(content)
                return
            elseif self.BuiltInThemes[content] then
                theme = content
            elseif self:GetCustomTheme(content) then
                theme     = content
                isBuiltIn = false
            end
        elseif self.BuiltInThemes[self.DefaultTheme] then
            theme = self.DefaultTheme
        end

        ThemeManager.DefaultThemeName = theme
        UpdateThemeLabels()

        if isBuiltIn then
            self.Library.Options.ThemeManager_ThemeList:SetValue(theme)
        else
            self:ApplyTheme(theme)
        end
    end

    function ThemeManager:SaveDefault(theme)
        ThemeManager.DefaultThemeName = theme
        UpdateThemeLabels()
        writefile(self.Folder .. '/themes/default.txt', theme)
    end

    function ThemeManager:SaveCustomTheme(file)
        if file:gsub(' ', '') == '' then
            self.Library:Notify('Invalid file name for theme (empty)', 3)
            return
        end

        local theme = {}
        for _, field in next, ThemeFields do
            if self.Library.Options[field] then
                theme[field] = self.Library.Options[field].Value:ToHex()
            end
        end

        writefile(self.Folder .. '/themes/' .. file .. '.json', HttpService:JSONEncode(theme))
    end

    function ThemeManager:Delete(name)
        if not name then return false, 'no config file is selected' end

        local file = self.Folder .. '/themes/' .. name .. '.json'
        if not isfile(file) then return false, 'invalid file' end

        local success = pcall(delfile, file)
        if not success then return false, 'delete file error' end

        return true
    end

    function ThemeManager:ReloadCustomThemes()
        local list = listfiles(self.Folder .. '/themes')

        local out = {}
        for i = 1, #list do
            local file = list[i]
            if file:sub(-5) == '.json' then
                local pos   = file:find('.json', 1, true)
                local start = pos
                local char  = file:sub(pos, pos)

                while char ~= '/' and char ~= '\\' and char ~= '' do
                    pos  = pos - 1
                    char = file:sub(pos, pos)
                end

                if char == '/' or char == '\\' then
                    table.insert(out, file:sub(pos + 1, start - 1))
                end
            end
        end

        return out
    end

    local function GetCurrentlySelectedTheme(lib)
        local animated = lib.Options.ThemeManager_AnimatedThemeList.Value
        local builtin  = lib.Options.ThemeManager_ThemeList.Value
        local custom   = lib.Options.ThemeManager_CustomThemeList.Value

        if animated and animated ~= '' then return animated end
        if builtin  and builtin  ~= '' then return builtin  end
        if custom   and custom   ~= '' then return custom   end
        return nil
    end

    function ThemeManager:CreateThemeManager(groupbox)
        groupbox:AddLabel('Background color'):AddColorPicker('BackgroundColor', { Default = self.Library.BackgroundColor })
        groupbox:AddLabel('Main color')      :AddColorPicker('MainColor',       { Default = self.Library.MainColor })
        groupbox:AddLabel('Accent color')    :AddColorPicker('AccentColor',     { Default = self.Library.AccentColor })
        groupbox:AddLabel('Outline color')   :AddColorPicker('OutlineColor',    { Default = self.Library.OutlineColor })
        groupbox:AddLabel('Font color')      :AddColorPicker('FontColor',       { Default = self.Library.FontColor })
        groupbox:AddLabel('Risk color')      :AddColorPicker('RiskColor',       { Default = self.Library.RiskColor })

        groupbox:AddToggle('ThemeManager_AutoSetTheme', { Text = 'Auto Set Theme', Default = true })

        local SetThemeButton = groupbox:AddButton('Set Theme', function()
            local theme = GetCurrentlySelectedTheme(self.Library)
            if not theme then
                self.Library:Notify('No theme selected', 2)
                return
            end
            self:ApplyTheme(theme)
            self.Library:Notify(string.format('Applied theme: %s', theme), 2)
        end)
        SetThemeButton:SetVisible(false)

        self.Library.Toggles.ThemeManager_AutoSetTheme:OnChanged(function()
            SetThemeButton:SetVisible(not self.Library.Toggles.ThemeManager_AutoSetTheme.Value)
        end)

        groupbox:AddButton('Set As Default', function()
            local theme = GetCurrentlySelectedTheme(self.Library)
            if not theme then
                self.Library:Notify('No theme selected', 2)
                return
            end
            self:SaveDefault(theme)
            self.Library:Notify(string.format('Set default theme to %q', theme))
        end)

        groupbox:AddDivider()

        local ctLabel = groupbox:AddLabel('Current Theme: ' .. tostring(self.CurrentTheme),  true)
        local dtLabel = groupbox:AddLabel('Default Theme: ' .. tostring(self.DefaultThemeName), true)
        CurrentThemeLabel = ctLabel
        DefaultThemeLabel = dtLabel

        groupbox:AddDivider()

        local ThemesArray = {}
        for Name, _ in next, self.BuiltInThemes do
            table.insert(ThemesArray, Name)
        end
        table.sort(ThemesArray, function(a, b) return self.BuiltInThemes[a][1] < self.BuiltInThemes[b][1] end)

        groupbox:AddDropdown('ThemeManager_ThemeList', {
            Text    = 'Default Theme List',
            Values  = ThemesArray,
            Default = 1,
        })

        self.Library.Options.ThemeManager_ThemeList:OnChanged(function()
            if self.Library.Toggles.ThemeManager_AutoSetTheme.Value then
                self.Library.Options.ThemeManager_AnimatedThemeList:SetValue(nil)
                self.Library.Options.ThemeManager_CustomThemeList:SetValue(nil)
                self:ApplyTheme(self.Library.Options.ThemeManager_ThemeList.Value)
            end
        end)

        groupbox:AddDivider()

        groupbox:AddDropdown('ThemeManager_AnimatedThemeList', {
            Text      = 'Animated Theme List',
            Values    = AnimatedThemes,
            AllowNull = true,
            Default   = 1,
        })

        local RainbowSpeedSlider = groupbox:AddSlider('ThemeManager_RainbowSpeed', {
            Text     = 'Animation Speed',
            Default  = 1,
            Min      = 1,
            Max      = 10,
            Rounding = 1,
            Visible  = false,
        })

        self.Library.Options.ThemeManager_AnimatedThemeList:OnChanged(function()
            local selected = self.Library.Options.ThemeManager_AnimatedThemeList.Value
            RainbowSpeedSlider:SetVisible(selected ~= nil and selected ~= '')

            if self.Library.Toggles.ThemeManager_AutoSetTheme.Value then
                if selected and selected ~= '' then
                    -- clear other lists
                    self.Library.Options.ThemeManager_ThemeList:SetValue(nil)
                    self.Library.Options.ThemeManager_CustomThemeList:SetValue(nil)
                    self:ApplyTheme(selected)
                end
            end
        end)

        groupbox:AddDivider()

        local webThemes = FetchWebThemes()
        groupbox:AddDropdown('ThemeManager_WebThemeList', {
            Text      = 'Web Theme List',
            Values    = webThemes,
            AllowNull = true,
            Default   = 1,
        })

        groupbox:AddButton('Refresh Web Themes', function()
            WebThemeCache = nil
            local themes = FetchWebThemes()
            self.Library.Options.ThemeManager_WebThemeList:SetValues(themes)
            self.Library.Options.ThemeManager_WebThemeList:SetValue(nil)
            self.Library:Notify('Refreshed web themes', 2)
        end)

        groupbox:AddButton('Download Theme', function()
            local name = self.Library.Options.ThemeManager_WebThemeList.Value
            if not name or name == '' then
                self.Library:Notify('No web theme selected', 2)
                return
            end

            local success, err = DownloadWebTheme(name)
            if not success then
                self.Library:Notify('Failed to download theme: ' .. tostring(err), 3)
                return
            end

            self.Library:Notify(string.format('Downloaded %q — available in Custom Themes', name), 3)
            self.Library.Options.ThemeManager_CustomThemeList:SetValues(self:ReloadCustomThemes())
            self.Library.Options.ThemeManager_CustomThemeList:SetValue(nil)
        end)

        groupbox:AddDivider()

        groupbox:AddInput('ThemeManager_CustomThemeName', { Text = 'Custom theme name' })
        groupbox:AddButton('Create theme', function()
            local name = self.Library.Options.ThemeManager_CustomThemeName.Value
            if name:gsub(" ", "") == "" then
                self.Library:Notify("Invalid theme name (empty)", 2)
                return
            end

            self:SaveCustomTheme(name)
            self.Library:Notify(string.format("Created theme %q", name))
            self.Library.Options.ThemeManager_CustomThemeList:SetValues(self:ReloadCustomThemes())
            self.Library.Options.ThemeManager_CustomThemeList:SetValue(nil)
        end)

        groupbox:AddDivider()

        groupbox:AddDropdown('ThemeManager_CustomThemeList', {
            Text      = 'Custom themes',
            Values    = self:ReloadCustomThemes(),
            AllowNull = true,
            Default   = 1,
        })

        self.Library.Options.ThemeManager_CustomThemeList:OnChanged(function()
            local selected = self.Library.Options.ThemeManager_CustomThemeList.Value
            if self.Library.Toggles.ThemeManager_AutoSetTheme.Value then
                if selected and selected ~= '' then
                    self.Library.Options.ThemeManager_ThemeList:SetValue(nil)
                    self.Library.Options.ThemeManager_AnimatedThemeList:SetValue(nil)
                    self:ApplyTheme(selected)
                end
            end
        end)

        groupbox:AddButton('Load theme', function()
            local name = self.Library.Options.ThemeManager_CustomThemeList.Value
            if not name or name == '' then self.Library:Notify('No custom theme selected', 2) return end
            self:ApplyTheme(name)
            self.Library:Notify(string.format('Loaded theme %q', name))
        end)
        groupbox:AddButton('Overwrite theme', function()
            local name = self.Library.Options.ThemeManager_CustomThemeList.Value
            if not name or name == '' then self.Library:Notify('No custom theme selected', 2) return end
            self:SaveCustomTheme(name)
            self.Library:Notify(string.format('Overwrote theme %q', name))
        end)
        groupbox:AddButton('Delete theme', function()
            local name = self.Library.Options.ThemeManager_CustomThemeList.Value
            if not name or name == '' then self.Library:Notify('No custom theme selected', 2) return end

            local success, err = self:Delete(name)
            if not success then
                self.Library:Notify('Failed to delete theme: ' .. err)
                return
            end

            self.Library:Notify(string.format('Deleted theme %q', name))
            self.Library.Options.ThemeManager_CustomThemeList:SetValues(self:ReloadCustomThemes())
            self.Library.Options.ThemeManager_CustomThemeList:SetValue(nil)
        end)
        groupbox:AddButton('Refresh list', function()
            self.Library.Options.ThemeManager_CustomThemeList:SetValues(self:ReloadCustomThemes())
            self.Library.Options.ThemeManager_CustomThemeList:SetValue(nil)
        end)
        groupbox:AddButton('Reset default', function()
            local success = pcall(delfile, self.Folder .. '/themes/default.txt')
            if not success then
                self.Library:Notify('Failed to reset default: delete file error')
                return
            end

            ThemeManager.DefaultThemeName = "None"
            UpdateThemeLabels()
            self.Library:Notify('Cleared default theme')
            self.Library.Options.ThemeManager_CustomThemeList:SetValues(self:ReloadCustomThemes())
            self.Library.Options.ThemeManager_CustomThemeList:SetValue(nil)
        end)

        self:LoadDefault()

        local function UpdateTheme() self:ThemeUpdate() end
        self.Library.Options.BackgroundColor:OnChanged(UpdateTheme)
        self.Library.Options.MainColor:OnChanged(UpdateTheme)
        self.Library.Options.AccentColor:OnChanged(UpdateTheme)
        self.Library.Options.OutlineColor:OnChanged(UpdateTheme)
        self.Library.Options.FontColor:OnChanged(UpdateTheme)

        self.Library.Options.RiskColor:OnChanged(function()
            if ThemeManager.Library then
                ThemeManager.Library.RiskColor = ThemeManager.Library.Options.RiskColor.Value
                ThemeManager.Library:UpdateColorsUsingRegistry()
            end
        end)
    end

    function ThemeManager:CreateGroupBox(tab)
        assert(self.Library, 'ThemeManager:CreateGroupBox -> Must set ThemeManager.Library first!')
        return tab:AddLeftGroupbox('Themes')
    end

    function ThemeManager:ApplyToTab(tab)
        assert(self.Library, 'ThemeManager:ApplyToTab -> Must set ThemeManager.Library first!')
        local groupbox = self:CreateGroupBox(tab)
        self:CreateThemeManager(groupbox)
    end

    function ThemeManager:ApplyToGroupbox(groupbox)
        assert(self.Library, 'ThemeManager:ApplyToGroupbox -> Must set ThemeManager.Library first!')
        self:CreateThemeManager(groupbox)
    end

    ThemeManager:BuildFolderTree()
end

getgenv().LinoriaThemeManager = ThemeManager
return ThemeManager
