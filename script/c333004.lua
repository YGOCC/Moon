--Aeropolis Factory -A-
function c333004.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
 --atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x333))
	e2:SetValue(300)
	c:RegisterEffect(e2)
--token 1
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e3:SetCountLimit(1)
	e3:SetCondition(c333004.fcon)
	e3:SetOperation(c333004.fop)
	c:RegisterEffect(e3)

 --synchro summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(333004,0))
	e4:SetCountLimit(1)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCondition(c333004.sccon)
	e4:SetOperation(c333004.scop)
	c:RegisterEffect(e4)
end

function c333004.filter(c)
	return c:IsSetCard(0x333) and c:IsFaceup()
end

function c333004.fcon(e)
	return Duel.IsExistingMatchingCard(c333004.filter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end

function c333004.fop(e,tp,eg,ep,ev,re,r,rp)
	local token=Duel.CreateToken(tp,3330)
	  Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
	Duel.SpecialSummonComplete()
end

function c333004.scfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x333) and c:IsControler(tp) and c:IsType(TYPE_SYNCHRO)
end

function c333004.sccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c333004.scfilter,1,nil,tp)
end

function c333004.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<1 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,3330,0,0x4011,0,0,1,RACE_CYBERSE,ATTRIBUTE_LIGHT) then return end
	local token=Duel.CreateToken(tp,3330)
	if Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.SpecialSummonComplete()
		ft=ft-1
	end
	if ft>0 and Duel.SelectYesNo(tp,aux.Stringid(33303,1)) then
		local token=Duel.CreateToken(tp,3330)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		Duel.SpecialSummonComplete()
	end
end