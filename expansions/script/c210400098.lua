--created & coded by Lyris, art by G.River of Pixiv
--「S・VINE」アストラル・ドラゴン(アナザー宙)
local cid,id=GetID()
function cid.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddOrigSpatialType(c)
	aux.AddSpatialProc(c,nil,8,600,nil,aux.TRUE,aux.TRUE)
end
