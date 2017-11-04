--Lyrica (Basic)
local ref=_G['c'..18917005]
function ref.initial_effect(c)
	--Summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(ref.sstg)
	e1:SetOperation(ref.ssop)
	c:RegisterEffect(e1)
	--Material Grant
	if not ref.global_check then
		ref.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(ref.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end

function ref.rtfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:GetLevel()<=4 --not c:IsForbidden()
		and Duel.IsExistingMatchingCard(ref.ssfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,c:GetAttribute())
end
function ref.ssfilter(c,e,tp,att)
	return c:IsType(TYPE_MONSTER) and c:GetLevel()<=4
		and not c:IsAttribute(att)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function ref.sstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(ref.rtfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,ref.rtfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectTarget(tp,ref.ssfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,g:GetFirst():GetAttribute())
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,tp,LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g2,1,tp,LOCATION_GRAVE)
end
function ref.ssop(e,tp,eg,ep,ev,re,r,rp)
	local ex,g1=Duel.GetOperationInfo(0,CATEGORY_TOGRAVE)
	local ex,g2=Duel.GetOperationInfo(0,CATEGORY_SPECIAL_SUMMON)
	g1=g1:Filter(Card.IsRelateToEffect,nil,e)
	g2=g2:Filter(Card.IsRelateToEffect,nil,e)
	if g1:GetCount()>0 and Duel.SendtoGrave(g1,REASON_RETURN) and g2:GetCount()>0 and (Duel.GetLocationCount(tp,LOCATION_MZONE)>0) then
		Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP)
	end
end

function ref.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc.transform and tc:GetFlagEffect(18917005)==0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetCategory(CATEGORY_ATKCHANGE)
			e1:SetDescription(aux.Stringid(18917005,1))
			e1:SetType(EFFECT_TYPE_QUICK_O)
			e1:SetCode(EVENT_FREE_CHAIN)
			e1:SetRange(LOCATION_MZONE)
			e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
			e1:SetHintTiming(TIMING_DAMAGE_STEP)
			e1:SetCondition(ref.atkcon)
			e1:SetCost(ref.atkcost)
			e1:SetOperation(ref.atkop)
			tc:RegisterEffect(e1,true)
			tc:RegisterFlagEffect(18917005,0,0,1)
		end
		tc=eg:GetNext()
	end
end
function ref.atkcon(e,tp,eg,ep,ev,re,r,rp)
	if not (e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,18917005)) then return false end
	local phase=Duel.GetCurrentPhase()
	if phase~=PHASE_DAMAGE or Duel.IsDamageCalculated() then return false end
	if not Duel.GetAttackTarget() then return false end
	local c=e:GetHandler()
	return c and c:IsRelateToBattle()
end
function ref.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function ref.atkop(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not a:IsRelateToBattle() or a:IsFacedown() or not d:IsRelateToBattle() or d:IsFacedown() then return end
	if a:GetControler()~=tp then a,d=d,a end
	if a:IsImmuneToEffect(e) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetOwnerPlayer(tp)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE_CAL)
	e1:SetValue(d:GetAttack()+100)
	a:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
	a:RegisterEffect(e2)
end