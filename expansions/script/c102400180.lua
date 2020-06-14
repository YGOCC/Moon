--created & coded by Lyris, art by Bloo-DKai12 of DeviantArt
--フェイツ・デスガイ
local cid,id=GetID()
function cid.initial_effect(c)
	c:EnableReviveLimit()
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(cid.tg)
	e2:SetOperation(cid.activate)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(function(e,tp) return not Duel.IsExistingMatchingCard(cid.cfilter,tp,LOCATION_MZONE,0,1,nil) end)
	e3:SetCountLimit(1,id)
	e3:SetCost(cid.cost)
	c:RegisterEffect(e3)
end
function cid.cfilter(c)
	return c:GetSequence()<5
end
function cid.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function cid.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(cid.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,Duel.SelectTarget(tp,cid.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp),1,tp,LOCATION_GRAVE)
end
function cid.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP) end
end
function cid.filter(c,e,tp)
	return c:IsSetCard(0xf7a) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) and not c:IsCode(id)
end
