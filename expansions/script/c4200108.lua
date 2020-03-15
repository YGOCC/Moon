local cid,id=GetID()
function cid.initial_effect(c)
c:SetSPSummonOnce(id)
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,cid.mfilter,cid.xyzcheck,2,2)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_ATTRIBUTE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_ADD_RACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(RACE_WARRIOR)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCondition(cid.stcon)
	e3:SetTarget(cid.sttg)
	e3:SetOperation(cid.stop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCost(cid.drcost)
	e4:SetTarget(cid.drtg)
	e4:SetOperation(cid.drop)
	c:RegisterEffect(e4)
end
function cid.mfilter(c,xyzc)
	return c:GetLevel()==4 
end
function cid.xyzcheck(g)
	local sg=g:Filter(function(c) return c:GetLevel()==4 end,nil)
	return sg:GetClassCount(Card.GetRace)>=2 or sg:GetClassCount(Card.GetAttribute)>=2
end
function cid.sparkfilter(c)
return c:IsCode(id-8)
end
function cid.filter(c,e,tp)
	if c:IsType(TYPE_MONSTER) then
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	else
		local ct=Duel.GetLocationCount(tp,LOCATION_SZONE)
		if e:IsHasType(EFFECT_TYPE_ACTIVATE) and not e:GetHandler():IsLocation(LOCATION_SZONE) then ct=ct-1 end
		return c:IsSSetable(true) and (c:IsType(TYPE_FIELD) or ct>0)
	end
end
function cid.stcon(e,c)
	return Duel.IsExistingMatchingCard(cid.sparkfilter,tp,LOCATION_GRAVE,0,1,nil)
end
function cid.sttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and cid.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(cid.filter,tp,0,LOCATION_GRAVE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cid.filter,tp,0,LOCATION_GRAVE,1,1,nil,e,tp)
	if g:GetFirst():IsType(TYPE_MONSTER) then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	else
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
	end
end
function cid.stop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	if tc:IsType(TYPE_MONSTER) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	elseif (tc:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0) then
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function cid.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cid.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	if Duel.IsExistingMatchingCard(cid.sparkfilter,tp,LOCATION_GRAVE,0,1,nil) then
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)   
end
end
function cid.drop(e,tp,eg,ep,ev,re,r,rp)
	local ifclause=false
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT) 
	if p:GetCount()>0 then 
	if Duel.Draw(p,d,REASON_EFFECT)>0 and Duel.IsExistingMatchingCard(cid.sparkfilter,tp,LOCATION_GRAVE,0,1,nil) then
		ifclause=true
	end
	if ifclause then
		local h=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetFieldGroup(h,LOCATION_HAND,0)
	local dg=g:RandomSelect(tp,1)
	Duel.SendtoGrave(dg,REASON_EFFECT+REASON_DISCARD)
			end
		end
end 