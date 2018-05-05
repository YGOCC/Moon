--Morninglight Lark
--Design and code by Kindrindra
local ref=_G['c'..28915511]
function ref.initial_effect(c)
	local ge1=Effect.CreateEffect(c)
	ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge1:SetCode(EVENT_ADJUST)
	ge1:SetRange(0xff)
	ge1:SetCountLimit(1,555+EFFECT_COUNT_CODE_DUEL)
	ge1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	ge1:SetOperation(ref.chk)
	c:RegisterEffect(ge1,tp)

	--To Grave
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,28915511)
	e1:SetTarget(ref.tgtg)
	e1:SetOperation(ref.tgop)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(ref.tgcon)
	c:RegisterEffect(e3)
	--Attack Lock
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetTarget(ref.atktarget)
	c:RegisterEffect(e2)
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

--To Grave
function ref.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+0x555
end
function ref.tgfilter(c)
	return c:IsAbleToGrave()
end
function ref.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(ref.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function ref.displayfilter(c)
	return c:IsCode(555)
end
function ref.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,ref.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
		unlock_level = unlock_level+1
		local displaycard=Duel.GetMatchingGroup(ref.displayfilter,tp,LOCATION_REMOVED,0,nil):GetFirst()
		if displaycard then
			displaycard:SetTurnCounter(unlock_level)
		end
	end
end

--Attack Lock
function ref.atktarget(e,c)
	return not c:IsLevelAbove(unlock_level+1)
end
