--Creation Soul Scale 0
function c88880018.initial_effect(c)
	--(1) Pendulum summon
	aux.EnablePendulumAttribute(c)
	--(2) You can only Pendulum Summon "CREATION" monsters. This effect cannot be negated.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c88880018.splimit)
	c:RegisterEffect(e1)
	--(3) Once a turn, when your opponent declares an attack against a "CREATION" Xyz monster you control: you can target that monster; Special Summon, 1 "CREATION" Xyz monster from your extra deck whose rank is increased by 1, by using that monster as material. (This Special Summon is treated as an Xyz Summon. Transfer the Materials.)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e2:SetCountLimit(1)
	e2:SetCondition(c88880018.rnkcon)
	e2:SetTarget(c88880018.rnktg)
	e2:SetOperation(c88880018.rnkop)
	c:RegisterEffect(e2)
end
--(1) You can only Pendulum Summon "CREATION" monsters. This effect cannot be negated.
function c88880018.filter(c)
	return c:IsSetCard(0x889)
end
function c88880018.splimit(e,c,tp,sumtp,sumpos)
	if not (bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM) then return end
	return not c88880018.filter(c)
end
--(2) Once a turn, when your opponent declares an attack against a "CREATION" Xyz monster you control: you can target that monster; Special Summon, 1 "CREATION" Xyz monster from your extra deck whose rank is increased by 1, by using that monster as material. (This Special Summon is treated as an Xyz Summon. Transfer the Materials.)
function c88880018.rnkcon(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttackTarget()
	return tp~=Duel.GetTurnPlayer() and at and at:IsSetCard(0x889) and at:IsType(TYPE_XYZ)
end
function c88880018.rnktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetAttacker() and Duel.GetAttackTarget():IsSetCard(0x889) end
	Duel.SetTargetCard(Duel.GetAttackTarget())
end
function c88880018.spxyzfilter(c,e,tp,mc)
	local rk=mc:GetRank()+1
	return mc:IsCanBeXyzMaterial(c)	
	and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) 
	and c:GetRank()==rk
	and mc:IsSetCard(0x889)
end
function c88880018.rnkop(e,tp,eg,ep,ev,re,r,rp)
	local c=Duel.GetFirstTarget()
	local ct=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) and c:IsControler(tp) and not c:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c88880018.spxyzfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,c)
		local sc=g:GetFirst()
		if sc then
			local mg=c:GetOverlayGroup()
			if mg:GetCount()~=0 then
				Duel.Overlay(sc,mg)
			end
			sc:SetMaterial(Group.FromCards(c))
			Duel.Overlay(sc,Group.FromCards(c))
			Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
			sc:CompleteProcedure()
			Duel.BreakEffect()
			Duel.Destroy(ct,REASON_EFFECT)
		end
	end
end