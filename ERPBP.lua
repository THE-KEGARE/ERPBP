__name__ = ('Evolve RP Best Prices')
__authors__ = ('Kegare & !chizusrevenge')
__description__ = ('Скрипт облегчает поиск самых дешевых и выгодных бизнесов на сервере Evolve RP, таких как закусочные и автозаправки.')
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
--[[## логика центрирования текста ]]
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
    
    -- Добавляем последнюю строку
    if currentLine ~= "" then
        table.insert(lines, currentLine)
    end
    
    -- Центрируем и выводим каждую строку
    for _, line in ipairs(lines) do
        local calc = imgui.CalcTextSize(line)
        local width = imgui.GetWindowWidth()
        imgui.SetCursorPosX(width / 2 - calc.x / 2)
        imgui.Text(line)
    end
end
--[[## рендеринг основного окна ]]
local renderMainFrame = imgui.OnFrame(
    function() return windowVisible[0] end,
    function()
        setupDarkRedTheme()
        local sw, sh = getScreenResolution()
        imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(340, 329), imgui.Cond.FirstUseEver)
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
                    -- ## кнопка ближайшей закусочной
                    if imgui.Button('Ближайшая АЗС') then
                        local closest_cmd = getClosestGas()
                        if closest_cmd then
                            sampSendChat(closest_cmd)
                        end
                    end
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





--[[
if imgui.BeginTabItem('Информация') then
    local originalColor = imgui.GetStyle().Colors[imgui.Col.Text]

    -- ## устанавливаем цвет текста как у TextDisabled
    imgui.PushStyleColor(imgui.Col.Text, imgui.GetStyle().Colors[imgui.Col.TextDisabled])
    
    -- ## рассчитываем и устанавливаем позицию текста внизу окна
    local footer_height = 20  -- высота блока с текстом
    imgui.SetCursorPosY(imgui.GetWindowHeight() - footer_height)
    
    -- ## выводим текст
    imgui.CenterText('Авторы: ' .. __authors__, 300)
    -- imgui.CenterText(__description__, 300)
    imgui.CenterText(__update__, 300)
    
    -- ## восстанавливаем оригинальный цвет текста
    imgui.PopStyleColor()        

    imgui.EndTabItem()
end
]]