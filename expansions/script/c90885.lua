--"Cannon Handler"
--Scripted by 'Márcio Eduine'
function c90885.initial_effect(c)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(90885,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c90885.operation)
	c:RegisterEffect(e2)
	--Discard Deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(90885,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCategory(CATEGORY_DECKDES)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c90885.discon)
	e3:SetTarget(c90885.distg)
	e3:SetOperation(c90885.disop)
	c:RegisterEffect(e3)
end
function c90885.filter(c,tp)
	return c:IsPreviousLocation(LOCATION_DECK) and c:IsSetCard(0x5ab) and c:IsType(TYPE_MONSTER) and c:IsControler(tp) and c:IsReason(REASON_EFFECT)
end
function c90885.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(c90885.filter,nil,tp)
	if ct>0 then
		Duel.Damage(1-tp,800*ct,REASON_EFFECT)
	end
end
function c90885.discon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c90885.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,1)
end
function c90885.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(tp,1,REASON_EFFECT)
end