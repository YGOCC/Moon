--Number 9999: Shining Hope Dragon
function c88880021.initial_effect(c)
    aux.AddXyzProcedure(c,aux.FALSE,5,5,c88880021.ovfilter,aux.Stringid(88880021,1))
    c:EnableReviveLimit()
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e0:SetRange(LOCATION_MZONE)
    c:RegisterEffect(e0)
    local e1=e0:Clone()
    e1:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
    c:RegisterEffect(e1)
    --destroy 1 monster
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(88880021,0))
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    --e2:SetValue(2)
    e2:SetCost(c88880021.descost)
    e2:SetTarget(c88880021.destg)
    e2:SetOperation(c88880021.desop)
    c:RegisterEffect(e2)
    --gain ATK
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_DRAW)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EVENT_FREE_CHAIN)
    --e3:SetValue(1)
    e3:SetCondition(c88880021.condition)
    e3:SetCost(c88880021.cost)
    e3:SetTarget(c88880021.target)
    e3:SetOperation(c88880021.activate)
    c:RegisterEffect(e3)
end
c88880021.xyz_number=9999
function c88880021.ovfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x889) or c:IsSetCard(0xcf) or c:IsSetCard(0x890) and c:IsType(TYPE_XYZ) and c:IsSetCard(0x48) or c:IsSetCard(0x1048)-- change that to the code of your desired card.
end
function c88880021.descost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c88880021.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_MZONE,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_MZONE)
end
function c88880021.desop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,0,LOCATION_MZONE,1,1,nil)
    if #g>0 and Duel.Destroy(g,REASON_EFFECT)>0 then
                Duel.Damage(1-tp,g:GetFirst():GetAttack(),REASON_EFFECT)
    end
end
--ATK gain
function c88880021.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)==0
end
function c88880021.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c88880021.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local ct=5-Duel.GetMatchingGroupCount(nil,tp,LOCATION_HAND,0,e:GetHandler())
    if chk==0 then return ct>0 and Duel.IsPlayerCanDraw(tp,ct) end
    Duel.SetTargetPlayer(tp)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function c88880021.activate(e,tp,eg,ep,ev,re,r,rp)
    local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
    local ct=5-Duel.GetFieldGroupCount(p,LOCATION_HAND,0)
    if ct>0 then
        Duel.Draw(p,ct,REASON_EFFECT)
    end
    local c=e:GetHandler()
    local g=Duel.GetOperatedGroup()
    local atk=g:GetSum(Card.GetAttack)
    local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(atk)
        c:RegisterEffect(e1)
end
