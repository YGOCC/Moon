--Speedy, The Speed's Assassin
function c18691865.initial_effect(c)
    --move
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(18691865,0))
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetTarget(c18691865.seqtg)
    e1:SetOperation(c18691865.seqop)
    c:RegisterEffect(e1)
    --NegateAttack WITH MoveSequence
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(18691865,0))
    e2:SetCategory(CATEGORY_NEGATE)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_BE_BATTLE_TARGET)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetCondition(c18691865.condition1)
    e2:SetCondition(c18691865.seqcon)
    e2:SetTarget(c18691865.negtg)
    e2:SetOperation(c18691865.negop)
    c:RegisterEffect(e2)
    --replace
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(18691865,0))
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetCode(EVENT_CHAINING)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(c18691865.condition2)
    e3:SetTarget(c18691865.target)
    e3:SetOperation(c18691865.operation)
    c:RegisterEffect(e3)
end
function c18691865.filter(c,tp)
    local seq=c:GetSequence()
    if seq>4 then return false end
    return (seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1))
        or (seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1))
end
function c18691865.seqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c18691865.filter(chkc,tp) end
    if chk==0 then return Duel.IsExistingTarget(c18691865.filter,tp,LOCATION_MZONE,0,1,nil,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(18691865,1))
    Duel.SelectTarget(tp,c18691865.filter,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function c18691865.seqop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local tc=Duel.GetFirstTarget()
    if not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) then return end
    local seq=tc:GetSequence()
    if seq>4 then return end
    if (seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1))
        or (seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1)) then
        local flag=0
        if seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1) then flag=bit.replace(flag,0x1,seq-1) end
        if seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1) then flag=bit.replace(flag,0x1,seq+1) end
        flag=bit.bxor(flag,0xff)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
        local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,flag)
        local nseq=0
        if s==1 then nseq=0
        elseif s==2 then nseq=1
        elseif s==4 then nseq=2
        elseif s==8 then nseq=3
        else nseq=4 end
        Duel.MoveSequence(tc,nseq)
    end
end
function c18691865.condition1(e,tp,eg,ep,ev,re,r,rp)
    local at=Duel.GetAttacker()
    return at:GetControler()~=tp
end
function c18691865.seqcon(e,tp,eg,ep,ev,re,r,rp)
     local seq=e:GetHandler():GetSequence()
    if seq>4 then return false end
    return (seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1))
        or (seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1))
end
function c18691865.negtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c18691865.filter1(chkc,tp) end
    if chk==0 then return Duel.IsExistingTarget(c18691865.filter1,tp,LOCATION_MZONE,0,1,nil,tp) end
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c18691865.negop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.NegateAttack(ev) then
end
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) or c:IsControler(1-tp) then return end
    local seq=c:GetSequence()
    if seq>4 then return end
    local flag=0
    if seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1) then flag=flag|(0x1<<seq-1) end
    if seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1) then flag=flag|(0x1<<seq+1) end
    if flag==0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
    Duel.MoveSequence(c,math.log(Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,~flag),2))
end
function c18691865.condition2(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
    if not g or g:GetCount()~=1 then return false end
    local tc=g:GetFirst()
    e:SetLabelObject(tc)
    return tc:IsOnField()
end
function c18691865.filter2(c,re,rp,tf,ceg,cep,cev,cre,cr,crp)
    return tf(re,rp,ceg,cep,cev,cre,cr,crp,0,c)
end
function c18691865.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local ct=ev
    local label=Duel.GetFlagEffectLabel(0,18691865)
    if label then
        if ev==bit.rshift(label,16) then ct=bit.band(label,0xffff) end
    end
    local ce,cp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
    local tf=ce:GetTarget()
    local ceg,cep,cev,cre,cr,crp=Duel.GetChainEvent(ct)
    if chkc then return chkc:IsOnField() and c18691865.filter2(chkc,ce,cp,tf,ceg,cep,cev,cre,cr,crp) end
    if chk==0 then return Duel.IsExistingTarget(c18691865.filter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetLabelObject(),ce,cp,tf,ceg,cep,cev,cre,cr,crp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,c18691865.filter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetLabelObject(),ce,cp,tf,ceg,cep,cev,cre,cr,crp)
    local val=ct+bit.lshift(ev+1,16)
    if label then
        Duel.SetFlagEffectLabel(0,18691865,val)
    else
        Duel.RegisterFlagEffect(0,18691865,RESET_CHAIN,0,1,val)
    end
end
function c18691865.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.ChangeTargetCard(ev,Group.FromCards(tc))
    end
end