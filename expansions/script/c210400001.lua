--created & coded by Lyris, art from Yu-Gi-Oh! Duel Monsters Episode 86
--早すぎた決断
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cod=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cod
end
local id,cid=getID()
function cid.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(cid.cost)
	e1:SetTarget(cid.target)
	e1:SetOperation(cid.activate)
	c:RegisterEffect(e1)
end
function cid.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function cid.filter2(c,g,tp)
	return g:IsExists(cid.filter1,1,c,tp,c)
end
function cid.filter1(c,tp,tc)
	local code=tc:GetCode()
	return c:IsCode(code) and Duel.IsExistingMatchingCard(cid.filter3,tp,LOCATION_DECK,0,1,Group.FromCards(c,tc),code)
end
function cid.filter3(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
end
function cid.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cid.filter,tp,LOCATION_DECK,0,nil)
	if chk==0 then return g:IsExists(cid.filter2,1,nil,g,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg=g:FilterSelect(tp,cid.filter2,1,1,nil,g,tp)
	local tc=tg:GetFirst()
	tg:AddCard(g:Filter(Card.IsCode,tc,tc:GetCode()):GetFirst())
	Duel.SendtoGrave(tg,REASON_COST)
	Duel.SetTargetCard(tg)
end
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cid.cfilter(c,e)
	return c:IsRelateToEffect(e) and c:IsLocation(LOCATION_GRAVE)
end
function cid.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(cid.cfilter,nil,e)
	local code=g:GetFirst():GetCode()
	if g:FilterCount(Card.IsCode,nil,code)~=2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,cid.filter3,tp,LOCATION_DECK,0,1,1,nil,code)
	if tg:GetCount()>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local tc=g:GetFirst()
		if tc:IsLocation(LOCATION_HAND) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_CANNOT_ACTIVATE)
			e1:SetTargetRange(1,0)
			e1:SetValue(cid.aclimit)
			e1:SetLabelObject(tc)
			e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function cid.aclimit(e,re,tp)
	local tc=e:GetLabelObject()
	return re:GetHandler():IsCode(tc:GetCode()) and not re:GetHandler():IsImmuneToEffect(e)
end
