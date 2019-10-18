--VECTOR Legion Arcane Defender
--Scripted by Zerry
function c67864662.initial_effect(c)
--equip
local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67864662,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c67864662.eqtg)
	e1:SetOperation(c67864662.eqop)
	c:RegisterEffect(e1)
--unequip
local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67864661,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c67864662.sptg)
	e2:SetOperation(c67864662.spop)
	c:RegisterEffect(e2)
--protecc
local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(1)
	c:RegisterEffect(e3)
--eqlimit
local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_EQUIP_LIMIT)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetValue(c67864662.eqlimit)
	c:RegisterEffect(e4)
--mill
local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(67864662,0))
	e5:SetCategory(CATEGORY_TOGRAVE)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCountLimit(1,67864662)
	e5:SetTarget(c67864662.tgtg)
	e5:SetOperation(c67864662.tgop)
	c:RegisterEffect(e5)
local e6=e5:Clone(c)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e6)
end
--Union
function c67864662.filter(c)
	local ct1,ct2=c:GetUnionCount()
	return c:IsFaceup() and c:IsSetCard(0x2a6) and ct2==0
end
function c67864662.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c67864662.filter(chkc) end
	if chk==0 then return e:GetHandler():GetFlagEffect(67864662)==0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c67864661.filter,tp,LOCATION_MZONE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c67864662.filter,tp,LOCATION_MZONE,0,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
	c:RegisterFlagEffect(67864662,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c67864662.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	if not tc:IsRelateToEffect(e) or not c67864662.filter(tc) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	if not Duel.Equip(tp,c,tc,false) then return end
	aux.SetUnionState(c)
end
function c67864662.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(67864662)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	c:RegisterFlagEffect(67864662,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c67864662.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
end
--eqlimit
function c67864662.eqlimit(e,c)
	return c:IsSetCard(0x2a6) or e:GetHandler():GetEquipTarget()==c
end
function c67864662.tgfilter(c)
	return c:IsSetCard(0x2a6) and c:IsAbleToGrave()
end
function c67864662.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67864662.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c67864662.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c67864662.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end