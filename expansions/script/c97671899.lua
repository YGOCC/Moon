--Wyndbreaker Victorie the Virtuous Queen
function c97671899.initial_effect(c)
    --fusion material
    c:EnableReviveLimit()
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e0:SetCode(EFFECT_FUSION_MATERIAL)
    e0:SetCondition(c97671899.fscon)
    e0:SetOperation(c97671899.fsop)
    c:RegisterEffect(e0)
    --spsummon condition
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(c97671899.splimit)
    c:RegisterEffect(e1)
    --special summon rule
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e2:SetRange(LOCATION_EXTRA)
    e2:SetCondition(c97671899.sprcon)
    e2:SetOperation(c97671899.sprop)
    c:RegisterEffect(e2)
    --battle indestructable
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e3:SetValue(1)
    c:RegisterEffect(e3)
    --Attack
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCondition(c97671899.atkcon)
    e4:SetCost(c97671899.atkcost)
    e4:SetTarget(c97671899.atktg)
    e4:SetOperation(c97671899.atkop)
    c:RegisterEffect(e4)
end
function c97671899.filter1(c)
    return c:IsFusionSetCard(0xd70) and c:IsFusionType(TYPE_NORMAL) and not c:IsHasEffect(6205579)
end
function c97671899.filter2(c)
    return c:IsFusionSetCard(0xd70) and not c:IsHasEffect(6205579)
end
function c97671899.fscon(e,g,gc,chkfnf)
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
function c97671899.fsop(e,tp,eg,ep,ev,re,r,rp,gc,chkfnf)
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
function c97671899.splimit(e,se,sp,st)
    return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c97671899.spfilter1(c,tp,sc)
    return c:IsFusionSetCard(0xd70) and c:IsFusionType(TYPE_NORMAL) and c:IsCanBeFusionMaterial(sc,true)
        and Duel.IsExistingMatchingCard(c97671899.spfilter2,tp,LOCATION_ONFIELD,0,2,c,sc)
end
function c97671899.spfilter2(c,sc)
    return c:IsFusionSetCard(0xd70) and c:IsFusionType(TYPE_MONSTER) and c:IsCanBeFusionMaterial(sc,true)
end
function c97671899.sprcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>-3
        and Duel.IsExistingMatchingCard(c97671899.spfilter1,tp,LOCATION_ONFIELD,0,1,nil,tp,c)
end
function c97671899.sprop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g1=Duel.SelectMatchingCard(tp,c97671899.spfilter1,tp,LOCATION_ONFIELD,0,1,1,nil,tp,c)
    local tc=g1:GetFirst()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g2=Duel.SelectMatchingCard(tp,c97671899.spfilter2,tp,LOCATION_ONFIELD,0,2,2,tc,c)
    g1:Merge(g2)
    local tc=g1:GetFirst()
    while tc do
        if not tc:IsFaceup() then Duel.ConfirmCards(1-tp,tc) end
        tc=g1:GetNext()
    end
    Duel.Release(g1,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
function c97671899.atkcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsAbleToEnterBP()
end
function c97671899.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsSetCard,1,c,0xd70) end
    local rg=Duel.SelectReleaseGroup(tp,Card.IsSetCard,1,1,c,0xd70)
    Duel.Release(rg,REASON_COST)
end
function c97671899.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local con1=c:GetFlagEffect(97671899)==0
    local con2=c:GetFlagEffect(97672899)==0
    if chk==0 then return con1 or con2 end
    local op=0
    if con1 and con2 then
        op=Duel.SelectOption(tp,aux.Stringid(97671899,1),aux.Stringid(97671899,2))
    elseif con1 then
        op=Duel.SelectOption(tp,aux.Stringid(97671899,1))
    else
        op=Duel.SelectOption(tp,aux.Stringid(97671899,2))+1
    end
    e:SetLabel(op)
end
function c97671899.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local op=e:GetLabel()
    if op==0 then
        if c:IsFaceup() and c:IsRelateToEffect(e) then
            c:RegisterFlagEffect(97671899,RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END,0,0)
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
            e1:SetRange(LOCATION_MZONE)
            e1:SetCode(EFFECT_IMMUNE_EFFECT)
            e1:SetValue(c97671899.efilter)
            e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
            c:RegisterEffect(e1)
        end
    elseif op==1 then
        if c:IsFaceup() and c:IsRelateToEffect(e) then
            c:RegisterFlagEffect(97672899,RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END,0,0)
            local e2=Effect.CreateEffect(c)
            e2:SetType(EFFECT_TYPE_SINGLE)
            e2:SetCode(EFFECT_EXTRA_ATTACK)
            e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
            e2:SetValue(1)
            e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
            c:RegisterEffect(e2)
        end
    end
end
function c97671899.efilter(e,te)
    return te:IsActiveType(TYPE_TRAP)
end