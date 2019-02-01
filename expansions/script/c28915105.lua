--Corona Spell
local ref=_G['c'..28915105]
local id=28915105
function ref.initial_effect(c)
	--Corona Card
	--aux.EnableCorona(c,ref.matfilter,3,99,TYPE_SPELL,nil)
	aux.EnableCoronaNeo(c,3,3,ref.matfilter,ref.matfilter2)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(ref.acttg)
	e1:SetOperation(ref.actop)
	c:RegisterEffect(e1)
end
function ref.matfilter(c)
	return c:IsType(TYPE_SPELL)
end
function ref.matfilter2(c)
	return c:GetType()==TYPE_SPELL or c:GetType()==TYPE_TRAP
end

function ref.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function ref.actop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	local g=Duel.GetDecktopGroup(p,1)
	Duel.ConfirmCards(p,g)
	if Duel.SelectYesNo(p,aux.Stringid(id,0)) then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
	Duel.Draw(p,d,REASON_EFFECT)
end
