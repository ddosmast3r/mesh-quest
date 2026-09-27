-- Tiny save shared by every cartridge in the chapter.

save={}

function save.init()
 cartdata("mesh_quest")
end

function save.progress(value)
 if value then dset(0,max(dget(0),value)) end
 return dget(0)
end

function save.callsign(value)
 if value then dset(2,value) end
 local result=flr(dget(2))
 return result>0 and result or 1
end

function save.greeting(value)
 if value then dset(3,value) end
 return flr(dget(3))
end
