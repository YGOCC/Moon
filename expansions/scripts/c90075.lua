--"Software - Data Fusion"
local m=90075
local cm=_G["c"..m]
function cm.initial_effect(c)
    --"Fusion Summon"
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(90075,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(c90075.ftarget)
    e1:SetOperation(c90075.factivate)
    c:RegisterEffect(e1)
    --"Synchro Material"
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(90075,1))
    e2:SetType(EFFECT_TYPE_ACTIVATE)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetTarget(c90075.starget)
    e2:SetOperation(c90075.sactivate)
    c:RegisterEffect(e2)
    --"Tuner Monster"
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(90075,2))
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetRange(LOCATION_GRAVE)
    e3:SetCost(aux.bfgcost)
    e3:SetTarget(c90075.ttarget)
    e3:SetOperation(c90075.tactivate)
    c:RegisterEffect(e3)
    --"Salvage"
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(90075,3))
    e4:SetCategory(CATEGORY_TOHAND)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_GRAVE)
    e4:SetCost(c90075.thcost)
    e4:SetTarget(c90075.thtg)
    e4:SetOperation(c90075.thop)
    c:RegisterEffect(e4)
end
function c90075.ffilter0(c,e)
    return c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end
function c90075.ffilter1(c,e)
    return c:IsOnField() and not c:IsImmuneToEffect(e)
end
function c90075.ffilter2(c,e,tp,m,f,chkf)
    return c:IsType(TYPE_FUSION) and c:IsSetCard(0x1aa) and (not f or f(c))
        and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c90075.ftarget(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local chkf=tp
        local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsOnField,nil)
        if Duel.GetFieldGroupCount(tp,LOCATION_PZONE,0)>=2 then
            mg1:Merge(Duel.GetMatchingGroup(c90075.ffilter0,tp,LOCATION_PZONE,0,nil,e))
        end
        local res=Duel.IsExistingMatchingCard(c90075.ffilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
        if not res then
            local ce=Duel.GetChainMaterial(tp)
            if ce~=nil then
                local fgroup=ce:GetTarget()
                local mg2=fgroup(ce,e,tp)
                local mf=ce:GetValue()
                res=Duel.IsExistingMatchingCard(c90075.ffilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
            end
        end
        return res
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c90075.factivate(e,tp,eg,ep,ev,re,r,rp)
    local chkf=tp
    local mg1=Duel.GetFusionMaterial(tp):Filter(c90075.ffilter1,nil,e)
    if Duel.GetFieldGroupCount(tp,LOCATION_PZONE,0)>=2 then
        mg1:Merge(Duel.GetMatchingGroup(c90075.ffilter0,tp,LOCATION_PZONE,0,nil,e))
    end
    local sg1=Duel.GetMatchingGroup(c90075.ffilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
    local mg2=nil
    local sg2=nil
    local ce=Duel.GetChainMaterial(tp)
    if ce~=nil then
        local fgroup=ce:GetTarget()
        mg2=fgroup(ce,e,tp)
        local mf=ce:GetValue()
        sg2=Duel.GetMatchingGroup(c90075.ffilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
    end
    if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
        local sg=sg1:Clone()
        if sg2 then sg:Merge(sg2) end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local tg=sg:Select(tp,1,1,nil)
        local tc=tg:GetFirst()
        if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
            local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
            tc:SetMaterial(mat1)
            Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
            Duel.BreakEffect()
            Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
        else
            local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
            local fop=ce:GetOperation()
            fop(ce,e,tp,tc,mat2)
        end
        tc:CompleteProcedure()
    end
end
function c90075.sfilter(c)
    return c:IsFaceup() and c:IsCanBeSynchroMaterial()
end
function c90075.starget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and c90075.sfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c90075.sfilter,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,c90075.sfilter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c90075.sactivate(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_SYNCHRO_MATERIAL)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
    end
end
function c90075.tfilter(c)
    return c:IsFaceup() and c:IsLevelBelow(5) and c:IsSetCard(0x1aa) and not c:IsType(TYPE_TUNER)
end
function c90075.ttarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c90075.tfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c90075.tfilter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,c90075.tfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c90075.tactivate(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsFaceup() then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_ADD_TYPE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        e1:SetValue(TYPE_TUNER)
        tc:RegisterEffect(e1)
    end
end
function c90075.thfilter(c)
    return c:IsSetCard(0x1aa) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c90075.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c90075.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c90075.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c90075.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToHand() end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c90075.thop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SendtoHand(c,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,c)
    end
end