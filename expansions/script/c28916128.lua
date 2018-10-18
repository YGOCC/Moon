--FIRE Fusion
--Design and Code by Kinny
local ref=_G['c'..28916128]
local id=28916128
function ref.initial_effect(c)
	--Material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsSetCard,1854),aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_FIRE),true)
	--On-Fusion
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id)
	e1:SetCondition(ref.sscon1)
	e1:SetTarget(ref.destg)
	e1:SetOperation(ref.desop)
	c:RegisterEffect(e1)
	--On-Material
	local e2=e1:Clone()
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(ref.sscon2)
	c:RegisterEffect(e2)
	--Limit
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(ref.ctop)
	c:RegisterEffect(e3)
	--[[Duel.AddCustomActivityCounter(id,ACTIVITY_SPSUMMON,ref.counterfilter)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetTargetRange(0,1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(ref.splimit)
	c:RegisterEffect(e3)]]
end

--Remove
function ref.sscon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function ref.sscon2(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_FUSION
end
function ref.desfilter(c,tp)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,c)
end
function ref.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsLocation(LOCATION_MZONE) and ref.desfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(ref.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectMatchingCard(tp,ref.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g2=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,g1:GetFirst())
	local g3=Group.CreateGroup()
	g3:Merge(g1)
	g3:Merge(g2)
	Duel.SetTargetCard(g3)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,g2,1,0,0)
end
function ref.desop(e,tp,eg,ep,ev,re,r,rp)
	--local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local ex,desg=Duel.GetOperationInfo(0,CATEGORY_DESTROY)
	local ex,atkg=Duel.GetOperationInfo(0,CATEGORY_ATKCHANGE)
	desg=desg:Filter(Card.IsRelateToEffect,nil,e)
	atkg=atkg:Filter(Card.IsRelateToEffect,nil,e)
	--tg:Sub(desg)
	--desg=desg:Filter(Card.IsRelateToEffect,nil,e)
	if atkg:GetCount()>0 and desg:GetCount()>0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(desg:GetFirst():GetAttack()/2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		atkg:GetFirst():RegisterEffect(e1)
	end
	if desg:GetCount()>0 then
		Duel.Destroy(desg,REASON_EFFECT)
	end
end

--Limit
function ref.ctfilter(c,tp)
	return c:GetSummonPlayer()==tp and c:IsAttackPos()
end
function ref.ctop(e,tp,eg,ep,ev,re,r,rp)
	if eg:FilterCount(ref.ctfilter,nil,1-tp)>0 then
		local c=e:GetHandler()
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e3:SetTargetRange(0,1)
		e3:SetRange(LOCATION_MZONE)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e3:SetTarget(ref.splimit)
		c:RegisterEffect(e3)
	end
end

function ref.counterfilter(c)
	return not c:IsPosition(POS_FACEUP_ATTACK)
end
function ref.spcon(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message(Duel.GetCustomActivityCount(id,1-tp,ACTIVITY_SPSUMMON)~=0)
	return Duel.GetCustomActivityCount(id,1-tp,ACTIVITY_SPSUMMON)~=0
end
function ref.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	--Debug.Message(Duel.GetCustomActivityCount(id,sump,ACTIVITY_SPSUMMON)~=0)
	--Debug.Message(sumpos==POS_FACEUP_ATTACK)
	--Debug.Message(e:GetHandler():GetControler())
	return (sumpos==POS_FACEUP_ATTACK)
end
