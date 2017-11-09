--A Bushido Beast’s War
function c1020047.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_SUMMON)
	e1:SetTarget(c1020047.target)
	c:RegisterEffect(e1)
	--Atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x4B0))
	e2:SetValue(400)
	c:RegisterEffect(e2)
	--pierce
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(aux.bfgcost)
	e3:SetOperation(c1020047.pierceop)
	c:RegisterEffect(e3)
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DISABLE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetTarget(c1020047.distg)
	e4:SetOperation(c1020047.disop)
	c:RegisterEffect(e4)
end
function c1020047.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(EVENT_SUMMON_SUCCESS,true)
	if res and c1020047.distg(e,tp,teg,tep,tev,tre,tr,trp,0) and not teg:GetFirst():IsDisabled() and Duel.SelectYesNo(tp,94) then
		e:SetCategory(CATEGORY_DISABLE)
		c1020047.distg(e,tp,teg,tep,tev,tre,tr,trp,1)
		e:SetOperation(c1020047.disop)
	else
		e:SetCategory(0)
		e:SetOperation(nil)
	end
end
function c1020047.pierceop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCode(EFFECT_PIERCE)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x4B0))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c1020047.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst()
	if chk==0 then return eg:GetCount()==1 and tc:GetSummonPlayer()~=tp and e:GetHandler():GetFlagEffect(1020044)==0 end
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,tc,1,0,0)
	e:GetHandler():RegisterFlagEffect(1020044,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c1020047.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
	end
end
