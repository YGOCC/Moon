--Naga Myrmidon
function c11000429.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c11000429.spcon)
	e1:SetOperation(c11000429.spop)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11000429,0))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c11000429.damtg)
	e2:SetOperation(c11000429.damop)
	c:RegisterEffect(e2)
	--Can't attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,0x1c0)
	e3:SetCountLimit(1)
	e3:SetCondition(c11000429.indcon)
	e3:SetTarget(c11000429.target)
	e3:SetOperation(c11000429.activate)
	c:RegisterEffect(e3)
end
function c11000429.spcon(e,c)
	if c==nil then return  end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-2
		and Duel.CheckReleaseGroup(c:GetControler(),Card.IsSetCard,2,nil,0x204)
end
function c11000429.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(tp,Card.IsSetCard,2,2,nil,0x204)
	Duel.Release(g,REASON_COST)
end
function c11000429.damfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x204) and not c:IsSetCard(0x1204)
end
function c11000429.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c11000429.damfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	local ct=Duel.GetMatchingGroupCount(c11000429.damfilter,tp,LOCATION_GRAVE,0,nil)
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*100)
end
function c11000429.damop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local ct=Duel.GetMatchingGroupCount(c11000429.damfilter,tp,LOCATION_GRAVE,0,nil)
	Duel.Damage(p,ct*100,REASON_EFFECT)
end
function c11000429.indcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c11000429.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c11000429.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c78474168.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c11000429.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c11000429.filter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c11000429.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(1-tp) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(11000429,0))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end