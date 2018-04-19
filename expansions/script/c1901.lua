--Deepwood Carbuncle
local voc=c1901
function c1901.initial_effect(c)
	--self destroy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SELF_DESTROY)
	e1:SetCondition(voc.sdcon)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1901,0))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,1901)
	e2:SetCost(voc.cost)
	e2:SetTarget(voc.target)
	e2:SetOperation(voc.operation)
	c:RegisterEffect(e2)
	--cannot tribute
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UNRELEASABLE_SUM)
	e3:SetValue(voc.recon)
	c:RegisterEffect(e3)
end
function voc.sdfilter(c)
	return not c:IsSetCard(0x5AA)
end
function voc.sdcon(e)
	return Duel.IsExistingMatchingCard(voc.sdfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil) and Duel.GetCurrentPhase()==PHASE_END and Duel.GetTurnPlayer()~=e:GetHandlerPlayer()
end
function voc.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function voc.recon(e,c)
	return not c:IsSetCard(0x5AA)
end
function voc.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function voc.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsStatus(STATUS_BATTLE_DESTROYED) then return end
	Duel.SendtoDeck(c,1-tp,2,REASON_EFFECT)
	if not c:IsLocation(LOCATION_DECK) then return end
	Duel.ShuffleDeck(1-tp)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1901,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetCondition(voc.spcon)
	e1:SetTarget(voc.sptg)
	e1:SetOperation(voc.spop)
	e1:SetReset(RESET_EVENT+0x1de0000)
	c:RegisterEffect(e1)
end
function voc.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DRAW)
end
function voc.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function voc.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)>0 then
			
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,0)
		e1:SetCondition(voc.splimcon)
	e1:SetTarget(voc.splimit)
	e1:SetReset(RESET_EVENT+0x1fe0000)
			
			c:RegisterEffect(e1)
		end
	end
end
function voc.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function voc.splimit(e,c)
	return not c:IsSetCard(0x5AA)
end
