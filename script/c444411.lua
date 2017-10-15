-- Modular Motherboard
function c444411.initial_effect(c)
	--copy (archetype field spell effect)
    local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetRange(LOCATION_ONFIELD+LOCATION_PZONE)	
	e1:SetOperation(c444411.operation)
	c:RegisterEffect(e1)
	-- return + search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(444411,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND) 
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PREDRAW)
	e2:SetRange(LOCATION_ONFIELD+LOCATION_PZONE)
	e2:SetCountLimit(1,444411)
	e2:SetCondition(c444411.specificcondition)
	e2:SetCost(c444411.specificcost)
	e2:SetTarget(c444411.specifictarget)
	e2:SetOperation(c444411.specificoperation)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e3)
end
function c444411.filter(c)
	return c:IsFaceup() and c:IsSetCard(4444) and not c:IsCode(444411) 
end
function c444411.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.RaiseEvent(e:GetHandler(),444411,e,0,0,0,0)
    local c=e:GetHandler() 
    c:ResetEffect(0xff,RESET_COPY)
    local wg=Duel.GetMatchingGroup(c444411.filter,c:GetControler(),LOCATION_ONFIELD,0,c)
    local wbc=wg:GetFirst()
    while wbc do
        local code=wbc:GetOriginalCode()
        if c:IsFaceup() and c:GetFlagEffect(code)==0  then
            local cid=c:CopyEffect(code,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY,2)
            c:RegisterFlagEffect(code,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY,0,2)
            local e0=Effect.CreateEffect(c)
            e0:SetCode(444411)
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
            e1:SetOperation(c444411.resetop)
            e1:SetReset(RESET_EVENT+0x1fe0000)
            c:RegisterEffect(e1,true)
        end
        wbc=wg:GetNext()
    end
end
function c444411.codefilter(c,code)
    return c:GetOriginalCode()==code and c:IsSetCard(4444)
end
function c444411.resetop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(c444411.filter,tp,LOCATION_ONFIELD,0,nil,nil)
    if not g:IsExists(c444411.codefilter,1,nil,e:GetLabelObject():GetLabel()) or c:IsDisabled() then
        c:ResetEffect(e:GetLabel(),RESET_COPY)
        c:ResetFlagEffect(e:GetLabelObject():GetLabel())
    end
end
-- the draw effect's functions are everything below here:
function c444411.specificcondition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local eqc=c:GetEquipTarget()
	return tp==Duel.GetTurnPlayer() and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 and Duel.GetFlagEffect(tp,e:GetHandler():GetCode())<2 
	and Duel.GetDrawCount(tp)>0 and Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)>1 and not eqc 
end
function c444411.costfilter(c,e,tp)
	return c.IsAbleToDeckAsCost(c) and Duel.IsExistingTarget(c444411.tgfilter,tp,LOCATION_GRAVE,0,1,c,e,tp)
end
function c444411.tgfilter(c,e,tp)
	return c:IsSetCard(4444) and c:IsAbleToHand()
end
function c444411.specificcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c444411.specifictarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c444411.tgfilter(chkc,e,tp) end
	 if chk==0 then	
		if e:GetLabel()==1 then
			e:SetLabel(0)
			return Duel.IsExistingMatchingCard(c444411.costfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		else
			return Duel.IsExistingTarget(c444411.tgfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		end
	  end
	if e:GetLabel()==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local cg=Duel.SelectMatchingCard(tp,c444411.costfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		Duel.SendtoDeck(cg,nil,0,REASON_COST)
		e:SetLabel(0)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c444411.tgfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local dt=Duel.GetDrawCount(tp)
	if dt~=0  then
		_replace_count=0
		_replace_max=dt
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_DRAW_COUNT)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_DRAW)
		e1:SetValue(0)
		Duel.RegisterEffect(e1,tp)
	end		
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
	Duel.RegisterFlagEffect(tp,e:GetHandler():GetCode(),RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c444411.specificoperation(e,tp,eg,ep,ev,re,r,rp)
	local _replace_count=_replace_count+1
	if _replace_count>_replace_max or not e:GetHandler():IsRelateToEffect(e) or e:GetHandler():IsFacedown()then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.GetFirstTarget()	
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tc)	
	Duel.ShuffleDeck(tp)
end