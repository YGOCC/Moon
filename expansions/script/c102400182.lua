--created & coded by Lyris, art by wawa3761 of DeviantArt
--ニュートリックス・ギャブリー
local cid,id=GetID()
function cid.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,3,99,cid.lcheck)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cid.discon)
	e2:SetOperation(cid.disop)
	c:RegisterEffect(e2)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk) if chk==0 then return c:GetFlagEffect(id)==0 end c:RegisterFlagEffect(id,RESET_CHAIN,0,1) end)
	e1:SetTarget(cid.target)
	e1:SetOperation(cid.operation)
	c:RegisterEffect(e1)
end
function cid.lcheck(g)
	return g:GetClassCount(Card.GetLinkAttribute)==1 and g:GetClassCount(Card.GetLinkRace)==1 and g:GetClassCount(Card.GetLinkCode)==g:GetCount()
end
function cid.lfilter(c,tp)
	return Duel.IsExistingMatchingCard(function(tc,lpt) return tc:GetLinkMarker()&lpt>0 end,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,c:GetLinkMarker())
end
function cid.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=re:GetHandler()
	local p=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CONTROLER)
	return re:IsActiveType(TYPE_LINK) and p~=tp and Duel.IsExistingMatchingCard(function(tc,lpt) return tc:GetLinkMarker()&lpt>0 end,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,c:GetLinkMarker())
end
function cid.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsType(TYPE_LINK) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsType,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,TYPE_LINK) end
	Duel.SelectTarget(tp,Card.IsType,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,TYPE_LINK)
end
function cid.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()==0 then return end
	local ct=Duel.AnnounceNumber(tp,1,2,3)
	for tc in aux.Next(g) do
		local lpt,nlpt=tc:GetLinkMarker(),0
		local j=0
		for i=0,8 do
			j=0x1<<i&lpt
			if j>0 and cid.link_table[ct][j] then
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
	[1]={
		[LINK_MARKER_BOTTOM_LEFT]=LINK_MARKER_BOTTOM,
		[LINK_MARKER_BOTTOM]=LINK_MARKER_BOTTOM_RIGHT,
		[LINK_MARKER_BOTTOM_RIGHT]=LINK_MARKER_RIGHT,
		[LINK_MARKER_LEFT]=LINK_MARKER_BOTTOM_LEFT,
		[LINK_MARKER_RIGHT]=LINK_MARKER_TOP_RIGHT,
		[LINK_MARKER_TOP_LEFT]=LINK_MARKER_LEFT,
		[LINK_MARKER_TOP]=LINK_MARKER_TOP_LEFT,
		[LINK_MARKER_TOP_RIGHT]=LINK_MARKER_TOP,
	}
	},
	[2]={
		[LINK_MARKER_BOTTOM_LEFT]=LINK_MARKER_BOTTOM_RIGHT,
		[LINK_MARKER_BOTTOM]=LINK_MARKER_RIGHT,
		[LINK_MARKER_BOTTOM_RIGHT]=LINK_MARKER_TOP_RIGHT,
		[LINK_MARKER_LEFT]=LINK_MARKER_BOTTOM,
		[LINK_MARKER_RIGHT]=LINK_MARKER_TOP,
		[LINK_MARKER_TOP_LEFT]=LINK_MARKER_BOTTOM_LEFT,
		[LINK_MARKER_TOP]=LINK_MARKER_LEFT,
		[LINK_MARKER_TOP_RIGHT]=LINK_MARKER_TOP_LEFT,
	},
	[3]={
		[LINK_MARKER_BOTTOM_LEFT]=LINK_MARKER_BOTTOM,
		[LINK_MARKER_BOTTOM]=LINK_MARKER_TOP_RIGHT,
		[LINK_MARKER_BOTTOM_RIGHT]=LINK_MARKER_RIGHT,
		[LINK_MARKER_LEFT]=LINK_MARKER_BOTTOM_RIGHT,
		[LINK_MARKER_RIGHT]=LINK_MARKER_TOP_LEFT,
		[LINK_MARKER_TOP_LEFT]=LINK_MARKER_TOP,
		[LINK_MARKER_TOP]=LINK_MARKER_BOTTOM_LEFT,
		[LINK_MARKER_TOP_RIGHT]=LINK_MARKER_LEFT,
	},
}
