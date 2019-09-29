--created & coded by Lyris, art at https://78.media.tumblr.com/e349861ac74f1e6d72f42fa7ad8cd8f7/tumblr_p2oxlkOMsG1w0w6bio1_1280.jpg
--ニュートリックス・ホリー
local cid,id=GetID()
function cid.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(cid.target)
	e1:SetOperation(cid.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(cid.tg)
	e2:SetOperation(cid.op)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
end
function cid.lfilter(c,tp)
	return Duel.IsExistingMatchingCard(function(tc,lpt) return tc:GetLinkMarker()&lpt>0 end,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,c:GetLinkMarker())
		or (c:IsType(TYPE_LINK) and not Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,TYPE_LINK))
end
function cid.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xd10)
end
function cid.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cid.lfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp)
		and Duel.IsExistingMatchingCard(cid.filter,tp,LOCATION_MZONE,0,1,nil) end
end
function cid.op(e,tp,eg,ep,ev,re,r,rp)
	local ct=#Duel.GetMatchingGroup(cid.lfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
	if ct==0 then return end
	local g=Duel.GetMatchingGroup(cid.filter,tp,LOCATION_MZONE,0,nil)
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(ct*400)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsType(TYPE_LINK) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsType,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,TYPE_LINK) end
	Duel.SelectTarget(tp,Card.IsType,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,TYPE_LINK)
end
function cid.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()==0 then return end
	for tc in aux.Next(g) do
		local lpt,nlpt=tc:GetLinkMarker(),0
		local j=0
		for i=0,8 do
			j=0x1<<i&lpt
			if j>0 and cid.link_table[j] then
				nlpt=nlpt|cid.link_table[j]
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
	[LINK_MARKER_BOTTOM_LEFT]=LINK_MARKER_TOP,
	[LINK_MARKER_BOTTOM]=LINK_MARKER_TOP_LEFT,
	[LINK_MARKER_BOTTOM_RIGHT]=LINK_MARKER_LEFT,
	[LINK_MARKER_LEFT]=LINK_MARKER_TOP_RIGHT,
	[LINK_MARKER_RIGHT]=LINK_MARKER_BOTTOM_LEFT,
	[LINK_MARKER_TOP_LEFT]=LINK_MARKER_RIGHT,
	[LINK_MARKER_TOP]=LINK_MARKER_BOTTOM_RIGHT,
	[LINK_MARKER_TOP_RIGHT]=LINK_MARKER_BOTTOM,
}
