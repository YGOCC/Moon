--Unlocking Key of Creation
function c249000846.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,249000846)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetTarget(c249000846.condition)
	e1:SetOperation(c249000846.operation)
	c:RegisterEffect(e1)
end
function c249000846.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1F6)
end
function c249000846.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c249000846.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c249000846.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	ac=Duel.AnnounceCardFilter(tp,TYPE_SYNCHRO,OPCODE_ISTYPE,TYPE_XYZ,OPCODE_ISTYPE,OPCODE_OR)
	sc=Duel.CreateToken(tp,ac)
	Duel.SendtoDeck(sc,nil,0,REASON_RULE)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetLabel(ac)
	e1:SetTarget(c249000846.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c249000846.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return (not se:GetHandler():IsSetCard(0x1F6)) and c:IsCode(e:GetLabel())
end