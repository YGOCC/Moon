--"Espadachim - Guardian of the Sword Gate"
local m=70009
local cm=_G["c"..m]
function cm.initial_effect(c)
    --"Link Summon"
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x509),2)
    c:EnableReviveLimit()
    --"Select 3 Equip Spell Cards from your Deck."
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(70009,0))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetCountLimit(1)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTarget(c70009.thtg)
    e1:SetOperation(c70009.thop)
    c:RegisterEffect(e1)
    --"Destroy Replace"
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EFFECT_DESTROY_REPLACE)
    e2:SetTarget(c70009.desreptg)
    e2:SetOperation(c70009.desrepop)
    c:RegisterEffect(e2)
    --"Double damage"
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_PRE_BATTLE_DAMAGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(c70009.damcon)
    e3:SetOperation(c70009.damop)
    c:RegisterEffect(e3)
    --"Damage"
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_DAMAGE)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e4:SetCode(EVENT_BATTLE_DESTROYING)
    e4:SetCondition(c70009.damcon2)
    e4:SetTarget(c70009.damtg2)
    e4:SetOperation(c70009.damop2)
    c:RegisterEffect(e4)
    --"ATK"
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetCode(EFFECT_UPDATE_ATTACK)
    e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCondition(c70009.ATKcondition)
    e5:SetValue(c70009.ATKval)
    c:RegisterEffect(e5)
end
function c70009.thfilter(c)
    return c:IsType(TYPE_EQUIP) and c:IsAbleToHand()
end
function c70009.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c70009.thfilter,tp,LOCATION_DECK,0,3,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c70009.thop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c70009.thfilter,tp,LOCATION_DECK,0,nil)
    if g:GetCount()>=3 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local sg=g:Select(tp,3,3,nil)
        Duel.ConfirmCards(1-tp,sg)
        Duel.ShuffleDeck(tp)
        local tg=sg:RandomSelect(1-tp,1)
        Duel.SendtoHand(tg,nil,REASON_EFFECT)
    end
end
function c70009.repfilter(c)
    return c:IsType(TYPE_SPELL) and c:IsLocation(LOCATION_SZONE) and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
end
function c70009.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then
        local g=c:GetEquipGroup()
        return not c:IsReason(REASON_REPLACE) and g:IsExists(c70009.repfilter,1,nil)
    end
    if Duel.SelectEffectYesNo(tp,c,96) then
        local g=c:GetEquipGroup()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
        local sg=g:FilterSelect(tp,c70009.repfilter,1,1,nil)
        Duel.SetTargetCard(sg)
        return true
    else return false end
end
function c70009.desrepop(e,tp,eg,ep,ev,re,r,rp)
    local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    Duel.SendtoGrave(tg,REASON_EFFECT+REASON_REPLACE)
end
function c70009.damcon(e,tp,eg,ep,ev,re,r,rp)
    local lg=e:GetHandler():GetMutualLinkedGroup()
    local tc=eg:GetFirst()
    return ep~=tp and lg:IsContains(tc) and tc:GetBattleTarget()~=nil
end
function c70009.damop(e,tp,eg,ep,ev,re,r,rp)
    Duel.ChangeBattleDamage(ep,ev*2)
end
function c70009.damcon2(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetMutualLinkedGroupCount()>=2
end
function c70009.damtg2(e,tp,eg,ep,ev,re,r,rp,chk)
    local bc=e:GetHandler():GetBattleTarget()
    local dam=bc:GetTextAttack()
    if chk==0 then return dam>0 end
    Duel.SetTargetCard(bc)
    Duel.SetTargetPlayer(1-tp)
    Duel.SetTargetParam(dam)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c70009.damop2(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
        local dam=tc:GetTextAttack()
        if dam<0 then dam=0 end
        Duel.Damage(p,dam,REASON_EFFECT)
    end
end
function c70009.ATKcondition(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetMutualLinkedGroupCount()==3
end
function c70009.ATKfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x509) and c:GetBaseAttack()>=0
end
function c70009.ATKval(e,c)
    local lg=c:GetLinkedGroup():Filter(c70009.ATKfilter,nil)
    return lg:GetSum(Card.GetBaseAttack)
end