--Shadow Bind
--Design and code by Kindrindra
local ref=_G['c'..28915505]
function ref.initial_effect(c)
	if not ref.global_check then
		ref.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetCountLimit(1)
		ge1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge1:SetOperation(ref.chk)
		Duel.RegisterEffect(ge1,0)
	end

	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(ref.negtg)
	e1:SetOperation(ref.negop)
	c:RegisterEffect(e1)
	
end
ref.blink=true
function ref.material1(c)
	return c:GetType()==TYPE_SPELL
end
function ref.material2(c)
	return c:IsType(TYPE_MONSTER)
end
function ref.chk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,555)
	Duel.CreateToken(1-tp,555)
end

function ref.filter(c)
	return c:IsFaceup() and (c:IsType(TYPE_EFFECT) or not c:IsType(TYPE_MONSTER)) and not c:IsDisabled()
end
function ref.negtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) and ref.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(ref.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,ref.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
end
function ref.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsDisabled() and tc:IsControler(1-tp) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_MONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_UPDATE_ATTACK)
			e3:SetValue(-800)
			e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
			local e4=e3:Clone()
			e4:SetCode(EFFECT_UPDATE_DEFENSE)
			tc:RegisterEffect(e4)
		end
	end
end

ref.ODDcount=9
ref.ODDrange=LOCATION_GRAVE
function ref.ODDcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end

function ref.posfilter(c)
	return true
end
function ref.ODDtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(ref.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(ref.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,sg,sg:GetCount(),0,0)
end
function ref.ODDop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(ref.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if sg:GetCount()>0 then
		Duel.ChangePosition(sg,POS_FACEUP_DEFENSE,0,POS_FACEUP_ATTACK,0)
	end
end