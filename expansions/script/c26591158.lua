--Arti della Xenofiamma - Luna
--Script by XGlitchy30
function c26591158.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,26591158+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c26591158.target)
	e1:SetOperation(c26591158.activate)
	c:RegisterEffect(e1)
end
--filters
function c26591158.thfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(c26591145.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c26591158.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x23b9) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_RITUAL)
end
function c26591158.scfilter(c)
	return c:IsSetCard(0x23b9)
end
--Activate
function c26591158.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c26591158.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,tp)
		or Duel.IsExistingMatchingCard(c26591158.scfilter,tp,LOCATION_MZONE,0,1,nil)
	end
	local opt=0
	if Duel.IsExistingTarget(c26591158.scfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingTarget(c26591158.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,nil,tp) then
		opt=Duel.SelectOption(tp,aux.Stringid(26591158,0),aux.Stringid(26591158,1))
	elseif Duel.IsExistingTarget(c26591158.scfilter,tp,LOCATION_MZONE,0,1,nil) then
		opt=Duel.SelectOption(tp,aux.Stringid(26591158,1))+1
	elseif Duel.IsExistingTarget(c26591158.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,nil,tp) then
		opt=Duel.SelectOption(tp,aux.Stringid(26591158,0))
	end
	e:SetLabel(opt)
	if opt==0 then
		e:SetCategory(CATEGORY_DESTROY)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectTarget(tp,c26591158.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,2,nil,tp)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
	else
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		Duel.SelectTarget(tp,c26591158.scfilter,tp,LOCATION_MZONE,0,1,1,nil)
	end
end
function c26591158.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==0 then
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
		Duel.Destroy(g,REASON_EFFECT)
	else
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			if tc:GetFlagEffect(26591158)==0 then
				tc:RegisterFlagEffect(26591158,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
				e1:SetCode(EFFECT_SET_ATTACK_FINAL)
				e1:SetRange(LOCATION_MZONE)
				e1:SetTargetRange(0,LOCATION_MZONE)
				e1:SetCondition(c26591158.statscon)
				e1:SetTarget(c26591158.statstg)
				e1:SetValue(c26591158.statsval)
				e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e1)
				local e1x=e1:Clone()
				e1x:SetCode(EFFECT_SET_DEFENSE_FINAL)
				e1x:SetValue(c26591158.statsval2)
				tc:RegisterEffect(e1x)
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
				e2:SetCode(EFFECT_PIERCE)
				e2:SetCondition(c26591158.effcon)
				e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e2)
				tc:RegisterFlagEffect(0,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(26591158,2))
			end
		end
	end
end
--halve atk and def
function c26591158.statscon(e)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL) and Duel.GetAttackTarget()~=nil
		and (Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler())
end
function c26591158.statstg(e,c)
	return c==e:GetHandler():GetBattleTarget()
end
function c26591158.statsval(e,c)
	return e:GetHandler():GetBattleTarget():GetAttack()/2
end
function c26591158.statsval2(e,c)
	return e:GetHandler():GetBattleTarget():GetDefense()/2
end
--pierce
function c26591158.effcon(e)
	return e:GetOwnerPlayer()==e:GetHandlerPlayer()
end