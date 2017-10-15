--Digimon Joke GoldNumemon
function c47000076.initial_effect(c)
c:SetUniqueOnField(1,0,47000076)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x3E4),aux.NonTuner(Card.IsSetCard,0x2DD3),1)
	--atk increase
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(47000076,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetOperation(c47000076.atkop)
	c:RegisterEffect(e2)
	--cannot be target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c47000076.tgvalue)
	c:RegisterEffect(e4)
	--cannot be battle target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetValue(c47000076.tg)
	c:RegisterEffect(e2)
end
function c47000076.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(c47000076.atkval)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE)
		c:RegisterEffect(e1)
	end
end
function c47000076.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x2DD3) and c:IsType(TYPE_MONSTER) 
end
function c47000076.atkval(e,c)
	return Duel.GetMatchingGroupCount(c47000076.filter,c:GetControler(),LOCATION_MZONE,0,e:GetHandler())*1000
end
function c47000076.tgvalue(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
function c47000076.tg(e,c)
	return c:IsFaceup() and c~=e:GetHandler() and c:IsSetCard(0x2DD3) 
end
