--Nissa Revane
function c100782015.initial_effect(c)
	c:SetStatus(STATUS_UNSUMMONABLE_CARD,true)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c100782015.activate)
	c:RegisterEffect(e1)
	--cannot special summon
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e2)
	--cannot target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_PZONE)
	e3:SetValue(c100782015.indval)
	c:RegisterEffect(e3)
	--Special Summon Nissa's Chosen
	local e5=Effect.CreateEffect(c)
	e5:SetCountLimit(1,100782015)
	e5:SetDescription(aux.Stringid(100782015,0))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_PZONE)
	e5:SetTarget(c100782015.sptg)
	e5:SetOperation(c100782015.spop)
	c:RegisterEffect(e5)
	--Gain Life Points
	local e6=Effect.CreateEffect(c)
	e6:SetCountLimit(1,100782015)
	e6:SetDescription(aux.Stringid(100782015,1))
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetCategory(CATEGORY_RECOVER)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_PZONE)
	e6:SetCondition(c100782015.con)
	e6:SetTarget(c100782015.target)
	e6:SetOperation(c100782015.operation)
	c:RegisterEffect(e6)
	--Special Summon Elves
	local e7=Effect.CreateEffect(c)
	e7:SetCountLimit(1,100782015)
	e7:SetDescription(aux.Stringid(100782015,2))
	e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_PZONE)
	e7:SetCost(c100782015.scost)
	e7:SetTarget(c100782015.starget)
	e7:SetOperation(c100782015.soperation)
	c:RegisterEffect(e7)
end
function c100782015.scost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x189B8,7,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x189B8,7,REASON_COST)
end
function c100782015.xfilter(c,e,tp)
	return c:IsSetCard(0x189AE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100782015.starget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c100782015.xfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c100782015.soperation(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c100782015.xfilter,tp,LOCATION_DECK,0,ft,ft,nil,e,tp)
	local tc=g:GetFirst()
	while tc do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		c:SetCardTarget(tc)
		tc=g:GetNext()
	end
	Duel.SpecialSummonComplete()
end
function c100782015.lpfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x189AE)
end
function c100782015.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c100782015.lpfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c100782015.filter(c)
	return c:IsSetCard(0x189AE) and c:IsType(TYPE_MONSTER)
end
function c100782015.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local val=Duel.GetMatchingGroupCount(c100782015.filter,tp,LOCATION_MZONE,0,nil)*1000
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(val)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,val)
end
function c100782015.operation(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x189B8,1)
	local val=Duel.GetMatchingGroupCount(c100782015.filter,tp,LOCATION_MZONE,0,nil)*1000
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Recover(p,val,REASON_EFFECT)
end
function c100782015.indval(e,re,tp)
	return tp~=e:GetHandlerPlayer()
end
function c100782015.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c and c:IsFaceup() and c:IsRelateToEffect(e) then
		c:AddCounter(0x189B8,2)
	end
end
function c100782015.spfilter(c,e,tp)
	return c:IsCode(100782016) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100782015.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c100782015.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
	e:GetHandler():AddCounter(0x189B8,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c100782015.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c100782015.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
