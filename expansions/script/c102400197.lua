--created & coded by Lyris, art from "Dramatic Crossroads"
--フェイツ・ディシジョン
local cid,id=GetID()
function cid.initial_effect(c)
	aux.AddRitualProcGreater2(c,aux.FilterBoolFunction(Card.IsSetCard,0xf7a),LOCATION_GRAVE)
end
