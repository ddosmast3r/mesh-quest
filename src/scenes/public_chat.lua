scenes.public_chat={
 greetings={
  "csfn qrjcft. G tut opcCk.",
  "qrjcft. tpmDlp qpelmFyjmsG.",
  "fstD ltp hjcpk?"
 },
 seed={
  {"R0UTER","oa 868 sfdpeoG zun qpeoGmsG"},
  {"MOTH","of zun. jocfrsjG qpsmf ialata"},
  {"LIS","ada. muoa pqGtD ptrahaft qalftC"},
  {"D3D","nfrlurjk c rftraosmGxjj"},
  {"R0UTER","snfzop. G cyfra +4 eb qpknam"}
 }
}

local function chat_add(s,name,body,status)
 add(s.messages,{name=name,body=body,status=status})
 if #s.messages>8 then deli(s.messages,1) end
 audio.play(1)
end

function scenes.public_chat.enter()
 local s=scenes.public_chat
 s.messages={}
 s.seed_index=1
 s.phase="intro"
 s.time=0
 s.choice=1
 s.wx_online=false
 s.callsign=s.callsigns and s.callsigns[save.callsign()] or ({"HOME","NULL","MESHOK"})[save.callsign()]
 chat_add(s,s.seed[1][1],s.seed[1][2])
end

function scenes.public_chat.update()
 local s=scenes.public_chat
 s.time+=1
 if s.phase=="intro" then
  if s.time>75 or input.confirm_pressed() then
   s.time=0
   s.seed_index+=1
   if s.seed_index<=#s.seed then
    chat_add(s,s.seed[s.seed_index][1],s.seed[s.seed_index][2])
   else
    s.phase="thought"
   end
  end
 elseif s.phase=="thought" then
  if input.confirm_pressed() then s.phase="greeting" end
 elseif s.phase=="greeting" then
  if btnp(2) then s.choice=(s.choice+1)%3+1 end
  if btnp(3) then s.choice=s.choice%3+1 end
  if btnp(4) then
   save.greeting(s.choice)
   chat_add(s,s.callsign,s.greetings[s.choice],"24b / sent")
   s.choice=1
   s.phase="ignored"
   s.time=0
  end
 elseif s.phase=="ignored" then
  if s.time==90 then chat_add(s,"MOTH","ltp oa sfcfrf cjejt qpdpeoCk uifm?") end
  if s.time==180 then
   chat_add(s,"R0UTER","u nfoG qrpqam qpsmf ialata")
   s.phase="relay"
   s.time=0
  end
 elseif s.phase=="relay" then
  if btnp(4) then
   s.phase="window"
   s.time=0
  end
 elseif s.phase=="window" then
  if btnp(4) then
   chat_add(s,s.callsign,"iaqrps l qpdpeopnu uimu","31b / sent")
   s.phase="recover"
   s.time=0
  end
 elseif s.phase=="recover" then
  if s.time==60 then
   s.wx_online=true
   chat_add(s,"WX-3","tfnqfratura -2.1, cmahopstD 81%")
  elseif s.time==125 then
   chat_add(s,"R0UTER","sfcfroCk uifm, of ecjdak ustrpkstcp. yfrfi tfbG cjeop qpdpeu")
  elseif s.time==205 then
   chat_add(s,"LIS","qpieracmGF. tfqfrD tC nfbfmD")
  elseif s.time>280 then
   s.phase="final"
  end
 elseif s.phase=="final" and input.confirm_pressed() then
  game.back_to_menu()
 end
end

local function chat_messages(s)
 local y=14
 local first=max(1,#s.messages-3)
 for i=first,#s.messages do
  local m=s.messages[i]
  print(m.name,4,y,m.name==s.callsign and 10 or 11)
  y+=7
  local lines=ui.cyr_wrap(m.body,80)
  for j=1,#lines do
   ui.cyr_text(lines[j],7,y,6)
   y+=6
  end
  if m.status then
   print(m.status,7,y,5)
   y+=7
  end
  y+=3
 end
end

local function chat_choice(s,title,items)
 rectfill(3,77,88,126,0)
 rect(3,77,88,126,3)
 ui.cyr_text(title,7,82,11)
 for i=1,#items do
  local c=i==s.choice and 10 or 6
  local lines=ui.cyr_wrap((i==s.choice and "> " or "  ")..items[i],77)
  ui.cyr_text(lines[1],7,92+(i-1)*10,c)
 end
end

function scenes.public_chat.draw()
 local s=scenes.public_chat
 chat_art.frame()
 if s.phase=="window" or s.phase=="recover" then
  chat_art.network(s.wx_online)
 else
  chat_messages(s)
 end
 if s.phase=="thought" then
  rectfill(4,80,87,124,0)
  rect(4,80,87,124,11)
  local lines=ui.cyr_wrap("Etp tpyop yat djlpc? jmj lpsnpoactpc-astrpmpdpc-tarpmpdpc?",76)
  for i=1,#lines do ui.cyr_text(lines[i],8,85+(i-1)*7,10) end
 elseif s.phase=="greeting" then
  chat_choice(s,"ytp oaqjsatD?",s.greetings)
 elseif s.phase=="relay" then
  chat_choice(s,"",{"qpstacjtD ustrpkstcp u ploa"})
 elseif s.phase=="window" then
  chat_choice(s,"sjdoam stam muyzf",{"ptqracjtD iaqrps"})
 elseif s.phase=="final" then
  rectfill(7,43,120,84,0)
  rect(7,43,120,84,11)
  ui.cyr_centered("nof ptcftjmj.",57,10)
  ui.cyr_centered("dmacopf nfoF",70,3)
 end
end
