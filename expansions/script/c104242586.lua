--Moon's Dream: Org XIII
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cod=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cod
end
local id,cid=getID()
function cid.initial_effect(c)
	c:EnableReviveLimit()
		if Card.Type then 
	  Xyz.AddProcedure(c,cid.mfilter,2,3,cid.ovfilter,aux.Stringid(id,0),3,cid.xyzop)
	else if not Card.Type then
    aux.AddXyzProcedure(c,cid.mfilter,2,3,cid.ovfilter,aux.Stringid(id,0),3,cid.xyzop)
	end
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(32302078,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCost(cid.cost)
	e1:SetTarget(cid.tgtg)
	e1:SetOperation(cid.tgop)
	c:RegisterEffect(e1)
	--bounce
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(32302078,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+1000)
	e2:SetCondition(cid.bcon)
	e2:SetTarget(cid.btg)
	e2:SetOperation(cid.bop)
	c:RegisterEffect(e2)
end
end

--Filters
function cid.searchfilter(c,e,tp)
	return c:IsSetCard(0x666) and c:IsAbleToHand()
end
function cid.fragment(c)
	return c:IsCode(104242585) and c:IsFaceup()
end
function cid.moondream(c)
	return c:IsSetCard(0x666) and c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function cid.cfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_BEAST) and c:IsFaceup()
end
function cid.mfilter(c)
    return c:IsRace(RACE_BEAST)
end
function cid.ovfilter(c)
return c:IsFaceup() and c:IsSetCard(0x666)
end
function cid.splimit(e,c)
	return c:GetRace()~=RACE_BEAST
end
--bounce effect
function cid.bcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetOverlayCount()==0
end
function cid.btg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cid.bop(e,tp,eg,ep,ev,re,r,rp)
	if chk==0 then return e:GetHandler():IsAbleToDeck() end
	if Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_EFFECT)~=0 then
	local c=e:GetHandler()
--	if c:IsRelateToEffect(e) and Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
	--Duel.SpecialSummonComplete()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cid.searchfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,3,3,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		e:IsHasType(EFFECT_TYPE_IGNITION) 
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e2:SetTargetRange(1,0)
		e2:SetTarget(cid.splimit)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
end
end
end
--summon condition
function cid.xyzop(e,tp,chk,c)
    if chk==0 then return Duel.IsExistingMatchingCard(cid.ovfilter,tp,LOCATION_EXTRA,0,2,e:GetHandler())
  --  and Duel.GetFlagEffect(tp,id)==0
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
    local g=Duel.SelectMatchingCard(tp,cid.ovfilter,tp,LOCATION_EXTRA,0,2,2,e:GetHandler())
    if g:GetCount()>=0 then
        Duel.Overlay(e:GetHandler(),g)
        return true
  --      Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
    end
    return false
end
--pop 1 and token
function cid.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cid.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function cid.tgop(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.Destroy(tc,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(cid.fragment,tp,LOCATION_REMOVED,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and  Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.BreakEffect()
		local frag=Duel.GetFirstMatchingCard(cid.fragment,tp,LOCATION_REMOVED,0,nil,e,tp)
		if frag and Duel.RemoveCards then
		Duel.RemoveCards(frag,nil,REASON_EFFECT+REASON_RULE)
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		end
			if frag and not Duel.RemoveCards then 
			Duel.Exile(frag,REASON_EFFECT+REASON_RULE)
		
			
	end
	local atk=Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_HAND+LOCATION_ONFIELD)*500
			local def=Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_HAND+LOCATION_ONFIELD)*500
			if Duel.IsPlayerCanSpecialSummonMonster(tp,104242592,0,0x4011,atk,def,2,RACE_BEAST,ATTRIBUTE_DARK) then
				Duel.BreakEffect()
				local token=Duel.CreateToken(tp,104242592)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_SET_ATTACK)
				e2:SetValue(atk)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
				token:RegisterEffect(e2)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_SET_DEFENSE)
				e2:SetValue(def)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
				token:RegisterEffect(e2)
				Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end

end
end
end