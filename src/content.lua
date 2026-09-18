-- Static copy and topology live here so scenes contain behavior only.

content={}

content.boot_checks={
 {label="sx1262 radio",value="ok"},
 {label="region",value="eu868"},
 {label="mesh scan",value="ready"}
}

content.new_game_item={
 label="novaq igra",
 notice="net cujeta",
 sfx=4
}

content.continue_item={
 label="prodoljits",
 notice="nedoctfpno",
 sfx=4
}

content.settings_item={
 label="nactroyki",
 target="settings",
 sfx=1
}

content.setting_items={
 {label="audio",key="sound"},
 {label="map grid",key="grid"}
}

-- Stylized north-up Pyatigorsk map: city below, Mount Mashuk above.
content.menu_nodes={
 {x=13,y=27,label="a",name="kvartal",status="online",route=true,source=true},
 {x=28,y=40,label="b",name="beshtau",status="online",route=true},
 {x=40,y=61,label="c",name="center",status="online",route=true},
 {x=55,y=78,label="d",name="tsvetnik",status="down",route=true},
 {x=72,y=61,label="e",name="cable",status="down",route=true},
 {x=52,y=39,label="f",name="duel",status="weak"},
 {x=71,y=28,label="g",name="north trail",status="down"},
 {x=110,y=66,label="h",name="proval",status="weak"},
 {x=90,y=44,label="i",name="upper station",status="down",route=true},
 {x=105,y=27,label="m",name="mashuk",status="down",route=true,goal=true}
}

content.menu_links={
 {from=1,to=2,route=true},
 {from=2,to=3,route=true},
 {from=3,to=4,route=true},
 {from=4,to=5,route=true},
 {from=5,to=9,route=true},
 {from=9,to=10,route=true},
 {from=2,to=6,weak=true},
 {from=6,to=7},
 {from=7,to=10},
 {from=4,to=8,weak=true},
 {from=5,to=8},
 {from=8,to=9},
 {from=3,to=6},
 {from=6,to=4}
}

content.nodes={
 {id="a",label="a",x=12,y=52,dx=8,dy=42,dist=0,status="online",route=true},
 {id="b",label="b",x=38,y=25,dx=32,dy=14,dist=10,status="online",route=true},
 {id="c",label="c",x=53,y=83,dx=47,dy=72,dist=15,status="weak",route=false},
 {id="d",label="d",x=63,y=57,dx=57,dy=46,dist=22,status="down",route=true},
 {id="e",label="e",x=113,y=64,dx=107,dy=49,dist=24,status="down",route=true,goal=true},
 {id="f",label="f",x=89,y=28,dx=83,dy=17,dist=23,status="down",route=false}
}

content.links={
 {from=1,to=2,cost=10,route=true},
 {from=1,to=3,cost=15,weak=true},
 {from=2,to=4,cost=12,route=true},
 {from=2,to=6,cost=15,weak=true},
 {from=4,to=6,cost=1},
 {from=4,to=5,cost=2,route=true},
 {from=6,to=5,cost=5},
 {from=3,to=5,cost=10}
}

content.cost_labels={
 {25,37,"10",true},
 {31,68,"15"},
 {63,23,"15"},
 {52,37,"12",true},
 {78,38,"1"},
 {88,62,"2",true},
 {103,34,"5"},
 {83,67,"10"}
}
