--VECTOR Legion: Core Commando
--Scripted by Zerry
function c67864664.initial_effect(c)
	--fusion material
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x2a6),aux.NonTuner(c67864664.sfilter),1)
	c:EnableReviveLimit()
--Equip
local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67864664,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c67864664.condition)
	e1:SetTarget(c67864664.target)
	e1:SetOperation(c67864664.operation)
	c:RegisterEffect(e1)
--Destroy
local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(67864664,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,67864664)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCost(c67864664.descost)
	e3:SetTarget(c67864664.destg)
	e3:SetOperation(c67864664.desop)
	c:RegisterEffect(e3)
end
function c67864664.sfilter(c)
	return c:IsRace(RACE_WARRIOR+RACE_MACHINE)
end
function c67864664.eqfilter(c,e,tp,ec)
	return c:IsType(TYPE_UNION)
end
function c67864664.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c67864664.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c67864664.eqfilter(chkc,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>(e:GetHandler():IsLocation(LOCATION_SZONE) and 0 or 1)
		and Duel.IsExistingTarget(c67864664.eqfilter,tp,LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c67864664.eqfilter,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c67864664.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
	if aux.CheckUnionEquip(tc,e:GetHandler()) and Duel.Equip(tp,tc,e:GetHandler()) then
   	 	aux.SetUnionState(tc)
		end
	end
end
function c67864664.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetEquipGroup():IsExists(Card.IsAbleToGraveAsCost,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=e:GetHandler():GetEquipGroup():FilterSelect(tp,Card.IsAbleToGraveAsCost,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c67864664.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c67864664.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
