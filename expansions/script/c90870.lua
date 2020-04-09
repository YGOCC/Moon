--"Flowers, the Pain-Conducting Manipulator"
--Scripted by 'Márcio Eduine'
function c90870.initial_effect(c)
	c:SetUniqueOnField(1,0,90870)
	--Link Materials
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c90870.mfilter,2,2)
	--ATK Up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(90870,0))
	e2:SetCategory(CATEGORY_DAMAGE+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_RECOVER)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c90870.condition)
	e2:SetTarget(c90870.atktg)
	e2:SetOperation(c90870.atkop)
	c:RegisterEffect(e2)
	--Discard Deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(90870,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCategory(CATEGORY_DECKDES)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c90870.discon)
	e3:SetTarget(c90870.distg)
	e3:SetOperation(c90870.disop)
	c:RegisterEffect(e3)
end
function c90870.mfilter(c)
	return c:IsLinkSetCard(0x5ab) and c:IsLevel(3)
end
function c90870.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp 
end
function c90870.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x5ab)
end
function c90870.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c90870.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ev)
end
function c90870.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c90870.filter,tp,LOCATION_MZONE,0,nil)
	if g:GetCount()>0 then
		local sc=g:GetFirst()
		while sc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
			e1:SetValue(ev)
			sc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			sc:RegisterEffect(e2)
			sc=g:GetNext()
		end
	Duel.Damage(1-tp,ev*2,REASON_EFFECT)
	end
end
function c90870.discon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c90870.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,2)
end
function c90870.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(tp,2,REASON_EFFECT)
end