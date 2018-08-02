--ASSASSIN - DARKNESS BLADE
function c18691845.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x50e),2,99,c18691845.lcheck)
    c:EnableReviveLimit()
    --indes
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e1:SetValue(c18691845.indval)
    c:RegisterEffect(e1)
    --reduce
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(18691845,0))
    e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DAMAGE)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCondition(c18691845.condition)
    e2:SetTarget(c18691845.target)
    e2:SetOperation(c18691845.operation)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e3)
    --draw
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(18691845,0))
    e4:SetCategory(CATEGORY_DRAW)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e4:SetCode(EVENT_BATTLE_DESTROYING)
    e4:SetCondition(aux.bdocon)
    e4:SetTarget(c18691845.drtg)
    e4:SetOperation(c18691845.drop)
    c:RegisterEffect(e4)
    --atkup
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e5:SetCode(EFFECT_UPDATE_ATTACK)
    e5:SetRange(LOCATION_MZONE)
    e5:SetValue(c18691845.atkval)
    c:RegisterEffect(e5)
end
function c18691845.lcheck(g,lc)
    return g:IsExists(Card.IsCode,1,nil,18591838)
end
function c18691845.indval(e,c)
    return c:IsLinkBelow(3)
end
function c18691845.condition(e,tp,eg,ep,ev,re,r,rp)
    if eg:GetCount()~=1 then return false end
    local tc=eg:GetFirst()
    return tc~=e:GetHandler() and tc:IsFaceup() and tc:GetLink()>0 and tc:GetSummonPlayer()==1-tp
end
function c18691845.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,eg:GetFirst():GetLink()*200)
end
function c18691845.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=eg:GetFirst()
    if tc:IsFaceup() and tc:IsLocation(LOCATION_MZONE) and not tc:IsImmuneToEffect(e) then
        local atk=tc:GetAttack()
        local nv=math.min(atk,tc:GetLink()*200)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        e1:SetValue(-tc:GetLink()*200)
        tc:RegisterEffect(e1)
        if not tc:IsHasEffect(EFFECT_REVERSE_UPDATE) then
            Duel.Damage(1-tp,nv,REASON_EFFECT)
        end
    end
end
function c18691845.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c18691845.drop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
end

function c18691845.atkval(e,c)
    local g=e:GetHandler():GetLinkedGroup():Filter(Card.IsFaceup,nil)
    return g:GetSum(Card.GetBaseAttack)
end
function c18691845.antg(e,c)
    return e:GetHandler():GetLinkedGroup():IsContains(c)
end
function c18691845.cfilter(c,lg)
    return c:IsType(TYPE_EFFECT) and lg:IsContains(c)
end
function c18691845.thcon(e,tp,eg,ep,ev,re,r,rp)
    local lg=e:GetHandler():GetLinkedGroup()
    return eg:IsExists(c18691845.cfilter,1,nil,lg)
end