--Girl Of The Skies: Charb
function c33302.initial_effect(c)
--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
--multiatk
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33302,2))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c33302.atkcon)
	e1:SetCost(c33302.atkcost)
	e1:SetTarget(c33302.atktg)
	e1:SetOperation(c33302.atkop)
	c:RegisterEffect(e1)


local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetTarget(c33302.sptg)
	e4:SetOperation(c33302.spop)
	c:RegisterEffect(e4)
end

function c33302.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP()
end
function c33302.rfilter(c)
	return c:IsCode(3330)
end
function c33302.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c33302.rfilter,1,e:GetHandler()) end
	local g=Duel.SelectReleaseGroup(tp,c33302.rfilter,1,1,e:GetHandler())
	Duel.Release(g,REASON_COST)
end
function c33302.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetEffectCount(EFFECT_EXTRA_ATTACK)==0 end
end
function c33302.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_EXTRA_ATTACK)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
	end
end
function c33302.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c33302.spop(e,tp,eg,ep,ev,re,r,rp)
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
	if ft>0 and Duel.SelectYesNo(tp,aux.Stringid(33302,1)) then
		local token=Duel.CreateToken(tp,3330)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		Duel.SpecialSummonComplete()
	end
end