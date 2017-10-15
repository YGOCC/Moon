-- Modular Scanner
function c444424.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,4444),aux.NonTuner(Card.IsSetCard,4444),1)
	c:EnableReviveLimit()
	-- copy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetRange(LOCATION_ONFIELD+LOCATION_PZONE)	
	e1:SetOperation(c444424.operation)
	c:RegisterEffect(e1)    
    -- hands revealed
    local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_PUBLIC)
	e2:SetCondition(c444424.passivescondition)
	e2:SetRange(LOCATION_ONFIELD+LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
	c:RegisterEffect(e2)
    --look at set card
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(444424,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_ONFIELD+LOCATION_PZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c444424.condition)
	e3:SetTarget(c444424.ltarget)
	e3:SetOperation(c444424.loperation)
	c:RegisterEffect(e3)
end
-- "global handlerspecific activation limiter" (archetype effect)
function c444424.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local eqc=c:GetEquipTarget()
	return  Duel.GetFlagEffect(tp,e:GetHandler():GetCode())<2 and not eqc 
end
function c444424.passivescondition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local eqc=c:GetEquipTarget()
	return  not eqc 
end

function c444424.filter(c)
	return c:IsPublic() and c:IsSetCard(4444) 
end

function c444424.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.RaiseEvent(e:GetHandler(),444424,e,0,0,0,0)
    local c=e:GetHandler() 
    c:ResetEffect(0xff,RESET_COPY)
    local wg=Duel.GetMatchingGroup(c444424.filter,c:GetControler(),LOCATION_HAND,0,c)
    local wbc=wg:GetFirst()
    while wbc do
        local code=wbc:GetOriginalCode()
        if c:IsFaceup() and c:GetFlagEffect(code)==0  then
            local cid=c:CopyEffect(code,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY,2)
            c:RegisterFlagEffect(code,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY,0,2)
            local e0=Effect.CreateEffect(c)
            e0:SetCode(444424)
            e0:SetLabel(code)
            e0:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY,2) 
            c:RegisterEffect(e0,true)
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
            e1:SetCode(EVENT_ADJUST)
            e1:SetRange(LOCATION_ONFIELD+LOCATION_PZONE)
            e1:SetLabel(cid)
            e1:SetLabelObject(e0)
            e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
            e1:SetOperation(c444424.resetop)
            e1:SetReset(RESET_EVENT+0x1fe0000)
            c:RegisterEffect(e1,true)
        end
        wbc=wg:GetNext()
    end
end

function c444424.codefilter(c,code)
    return c:GetOriginalCode()==code and c:IsSetCard(4444)
end
function c444424.resetop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(c444424.filter,tp,LOCATION_HAND,0,nil,nil)
    if not g:IsExists(c444424.codefilter,1,nil,e:GetLabelObject():GetLabel()) or c:IsDisabled() then
        c:ResetEffect(e:GetLabel(),RESET_COPY)
        c:ResetFlagEffect(e:GetLabelObject():GetLabel())
    end
end

function c444424.ltarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFacedown,tp,0,LOCATION_ONFIELD,1,nil)end
	Duel.RegisterFlagEffect(tp,e:GetHandler():GetCode(),RESET_EVENT+0x007e0000+RESET_PHASE+PHASE_END,0,1)
end
function c444424.loperation(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_ONFIELD,nil)
    if g1:GetCount()>0 then
		local sg1=g1:Select(tp,1,1,nil)
		Duel.HintSelection(sg1)		
		local tc=sg1:GetFirst() 
	    if tc  and tc:IsFacedown() then -- and tc:IsRelateToEffect(e)
	    	local tp=e:GetHandler():GetControler()
		    Duel.ConfirmCards(tp,tc)
	    end
	end
end