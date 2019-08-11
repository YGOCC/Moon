--created by Alastar Rainford, coded by Lyris
local cid,id=GetID()
function cid.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep2(c,aux.FilterBoolFunction(Card.IsRace,RACE_PSYCHO),2,63,true)
	aux.AddContactFusionProcedure(c,cid.cfilter,LOCATION_MZONE,0,cid.sprop)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(cid.splimit)
	c:RegisterEffect(e1)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_UPDATE_ATTACK)
	e0:SetRange(LOCATION_MZONE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetValue(function(e,c) return c:GetEquipCount()*500 end)
	c:RegisterEffect(e0)
	local e1=e0:Clone()
	e1:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetTarget(cid.target)
	e2:SetOperation(cid.operation)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id-7+EFFECT_COUNT_CODE_OATH)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetTarget(cid.tdtg)
	e3:SetOperation(cid.activate)
	c:RegisterEffect(e3)
end
function cid.cfilter(c,fc)
	return c:IsAbleToGraveAsCost() and c:GetEquipGroup():IsExists(Card.IsType,1,nil,TYPE_SPELL)
end
function cid.sprop(g)
	Duel.SendtoGrave(g,REASON_COST)
end
function cid.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function cid.filter(c,tp)
	return (c:IsSetCard(0xa88) and c:IsType(TYPE_MONSTER) or c:IsType(TYPE_EQUIP)) and not c:IsForbidden() and c:CheckUniqueOnField(tp) and Duel.IsExistingMatchingCard(cid.filter2,tp,LOCATION_MZONE,0,1,nil,c)
end
function cid.filter2(c,eqc)
	return c:IsFaceup() and eqc:CheckEquipTarget(c)
end
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cid.filter(chkc,tp) end
	if chk==0 then return true end
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft>3 then ft=3 end
	local g=Group.CreateGroup()
	for i=1,ft do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		g=g+Duel.SelectMatchingCard(tp,cid.filter,tp,LOCATION_GRAVE,0,1,1,nil,tp)
		if i<ft and not Duel.SelectYesNo(tp,aux.Stringid(id,0)) then break end
	end
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,#g,0,0)
end
function cid.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<#g then return end
	for tc in aux.Next(g) do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local ec=Duel.SelectMatchingCard(tp,cid.filter2,tp,LOCATION_MZONE,0,1,1,nil,tc)
		Duel.Equip(tp,tc,ec:GetFirst())
	end
end
function cid.tdfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xa88) and c:IsAbleToDeck()
end
function cid.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_GRAVE and chkc:GetControler()==tp and cid.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cid.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=Duel.SelectTarget(tp,cid.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,1,0,0)
end
function cid.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)
	end
end
