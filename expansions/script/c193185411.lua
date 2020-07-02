--created by Swag, coded by Lyris
local cid,id=GetID()
function cid.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddOrigTimeleapType(c)
	aux.AddTimeleapProc(c,5,function(e,tc) return Duel.IsExistingMatchingCard(cid.mfilter,tc:GetControler(),LOCATION_GRAVE,0,1,nil) end,aux.FilterBoolFunction(Card.IsSetCard,0xd78),cid.sumop)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetCondition(function(e) return e:GetHandler():IsSummonType(SUMMON_TYPE_TIMELEAP) end)
	e1:SetOperation(cid.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+100)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetCondition(function(e,tp) local ph=Duel.GetCurrentPhase() return Duel.GetTurnPlayer()~=tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) end)
	e2:SetCost(cid.cost)
	e2:SetTarget(cid.target)
	e2:SetOperation(cid.desop)
	c:RegisterEffect(e2)
end
function cid.mfilter(c)
	return c:IsLevelAbove(7) and c:IsSetCard(0xd78) and c:IsType(TYPE_MONSTER)
end
function cid.sumop(e,tp,eg,ep,ev,re,r,rp,c,g)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_TIMELEAP)
	aux.TimeleapHOPT(tp)
end
function cid.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<2 then return end
	Duel.ConfirmDecktop(tp,2)
	local g=Duel.GetDecktopGroup(tp,2)
	Duel.DisableShuffleCheck()
	if g:FilterCount(Card.IsAbleToHand,nil)>0 and Duel.SelectYesNo(1-tp,1190) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local add=g:Select(1-tp,1,1,nil)
		Duel.SendtoHand(add,nil,REASON_EFFECT)
		Duel.ShuffleHand(tp)
		g:Sub(add)
		Duel.BreakEffect()
	end
	Duel.SendtoGrave(g,REASON_EFFECT)
end
function cid.cfilter(c)
	return c:IsLevelAbove(5) and c:IsRace(RACE_ZOMBIE) and c:IsAbleToRemoveAsCost()
end
function cid.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cid.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	Duel.Remove(Duel.SelectMatchingCard(tp,cid.cfilter,tp,LOCATION_GRAVE,0,1,1,nil),POS_FACEUP,REASON_COST)
end
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,1,nil),1,0,0)
end
function cid.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then Duel.Destroy(tc,REASON_EFFECT) end
end
