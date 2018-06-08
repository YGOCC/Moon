--オッドアイズ・フュージョン
function c1020033.initial_effect(c)
	aux.AddLinkProcedure(c,c1020033.lkfil,4,4)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c1020033.lklimit)
	c:RegisterEffect(e1)
	--Change
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetCost(c1020033.atkcost)
	e3:SetTarget(c1020033.atktg)
	e3:SetOperation(c1020033.atkop)
	c:RegisterEffect(e3)
end
function c1020033.lkfil(c)
	return c:IsSetCard(0x1ded)
end
function c1020033.lklimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end
function c1020033.filter1(c,tc)
	return c:IsFaceup() and c:IsSetCard(0xded) and bit.band(c:GetType(),tc:GetType())~=tc:GetType()
end
function c1020033.filter2(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_PENDULUM) and c:IsAbleToGraveAsCost()
		and Duel.IsExistingTarget(c1020033.filter1,tp,LOCATION_MZONE,0,1,e:GetHandler(),c) and c:IsSetCard(0xded)
end
function c1020033.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1020033.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	local g=Duel.SelectMatchingCard(tp,filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabelObject(g:GetFirst())
end
function c1020033.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c1020033.filter1,tp,LOCATION_MZONE,0,1,1,e:GetHandler(),e:GetLabelObject())
end
function c1020033.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local g1=e:GetLabelObject()
	if tc:IsRelateToEffect(e) and bit.band(g1:GetType(),tc:GetType())~=g1:GetType() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_REMOVE_TYPE)
		e1:SetValue(tc:GetType())
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(g1:GetType())
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2,true)
	end
end
