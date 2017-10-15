--Lyn, Chosen Of The Mystral
function c202004.initial_effect(c)
	c:SetSPSummonOnce(202004)
	 --synchro summon
	aux.AddSynchroProcedure2(c,nil,aux.NonTuner(c202004.sfilter))
	c:EnableReviveLimit()
	 --tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(202004,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1)
	e1:SetCondition(c202004.shucon)
	e1:SetTarget(c202004.shutg)
	e1:SetOperation(c202004.shuop)
	c:RegisterEffect(e1)

 local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c202004.negcon)
	e2:SetTarget(c202004.negtg)
	e2:SetOperation(c202004.negop)
	c:RegisterEffect(e2)

--death
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(202004,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetTarget(c202004.sptg)
	e3:SetOperation(c202004.spop)
	c:RegisterEffect(e3)
end
function c202004.btfilter(c,e,tp)
	return c:IsSetCard(0x202) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c202004.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c202004.btfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c202004.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c202004.btfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c202004.negcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler()~=e:GetHandler() and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c202004.negfilter(c)
	return c:IsSetCard(0x202) and c:IsAbleToDeck()
end
function c202004.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c202004.negfilter,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c202004.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c202004.negfilter,tp,LOCATION_GRAVE,0,2,2,nil)
	if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 then
		if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
			Duel.Destroy(eg,REASON_EFFECT)
		end
	end
end

function c202004.syfilter(c)
	return c:IsSetCard(0x202) and c:IsType(TYPE_SYNCHRO)
end
function c202004.shucon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c202004.shufilter(c,e,tp,eg,ep,ev,re,r,rp)
	return (c:IsFacedown() and c:IsLocation(LOCATION_SZONE) and c:IsAbleToDeck()) or (c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsAbleToDeck())
end
function c202004.shutg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c202004.shufilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) end
	local sg=Duel.GetMatchingGroup(c202004.shufilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,sg:GetCount(),0,0)
end
function c202004.shuop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	  local sg=Duel.GetMatchingGroup(c202004.shufilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	Duel.SendtoDeck(sg,nil,1,REASON_EFFECT)
end