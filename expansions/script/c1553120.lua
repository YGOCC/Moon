--Legends and Myths, Deianria The Fallen Overseer
function c1553120.initial_effect(c)
	--link summon
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,c1553120.matfilter,2)
    	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1553120,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,1553120)
	e1:SetCondition(c1553120.gycon)
	e1:SetTarget(c1553120.gytg)
	e1:SetOperation(c1553120.gyop)
	c:RegisterEffect(e1)
	--extra attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1553120,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetCountLimit(1,1553121)
	e2:SetCost(c1553120.cost)
	e2:SetTarget(c1553120.target)
	c:RegisterEffect(e2)
	--lvchange
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1553120,2))
	e3:SetCategory(CATEGORY_LVCHANGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,1553122)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetTarget(c1553120.lvtg)
	e3:SetOperation(c1553120.lvop)
	c:RegisterEffect(e3)
end
function c1553120.matfilter(c)
	return c:IsLinkSetCard(0x190) or c:IsLinkSetCard(0xFA0)
end
function c1553120.gycon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c1553120.gyfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xFA0) or c:IsSetCard(0x190)
end
function c1553120.gytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c1553120.gyfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1553120.gyfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c1553120.gyfilter,tp,LOCATION_REMOVED,0,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c1553120.gyop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=tg:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_RETURN)
	end
end
function c1553120.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsSetCard,1,e:GetHandler(),0xFA0) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsSetCard,1,1,e:GetHandler(),0xFA0)
	Duel.Release(g,REASON_COST)
end
function c1553120.target(e,c)
	return e:GetHandler():GetLinkedGroup()
end
function c1553120.filter(c)
	return c:IsFaceup() and not c:IsType(TYPE_LINK)
end
function c1553120.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c1553120.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1553120.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c1553120.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c1553120.lvop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end