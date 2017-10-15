-- Modular Auxiliary
function c444414.initial_effect(c)

	--destroy replace
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetRange(LOCATION_ONFIELD+LOCATION_PZONE)
	e1:SetTarget(c444414.destg)
	e1:SetValue(c444414.value)
	e1:SetOperation(c444414.desop)
	c:RegisterEffect(e1)

	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e3)

    local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(444414,0))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_ONFIELD+LOCATION_PZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c444414.condition)
	e4:SetCost(c444414.spcost2)
	e4:SetTarget(c444414.target)
	e4:SetOperation(c444414.spop2)
	c:RegisterEffect(e4)
end

function c444414.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local eqc=c:GetEquipTarget()
	return Duel.GetFlagEffect(tp,e:GetHandler():GetCode())<2 and not eqc 
end

function c444414.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c444414.filter,tp,LOCATION_ONFIELD,0,1,e:GetHandler(),tp,e) end
	local g=Duel.SelectMatchingCard(tp,c444414.filter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler(),tp,e)
	Duel.SendtoHand(g,tp,REASON_COST)
 	local effectcopy=g:GetFirst()
 	e:SetLabelObject(effectcopy)

	Duel.RegisterFlagEffect(tp,e:GetHandler():GetCode(),RESET_EVENT+0x007e0000+RESET_PHASE+PHASE_END,0,1)
end

-- copy functions: target
function c444414.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and c444401.copyfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c444401.copyfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c444401.copyfilter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())	
	
end

function c444414.filter(c)
	return c:IsSetCard(4444) and c:IsAbleToHandAsCost()
end

function c444414.spop2(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetLabelObject(effectcopy)   
    local code=tc:GetOriginalCodeRule()
    local cid=0
    local target=Duel.GetFirstTarget() 

    cid=target:CopyEffect(code,RESET_EVENT+0x007e0000+RESET_PHASE+PHASE_STANDBY,2)

	local e8=Effect.CreateEffect(e:GetHandler())                
    e8:SetDescription(aux.Stringid(444414,1))
    e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e8:SetCode(EVENT_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
    e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e8:SetCountLimit(1)
    e8:SetRange(LOCATION_ONFIELD+LOCATION_PZONE)
    e8:SetReset(RESET_EVENT+0x007e0000+RESET_PHASE+PHASE_STANDBY,2)
    e8:SetLabel(cid)
    e8:SetOperation(c444414.rstop)
    target:RegisterEffect(e8,true) 

    Duel.RegisterFlagEffect(tp,444443,RESET_EVENT+0x007e0000+RESET_PHASE+PHASE_STANDBY,0,2) 
    local count=Duel.GetFlagEffect(tp,444443)  
    target:RegisterFlagEffect(e:GetHandler():GetOriginalCode(),RESET_EVENT+0x007e0000+RESET_PHASE+PHASE_STANDBY,0,2)
    target:SetFlagEffectLabel(e:GetHandler():GetOriginalCode(),count) 
    target:RegisterFlagEffect(target:GetOriginalCode(),RESET_EVENT+0x007e0000+RESET_PHASE+PHASE_STANDBY,0,2)   
    target:SetFlagEffectLabel(target:GetOriginalCode(),count)
    e:GetHandler():RegisterFlagEffect(e:GetHandler():GetOriginalCode(),RESET_EVENT+0x007e0000+RESET_PHASE+PHASE_STANDBY,0,2) 
    e:GetHandler():SetFlagEffectLabel(e:GetHandler():GetOriginalCode(),count)
    e:GetHandler():RegisterFlagEffect(target:GetOriginalCode(),RESET_EVENT+0x007e0000+RESET_PHASE+PHASE_STANDBY,0,2) 
    e:GetHandler():SetFlagEffectLabel(target:GetOriginalCode(),count)
    target:RegisterFlagEffect(count,RESET_EVENT+0x007e0000+RESET_PHASE+PHASE_STANDBY,0,2)
    target:SetFlagEffectLabel(count,count)
    e:GetHandler():RegisterFlagEffect(count,RESET_EVENT+0x007e0000+RESET_PHASE+PHASE_STANDBY,0,2) 
    e:GetHandler():SetFlagEffectLabel(count,count)
end

function c444414.copyfilter(c)
	return c:IsFaceup() and c:IsSetCard(4444)
end

--- end of functions of e4

function c444414.dfilter(c,e)
	local check=e:GetHandler()
	return c:IsLocation(LOCATION_ONFIELD) and c:IsFaceup() and not c:IsReason(REASON_REPLACE) 
	and c:GetFlagEffectLabel(e:GetHandler():GetOriginalCode())==check:GetFlagEffectLabel(e:GetHandler():GetOriginalCode())
	and check:GetFlagEffectLabel(e:GetHandler():GetOriginalCode())==c:GetFlagEffectLabel(c:GetOriginalCode())
	and c:GetFlagEffectLabel(c:GetOriginalCode())==check:GetFlagEffectLabel(c:GetOriginalCode())
	and c:GetFlagEffectLabel(e:GetHandler():GetOriginalCode())>0
end
function c444414.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not eg:IsContains(e:GetHandler())and Duel.IsExistingMatchingCard(c444414.addfilter,tp,LOCATION_DECK,0,1,nil)
		 and eg:IsExists(c444414.dfilter,1,nil,e) end
	if Duel.SelectYesNo(tp,aux.Stringid(444414,1)) then
		local g=Duel.SelectMatchingCard(tp,c444414.cfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
		Duel.RegisterFlagEffect(tp,e:GetHandler():GetCode(),RESET_EVENT+0x007e0000+RESET_PHASE+PHASE_END,0,1)
		return true
	else return false end
end
function c444414.value(e,c)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and not c:IsReason(REASON_REPLACE)
end
function c444414.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
end

function c444414.addfilter(c,e)
	return c:IsCode(e:GetHandler():GetOriginalCode()) and c:IsAbleToHand()
end