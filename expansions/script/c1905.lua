--Deepwood Elder Weedman
local voc=c1905
function c1905.initial_effect(c)
	--increase
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(voc.atkval)
	c:RegisterEffect(e1)
	--send to grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1905,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCategory(CATEGORY_TODECK)
	--e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(voc.limtg)
	e3:SetOperation(voc.sop)
	c:RegisterEffect(e3)
end
function voc.limtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetChainLimit(aux.FALSE)
end
function voc.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x5AA) and c:IsType(TYPE_MONSTER) 
end
function voc.atkval(e,c)
	return Duel.GetMatchingGroupCount(voc.filter,c:GetControler(),0,LOCATION_MZONE,e:GetHandler())*1000
end
function voc.sop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SendtoGrave(g,REASON_EFFECT)
	Duel.SetChainLimit(aux.FALSE)
end
