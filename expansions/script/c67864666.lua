--VECTOR Frame: Kanzaki
--Scripted by Zerry
function c67864666.initial_effect(c)
--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c67864666.ffilter,c67864666.ffilter2,false)
--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.fuslimit)
	c:RegisterEffect(e0)
--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c67864666.val)
	c:RegisterEffect(e1)
--Equip
local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67864666,0))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c67864666.eqcon)
	e2:SetTarget(c67864666.eqtg)
	e2:SetOperation(c67864666.eqop)
	c:RegisterEffect(e2)
end
--Filters
function c67864666.ffilter(c)
	return c:IsSetCard(0x2a6) and c:IsRace(RACE_WARRIOR)
end
function c67864666.ffilter2(c)
	return c:IsAttribute(ATTRIBUTE_WATER+ATTRIBUTE_EARTH)
end
--Equip
function c67864666.eqfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and c:IsControler(1-tp) and c:IsAbleToChangeControler()
end
function c67864666.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()~=tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function c67864666.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c67864666.eqfilter(chkc,tp) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c67864666.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler(),tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c67864666.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler(),tp)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c67864666.eqop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if not (tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsType(TYPE_EFFECT)) then return end
    if c:IsFaceup() and c:IsRelateToEffect(e) then
        if Duel.Equip(tp,tc,c,false) then
            --Add Equip limit
            tc:RegisterFlagEffect(67864651,RESET_EVENT+0x1fe0000,0,0)
            e:SetLabelObject(tc)
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
            e1:SetCode(EFFECT_EQUIP_LIMIT)
            e1:SetReset(RESET_EVENT+0x1fe0000)
            e1:SetValue(c67864666.eqlimit)
            tc:RegisterEffect(e1)
        end
    else
        Duel.SendtoGrave(tc,REASON_EFFECT)
    end
end
function c67864666.eqlimit(e,c)
	return e:GetOwner()==c
end
--atk gain
function c67864666.val(e,c)
	return c:GetEquipCount()*800
end
