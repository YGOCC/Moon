--Over Rewind
function c26064012.initial_effect(c)
    --place
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(26064012,0))
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetLabel(000)
    e1:SetTarget(c26064012.tftg)
    e1:SetOperation(c26064012.tfop)
    c:RegisterEffect(e1)
    --destroy
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(26064012,1))
    e2:SetCategory(CATEGORY_TODECK)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_DESTROYED)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
    e2:SetCondition(c26064012.recon)
    e2:SetTarget(c26064012.retg)
    e2:SetOperation(c26064012.reop)
    c:RegisterEffect(e2)
    if not c26064012.global_check then
        c26064012.global_check=true
        local ge1=Effect.CreateEffect(c)
        ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        ge1:SetCode(EVENT_DESTROYED)
        ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_DELAY)
        ge1:SetOperation(c26064012.checkop1)
        Duel.RegisterEffect(ge1,0)
        local ge2=ge1:Clone()
        ge2:SetCode(EVENT_TO_GRAVE)
        ge2:SetOperation(c26064012.checkop2)
        Duel.RegisterEffect(ge2,0)
    end
end
function c26064012.checkop1(e,tp,eg,ep,ev,re,r,rp)
    local tc=eg:GetFirst()
    while tc do
        if tc:IsCode(26064007) then
            tc:RegisterFlagEffect(26064012,RESET_EVENT+RESETS_STANDARD,0,1)
            tc:RegisterFlagEffect(26064010,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
        end
        tc=eg:GetNext()
    end
end
function c26064012.checkop2(e,tp,eg,ep,ev,re,r,rp)
    local tc=eg:GetFirst()
    while tc do
        if tc:IsCode(26064007) and rp~=tp then
            tc:RegisterFlagEffect(26064011,RESET_EVENT+RESETS_STANDARD,0,1)
            tc:RegisterFlagEffect(26064010,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
        end
        tc=eg:GetNext()
    end
end
function c26064012.filter(c,tp)
    return c:IsType(TYPE_FIELD) or (c:IsType(TYPE_CONTINUOUS) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
    and c:IsSetCard(0x664) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function c26064012.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
    local lab=e:GetLabel()
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and c26064012.filter(chkc,e,tp) end
    if chk==0 then return Duel.IsExistingTarget(c26064012.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
    local g=Duel.SelectTarget(tp,c26064012.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
end
function c26064012.chlimit(e,ep,tp)
    return tp==ep
end
function c26064012.tfop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    local v1,v2,v3=false,false,false
    if tc:GetFlagEffect(26064010)~=0 then v1=1 end
    if tc:GetFlagEffect(26064011)~=0 then v2=1 end
    if tc:GetFlagEffect(26064012)~=0 then v3=1 end
    if tc:IsRelateToEffect(e) then
        local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD+LOCATION_HAND,nil)
        if g:GetCount()>0 and v1 and v2 and v3 then
            local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD+LOCATION_HAND)
            local ct=g:GetCount()-Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)
            if ct>0 then
                Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TODECK)
                local g=Duel.SelectMatchingCard(1-tp,Card.IsAbleToDeck,p,0,LOCATION_HAND+LOCATION_ONFIELD,ct,ct,nil)
                Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
            end
        end
        Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
        if tc:IsCode(26064007) then
            Duel.Hint(HINT_CARD,tp,26064012)
            Duel.BreakEffect()
            tc:AddCounter(0xb6,25)
        end
    end
end
function c26064012.recon(e)
    return rp~=tp and e:GetHandler():GetPreviousControler()==tp
end
function c26064012.refilter(c)
    return c:IsMSetable(true,nil) or c:IsSSetable()
end
function c26064012.retg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) end
    if chk==0 then return Duel.IsExistingTarget(c26064012.refilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
    local g=Duel.SelectTarget(tp,c26064012.refilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function c26064012.reop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) then
        if tc:IsType(TYPE_MONSTER) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
            and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) then
            Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
            Duel.ConfirmCards(1-tp,tc)
        elseif (tc:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
            and tc:IsSSetable() then
            Duel.SSet(tp,tc)
            Duel.ConfirmCards(1-tp,tc)
            if tc:IsType(TYPE_TRAP) then
                local e1=Effect.CreateEffect(e:GetHandler())
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
                e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
                e1:SetReset(RESET_PHASE+PHASE_END)
                tc:RegisterEffect(e1)
            end
        end
    end
end