-- Homura, Aegis' Blade

function c50000056.initial_effect(c)
	c:EnableReviveLimit()
	c:SetUniqueOnField(1,0,50000056)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(50000056,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c50000056.spcon)
	e1:SetValue(c50000056.spval)
	c:RegisterEffect(e1)
	--swap2
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(50000056,1))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c50000056.adcon2)
	e3:SetTarget(c50000056.adtg2)
	e3:SetOperation(c50000056.adop2)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(50000056,3))
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e4:SetCondition(c50000056.descon)
	e4:SetTarget(c50000056.destg)
	e4:SetOperation(c50000056.desop)
	c:RegisterEffect(e4)
end

function c50000056.filter2(c)
	return c:IsType(TYPE_LINK) and c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsFaceup()
end
function c50000056.getzone(tp)
	local zone = 0
	local g = Duel.GetMatchingGroup(c50000056.filter2,tp,LOCATION_MZONE,0,nil)
	for tc in aux.Next(g) do
		zone = zone | tc:GetLinkedZone()
	end
	return zone&0x1f
end
function c50000056.spcon(e,c)
	if c==nil then return true end
	local tp=e:GetHandlerPlayer()
	local zone=c50000056.getzone(tp)
	return zone~=0
end
function c50000056.spval(e,c)
	local tp=e:GetHandlerPlayer()
	local zone=c50000056.getzone(tp)
	return 0,zone
end

function c50000056.adcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE) and Duel.GetCurrentChain()==0
end
function c50000056.adtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(2000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,2000)
end
function c50000056.adop2(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end

function c50000056.descon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and e:GetHandler():IsReason(REASON_EFFECT) and e:GetHandler():IsPreviousPosition(POS_FACEUP) and not e:GetHandler():IsLocation(LOCATION_DECK)
end
function c50000056.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c50000056.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		if Duel.Destroy(tc,REASON_EFFECT)~=0 then
			Duel.Damage(1-tp,500,REASON_EFFECT)
		end
	end
end
