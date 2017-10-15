-- Modular Setup
function c444405.initial_effect(c)
	--copy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(444405,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_ONFIELD+LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c444405.condition)
	e1:SetTarget(c444405.target)
	e1:SetOperation(c444405.operation)
	c:RegisterEffect(e1)
	-- add to hand
    local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(444405,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_ONFIELD+LOCATION_PZONE)
	e2:SetCondition(c444405.condition)
	e2:SetCost(c444405.acost)
	e2:SetTarget(c444405.atg)
	e2:SetOperation(c444405.aop)
	c:RegisterEffect(e2)
end
-- "global handlerspecific activation limiter" (archetype effect)
function c444405.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local eqc=c:GetEquipTarget()
	return  Duel.GetFlagEffect(tp,e:GetHandler():GetCode())<2 and not eqc 
end
-- copy target (taken from dark panther, changed target to being an achetype card on the field)
function c444405.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and c444405.copyfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c444405.copyfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c444405.copyfilter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.RegisterFlagEffect(tp,e:GetHandler():GetCode(),RESET_EVENT+0x007e0000+RESET_PHASE+PHASE_END,0,1)
end
function c444405.copyfilter(c)
	return c:IsFaceup() and c:IsSetCard(4444)
end
--copy operation
function c444405.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc and c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsType(TYPE_TOKEN) then
        local code=tc:GetOriginalCodeRule()
        local cid=0
        if not tc:IsType(TYPE_TRAPMONSTER) then
            cid=c:CopyEffect(code,RESET_EVENT+0x007e0000+RESET_PHASE+PHASE_STANDBY,2)
        end
        local e2=Effect.CreateEffect(c)
        e2:SetDescription(aux.Stringid(444405,1))
        e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e2:SetCode(EVENT_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
        e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
        e2:SetCountLimit(1)
        e2:SetRange(LOCATION_ONFIELD)
        e2:SetReset(RESET_EVENT+0x007e0000+RESET_PHASE+PHASE_STANDBY,2)
        e2:SetLabel(cid)
        e2:SetOperation(c444405.rstop)
        c:RegisterEffect(e2)
    end
end
function c444405.rstop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local cid=e:GetLabel()
    if cid~=0 then c:ResetEffect(cid,RESET_COPY) end
    Duel.HintSelection(Group.FromCards(c))
    Duel.Hint(HINT_OPSELECTED,tp,e:GetDescription())
end
-- specific effect from here on:
function c444405.costfilter(c)
	return c:IsDiscardable()
end
function c444405.acost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c444405.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.RegisterFlagEffect(tp,e:GetHandler():GetCode(),RESET_EVENT+0x007e0000+RESET_PHASE+PHASE_END,0,1)
	Duel.DiscardHand(tp,c444405.costfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c444405.afilter(c)
	return c:IsSetCard(4444) and c:IsAbleToHand()and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c444405.atg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c444405.afilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c444405.aop(e,tp,eg,ep,ev,re,r,rp)
	-- if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c444405.afilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
