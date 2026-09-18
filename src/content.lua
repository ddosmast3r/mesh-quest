-- Static copy and topology live here so scenes contain behavior only.

content={}

content.boot_checks={
 {label="sx1262 radio",value="ok"},
 {label="region",value="eu868"},
 {label="mesh scan",value="ready"}
}

content.new_game_item={
 label="opcaG jdra",
 action="new_game",
 sfx=4
}

content.continue_item={
 label="qrpepmhjtD",
 action="continue",
 sfx=4
}

content.settings_item={
 label="oastrpklj",
 target="settings",
 sfx=1
}

content.setting_items={
 {label="audio",key="sound"},
 {label="map grid",key="grid"}
}

-- Stylized north-up Pyatigorsk map: city below, Mount Mashuk above.
content.menu_nodes={
 {13,27,"a","online",true},
 {28,40,"b","online"},
 {40,61,"c","online"},
 {55,78,"d","down"},
 {72,61,"e","down"},
 {52,39,"f","weak"},
 {71,28,"g","down"},
 {110,66,"h","weak"},
 {90,44,"i","down"},
 {105,27,"m","down",false,true}
}

content.menu_links={
 {1,2,true},{2,3,true},{3,4,true},{4,5,true},
 {5,9,true},{9,10,true},{2,6,false,true},{6,7},
 {7,10},{4,8,false,true},{5,8},{8,9},{3,6},{6,4}
}
