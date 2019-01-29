--Shroud of the Dragonlords
local cm=c88800008
local m=88800008
function cm.initial_effect(c)
    --Make Immune and Search
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCondition(cm.condition)
    e1:SetTarget(cm.target)
    e1:SetOperation(cm.activate)
    c:RegisterEffect(e1)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(cm.dfilter,tp,LOCATION_MZONE,0,1,nil,tp)
end
--Target 1 Dragonlord Monster you control
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and cm.dfilter(chkc,tp) end
    if chk==0 then return Duel.IsExistingMatchingCard(cm.dfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
end
--Make that Monster Immune to all effects other than itself then add a card for no reason if it was Normal Summoned.
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsFaceup() and tc:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_IMMUNE_EFFECT)
        e1:SetValue(cm.efilter)
        e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
        if tc:IsSummonType(SUMMON_TYPE_NORMAL) then 
            local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
            if g:GetCount()>0 then
                Duel.SendtoHand(g,nil,REASON_EFFECT)
                Duel.ConfirmCards(1-tp,g) 
            end
        end
    end
end

--Filters
--Is it a face-up Dragonlord Monster? 
function cm.dfilter(c,tp)
    return c:IsFaceup() and c:IsSetCard(0xfb0) and c:IsType(TYPE_MONSTER) and c:IsControler(tp)
end
--Not really sure to be honest
function cm.efilter(e,re)
    return e:GetHandler()~=re:GetOwner()
end
--Is it a Dracolord Card?
function cm.filter(c,e,tp)
    return c:IsSetCard(0xfb0) and not c:IsCode(m)
end