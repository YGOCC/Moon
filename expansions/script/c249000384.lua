--Elven Mage Paladin - Sapphira
function c249000384.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,2490003832)
	e1:SetCondition(c249000384.spcon)
	e1:SetOperation(c249000384.spop)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12510878,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetCondition(c249000384.condition)
	e2:SetTarget(c249000384.target)
	e2:SetOperation(c249000384.operation)
	c:RegisterEffect(e2)
	--copy spell
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,2490003832)
	e3:SetCost(c249000384.cost)
	e3:SetTarget(c249000384.target2)
	e3:SetOperation(c249000384.operation2)
	c:RegisterEffect(e3)
end
c249000384.declared_table_count=1
c249000384.declared_table={
-1,
}
function c249000384.spcon(e,c)
	if c==nil then return true end
	return Duel.CheckReleaseGroup(c:GetControler(),Card.IsSetCard,1,nil,0x1B7)
end
function c249000384.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(c:GetControler(),Card.IsSetCard,1,1,nil,0x1B7)
	Duel.Release(g,REASON_COST)
end
function c249000384.rmfilter(c)
	return c:IsSetCard(0x1B7) and c:IsAbleToRemoveAsCost() and ((not c:IsLocation(LOCATION_EXTRA)) or (c:IsFaceup() and c:IsLocation(LOCATION_EXTRA)))
end
function c249000384.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c249000384.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c249000384.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c249000384.rmfilter(c)
	return c:IsSetCard(0x1B7) and c:IsAbleToRemoveAsCost() and ((not c:IsLocation(LOCATION_EXTRA)) or (c:IsFaceup() and c:IsLocation(LOCATION_EXTRA)))
end
function c249000384.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000383.rmfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil) end
	local sg=Duel.SelectMatchingCard(tp,c249000384.rmfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function c249000384.nottablematch(id)
	for i=1,c249000384.declared_table_count do
		if c249000384.declared_table[i]==id then return false end
	end
	return true
end
function c249000384.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanSpecialSummon(tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac=Duel.AnnounceCardFilter(tp,2,OPCODE_ISTYPE,65538,OPCODE_ISTYPE,OPCODE_OR)
	local token=Duel.CreateToken(tp,ac)
	while not (c249000384.nottablematch(ac) and	token:CheckActivateEffect(true,true,true) and bit.band(token:GetActivateEffect():GetCategory(),CATEGORY_SPECIAL_SUMMON)~=0)
	do
		ac=Duel.AnnounceCardFilter(tp,2,OPCODE_ISTYPE,65538,OPCODE_ISTYPE,OPCODE_OR)
		token=Duel.CreateToken(tp,ac)
	end
	c249000384.declared_table[c249000384.declared_table_count+1]=ac
	c249000384.declared_table_count=c249000384.declared_table_count+1
	e:SetLabel(ac)
end
function c249000384.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.CreateToken(tp,e:GetLabel())
	if not tc then return end
	local tpe=tc:GetType()
	local te=tc:GetActivateEffect()
	local tg=te:GetTarget()
	local op=te:GetOperation()
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	Duel.ClearTargetCard()
	if tg then
		if tc:IsSetCard(0x95) then
			tg(e,tp,eg,ep,ev,re,r,rp,1)
		else
			tg(te,tp,eg,ep,ev,re,r,rp,1)
		end
	end
	Duel.BreakEffect()
	if op then 
		if tc:IsSetCard(0x95) then
			op(e,tp,eg,ep,ev,re,r,rp)
		else
			op(te,tp,eg,ep,ev,re,r,rp)
		end
	end
end
