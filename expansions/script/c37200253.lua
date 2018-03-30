--Miracoulous Intervention
--Script by XGlitchy30
function c37200253.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c37200253.target)
	e1:SetOperation(c37200253.activate)
	c:RegisterEffect(e1)
end
--filters
function c37200253.shfilter(c)
	return c:IsFaceup() and c:IsAbleToDeck()
end
function c37200253.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c37200253.confirmation(c,card)
	return c==card
end
function c37200253.debug(c)
	return c:IsCode(57019473)
end
--Activate
function c37200253.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsFaceup() and chkc:IsAbleToDeck() end
	if chk==0 then return Duel.IsExistingTarget(c37200253.shfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c37200253.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c37200253.shfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c37200253.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsAbleToDeck() then
		Duel.SendtoDeck(tc,nil,1,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		local spg=Duel.GetMatchingGroup(c37200253.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
		local sp=spg:GetFirst()
		--groups
		local acc=Group.CreateGroup()
		local ref=Group.CreateGroup()
		local pass=Group.CreateGroup()
		while sp do
			local check=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_HAND,0,sp,TYPE_MONSTER)
			local chck=check:GetFirst()
			while chck do
				local sum=sp:GetAttack()+sp:GetDefense()
				local chksum=chck:GetAttack()+chck:GetDefense()
				if sum>chksum then
					acc:AddCard(sp)
				else
					ref:AddCard(sp)
				end
				chck=check:GetNext()
			end
			if acc:IsExists(c37200253.confirmation,1,nil,sp) and not ref:IsExists(c37200253.confirmation,1,nil,sp) then
				pass:AddCard(sp)
			end
			sp=spg:GetNext()
		end
		if pass:GetCount()>0 then
			local pc=pass:GetFirst()
			if Duel.SpecialSummonStep(pc,0,tp,tp,false,false,POS_FACEUP) then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				pc:RegisterEffect(e1,true)
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetReset(RESET_EVENT+0x1fe0000)
				pc:RegisterEffect(e2,true)
				pc:RegisterFlagEffect(37200253,RESET_EVENT+0x1fe0000,0,1)
				local e3=Effect.CreateEffect(e:GetHandler())
				e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e3:SetCode(EVENT_PHASE+PHASE_END)
				e3:SetCountLimit(1)
				e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
				e3:SetLabelObject(pc)
				e3:SetCondition(c37200253.atdcon)
				e3:SetOperation(c37200253.autodestroy)
				Duel.RegisterEffect(e3,tp)
				local e4=Effect.CreateEffect(e:GetHandler())
				e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
				e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
				e4:SetCode(EVENT_DESTROY)
				e4:SetLabel(tp)
				e4:SetCondition(c37200253.prcon)
				e4:SetOperation(c37200253.prop)
				e4:SetReset(RESET_EVENT+0x1fe0000)
				pc:RegisterEffect(e4)	
			end
			Duel.SpecialSummonComplete()
		end
	end
end
--autodestruction
function c37200253.atdcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(37200253)~=0 then
		return true
	else
		e:Reset()
		return false
	end
end
function c37200253.autodestroy(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Destroy(tc,REASON_EFFECT)
end
--protection
function c37200253.prcon(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetLabel()
	return rp~=p
end
function c37200253.prop(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetLabel()
	--damage protection
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,p)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,p)
	--destruction protection
	local e11=Effect.CreateEffect(e:GetHandler())
	e11:SetType(EFFECT_TYPE_FIELD)
	e11:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e11:SetTarget(c37200253.tg)
	e11:SetTargetRange(LOCATION_MZONE,0)
	e11:SetReset(RESET_PHASE+PHASE_END)
	e11:SetValue(1)
	Duel.RegisterEffect(e11,p)
	local e12=Effect.CreateEffect(e:GetHandler())
	e12:SetType(EFFECT_TYPE_FIELD)
	e12:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e12:SetTarget(c37200253.tg)
	e12:SetTargetRange(LOCATION_MZONE,0)
	e12:SetReset(RESET_PHASE+PHASE_END)
	e12:SetValue(1)
	Duel.RegisterEffect(e12,p)
end
function c37200253.tg(e,c)
	return c:IsType(TYPE_MONSTER)
end