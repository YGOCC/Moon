--Digimon Aquan GigaSeadramon
function c47000165.initial_effect(c)
c:EnableReviveLimit()
--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c47000165.splimit)
	c:RegisterEffect(e1)
--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA+LOCATION_GRAVE)
	e2:SetCondition(c47000165.sprcon)
	e2:SetOperation(c47000165.sprop)
	c:RegisterEffect(e2)
--name change
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_CHANGE_CODE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(22702055)
	c:RegisterEffect(e3)
--pierce
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e4)
--actlimit
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCode(EFFECT_CANNOT_ACTIVATE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(0,1)
	e5:SetValue(c47000165.aclimit)
	e5:SetCondition(c47000165.actcon)
	c:RegisterEffect(e5)
--attackall
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_ATTACK_ALL)
	e6:SetValue(1)
	c:RegisterEffect(e6)
--atkup
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(47000165,0))
	e7:SetCategory(CATEGORY_ATKCHANGE)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e7:SetCode(EVENT_BATTLE_DESTROYING)
	e7:SetLabel(500)
	e7:SetCondition(c47000165.atkcon)
	e7:SetOperation(c47000165.operation2)
	c:RegisterEffect(e7)
end
function c47000165.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c47000165.spfilter1(c,tp)
	return c:IsFaceup() and c:IsCode(47000162) and Duel.IsExistingMatchingCard(c47000165.spfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c)
end
function c47000165.spfilter2(c)
	return c:IsSetCard(0x2FBA) and c:IsType(TYPE_SPELL+TYPE_MONSTER)
end
function c47000165.sprcon(e,c)
	if c==nil then return true end 
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(c47000165.spfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,tp)
end
function c47000165.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(47000165,0))
	local g1=Duel.SelectMatchingCard(tp,c47000165.spfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(47000165,1))
	local g2=Duel.SelectMatchingCard(tp,c47000165.spfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,10,g1:GetFirst())
	g1:Merge(g2)
	local tc=g1:GetFirst()
	while tc do
		if not tc:IsFaceup() then Duel.ConfirmCards(1-tp,tc) end
		tc=g1:GetNext()
	end
	Duel.Release(g1,REASON_COST+REASON_FUSION+REASON_MATERIAL)
	--atk mod
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetReset(RESET_EVENT+0xff0000)
	e1:SetValue(g1:GetCount()*500)
	c:RegisterEffect(e1)
	--def mod
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	e2:SetReset(RESET_EVENT+0xff0000)
	e2:SetValue(g1:GetCount()*500)
	c:RegisterEffect(e2)
end
function c47000165.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c47000165.actcon(e)
	return Duel.GetAttacker()==e:GetHandler()
end
function c47000165.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
	end
end
function c47000165.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsFaceup() and c:IsRelateToBattle()
		and bc:IsLocation(LOCATION_GRAVE) and bc:IsReason(REASON_BATTLE) and bc:IsType(TYPE_MONSTER)
end