--SoA Calldown - Orbital Strike
function c115000878.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1c0)
	e1:SetCondition(c115000878.condition)
	e1:SetTarget(c115000878.target)
	e1:SetOperation(c115000878.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e2:SetCondition(c115000878.handcon)
	c:RegisterEffect(e2)
end
function c115000878.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1AB)
end
function c115000878.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c115000878.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c115000878.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil) end
end
function c115000878.filter(c,e,tp)
	return c:IsRelateToEffect(e) and c:IsFaceup() and c:IsControler(1-tp)
end
function c115000878.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local i=5
	repeat
		i=i-1
		local tc=nil
		if i > 1 then
			tc=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,1,nil):GetFirst()
		else
			tc=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil):GetFirst()
		end
		if not tc then return end
		if tc:IsType(TYPE_SPELL+TYPE_TRAP) and i > 1 then
			Duel.Destroy(tc,REASON_EFFECT)
			Duel.BreakEffect()
			i=i-1
		else
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(-500)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			tc:RegisterEffect(e2)
			Duel.BreakEffect()
			if tc:GetAttack() <=0 or (tc:GetDefense()<=0 and not tc:IsType(TYPE_LINK)) then
				Duel.BreakEffect()
				Duel.Destroy(tc,REASON_EFFECT)
			end
		end
		if Duel.GetMatchingGroupCount(Card.IsFaceup,tp,0,LOCATION_ONFIELD,nil) < 1 or i < 1 or not Duel.SelectYesNo(tp,502) then return end
	until i < 1
end
function c115000878.handfilter(c)
	return c:IsCode(115000268) and c:IsFaceup()
end
function c115000878.handcon(e)
	return Duel.IsExistingMatchingCard(c115000878.handfilter,e:GetHandler():GetControler(),LOCATION_ONFIELD,0,1,nil)
end