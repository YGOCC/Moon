--Chronowitch of Death
function c92720005.initial_effect(c)
	c:EnableCounterPermit(0x2)
	--link summon
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),2,2)
	--place counter
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(92720001,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1)
	e1:SetCondition(c92720005.addcon)
	e1:SetOperation(c92720005.addc)
	c:RegisterEffect(e1)
	--move counter
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(92720001,1))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(c92720005.addcost2)
	e2:SetTarget(c92720005.addct2)
	e2:SetOperation(c92720005.addc2)
	c:RegisterEffect(e2)
	--attackup
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EFFECT_UPDATE_ATTACK)
    e3:SetValue(c92720005.attackup)
    c:RegisterEffect(e3)
end
function c92720005.attackup(e,c)
    return c:GetCounter(0x2)*100
end
function c92720005.addcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c92720005.addc(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		c:AddCounter(0x2,1)
	end
end
function c92720005.addcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x2,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x2,1,REASON_COST)
end
function c92720005.filter(c)
	return c:IsSetCard(0xf92) and c:IsType(TYPE_MONSTER)
end
function c92720005.addct2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c92720005.filter(chkc,e,tp) end 
	if chk==0 then return Duel.IsExistingTarget(c92720005.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c92720005.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,g,1,0x2,1)
end
function c92720005.addc2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		tc:AddCounter(0x2,1)
	end
end