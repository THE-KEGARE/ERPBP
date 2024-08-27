__name__ = ('Evolve RP Best Prices')
__authors__ = ('Kegare & !chizusrevenge')
__description__ = ('Данный скрипт предназначен для упрощения поиска наиболее дешевых и выгодных для игрока бизнесов на сервере Evolve RP. Он позволяет быстро находить различные бизнесы, такие как закусочные, автозаправочные станции и другие.')
__update__ = ('Последнее обновление скрипта: 27.08.2024')

local imgui = require 'mimgui'
local encoding = require 'encoding'
local vkeys = require 'vkeys'
encoding.default = 'CP1251'
u8 = encoding.UTF8

local windowVisible = imgui.new.bool(false)

-- ## отправка /gps серверу
local function sendGpsCommand(command)
    sampSendChat(command)
end

-----------------==[ Внешний Вид ]==------------------
local function setupDarkRedTheme()
    imgui.SwitchContext()
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
    imgui.GetStyle().Colors[imgui.Col.Button] = imgui.ImVec4(0.7, 0.10, 0.25, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ButtonHovered] = imgui.ImVec4(0.76, 0.18, 0.33, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ButtonActive] = imgui.ImVec4(0.78, 0.20, 0.35, 1.0)
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
-----------OnInitialize---------
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
    BoneCountry_Gas = {coords = {612.30, 1695.17, 6.86}, gps_cmd = '/gps 9 28'},
    Island_Gas = {coords = {3209.04, 36.90, 3.99}, gps_cmd = '/gps 9 70'},
    Dilimore_Gas = {coords = {655.72, -564.95, 16.34}, gps_cmd = '/gps 9 43'},
    Whestone_Gas = {coords = {-1605.45, -2714.34, 48.22}, gps_cmd = '/gps 9 42'},
    Shell_Gas = {coords = {2382.34, 508.29, 1.88}, gps_cmd = '/gps 9 69'},
    ElGuebrabos_Gas = {coords = {-1329.60, 2677.52, 49.94}, gps_cmd = '/gps 9 39'}
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
----------------imgui.CenterText-------------------
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
-----------------------imgui.CenteredTextWithLink------------------------------
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
-------------------imgui.TextColoredRGB-------------------------
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
    function() return windowVisible[0] end,
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
        if imgui.Begin(string.upper(__name__), windowVisible, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar) then
            if imgui.BeginTabBar('MainTabBar') then
                ----------------------==[ Закусочные ]==-------------------------
                if imgui.BeginTabItem('Закусочные') then
                    --------------------Blueberry Pizza----------------------
                    if imgui.CollapsingHeader('Blueberry Pizza') then
                        imgui.Indent(10)
                        imgui.TextWrapped('Цена хот-дога: $375')
                        imgui.TextWrapped('Цена тяжелой закуски: $1125')
                        imgui.TextWrapped('GPS: /gps 9 61')
                        imgui.TextWrapped('Местоположение: Red County')
                    
                        if imgui.Button('Установить метку##blueberry') then
                            sendGpsCommand('/gps 9 61')
                        end
                        imgui.Unindent(10)
                    end
                    --------------------Financial Pizza----------------------
                    if imgui.CollapsingHeader('Financial Pizza') then
                        imgui.Indent(10)
                        imgui.TextWrapped('Цена хот-дога: $450')
                        imgui.TextWrapped('Цена тяжелой закуски: $1350')
                        imgui.TextWrapped('GPS: /gps 9 25')
                        imgui.TextWrapped('Местоположение: San Fierro')
                    
                        if imgui.Button('Установить метку##financial') then
                            sendGpsCommand('/gps 9 25')
                        end
                        imgui.Unindent(10)
                    end
                    --------------------Island Cluckin Bell----------------------
                    if imgui.CollapsingHeader('Island Cluckin Bell') then
                        imgui.Indent(10)
                        imgui.TextWrapped('Цена хот-дога: $525')
                        imgui.TextWrapped('Цена тяжелой закуски: $1575')
                        imgui.TextWrapped('GPS: /gps 9 72')
                        imgui.TextWrapped('Местоположение: Red County')
                    
                        if imgui.Button('Установить метку##island') then
                            sendGpsCommand('/gps 9 72')
                        end
                        imgui.Unindent(10)
                    end
                    --------------------Spinybed Burger----------------------
                    if imgui.CollapsingHeader('Spinybed Burger') then
                        imgui.Indent(10)
                        imgui.TextWrapped('Цена хот-дога: $555')
                        imgui.TextWrapped('Цена тяжелой закуски: $1665')
                        imgui.TextWrapped('GPS: /gps 9 55')
                        imgui.TextWrapped('Местоположение: Las Venturas')
                    
                        if imgui.Button('Установить метку##spinybed') then
                            sendGpsCommand('/gps 9 55')
                        end
                        imgui.Unindent(10)
                    end
                    -- ## кнопка ближайшей закусочной
                    if imgui.Button('Ближайшая закусочная') then
                        local closest_cmd = getClosestFood()
                        if closest_cmd then
                            sampSendChat(closest_cmd) -- отправка /gps серверу
                        end
                    end
                    imgui.EndTabItem()
                end
                -----------------------==[ Заправки ]==---------------------------
                if imgui.BeginTabItem('Автозаправочные станции') then
                    if imgui.CollapsingHeader('BoneCountry Gas') then
                        imgui.Indent(10)
                        imgui.TextWrapped('Цена за литр: $75')
                        imgui.TextWrapped('Цена рем. комплекта: $1500')
                        imgui.TextWrapped('GPS: /gps 9 28')
                        imgui.TextWrapped('Местоположение: Bone County')
                    
                        if imgui.Button('Установить метку##bonecountrygas') then
                            sendGpsCommand('/gps 9 28')
                        end
                        imgui.Unindent(10)
                    end
                    ---------------------------Island Gas----------------------------
                    if imgui.CollapsingHeader('Island Gas') then
                        imgui.Indent(10)
                        imgui.TextWrapped('Цена за литр: $75')
                        imgui.TextWrapped('Цена рем. комплекта: $1500')
                        imgui.TextWrapped('Цена канистры: $750')
                        imgui.TextWrapped('GPS: /gps 9 70')
                        imgui.TextWrapped('Местоположение: Red County')
                    
                        if imgui.Button('Установить метку##islandgas') then
                            sendGpsCommand('/gps 9 70')
                        end
                        imgui.Unindent(10)
                    end
                    ---------------------------Dilimore Gas----------------------------
                    if imgui.CollapsingHeader('Dilimore Gas') then
                        imgui.Indent(10)
                        imgui.TextWrapped('Цена за литр: $75')
                        imgui.TextWrapped('Цена рем. комплекта: $1500')
                        imgui.TextWrapped('Цена канистры: $750')
                        imgui.TextWrapped('GPS: /gps 9 43')
                        imgui.TextWrapped('Местоположение: Red County')
                    
                        if imgui.Button('Установить метку##dilimoregas') then
                            sendGpsCommand('/gps 9 43')
                        end
                        imgui.Unindent(10)
                    end
                    ---------------------------Whestone Gas----------------------------
                    if imgui.CollapsingHeader('Whestone Gas') then
                        imgui.Indent(10)              
                        imgui.TextWrapped('Цена за литр: $77')
                        imgui.TextWrapped('Цена рем. комплекта: $1540')
                        imgui.TextWrapped('Цена канистры: $770')
                        imgui.TextWrapped('GPS: /gps 9 42')
                        imgui.TextWrapped('Местоположение: Whestone')
                    
                        if imgui.Button('Установить метку##whestonegas') then
                            sendGpsCommand('/gps 9 42')
                        end
                        imgui.Unindent(10)
                    end
                    ---------------------------Shell Gas----------------------------
                    if imgui.CollapsingHeader('Shell Gas') then
                        imgui.Indent(10)
                        imgui.TextWrapped('Цена за литр: $80')
                        imgui.TextWrapped('Цена рем. комплекта: $1600')
                        imgui.TextWrapped('Цена канистры: $800')
                        imgui.TextWrapped('GPS: /gps 9 69')
                        imgui.TextWrapped('Местоположение: Las Venturas')
                    
                        if imgui.Button('Установить метку##shellgas') then
                            sendGpsCommand('/gps 9 69')
                        end
                        imgui.Unindent(10)
                    end
                    ---------------------------ElGuebrabos Gas----------------------------
                    if imgui.CollapsingHeader('ElGuebrabos Gas') then
                        imgui.Indent(10)
                        imgui.TextWrapped('Цена за литр: $85')
                        imgui.TextWrapped('Цена рем. комплекта: $1700')
                        imgui.TextWrapped('Цена канистры: $850')
                        imgui.TextWrapped('GPS: /gps 9 39')
                        imgui.TextWrapped('Местоположение: Tierra Robada')
                    
                        if imgui.Button('Установить метку##elguebrabos') then
                            sendGpsCommand('/gps 9 39')
                        end
                        imgui.Unindent(10)
                    end
                    --[[## кнопка ближайшей закусочной ]]
                    if imgui.Button('Ближайшая АЗС') then
                        local closest_cmd = getClosestGas()
                        if closest_cmd then
                            sampSendChat(closest_cmd)
                        end
                    end
                    imgui.EndTabItem()
                end

                if imgui.BeginTabItem('Магазины') then
                    imgui.EndTabItem()
                end

                if imgui.BeginTabItem('Настройки') then
                    imgui.EndTabItem()
                end

                if imgui.BeginTabItem('Информация') then
                    local originalColor = imgui.GetStyle().Colors[imgui.Col.Text]
                
                    --[[## цвет текста как у TextDisabled ]]
                    imgui.PushStyleColor(imgui.Col.Text, imgui.GetStyle().Colors[imgui.Col.TextDisabled])
                    imgui.PopStyleColor()
                    imgui.Dummy(imgui.ImVec2(0, 5))
                    --[[## выводим текст]]
                    imgui.CenterText('Авторы скрипта: ' .. __authors__, 300)
                    imgui.TextColoredRGB('{FF0000}благодарят вас за скачивание <3')
                    imgui.Dummy(imgui.ImVec2(0, 5))
                    imgui.CenterText(__description__, 400)

                    imgui.Dummy(imgui.ImVec2(0, 5))
                    
                    imgui.CenteredTextWithLink("Оригинальный репозиторий:", "GitHub", "https://github.com/THE-KEGARE/ERPBP", 200)
                    imgui.CenteredTextWithLink("Наш сервер:", "Discord", "https://discord.gg/bRG3jhzDzG", 200)
                    imgui.CenteredTextWithLink("Если нашли баг:", "Telegram главного разработчика", "https://t.me/apparently_adolf_hitler", 200)
                    imgui.Dummy(imgui.ImVec2(0, 20))

                    imgui.PushStyleColor(imgui.Col.Text, imgui.GetStyle().Colors[imgui.Col.TextDisabled])
                    imgui.CenterText('Так как скрипт находится на стадии разработки, возможны недочеты.', 300)
                    imgui.CenterText('Спасибо за понимание.', 300)
                    imgui.Dummy(imgui.ImVec2(0, 20))
                    
                    imgui.CenterText(__update__, 300)
                    imgui.PopStyleColor()
                          
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
    sampRegisterChatCommand('bp', function()
        windowVisible[0] = not windowVisible[0]
    end)

    while true do
        wait(0)
        if not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() then
            if wasKeyPressed(vkeys.VK_OEM_MINUS) then  -- ## проверка нажатия клавиши "-"
                windowVisible[0] = not windowVisible[0]
            end
        end
    end
end
