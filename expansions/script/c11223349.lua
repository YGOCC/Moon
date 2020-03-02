--Red-Eyes Metal Proto Dragon
local s,id=GetID()
function s.initial_effect(c)
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_DARK),2,2,s.lcheck)
    --spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1,id)
    e1:SetCondition(s.condition)
    e1:SetTarget(s.target)
    e1:SetOperation(s.operation)
    c:RegisterEffect(e1)
    --equip
    local e2=Effect.CreateEffect(c)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCategory(CATEGORY_EQUIP)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetCountLimit(1)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTarget(s.eqtg)
    e2:SetOperation(s.eqop)
    c:RegisterEffect(e2)
end
    --SumReqs
function s.lcheck(g,lc)
            return g:IsExists(Card.IsLinkSetCard,1,nil,0x3b)
end
--SSummon
function s.condition(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function s.filter(c,e,tp)
    return c:IsRace(RACE_DRAGON) and c:IsLevel(1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)> 0
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
	end
function s.eqfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK)and not c:IsForbidden()
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(s.eqfilter,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingTarget(aux.FilterFaceupFunction(Card.IsSetCard,0x3b),tp,LOCATION_MZONE,0,1,nil) end	
Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)	
Duel.SelectTarget(tp,aux.FilterFaceupFunction(Card.IsSetCard,0x3b),tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,s.eqfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end

--equip--
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g~=2 then return end
	local tc=g:GetFirst()
	local ec=g:GetNext()
	if tc:IsLocation(LOCATION_GRAVE) then tc,ec=ec,tc end
	if tc:IsFaceup() then
		Duel.Equip(tp,ec,tc,true)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetLabelObject(tc)
		e1:SetValue(s.eqlimit)
		ec:RegisterEffect(e1)
		--atkup
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(1200)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		ec:RegisterEffect(e2)
		--defup
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_EQUIP)
		e3:SetCode(EFFECT_UPDATE_DEFENSE)
		e3:SetValue(1000)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		ec:RegisterEffect(e3)
	end
	
end
function s.eqlimit(e,c)
	return c==e:GetLabelObject()
end