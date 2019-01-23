--"Hacker - Pop, The King Of Cracking Codes"
local m=90071
local cm=_G["c"..m]
function cm.initial_effect(c)
    --"Cracking Counter"
    c:EnableCounterPermit(0x1dc)
    --"Link Materials"
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,c90071.matfilter,2,2)
    --"Search"
    local e0=Effect.CreateEffect(c)
    e0:SetDescription(aux.Stringid(90071,0))
    e0:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e0:SetProperty(EFFECT_FLAG_DELAY)
    e0:SetCode(EVENT_SPSUMMON_SUCCESS)
    e0:SetCountLimit(1,90071)
    e0:SetTarget(c90071.thtg)
    e0:SetOperation(c90071.tgop)
    c:RegisterEffect(e0)
    --"Place Cracking Counter"
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(90071,1))
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_DAMAGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCondition(c90071.condition)
    e1:SetOperation(c90071.counter)
    c:RegisterEffect(e1)
    --"Fusion Summon"
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(90071,2))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1,90071)
    e3:SetCost(c90071.spcost)
    e3:SetTarget(c90071.sptg)
    e3:SetOperation(c90071.spop)
    c:RegisterEffect(e3)
end
function c90071.matfilter(c,lc,sumtype,tp)
    return c:IsSetCard(0x1aa) and c:IsType(TYPE_NORMAL)
end
function c90071.thfilter(c)
    return ((c:IsSetCard(0x1aa) and c:IsType(TYPE_MONSTER)) or c:IsCode(90069)) and c:IsAbleToHand()
end
function c90071.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c90071.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c90071.tgop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c90071.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c90071.condition(e,tp,eg,ep,ev,re,r,rp)
    return ep~=tp and bit.band(r,REASON_BATTLE)==0
end
function c90071.counter(e,tp,eg,ep,ev,re,r,rp)
    e:GetHandler():AddCounter(0x1dc,1)
end
function c90071.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x1dc,2,REASON_COST) end
    e:GetHandler():RemoveCounter(tp,0x1dc,2,REASON_COST)
end
function c90071.spfilter1(c,e)
    return not c:IsImmuneToEffect(e)
end
function c90071.spfilter2(c,e,tp,m,f,chkf)
    return c:IsType(TYPE_FUSION) and c:IsSetCard(0x1aa) and (not f or f(c))
        and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c90071.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local chkf=tp
        local mg1=Duel.GetFusionMaterial(tp)
        local res=Duel.IsExistingMatchingCard(c90071.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
        if not res then
            local ce=Duel.GetChainMaterial(tp)
            if ce~=nil then
                local fgroup=ce:GetTarget()
                local mg2=fgroup(ce,e,tp)
                local mf=ce:GetValue()
                res=Duel.IsExistingMatchingCard(c90071.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
            end
        end
        return res
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c90071.spop(e,tp,eg,ep,ev,re,r,rp)
    local chkf=tp
    local mg1=Duel.GetFusionMaterial(tp):Filter(c90071.spfilter1,nil,e)
    local sg1=Duel.GetMatchingGroup(c90071.spfilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
    local mg2=nil
    local sg2=nil
    local ce=Duel.GetChainMaterial(tp)
    if ce~=nil then
        local fgroup=ce:GetTarget()
        mg2=fgroup(ce,e,tp)
        local mf=ce:GetValue()
        sg2=Duel.GetMatchingGroup(c90071.spfilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
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