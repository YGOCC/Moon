--Wyndbreaker Alexander the Righteous King
function c97671898.initial_effect(c)
    --fusion material
    c:EnableReviveLimit()
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e0:SetCode(EFFECT_FUSION_MATERIAL)
    e0:SetCondition(c97671898.fscon)
    e0:SetOperation(c97671898.fsop)
    c:RegisterEffect(e0)
    --spsummon condition
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(c97671898.splimit)
    c:RegisterEffect(e1)
    --special summon rule
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e2:SetRange(LOCATION_EXTRA)
    e2:SetCondition(c97671898.sprcon)
    e2:SetOperation(c97671898.sprop)
    c:RegisterEffect(e2)
    --battle indestructable
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e3:SetValue(1)
    c:RegisterEffect(e3)
    --
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_TODECK)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetCode(EVENT_DAMAGE_STEP_END)
    e4:SetCondition(c97671898.effcon)
    e4:SetCost(c97671898.effcost)
    e4:SetTarget(c97671898.efftg)
    e4:SetOperation(c97671898.effop)
    c:RegisterEffect(e4)
end
function c97671898.filter1(c)
    return c:IsFusionSetCard(0xd70) and c:IsFusionType(TYPE_NORMAL) and not c:IsHasEffect(6205579)
end
function c97671898.filter2(c)
    return c:IsFusionSetCard(0xd70) and not c:IsHasEffect(6205579)
end
function c97671898.fscon(e,g,gc,chkfnf)
    if g==nil then return true end
    local f1=c54401832.filter1
    local f2=c54401832.filter2
    local chkf=bit.band(chkfnf,0xff)
    local tp=e:GetHandlerPlayer()
    local mg=g:Filter(Card.IsCanBeFusionMaterial,nil,e:GetHandler(),true)
    local mg1=mg:Filter(aux.FConditionFilterConAndSub,nil,f1,true)
    if gc then
        if not gc:IsCanBeFusionMaterial(e:GetHandler(),true) then return false end
        return aux.FConditionFilterFFRCol1(gc,f1,f2,2,chkf,mg,nil,0) 
            or mg1:IsExists(aux.FConditionFilterFFRCol1,1,nil,f1,f2,2,chkf,mg,nil,0,gc)
    end
    return mg1:IsExists(Auxiliary.FConditionFilterFFRCol1,1,nil,f1,f2,2,chkf,mg,nil,0)
end
function c97671898.fsop(e,tp,eg,ep,ev,re,r,rp,gc,chkfnf)
    local f1=c54401832.filter1
    local f2=c54401832.filter2
    local chkf=bit.band(chkfnf,0xff)
    local g=eg:Filter(Card.IsCanBeFusionMaterial,nil,e:GetHandler(),true)
    local mg1=g:Filter(aux.FConditionFilterConAndSub,nil,f1,true)
    local p=tp
    local sfhchk=false
    if Duel.IsPlayerAffectedByEffect(tp,511004008) and Duel.SelectYesNo(1-tp,65) then
        p=1-tp Duel.ConfirmCards(1-tp,g)
        if g:IsExists(Card.IsLocation,1,nil,LOCATION_HAND) then sfhchk=true end
    end
    if gc then
        local matg=Group.CreateGroup()
        if aux.FConditionFilterFFRCol1(gc,f1,f2,2,chkf,g,nil,0) then
            matg:AddCard(gc)
            for i=1,2 do
                Duel.Hint(HINT_SELECTMSG,p,HINTMSG_FMATERIAL)
                local g1=g:FilterSelect(p,aux.FConditionFilterFFRCol2,1,1,nil,f1,f2,2,chkf,g,matg,i-1)
                matg:Merge(g1)
                g:Sub(g1)
            end
            matg:RemoveCard(gc)
            if sfhchk then Duel.ShuffleHand(tp) end
            Duel.SetFusionMaterial(matg)
        else
            Duel.Hint(HINT_SELECTMSG,p,HINTMSG_FMATERIAL)
            local matg=mg1:FilterSelect(p,aux.FConditionFilterFFRCol1,1,1,nil,f1,f2,2,chkf,g,nil,0,gc)
            matg:AddCard(gc)
            g:Sub(matg)
            Duel.Hint(HINT_SELECTMSG,p,HINTMSG_FMATERIAL)
            local g1=g:FilterSelect(p,aux.FConditionFilterFFRCol2,1,1,nil,f1,f2,2,chkf,g,matg,1)
            matg:Merge(g1)
            g:Sub(g1)
            matg:RemoveCard(gc)
            if sfhchk then Duel.ShuffleHand(tp) end
            Duel.SetFusionMaterial(matg)
        end
        return
    end
    local matg=Group.CreateGroup()
    Duel.Hint(HINT_SELECTMSG,p,HINTMSG_FMATERIAL)
    local matg=mg1:FilterSelect(p,aux.FConditionFilterFFRCol1,1,1,nil,f1,f2,2,chkf,g,nil,0,gc)
    g:Sub(matg)
    for i=1,2 do
        Duel.Hint(HINT_SELECTMSG,p,HINTMSG_FMATERIAL)
        local g1=g:FilterSelect(p,aux.FConditionFilterFFRCol2,1,1,nil,f1,f2,2,chkf,g,matg,i-1)
        matg:Merge(g1)
        g:Sub(g1)
    end
    if sfhchk then Duel.ShuffleHand(tp) end
    Duel.SetFusionMaterial(matg)
end
function c97671898.splimit(e,se,sp,st)
    return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c97671898.spfilter1(c,tp,sc)
    return c:IsFusionSetCard(0xd70) and c:IsFusionType(TYPE_NORMAL) and c:IsCanBeFusionMaterial(sc,true)
        and Duel.IsExistingMatchingCard(c97671898.spfilter2,tp,LOCATION_ONFIELD,0,2,c,sc)
end
function c97671898.spfilter2(c,sc)
    return c:IsFusionSetCard(0xd70) and c:IsFusionType(TYPE_MONSTER) and c:IsCanBeFusionMaterial(sc,true)
end
function c97671898.sprcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>-3
        and Duel.IsExistingMatchingCard(c97671898.spfilter1,tp,LOCATION_ONFIELD,0,1,nil,tp,c)
end
function c97671898.sprop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g1=Duel.SelectMatchingCard(tp,c97671898.spfilter1,tp,LOCATION_ONFIELD,0,1,1,nil,tp,c)
    local tc=g1:GetFirst()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g2=Duel.SelectMatchingCard(tp,c97671898.spfilter2,tp,LOCATION_ONFIELD,0,2,2,tc,c)
    g1:Merge(g2)
    local tc=g1:GetFirst()
    while tc do
        if not tc:IsFaceup() then Duel.ConfirmCards(1-tp,tc) end
        tc=g1:GetNext()
    end
    Duel.Release(g1,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
function c97671898.effcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler()==Duel.GetAttacker() and e:GetHandler():IsRelateToBattle()
end
function c97671898.effcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsSetCard,1,e:GetHandler(),0xd70) end
    local g=Duel.SelectReleaseGroup(tp,Card.IsSetCard,1,1,e:GetHandler(),0xd70)
    Duel.Release(g,REASON_COST)
end
function c97671898.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
    local b1=e:GetHandler():IsChainAttackable(0,true)
    local b2=Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD+LOCATION_HAND,1,nil)
    if chk==0 then return b1 or b2 end
    local opt=0
    if b1 and b2 then
        opt=Duel.SelectOption(tp,aux.Stringid(97671898,2),aux.Stringid(97671898,3))
    elseif b1 then
        opt=Duel.SelectOption(tp,aux.Stringid(97671898,2))
    else
        opt=Duel.SelectOption(tp,aux.Stringid(97671898,3))+1
    end
    e:SetLabel(opt)
    if opt==1 then
        Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,1-tp,LOCATION_ONFIELD+LOCATION_HAND)
    end
end
function c97671898.effop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if e:GetLabel()==0 then
        if not c:IsRelateToBattle() then return end
        Duel.ChainAttack()
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE+PHASE_DAMAGE_CAL)
        c:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_PIERCE)
        e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE+PHASE_DAMAGE_CAL)
        c:RegisterEffect(e2)
    else
        local g1=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_HAND,nil)
        local g2=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
        local opt=0
        if g1:GetCount()>0 and g2:GetCount()>0 then
            opt=Duel.SelectOption(tp,aux.Stringid(97671898,4),aux.Stringid(97671898,5))
        elseif g1:GetCount()>0 then
            opt=0
        elseif g2:GetCount()>0 then
            opt=1
        else
            return
        end
        local sg=nil
        if opt==0 then
            sg=g1:RandomSelect(tp,1)
        else
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
            sg=g2:Select(tp,1,1,nil)
        end
        Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
        if sg:GetFirst():IsLocation(LOCATION_DECK) and c:IsRelateToEffect(e) and c:IsFaceup() then
            Duel.BreakEffect()
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
            e1:SetCode(EFFECT_UPDATE_ATTACK)
            e1:SetValue(100)
            e1:SetReset(RESET_EVENT+0x1ff0000)
            c:RegisterEffect(e1)
        end
    end
end