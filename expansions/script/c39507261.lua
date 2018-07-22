--Rion the Crusader
function c39507261.initial_effect(c)
    c:SetUniqueOnField(1,0,39507261)
    --tohand
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(39507261,0))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e1:SetTarget(c39507261.thtg)
    e1:SetOperation(c39507261.thop)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
    c:RegisterEffect(e2)
    local e3=e1:Clone()
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e3)
    --spsummon
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(39507261,1))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTarget(c39507261.sptg)
    e4:SetOperation(c39507261.spop)
    c:RegisterEffect(e4)
    --destroy equip
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(39507261,2))
    e5:SetCategory(CATEGORY_DESTROY)
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetRange(LOCATION_MZONE)
    e5:SetTarget(c39507261.destg)
    e5:SetOperation(c39507261.desop)
    c:RegisterEffect(e5)
end
function c39507261.thfilter(c)
    return c:IsSetCard(0xf6e) and c:IsAbleToHand()
end
function c39507261.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c39507261.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c39507261.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c39507261.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c39507261.filter1(c,e)
    return c:IsOnField() and c:IsSetCard(0xf6e) and (not e or not c:IsImmuneToEffect(e))
end
function c39507261.filter2(c,e,tp,m,f,chkf)
    return c:IsType(TYPE_FUSION) and (not f or f(c))
        and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c39507261.filter3(c)
    return c:IsCanBeFusionMaterial() and c:IsSetCard(0xf6e)
end
function c39507261.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local chkf=tp
        local mg1=Duel.GetFusionMaterial(tp):Filter(c39507261.filter1,nil)
        local res=Duel.IsExistingMatchingCard(c39507261.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
        if not res then
            local ce=Duel.GetChainMaterial(tp)
            if ce~=nil then
                local fgroup=ce:GetTarget()
                local mg2=fgroup(ce,e,tp):Filter(c39507261.filter3,nil)
                local mf=ce:GetValue()
                res=Duel.IsExistingMatchingCard(c39507261.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
            end
        end
        return res
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c39507261.spop(e,tp,eg,ep,ev,re,r,rp)
    local chkf=tp
    local mg1=Duel.GetFusionMaterial(tp):Filter(c39507261.filter1,nil,e)
    local sg1=Duel.GetMatchingGroup(c39507261.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
    local mg2=nil
    local sg2=nil
    local ce=Duel.GetChainMaterial(tp)
    if ce~=nil then
        local fgroup=ce:GetTarget()
        mg2=fgroup(ce,e,tp):Filter(c39507261.filter3,nil)
        local mf=ce:GetValue()
        sg2=Duel.GetMatchingGroup(c39507261.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
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
function c39507261.eqfilter(c,ec)
    return c:GetEquipTarget()==ec
end
function c39507261.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chkc then return chkc:IsOnField() end
    if chk==0 then return Duel.IsExistingMatchingCard(c39507261.eqfilter,tp,LOCATION_SZONE,0,1,nil,e:GetHandler())
        and Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil) end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c39507261.desop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectMatchingCard(tp,c39507261.eqfilter,tp,LOCATION_SZONE,0,1,1,nil,e:GetHandler())
    if c:IsRelateToEffect(e) and Duel.Destroy(g,REASON_EFFECT)~=0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
        local sg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
        if sg:GetCount()>0 then
            Duel.HintSelection(sg)
            Duel.Destroy(sg,REASON_EFFECT)
        end
    end
end