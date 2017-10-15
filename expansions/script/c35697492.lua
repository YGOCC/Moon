--Euphie, Princess of Eternal Flames
function c35697492.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xf160),c35697492.ffilter,true)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(35697492,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetCondition(c35697492.rmcon)
	e1:SetTarget(c35697492.rmtg)
	e1:SetOperation(c35697492.rmop)
	c:RegisterEffect(e1)
end
c35697492.material_setcode=0xf160
function c35697492.ffilter(c)
	return c:IsFusionAttribute(ATTRIBUTE_FIRE)
end
function c35697492.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c35697492.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c35697492.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_GRAVE) and c35697492.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c35697492.filter,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c35697492.filter,tp,0,LOCATION_GRAVE,1,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c35697492.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
end