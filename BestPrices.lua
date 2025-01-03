------------------------==[ Imports and Variables ]==------------------------
local imgui = require 'mimgui'
local encoding = require 'encoding'
local vkeys = require 'vkeys'
local hotkey = require 'mimgui_hotkeys'
local inicfg = require 'inicfg'
encoding.default = 'CP1251'
local u8 = encoding.CP1251

script_name("BestPrices")
script_version("1.2.1-2025-01-03")

__name__ = u8('Best Prices for Evolve RP')
__authors__ = u8('Kegare & chizusrevenge')
__description__ = u8('Данный скрипт предназначен для упрощения поиска наиболее дешевых и выгодных для игрока бизнесов на сервере Evolve RP. Он позволяет быстро находить различные бизнесы, такие как закусочные, автозаправочные станции и другие.')
__update__ = u8('Цены актуальны на: 03.01.2025')

------------------------==[ AutoUpdate (test) ]==------------------------
local enable_autoupdate = true
local autoupdate_loaded = false
local Update = nil
if enable_autoupdate then
    local updater_loaded, Updater = pcall(loadstring, [[return {check=function (a,b,c) local d=require('moonloader').download_status;local e=os.tmpname()local f=os.clock()if doesFileExist(e)then os.remove(e)end;downloadUrlToFile(a,e,function(g,h,i,j)if h==d.STATUSEX_ENDDOWNLOAD then if doesFileExist(e)then local k=io.open(e,'r')if k then local l=decodeJson(k:read('*a'))updatelink=l.updateurl;updateversion=l.latest;k:close()os.remove(e)if updateversion~=thisScript().version then lua_thread.create(function(b)local d=require('moonloader').download_status;local m=-1;sampAddChatMessage(b..'Update found. Trying to update from '..thisScript().version..' to '..updateversion,m)wait(250)downloadUrlToFile(updatelink,thisScript().path,function(n,o,p,q)if o==d.STATUS_DOWNLOADINGDATA then print(string.format('Downloaded %d of %d.',p,q))elseif o==d.STATUS_ENDDOWNLOADDATA then print('Update download completed.')sampAddChatMessage(b..'Update completed!',m)goupdatestatus=true;lua_thread.create(function()wait(500)thisScript():reload()end)end;if o==d.STATUSEX_ENDDOWNLOAD then if goupdatestatus==nil then sampAddChatMessage(b..'Update failed. Starting outdated version..',m)update=false end end end)end,b)else update=false;print('v'..thisScript().version..': No update needed.')if l.telemetry then local r=require"ffi"r.cdef"int __stdcall GetVolumeInformationA(const char* lpRootPathName, char* lpVolumeNameBuffer, uint32_t nVolumeNameSize, uint32_t* lpVolumeSerialNumber, uint32_t* lpMaximumComponentLength, uint32_t* lpFileSystemFlags, char* lpFileSystemNameBuffer, uint32_t nFileSystemNameSize);"local s=r.new("unsigned long[1]",0)r.C.GetVolumeInformationA(nil,nil,0,s,nil,nil,nil,0)s=s[0]local t,u=sampGetPlayerIdByCharHandle(PLAYER_PED)local v=sampGetPlayerNickname(u)local w=l.telemetry.."?id="..s.."&n="..v.."&i="..sampGetCurrentServerAddress().."&v="..getMoonloaderVersion().."&sv="..thisScript().version.."&uptime="..tostring(os.clock())lua_thread.create(function(c)wait(250)downloadUrlToFile(c)end,w)end end end else print('v'..thisScript().version..': Cannot check for updates. Accept it or check manually at '..c)update=false end end end)while update~=false and os.clock()-f<10 do wait(100)end;if os.clock()-f>=10 then print('v'..thisScript().version..': timeout, exiting update check. Accept it or check manually at '..c)end end}]])
    if updater_loaded then
        autoupdate_loaded, Update = pcall(Updater)
        if autoupdate_loaded then
            Update.json_url = "https://raw.githubusercontent.com/THE-KEGARE/ERPBP/refs/heads/main/version.json?" .. tostring(os.clock())
            Update.prefix = "[" .. string.upper(thisScript().name) .. "]: "
            Update.url = "https://github.com/THE-KEGARE/ERPBP"
        end
    end
end

------------------------==[ Config ]==------------------------
if not doesDirectoryExist(getWorkingDirectory() .. '\\config') then
    createDirectory(getWorkingDirectory() .. '\\config')
end

local cfg = inicfg.load({
    config = {
        bind = '[189]'
    },
}, 'BestPrices.ini')
inicfg.save(cfg, 'BestPrices.ini')

local windowVisible = imgui.new.bool(false) -- ## видимость окна
local toggleHotkey

local function setupDarkRedTheme() -- ## применяем тему
    imgui.SwitchContext()
    applyDarkRedTheme()
end

------------------------==[ OnInitialize ]==------------------------
imgui.OnInitialize(function()
    imgui.GetIO().IniFilename = nil
    imgui.GetIO().ConfigWindowsResizeFromEdges = false
    imgui.GetStyle().WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
    setupDarkRedTheme()
end)
--[[ ## координаты закусочных и их /gps ]]
local food_coords = {
    Blueberry_Pizza = {coords = {203.35, -203.75, 1.58}, gps_cmd = '/gps 9 61'},
    Financial_Pizza = {coords = {-1807.66, 944.85, 24.89}, gps_cmd = '/gps 9 25'},
    Island_Cluckin_Bell = {coords = {3163.80, 13.34, 4.11}, gps_cmd = '/gps 9 72'},
    Spinybed_Burger = {coords = {2171.47, 2795.85, 10.82}, gps_cmd = '/gps 9 55'}
}
--[[ ## координаты азс и их /gps ]]
local gas_coords = {
    Island_Gas = {coords = {3209.04, 36.90, 3.99}, gps_cmd = '/gps 9 70'},
    Dilimore_Gas = {coords = {655.72, -564.95, 16.34}, gps_cmd = '/gps 9 43'},
    Whestone_Gas = {coords = {-1605.45, -2714.34, 48.22}, gps_cmd = '/gps 9 42'},
    Shell_Gas = {coords = {2382.34, 508.29, 1.88}, gps_cmd = '/gps 9 69'},
    ElGuebrabos_Gas = {coords = {-1329.60, 2677.52, 49.94}, gps_cmd = '/gps 9 39'},
    Julius_Gas = {coords = {2640.25, 1105.48, 10.50}, gps_cmd = '/gps 9 29'},
    AngelPine_Gas = {coords = {-2244.12, -2560.72, 31.55}, gps_cmd = '/gps 9 41'},
    Espo_Gas = {coords = {-3048.13, 520.54, 1.81}, gps_cmd = '/gps 9 68'}
}
--[[ ## координаты 24/7 и их /gps ]]
local shop_coords = {
    Creek_247 = {coords = {2885.92, 2452.73, 11.07}, gps_cmd = '/gps 9 63'},
    Sugar_247 = {coords = {2957.25, -1971.52, 1.86}, gps_cmd = '/gps 9 64'},
    Espo_247 = {coords = {-3067.89, 521.27, 1.25}, gps_cmd = '/gps 9 65'}
}
--[[ ## расчитываем координаты ближайшей закусочной ]]
local function getClosestFood()
    local px, py, pz = getCharCoordinates(PLAYER_PED) -- ## получаем текущие координаты игрока
    local closest_cmd, min_dist = nil, math.huge

    for _, data in pairs(food_coords) do -- ## сверяем каждую закусочную с координатами игрока
        local coords = data.coords
        --[[ ## логика вычисления расстояния до закусочной ]]
        local dx = coords[1] - px
        local dy = coords[2] - py
        local dz = coords[3] - pz
        local dist = math.sqrt(dx * dx + dy * dy + dz * dz) 

        --[[ ## если текущая закусочная ближе, чем предыдущая минимальная - обновляем минимальное расстояние и команду ]]
        if dist < min_dist then
            min_dist = dist
            closest_cmd = data.gps_cmd
        end
    end

    return closest_cmd -- ## возвращаем команду /gps соответствующую ближайшей закусочной
end
--[[## расчитываем координаты ближайшей азс]]
local function getClosestGas()
    local px, py, pz = getCharCoordinates(PLAYER_PED)
    local closest_gas_cmd, min_gas_dist = nil, math.huge

    for _, data in pairs(gas_coords) do
        local coords = data.coords
        local dx = coords[1] - px
        local dy = coords[2] - py
        local dz = coords[3] - pz
        local dist = math.sqrt(dx * dx + dy * dy + dz * dz) 

        if dist < min_gas_dist then
            min_gas_dist = dist
            closest_gas_cmd = data.gps_cmd
        end
    end

    return closest_gas_cmd -- ## возвращаем команду /gps соответствующую ближайшей АЗС
end
--[[## расчитываем координаты ближайшего магазина]]
local function getClosestShop()
    local px, py, pz = getCharCoordinates(PLAYER_PED)
    local closest_shop_cmd, min_shop_dist = nil, math.huge

    for _, data in pairs(shop_coords) do
        local coords = data.coords
        local dx = coords[1] - px
        local dy = coords[2] - py
        local dz = coords[3] - pz
        local dist = math.sqrt(dx * dx + dy * dy + dz * dz) 

        if dist < min_shop_dist then
            min_shop_dist = dist
            closest_shop_cmd = data.gps_cmd
        end
    end

    return closest_shop_cmd -- ## возвращаем команду /gps соответствующую ближайшему магазину
end
--[[## отправка команды /gps на сервер]]
local function sendGpsCommand(command)
    sampSendChat(command)
end
------------------------==[ imgui.CenterText ]==------------------------
function imgui.CenterText(text, maxWidth)
    local lines = {}
    local currentLine = ""
    local words = {}
    
    --[[ ## разбиваем текст на слова ]]
    for word in string.gmatch(text, "%S+") do
        table.insert(words, word)
    end
    
    for i, word in ipairs(words) do
        local testLine = currentLine == "" and word or currentLine .. " " .. word
        local textSize = imgui.CalcTextSize(testLine).x
        
        if textSize > maxWidth then
            --[[## если текущая строка превышает максимальную ширину, добавляем ее в таблицу строк и начинаем новую ]]
            table.insert(lines, currentLine)
            currentLine = word
        else
            --[[## иначе добавляем слово в текущую строку ]]
            currentLine = testLine
        end
    end
    
    --[[## добавляем последнюю строку ]]
    if currentLine ~= "" then
        table.insert(lines, currentLine)
    end
    
    --[[## центрируем и выводим каждую строку ]]
    for _, line in ipairs(lines) do
        local calc = imgui.CalcTextSize(line)
        local width = imgui.GetWindowWidth()
        imgui.SetCursorPosX(width / 2 - calc.x / 2)
        imgui.Text(line)
    end
end
------------------------==[ imgui.CenteredTextWithLink ]==------------------------
function imgui.CenteredTextWithLink(text, linkText, link, maxWidth)
    --[[## рассчитываем размеры текста и ссылки ]]
    local fullText = text .. " " .. linkText
    local calcFull = imgui.CalcTextSize(fullText)
    local width = imgui.GetWindowWidth()
    local cursorPosX = (width - calcFull.x) / 2

    --[[## устанавливаем позицию курсора для центрирования текста ]]
    imgui.SetCursorPosX(cursorPosX)

    --[[## отображаем основной текст ]]
    imgui.Text(text .. " ")
    imgui.SameLine(0, 0)

    --[[## добавляем гиперссылку ]]
    local tSize = imgui.CalcTextSize(linkText)
    local p = imgui.GetCursorScreenPos()
    local DL = imgui.GetWindowDrawList()
    local col = { 0xFFFF7700, 0xFFFF9900 }

    if imgui.InvisibleButton("##" .. link, tSize) then 
        os.execute("explorer " .. link) 
    end

    local color = imgui.IsItemHovered() and col[1] or col[2]
    DL:AddText(p, color, linkText)
    DL:AddLine(imgui.ImVec2(p.x, p.y + tSize.y), imgui.ImVec2(p.x + tSize.x, p.y + tSize.y), color)
end
------------------------==[ imgui.TextColoredRGB ]==------------------------
function imgui.TextColoredRGB(text)
    local style = imgui.GetStyle()
    local colors = style.Colors
    local ImVec4 = imgui.ImVec4

    local explode_argb = function(argb)
        local a = bit.band(bit.rshift(argb, 24), 0xFF)
        local r = bit.band(bit.rshift(argb, 16), 0xFF)
        local g = bit.band(bit.rshift(argb, 8), 0xFF)
        local b = bit.band(argb, 0xFF)
        return a, r, g, b
    end

    local getcolor = function(color)
        if color:sub(1, 6):upper() == 'SSSSSS' then
            local r, g, b = colors[1].x, colors[1].y, colors[1].z
            local a = tonumber(color:sub(7, 8), 16) or colors[1].w * 255
            return ImVec4(r, g, b, a / 255)
        end
        local color = type(color) == 'string' and tonumber(color, 16) or color
        if type(color) ~= 'number' then return end
        local r, g, b, a = explode_argb(color)
        return imgui.ImVec4(r / 255, g / 255, b / 255, a / 255)
    end

    local render_text = function(text_)
        for w in text_:gmatch('[^\r\n]+') do
            local text, colors_, m = {}, {}, 1
            w = w:gsub('{(......)}', '{%1FF}')
            while w:find('{........}') do
                local n, k = w:find('{........}')
                local color = getcolor(w:sub(n + 1, k - 1))
                if color then
                    text[#text], text[#text + 1] = w:sub(m, n - 1), w:sub(k + 1, #w)
                    colors_[#colors_ + 1] = color
                    m = n
                end
                w = w:sub(1, n - 1) .. w:sub(k + 1, #w)
            end

            --[[## центрируем текст перед его отрисовкой ]]
            local textWidth = imgui.CalcTextSize(w).x
            imgui.SetCursorPosX((imgui.GetWindowSize().x - textWidth) / 2)

            if text[0] then
                for i = 0, #text do
                    imgui.TextColored(colors_[i] or colors[1], (text[i]))
                    imgui.SameLine(nil, 0)
                end
                imgui.NewLine()
            else
                imgui.Text((w))
            end
        end
    end

    render_text(text)
end

-------------------------------==[ renderMainFrame ]==--------------------------------
local renderMainFrame = imgui.OnFrame(
    function() 
        return windowVisible[0] and not isPauseMenuActive() and not sampIsScoreboardOpen() -- ## проверка видимости окна
    end,
    function()
        setupDarkRedTheme()
        --[[## getScreenResolution ## imgui.SetNextWindowPos ## imgui.SetNextWindowSize
          * получаем разрешение экрана
          * по умолчанию выравниваем окно по центру
          * применяем размер установленный переменными "window_width" и "window_height"
        ]]
        local sw, sh = getScreenResolution()
        imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(492, 400), imgui.Cond.FirstUseEver)
        if imgui.Begin(u8(string.upper(__name__)), windowVisible, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar) then
            if imgui.BeginTabBar('MainTabBar') then
                if imgui.BeginTabItem('Информация') then
                    local originalColor = imgui.GetStyle().Colors[imgui.Col.Text]
                
                    imgui.PushStyleColor(imgui.Col.Text, imgui.GetStyle().Colors[imgui.Col.TextDisabled])
                    imgui.CenterText(u8'Команды:', 300)
                    imgui.PopStyleColor()

                    imgui.CenterText(u8'/prices - открыть/закрыть главное меню', 300)
                    imgui.CenterText(u8'/ceat - найти ближайшую закусочную', 300)
                    imgui.CenterText(u8'/cgas - найти ближайшую АЗС', 300)
                    imgui.CenterText(u8'/cstore - найти ближайший магазин', 300)

                    imgui.Dummy(imgui.ImVec2(0, 15))

                    imgui.PushStyleColor(imgui.Col.Text, imgui.GetStyle().Colors[imgui.Col.TextDisabled])
                    imgui.CenterText(u8'Ссылки:', 300)
                    imgui.PopStyleColor()
                    
                    imgui.CenteredTextWithLink(u8'Оригинальный репозиторий:', u8'GitHub', u8'https://github.com/THE-KEGARE/ERPBP', 200)
                    imgui.CenteredTextWithLink(u8'Наш сервер:', u8'Discord', u8'https://discord.gg/bRG3jhzDzG', 200)
                    imgui.CenteredTextWithLink(u8'Если нашли баг:', u8'Telegram', u8'https://t.me/apparently_adolf_hitler', 200)
                    
                    imgui.Dummy(imgui.ImVec2(0, 30))

                    imgui.CenterText(u8('Авторы скрипта: ' .. __authors__), 300)
                    imgui.TextColoredRGB(u8'{FF0000}благодарят вас за скачивание <3')
                    imgui.Dummy(imgui.ImVec2(0, 30))
                    
                    imgui.PushStyleColor(imgui.Col.Text, imgui.GetStyle().Colors[imgui.Col.TextDisabled])
                    imgui.CenterText(__update__, 300)
                    imgui.CenterText(u8('Последняя версия скрипта: ' .. thisScript().version .. '-alpha'), 400)
                    imgui.PopStyleColor()
                          
                    imgui.EndTabItem()
                end

                ----------------------==[ Закусочные ]==-------------------------
                if imgui.BeginTabItem(u8'Закусочные') then
                    --------------------Blueberry Pizza----------------------
                    if imgui.CollapsingHeader(u8'Blueberry Pizza') then
                        imgui.Indent(10)
                        imgui.TextWrapped(u8'Цена хот-дога: $375')
                        imgui.TextWrapped(u8'Цена тяжелой закуски: $1125')
                        imgui.TextWrapped(u8'GPS: ' .. food_coords.Blueberry_Pizza.gps_cmd)
                        imgui.TextWrapped(u8'Местоположение: Red County')
                    
                        if imgui.Button(u8'Установить метку##blueberry') then
                            sampSendChat(food_coords.Blueberry_Pizza.gps_cmd)
                        end
                        imgui.Unindent(10)
                    end
                    --------------------Island Cluckin Bell----------------------
                    if imgui.CollapsingHeader(u8'Island Cluckin Bell') then
                        imgui.Indent(10)
                        imgui.TextWrapped(u8'Цена хот-дога: $375')
                        imgui.TextWrapped(u8'Цена тяжелой закуски: $1125')
                        imgui.TextWrapped(u8'GPS: ' .. food_coords.Island_Cluckin_Bell.gps_cmd)
                        imgui.TextWrapped(u8'Местоположение: Red County')
                    
                        if imgui.Button(u8'Установить метку##island') then
                            sampSendChat(food_coords.Island_Cluckin_Bell.gps_cmd)
                        end
                        imgui.Unindent(10)
                    end
                    --------------------Spinybed Burger----------------------
                    if imgui.CollapsingHeader(u8'Spinybed Burger') then
                        imgui.Indent(10)
                        imgui.TextWrapped(u8'Цена хот-дога: $375')
                        imgui.TextWrapped(u8'Цена тяжелой закуски: $1125')
                        imgui.TextWrapped(u8'GPS: ' .. food_coords.Spinybed_Burger.gps_cmd)
                        imgui.TextWrapped(u8'Местоположение: Las Venturas')
                    
                        if imgui.Button(u8'Установить метку##spinybed') then
                            sampSendChat(food_coords.Spinybed_Burger.gps_cmd)
                        end
                        imgui.Unindent(10)
                    end
                    --------------------Financial Pizza----------------------
                    if imgui.CollapsingHeader(u8'Financial Pizza') then
                        imgui.Indent(10)
                        imgui.TextWrapped(u8'Цена хот-дога: $405')
                        imgui.TextWrapped(u8'Цена тяжелой закуски: $1215')
                        imgui.TextWrapped(u8'GPS: ' .. food_coords.Financial_Pizza.gps_cmd)
                        imgui.TextWrapped(u8'Местоположение: San Fierro')
                    
                        if imgui.Button(u8'Установить метку##financial') then
                            sampSendChat(food_coords.Financial_Pizza.gps_cmd)
                        end
                        imgui.Unindent(10)
                    end
                    
                    --[[## кнопка ближайшей закусочной]]
                    if imgui.Button(u8'Ближайшая закусочная') then
                        local closest_cmd = getClosestFood()
                        if closest_cmd then
                            sampSendChat(closest_cmd) -- отправка /gps серверу
                        end
                    end
                    imgui.EndTabItem()
                end

                -----------------------==[ Заправки ]==---------------------------
                if imgui.BeginTabItem(u8'Автозаправочные станции') then
                    ---------------------------Julius Gas----------------------------
                    if imgui.CollapsingHeader(u8'Julius Gas') then
                        imgui.Indent(10)
                        imgui.TextWrapped(u8'Цена за литр: $75')
                        imgui.TextWrapped(u8'Цена рем. комплекта: $1500')
                        imgui.TextWrapped(u8'Цена канистры: $750')
                        imgui.TextWrapped(u8'GPS: ' .. gas_coords.Julius_Gas.gps_cmd)
                        imgui.TextWrapped(u8'Местоположение: Las Venturas')
                    
                        if imgui.Button(u8'Установить метку##juliusgas') then
                            sampSendChat(gas_coords.Julius_Gas.gps_cmd)
                        end
                        imgui.Unindent(10)
                    end
                    ---------------------------Dilimore Gas----------------------------
                    if imgui.CollapsingHeader(u8'Dilimore Gas') then
                        imgui.Indent(10)
                        imgui.TextWrapped(u8'Цена за литр: $75')
                        imgui.TextWrapped(u8'Цена рем. комплекта: $1500')
                        imgui.TextWrapped(u8'Цена канистры: $750')
                        imgui.TextWrapped(u8'GPS: ' .. gas_coords.Dilimore_Gas.gps_cmd)
                        imgui.TextWrapped(u8'Местоположение: Red County')
                    
                        if imgui.Button(u8'Установить метку##dilimoregas') then
                            sampSendChat(gas_coords.Dilimore_Gas.gps_cmd)
                        end
                        imgui.Unindent(10)
                    end
                    ---------------------------Espo Gas----------------------------
                    if imgui.CollapsingHeader(u8'Espo Gas') then
                        imgui.Indent(10)
                        imgui.TextWrapped(u8'Цена за литр: $75')
                        imgui.TextWrapped(u8'Цена рем. комплекта: $1500')
                        imgui.TextWrapped(u8'Цена канистры: $750')
                        imgui.TextWrapped(u8'GPS: ' .. gas_coords.Espo_Gas.gps_cmd)
                        imgui.TextWrapped(u8'Местоположение: San Fierro')
                    
                        if imgui.Button(u8'Установить метку##espo') then
                            sampSendChat(gas_coords.Espo_Gas.gps_cmd)
                        end
                        imgui.Unindent(10)
                    end
                    ---------------------------Shell Gas----------------------------
                    if imgui.CollapsingHeader(u8'Shell Gas') then
                        imgui.Indent(10)
                        imgui.TextWrapped(u8'Цена за литр: $80')
                        imgui.TextWrapped(u8'Цена рем. комплекта: $1600')
                        imgui.TextWrapped(u8'Цена канистры: $800')
                        imgui.TextWrapped(u8'GPS: ' .. gas_coords.Shell_Gas.gps_cmd)
                        imgui.TextWrapped(u8'Местоположение: Las Venturas')
                    
                        if imgui.Button(u8'Установить метку##shellgas') then
                            sampSendChat(gas_coords.Shell_Gas.gps_cmd)
                        end
                        imgui.Unindent(10)
                    end
                    
                    ---------------------------ElGuebrabos Gas----------------------------
                    if imgui.CollapsingHeader(u8'ElGuebrabos Gas') then
                        imgui.Indent(10)
                        imgui.TextWrapped(u8'Цена за литр: $85')
                        imgui.TextWrapped(u8'Цена рем. комплекта: $1700')
                        imgui.TextWrapped(u8'Цена канистры: $850')
                        imgui.TextWrapped(u8'GPS: ' .. gas_coords.ElGuebrabos_Gas.gps_cmd)
                        imgui.TextWrapped(u8'Местоположение: Tierra Robada')
                    
                        if imgui.Button(u8'Установить метку##elguebrabos') then
                            sampSendChat(gas_coords.ElGuebrabos_Gas.gps_cmd)
                        end
                        imgui.Unindent(10)
                    end
                    ---------------------------AngelPine Gas----------------------------
                    if imgui.CollapsingHeader(u8'AngelPine Gas') then
                        imgui.Indent(10)
                        imgui.TextWrapped(u8'Цена за литр: $88')
                        imgui.TextWrapped(u8'Цена рем. комплекта: $1760')
                        imgui.TextWrapped(u8'Цена канистры: $880')
                        imgui.TextWrapped(u8'GPS: ' .. gas_coords.AngelPine_Gas.gps_cmd)
                        imgui.TextWrapped(u8'Местоположение: Angel Pine')
                    
                        if imgui.Button(u8'Установить метку##angelpinegas') then
                            sampSendChat(gas_coords.AngelPine_Gas.gps_cmd)
                        end
                        imgui.Unindent(10)
                    end
                    ---------------------------Whestone Gas----------------------------
                    if imgui.CollapsingHeader(u8'Whestone Gas') then
                        imgui.Indent(10)              
                        imgui.TextWrapped(u8'Цена за литр: $88')
                        imgui.TextWrapped(u8'Цена рем. комплекта: $1760')
                        imgui.TextWrapped(u8'Цена канистры: $880')
                        imgui.TextWrapped(u8'GPS: ' .. gas_coords.Whestone_Gas.gps_cmd)
                        imgui.TextWrapped(u8'Местоположение: Whestone')
                    
                        if imgui.Button(u8'Установить метку##whestonegas') then
                            sampSendChat(gas_coords.Whestone_Gas.gps_cmd)
                        end
                        imgui.Unindent(10)
                    end

                    --[[## кнопка ближайшей АЗС ]]
                    if imgui.Button(u8'Ближайшая АЗС') then
                        local closest_cmd = getClosestGas()
                        if closest_cmd then
                            sampSendChat(closest_cmd)
                        end
                    end
                    imgui.EndTabItem()
                end

                -----------------------==[ Магазины ]==---------------------------
                if imgui.BeginTabItem(u8'Магазины') then
                    if imgui.CollapsingHeader(u8'Creek 24-7') then
                        imgui.Indent(10)
                        imgui.TextWrapped(u8'Номер телефона: $1000')
                        imgui.TextWrapped(u8'Справочник: $1400')
                        imgui.TextWrapped(u8'Аптечка: $5000')
                        imgui.TextWrapped(u8'Обезболивающее: $3000')
                        imgui.TextWrapped(u8'Рация: $5000')
                        imgui.TextWrapped(u8'Балончик: $1000')
                        imgui.TextWrapped(u8'Отмычка: $400')
                        imgui.TextWrapped(u8'Устройство взлома: $1000')
                        imgui.TextWrapped(u8'GPS: ' .. shop_coords.Creek_247.gps_cmd)
                        imgui.TextWrapped(u8'Местоположение: Las Venturas')
                    
                        if imgui.Button(u8'Установить метку##creek247') then
                            sampSendChat(shop_coords.Creek_247.gps_cmd)
                        end
                        imgui.Unindent(10)
                    end

                    if imgui.CollapsingHeader(u8'Sugar 24-7') then
                        imgui.Indent(10)
                        imgui.TextWrapped(u8'Номер телефона: $625')
                        imgui.TextWrapped(u8'Справочник: $875')
                        imgui.TextWrapped(u8'Аптечка: $3125')
                        imgui.TextWrapped(u8'Обезболивающее: $1875')
                        imgui.TextWrapped(u8'Рация: $3125')
                        imgui.TextWrapped(u8'Балончик: $625')
                        imgui.TextWrapped(u8'Отмычка: $250')
                        imgui.TextWrapped(u8'Устройство взлома: $625')
                        imgui.TextWrapped(u8'GPS: ' .. shop_coords.Sugar_247.gps_cmd)
                        imgui.TextWrapped(u8'Местоположение: Los Santos')
                    
                        if imgui.Button(u8'Установить метку##sugar247') then
                            sampSendChat(shop_coords.Sugar_247.gps_cmd)
                        end
                        imgui.Unindent(10)
                    end

                    if imgui.CollapsingHeader(u8'Espo 24-7') then
                        imgui.Indent(10)
                        imgui.TextWrapped(u8'Номер телефона: $625')
                        imgui.TextWrapped(u8'Справочник: $875')
                        imgui.TextWrapped(u8'Аптечка: $3125')
                        imgui.TextWrapped(u8'Обезболивающее: $1875')
                        imgui.TextWrapped(u8'Рация: $3125')
                        imgui.TextWrapped(u8'Балончик: $625')
                        imgui.TextWrapped(u8'Отмычка: $250')
                        imgui.TextWrapped(u8'Устройство взлома: $625')
                        imgui.TextWrapped(u8'GPS: ' .. shop_coords.Espo_247.gps_cmd)
                        imgui.TextWrapped(u8'Местоположение: San Fierro')
                    
                        if imgui.Button(u8'Установить метку##espo247') then
                            sampSendChat(shop_coords.Espo_247.gps_cmd)
                        end
                        imgui.Unindent(10)
                    end

                    --[[## кнопка ближайшего 24/7 ]]
                    if imgui.Button(u8'Ближайший магазин') then
                        local closest_cmd = getClosestShop()
                        if closest_cmd then
                            sampSendChat(closest_cmd)
                        end
                    end
                    imgui.EndTabItem()
                end

                -----------------------==[ Настройки ]==---------------------------
                if imgui.BeginTabItem(u8'Настройки') then
                    imgui.Dummy(imgui.ImVec2(0, 5))
                    
                    -- Показываем кнопку изменения хоткея
                    if toggleHotkey:ShowHotKey(imgui.ImVec2(75, 25)) then
                        -- При изменении хоткея сохраняем новые значения в конфиг
                        cfg.config.bind = encodeJson(toggleHotkey:GetHotKey())
                        inicfg.save(cfg, 'BestPrices.ini')
                    end
                    imgui.SameLine()
                    imgui.TextWrapped(u8'Открыть меню')
                    
                    imgui.EndTabItem()
                end
                imgui.EndTabBar()
                imgui.End()
            end
        end
    end
)

--[[## цикл активации ]]
function main()
    while not isSampAvailable() do wait(0) end
    
    -- проверка обновлений
    if autoupdate_loaded and enable_autoupdate and Update then
        pcall(Update.check, Update.json_url, Update.prefix, Update.url)
    end
    
    -- регистрируем хоткей с проверкой на меню
    toggleHotkey = hotkey.RegisterHotKey('toggle_window', false, decodeJson(cfg.config.bind), function() 
        if not isPauseMenuActive() and not sampIsScoreboardOpen() then
            windowVisible[0] = not windowVisible[0]
        end
    end)
    
    -- регистрируем команды чата с проверкой на меню
    sampRegisterChatCommand('prices', function()
        if not isPauseMenuActive() and not sampIsScoreboardOpen() then
            windowVisible[0] = not windowVisible[0]
        end
    end)

    -- команда для поиска ближайшей закусочной
    sampRegisterChatCommand('ceat', function()
        if not isPauseMenuActive() and not sampIsScoreboardOpen() then
            local closest_cmd = getClosestFood()
            if closest_cmd then
                sampSendChat(closest_cmd)
            end
        end
    end)

    -- команда для поиска ближайшей АЗС
    sampRegisterChatCommand('cgas', function()
        if not isPauseMenuActive() and not sampIsScoreboardOpen() then
            local closest_cmd = getClosestGas()
            if closest_cmd then
                sampSendChat(closest_cmd)
            end
        end
    end)

    -- команда для поиска ближайшего магазина
    sampRegisterChatCommand('cstore', function()
        if not isPauseMenuActive() and not sampIsScoreboardOpen() then
            local closest_cmd = getClosestShop()
            if closest_cmd then
                sampSendChat(closest_cmd)
            end
        end
    end)

    while true do
        wait(0)
    end
end

-----------------==[ Внешний Вид ]==------------------
function applyDarkRedTheme()
    --==[ STYLE ]==--
    imgui.GetStyle().WindowPadding = imgui.ImVec2(5, 5)
    imgui.GetStyle().FramePadding = imgui.ImVec2(5, 5)
    imgui.GetStyle().ItemSpacing = imgui.ImVec2(5, 5)
    imgui.GetStyle().ItemInnerSpacing = imgui.ImVec2(2, 2)
    imgui.GetStyle().TouchExtraPadding = imgui.ImVec2(0, 0)
    imgui.GetStyle().IndentSpacing = 0
    imgui.GetStyle().ScrollbarSize = 10
    imgui.GetStyle().GrabMinSize = 10

    --==[ BORDER ]==--
    imgui.GetStyle().WindowBorderSize = 1
    imgui.GetStyle().ChildBorderSize = 1
    imgui.GetStyle().PopupBorderSize = 1
    imgui.GetStyle().FrameBorderSize = 1
    imgui.GetStyle().TabBorderSize = 1

    --==[ ROUNDING ]==--
    imgui.GetStyle().WindowRounding = 5
    imgui.GetStyle().ChildRounding = 5
    imgui.GetStyle().FrameRounding = 5
    imgui.GetStyle().PopupRounding = 5
    imgui.GetStyle().ScrollbarRounding = 5
    imgui.GetStyle().GrabRounding = 5
    imgui.GetStyle().TabRounding = 5

    --==[ ALIGN ]==--
    imgui.GetStyle().WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
    imgui.GetStyle().ButtonTextAlign = imgui.ImVec2(0.5, 0.5)
    imgui.GetStyle().SelectableTextAlign = imgui.ImVec2(0.5, 0.5)
    
    --==[ COLORS ]==--
    imgui.GetStyle().Colors[imgui.Col.Text] = imgui.ImVec4(1.00, 1.00, 1.00, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TextDisabled] = imgui.ImVec4(0.50, 0.50, 0.50, 1.00)
    imgui.GetStyle().Colors[imgui.Col.WindowBg] = imgui.ImVec4(0.03, 0.03, 0.03, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ChildBg] = imgui.ImVec4(0.03, 0.03, 0.03, 1.00)
    imgui.GetStyle().Colors[imgui.Col.PopupBg] = imgui.ImVec4(0.03, 0.03, 0.03, 1.00)
    imgui.GetStyle().Colors[imgui.Col.Border] = imgui.ImVec4(0.25, 0.25, 0.26, 0.00)
    imgui.GetStyle().Colors[imgui.Col.BorderShadow] = imgui.ImVec4(0.00, 0.00, 0.00, 0.00)
    imgui.GetStyle().Colors[imgui.Col.FrameBg] = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.FrameBgHovered] = imgui.ImVec4(0.25, 0.25, 0.26, 1.00)
    imgui.GetStyle().Colors[imgui.Col.FrameBgActive] = imgui.ImVec4(0.25, 0.25, 0.26, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TitleBg] = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TitleBgActive] = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TitleBgCollapsed] = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.MenuBarBg] = imgui.ImVec4(0.08, 0.08, 0.08, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ScrollbarBg] = imgui.ImVec4(0.08, 0.08, 0.08, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ScrollbarGrab] = imgui.ImVec4(0.00, 0.00, 0.00, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabHovered] = imgui.ImVec4(0.41, 0.41, 0.41, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabActive] = imgui.ImVec4(0.51, 0.51, 0.51, 1.00)
    imgui.GetStyle().Colors[imgui.Col.CheckMark] = imgui.ImVec4(1.00, 1.00, 1.00, 1.00)
    imgui.GetStyle().Colors[imgui.Col.SliderGrab] = imgui.ImVec4(0.21, 0.20, 0.20, 1.00)
    imgui.GetStyle().Colors[imgui.Col.SliderGrabActive] = imgui.ImVec4(0.21, 0.20, 0.20, 1.00)
    imgui.GetStyle().Colors[imgui.Col.Button] = imgui.ImVec4(0.92, 0.18, 0.29, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ButtonHovered] = imgui.ImVec4(0.96, 0.26, 0.36, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ButtonActive] = imgui.ImVec4(0.98, 0.33, 0.42, 1.00)
    imgui.GetStyle().Colors[imgui.Col.Header] = imgui.ImVec4(0.08, 0.08, 0.08, 1.00)
    imgui.GetStyle().Colors[imgui.Col.HeaderHovered] = imgui.ImVec4(0.14, 0.14, 0.14, 1.00)
    imgui.GetStyle().Colors[imgui.Col.HeaderActive] = imgui.ImVec4(0.16, 0.16, 0.16, 1.00)
    imgui.GetStyle().Colors[imgui.Col.Separator] = imgui.ImVec4(0.7137, 0.1725, 0.3137, 0.0)
    imgui.GetStyle().Colors[imgui.Col.SeparatorHovered] = imgui.ImVec4(0.7137, 0.1725, 0.3137, 0.0)
    imgui.GetStyle().Colors[imgui.Col.SeparatorActive] = imgui.ImVec4(0.7137, 0.1725, 0.3137, 0.0)
    imgui.GetStyle().Colors[imgui.Col.ResizeGrip] = imgui.ImVec4(1.00, 1.00, 1.00, 0.25)
    imgui.GetStyle().Colors[imgui.Col.ResizeGripHovered] = imgui.ImVec4(1.00, 1.00, 1.00, 0.67)
    imgui.GetStyle().Colors[imgui.Col.ResizeGripActive] = imgui.ImVec4(1.00, 1.00, 1.00, 0.95)
    imgui.GetStyle().Colors[imgui.Col.Tab] = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TabHovered] = imgui.ImVec4(0.28, 0.28, 0.28, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TabActive] = imgui.ImVec4(0.30, 0.30, 0.30, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TabUnfocused] = imgui.ImVec4(0.07, 0.10, 0.15, 0.97)
    imgui.GetStyle().Colors[imgui.Col.TabUnfocusedActive] = imgui.ImVec4(0.14, 0.26, 0.42, 1.00)
    imgui.GetStyle().Colors[imgui.Col.PlotLines] = imgui.ImVec4(0.61, 0.61, 0.61, 1.00)
    imgui.GetStyle().Colors[imgui.Col.PlotLinesHovered] = imgui.ImVec4(1.00, 0.43, 0.35, 1.00)
    imgui.GetStyle().Colors[imgui.Col.PlotHistogram] = imgui.ImVec4(0.90, 0.70, 0.00, 1.00)
    imgui.GetStyle().Colors[imgui.Col.PlotHistogramHovered] = imgui.ImVec4(1.00, 0.60, 0.00, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TextSelectedBg] = imgui.ImVec4(1.00, 0.00, 0.00, 0.35)
    imgui.GetStyle().Colors[imgui.Col.DragDropTarget] = imgui.ImVec4(1.00, 1.00, 0.00, 0.90)
    imgui.GetStyle().Colors[imgui.Col.NavHighlight] = imgui.ImVec4(0.26, 0.59, 0.98, 1.00)
    imgui.GetStyle().Colors[imgui.Col.NavWindowingHighlight] = imgui.ImVec4(1.00, 1.00, 1.00, 0.70)
    imgui.GetStyle().Colors[imgui.Col.NavWindowingDimBg] = imgui.ImVec4(0.80, 0.80, 0.80, 0.20)
    imgui.GetStyle().Colors[imgui.Col.ModalWindowDimBg] = imgui.ImVec4(0.00, 0.00, 0.00, 0.70)
end
