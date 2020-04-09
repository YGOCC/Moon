--"Phantom, the Benefits Handler"
--Scripted by 'Márcio Eduine'
function c90871.initial_effect(c)
	--Fusion Materials
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c90871.ffilter,3,true)
	aux.AddContactFusionProcedure(c,Card.IsAbleToDeckOrExtraAsCost,LOCATION_ONFIELD,0,aux.tdcfop(c))
	--Special Summon Condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(c90871.splimit)
	c:RegisterEffect(e0)
	--ATK Up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c90871.condition)
	e1:SetValue(c90871.atkval)
	c:RegisterEffect(e1)
	--Discard Deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(90871,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCategory(CATEGORY_DECKDES)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c90871.discon)
	e3:SetTarget(c90871.distg)
	e3:SetOperation(c90871.disop)
	c:RegisterEffect(e3)
end
c90871.material_setcode=0x5ab
function c90871.ffilter(c,fc,sub,mg,sg)
	return c:IsLevel(3) and c:IsFusionSetCard(0x5ab) and (not sg or not sg:Filter(Card.IsFusionSetCard,nil,0x5ab):IsExists(Card.IsRace,1,c,c:GetRace()))
end
function c90871.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function c90871.condition(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetLP(tp)>Duel.GetLP(1-tp)
end
function c90871.atkval(e,c)
	local cont=c:GetControler()
	return Duel.GetLP(cont)-Duel.GetLP(1-cont)
end
function c90871.discon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c90871.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,2)
end
function c90871.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(tp,2,REASON_EFFECT)
end