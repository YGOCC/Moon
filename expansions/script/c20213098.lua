--created by Meedogh, coded by Lyris
local cid,id=GetID()
function cid.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_BIGBANG))
	e1:SetValue(function(e) return 200+Duel.GetMatchingGroupCount(cid.afilter,e:GetHandlerPlayer(),LOCATION_SZONE,LOCATION_SZONE,nil)*200 end)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetCost(cid.cost)
	e3:SetTarget(cid.eqtg)
	e3:SetOperation(cid.eqop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_TO_GRAVE_REDIRECT_CB)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetCondition(cid.repcon)
	e4:SetOperation(cid.repop)
	c:RegisterEffect(e4)
end
function cid.afilter(c)
	return c:GetOriginalType()&TYPE_MONSTER~=0 or aux.GetOriginalPandemoniumType(c)~=nil
end
function cid.filter(c,tp)
	return not c:IsType(TYPE_BIGBANG) or Duel.IsExistingMatchingCard(cid.cfilter,tp,LOCATION_MZONE,0,1,c,tp)
end
function cid.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return Duel.CheckReleaseGroup(tp,cid.filter,1,nil,tp) end
	Duel.Release(Duel.SelectReleaseGroup(tp,cid.filter,1,1,nil,tp),REASON_COST)
end
function cid.cfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_BIGBANG)
		and Duel.IsExistingMatchingCard(cid.eqfilter,tp,LOCATION_DECK,0,1,nil,tp)
end
function cid.eqfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function cid.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local res=e:GetLabel()==1
	if chk==0 then
		e:SetLabel(0)
		return Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 and (res
			or Duel.IsExistingMatchingCard(cid.cfilter,tp,LOCATION_MZONE,0,1,nil,tp))
	end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK)
end
function cid.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,cid.eqfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local tg=Duel.SelectMatchingCard(tp,cid.cfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
		local sc=tg:GetFirst()
		if not sc or not Duel.Equip(tp,tc,sc) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetLabelObject(tc)
		e1:SetValue(cid.eqlimit)
		sc:RegisterEffect(e1)
	end
end
function cid.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function cid.repfilter(c,tp)
	return c:IsReason(REASON_DESTROY) and Duel.IsExistingMatchingCard(aux.AND(Card.IsFaceup,Card.IsType),tp,LOCATION_MZONE,0,1,c,TYPE_BIGBANG)
end
function cid.repcon(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cid.repfilter,nil,tp)
	return #g>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>#g-1
end
function cid.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=eg:Filter(cid.repfilter,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local qg=Duel.SelectMatchingCard(tp,aux.AND(Card.IsFaceup,Card.IsType),tp,LOCATION_MZONE,0,1,1,g)
	local gc=qg:GetFirst()
	for tc in aux.Next(g) do
		if Duel.Equip(tp,tc,gc,true) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(cid.eqlimit)
			e1:SetLabelObject(gc)
			tc:RegisterEffect(e1)
		end
	end
end
function cid.eqlimit(e,c)
	return c==e:GetLabelObject()
end
