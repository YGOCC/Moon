--EQUIPPED ASSASSIN
function c18691854.initial_effect(c)
    --fusion material
    c:EnableReviveLimit()
    aux.AddFusionProcFunRep(c,c18691854.matfilter,2,true)
    --equip
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(18691854,0))
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetCondition(c18691854.eqcon)
    e1:SetTarget(c18691854.eqtg)
    e1:SetOperation(c18691854.eqop)
    --destroy replace
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_DESTROY_REPLACE)
    e3:SetTarget(c18691854.reptg)
    e3:SetOperation(c18691854.repop)
    c:RegisterEffect(e3)
    c:RegisterEffect(e1)
    --Race change
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(18691854,0))
    e5:SetType(EFFECT_TYPE_QUICK_O)
    e5:SetCode(EVENT_FREE_CHAIN)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCountLimit(1)
    e5:SetTarget(c18691854.atttg)
    e5:SetOperation(c18691854.attop)
    c:RegisterEffect(e5)
end
c18691854.the_arrival_of_the_assassin=true
function c18691854.matfilter(c)
    return c:GetSummonLocation()==LOCATION_EXTRA
end
function c18691854.eqcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local ec=e:GetLabelObject()
    return ec==nil or not ec:IsHasCardTarget(c) or ec:GetFlagEffect(18691854)>=1
end
function c18691854.filter(c)
    return c:IsFaceup() and c:IsAbleToChangeControler()
end
function c18691854.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c18691854.filter(chkc) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingTarget(c18691854.filter,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    local g=Duel.SelectTarget(tp,c18691854.filter,tp,0,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c18691854.eqlimit(e,c)
    return e:GetOwner()==c
end
function c18691854.eqop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsType(TYPE_MONSTER) then
        if c:IsFaceup() and c:IsRelateToEffect(e) then
             local atk=tc:GetTextAttack()
            if atk<0 then atk=0 end
            if not Duel.Equip(tp,tc,c,false) then return end
            --Add Equip limit
            tc:RegisterFlagEffect(18691854,RESET_EVENT+RESETS_STANDARD,0,0)
            e:SetLabelObject(tc)
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_EQUIP_LIMIT)
            e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD)
            e1:SetValue(c18691854.eqlimit)
            tc:RegisterEffect(e1)
            if atk>0 then
                local e2=Effect.CreateEffect(c)
                e2:SetType(EFFECT_TYPE_EQUIP)
                e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OWNER_RELATE)
                e2:SetCode(EFFECT_UPDATE_ATTACK)
                e2:SetReset(RESET_EVENT+RESETS_STANDARD)
                e2:SetValue(atk)
                tc:RegisterEffect(e2)
            end
        end
    end
end
function c18691854.repfilter(c,e)
    return c:IsFaceup() and c:IsType(TYPE_EQUIP)
        and c:IsDestructable(e) and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
end
function c18691854.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return not c:IsReason(REASON_REPLACE) and c:IsOnField() and c:IsFaceup()
        and Duel.IsExistingMatchingCard(c18691854.repfilter,tp,LOCATION_ONFIELD,0,1,c,e) end
    if Duel.SelectEffectYesNo(tp,c,96) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
        local g=Duel.SelectMatchingCard(tp,c18691854.repfilter,tp,LOCATION_ONFIELD,0,1,1,c,e)
        Duel.SetTargetCard(g)
        g:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,true)
        return true
    else return false end
end
function c18691854.repop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    g:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,false)
    Duel.Destroy(g,REASON_EFFECT+REASON_REPLACE)
end
function c18691854.atttg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RACE)
    local aat=Duel.AnnounceRace(tp,1,RACE_ALL-e:GetHandler():GetRace())
    e:SetLabel(aat)
end
function c18691854.attop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and c:IsFaceup() then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CHANGE_RACE)
        e1:SetValue(e:GetLabel())
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
        c:RegisterEffect(e1)
    end
end