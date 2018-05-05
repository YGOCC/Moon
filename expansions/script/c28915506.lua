--Burst Monster
--Design and code by Kindrindra
local ref=_G['c'..28915506]
function ref.initial_effect(c)
	local ge1=Effect.CreateEffect(c)
	ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge1:SetCode(EVENT_ADJUST)
	ge1:SetRange(0xff)
	ge1:SetCountLimit(1,555+EFFECT_COUNT_CODE_DUEL)
	ge1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	ge1:SetOperation(ref.chk)
	c:RegisterEffect(ge1,tp)

	
end
ref.burst=true
function ref.trapmaterial(c)
	return true
end
function ref.monmaterial(c)
	return true
end
function ref.chk(e,tp,eg,ep,ev,re,r,rp)
	local token=Duel.CreateToken(tp,555,nil,nil,nil,nil,nil,nil)		
	Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	Duel.Remove(token,POS_FACEUP,REASON_RULE)
end

