--Stardust Cat Draco
function c160002125.initial_effect(c)
	c:EnableReviveLimit()
	if not c160002125.global_check then
		c160002125.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c160002125.chk)
		Duel.RegisterEffect(ge2,0)
	end
end
c160002125.evolute=true
c160002125.material1=function(mc) return mc:IsAttribute(ATTRIBUTE_WATER) and (mc:GetLevel()==3 or mc:GetRank()==3) and mc:IsFaceup() end
c160002125.material2=function(mc) return mc:IsRace(RACE_WYRM) and (mc:GetLevel()==4 or mc:GetRank()==4) and mc:IsFaceup() end
function c160002125.chk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,388)
	Duel.CreateToken(1-tp,388)
		c160002125.stage_o=7
c160002125.stage=c160002125.stage_o

end