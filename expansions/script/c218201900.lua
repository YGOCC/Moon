--created by Hawknad777, coded by Lyris
local cid,id=GetID()
function cid.initial_effect(c)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(cid.spcon)
	e2:SetOperation(cid.spop)
	c:RegisterEffect(e2)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(function(e,tp) return Duel.GetTurnPlayer()==tp end)
	e1:SetCost(cid.cost)
	e1:SetTarget(cid.target)
	e1:SetOperation(cid.operation)
	c:RegisterEffect(e1)
end
function cid.spfilter(c,ft,tp)
	return c:IsCode(CARD_NEBULA_TOKEN) and (ft>0 or (c:IsControler(tp) and c:GetSequence()<5)) and (c:IsControler(tp) or c:IsFaceup())
end
function cid.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1 and Duel.CheckReleaseGroup(tp,cid.spfilter,1,nil,ft,tp)
end
function cid.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.SelectReleaseGroup(tp,cid.spfilter,1,1,nil,ft,tp)
	Duel.Release(g,REASON_COST)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+0xff0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
	c:RegisterEffect(e1)
end
function cid.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReleasable() and Duel.CheckReleaseGroup(tp,Card.IsCode,1,c,id) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsCode,1,1,c,id)
	Duel.Release(g,REASON_COST)
end
function cid.filter(c,e,tp)
	return c:IsSetCard(0x88f) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(cid.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cid.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cid.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0x100,tp,tp,false,false,POS_FACEUP)
	end
end
