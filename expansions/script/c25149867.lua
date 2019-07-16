--Starlignment Trigon
--Scripted by: XGlitchy30
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cod=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cod
end
local id,cid=getID()
function cid.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(cid.cost)
	e1:SetTarget(cid.target)
	e1:SetOperation(cid.activate)
	c:RegisterEffect(e1)
end
--Attribute Effects Conditions
function cid.attrfilter(attr,e,tp)
	if not attr then return false end
	local oattr1,oattr2=0,0
	if attr==ATTRIBUTE_LIGHT then
		oattr1,oattr2=ATTRIBUTE_WATER,ATTRIBUTE_EARTH
		return not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
			and Duel.IsExistingMatchingCard(cid.chkfilter,tp,LOCATION_GRAVE,0,2,nil,ATTRIBUTE_LIGHT,oattr1,oattr2,e,tp)
	elseif attr==ATTRIBUTE_FIRE then
		oattr1,oattr2=ATTRIBUTE_DARK,ATTRIBUTE_WIND
		return Duel.IsExistingMatchingCard(cid.chkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,2,nil,ATTRIBUTE_FIRE,oattr1,oattr2)
	elseif attr==ATTRIBUTE_EARTH then
		oattr1,oattr2=ATTRIBUTE_WATER,ATTRIBUTE_LIGHT
		return Duel.IsExistingMatchingCard(cid.chkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,2,nil,ATTRIBUTE_EARTH,oattr1,oattr2)
	elseif attr==ATTRIBUTE_DARK then
		oattr1,oattr2=ATTRIBUTE_WIND,ATTRIBUTE_FIRE
		return Duel.IsExistingMatchingCard(cid.chkfilter,tp,LOCATION_DECK,0,2,nil,ATTRIBUTE_DARK,oattr1,oattr2) and Duel.IsPlayerCanDraw(tp,2)
	elseif attr==ATTRIBUTE_WATER then
		oattr1,oattr2=ATTRIBUTE_LIGHT,ATTRIBUTE_EARTH
		return Duel.IsExistingMatchingCard(cid.chkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,2,nil,ATTRIBUTE_WATER,oattr1,oattr2)
	elseif attr==ATTRIBUTE_WIND then
		oattr1,oattr2=ATTRIBUTE_FIRE,ATTRIBUTE_DARK
		return Duel.IsExistingMatchingCard(cid.chkfilter,tp,LOCATION_REMOVED+LOCATION_GRAVE,LOCATION_REMOVED+LOCATION_GRAVE,2,nil,ATTRIBUTE_WIND,oattr1,oattr2)
	else
		return false
	end
end
function cid.chkfilter(c,id,oattr1,oattr2,e,tp)
	if not c:IsType(TYPE_MONSTER) or (not c:IsAttribute(oattr1) and not c:IsAttribute(oattr2)) then return false end
	if id==ATTRIBUTE_LIGHT then
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	elseif id==ATTRIBUTE_FIRE then
		return c:IsFaceup()
	elseif id==ATTRIBUTE_EARTH then
		return c:IsFaceup() and (c:GetAttack()~=0 or c:GetDefense()~=0)
	elseif id==ATTRIBUTE_DARK then
		return c:IsAbleToRemove()
	elseif id==ATTRIBUTE_WATER then
		return c:IsFaceup() and not c:IsDisabled()
	elseif id==ATTRIBUTE_WIND then
		return c:IsAbleToDeck() and (c:IsLocation(LOCATION_GRAVE) or (c:IsLocation(LOCATION_REMOVED) and c:IsFaceup()))
	else
		return false
	end
end
--Activate
function cid.pcheck(c,tp)
	return c:IsLocation(LOCATION_DECK) and c:IsControler(tp)
end
function cid.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function cid.cfilter(c,chk,attr,chk1,chk2,chk3,chk4,chk5,chk6)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x2595) and c:IsDiscardable() and ((chk==0 and c:IsAttribute(attr))
		or ((c:IsAttribute(ATTRIBUTE_LIGHT) and chk1) or (c:IsAttribute(ATTRIBUTE_FIRE) and chk2)
		or (c:IsAttribute(ATTRIBUTE_EARTH) and chk3) or (c:IsAttribute(ATTRIBUTE_DARK) and chk4)
		or (c:IsAttribute(ATTRIBUTE_WATER) and chk5) or (c:IsAttribute(ATTRIBUTE_WIND) and chk6)))
end
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk)
	--check conditions
	local chk1=Duel.IsExistingMatchingCard(cid.cfilter,tp,LOCATION_HAND,0,1,nil,0,ATTRIBUTE_LIGHT)
		and cid.attrfilter(ATTRIBUTE_LIGHT,e,tp)
	local chk2=Duel.IsExistingMatchingCard(cid.cfilter,tp,LOCATION_HAND,0,1,nil,0,ATTRIBUTE_FIRE) 
		and cid.attrfilter(ATTRIBUTE_FIRE)
	local chk3=Duel.IsExistingMatchingCard(cid.cfilter,tp,LOCATION_HAND,0,1,nil,0,ATTRIBUTE_EARTH) 
		and cid.attrfilter(ATTRIBUTE_EARTH)
	local chk4=Duel.IsExistingMatchingCard(cid.cfilter,tp,LOCATION_HAND,0,1,nil,0,ATTRIBUTE_DARK) 
		and cid.attrfilter(ATTRIBUTE_DARK)
	local chk5=Duel.IsExistingMatchingCard(cid.cfilter,tp,LOCATION_HAND,0,1,nil,0,ATTRIBUTE_WATER) 
		and cid.attrfilter(ATTRIBUTE_WATER)
	local chk6=Duel.IsExistingMatchingCard(cid.cfilter,tp,LOCATION_HAND,0,1,nil,0,ATTRIBUTE_WIND) 
		and cid.attrfilter(ATTRIBUTE_WIND)
	----------
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return (chk1 or chk2 or chk3 or chk4 or chk5 or chk6)
	end
	e:SetLabel(0)
	e:SetCategory(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,cid.cfilter,tp,LOCATION_HAND,0,1,1,nil,1,nil,chk1,chk2,chk3,chk4,chk5,chk6)
	local opt=g:GetFirst():GetAttribute()
	if Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)~=0 then
		local num,check1,check2=1,false,false
		while num<=32 do
			if bit.band(opt,num)>0 then
				if not check1 then
					check1=true
				else
					check2=true
					opt=opt+1000
					break
				end
			end
			num=num*2
		end
		e:SetLabel(opt)
		if bit.band(opt,ATTRIBUTE_LIGHT)>0 then
			e:SetCategory(CATEGORY_SPECIAL_SUMMON)
			Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_GRAVE)
		elseif bit.band(opt,ATTRIBUTE_FIRE)>0 then
			e:SetCategory(CATEGORY_DESTROY)
			local sg=Duel.GetMatchingGroup(cid.chkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,ATTRIBUTE_FIRE,ATTRIBUTE_DARK,ATTRIBUTE_WIND)
			Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,#sg,0,0)
		elseif bit.band(opt,ATTRIBUTE_EARTH)>0 then
			e:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
		elseif bit.band(opt,ATTRIBUTE_DARK)>0 then
			e:SetCategory(CATEGORY_REMOVE+CATEGORY_DRAW)
			Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,tp,LOCATION_DECK)
			Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
		elseif bit.band(opt,ATTRIBUTE_WATER)>0 then
			e:SetCategory(CATEGORY_DISABLE)
		elseif bit.band(opt,ATTRIBUTE_WIND)>0 then
			e:SetCategory(CATEGORY_TODECK)
			Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,PLAYER_ALL,LOCATION_REMOVED+LOCATION_GRAVE)
		end
	end
end
function cid.activate(e,tp,eg,ep,ev,re,r,rp)
	local opt=e:GetLabel()
	if opt>1000 then
		opt=opt-1000
		local num,attr=1,0
		while num<=32 do
			if bit.band(opt,num)>0 then
				attr=bit.bor(attr,num)
			end
			num=num*2
		end
		opt=Duel.AnnounceAttribute(tp,1,bit.band(0xffff,attr))
	end
	local oattr1,oattr2=0,0
	--light
	if opt==ATTRIBUTE_LIGHT then
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
		oattr1,oattr2=ATTRIBUTE_WATER,ATTRIBUTE_EARTH
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cid.chkfilter),tp,LOCATION_GRAVE,0,nil,opt,oattr1,oattr2,e,tp)
		if #g>=2 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,2,2,nil)
			Duel.HintSelection(sg)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	--fire
	elseif opt==ATTRIBUTE_FIRE then
		oattr1,oattr2=ATTRIBUTE_DARK,ATTRIBUTE_WIND
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,cid.chkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,2,2,nil,opt,oattr1,oattr2)
		if #g>0 then
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
		end
	--earth
	elseif opt==ATTRIBUTE_EARTH then
		oattr1,oattr2=ATTRIBUTE_WATER,ATTRIBUTE_LIGHT
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g=Duel.SelectMatchingCard(tp,cid.chkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,2,2,nil,opt,oattr1,oattr2)
		if #g>0 then
			Duel.HintSelection(g)
			local tc=g:GetFirst()
			while tc do
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				e1:SetCode(EFFECT_SET_ATTACK_FINAL)
				e1:SetValue(0)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
				tc:RegisterEffect(e2)
				tc=g:GetNext()
			end
		end
	--dark
	elseif opt==ATTRIBUTE_DARK then
		oattr1,oattr2=ATTRIBUTE_WIND,ATTRIBUTE_FIRE
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,cid.chkfilter,tp,LOCATION_DECK,0,2,2,nil,opt,oattr1,oattr2)
		if #g>0 then
			Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
			local og=Duel.GetOperatedGroup()
			local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_REMOVED)
			if ct==2 then
				Duel.BreakEffect()
				Duel.Draw(tp,2,REASON_EFFECT)
			end
		end
	--water
	elseif opt==ATTRIBUTE_WATER then
		oattr1,oattr2=ATTRIBUTE_LIGHT,ATTRIBUTE_EARTH
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g=Duel.SelectMatchingCard(tp,cid.chkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,2,2,nil,opt,oattr1,oattr2)
		if #g>0 then
			Duel.HintSelection(g)
			local tc=g:GetFirst()
			while tc do
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetValue(RESET_TURN_SET)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e2)
				tc=g:GetNext()
			end
		end
	--wind
	elseif opt==ATTRIBUTE_WIND then
		oattr1,oattr2=ATTRIBUTE_FIRE,ATTRIBUTE_DARK
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cid.chkfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,2,2,nil,opt,oattr1,oattr2)
		if #g>0 then
			Duel.HintSelection(g)
			Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
			local og=Duel.GetOperatedGroup()
			for p=0,1 do
				if og:IsExists(cid.pcheck,1,nil,p) then
					Duel.ShuffleDeck(p)
				end
			end
		end
	--exceptions
	else
		return
	end
end