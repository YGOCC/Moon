--Moon's Dream: I'm Still Here!
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
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(50005218,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(cid.btg)
	e2:SetOperation(cid.bop)
	c:RegisterEffect(e2)
	--banish
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(88523882,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(cid.fragcon)
	e3:SetTarget(cid.thtg)
	e3:SetOperation(cid.thop)
	c:RegisterEffect(e3)	
end
function cid.cfilter(c,tp,e)
	return c:IsSetCard(0x666) and c:IsAbleToDeck() and c:IsType(TYPE_MONSTER)
end
function cid.Tcfilter(c,e)
	return c:IsSetCard(0x666) and c:IsAbleToDeck() 
end
function cid.btg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cid.cfilter(chkc) and cid.Tcfilter(chkc)  end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and 
		Duel.IsExistingTarget(cid.cfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp)
	and Duel.IsExistingTarget(cid.Tcfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,3,nil,e,tp)	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectTarget(tp,cid.cfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectTarget(tp,cid.Tcfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,2,2,g1,e,tp)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cid.bop(e,tp,eg,ep,ev,re,r,rp)
if not e:GetHandler():IsRelateToEffect(e) then return end
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)==0 then return end
			Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
				local g=Duel.GetOperatedGroup()
					if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
						local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
							if ct>=1 then
								Duel.BreakEffect()
									Duel.Draw(tp,1,REASON_EFFECT)
								end
end

function cid.fragcon(e,tp,eg,ep,ev,re,r,rp)
	local ec=eg:GetFirst()
	return not eg:IsContains(e:GetHandler()) and ec:IsSetCard(0x666) and ec:GetPreviousControler()==tp  and ec:IsType(TYPE_FUSION)
end
function cid.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_DECK)
end
function cid.thfilter(c)
	return c:IsSetCard(0x666) and c:IsAbleToRemove()
end
function cid.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.ConfirmDecktop(tp,3)
	local g=Duel.GetDecktopGroup(tp,3)
	if g:GetCount()>0 then
		if g:IsExists(Card.IsSetCard,1,nil,0x666) then
			if g:IsExists(cid.thfilter,1,nil) then
				Duel.Hint(HINT_SELECTMSG,p,HINTMSG_REMOVE)
				local sg=g:FilterSelect(tp,cid.thfilter,1,1,nil)
				Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
				
			end
		end
		Duel.ShuffleDeck(tp)
	end
end
