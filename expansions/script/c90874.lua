--"Gilded General, the Mind Manipulator"
--Scripted by 'Márcio Eduine'
function c90874.initial_effect(c)
	--Xyz Materials
	aux.AddXyzProcedure(c,c90874.mfilter,3,2,nil,nil,5)
	c:EnableReviveLimit()	
	--Take Control
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(90874,0))
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_DAMAGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c90874.condition)
	e1:SetCost(c90874.cost)
	e1:SetTarget(c90874.target)
	e1:SetOperation(c90874.operation)
	c:RegisterEffect(e1)
	--Discard Deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(90874,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCategory(CATEGORY_DECKDES)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c90874.discon)
	e3:SetTarget(c90874.distg)
	e3:SetOperation(c90874.disop)
	c:RegisterEffect(e3)
end
function c90874.mfilter(c,fc,sub,mg,sg)
	return c:IsLevel(3) and c:IsFusionSetCard(0x5ab) and (not sg or not sg:Filter(Card.IsFusionSetCard,nil,0x5ab):IsExists(Card.IsAttribute,1,c,c:GetAttribute()))
end
function c90874.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c90874.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c90874.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsControlerCanBeChanged() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c90874.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		if Duel.GetControl(tc,tp,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)~=0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DIRECT_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
			tc:RegisterEffect(e1)
		end
	end
end
function c90874.discon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c90874.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,2)
end
function c90874.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(tp,2,REASON_EFFECT)
end