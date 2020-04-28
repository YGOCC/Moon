--Moon's Dream:Holder of Courage
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
	  Xyz.AddProcedure(c,cid.mfilter,2,2,cid.ovfilter,aux.Stringid(id,0),2,cid.xyzop)
	else if not Card.Type then
    aux.AddXyzProcedure(c,cid.mfilter,2,2,cid.ovfilter,aux.Stringid(id,0),2,cid.xyzop)
	end
	--special summon
	local selfsummon=Effect.CreateEffect(c)
	selfsummon:SetType(EFFECT_TYPE_FIELD)
	selfsummon:SetCode(EFFECT_SPSUMMON_PROC)
	selfsummon:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	selfsummon:SetRange(LOCATION_EXTRA)
	selfsummon:SetCondition(cid.spcon)
	selfsummon:SetOperation(cid.spop)
--	c:RegisterEffect(selfsummon)
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(32302078,0))
	e1:SetCategory(CATEGORY_HANDES+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCost(cid.cost)
	e1:SetTarget(cid.dtg)
	e1:SetOperation(cid.dop)
	c:RegisterEffect(e1)
	--bounce
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(32302078,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+1000)
	e2:SetCondition(cid.bcon)
	e2:SetTarget(cid.btg)
	e2:SetOperation(cid.bop)
	c:RegisterEffect(e2)
end
end
function cid.xyzcheck(g,tp,xyz)
	local mg=g:Filter(function(c) return not c:IsHasEffect(511001175) end,nil)
	return mg:GetClassCount(Card.GetRace)~=0
end
function cid.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cid.cfilter,tp,LOCATION_EXTRA,0,1,nil)
end
function cid.spop(e,tp,eg,ep,ev,re,r,rp,c)
	  if chk==0 then return Duel.IsExistingMatchingCard(cid.cfilter,tp,LOCATION_EXTRA,0,1,nil)
  --  and Duel.GetFlagEffect(tp,id)==0
	end
	Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_MZONE,POS_FACEUP,true)
	Duel.SpecialSummonComplete()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
    local g=Duel.SelectMatchingCard(tp,cid.cfilter,tp,LOCATION_EXTRA,0,1,1,nil)
    if g:GetCount()>=0 then
        Duel.Overlay(e:GetHandler(),g)
  --      Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
end
end


--Filters
function cid.fragment(c)
	return c:IsCode(104242585) and c:IsFaceup()
end
function cid.cfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_BEAST) and c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function cid.xyzfilter(c,xyz,sumtype,tp)
	return c:IsRace(RACE_BEAST,xyz,sumtype,tp) 
end
function cid.mfilter(c)
    return c:IsRace(RACE_BEAST)
end
function cid.ovfilter(c)
return c:IsFaceup() and c:IsSetCard(0x666)
end
function cid.spfilter(c,e,tp)
	return c:IsSetCard(0x666) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cid.splimit(e,c)
	return c:GetRace()~=RACE_BEAST
end
--summon condition
function cid.xyzop(e,tp,chk,c)
    if chk==0 then return Duel.IsExistingMatchingCard(cid.ovfilter,tp,LOCATION_EXTRA,0,1,e:GetHandler())
  --  and Duel.GetFlagEffect(tp,id)==0
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
    local g=Duel.SelectMatchingCard(tp,cid.ovfilter,tp,LOCATION_EXTRA,0,1,1,e:GetHandler())
    if g:GetCount()>=0 then
        Duel.Overlay(e:GetHandler(),g)
        return true
  --      Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
    end
    return false
end
--mill hands and multiswing
function cid.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cid.dtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local h1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
		if e:GetHandler():IsLocation(LOCATION_HAND) then h1=h1-1 end
		local h2=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
		return (h1+h2>0) and (Duel.IsPlayerCanDraw(tp,h1) or h1==0) and (Duel.IsPlayerCanDraw(1-tp) or h2==0)
	end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,PLAYER_ALL,1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,1)
end
function cid.dop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local h1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local h2=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	local dg=Duel.GetFieldGroup(tp,LOCATION_HAND,LOCATION_HAND)
	local dt=Duel.SendtoGrave(dg,REASON_EFFECT+REASON_DISCARD)
	if  dt~=0 then
	Duel.BreakEffect()
	Duel.Draw(tp,h1,REASON_EFFECT)
	Duel.Draw(1-tp,h2,REASON_EFFECT)
	if dt~=0 and c:IsRelateToEffect(e) and c:IsFaceup() then
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(dt*300)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end
	
		if Duel.IsExistingMatchingCard(cid.fragment,tp,LOCATION_REMOVED,0,1,nil) and c:IsFaceup() and 
		Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.BreakEffect()
		local frag=Duel.GetFirstMatchingCard(cid.fragment,tp,LOCATION_REMOVED,0,nil,e,tp)
		if frag and Duel.RemoveCards then
		Duel.RemoveCards(frag,nil,REASON_EFFECT+REASON_RULE)
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		end
			if frag and not Duel.RemoveCards then 
			Duel.Exile(frag,REASON_EFFECT+REASON_RULE)
	
	
end
if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ATTACK_ALL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(1)
		c:RegisterEffect(e1)
end
end
end
end
--bounce effect
function cid.bcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetOverlayCount()==0
end
function cid.btg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 
	and Duel.IsExistingMatchingCard(cid.spfilter,tp,LOCATION_GRAVE,0,2,nil,e,tp) and not Duel.IsPlayerAffectedByEffect(tp,59822133) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)	
end
function cid.bop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if chk==0 then return e:GetHandler():IsAbleToDeck() end
	if Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_EFFECT)~=0 then
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cid.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=1 then return end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cid.spfilter),tp,LOCATION_GRAVE,0,nil,e,tp)
	if g:GetCount()>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg1=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
		Duel.SpecialSummon(sg1,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end