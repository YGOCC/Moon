--Mechia Technorise
local m=8880810
local cm=_G["c"..m]
function cm.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,m)
    e1:SetTarget(cm.target)
    e1:SetOperation(cm.activate)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(32904931,1))
    e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,8882810)
    e2:SetTarget(cm.tdtg)
    e2:SetOperation(cm.tdop)
    c:RegisterEffect(e2)
end
function cm.dfilter(c)
    return c:IsSetCard(0xff8) and c:IsLevelAbove(1) and c:IsAbleToGrave()
end
function cm.filter(c,e,tp,m,ft)
    if not c:IsSetCard(0xff8) and c:IsType(TYPE_RITUAL)
        or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
    local mg=m:Filter(Card.IsCanBeRitualMaterial,c,c)
    local dg=Duel.GetMatchingGroup(cm.dfilter,tp,LOCATION_DECK,0,nil)
    if ft>0 then
        return mg:CheckWithSumEqual(Card.GetRitualLevel,c:GetLevel(),1,99,c)
            or dg:IsExists(cm.dlvfilter,1,nil,tp,mg,c)
    else
        return ft>-1 and mg:IsExists(cm.mfilterf,1,nil,tp,mg,dg,c)
    end
end
function cm.mfilterf(c,tp,mg,dg,rc)
    if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5 then
        Duel.SetSelectedCard(c)
        return mg:CheckWithSumEqual(Card.GetRitualLevel,rc:GetLevel(),0,99,rc)
            or dg:IsExists(cm.dlvfilter,1,nil,tp,mg,rc,c)
    else return false end
end
function cm.dlvfilter(c,tp,mg,rc,mc)
    Duel.SetSelectedCard(Group.FromCards(c,mc))
    return mg:CheckWithSumEqual(Card.GetRitualLevel,rc:GetLevel(),0,99,rc)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local mg=Duel.GetRitualMaterial(tp)
        local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
        return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,mg,ft)
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
    local v=Duel.GetRitualMaterial(tp)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.filter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,v,ft)
    local tc=tg:GetFirst()
    if tc then
        local mat,dmat
        local mg=v:Filter(Card.IsCanBeRitualMaterial,tc,tc)
        local dg=Duel.GetMatchingGroup(cm.dfilter,tp,LOCATION_DECK,0,nil)
        if ft>0 then
            local b1=dg:IsExists(cm.dlvfilter,1,nil,tp,mg,tc)
            local b2=mg:CheckWithSumEqual(Card.GetRitualLevel,tc:GetLevel(),1,99,tc)
            if b1 and (not b2 or Duel.SelectYesNo(tp,aux.Stringid(m,0))) then
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
                dmat=dg:FilterSelect(tp,cm.dlvfilter,1,1,nil,tp,mg,tc)
                Duel.SetSelectedCard(dmat)
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
                mat=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),0,99,tc)
                mat:Merge(dmat)
            else
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
                mat=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),1,99,tc)
            end
        else
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
            mat=mg:FilterSelect(tp,cm.mfilterf,1,1,nil,tp,mg,dg,tc)
            local b1=dg:IsExists(cm.dlvfilter,1,nil,tp,mg,tc,mat:GetFirst())
            Duel.SetSelectedCard(mat)
            local b2=mg:CheckWithSumEqual(Card.GetRitualLevel,tc:GetLevel(),0,99,tc)
            if b1 and (not b2 or Duel.SelectYesNo(tp,aux.Stringid(m,0))) then
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
                dmat=dg:FilterSelect(tp,cm.dlvfilter,1,1,nil,tp,mg,tc,mat:GetFirst())
                mat:Merge(dmat)
                Duel.SetSelectedCard(mat)
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
                local mat2=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),0,99,tc)
                mat:Merge(mat2)
            else
                Duel.SetSelectedCard(mat)
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
                local mat2=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),0,99,tc)
                mat:Merge(mat2)
            end
        end
        tc:SetMaterial(mat)
        if dmat then
            mat:Sub(dmat)
            Duel.SendtoGrave(dmat,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
        end
        Duel.ReleaseRitualMaterial(mat)
        Duel.BreakEffect()
        Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
        tc:CompleteProcedure()
        tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e1:SetCode(EVENT_PHASE+PHASE_END)
        e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
        e1:SetCondition(cm.descon)
        e1:SetOperation(cm.desop)
        e1:SetReset(RESET_PHASE+PHASE_END,2)
        e1:SetCountLimit(1)
        e1:SetLabel(Duel.GetTurnCount())
        e1:SetLabelObject(tc)
        Duel.RegisterEffect(e1,tp)
    end
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetLabelObject()
    return Duel.GetTurnCount()~=e:GetLabel() and tc:GetFlagEffect(m)~=0
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetLabelObject()
    Duel.Destroy(tc,REASON_EFFECT)
end

function cm.thfilter(c)
    return c:IsFaceup() and c:IsSetCard(0xff8) and c:IsAbleToHand()
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and cm.thfilter(chkc) end
    if chk==0 then return e:GetHandler():IsAbleToDeck()
        and Duel.IsExistingTarget(cm.thfilter,tp,LOCATION_REMOVED,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectTarget(tp,cm.thfilter,tp,LOCATION_REMOVED,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,2,REASON_EFFECT)~=0 and tc:IsRelateToEffect(e) then
        Duel.SendtoHand(tc,nil,REASON_EFFECT)
    end
end