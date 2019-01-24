--"Software - Spy Eye"
local m=90603
local cm=_G["c"..m]
function cm.initial_effect(c)
    --"Apenas um Virado para Cima"
    c:SetUniqueOnField(1,0,90603)
    --"Activar"
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e0)
    --"Remover uma Carta do Jogo"
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(90067,0))
    e1:SetCategory(CATEGORY_REMOVE)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e1:SetType(EFFECT_TYPE_QUICK_F)
    e1:SetCode(EVENT_CHAINING)
    e1:SetRange(LOCATION_SZONE)
    e1:SetCondition(c90603.remcon)
    e1:SetTarget(c90603.remtg)
    e1:SetOperation(c90603.remop)
    c:RegisterEffect(e1)
    --"Embaralhar e Puxar"
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(90603,1))
    e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCountLimit(1,90603)
    e2:SetTarget(c90603.SStarget)
    e2:SetOperation(c90603.SSoperation)
    c:RegisterEffect(e2)
    --"Aumenta o ATK de Todos os Monstros 'Hacker' Normais"
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetRange(LOCATION_SZONE)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_NORMAL))
    e1:SetValue(c90603.val3)
    c:RegisterEffect(e1)
    --"Retorna Todas as Cartas à Mão de se Proprietário"
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_TOHAND)
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetRange(LOCATION_GRAVE)
    e4:SetCountLimit(1)
    e4:SetCost(aux.bfgcost)
    e4:SetTarget(c90603.target)
    e4:SetOperation(c90603.activate)
    c:RegisterEffect(e4)
end
function c90603.remcon(e,tp,eg,ep,ev,re,r,rp)
    return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
        and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function c90603.remtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
     if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_GRAVE)
end
function c90603.remop(e,tp,eg,ep,ev,re,r,rp)
    local ht=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
    if ht==0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local rg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,ht,nil)
    local c=e:GetHandler()
    if rg:GetCount()>0 then
        Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
    end
end
function c90603.SSfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x1aa) and c:IsType(TYPE_PENDULUM)
end
function c90603.SStarget(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp)
        and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_EXTRA,0,1,63,e:GetHandler()) end
    Duel.SetTargetPlayer(tp)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_EXTRA)
end
function c90603.SSoperation(e,tp,eg,ep,ev,re,r,rp)
    local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
    Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(g,c90603.SSfilter,p,LOCATION_EXTRA,0,1,63,nil)
    if g:GetCount()==0 then return end
    Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
    Duel.ShuffleDeck(p)
    Duel.BreakEffect()
    Duel.Draw(p,g:GetCount(),REASON_EFFECT)
end
function c90603.val3(e,c)
    return Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_REMOVED)*200
end
function c90603.filter(c)
    return c:IsType(TYPE_SPELL+TYPE_TRAP+TYPE_MONSTER) and c:IsAbleToHand()
end
function c90603.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.IsExistingMatchingCard(c90603.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) end
    local sg=Duel.GetMatchingGroup(c90603.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,sg:GetCount(),0,0)
end
function c90603.activate(e,tp,eg,ep,ev,re,r,rp)
    local sg=Duel.GetMatchingGroup(c90603.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e))
    Duel.SendtoHand(sg,nil,REASON_EFFECT)
end