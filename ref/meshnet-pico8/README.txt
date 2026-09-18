MESHNET - Lifeline-подобная игра на pico-8 про Meshtastic
==========================================================
Дата: 17.09.2026
Содержимое: 11 экранов (артбордов) + весь текст с них + данные графа


1. ЧТО ЭТО
----------
Ядро игры: переписка с человеком, который застрял где-то в горах, и
связь идёт через меш-сеть Meshtastic. Игрок сидит у своего узла,
получает её сообщения с задержкой и выбирает ответ из двух вариантов.
Как в Lifeline, только вместо спутниковой связи LoRa-меш, и все его
ограничения становятся драматургией:

- задержка ответа - она идёт, ей нужно время, и это реальное время;
- NO ACK - твоё сообщение ушло, но подтверждения нет, неизвестно
  дошло ли;
- лимит хопов - если узел-ретранслятор умер, до неё физически не
  добить, сколько ни пиши;
- батарея - у неё и у твоего узла, ночью солнечные узлы засыпают;
- размер пакета - в LoRa он крошечный, поэтому длинный тёплый ответ
  дороже сухой команды.

Граф из твоей исходной картинки стал КАРТОЙ СЮЖЕТА: узлы = сцены,
рёбра = выборы. Отдельно есть второй граф, сетевой (кто через кого
ретранслирует), он лежит во втором ряду как запас.

Персонажа зовут MIRA. Название MESHNET - заглушка, меняй.


2. СТИЛЬ
--------
Палитра: 3 цвета из палитры pico-8
  0  #000000  чёрный          фон
  3  #008751  тёмно-зелёный   мета-данные, слабые связи, неактивное
  11 #00E436  салатовый       её слова, твой выбор, пройденная ветка

Правило чтения: ярко-зелёное = то, что важно сейчас (её сообщения,
пройденная ветка, активная кнопка). Тёмно-зелёное = служебное
(таймстемпы, хопы, SNR, твои отправленные реплики).

Размер экранов 512x512 = экран pico-8 128x128 в масштабе 4х. Все
размеры кратны 4 px, сглаживания нет, скруглений нет.

Шрифт: Silkscreen как стенд-ин встроенного шрифта pico-8 (4x6 px).
Встроенный шрифт только ASCII, кириллицы нет. Поэтому весь текст
латиницей. Если нужен русский, придётся рисовать шрифт в спрайтах и
печатать своей функцией.


3. ЭКРАНЫ, РЯД 1: ЯДРО LIFELINE
-------------------------------

--- Chat.dc.html - "Chat A - radio log" ---------------------
Главный экран, вариант А. Стиль радио-лога: никаких пузырей, входящее
с префиксом >, исходящее с префиксом <, над каждым сообщением
мета-строка.

Полный текст экрана:

  шапка:        MIRA                     3 HOPS  -9DB
  статус:       LAST ACK 19:22   BAT 41%   QUEUE 1

  MIRA 19:04 - 2 HOPS
  > THE RIDGE NODE IS DEAD. I CAN SEE ITS PANEL FROM HERE. SNOW.

  ME 19:06 - ACK
  < HOW MUCH BATTERY DO YOU HAVE?

  MIRA 19:22 - 3 HOPS
  > 41%. TOWER IS 12 KM UPHILL, THE FARM IS 15 DOWNHILL.

  ME 19:23 - NO ACK, RETRY 2
  < STAY PUT.

  REPLY                                      PAYLOAD 237B
  [ TAKE THE TOWER ROUTE                              22B ]
  [ GO DOWNHILL TO THE FARM                           24B ]

  после выбора:
  SENT 19:44 - 22B
  < TAKE THE TOWER ROUTE
  NO ACK YET - RETRY 1/5 - TTL 3
  [ X   WAIT FOR HER ]

Интерактив рабочий: жмёшь вариант, он уходит, панель переключается в
состояние ожидания подтверждения, оттуда переход на экран Waiting.

--- Chat-B.dc.html - "Chat B - bubbles" ---------------------
Тот же экран, вариант Б. Пузыри: входящие слева обводкой, исходящие
справа заливкой, неподтверждённое - пунктирной рамкой. В шапке
пиксельные полоски сигнала (3 из 5) и батарейка 41%.

Текст тот же, что в варианте А, но реплики без префиксов, а
мета-строка под пузырём:
  19:04 - 2 HOPS / 19:06 - ACK / 19:22 - 3 HOPS / 19:23 - NO ACK
  PICK ONE                                   PAYLOAD 237B
  [ > TAKE THE TOWER ROUTE                            22B ]
  [ > GO DOWNHILL TO THE FARM                         24B ]

Выбирай один из двух вариантов, дальше доведу выбранный.
Мой выбор: А честнее для pico-8 и для темы радио, Б понятнее
человеку, который никогда не держал в руках рацию.

--- Story-Map.dc.html - "Story map" -------------------------
Тот самый граф, теперь карта сюжета. Узлы = сцены, рёбра = выборы.
Ярким подсвечена пройденная ветка, пунктиром непройденное.
Узлы кликабельные, внизу карточка сцены.

  шапка:  STORY MAP // 4 OF 9 SEEN           NIGHT 1
  легенда: BRIGHT = THE BRANCH YOU TOOK
  подписи рёбер: WAIT, WALK, TRUTH, PUSH ON, SLEEP

Сцены (id / название / состояние / как попал / текст карточки):

  S1  FIRST CONTACT   SEEN
      NIGHT 1 - 19:04
      SHE PINGS A CHANNEL SHE DOES NOT KNOW YOU ARE ON.

  S2  THE DEAD RIDGE  SEEN
      VIA WAIT
      YOU TOLD HER TO HOLD STILL AND LET THE MESH FIND A ROUTE.

  S3  THE LONG SLEEP  UNSEEN
      VIA SLEEP
      THE BRANCH WHERE YOU CLOSE THE APP FIRST. SHE WAKES ALONE.

  X1  LOST CONTACT    DEAD END
      VIA PUSH ON
      SHE WALKED OUT OF RANGE MID-SENTENCE. NO ACK EVER CAME.

  S5  TWO ROUTES      SEEN
      VIA WALK
      TOWER 12 KM UPHILL OR FARM 15 KM DOWNHILL. SHE ASKS YOU TO PICK.

  S6  THE FARM DOG    UNSEEN
      VIA SLEEP
      ONLY REACHABLE FROM THE BRANCH YOU HAVE NOT PLAYED.

  S7  TOWER CLIMB     UNSEEN
      VIA TOWER
      THE SHORT ROUTE. COSTS HER BATTERY SHE MAY NOT HAVE.

  S8  FARM GATE       YOU ARE HERE
      VIA WAIT > WALK > TRUTH
      SHE IS AT THE GATE, 41% BATTERY, WAITING FOR YOUR NEXT PACKET.

  S9  DAWN            LOCKED
      BOTH ROUTES MEET HERE
      NIGHT 1 ENDS HERE, WHICHEVER WAY YOU SENT HER.

Рёбра карты сюжета:
  S1-S2 (WAIT)   S1-S3 (SLEEP)
  S2-X1 (PUSH ON, мёртвый конец)   S2-S5 (WALK)
  S3-S5   S3-S6
  S5-S7 (TOWER)   S5-S8 (TRUTH)   S6-S8
  X1-S7 (пунктир, недостижимо)
  S7-S9   S8-S9

Смысл: игрок видит не только что он выбрал, но и что потерял. Ветка
X1 обрывается не по его глупости, а потому что связь умерла на
середине фразы, и это ровно то ощущение, которое даёт настоящий меш.

--- Waiting.dc.html - "Waiting (real time)" -----------------
Сигнатурный экран Lifeline: ждёшь в реальном времени.

Полный текст:

  шапка:  WAITING // REAL TIME                TTL 3
  MIRA IS WALKING TO THE FARM GATE
  04:12
  прогресс: 12 блоков, 5 залиты

  LAST PACKET     19:22 - 3 HOPS
  YOUR REPLY      SENT, NO ACK, RETRY 2/5
  BATTERY         HER 41% - YOU 78%
  NEXT WINDOW     19:48, WHEN SHE CRESTS

  CLOSE THE GAME IF YOU WANT. THE MESH HOLDS HER MESSAGE AND THE NODE
  WILL BUZZ YOU WHEN IT LANDS.

  [ X   BACK TO THREAD ]   [ Z   CHECK ROUTE ]

Смысл: NEXT WINDOW это не просто таймер, а физика. Она поднимается на
гребень, оттуда прямая видимость, оттуда пакет дойдёт. Ожидание
получает объяснение внутри мира.

--- Offline.dc.html - "No route" ----------------------------
Состояние обрыва. Шапка инвертирована (заливка салатовым, текст
чёрным), чтобы читалась как авария без красного цвета.

Полный текст:

  шапка:  NO ROUTE TO MIRA                    19:41
  цепочка: YOU --- HILL --X-- TOWER --- MIRA
           (первый линк живой, дальше разрыв с крестом)

  TOWER WENT QUIET AT 19:26. WITHOUT IT SHE IS 4 HOPS AWAY AND THE
  LIMIT IS 3.

  QUEUED                                    3 MSG - 64B
  19:23 STAY PUT.                                   22B
  19:31 WHERE ARE YOU                               18B
  19:40 ANSWER IF YOU CAN                           24B

  AUTO RETRY IN                                   00:48

  [ Z   REROUTE VIA FARM                    15KM -14DB ]
  [ X   WAIT FOR THE TOWER ]

Смысл: очередь неотправленных сообщений это лучший эмоциональный
инструмент в игре. Игрок видит три своих непрочитанных фразы и
понимает, что кричал в пустоту.


4. ЭКРАНЫ, РЯД 2: СЕТЕВОЙ СЛОЙ (запас, подкручен под сюжет)
-----------------------------------------------------------

--- Main.dc.html - "Net map (Dijkstra)" ---------------------
Карта сети: через кого идёт переписка. Узлы = устройства, цифра на
ребре = км, метка d=NN = кратчайшая стоимость от твоего узла,
ярким подсвечен оптимальный маршрут. Узлы кликабельные.

  шапка:  NET MAP // DIJKSTRA              HOP LIMIT 3
  метки:  YOU (у A), MIRA (у E)
  легенда: KM PER LINK / BRIGHT = BEST ROUTE
  HUD:    имя, статус, роль, SNR, батарея, линки,
          PATH A>B>D  COST 22,  Z PING

Узлы:
  A HOME   ROUTER    ONLINE  d0
     YOUR NODE. SOLAR, ALWAYS ON. EVERY PACKET YOU SEND STARTS HERE.
  B HILL   REPEATER  ONLINE  d10
     LAST CONFIRMED HOP. IT RELAYED HER 19:22 MESSAGE TO YOU.
  C FARM   CLIENT    WEAK    d15
     SENDS ITS OWN DATA, NEVER RELAYS YOURS. A DEAD END FOR HER.
  D TOWER  ROUTER    DOWN    d22
     THE HUB. IT WENT QUIET AT 19:26, WHICH IS WHY SHE HAS NO ROUTE.
  E MIRA   TRACKER   DOWN    d24
     HER HANDHELD. 24 KM OF LINKS AWAY, 3 HOPS IF TOWER WAKES UP.
  F RIDGE  REPEATER  DOWN    d23
     THE NODE SHE CAN SEE FROM WHERE SHE STANDS. PANEL UNDER SNOW.

Рёбра (км): A-B 10, A-C 15, B-D 12, B-F 15, C-E 10, D-E 2, D-F 1, F-E 5
Дейкстра от A: d(A)0 d(B)10 d(C)15 d(D)22 d(F)23 d(E)24
Кратчайший путь до неё: A > B > D > E = 24 км, 3 хопа.
Ловушка: A-C всего 15, но из C до E ещё 10, итого 25. Жадный первый
шаг проигрывает.

--- Dijkstra.dc.html - "Dijkstra, step by step" --------------
Алгоритм честно считается внутри макета. Кнопка STEP делает один шаг:
узлы из d=INF получают стоимость, узел в очереди получает кольцо,
обработанный заливается, рёбра дерева предков зажигаются.

  шапка:  DIJKSTRA // ROUTE SOLVER            STEP 1/6
  VISIT    A
  QUEUE    B10 C15
  TO CITY  24 VIA A>B>D>E
  U <- POP-MIN(Q)
  D[V] = MIN( D[V], D[U]+W )
  [ Z  STEP ]   [ X  RESET ]

Порядок обработки: A(0) > B(10) > C(15) > D(22) > F(23) > E(24).

--- Hops.dc.html - "Managed flood" ---------------------------
Как реально летит пакет. Настоящий алгоритм Meshtastic называется
managed flood routing.

  шапка: MANAGED FLOOD // NO ROUTES              TTL 3
  цепочка HOME > HILL > TOWER > CITY, кольца радиуса,
  счётчики TTL 3 > 2 > 1
  DASHED RING = RADIO RANGE          O(N) / PACKET

  1 A NODE REBROADCASTS ANYTHING IT HEARS. NOBODY ROUTES, EVERYBODY
    SHOUTS - THAT IS THE FLOOD.
  2 EACH REBROADCAST BURNS ONE HOP. AT TTL 0 THE PACKET DIES WHERE
    IT IS.
  3 SEEN THIS PACKET ID BEFORE? DROP IT. ONE DEDUPE SET KILLS EVERY
    LOOP.

  DIJKSTRA PICKS THE ROUTE. THE FLOOD IGNORES IT.

--- Node-Card.dc.html - "Node info" --------------------------
Карточка устройства.

  шапка: NODE INFO // 04 OF 06            d=22 FROM HOME
  TOWER / ROUTER / SOLAR / BAT 88% / SNR -5DB
  WHY IT MATTERS
  TOWER WENT QUIET AT 19:26. IT IS THE ONLY SHORT ROUTE TO MIRA.
  WITHOUT IT SHE IS 4 HOPS OUT AND THE LIMIT IS 3.
  LINKS: RIDGE 1 KM, CITY 2 KM, HILL 12 KM
  [ Z  PING NODE ]  [ X  BACK ]


5. ЭКРАНЫ, РЯД 3: СПРАВОЧНОЕ
----------------------------

--- Codex.dc.html - "Algo codex" -----------------------------
Гиковая энциклопедия внутри игры, 6 записей с асимптотикой:

  1 DIJKSTRA       O(E LOG V)  MAP SCREEN. CHEAPEST ROUTE BY LINK COST.
  2 MANAGED FLOOD  O(N)        THE REAL RADIO. NO ROUTES, JUST
                               REBROADCAST.
  3 MIN-HEAP       O(LOG N)    THE QUEUE DIJKSTRA POPS THE NEXT NODE
                               FROM.
  4 BFS            O(V+E)      HOP RINGS. ALL NODES WITHIN TTL, COST
                               IGNORED.
  5 DEDUPE SET     O(1)        PACKET ID SEEN BEFORE? DROP IT. NO LOOPS.
  6 NEXT-HOP       O(1)        NEWER FIRMWARE. REMEMBER WHO RELAYED,
                               ASK THEM.

  THE MAP SCREEN RUNS 1. THE RADIO RUNS 2. THAT GAP IS THE GAME.

Хорошо работает как награда: прошёл сцену - открыл запись.

--- Kit.dc.html - "Style kit" --------------------------------
Техлист: палитра с индексами pico-8, образцы шрифта, 4 состояния узла
(CLEARED / OPEN / LOCKED / SELECTED), 3 типа связи (BEST ROUTE / LINK
/ WEAK LINK) и правила: размеры кратны 4 px, без сглаживания,
d=NN у узла это стоимость по Дейкстре, ярко-зелёный это вывод
алгоритма.


6. МЕХАНИКИ, КОТОРЫЕ УЖЕ ЗАШИТЫ В МАКЕТЫ
----------------------------------------
- PAYLOAD. У варианта ответа есть цена в байтах (22B, 24B), в шапке
  общий лимит 237B. Длинная эмоциональная реплика дороже команды.
  Это главный рычаг: игрок выбирает между "быть тёплым" и "быть
  эффективным", и выбор стоит физического ресурса.
- ACK. Каждое твоё сообщение имеет статус: ACK, NO ACK, RETRY n/5.
  Ты никогда не уверен, что она прочитала.
- HOPS. У её сообщений указано, через сколько узлов они пришли.
  Растёт число хопов - растёт задержка и шанс потери.
- TTL. Лимит хопов 3. Если ретранслятор умер и она в 4 хопах, ты
  физически не можешь ей написать, хоть жми что угодно.
- БАТАРЕЯ. У неё падает быстрее, когда она идёт. Ночью солнечные
  узлы засыпают.
- РЕАЛЬНОЕ ВРЕМЯ. NEXT WINDOW привязан к тому, где она находится, а
  не к абстрактному таймеру.
- ОЧЕРЕДЬ. Неотправленные сообщения видны списком. Три фразы в пустоту
  читаются сильнее любой драматической музыки.


7. ФАЙЛЫ
--------
project/canvas.json         индекс канваса: позиции артбордов, заметки
project/Chat.dc.html        главный экран, вариант A (радио-лог)
project/Chat-B.dc.html      главный экран, вариант B (пузыри)
project/Story-Map.dc.html   карта сюжета (граф сцен и выборов)
project/Waiting.dc.html     ожидание в реальном времени
project/Offline.dc.html     обрыв связи, очередь сообщений
project/Main.dc.html        карта сети (Дейкстра)
project/Dijkstra.dc.html    пошаговая Дейкстра
project/Hops.dc.html        managed flood
project/Node-Card.dc.html   карточка устройства
project/Codex.dc.html       кодекс алгоритмов
project/Kit.dc.html         style kit

Формат .dc.html: самостоятельные страницы редактора Design. Локально
в браузере они не откроются как есть, потому что подключают
support.js, который отдаёт сам артефакт. Смотреть и править в канвасе,
картинки и PDF вытаскиваются экспортом оттуда же. Нужны PNG отдельными
файлами - скажи, соберу.

Перенос в pico-8: делишь все размеры на 4. Экран 512 = 128, узел 32 =
8 px спрайт, шрифт 16 = встроенный 4x6.


8. ЧТО ДОБАВИТЬ ДАЛЬШЕ
----------------------
- Экран ветки-смерти: как выглядит LOST CONTACT, когда он случился.
- Ночь: солнечные узлы засыпают, карта сети гаснет наполовину.
- Экран уведомления на закрытой игре (её сообщение пришло, пока тебя
  не было).
- Экран эфира: две передачи в одном канале, коллизия.
- Русский шрифт спрайтами, если интерфейс должен быть на русском.
