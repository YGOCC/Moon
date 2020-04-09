--"Thunder Blade, the Thunder Manipulator"
--Scripted by 'Márcio Eduine'
function c90873.initial_effect(c)
   --Xyz Materials
	aux.AddXyzProcedure(c,c90873.mfilter,3,3,nil,nil,5)
	c:EnableReviveLimit()   
	--ATK/DEF Up and Inflict Damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(90873,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_RECOVER)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c90873.damcon)
	e1:SetCost(c90873.cost)
	e1:SetTarget(c90873.damtg)
	e1:SetOperation(c90873.damop)
	c:RegisterEffect(e1)
	--Discard Deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(90873,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCategory(CATEGORY_DECKDES)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c90873.discon)
	e3:SetTarget(c90873.distg)
	e3:SetOperation(c90873.disop)
	c:RegisterEffect(e3)
end
function c90873.mfilter(c,fc,sub,mg,sg)
	return c:IsLevel(3) and c:IsFusionSetCard(0x5ab) and (not sg or not sg:Filter(Card.IsFusionSetCard,nil,0x5ab):IsExists(Card.IsCode,1,c,c:GetCode()))
end
function c90873.damcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c90873.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c90873.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ev)
end
function c90873.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(ev)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	Duel.Damage(1-tp,ev,REASON_EFFECT)
end
function c90873.discon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c90873.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,2)
end
function c90873.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(tp,2,REASON_EFFECT)
end