--Number 302: Creation Pheonix Photonic Dragon
function c88880052.initial_effect(c)
    --Xyz Summon
    c:EnableReviveLimit()
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_FIELD)
    e0:SetCode(EFFECT_SPSUMMON_PROC)
    e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e0:SetRange(LOCATION_EXTRA)
    e0:SetCondition(c88880052.spcon)
    e0:SetValue(SUMMON_TYPE_XYZ)
    c:RegisterEffect(e0)
    --Special Summon from GY
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(88880052,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e1:SetRange(LOCATION_GRAVE)
    e1:SetCode(EVENT_DESTROYED)
    e1:SetTarget(c88880052.target)
    e1:SetOperation(c88880052.operation)
    c:RegisterEffect(e1)
    --Attack Again
    local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_ATTACK_DISABLED)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCondition(c88880052.atcon)
    e2:SetCost(c88880052.atcost)
    e2:SetOperation(c88880052.atop)
    c:RegisterEffect(e2)
    --Is targeted by cards effects
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e2:SetCondition(c88880052.tgcon)
    e2:SetValue(aux.tgoval)
    c:RegisterEffect(e2)
    --Attach cards
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e4:SetCode(EVENT_SPSUMMON_SUCCESS)
    e4:SetCondition(c88880052.athcon)
    e4:SetTarget(c88880052.athtg)
    e4:SetOperation(c88880052.athop)
    c:RegisterEffect(e4)
end
c88880052.xyz_number=302
--XyzSummon
function c88880052.spcon(e,c)
    return Duel.IsExistingMatchingCard(Card.IsCode,e:GetHandlerPlayer(),LOCATION_GRAVE,0,1,nil,88880056)
end
--Special Summon from GY
function c88880052.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local c=e:GetHandler()
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
    c:ResetFlagEffect(88880052)
end
function c88880052.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,1,tp,tp,false,false,POS_FACEUP)>0 then
        local atk=Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE):GetMaxGroup(Card.GetAttack):GetFirst():GetAttack()
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
        e1:SetRange(LOCATION_MZONE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(atk)
        e1:SetReset(RESET_EVENT+0x1ff0000)
        c:RegisterEffect(e1)
    end
end
--Attack Again
function c88880052.atcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler())
end
function c88880052.atcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c88880052.atop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToBattle() then return end
    Duel.ChainAttack()
    local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_EXTRA_ATTACK)
        e1:SetValue(1)
        e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        c:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_SET_ATTACK_FINAL)
        e2:SetCondition(c88880052.adcon)
        e2:SetValue(e:GetHandler():GetAttack()*2)
        e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        c:RegisterEffect(e2)
end
function c88880052.adcon(e)
	local c=e:GetHandler()
	return Duel.GetAttacker()==c 
		and (Duel.GetCurrentPhase()==PHASE_DAMAGE or Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL)
end

--Xyz Materials
function c88880052.athcon(e,c)
    return e:GetHandler():IsPreviousLocation(LOCATION_GRAVE) or e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c88880052.athtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_GRAVE,0,1,nil,0x48) end
    local g=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_GRAVE,0,nil,0x48)
    Duel.SetTargetCard(g)
end
function c88880052.mfilter(c,e)
    return c:IsRelateToEffect(e) and not c:IsImmuneToEffect(e)
end
function c88880052.athop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_GRAVE,0,nil,0x48)
    if g:GetCount()>0 then
        Duel.Overlay(c,g)
    end
end
--can't be targeted by card effects
function c88880052.tgcon(e)
    return Duel.GetTurnPlayer()~=e:GetHandlerPlayer()
end
