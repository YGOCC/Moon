--Paintress Nadia
local cid,id=GetID()
function cid.initial_effect(c)
	local ref=_G['c'..id]
 
	--hand 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_EXTRA_EVOLUTE_MATERIAL)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cid.matcon)
	--e1:SetValue(cid.matval)
	e1:SetOperation(ref.matop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCondition(cid.ctcon)
	e2:SetOperation(cid.ctop)
	c:RegisterEffect(e2)
end
function cid.matcon(c,ec,mode)
	if mode==1 then return Duel.GetFlagEffect(c:GetControler(),id)==0 and c:IsLocation(LOCATION_HAND) end
	return true
end
function cid.mfilter(c)
	return c:IsLocation(LOCATION_MZONE) and not c:IsType(TYPE_EFFECT)
end
function cid.matval(e,c,mg)
	return c:IsSetCard(0xc50) and mg:IsExists(cid.mfilter,1,nil)
end
function ref.matop(c)
	Duel.SendtoGrave(c,REASON_MATERIAL+0x10000000)
end
function cid.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND)
end
function cid.ctop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
end
