--Mysterious Blazar Dragon
function c53313902.initial_effect(c)
	--You can Special Summon this card (from your hand) by tributing 1 "Mysterious Dragon" and 1 LIGHT monster you control.
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_HAND)
	e0:SetCondition(c53313902.spcon)
	e0:SetOperation(c53313902.spop)
	c:RegisterEffect(e0)
	--Once per turn: You can target 1 face-up monster on the field, except This card; this card's effects becomes the targeted monster's effects until the end of this turn.
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c53313902.target)
	e1:SetOperation(c53313902.operation)
	c:RegisterEffect(e1)
	--Once per turn: When a card(s) is banished from the Graveyard: You can target 1 of your banished cards, and add it to your Hand.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetCondition(c53313902.condition)
	e2:SetTarget(c53313902.htarget)
	e2:SetOperation(c53313902.activate)
	c:RegisterEffect(e2)
end
function c53313902.rfilter(c,tp)
	return c:IsCode(53313901) and Duel.CheckReleaseGroup(tp,Card.IsAttribute,1,c,ATTRIBUTE_LIGHT)
end
function c53313902.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.CheckReleaseGroup(tp,c53313902.rfilter,1,nil,tp)
end
function c53313902.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g1=Duel.SelectReleaseGroup(tp,c53313902.rfilter,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g2=Duel.SelectReleaseGroup(tp,Card.IsAttribute,1,1,g1:GetFirst(),ATTRIBUTE_LIGHT)
	g1:Merge(g2)
	Duel.Release(g1,REASON_COST)
end
function c53313902.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc~=e:GetHandler() and chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
end
function c53313902.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsType(TYPE_TOKEN) then
		local code=tc:GetOriginalCodeRule()
		local cid=0
		if not tc:IsType(TYPE_TRAPMONSTER) then
			cid=c:CopyEffect(code, RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END, 1)
		end
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e2:SetCountLimit(1)
		e2:SetRange(LOCATION_MZONE)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e2:SetLabel(cid)
		e2:SetOperation(c53313902.rstop)
		c:RegisterEffect(e2)
	end
end
function c53313902.rstop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cid=e:GetLabel()
	if cid~=0 then c:ResetEffect(cid,RESET_COPY) end
	Duel.HintSelection(Group.FromCards(c))
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c53313902.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_GRAVE)
end
function c53313902.htarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and chkc:IsAbleToHand()end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c53313902.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetFirstTarget()
	if sg:IsRelateToEffect(e) then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
