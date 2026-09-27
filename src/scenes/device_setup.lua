scenes.device_setup={
 texts={
  "spefrhjnpf lprpblj",
  "soayama aotfooa. of wpyu sqamjtD raejp c qfrcCk hf efoD.",
  "c GAjlf bCm labfmD takq-sj.",
  "lpnqDFtfr fdp of cjejt. tpmDlp iarGela.",
  "def-tp bCm erudpk labfmD...",
  "pt starpdp dfknqaea. Etpt wptG bC s eaooCnj.",
  "tfqfrD ustrpkstcp qpGcjmpsD c sjstfnf.",
  "erakcfr ustaopcmfo.",
  "iahatD but j oahatD vmEz.",
  "qrpzjcla iacfrzfoa.",
  "tfmfvpo oazgm opcCk uifm.",
  "lal nfoG bueut cjeftD c sftj?"
 },
 actions={
  "psnptrftD lpnqmflt","qrjlrutjtD aotfoou","oaktj labfmD","qrpcfrjtD",
  "qpjslatD fAg","iahatD labfmD","qpelmFyjtD","ustaopcjtD",
  "qrpzjtD","eamDzf","qpelmFyjtD","dptpcp"
 },
 callsigns={"HOME","NULL","MESHOK"}
}

function scenes.device_setup.enter()
 local s=scenes.device_setup
 s.phase=1
 s.choice=save.callsign()
 s.notice=nil
 input.pointer_enter(s,64,64)
end

function scenes.device_setup.update()
 local s=scenes.device_setup
 local clicked=input.pointer_update(s)
 if s.phase==12 then
  if btnp(0) or btnp(2) then s.choice=(s.choice+1)%3+1 end
  if btnp(1) or btnp(3) then s.choice=s.choice%3+1 end
 end
 if clicked then
  if s.keyboard_click or input.inside(s,{12,94,116,122}) then
   if s.phase<12 then
    s.phase+=1
    s.notice=nil
    audio.play(1)
   else
    save.callsign(s.choice)
    game.open_chat()
   end
  elseif not s.notice then
   s.notice="efkstcjf ofmDiG jsqprtjtD. nphop qrpbpcatD sopca."
  end
 end
end

local function setup_caption(s)
 local lines=ui.cyr_wrap(s.texts[s.phase],112)
 local h=#lines*7+20
 local y=128-h
 rectfill(4,y,123,127,0)
 rect(4,y,123,127,3)
 for i=1,#lines do ui.cyr_text(lines[i],8,y+4+(i-1)*7,7) end
 rectfill(11,108,116,122,1)
 rect(11,108,116,122,11)
 ui.cyr_centered(s.actions[s.phase],113,10)
end

function scenes.device_setup.draw()
 local s=scenes.device_setup
 if s.phase==1 then setup_art.contents()
 elseif s.phase==2 then
  setup_art.desk()
  setup_art.device(50,42,false,false,false)
 elseif s.phase<=5 then setup_art.drawer(false)
 elseif s.phase==6 then setup_art.drawer(true)
 elseif s.phase<=10 then setup_art.pc(s.phase)
 else setup_art.phone(s.phase>=11)
 end
 if s.phase==12 then
  rectfill(12,76,116,103,0)
  rect(12,76,116,103,11)
  print("<  "..s.callsigns[s.choice].."  >",43,87,10)
 end
 setup_caption(s)
 input.draw_cursor(s)
end
