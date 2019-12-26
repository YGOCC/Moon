--Chaos-Eyes Duality Dragon
--Ｃ眼の陰陽竜
--「カオスアイズ・デュアリティドラゴン」
local s,id=GetID()
function s.initial_effect(c)
	--Contact Summon
	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,true,true,89631139,74677422,5405694)
	aux.AddContactFusion(c,s.contactfil,s.contactop,s.splimit)
	--Cannot be Targeted by opponent's effects
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	--Cannot be Destroyed by Effects
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(s.indval)
	c:RegisterEffect(e2)
	--Force to Attack-Position
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SET_POSITION)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e3)
	local e4=e3.Clone()
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=e4.Clone()
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e6=e4.Clone()
	e6:SetCode(EVENT_MSET)
	c:RegisterEffect(e5)
	--Must Attack this Card
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_MUST_ATTACK)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTargetRange(0,LOCATION_MZONE)
	c:RegisterEffect(e6)
	local e8=e7:Clone()
	e8:SetCode(EFFECT_MUST_ATTACK_MONSTER)
	c:RegisterEffect(e8)
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_MUST_BE_ATTACKED)
	e9:SetValue(1)
	c:RegisterEffect(e9)
	--Increase ATK and DEF
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(900881123,0))
	e10:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e10:SetType(EFFECT_TYPE_IGNITION)
	e10:SetRange(LOCATION_MZONE)
	e10:SetCountLimit(1)
	e10:SetCost(s.atkcost)
	e10:SetOperation(s.atkop)
	c:RegisterEffect(e10)
end
function s.indval(e,re,tp)
	return tp~=e:GetHandlerPlayer()
end
function s.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function s.contactfil(tp)
	return Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,LOCATION_ONFIELD,0,nil)
end
function s.contactop(g)
	Duel.Remove(g,POS_FACEUP,REASON_COST+REASON_MATERIAL)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,eg,eg:GetCount(),0,0)
end
function s.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2000) end
	Duel.PayLPCost(tp,2000)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e2)
	end
end