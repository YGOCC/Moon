--created & coded by Lyris, art by G.River of Pixiv
--「S・VINE」アストラル・ドラゴン
c210400033.spt_other_space=210400098
function c210400033.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddOrigSpatialType(c,false,true)
	aux.AddSpatialProc(c,nil,8,600,nil,aux.TRUE,aux.TRUE)
end
