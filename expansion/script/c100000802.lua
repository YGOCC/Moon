--魔轟神ヴァルキュルス
function c100000802.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x109),aux.NonTuner(Card.IsSetCard,0x109),1)
	c:EnableReviveLimit()
	--cannot be target/battle indestructable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c100000802.target)
	e1:SetValue(1)
	c:RegisterEffect(e1)
		--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c100000802.val)
	c:RegisterEffect(e3)
			--defup
	local e9=e3:Clone()
	e9:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e9)
end
function c100000802.filt(c)
	return c:IsSetCard(0x109) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c100000802.val(e,c)
	return Duel.GetMatchingGroupCount(c100000802.filt,c:GetControler(),LOCATION_GRAVE,0,nil)*100
end
function c100000802.target(e,c)
	return c~=e:GetHandler() and c:IsSetCard(0x109) and c:IsType(TYPE_MONSTER)
end