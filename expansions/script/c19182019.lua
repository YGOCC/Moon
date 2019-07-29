--created by Alastar Rainford, coded by Lyris
local cid,id=GetID()
function cid.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cid.plcost)
	e1:SetTarget(cid.pltg)
	e1:SetOperation(cid.plop)
	c:RegisterEffect(e1)
end
function cid.cfilter(c)
	return c:GetSequence()<5 and c:IsAbleToGraveAsCost()
end
function cid.plcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cid.cfilter,tp,LOCATION_SZONE,0,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(cid.cfilter,tp,LOCATION_SZONE,0,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
end
function cid.plfilter(c,tp)
	return c:IsSetCard(0xa88) and not c:IsForbidden() and c:CheckUniqueOnField(tp) and Duel.IsExistingMatchingCard(cid.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,c)
end
function cid.filter2(c,eqc)
	return c:IsFaceup() and eqc:CheckEquipTarget(c)
end
function cid.pltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cid.plfilter,tp,LOCATION_GRAVE,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,LOCATION_GRAVE)
end
function cid.plop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft<=0 then return end
	for i=1,ft do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,cid.plfilter,tp,LOCATION_GRAVE,0,1,1,nil,tp)
		local tc=g:GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local ec=Duel.SelectMatchingCard(tp,cid.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tc)
		Duel.Equip(tp,tc,ec:GetFirst())
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCondition(cid.descon)
	e1:SetOperation(cid.desop)
	Duel.RegisterEffect(e1,tp)
end
function cid.desfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa88) and c:GetSequence()<5
end
function cid.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cid.desfilter,tp,LOCATION_SZONE,0,1,nil)
end
function cid.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cid.desfilter,tp,LOCATION_SZONE,0,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
