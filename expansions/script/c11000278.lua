--Arcade Sona
function c11000278.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c11000278.efilter)
	e2:SetValue(500)
	c:RegisterEffect(e2)
	--def up
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SPSUMMON_PROC)
	e4:SetProperty(EFFECT_FLAG_SPSUM_PARAM)
	e4:SetRange(LOCATION_HAND)
	e4:SetTargetRange(POS_FACEUP_DEFENSE,0)
	e4:SetCondition(c11000278.hspcon)
	c:RegisterEffect(e4)
	--coin
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(11000277,0))
	e5:SetCategory(CATEGORY_COIN)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetTarget(c11000278.cointg)
	e5:SetOperation(c11000278.coinop)
	c:RegisterEffect(e5)
	--coin second toss
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetRange(LOCATION_PZONE)
	e6:SetCode(EVENT_TOSS_COIN_NEGATE)
	e6:SetCondition(c11000278.scoincon)
	e6:SetOperation(c11000278.scoinop)
	c:RegisterEffect(e6)
end
function c11000278.efilter(e,c)
	return c:IsSetCard(0x201) and c:IsType(TYPE_MONSTER)
end
function c11000278.spfilter(c)
	return c:IsFaceup() and c:IsCode(11000273)
end
function c11000278.hspcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c11000278.spfilter,c:GetControler(),LOCATION_ONFIELD,0,1,nil)
end
function c11000278.scoincon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and Duel.GetFlagEffect(tp,11000278)==0
end
function c11000278.scoinop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,11000278)~=0 then return end
	if Duel.SelectYesNo(tp,aux.Stringid(11000278,0)) then
		Duel.Hint(HINT_CARD,0,11000278)
		Duel.RegisterFlagEffect(tp,11000278,RESET_PHASE+PHASE_END,0,1)
		Duel.TossCoin(tp,ev)
	end
end
function c11000278.cointg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c11000278.coinop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local res=0
	if c:IsHasEffect(11000273) then
		res=1-Duel.SelectOption(tp,60,61)
	else res=Duel.TossCoin(tp,1) end
	c11000278.arcanareg(c,res)
end
function c11000278.arcanareg(c,coin)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c11000278.atkcon)
	e1:SetValue(1000)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e1)
	--defup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c11000278.defcon)
	e2:SetValue(1000)
	e2:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e2)
	c:RegisterFlagEffect(36690018,RESET_EVENT+0x1ff0000,EFFECT_FLAG_CLIENT_HINT,1,coin,63-coin)
end
function c11000278.atkcon(e)
	return e:GetHandler():GetFlagEffectLabel(36690018)==1
end
function c11000278.defcon(e)
	return e:GetHandler():GetFlagEffectLabel(36690018)==0
end
