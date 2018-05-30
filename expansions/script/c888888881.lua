--Thunderground Lightning Wolf
local card = c888888881
function card.initial_effect(c)
	--SS Self
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,888888881)
	e1:SetCondition(card.hspcon)
	e1:SetOperation(card.hspop)
	c:RegisterEffect(e1)
	--shuffle self, send other to grave
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,888888882)
	e2:SetCost(card.spcost)
	e2:SetTarget(card.sptg)
	e2:SetOperation(card.spop)
	c:RegisterEffect(e2)
end
function card.spfilter(c)
	return c:IsSetCard(0x888) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function card.hspcon(e,c,tp)
	if c==nil then return true end
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(card.spfilter,tp,LOCATION_DECK,0,1,nil) 
end
function card.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,card.spfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function card.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckAsCost() end
	Duel.SendtoDeck(c,nil,2,REASON_COST)
end
function card.spfilter2(c,e,tp)
	return  c:IsSetCard(0x888) and c:IsType(TYPE_MONSTER) and not c:IsCode(888888881)
end
function card.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return 
	Duel.IsExistingMatchingCard(card.spfilter2,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function card.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SENDTOGRAVE)
	local g=Duel.SelectMatchingCard(tp,card.spfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,nil,REASON_EFFECT)
	end
end
