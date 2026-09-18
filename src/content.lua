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
 notice="nedoctupno",
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

-- Original ten-node menu backdrop from the first approved title screen.
content.menu_nodes={
 {x=13,y=63,phase=0},
 {x=35,y=53,phase=1},
 {x=57,y=70,phase=2},
 {x=82,y=56,phase=3},
 {x=109,y=65,phase=4},
 {x=25,y=89,phase=5},
 {x=49,y=100,phase=6},
 {x=76,y=87,phase=7},
 {x=103,y=97,phase=8},
 {x=116,y=82,phase=9}
}

content.menu_links={
 {1,2},{2,3},{3,4},{4,5},
 {1,6},{2,6},{3,7},{3,8},
 {4,8},{5,10},{6,7},{7,8},
 {8,9},{9,10}
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
