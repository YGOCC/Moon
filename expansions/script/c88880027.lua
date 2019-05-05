--Crystal-Rose Evolution Dragon
function c88880027.initial_effect(c)
	c:EnableReviveLimit()
	--Pendulum Summon
	aux.EnablePendulumAttribute(c,false)
	--Synchro Summon
	aux.AddSynchroMixProcedure(c,c88880027.matfilter1,nil,nil,aux.NonTuner(c88880027.matfilter),1,99)
	--No Tuner Check
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(88880027)
	c:RegisterEffect(e0)
	--Penudulum Effects
	--(p1) All "CREATION-Eyes" monsters you control cannot be targeted or destroyed by opponents card effects.
	local ep1=Effect.CreateEffect(c)
	ep1:SetType(EFFECT_TYPE_FIELD)
	ep1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	ep1:SetRange(LOCATION_PZONE)
	ep1:SetTargetRange(LOCATION_MZONE,0)
	ep1:SetTarget(c88880027.cntgdetg)
	ep1:SetValue(aux.indoval)
	c:RegisterEffect(ep1)
	local ep2=ep1:Clone()
	ep2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	ep2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	ep2:SetValue(aux.tgoval)
	c:RegisterEffect(ep2)
	--(p2) If a "CREATION-Eyes" monster you control is destroyed (by battle or card effects), you can special summon this card. this effect of "Crystal-Rose Evolution Dragon" cannot be negated, also it can only be activated once per turn.
	local ep3=Effect.CreateEffect(c)
	ep3:SetDescription(aux.Stringid(88880027,0))
	ep3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	ep3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	ep3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DAMAGE_STEP)
	ep3:SetRange(LOCATION_PZONE)
	ep3:SetCode(EVENT_DESTROYED)
	ep3:SetCountLimit(1,88880027)
	ep3:SetCondition(c88880027.spcon)
	ep3:SetTarget(c88880027.sptg)
	ep3:SetOperation(c88880027.spop)
	c:RegisterEffect(ep3)
	--(1) This card can only be destroyed by a "Number" or "CREATION" monster.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(c88880027.indes)
	c:RegisterEffect(e1)
	--(2) Your opponent cannot activate spell effects while this card is face-up on the field. 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetTargetRange(0,1)
	e2:SetValue(c88880027.aclimit)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2)
	--(3) When a "CREATION" monster has it's ATK increased, this cards ATK increases by half that amount. 
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ADJUST)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(c88880027.atkop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CUSTOM+88880027)
	e4:SetRange(LOCATION_MZONE)
	e4:SetOperation(c88880027.atkup)
	c:RegisterEffect(e4)
	--(4) If this card would be destroyed: you can place this card in the Pendulum Zone instead.
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCondition(c88880027.pencon)
	e5:SetTarget(c88880027.pentg)
	e5:SetOperation(c88880027.penop)
	c:RegisterEffect(e5)
end
--Synchro Summon
function c88880027.matfilter1(c,syncard)
	return (c:IsType(TYPE_TUNER) and c:IsSetCard(0x889))
		or (c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x889) and c:IsLevel(4) and c:IsNotTuner(syncard))
end
function c88880027.matfilter(c)
	return c:IsSetCard(0x889) and c:IsType(TYPE_PENDULUM)
end
--Pendulum Effects
--(p1)
function c88880027.cntgdetg(e,c)
	return c:IsSetCard(0x1889)
end
--(p2) If a "CREATION-Eyes" monster you control is destroyed (by battle or card effects), you can special summon this card. this effect of "Crystal-Rose Evolution Dragon" cannot be negated, also it can only be activated once per turn.
function c88880027.cfilter(c,tp)
	return c:IsReason(REASON_DESTROY) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp
		and c:IsSetCard(0x889)
end
function c88880027.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c88880027.cfilter,1,nil,tp)
end
function c88880027.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c88880027.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
--Monster Effects
--(1) 
function c88880027.indes(e,c)
	return not c:IsSetCard(0x48) or c:IsSetCard(0x889)
end
--(2) Your opponent cannot activate spell effects while this card is face-up on the field. 
function c88880027.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE+EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_QUICK_O) and re:IsType(TYPE_SPELL)
end
--(3)
function c88880027.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(function(c)
		return c:IsSetCard(0x889) and c:IsFaceup() and not c:IsCode(88880027)
	end,tp,LOCATION_MZONE,LOCATION_MZONE,c)
	local tc=g:GetFirst()
	while tc do
		if tc:GetFlagEffect(88880027)==0 then
			tc:RegisterFlagEffect(88880027,RESETS_STANDARD,0,1,tc:GetAttack())
		else
			local patk=tc:GetFlagEffectLabel(88880027)
			local atk=tc:GetAttack()
			if atk>patk then
				Duel.RaiseSingleEvent(c,EVENT_CUSTOM+88880027,nil,0,nil,nil,math.ceil((atk-patk)/2))
			end
			tc:ResetFlagEffect(88880027)
			tc:RegisterFlagEffect(88880027,RESETS_STANDARD,0,1,tc:GetAttack())
		end
		tc=g:GetNext()
	end
end
function c88880027.atkup(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(ev)
	e:GetHandler():RegisterEffect(e1)
end
--(4)
function c88880027.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c88880027.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c88880027.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end