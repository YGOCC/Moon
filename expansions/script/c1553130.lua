--Legends and Myths, Amraen the Fallen Disciple
function c1553130.initial_effect(c)
	--link summon
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,c1553130.matfilter,2)
    --to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1553130,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,1553130)
	e1:SetCondition(c1553130.descon)
	e1:SetTarget(c1553130.destg)
	e1:SetOperation(c1553130.desop)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1553130,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,1553131)
	e2:SetCost(c1553130.cost)
	e2:SetTarget(c1553130.target)
	e2:SetOperation(c1553130.operation)
	c:RegisterEffect(e2)
end
function c1553130.matfilter(c)
	return c:IsLinkSetCard(0x190) or c:IsLinkSetCard(0xFA0)
end
function c1553130.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c1553130.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c1553130.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c1553130.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1553130.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c1553130.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c1553130.desop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
			Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c1553130.cfilter(c,g)
	return g:IsContains(c) and c:IsSetCard(0xFA0)
end
function c1553130.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=e:GetHandler():GetLinkedGroup()
	if chk==0 then return Duel.CheckReleaseGroup(tp,c1553130.cfilter,1,nil,lg) end
	local g=Duel.SelectReleaseGroup(tp,c1553130.cfilter,1,1,nil,lg)
	Duel.Release(g,REASON_COST)
end
function c1553130.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c1553130.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	Duel.Draw(p,d,REASON_EFFECT)
end
