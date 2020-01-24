if not banned_list_table then banned_list_table={} end
-- local string,io=require('string'),require('io')
local f=debug.getinfo(1,'S')['source']
local e1=Effect.GlobalEffect()
e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
e1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
e1:SetOperation(function() Debug.ShowHint(f) end)
Duel.RegisterEffect(e1,0)
-- local l=io.open(f:sub(f:find("expansions"),-22).."lflist.conf","r")
-- if not l then return end
-- local ls=l:read("*a")
-- for id in ls:sub(ls:find("!"),ls:find("!",ls:find("!")+1) and ls:find("!",ls:find("!")+1)-1 or -1):gmatch("([0-9]+) 0") do
	-- banned_list_table[tonumber(id)]=true
-- end
-- l:close()
