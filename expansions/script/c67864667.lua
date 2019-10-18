--VECTOR Frame: Solair
--Scripted by Zerry
function c67864667.initial_effect(c)
--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c67864667.ffilter,c67864667.ffilter2,false)
--Equip
local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67864664,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c67864667.condition)
	e1:SetTarget(c67864667.target)
	e1:SetOperation(c67864667.operation)
	c:RegisterEffect(e1)
--ATK Gain
local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e2:SetValue(c67864667.value)
	c:RegisterEffect(e2)
--Float
local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(678646451,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,67864667)
	e3:SetCondition(c67864667.spcon)
	e3:SetTarget(c67864667.sptg)
	e3:SetOperation(c67864667.spop)
	c:RegisterEffect(e3)
end
--filters
function c67864667.ffilter(c)
	return c:IsSetCard(0x2a6) and c:IsRace(RACE_WARRIOR)
end
function c67864667.ffilter2(c)
	return c:IsAttribute(ATTRIBUTE_FIRE+ATTRIBUTE_WIND)
end
function c67864667.eqfilter(c,e,tp,ec)
	return c:IsType(TYPE_UNION) and c:IsSetCard(0x52a6)
end
function c67864667.vfilter(c)
	return c:IsSetCard(0x2a6) and c:IsFaceup()
end
function c67864667.spfilter(c,e,tp)
	return (c:IsSetCard(0x2a6) or c:IsRace(RACE_WARRIOR)) and not c:IsCode(67864667) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
--Equip
function c67864667.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c67864667.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c67864667.eqfilter(chkc,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>(e:GetHandler():IsLocation(LOCATION_SZONE) and 0 or 1)
		and Duel.IsExistingTarget(c67864667.eqfilter,tp,LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c67864667.eqfilter,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c67864667.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
	if aux.CheckUnionEquip(tc,e:GetHandler()) and Duel.Equip(tp,tc,e:GetHandler()) then
   	 	aux.SetUnionState(tc)
		end
	end
end
--Atk Gain
function c67864667.value(e,c)
	return Duel.GetMatchingGroupCount(c67864667.vfilter,c:GetControler(),LOCATION_SZONE,0,nil)*500
end
--Float
function c67864667.spcon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c67864667.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c67864667.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c67864645.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c67864667.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c67864667.spop(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end