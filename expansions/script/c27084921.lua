--Exostorm Training Field
function c27084921.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    --remove
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
    e2:SetCode(EFFECT_TO_GRAVE_REDIRECT)
    e2:SetRange(LOCATION_FZONE)
    e2:SetTarget(c27084921.rmtarget)
    e2:SetTargetRange(0xff,0xff)
    e2:SetValue(LOCATION_REMOVED)
    c:RegisterEffect(e2)
    --
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(27084921)
    e3:SetRange(LOCATION_FZONE)
    e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e3:SetTargetRange(0xff,0xff)
    e3:SetTarget(c27084921.checktg)
    c:RegisterEffect(e3)
    --decrease tribute
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(27084921,0))
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_SUMMON_PROC)
    e4:SetRange(LOCATION_FZONE)
    e4:SetTargetRange(LOCATION_HAND,0)
    e4:SetCountLimit(1)
    e4:SetCondition(c27084921.ntcon)
    e4:SetTarget(c27084921.nttg)
    e4:SetOperation(c27084921.ntop)
    c:RegisterEffect(e4)
    --act limit
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e5:SetCode(EVENT_CHAINING)
    e5:SetRange(LOCATION_FZONE)
    e5:SetOperation(c27084921.chainop)
    c:RegisterEffect(e5)
end
function c27084921.rmtarget(e,c)
    return not c:IsLocation(0x80) 
        and c:IsSetCard(0xc1c)
end
function c27084921.checktg(e,c)
    return not c:IsPublic()
end
function c27084921.ntcon(e,c,minc)
    if c==nil then return true end
    return minc==0 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c27084921.nttg(e,c)
    return c:IsLevelAbove(5) and c:IsSetCard(0xc1c)
end
function c27084921.ntop(e,tp,eg,ep,ev,re,r,rp,c)
    c:RegisterFlagEffect(27084921,RESET_EVENT+0x1fe0000-RESET_TOFIELD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(27084921,1))
    local e2=Effect.CreateEffect(e:GetHandler())
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_PHASE+PHASE_END)
    e2:SetCountLimit(1)
    e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e2:SetLabel(Duel.GetTurnCount()+1)
    e2:SetLabelObject(c)
    e2:SetCondition(c27084921.tdcon)
    e2:SetOperation(c27084921.tdop)
    e2:SetReset(RESET_PHASE+PHASE_END,2)
    Duel.RegisterEffect(e2,tp)
end
function c27084921.tdcon(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetLabelObject()
    return Duel.GetTurnCount()~=e:GetLabel() and Duel.GetTurnPlayer()==tp and tc:GetFlagEffectLabel(27084921)==e:GetLabel()
end
function c27084921.tdop(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetLabelObject()
    Duel.Hint(HINT_CARD,1,27084921)
    Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
end
function c27084921.chainop(e,tp,eg,ep,ev,re,r,rp)
    if re:GetHandler():IsSetCard(0xc1c) and re:IsActiveType(TYPE_MONSTER) then
        Duel.SetChainLimit(c27084921.chainlm)
    end
end
function c27084921.chainlm(e,rp,tp)
    return tp==rp
end
