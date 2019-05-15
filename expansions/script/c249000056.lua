--Xyz-Magician Level Master
function c249000056.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c249000056.spcon)
	c:RegisterEffect(e1)
	--level change
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9583383,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c249000056.lvcost)
	e2:SetOperation(c249000056.lvop)
	c:RegisterEffect(e2)
end
function c249000056.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x2073) and c:GetCode()~=249000056
end
function c249000056.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c249000056.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c249000056.rfilter(c,tp)
	local lv=c:GetLevel()
	return lv>0 and c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c249000056.tfilter,tp,LOCATION_MZONE,0,1,nil,lv)
end
function c249000056.tfilter(c,clv)
	local lv=c:GetLevel()
	return lv>0 and lv~=clv and c:IsFaceup() and c:IsSetCard(0x2073)
end
function c249000056.lvcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000056.rfilter,tp,LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c249000056.rfilter,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	local lv=g:GetFirst():GetLevel()
	Duel.SetTargetParam(lv)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c249000056.filter2(c)
	return c:IsFaceup() and c:IsSetCard(0x2073)
end
function c249000056.lvop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c249000056.filter2,tp,LOCATION_MZONE,0,nil)
	local lv=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_EXTRA_TOMAIN_KOISHI)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_EXTRA,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_XYZ))
	Duel.RegisterEffect(e2,tp)
end
