--Oscurità Irregolare - Psichica Anomala
--Script by XGlitchy30
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cod=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cod
end
local id,cid=getID()
function cid.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x4999),4,2)
	c:EnableReviveLimit()
	--attach
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCost(cid.athcost)
	e1:SetTarget(cid.athtg)
	e1:SetOperation(cid.athop)
	c:RegisterEffect(e1)
	--xyz summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+100)
	e2:SetTarget(cid.xyztg)
	e2:SetOperation(cid.xyzop)
	c:RegisterEffect(e2)
end
--filters
function cid.filter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_DARK)
		and Duel.IsExistingMatchingCard(cid.xyzfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cid.xyzfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x4999)
end
function cid.fuxyz(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function cid.checkshf(c,tp)
	return c:IsLocation(LOCATION_DECK) and c:IsControler(tp)
end
function cid.xyzspfilter(c,e,tp)
	return c:IsSetCard(0x4999) and e:GetHandler():IsCanBeXyzMaterial(c) and c:IsType(TYPE_XYZ)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
--attach
function cid.athcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cid.athtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cid.filter(chkc,tp) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingTarget(cid.filter,tp,LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectTarget(tp,cid.filter,tp,LOCATION_GRAVE,0,1,3,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_OVERLAY)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cid.athop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)<=0 then return end
	local tc=tg:GetFirst()
	local ct=0
	while tc do
		Duel.Hint(HINT_CARD,tp,tc:GetOriginalCode())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g=Duel.SelectMatchingCard(tp,cid.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil)
		if #g>0 then
			Duel.HintSelection(g)
			Duel.Overlay(g:GetFirst(),Group.FromCards(tc))
			if g:GetFirst():GetOverlayGroup():IsContains(tc) then ct=ct+1 end
		end
		tc=tg:GetNext()
	end
	if ct>0 then
		local td=Duel.GetMatchingGroup(cid.fuxyz,tp,LOCATION_MZONE,0,nil)
		local xmat=Group.CreateGroup()
		xmat:KeepAlive()
		local tdc=td:GetFirst()
		while tdc do
			if tdc:GetOverlayCount()>0 then
				xmat:Merge(tdc:GetOverlayGroup())
			end
			tdc=td:GetNext()
		end
		if #xmat>=ct then
			local xtd=xmat:Filter(Card.IsAbleToDeck,nil)
			if #xtd<=0 then return end
			local xtc=xtd:Select(tp,ct,ct,nil)
			if #xtc==ct then
				Duel.BreakEffect()
				Duel.SendtoDeck(xtc,nil,0,REASON_EFFECT)
				local gd=Duel.GetOperatedGroup()
				for p=0,1 do
					if gd:IsExists(cid.checkshf,1,nil,p) then Duel.ShuffleDeck(p) end
				end
				local gct=gd:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
				if gct==ct then
					Duel.Draw(tp,1,REASON_EFFECT)
				end
			end
		end
		xmat:DeleteGroup()
	end
end
--xyz summon
function cid.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
end
function cid.xyzop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or e:GetHandler():IsFacedown() or Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<=0 then 
		return 
	end
	local td=Duel.GetDecktopGroup(tp,1)
	local check=0
	Duel.Overlay(e:GetHandler(),td)
	for tc in aux.Next(td) do
		if e:GetHandler():GetOverlayGroup():IsContains(tc) then
			check=check+1
		end
	end
	if check>=1 then
		if Duel.GetLocationCountFromEx(tp,tp,e:GetHandler())<=0 or not aux.MustMaterialCheck(e:GetHandler(),tp,EFFECT_MUST_BE_XMATERIAL)
			or not Duel.IsExistingMatchingCard(cid.xyzspfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) then
				return
		end
		if Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,cid.xyzspfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
			local sc=g:GetFirst()
			if sc then
				local mg=e:GetHandler():GetOverlayGroup()
				if mg:GetCount()~=0 then
					Duel.Overlay(sc,mg)
				end
				sc:SetMaterial(Group.FromCards(e:GetHandler()))
				Duel.Overlay(sc,Group.FromCards(e:GetHandler()))
				Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
				sc:CompleteProcedure()
			end
		end
	end
end