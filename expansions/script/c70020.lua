--"Espadachim Fusion"
local m=70020
local cm=_G["c"..m]
function cm.initial_effect(c)
    --"Activate"
    local e0=Effect.CreateEffect(c)
    e0:SetDescription(aux.Stringid(70020,0))
    e0:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_DECKDES)
    e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetCode(EVENT_FREE_CHAIN)
    e0:SetTarget(c70020.target)
    e0:SetOperation(c70020.activate)
    c:RegisterEffect(e0)
    --"Fusion Summon"
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(70020,0))
    e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_GRAVE)
    e1:SetCost(aux.bfgcost)
    e1:SetTarget(c70020.FStarget)
    e1:SetOperation(c70020.FSactivate)
    c:RegisterEffect(e1)
end
function c70020.fcheck(tp,sg,fc,mg)
    if sg:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then
        return sg:IsExists(c70020.filterchk,1,nil) end
    return true
end
function c70020.filterchk(c)
    return (c:IsType(TYPE_LINK) and c:IsSetCard(0x509)) and c:IsOnField()
end
function c70020.filter0(c)
    return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToGrave()
end
function c70020.filter1(c,e)
    return not c:IsImmuneToEffect(e)
end
function c70020.filter2(c,e,tp,m,f,chkf)
    return c:IsType(TYPE_FUSION) and c:IsSetCard(0x509) and (not f or f(c))
        and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c70020.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local chkf=tp
        local mg=Duel.GetFusionMaterial(tp)
        local mg2=Duel.GetMatchingGroup(c70020.filter0,tp,LOCATION_DECK,0,nil)
        if mg:IsExists(c70020.filterchk,1,nil) and mg2:GetCount()>0 then
            mg:Merge(mg2)
            aux.FCheckAdditional=c70020.fcheck
        end
        local res=Duel.IsExistingMatchingCard(c70020.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg,nil,chkf)
        aux.FCheckAdditional=nil
        if not res then
            local ce=Duel.GetChainMaterial(tp)
            if ce~=nil then
                local fgroup=ce:GetTarget()
                local mg3=fgroup(ce,e,tp)
                local mf=ce:GetValue()
                res=Duel.IsExistingMatchingCard(c70020.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
            end
        end
        return res
    end
end
function c70020.activate(e,tp,eg,ep,ev,re,r,rp)
    local chkf=tp
    local mg1=Duel.GetFusionMaterial(tp):Filter(c70020.filter1,nil,e)
    local mg2=Duel.GetMatchingGroup(c70020.filter0,tp,LOCATION_DECK,0,nil)
    if mg1:IsExists(c70020.filterchk,1,nil) and mg2:GetCount()>0 then
        mg1:Merge(mg2)
        aux.FCheckAdditional=c70020.fcheck
    end
    local sg1=Duel.GetMatchingGroup(c70020.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
    aux.FCheckAdditional=nil
    local mg2=nil
    local sg2=nil
    local ce=Duel.GetChainMaterial(tp)
    if ce~=nil then
        local fgroup=ce:GetTarget()
        mg2=fgroup(ce,e,tp)
        local mf=ce:GetValue()
        sg2=Duel.GetMatchingGroup(c70020.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
    end
    local sg=sg1:Clone()
    if sg2 then sg:Merge(sg2) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local tg=sg:Select(tp,1,1,nil)
    local tc=tg:GetFirst()
    if not tc then return end
    if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
        aux.FCheckAdditional=c70020.fcheck
        local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
        aux.FCheckAdditional=nil
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
function c70020.FSfilter0(c)
    return c:IsOnField() and c:IsAbleToRemove()
end
function c70020.FSfilter1(c,e)
    return c:IsOnField() and c:IsAbleToRemove() and not c:IsImmuneToEffect(e)
end
function c70020.FSfilter2(c,e,tp,m,f,chkf)
     return c:IsType(TYPE_FUSION) and c:IsSetCard(0x509) and (not f or f(c))
        and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c70020.FSfilter3(c)
    return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove()
end
function c70020.FStarget(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local chkf=tp
        local mg1=Duel.GetFusionMaterial(tp):Filter(c70020.FSfilter0,nil)
        local mg2=Duel.GetMatchingGroup(c70020.FSfilter3,tp,LOCATION_GRAVE,0,nil)
        mg1:Merge(mg2)
        local res=Duel.IsExistingMatchingCard(c70020.FSfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
        if not res then
            local ce=Duel.GetChainMaterial(tp)
            if ce~=nil then
                local fgroup=ce:GetTarget()
                local mg3=fgroup(ce,e,tp)
                local mf=ce:GetValue()
                res=Duel.IsExistingMatchingCard(c70020.FSfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
            end
        end
        return res
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_ONFIELD+LOCATION_GRAVE)
end
function c70020.FSactivate(e,tp,eg,ep,ev,re,r,rp)
    local chkf=tp
    local mg1=Duel.GetFusionMaterial(tp):Filter(c70020.FSfilter1,nil,e)
    local mg2=Duel.GetMatchingGroup(c70020.FSfilter3,tp,LOCATION_GRAVE,0,nil)
    mg1:Merge(mg2)
    local sg1=Duel.GetMatchingGroup(c70020.FSfilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
    local mg3=nil
    local sg2=nil
    local ce=Duel.GetChainMaterial(tp)
    if ce~=nil then
        local fgroup=ce:GetTarget()
        mg3=fgroup(ce,e,tp)
        local mf=ce:GetValue()
        sg2=Duel.GetMatchingGroup(c70020.FSfilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
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
            Duel.Remove(mat1,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
            Duel.BreakEffect()
            Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
        else
            local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
            local fop=ce:GetOperation()
            fop(ce,e,tp,tc,mat2)
        end
        tc:CompleteProcedure()
    end
end