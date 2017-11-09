--Bushido God Griffin
function c1020055.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c1020055.matfilter,2,2)
	--cannot be target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c1020055.unval)
	c:RegisterEffect(e1)
	--extra summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c1020055.sumcon)
	e2:SetOperation(c1020055.sumop)
	c:RegisterEffect(e2)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(48964966,1))
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e3:SetTarget(c1020055.rectg)
	e3:SetOperation(c1020055.recop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
	if not c1020055.global_check then
		c1020055.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetOperation(c1020055.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c1020055.matfilter(c,lc,sumtype,tp)
	return c:GetFlagEffect(1020055)>0 and c:IsSetCard(0x4B0)
end
function c1020055.unval(e,re)
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsControler(1-e:GetHandlerPlayer()) and re:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL)
		and re:GetHandler():IsLocation(LOCATION_MZONE)
end
function c1020055.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		tc:RegisterFlagEffect(1020055,RESET_EVENT+RESETS_STANDARD,0,0)
		tc=eg:GetNext()
	end
end
function c1020055.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c1020055.sumop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,1020055)~=0 then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x4B0))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,1020055,RESET_PHASE+PHASE_END,0,1)
end
function c1020055.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x4B0)
end
function c1020055.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(c1020055.filter,nil)
	if chk==0 then return g:GetCount()==1 end
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,1-tp,0)
end
function c1020055.recop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c1020055.filter,nil)
	local tc=g:GetFirst()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local lv=tc:GetOriginalLevel()>0 and tc:GetOriginalLevel() or tc:GetOriginalRank()
		Duel.Recover(tp,lv*200,REASON_EFFECT)
	end
end
