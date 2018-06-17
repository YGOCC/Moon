local m=9001011
local cm=c9001011
function cm.initial_effect(c)
        local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetDescription(aux.Stringid(m,0))
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_GRAVE)
    e1:SetCountLimit(1,m)
    e1:SetCondition(cm.condition)
    e1:SetTarget(cm.target)
    e1:SetOperation(cm.activate)
    c:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_CHAINING)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetCondition(cm.discon)
    e2:SetTarget(cm.distg)
    e2:SetOperation(cm.disop)
    c:RegisterEffect(e2)
end

function cm.condition(e,tp,eg,ep,ev,re,r,rp)
    local ph=Duel.GetCurrentPhase()
    if Duel.GetTurnPlayer()==tp then
        return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
    end
end
function cm.matfilter(c,rc)
    return c:IsCanBeRitualMaterial(rc) and c:IsType(TYPE_MONSTER)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then
        local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
        local mg=Duel.GetRitualMaterial(tp):Filter(cm.matfilter,c,c)
        if c.mat_filter then
            mg=mg:Filter(c.mat_filter,nil)
        end
        if not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,true) then return end
        if ft>0 then
            return mg:CheckWithSumGreater(Card.GetRitualLevel,c:GetLevel(),c)
        else
            return mg:IsExists(cm.mfilterf,1,nil,tp,mg,c)
        end
    end 
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
    return re:GetHandler()~=e:GetHandler() and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
        and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function cm.disfilter(c)
    return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsAbleToDeck() and c:IsSetCard(0x1f5)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.disfilter,tp,LOCATION_EXTRA,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_EXTRA)
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
    end
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,cm.disfilter,tp,LOCATION_EXTRA,0,1,1,nil)
    if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 then
        if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
            Duel.Destroy(eg,REASON_EFFECT)
        end
    end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local c=e:GetHandler()
    local mg=Duel.GetRitualMaterial(tp):Filter(cm.matfilter,c,c)
    if c.mat_filter then
        mg=mg:Filter(c.mat_filter,nil)
    end
    local mat=nil
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    if ft>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
        mat=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,c:GetLevel(),c)
    else
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
        mat=mg:FilterSelect(tp,cm.mfilterf,1,1,nil,tp,mg,c)
        Duel.SetSelectedCard(mat)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
        local mat2=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,c:GetLevel(),c)
        mat:Merge(mat2)
    end
    c:SetMaterial(mat)
    Duel.ReleaseRitualMaterial(mat)
    Duel.BreakEffect()
    Duel.SpecialSummon(c,SUMMON_TYPE_RITUAL,tp,tp,true,true,POS_FACEUP)
    c:CompleteProcedure()
end