<div align="center">

![img-logo]

<div align="left">

# Ознакомление
BestPrices это вспомогательный lua скрипт для сервера Evolve RolePlay, который упрощает поиск самых выгодных бизнесов и позволяет быстро устанавливать GPS-метки к ним.
<details>
<summary>Превью интерфейса главного меню в игре</summary>  
<br>

![img-info-example]
![img-snack-example]
![img-gas-example]
![img-store-example]
</details>

## Установка

<div align="left">

1. Установите [MoonLoader](https://www.blast.hk/moonloader)
2. Загрузите архив с актуальной версией скрипта и зависимостями на [странице релизов](https://github.com/THE-KEGARE/ERPBP/releases/)
3. Разархивируйте содержимое архива в папку `moonloader`
4. Активируйте меню скрипта при помощи команды `/prices`

## Использование
<details>
<summary>Вкладки и контент</summary>
<br>
В скрипте предусмотрено удобное разделение по категориям, чтобы вы могли быстро находить нужные заведения.
<br></br>

В верхней части меню, находятся вкладки, разделяющие бизнесы по типам: закусочные, автозаправочные станции и магазины. Они выглядят так: 

![img-tabs-preview]

В каждой категории представлены заведения, отсортированные от самых дешевых к самым дорогим. Для удобства, вы можете раскрывать и скрывать информацию о заведениях по своему выбору.
По нажатию на конкретное заведение вы увидите примерно следующее:

![img-tabs-content]

У каждого заведения, есть своя кнопка "Установить метку", которая автоматически установит GPS-метку на карте.
<br></br>
Отдельно стоит упомянуть, что у каждой категории есть своя кнопка для поиска ближайшего заведения, которая всегда находится в самом низу выбранной категории. Подробная информация об этом находятся в самом низу.

</details>

<details>
<summary>Хоткей</summary>
<br>

Благодаря библиотеке [mimgui_hotkeys](https://github.com/THE-KEGARE/ERPBP?tab=readme-ov-file#%D1%81%D1%81%D1%8B%D0%BB%D0%BA%D0%B8), в скрипте есть возможность выбирать горячую клавишу для открытия меню.

![img-hotkey]

Для этого, перейдите во вкладку "Настройки", кликните по кнопке возле надписи "Открыть меню", и нажмите желаемую клавишу.

![img-hotkey-set]

На данный момент, выбирать можно только клавишу активаиции меню. Функционал хоткеев планируется расширить в будущем. 

</details>

<details>
<summary>Ближайшее заведение</summary>
<br>
Существуют два способа установить метку на ближайшее заведение нужной категории:
<br>

### При помощи команд
На данный момент, их всего три:
<br>

```/ceat``` для закусочных,
```/cgas``` для заправок, и
```/cstore``` для 24/7.

Отправив команду нужной категории в чат, скрипт установит метку на ближайшее заведение.

![img-closest-cmd]

### При помощи меню

Данный метод еще проще. Открыв меню, выбираем вкладку нужной категории. Как было сказано ранее, внутри каждой из них, в самом низу, всегда находится кнопка "Установить ближайшую метку". 
<br>
Нажав на нее, установится метка выбранной категории.

![img-closest-button]

### Как это работает?
Теперь поговорим о том, как именно работает система. Механизм поиска ближайшего заведения реализован с использованием расчетов расстояния между текущими координатами игрока и координатами каждого заведения в категории.
<br>
Процесс выглядит следующим образом:
1. Получение координат игрока. Используется функция ```getCharCoordinates(PLAYER_PED)``` для определение текущего местоположения игрока в формате ```(x, y, z)```.
2. Итерация по таблице объектов. Каждая категория заведений, хранится в отдельной таблице, такой как x_coords. Для каждого объекта из таблицы берутся его координаты и команда /gps.
3. Расчет расстояния до объекта. Для вычисления расстояния между игроком и объектом применяется такая логика:
```lua
local dx = coords[1] - px
local dy = coords[2] - py
local dz = coords[3] - pz
local dist = math.sqrt(dx * dx + dy * dy + dz * dz)
``` 
```coords[1], coords[2], coords[3]``` — координаты заведения.
```px, py, pz``` — координаты игрока.
<br>

4. Сравнение расстояний. В процессе перебора, сравнивается текущее рассчитанное расстояние ```dist``` с минимальным расстоянием, хранящимся в переменной ```min_dist```. Если объект находится ближе, обновляются значения ```min_dist``` и соответствующей команды gps.
5. Возврат команды ```/gps```. После завершения цикла, функция возвращает команду ближайшего объекта, которая указывает серверу, куда нужно проложить маршрут.
6. Отправка команды. Полученная команда передается на сервер через вызов sampSendChat(command).
<br>
Не исключено, что алгоритм будет дорабатываться в будущем. Пока это лишь его первая версия, и тем не менее, он работает вполне отлично.

</details>




## Ссылки
Evolve RolePlay: http://evolve-rp.ru/  
MoonLoader: http://blast.hk/moonloader/  
mimgui: http://github.com/THE-FYP/mimgui/  
mimgui_hotkeys: http://www.blast.hk/threads/178867/

## Авторы
[Kegare](https://github.com/THE-KEGARE/), [chizusrevenge](https://github.com/chizusrevenge)

<sub>Примечание: скрипт все еще в разработке. Возможны баги и недочеты, а функциональность может измениться.  
Если вы играете на лаунчере и у вас установлен G-TOOLS, курсор может мерцать.</sub>

<!-- Images -->
[img-logo]: <src/images/05b76d7eda2.png>
[img-info-example]: <src/images/mx4WnyU.png>
[img-snack-example]: <src/images/7LGVlfF.png>
[img-gas-example]: <src/images/0qU9ra1.png>
[img-store-example]: <src/images/1Ppl6MS.png>
[img-tabs-preview]: <src/images/8iZYNv7.png>
[img-tabs-content]: <src/images/oqg7sz7.png>
[img-hotkey]: <src/images/mjrzW58.png>
[img-hotkey-set]: <src/images/SUMxAbr.png>
[img-closest-button]: <src/images/ddisPDWSg3.gif>
[img-closest-cmd]: <scr/images/72zdcDyZk5.gif>

<!-- URLs -->
[url-ml]: <https://www.blast.hk/moonloader/>
