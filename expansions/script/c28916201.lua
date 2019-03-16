--This file was automatically coded by Kinny's Numeron Code~!
local ref=_G['c'..28916201]
local id=28916201
function ref.initial_effect(c)
	--Effect 0
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCountLimit(1,28916201)
	e0:SetTarget(ref.target0)
	e0:SetOperation(ref.operation0)
	c:RegisterEffect(e0)
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_NO_TURN_RESET)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	e1:SetTarget(ref.target1)
	e1:SetOperation(ref.operation1)
	c:RegisterEffect(e1)
end
function ref.ToDeck(c)
	return c:IsAbleToDeck()
end
function ref.ToGY(c)
	return c:IsAbleToGrave() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
--Effect 0
function ref.target0(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanSpecialSummonMonster(tp,28916212,0,TYPES_TOKEN,0,0,1,RACE_WINDBEAST,ATTRIBUTE_WIND,POS_FACEUP_DEFENSE) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function ref.operation0(e,tp,eg,ep,ev,re,r,rp)
	local token=Duel.CreateToken(tp,28916212)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP_DEFENCE)
end
--Effect 1
function ref.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(ref.ToGY,tp,LOCATION_ONFIELD,0,1,c) end
	if chkc then return ref.ToGY(chkc) and c:IsLocation(LOCATION_ONFIELD) and c:IsControler(tp) and not chkc==c end
	local g0 = Duel.SelectTarget(tp,ref.ToGY,tp,LOCATION_ONFIELD,0,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g0,g0:GetFirst():GetControler(),g0:GetCount(),g0:GetFirst():GetLocation())
	Duel.SetOperationInfo(0,CATEGORY_DRAW,c,1,tp,0)
	c:RegisterFlagEffect(0,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,0))
end
function ref.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g0=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if Duel.Release(g0,REASON_EFFECT)~=0 then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
