--created & coded by Lyris
--S・VINEの零天使ラグナクライッシャ
function c210400027.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddSpatialProc(c,4,true,c210400027.material,c210400027.material)
	local ae3=Effect.CreateEffect(c)
	ae3:SetCategory(CATEGORY_REMOVE)
	ae3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	ae3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	ae3:SetCode(EVENT_TO_GRAVE)
	ae3:SetRange(LOCATION_MZONE)
	ae3:SetCondition(c210400027.condition)
	ae3:SetTarget(c210400027.target)
	ae3:SetOperation(c210400027.operation)
	c:RegisterEffect(ae3)
end
function c210400027.material(mc)
	return mc:IsAttribute(ATTRIBUTE_WATER) and mc:IsSetCard(0x785e)
end
function c210400027.cfilter(c)
	return c:IsLevelAbove(1) and c:IsSetCard(0x785e)
end
function c210400027.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return eg:FilterCount(Card.IsType,nil,TYPE_MONSTER)==1 and c210400027.cfilter(tc)
end
function c210400027.filter2(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x785e) and c:IsAbleToRemove()
end
function c210400027.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c210400027.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c210400027.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c210400027.filter2,tp,LOCATION_DECK,0,1,eg:GetFirst():GetLevel(),nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
