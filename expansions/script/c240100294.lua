--created & coded by Lyris
--S・VINEの第二女王クライッシャ
function c240100294.initial_effect(c)
	c:EnableCounterPermit(0x1)
	aux.AddOrigEvoluteType(c)
	aux.AddEvoluteProc(c,nil,8,aux.TRUE,aux.TRUE)
	local ae3=Effect.CreateEffect(c)
	ae3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	ae3:SetCode(EVENT_REMOVE)
	ae3:SetRange(LOCATION_MZONE)
	ae3:SetOperation(c240100294.acop)
	c:RegisterEffect(ae3)
	local ae0=Effect.CreateEffect(c)
	ae0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	ae0:SetCode(EVENT_CUSTOM+240100294)
	ae0:SetOperation(c240100294.eop)
	c:RegisterEffect(ae0)
	local ae1=Effect.CreateEffect(c)
	ae1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	ae1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	ae1:SetCode(EFFECT_DESTROY_REPLACE)
	ae1:SetRange(LOCATION_MZONE)
	ae1:SetTarget(c240100294.reptg)
	ae1:SetOperation(c240100294.repop)
	c:RegisterEffect(ae1)
	local ae2=Effect.CreateEffect(c)
	ae2:SetType(EFFECT_TYPE_QUICK_O)
	ae2:SetRange(LOCATION_MZONE)
	ae2:SetCode(EVENT_FREE_CHAIN)
	ae2:SetCountLimit(1)
	ae2:SetCost(c240100294.cost)
	ae2:SetOperation(c240100294.op)
	c:RegisterEffect(ae2)
end
function c240100294.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x285b)
end
function c240100294.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if eg:IsExists(c240100294.cfilter,1,c) then
		c:AddCounter(0x1,1)
		if c:GetCounter(0x1)==3 then
			Duel.RaiseSingleEvent(c,EVENT_CUSTOM+240100294,e,0,0,tp,0)
		end
	end
end
function c240100294.eop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RemoveCounter(tp,0x1,3,REASON_EFFECT)
	if c:GetCounter(0x1088)<8 then c:AddCounter(0x1088,1) end
end
function c240100294.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetCounter(0x1088)>0 end
	return Duel.SelectYesNo(tp,aux.Stringid(240100294,0))
end
function c240100294.repop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveCounter(tp,0x1088,1,REASON_EFFECT)
end
function c240100294.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x1088,2,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x1088,2,REASON_COST)
end
function c240100294.filter(c,e,tp)
	return c:IsSetCard(0x285b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c240100294.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,nil)>0
		and Duel.IsExistingMatchingCard(c240100294.filter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_EXTRA)
end
function c240100294.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,nil):RandomSelect(tp,1)
	if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and tc:GetFirst():IsLevelAbove(1) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c240100294.filter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil,e,tp)
		if g:GetCount()>0 then Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) end
	end
end
