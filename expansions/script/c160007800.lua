--Paintress Cesano
--XGlitchy30 was here
function c160007800.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c160007800.spcon)
	e1:SetOperation(c160007800.spop)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--apply spsummon proc
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c160007800.proccon)
	e2:SetOperation(c160007800.proc)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
 --extra summon
	   local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SET_SUMMON_COUNT_LIMIT)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c160007800.target)
	e3:SetTargetRange(1,0)
	e3:SetValue(2)
	c:RegisterEffect(e3)
end
--filters
function c160007800.spfilter(c)
	return (c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_EFFECT)) or (c:IsFaceup() and c:IsSetCard(0xc50)) and c:IsAbleToRemoveAsCost()
end
--special summon
function c160007800.spcon(e,c)
	  if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c160007800.spfilter,tp,LOCATION_EXTRA+LOCATION_HAND,0,1,nil)
end
function c160007800.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c160007800.spfilter,tp,LOCATION_EXTRA+LOCATION_HAND,0,1,1,nil)
	if Duel.Remove(g,POS_FACEUP,REASON_COST)~=0 then
		local tc=Duel.GetOperatedGroup():GetFirst()
		e:SetLabelObject(tc)
	end
end
--apply spsummon proc
function c160007800.proccon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function c160007800.proc(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject():GetLabelObject()
	local code=tc:GetOriginalCode()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetValue(tc:GetOriginalLevel())
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CHANGE_CODE)
	e2:SetValue(code)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e2)
	c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD,1)
end
function c160007800.target(e,c)
	return c:IsType(TYPE_DUAL) or c:IsType(TYPE_NORMAL)
end
