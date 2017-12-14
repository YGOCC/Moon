-- The Fortress #2

function c30039212.initial_effect(c)
	--immune
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_IMMUNE_EFFECT)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_FZONE)
	e0:SetValue(c30039212.efilter)
	c:RegisterEffect(e0)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(30039212,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,30039212)
	e1:SetCost(c30039212.cost)
	e1:SetTarget(c30039212.target)
	e1:SetOperation(c30039212.operation)
	c:RegisterEffect(e1)
	
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(30039212,1))
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e2)
	--self destruct
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EFFECT_SELF_DESTROY)
	e3:SetCondition(c30039212.sdcon)
	c:RegisterEffect(e3)
	--atk up
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(c30039212.tg)
	e4:SetValue(c30039212.val)
	c:RegisterEffect(e4)
	--battle immune
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e5:SetRange(LOCATION_FZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xE4))
	e5:SetValue(1)
	c:RegisterEffect(e5)
	
end

function c30039212.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:GetOwner()~=e:GetOwner()
end

--Search
function c30039212.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end

function c30039212.filter(c)
	return (c:IsSetCard(0x130) and not c:IsCode(30039212)) or c:IsSetCard(0xE4) or c:IsCode(87796900) or c:IsCode(57405307) and c:IsAbleToHand()
end

function c30039212.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c30039212.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function c30039212.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c30039212.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
-- self destruct

function c30039212.confilter(c)
	return c:IsFaceup() and (c:IsSetCard(0xE4) or c:IsCode(87796900) or c:IsCode(57405307))
end

function c30039212.sdcon(e)
	return not Duel.IsExistingMatchingCard(c30039212.confilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end

--ATK up

function c30039212.tg(e,c)
	return c:IsCode(87796900) or c:IsCode(57405307)
end
function c30039212.atkfilter(c)
	return c:IsFaceup() and c:IsCode(87796900) or c:IsCode(57405307)
end
function c30039212.val(e,c)
	return Duel.GetMatchingGroupCount(c30039212.atkfilter,c:GetControler(),LOCATION_MZONE,0,nil)*400
end