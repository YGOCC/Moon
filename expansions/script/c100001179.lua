function c100001179.initial_effect(c)
aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetDescription(aux.Stringid(100001179,0))
	e2:SetCountLimit(1,100001179)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(c100001179.rmcon)
	e2:SetTarget(c100001179.rmtg)
	e2:SetOperation(c100001179.rmop)
	c:RegisterEffect(e2)
		local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100001179,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCategory(CATEGORY_HANDES)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetTarget(c100001179.sptg)
	e1:SetOperation(c100001179.spop)
	c:RegisterEffect(e1)
	end
	function c100001179.cfilter(c)
	return c:GetPreviousLocation()==LOCATION_HAND
end
function c100001179.rmcon(e,tp,eg,ep,ev,re,r,rp)
	if not re then return false end
	local rc=re:GetHandler()
	return rp==tp and bit.band(r,REASON_EFFECT)~=0 and rc:IsSetCard(0x765)
		and eg:IsExists(c100001179.cfilter,1,nil)
end
function c100001179.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
	end
function c100001179.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND):RandomSelect(tp,1)
	Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
end
function c100001179.filter(c)
	return c:IsSetCard(0x765)
end
function c100001179.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100001179.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
end
function c100001179.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.DiscardHand(tp,c100001179.filter,1,1,REASON_EFFECT)~=0 then
	end
end