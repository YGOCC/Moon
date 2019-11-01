--created & coded by Lyris, art
--フェイツ・カオス・ゴッデス
local cid,id=GetID()
function cid.initial_effect(c)
	c:EnableReviveLimit()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_TOGRAVE)
	e2:SetTarget(cid.target)
	e2:SetOperation(cid.activate)
	c:RegisterEffect(e2)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC_G)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(aux.PandSSetCon(c,0))
	e1:SetOperation(cid.ssetop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND+LOCATION_EXTRA+LOCATION_OVERLAY+LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e2:SetOperation(function(e)
		local c=e:GetHandler()
		if c:GetOriginalType()==TYPE_TRAP then
			c:AddMonsterAttribute(TYPE_MONSTER+TYPE_RITUAL+TYPE_EFFECT)
			c:SetCardData(CARDDATA_TYPE,TYPE_MONSTER+TYPE_RITUAL+TYPE_EFFECT)
		end
	end)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetRange(0)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCode(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	c:RegisterEffect(e3)
end
function cid.ssetop(e,tp,eg,ep,ev,re,r,rp,c)
	c:SetCardData(CARDDATA_TYPE,TYPE_TRAP)
	Duel.SSet(c:GetControler(),c)
end
function cid.filter1(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToRemove()
end
function cid.filter2(c)
	return c:IsFaceup() and c:IsSetCard(0xf7a)
end
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(cid.filter1,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	local g2=Duel.GetMatchingGroup(cid.filter2,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	if chk==0 then return #g1>0 and #g2>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,g1:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g2,g2:GetCount(),0,0)
end
function cid.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(cid.filter1,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	local g2=Duel.GetMatchingGroup(cid.filter2,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	if Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)>0 then
		Duel.SendtoGrave(g2,REASON_EFFECT+REASON_RETURN)
	end
end