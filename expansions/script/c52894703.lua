--Seed of Corruption
--Keddy was here~
local function ID()
    local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
    str=string.sub(str,1,string.len(str)-4)
    local cod=_G[str]
    local id=tonumber(string.sub(str,2))
    return id,cod
end

local id,cod=ID()
function cod.initial_effect(c)
    --Fusion Summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_F)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCost(cod.effcost)
    e1:SetTarget(cod.sptg)
    e1:SetOperation(cod.spop)
    c:RegisterEffect(e1)
    --Search
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_HAND)
    e2:SetCost(cod.thcost)
    e2:SetTarget(cod.thtg)
    e2:SetOperation(cod.thop)
    c:RegisterEffect(e2)
    --Return
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,2))
    e3:SetCategory(CATEGORY_TOHAND)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetRange(LOCATION_GRAVE)
    e3:SetCost(cod.effcost)
    e3:SetCondition(cod.rtcon)
    e3:SetTarget(cod.rttg)
    e3:SetOperation(cod.rtop)
    c:RegisterEffect(e3)
end

--Common Cost/Condition
function cod.effcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFlagEffect(tp,id)==0 end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(1,0)
    e1:SetTarget(cod.splimit)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function cod.splimit(e,c,sump,sumtype,sumpos,targetp,se)
    return not c:IsSetCard(0xf07a) and c:IsLocation(LOCATION_EXTRA)
end

--Fusion Summon
function cod.filter0(c)
    return c:IsCanBeFusionMaterial()
end
function cod.filter1(c,e)
    return c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end
function cod.filter2(c,e,tp,m,f,chkf)
    return c:IsSetCard(0xf07a) and c:IsType(TYPE_FUSION) and (not f or f(c))
        and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function cod.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local chkf=tp
        local mg1=Duel.GetFusionMaterial(tp)
        local mg2=Duel.GetMatchingGroup(cod.filter0,tp,0,LOCATION_MZONE,nil)
        mg1:Merge(mg2)
        local res=Duel.IsExistingMatchingCard(cod.filter2,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp,mg1,nil,chkf)
        if not res then
            local ce=Duel.GetChainMaterial(tp)
            if ce~=nil then
                local fgroup=ce:GetTarget()
                local mg3=fgroup(ce,e,tp)
                local mf=ce:GetValue()
                res=Duel.IsExistingMatchingCard(cod.filter2,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp,mg3,mf,chkf)
            end
        end
        return res
    end
    Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cod.spop(e,tp,eg,ep,ev,re,r,rp)
    local chkf=tp
    local mg1=Duel.GetFusionMaterial(tp)
    local mg2=Duel.GetMatchingGroup(cod.filter1,tp,0,LOCATION_MZONE,nil,e)
    mg1:Merge(mg2)
    local sg1=Duel.GetMatchingGroup(cod.filter2,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,nil,e,tp,mg1,nil,chkf)
    local mg3=nil
    local sg2=nil
    local ce=Duel.GetChainMaterial(tp)
    if ce~=nil then
        local fgroup=ce:GetTarget()
        mg3=fgroup(ce,e,tp)
        local mf=ce:GetValue()
        sg2=Duel.GetMatchingGroup(cod.filter2,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,nil,e,tp,mg3,mf,chkf)
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
            local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
            local fop=ce:GetOperation()
            fop(ce,e,tp,tc,mat2)
        end
        tc:CompleteProcedure()
    end
end

--Search
function cod.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFlagEffect(tp,id)==0 and not e:GetHandler():IsPublic() end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(1,0)
    e1:SetTarget(cod.splimit)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function cod.splimit(e,c,sump,sumtype,sumpos,targetp,se)
    return not c:IsSetCard(0xf07a) and c:IsLocation(LOCATION_EXTRA)
end
function cod.th_filter(c)
    return c:IsAbleToHand() and c:IsCode(24094653) 
end
function cod.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_DECK) and cod.th_filter(chkc) end
    if chk==0 then return Duel.IsExistingMatchingCard(cod.th_filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
    Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
end
function cod.thop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,cod.th_filter,tp,LOCATION_DECK,0,1,1,nil)
    if #g<=0 then return end
    Duel.SendtoHand(g,nil,REASON_EFFECT)
end

--Return
function cod.rtcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(Card.IsSetCard,1,nil,0xf07a)
end
function cod.rttg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToHand() end
    Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,tp,LOCATION_GRAVE)
end
function cod.rtop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SendtoHand(c,nil,REASON_EFFECT)
    end
end