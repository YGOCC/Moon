--[[Synchro Tuner + 1+ non-Tuner Monsters
Must first be Synchro Summoned. Once per turn: You can target 1 Synchro Monster in your GY; 
Special Summon it and if you do, double this cards ATK until your opponents next End Phase. 
If you control 2 or more face-up Synchro Monsters, except this card, the ATK of all monsters Special Summoned 
from the Extra Deck becomes 0, except Synchro Monsters. You can only control 1 face-up 
"Woodland Sovereign".]]
function c79854543.initial_effect(c)
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_SYNCHRO),aux.NonTuner(),1)
	c:EnableReviveLimit()
	c:SetUniqueOnField(1,0,79854543)
	--must first be synchro summoned
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.synlimit)
	c:RegisterEffect(e1)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79854543,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c79854543.target)
	e2:SetOperation(c79854543.operation)
	c:RegisterEffect(e2)
	--ATK drop
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c79854543.atktarget)
	e3:SetCondition(c79854543.valcon)
	e3:SetValue(0)
	c:RegisterEffect(e3)
end
--special Summon
function c79854543.filter(c,e,tp)
	return c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c79854543.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c79854543.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c79854543.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c79854543.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c79854543.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(c:GetAttack()*2)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end
--atkdrop
function c79854543.vfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO)
end
function c79854543.valcon(e)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(c79854543.vfilter,c:GetControler(),LOCATION_MZONE,0,2,c)
end
function c79854543.atkfilter(c)
	return c:IsFaceup() and c:GetAttack()>0 and c:GetSummonLocation()==LOCATION_EXTRA and not c:IsType(TYPE_SYNCHRO)
end
function c79854543.atktarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79854543.atkfilter,tp,0,LOCATION_MZONE,1,nil) end
end