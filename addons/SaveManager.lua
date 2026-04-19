local cloneref = (cloneref or clonereference or function(instance: any)
    return instance
end)
local clonefunction = (clonefunction or copyfunction or function(func) 
    return func 
end)

local HttpService: HttpService = cloneref(game:GetService("HttpService"))
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

local SaveManager = {} do
    SaveManager.Folder = "LinoriaLibSettings"
    SaveManager.SubFolder = ""
    SaveManager.Ignore = {}
    SaveManager.Library = nil
    SaveManager.Parser = {
        Toggle = {
            Save = function(idx, object)
                return { type = 'Toggle', idx = idx, value = object.Value }
            end,
            Load = function(idx, data)
                local object = SaveManager.Library.Toggles[idx]
                if object and object.Value ~= data.value then
                    object:SetValue(data.value)
                end
            end,
        },
        Slider = {
            Save = function(idx, object)
                return { type = 'Slider', idx = idx, value = tostring(object.Value) }
            end,
            Load = function(idx, data)
                local object = SaveManager.Library.Options[idx]
                if object and object.Value ~= data.value then
                    object:SetValue(data.value)
                end
            end,
        },
        Dropdown = {
            Save = function(idx, object)
                return { type = 'Dropdown', idx = idx, value = object.Value, multi = object.Multi }
            end,
            Load = function(idx, data)
                local object = SaveManager.Library.Options[idx]
                if object and object.Value ~= data.value then
                    object:SetValue(data.value)
                end
            end,
        },
        ColorPicker = {
            Save = function(idx, object)
                return { type = 'ColorPicker', idx = idx, value = object.Value:ToHex(), transparency = object.Transparency }
            end,
            Load = function(idx, data)
                if SaveManager.Library.Options[idx] then
                    SaveManager.Library.Options[idx]:SetValueRGB(Color3.fromHex(data.value), data.transparency)
                end
            end,
        },
        KeyPicker = {
            Save = function(idx, object)
                return { type = 'KeyPicker', idx = idx, mode = object.Mode, key = object.Value, modifiers = object.Modifiers }
            end,
            Load = function(idx, data)
                if SaveManager.Library.Options[idx] then
                    SaveManager.Library.Options[idx]:SetValue({ data.key, data.mode, data.modifiers })
                end
            end,
        },
        Input = {
            Save = function(idx, object)
                return { type = 'Input', idx = idx, text = object.Value }
            end,
            Load = function(idx, data)
                local object = SaveManager.Library.Options[idx]
                if object and object.Value ~= data.text and type(data.text) == 'string' then
                    SaveManager.Library.Options[idx]:SetValue(data.text)
                end
            end,
        },
    }

    local AutoSaveConnections = {}

    local function ClearAutoSaveConnections()
        for _, conn in ipairs(AutoSaveConnections) do
            if conn and conn.Connected then
                conn:Disconnect()
            end
        end
        AutoSaveConnections = {}
    end

function SaveManager:SetLibrary(library)
        self.Library = library
    end

    function SaveManager:IgnoreThemeSettings()
        self:SetIgnoreIndexes({
            "BackgroundColor", "MainColor", "AccentColor", "OutlineColor", "FontColor",
            "RiskColor",
            "ThemeManager_ThemeList", "ThemeManager_CustomThemeList", "ThemeManager_CustomThemeName",
            "ThemeManager_AnimatedThemeList", "ThemeManager_WebThemeList",
            "ThemeManager_RainbowSpeed",
            "VideoLink",
        })
    end

    function SaveManager:CheckSubFolder(createFolder)
        if typeof(self.SubFolder) ~= "string" or self.SubFolder == "" then return false end

        if createFolder == true then
            if not isfolder(self.Folder .. "/settings/" .. self.SubFolder) then
                makefolder(self.Folder .. "/settings/" .. self.SubFolder)
            end
        end

        return true
    end

    function SaveManager:GetPaths()
        local paths = {}

        local parts = self.Folder:split('/')
        for idx = 1, #parts do
            local path = table.concat(parts, '/', 1, idx)
            if not table.find(paths, path) then paths[#paths + 1] = path end
        end

        paths[#paths + 1] = self.Folder .. '/themes'
        paths[#paths + 1] = self.Folder .. '/settings'

        if self:CheckSubFolder(false) then
            local subFolder = self.Folder .. "/settings/" .. self.SubFolder
            parts = subFolder:split('/')

            for idx = 1, #parts do
                local path = table.concat(parts, '/', 1, idx)
                if not table.find(paths, path) then paths[#paths + 1] = path end
            end
        end

        return paths
    end

    function SaveManager:BuildFolderTree()
        local paths = self:GetPaths()
        for i = 1, #paths do
            local str = paths[i]
            if isfolder(str) then continue end
            makefolder(str)
        end
    end

    function SaveManager:CheckFolderTree()
        if isfolder(self.Folder) then return end
        SaveManager:BuildFolderTree()
        task.wait(0.1)
    end

    function SaveManager:SetIgnoreIndexes(list)
        for _, key in next, list do
            self.Ignore[key] = true
        end
    end

    function SaveManager:SetFolder(folder)
        self.Folder = folder
        self:BuildFolderTree()
    end

    function SaveManager:SetSubFolder(folder)
        self.SubFolder = folder
        self:BuildFolderTree()
    end

    function SaveManager:Save(name)
        if not name then return false, 'no config file is selected' end
        SaveManager:CheckFolderTree()

        local fullPath = self.Folder .. '/settings/' .. name .. '.json'
        if SaveManager:CheckSubFolder(true) then
            fullPath = self.Folder .. "/settings/" .. self.SubFolder .. "/" .. name .. '.json'
        end

        local data = { objects = {} }

        for idx, toggle in next, self.Library.Toggles do
            if not toggle.Type then continue end
            if not self.Parser[toggle.Type] then continue end
            if self.Ignore[idx] then continue end
            table.insert(data.objects, self.Parser[toggle.Type].Save(idx, toggle))
        end

        for idx, option in next, self.Library.Options do
            if not option.Type then continue end
            if not self.Parser[option.Type] then continue end
            if self.Ignore[idx] then continue end
            table.insert(data.objects, self.Parser[option.Type].Save(idx, option))
        end

        local success, encoded = pcall(HttpService.JSONEncode, HttpService, data)
        if not success then return false, 'failed to encode data' end

        writefile(fullPath, encoded)
        return true
    end

    function SaveManager:Load(name)
        if not name then return false, 'no config file is selected' end
        SaveManager:CheckFolderTree()

        local file = self.Folder .. '/settings/' .. name .. '.json'
        if SaveManager:CheckSubFolder(true) then
            file = self.Folder .. "/settings/" .. self.SubFolder .. "/" .. name .. '.json'
        end

        if not isfile(file) then return false, 'invalid file' end

        local success, decoded = pcall(HttpService.JSONDecode, HttpService, readfile(file))
        if not success then return false, 'decode error' end

        for _, option in next, decoded.objects do
            if not option.type then continue end
            if not self.Parser[option.type] then continue end
            if self.Ignore[option.idx] then continue end
            task.spawn(self.Parser[option.type].Load, option.idx, option)
        end

        return true
    end

    function SaveManager:Delete(name)
        if not name then return false, 'no config file is selected' end

        local file = self.Folder .. '/settings/' .. name .. '.json'
        if SaveManager:CheckSubFolder(true) then
            file = self.Folder .. "/settings/" .. self.SubFolder .. "/" .. name .. '.json'
        end

        if not isfile(file) then return false, 'invalid file' end

        local success = pcall(delfile, file)
        if not success then return false, 'delete file error' end

        return true
    end

    function SaveManager:RefreshConfigList()
        local success, data = pcall(function()
            SaveManager:CheckFolderTree()

            local list = {}
            local out  = {}

            if SaveManager:CheckSubFolder(true) then
                list = listfiles(self.Folder .. "/settings/" .. self.SubFolder)
            else
                list = listfiles(self.Folder .. "/settings")
            end
            if typeof(list) ~= "table" then list = {} end

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
        end)

        if not success then
            if self.Library then
                self.Library:Notify('Failed to load config list: ' .. tostring(data))
            else
                warn('Failed to load config list: ' .. tostring(data))
            end
            return {}
        end

        return data
    end

    function SaveManager:BuildConfigSection(tab)
        assert(self.Library, 'SaveManager:BuildConfigSection -> Must set SaveManager.Library')

        local AutoLoadConfig = ''
        local AutoSaveConfig = ''
        local prefsFile = self.Folder .. '/autosave_prefs.json'

        local function SaveAutoPrefs()
            local prefs = {
                autoLoadConfig = AutoLoadConfig,
                autoSaveConfig = AutoSaveConfig,
            }
            local ok, encoded = pcall(HttpService.JSONEncode, HttpService, prefs)
            if ok then pcall(writefile, prefsFile, encoded) end
        end

        local section = tab:AddRightGroupbox('Configuration')

        section:AddInput('SaveManager_ConfigName', { Text = 'Config name' })
        section:AddButton('Create config', function()
            local name = self.Library.Options.SaveManager_ConfigName.Value

            if name:gsub(' ', '') == '' then
                self.Library:Notify('Invalid config name (empty)', 2)
                return
            end

            local success, err = self:Save(name)
            if not success then
                self.Library:Notify('Failed to create config: ' .. err)
                return
            end

            self.Library:Notify(string.format('Created config %q', name))
            self.Library.Options.SaveManager_ConfigList:SetValues(self:RefreshConfigList())
            self.Library.Options.SaveManager_ConfigList:SetValue(nil)
        end)

        section:AddDivider()

        section:AddDropdown('SaveManager_ConfigList', { Text = 'Config list', Values = self:RefreshConfigList(), AllowNull = true })
        section:AddButton('Load config', function()
            local name = self.Library.Options.SaveManager_ConfigList.Value

            local success, err = self:Load(name)
            if not success then
                self.Library:Notify('Failed to load config: ' .. err)
                return
            end

            self.Library:Notify(string.format('Config %q loaded', name))
        end)
        section:AddButton('Overwrite config', function()
            local name = self.Library.Options.SaveManager_ConfigList.Value

            local success, err = self:Save(name)
            if not success then
                self.Library:Notify('Failed to overwrite config: ' .. err)
                return
            end

            self.Library:Notify(string.format('Overwrote config %q', name))
        end)
        section:AddButton('Delete config', function()
            local name = self.Library.Options.SaveManager_ConfigList.Value

            local success, err = self:Delete(name)
            if not success then
                self.Library:Notify('Failed to delete config: ' .. err)
                return
            end

            self.Library:Notify(string.format('Deleted config %q', name))
            self.Library.Options.SaveManager_ConfigList:SetValues(self:RefreshConfigList())
            self.Library.Options.SaveManager_ConfigList:SetValue(nil)
        end)
        section:AddButton('Refresh list', function()
            local configs = self:RefreshConfigList()
            self.Library.Options.SaveManager_ConfigList:SetValues(configs)
            self.Library.Options.SaveManager_ConfigList:SetValue(nil)
        end)

        self.AutoSaveLabel = section:AddLabel('Autosave: None')
        self.AutoloadConfigLabel = section:AddLabel('Autoload: None')

        section:AddButton('Set as autosave', function()
            local name = self.Library.Options.SaveManager_ConfigList.Value
            if not name or name == '' then
                self.Library:Notify('Select a config from the list first', 2)
                return
            end
            AutoSaveConfig = name
            self.AutoSaveLabel:SetText('Autosave: ' .. name)
            SaveAutoPrefs()
            self.Library:Notify(string.format('Autosave config set to %q', name))
        end)
        section:AddButton('Set as autoload', function()
            local name = self.Library.Options.SaveManager_ConfigList.Value
            if not name or name == '' then
                self.Library:Notify('Select a config from the list first', 2)
                return
            end
            AutoLoadConfig = name
            self.AutoloadConfigLabel:SetText('Autoload: ' .. name)
            SaveAutoPrefs()
            self.Library:Notify(string.format('Autoload config set to %q', name))
        end)
        section:AddButton('Reset autosave', function()
            AutoSaveConfig = ''
            self.AutoSaveLabel:SetText('Autosave: None')
            SaveAutoPrefs()
            self.Library:Notify('Autosave config cleared')
        end)
        section:AddButton('Reset autoload', function()
            AutoLoadConfig = ''
            self.AutoloadConfigLabel:SetText('Autoload: None')
            SaveAutoPrefs()
            self.Library:Notify('Autoload config cleared')
        end)

        task.defer(function()
            ClearAutoSaveConnections()

            local lib = self.Library

            local function DoAutoSave()
                if AutoSaveConfig == '' then return end
                SaveManager:Save(AutoSaveConfig)
            end

            for idx, toggle in next, lib.Toggles do
                if not SaveManager.Ignore[idx] and idx:sub(1, 12) ~= 'SaveManager_' then
                    local ok, conn = pcall(function()
                        return toggle:OnChanged(DoAutoSave)
                    end)
                    if ok and conn then
                        table.insert(AutoSaveConnections, conn)
                    end
                end
            end

            for idx, option in next, lib.Options do
                if not SaveManager.Ignore[idx] and idx:sub(1, 12) ~= 'SaveManager_' then
                    local ok, conn = pcall(function()
                        return option:OnChanged(DoAutoSave)
                    end)
                    if ok and conn then
                        table.insert(AutoSaveConnections, conn)
                    end
                end
            end

            task.wait()

            if isfile(prefsFile) then
                local ok, decoded = pcall(function()
                    return HttpService:JSONDecode(readfile(prefsFile))
                end)
                if ok and decoded then
                    AutoLoadConfig = decoded.autoLoadConfig or ''
                    AutoSaveConfig = decoded.autoSaveConfig or ''
                    self.AutoSaveLabel:SetText('Autosave: ' .. (AutoSaveConfig ~= '' and AutoSaveConfig or 'None'))
                    self.AutoloadConfigLabel:SetText('Autoload: ' .. (AutoLoadConfig ~= '' and AutoLoadConfig or 'None'))
                end
            end

            if AutoLoadConfig ~= '' then
                local success, err = self:Load(AutoLoadConfig)
                if success then
                    self.Library:Notify(string.format('Auto-loaded config %q', AutoLoadConfig))
                else
                    self.Library:Notify('Failed to auto-load config: ' .. tostring(err))
                end
            end
        end)

        self:SetIgnoreIndexes({
            'SaveManager_ConfigList',
            'SaveManager_ConfigName',
        })
    end

    SaveManager:BuildFolderTree()
end

return SaveManager
