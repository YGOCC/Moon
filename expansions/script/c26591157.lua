--Arti della Xenofiamma - Sol
--Script by XGlitchy30
function c26591157.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,26591157+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c26591157.target)
	e1:SetOperation(c26591157.activate)
	c:RegisterEffect(e1)
end
--filters
function c26591157.thfilter(c,tp)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and Duel.IsExistingMatchingCard(c26591145.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c26591157.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x23b9) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_RITUAL)
end
function c26591157.scfilter(c)
	return c:IsSetCard(0x23b9)
end
--Activate
function c26591157.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c26591157.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,tp)
		or Duel.IsExistingMatchingCard(c26591157.scfilter,tp,LOCATION_MZONE,0,1,nil)
	end
	local opt=0
	if Duel.IsExistingTarget(c26591157.scfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingTarget(c26591157.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,nil,tp) then
		opt=Duel.SelectOption(tp,aux.Stringid(26591157,0),aux.Stringid(26591157,1))
	elseif Duel.IsExistingTarget(c26591157.scfilter,tp,LOCATION_MZONE,0,1,nil) then
		opt=Duel.SelectOption(tp,aux.Stringid(26591157,1))+1
	elseif Duel.IsExistingTarget(c26591157.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,nil,tp) then
		opt=Duel.SelectOption(tp,aux.Stringid(26591157,0))
	end
	e:SetLabel(opt)
	if opt==0 then
		e:SetCategory(CATEGORY_DESTROY)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectTarget(tp,c26591157.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,2,nil,tp)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
	else
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		Duel.SelectTarget(tp,c26591157.scfilter,tp,LOCATION_MZONE,0,1,1,nil)
	end
end
function c26591157.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==0 then
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
		Duel.Destroy(g,REASON_EFFECT)
	else
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			if tc:GetFlagEffect(26591157)==0 then
				tc:RegisterFlagEffect(26591157,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
				local e3=Effect.CreateEffect(e:GetHandler())
				e3:SetCategory(CATEGORY_RECOVER)
				e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
				e3:SetRange(LOCATION_MZONE)
				e3:SetCode(EVENT_BATTLE_DAMAGE)
				e3:SetCondition(c26591157.reccon)
				e3:SetTarget(c26591157.rectg)
				e3:SetOperation(c26591157.recop)
				e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e3)
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
				e2:SetCode(EVENT_PRE_BATTLE_DAMAGE)
				e2:SetLabelObject(e3)
				e2:SetCondition(c26591157.damcon)
				e2:SetOperation(c26591157.damop)
				e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e2)
				tc:RegisterFlagEffect(0,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(26591157,2))
			end
		end
	end
end
--check battle type
function c26591157.damcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and e:GetHandler():GetBattleTarget()~=nil and e:GetOwnerPlayer()==tp
end
function c26591157.damop(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():SetLabel(100)
end
--recover
function c26591157.reccon(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp then return false end
	local rc=eg:GetFirst()
	return rc:IsControler(tp) and rc==e:GetHandler() and e:GetLabel()==100
end
function c26591157.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ev/2)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ev/2)
end
function c26591157.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
	e:SetLabel(0)
end