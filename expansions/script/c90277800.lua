--Pandemoniumgraph Valkyrie
local card = c90277800
function card.initial_effect(c)
    aux.AddOrigPandemoniumType(c)
    --Search
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(90277800,0))
    e1:SetCategory(CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_SZONE)
    e1:SetCountLimit(1,90277800)
    e1:SetTarget(card.thtg)
    e1:SetOperation(card.thop)
    c:RegisterEffect(e1)
    aux.EnablePandemoniumAttribute(c,e1)
    --Activate
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(90277800,1))
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_DESTROYED)
    e2:SetCondition(card.con)
    e2:SetTarget(card.tg)
    e2:SetOperation(card.op)
    c:RegisterEffect(e2)
end
function card.con(e,tp,eg,ep,ev,re,r,rp)
    return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0
end
function card.thfilter(c)
    return c:IsSetCard(0xcf80) and c:IsAbleToHand() and not c:IsCode(90277800)
end
function card.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(card.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function card.op(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,card.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function card.cfilter(c)
    return c:IsAbleToHand() and c:IsSetCard(0xcf80)
end
function card.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then 
        if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<3 then return false end
        local g=Duel.GetDecktopGroup(tp,3)
        local result=g:FilterCount(card.cfilter,nil)>0
        return result end
    Duel.SetTargetPlayer(tp)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function card.thop(e,tp,eg,ep,ev,re,r,rp)
    local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
    Duel.ConfirmDecktop(p,3)
    local g=Duel.GetDecktopGroup(p,3)
    if g:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
        local sg=g:FilterSelect(p,Card.IsSetCard,1,1,nil,0xcf80)
            Duel.SendtoHand(sg,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-p,sg)
            Duel.ShuffleHand(p)
            Duel.ShuffleDeck(p)
            Duel.BreakEffect()
            Duel.Destroy(e:GetHandler(),REASON_EFFECT)
        end
    end
    
    