--created & coded by Lyris, art by G.River of Pixiv
--「S・VINE」アストラル・ドラゴン
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cod=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cod
end
local id,cid=getID()
cid.spt_other_space=210400098
function cid.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddOrigSpatialType(c,false,true)
	aux.AddSpatialProc(c,nil,8,600,nil,aux.TRUE,aux.TRUE)
end
