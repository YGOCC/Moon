--created by ZEN, coded by TaxingCorn117
--Blood Arts - Erin
local function getID()
    local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
    str=string.sub(str,1,string.len(str)-4)
    local cod=_G[str]
    local id=tonumber(string.sub(str,2))
    return id,cod
end
local id,cid=getID()
function cid.initial_effect(c)
    c:SetSPSummonOnce(id)
    --link summon
    aux.AddLinkProcedure(c,cid.mfilter,1,1)
    c:EnableReviveLimit()
end
function cid.mfilter(c)
    return c:IsLinkSetCard(0x52f)
end