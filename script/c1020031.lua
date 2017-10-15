--Coded-Eyes Imperial Dragon
function c1020031.initial_effect(c)
	c:SetUniqueOnField(1,0,1020031)
	--synchro summon
	aux.AddSynchroProcedure(c,c1020031.tunfil,aux.NonTuner(Card.IsSetCard,0xded),1)
	c:EnableReviveLimit()
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c1020031.damcon)
	e1:SetOperation(c1020031.damop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCondition(aux.bdocon)
	e2:SetTarget(c1020031.sptg)
	e2:SetOperation(c1020031.spop)
	c:RegisterEffect(e2)
end
function c1020031.tunfil(c)
	return c:IsRace(RACE_MACHINE) and c:GetLevel()==3
end
function c1020031.damcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_SYNCHRO)==SUMMON_TYPE_SYNCHRO
end
function c1020031.damfil(c)
	return c:IsFaceup() and c:IsSetCard(0xded) and c:IsType(TYPE_MONSTER)
end
function c1020031.damop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c1020031.damfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.Recover(tp,ct*1000,REASON_EFFECT)
end
function c1020031.filter(c,e,tp)
	return c:GetAttack()<=2500 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c1020031.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c1020031.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.SelectTarget(tp,c1020031.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if tc:GetFirst():IsRelateToEffect(e) then
		if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e2,true)
			Duel.SpecialSummonComplete()
		end
	end
end
