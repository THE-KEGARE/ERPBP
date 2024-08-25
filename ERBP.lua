--[[## комментарии
  * chatgpt мне не помог, пришлось все переписывать самому
  * комментарии оставил тебе для удобства чтения кода
  * это на случай если захочешь сам что то добавить/изменить
  * или же просто подметить что-то себе в будущем
]]

__name__ = ('Evolve RP Best Prices')
__authors__ = ('Kegare & !chizusrevenge')

local imgui = require 'mimgui'
local new = imgui.new
local vk = require 'vkeys'

-- ## переменная для управления отображением главного окна
local window = {
    show_main = new.bool(false), -- ## изначально false. переключается на true чтобы показать окно
}

-- ## устанавливаем общий стиль
local function setupDarkRedTheme()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local ImVec4 = imgui.ImVec4

    style.WindowPadding = imgui.ImVec2(10, 10)
    style.ItemSpacing = imgui.ImVec2(5, 5)
    style.WindowRounding = 5.0
    colors[imgui.Col.WindowBg] = ImVec4(0.0, 0.0, 0.0, 0.9)
    colors[imgui.Col.Border] = ImVec4(0.0, 0.0, 0.0, 0.0)
    colors[imgui.Col.BorderShadow] = ImVec4(0.0, 0.0, 0.0, 0.0)

    colors[imgui.Col.Button] = ImVec4(0.7137, 0.1725, 0.3137, 1.0)
    colors[imgui.Col.ButtonHovered] = ImVec4(0.7, 0.1, 0.25, 0.8)
    colors[imgui.Col.ButtonActive] = ImVec4(0.7, 0.1, 0.25, 1.0)
    colors[imgui.Col.Text] = ImVec4(1.0, 1.0, 1.0, 1.0)

    colors[imgui.Col.TitleBg] = ImVec4(0.7137, 0.1725, 0.3137, 1.0)
    colors[imgui.Col.TitleBgActive] = ImVec4(0.7137, 0.1725, 0.3137, 1.0)
    colors[imgui.Col.TitleBgCollapsed] = ImVec4(0.7137, 0.1725, 0.3137, 1.0)
    colors[imgui.Col.Header] = ImVec4(0.7137, 0.1725, 0.3137, 1.0)
    colors[imgui.Col.HeaderHovered] = ImVec4(0.7, 0.1, 0.25, 0.8)
    colors[imgui.Col.HeaderActive] = ImVec4(0.7, 0.1, 0.25, 1.0)

    colors[imgui.Col.ResizeGrip] = ImVec4(0.7137, 0.1725, 0.3137, 0.0)
    colors[imgui.Col.ResizeGripHovered] = ImVec4(0.7137, 0.1725, 0.3137, 0.0)
    colors[imgui.Col.ResizeGripActive] = ImVec4(0.7137, 0.1725, 0.3137, 0.0)

    colors[imgui.Col.SliderGrab] = ImVec4(0.88, 0.26, 0.24, 1.00)
    colors[imgui.Col.SliderGrabActive] = ImVec4(0.98, 0.26, 0.26, 1.00)

    colors[imgui.Col.Separator] = ImVec4(0.7137, 0.1725, 0.3137, 0.0)
    colors[imgui.Col.SeparatorHovered] = ImVec4(0.7137, 0.1725, 0.3137, 0.0)
    colors[imgui.Col.SeparatorActive] = ImVec4(0.7137, 0.1725, 0.3137, 0.0)
end

-- ## устанавливаем переменным размер окна по умолчанию
local window_width = 180
local window_height = 290

-- ## координаты закусочных и их /gps
local food_coords = {
    Blueberry_Pizza = {coords = {203.35, -203.75, 1.58}, gps_cmd = '/gps 9 61'},
    Financial_Pizza = {coords = {-1807.66, 944.85, 24.89}, gps_cmd = '/gps 9 25'},
    Island_Cluckin_Bell = {coords = {3163.80, 13.34, 4.11}, gps_cmd = '/gps 9 72'},
    Spinybed_Burger = {coords = {2171.47, 2795.85, 10.82}, gps_cmd = '/gps 9 55'}
}

-- ## устанавливаем стиль подкатегорий
local function setupSubHeaderStyle()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local ImVec4 = imgui.ImVec4

    colors[imgui.Col.Header] = ImVec4(0.4, 0.0, 0.0, 0.0)
    colors[imgui.Col.HeaderHovered] = ImVec4(0.7, 0.1, 0.25, 0.8)
    colors[imgui.Col.HeaderActive] = ImVec4(0.7, 0.1, 0.25, 1.0)
end

-- ## отправляем /gps серверу
local function sendGpsCommand(command)
    sampSendChat(command)
end

-- ## расчитываем координаты ближайшей закусочной
local function getClosestFood()
    local px, py, pz = getCharCoordinates(PLAYER_PED) -- ## получаем текущие координаты игрока
    local closest_cmd, min_dist = nil, math.huge

    for _, data in pairs(food_coords) do -- ## сверяем каждую закусочную с координатами игрока
        local coords = data.coords
        -- ## логика вычисления расстояния до закусочной
        local dx = coords[1] - px
        local dy = coords[2] - py
        local dz = coords[3] - pz
        local dist = math.sqrt(dx * dx + dy * dy + dz * dz) 

        -- ## если текущая закусочная ближе, чем предыдущая минимальная - обновляем минимальное расстояние и команду
        if dist < min_dist then
            min_dist = dist
            closest_cmd = data.gps_cmd
        end
    end

    return closest_cmd -- ## возвращаем команду /gps соответствующую ближайшей закусочной
end



-- ## выводим окно
imgui.OnFrame(function()
    return window.show_main[0]
end, function()
    --[[## getScreenResolution ## imgui.SetNextWindowPos ## imgui.SetNextWindowSize
      * получаем разрешение экрана
      * по умолчанию выравниваем окно по центру
      * применяем размер установленный переменными "window_width" и "window_height"
    ]]
    local sw, sh = getScreenResolution()
    imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.SetNextWindowSize(imgui.ImVec2(window_width, window_height), imgui.Cond.FirstUseEver)

    setupDarkRedTheme() -- ## устанавливаем общий стиль

    if window.show_main[0] then
        imgui.Begin(string.upper(__name__), window.show_main, imgui.WindowFlags.NoCollapse) -- ## хеадер окна
        if imgui.Button('Ближайшая закусочная') then
            local closest_cmd = getClosestFood()
            if closest_cmd then
                sampSendChat(closest_cmd)
            end
        end        
        
        if imgui.Button('Ближайшая АЗС') then
            -- Пока кнопка без функционала
        end
        
        
        if imgui.CollapsingHeader('Еда') then
            imgui.Indent(10) -- ## добавляем отступ подкатегории
            setupSubHeaderStyle() -- ## применяем стиль подкатегории
            
            -- ## подкатегория Blueberry Pizza
            if imgui.CollapsingHeader('Blueberry Pizza') then -- ## проверяем нажата ли подкатегория
                imgui.Indent(22) -- ## добавляем отступ для текста внутри подкатегории
                imgui.TextWrapped('Цена хот-дога: $375')
                imgui.TextWrapped('Цена тяжелой закуски: $1125')
                imgui.TextWrapped('GPS: /gps 9 61')
                imgui.TextWrapped('Регион: Red County')

                -- ## добавляем кнопку метки
                if imgui.Button('Установить метку##blueberry') then
                    sendGpsCommand('/gps 9 61')
                end
                imgui.Indent(-22) -- ## возвращаем отступ текста в исходное положение
            end
            
            -- ## подкатегория Financial Pizza
            if imgui.CollapsingHeader('Financial Pizza') then
                imgui.Indent(22)
                imgui.TextWrapped('Цена хот-дога: $450')
                imgui.TextWrapped('Цена тяжелой закуски: $1350')
                imgui.TextWrapped('GPS: /gps 9 25')
                imgui.TextWrapped('Регион: San Fierro')

                if imgui.Button('Установить метку##financial') then
                    sendGpsCommand('/gps 9 25')
                end
                imgui.Indent(-22)
            end
            
            -- ## подкатегория Island Cluckin Bell
            if imgui.CollapsingHeader('Island Cluckin Bell') then
                imgui.Indent(22)
                imgui.TextWrapped('Цена хот-дога: $525')
                imgui.TextWrapped('Цена тяжелой закуски: $1575')
                imgui.TextWrapped('GPS: /gps 9 72')
                imgui.TextWrapped('Регион: Red County')

                if imgui.Button('Установить метку##island') then
                    sendGpsCommand('/gps 9 72')
                end
                imgui.Indent(-22)
            end
            
            -- ## подкатегория Spinybed Burger
            if imgui.CollapsingHeader('Spinybed Burger') then
                imgui.Indent(22)
                imgui.TextWrapped('Цена хот-дога: $555')
                imgui.TextWrapped('Цена тяжелой закуски: $1665')
                imgui.TextWrapped('GPS: /gps 9 55')
                imgui.TextWrapped('Регион: Las Venturas')

                if imgui.Button('Установить метку##spinybed') then
                    sendGpsCommand('/gps 9 55')
                end
                imgui.Indent(-22)
            end
            imgui.Unindent(10) -- ## возвращаем отступ после подкатегории в исходное положение
        end
        
        setupDarkRedTheme() -- ## возвращаем общий стиль для категорий
        if imgui.CollapsingHeader('АЗС') then
            imgui.Indent(10)

            --[[## 
              * будущая реализация азс
            ]]

            imgui.Unindent(10)
        end

        -- ## выводим текст в стиле подсказки
        imgui.TextDisabled('Info')
        if imgui.IsItemHovered() then -- ## показываем если курсор наведен
            imgui.BeginTooltip() -- ## начало блока подсказки
            imgui.PushTextWrapPos(450) -- ## минимальная ширина окна текста подсказки
            imgui.TextUnformatted('Authors: ' .. __authors__)
            imgui.PopTextWrapPos() -- ## возвращаем текстовую ширину к исходной
            imgui.EndTooltip() -- ## конец блока
        end
        
        imgui.End()
    end
end)

-- ## код открытия окна
function main()
    while true do
        wait(0)
        if wasKeyPressed(vk.VK_OEM_MINUS) then -- ## активируем окно нажатием кнопки "-"
            window.show_main[0] = not window.show_main[0]
        end
    end
end