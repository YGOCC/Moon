--Fierce Schinodorus of Fiber VINE
function c500312525.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	c:EnableReviveLimit()
	--match winner
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,500312525)
	e2:SetTarget(c500312525.tg)
	e2:SetOperation(c500312525.op)
	c:RegisterEffect(e2)	
end
function c500312525.filter(c,e,tp)
	return c:IsFaceup() and c:IsRace(RACE_PLANT)
end

function c500312525.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c500312525.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c500312525.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c500312525.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c500312525.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_RITUAL_LEVEL)
		e1:SetValue(c500312525.rlevel)
		e1:SetReset(RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end

function c500312525.rlevel(e,c)
	local lv=e:GetHandler():GetLevel()
	if c:IsType(TYPE_RITUAL) then
		local clv=c:GetLevel()
		return lv*65536+clv
	else return lv end
end