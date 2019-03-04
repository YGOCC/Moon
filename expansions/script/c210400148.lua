--created & coded by Lyris, art at https://static.zerochan.net/Sendou.Emi.full.490053.jpg
--ニュートリックス・エミー
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
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(function(e,tp) return Duel.GetTurnPlayer()~=tp or Duel.IsPlayerAffectedByEffect(tp,210400153) end)
	e1:SetCost(cid.cost)
	e1:SetTarget(cid.target)
	e1:SetOperation(cid.operation)
	c:RegisterEffect(e1)
end
function cid.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemove() end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsType(TYPE_LINK) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsType,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,TYPE_LINK) end
	Duel.SelectTarget(tp,Card.IsType,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,TYPE_LINK)
end
function cid.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,0))
	local op=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))
	for tc in aux.Next(g) do
		local lpt,nlpt=tc:GetLinkMarker(),0
		local j=0
		for i=0,8 do
			j=0x1<<i&lpt
			if j>0 and cid.link_table[op][j] then
				nlpt=nlpt|j
			end
		end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_LINK_MARKER_KOISHI)
		e1:SetValue(nlpt)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
cid.link_table={
	[0]={
		[LINK_MARKER_BOTTOM_LEFT]=LINK_MARKER_TOP_RIGHT,
		[LINK_MARKER_BOTTOM]=LINK_MARKER_RIGHT,
		[LINK_MARKER_LEFT]=LINK_MARKER_TOP,
		[LINK_MARKER_RIGHT]=LINK_MARKER_BOTTOM,
		[LINK_MARKER_TOP]=LINK_MARKER_LEFT,
		[LINK_MARKER_TOP_RIGHT]=LINK_MARKER_BOTTOM_LEFT,
	},
	[1]={
		[LINK_MARKER_BOTTOM]=LINK_MARKER_LEFT,
		[LINK_MARKER_BOTTOM_RIGHT]=LINK_MARKER_TOP_LEFT,
		[LINK_MARKER_LEFT]=LINK_MARKER_BOTTOM,
		[LINK_MARKER_RIGHT]=LINK_MARKER_TOP,
		[LINK_MARKER_TOP_LEFT]=LINK_MARKER_BOTTOM_RIGHT,
		[LINK_MARKER_TOP]=LINK_MARKER_RIGHT,
	}
}
