--Kiriri, of Virtue
--Keddy was here~
local id,cod=9945210,c9945210
function cod.initial_effect(c)
	--Pre-Link Synchro Summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x204F),aux.NonTuner(cod.sfilter),1)
	--Post-Link Synchro Summon
--	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x101b),1,1,aux.NonTuner(cod.sfilter),1,99)
	c:EnableReviveLimit()
	--Atk
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1)
	e1:SetCost(cod.atkcost)
	e1:SetTarget(cod.atktg)
	e1:SetOperation(cod.atkop)
	c:RegisterEffect(e1)
    --Gain LP
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_RECOVER)
    e2:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
    e2:SetCode(EVENT_PHASE+PHASE_END)
    e2:SetRange(LOCATION_MZONE)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetCountLimit(1)
    e2:SetCondition(cod.reccon)
    e2:SetTarget(cod.rectg2)
    e2:SetOperation(cod.recop2)
    c:RegisterEffect(e2)
    --Indes
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,2))
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_NO_TURN_RESET)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetTarget(cod.indtg)
    e3:SetOperation(cod.indop)
    c:RegisterEffect(e3)
    --Tuner
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id,3))
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetProperty(EFFECT_FLAG_DELAY)
    e4:SetCode(EVENT_SPSUMMON_SUCCESS)
    e4:SetCondition(cod.tncon)
    e4:SetOperation(cod.tnop)
    c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetCode(EFFECT_MATERIAL_CHECK)
    e5:SetValue(cod.valcheck)
    e5:SetLabelObject(e4)
    c:RegisterEffect(e5)
end
function cod.sfilter(c)
	return c:IsSetCard(0x204F) or c:IsType(TYPE_RITUAL)
end
function cod.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,1,nil) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cod.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and aux.nzatk(chkc) end
	if chk==0 then return Duel.IsExistingTarget(aux.nzatk,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,aux.nzatk,tp,0,LOCATION_MZONE,1,1,nil)
end
function cod.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(0)
		tc:RegisterEffect(e1)
	end
end
function cod.reccon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function cod.lfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x204F)
end
function cod.rectg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local ct=Duel.GetMatchingGroupCount(cod.lfilter,tp,LOCATION_MZONE,0,nil)
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(ct*400)
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ct*400)
end
function cod.recop2(e,tp,eg,ep,ev,re,r,rp)
    local ct=Duel.GetMatchingGroupCount(cod.lfilter,tp,LOCATION_MZONE,0,nil)
    Duel.Recover(tp,ct*400,REASON_EFFECT)
end
function cod.ifilter(c,e)
	return c:IsFaceup() and c:IsSetCard(0x2050) and c:IsCanBeEffectTarget(e)
end
function cod.indtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_LOCATION_MZONE) and chkc:IsControler(1-tp) and cod.ifilter(chkc,e) end
	if chk==0 then return Duel.IsExistingTarget(cod.ifilter,tp,LOCATION_MZONE,0,1,nil,e) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,cod.ifilter,tp,LOCATION_MZONE,0,1,1,nil,e)
end
function cod.indop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and c:IsRelateToEffect(e) and c:IsFaceup() then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
        e1:SetCondition(cod.indcon)
        e1:SetLabelObject(c)
        e1:SetValue(1)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        c:RegisterEffect(e1)
        local e2=e1:Clone()
        e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
        tc:RegisterEffect(e2)
	end
end
function cod.indcon(e)
	local c=e:GetLabelObject()
	return c:IsLocation(LOCATION_ONFIELD) and c:IsFaceup()
end
function cod.tncon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO and e:GetLabel()==1
end
function cod.tnop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetCode(EFFECT_ADD_TYPE)
    e1:SetValue(TYPE_TUNER)
    e1:SetReset(RESET_EVENT+0x1fe0000)
    c:RegisterEffect(e1)
end
function cod.valcheck(e,c)
    local g=c:GetMaterial()
    if g:IsExists(Card.IsType,1,nil,TYPE_RITUAL) then
        e:GetLabelObject():SetLabel(1)
    else
        e:GetLabelObject():SetLabel(0)
    end
end