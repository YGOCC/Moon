--created & coded by Lyris, art by G.River of Pixiv
--「S・VINE」アストラル・ドラゴン
local cid,id=GetID()
cid.spt_other_space=id+75
function cid.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddOrigSpatialType(c,false,true)
	aux.AddSpatialProc(c,nil,8,600,nil,aux.TRUE,aux.TRUE)
end
