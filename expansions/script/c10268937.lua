--Tinsu the Mystic Paladin
function c10268937.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x19121),2,2)
	c:EnableReviveLimit()
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10268937,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,10268937)
	e1:SetTarget(c10268937.settg)
	e1:SetOperation(c10268937.setop)
	c:RegisterEffect(e1)
		--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetTarget(c10268937.indes)
	e2:SetValue(1)
	c:RegisterEffect(e2)
		--cannot be attacked
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e3:SetCondition(c10268937.atcon)
	e3:SetValue(aux.imval1)
	c:RegisterEffect(e3)
end
function c10268937.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x19121)
end
function c10268937.atcon(e)
	return Duel.IsExistingMatchingCard(c10268937.cfilter,e:GetOwnerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end
function c10268937.indes(e,c)
	return c:IsSetCard(0xFAB4B) and c:IsFaceup()
end 
function c10268937.setfilter1(c,tp)
	return c:IsSetCard(0x19121) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
		and Duel.IsExistingMatchingCard(c10268937.setfilter2,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function c10268937.setfilter2(c,code)
	return c:IsSetCard(0x19121) and not c:IsCode(code) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c10268937.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) and Duel.CheckLocation(tp,LOCATION_PZONE,1)
		and Duel.IsExistingMatchingCard(c10268937.setfilter1,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c10268937.setop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c10268937.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) or not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g1=Duel.SelectMatchingCard(tp,c10268937.setfilter1,tp,LOCATION_DECK,0,1,1,nil,tp)
	local tc1=g1:GetFirst()
	if not tc1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g2=Duel.SelectMatchingCard(tp,c10268937.setfilter2,tp,LOCATION_DECK,0,1,1,nil,tc1:GetCode())
	local tc2=g2:GetFirst()
	Duel.MoveToField(tc1,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	Duel.MoveToField(tc2,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end
function c10268937.splimit(e,c)
	return not c:IsSetCard(0x19121)
end