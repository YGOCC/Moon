--Mega Phoenix
function c20386025.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(20386025,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c20386025.tg)
	e1:SetOperation(c20386025.op)
	c:RegisterEffect(e1)
	--banish zombies
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(20386025,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(c20386025.target)
	e2:SetOperation(c20386025.activate)
	c:RegisterEffect(e2)
end
function c20386025.filter(c,e,tp)
	return c:IsSetCard(0x31C55) or c:IsSetCard(0x4FA2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and not Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,c:GetCode())
end
function c20386025.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(c20386025.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c20386025.op(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local g=Duel.GetMatchingGroup(c20386025.filter,tp,LOCATION_GRAVE,0,nil,e,tp)
	while g:GetCount()>0 and ft>0 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SpecialSummonStep(sg:GetFirst(), 0, tp, tp, false, false, POS_FACEUP)
		ft=ft-1
		g:Remove(Card.IsCode,nil,sg:GetFirst():GetCode())
	end
	Duel.SpecialSummonComplete()
end
function c20386025.rfilter(c)
	return c:IsRace(RACE_ZOMBIE)
end
function c20386025.tfilter(c)
	return not c:IsAbleToRemove()
end
function c20386025.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c20386025.rfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,nil)
		return g:GetCount()>0 and not g:IsExists(c20386025.tfilter,1,nil)
	end
	local g=Duel.GetMatchingGroup(c20386025.rfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c20386025.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c20386025.rfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end