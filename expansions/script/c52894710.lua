--Root of the Problem
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
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCost(cod.actcost)
    e1:SetTarget(cod.target)
    e1:SetOperation(cod.activate)
    c:RegisterEffect(e1)
    --Fusion Summon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCost(cod.fscost)
    e2:SetCondition(cod.fscon)
    e2:SetTarget(cod.fstg)
    e2:SetOperation(cod.fsop)
    c:RegisterEffect(e2)
end

--Activate Cost
function cod.splimit(e,c,sump,sumtype,sumpos,targetp,se)
    return not c:IsSetCard(0xf07a) and c:IsLocation(LOCATION_EXTRA)
end
function cod.actcost(e,tp,eg,ep,ev,re,r,rp,chk)
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

--Activate
function cod.spfilter(c,e,tp)
    return c:IsCode(52894703) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end
function cod.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(cod.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
    Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
end
function cod.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cod.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
    if #g>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
        Duel.ConfirmCards(1-tp,g)
    end
end

--Fusion Cost
function cod.fscost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.GetFlagEffect(tp,id)==0 and c:IsAbleToRemove() end
    Duel.Remove(c,POS_FACEUP,REASON_COST)
    --Cannot SPSummon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(1,0)
    e1:SetTarget(cod.splimit)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end

--Fusion Summon
function cod.mfilter(c)
    return c:IsCode(52894703) and c:IsPreviousLocation(LOCATION_ONFIELD) and not c:IsReason(REASON_FUSION+REASON_MATERIAL)
end
function cod.fscon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(cod.mfilter,1,nil)
end
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
function cod.fstg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local chkf=tp
        local mg1=eg:Filter(cod.mfilter,nil)
        local mg2=Duel.GetMatchingGroup(cod.filter0,tp,0,LOCATION_MZONE,nil)
        mg1:Merge(mg2)
        local res=Duel.IsExistingMatchingCard(cod.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
        if not res then
            local ce=Duel.GetChainMaterial(tp)
            if ce~=nil then
                local fgroup=ce:GetTarget()
                local mg3=fgroup(ce,e,tp)
                local mf=ce:GetValue()
                res=Duel.IsExistingMatchingCard(cod.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
            end
        end
        return res
    end
    Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cod.fsop(e,tp,eg,ep,ev,re,r,rp)
    local chkf=tp
    local mg1=eg:Filter(cod.mfilter,nil)
    local mg2=Duel.GetMatchingGroup(cod.filter1,tp,0,LOCATION_MZONE,nil,e)
    mg1:Merge(mg2)
    local sg1=Duel.GetMatchingGroup(cod.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
    local mg3=nil
    local sg2=nil
    local ce=Duel.GetChainMaterial(tp)
    if ce~=nil then
        local fgroup=ce:GetTarget()
        mg3=fgroup(ce,e,tp)
        local mf=ce:GetValue()
        sg2=Duel.GetMatchingGroup(cod.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
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
            if mat1:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE) then
                local gmat=mat1:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
                mat1:Sub(gmat)
                Duel.Remove(gmat,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
            end
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