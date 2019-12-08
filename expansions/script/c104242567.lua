--Moon's Dream, The Helpful Pony
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cod=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cod
end
local id,cid=getID()
function cid.initial_effect(c)
		--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCondition(cid.sprcon)
	c:RegisterEffect(e1)
		--bounce and limit targets
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCountLimit(1,id+1000)
	e2:SetCost(cid.bouncecost)
	e2:SetTarget(cid.thtg)
	e2:SetOperation(cid.thop)
	c:RegisterEffect(e2)
end
function cid.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return (Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0,nil)<Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE,nil)) or (Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0)
end
--bounce and limit targets
function cid.bouncecost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHandAsCost() end
	Duel.SendtoHand(e:GetHandler(),nil,REASON_COST)
end
function cid.thfilter(c)
	return c:IsLevel(3) and c:IsAttribute(ATTRIBUTE_DARK) and not c:IsCode(id) and c:IsAbleToHand()
end
function cid.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cid.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cid.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cid.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
			Duel.BreakEffect()
			Duel.Hint(HINT_CARD,0,104242585)
	local sc=Duel.CreateToken(tp,104242585)
	sc:SetCardData(CARDDATA_TYPE, sc:GetType()-TYPE_TOKEN)
  Duel.Remove(sc,POS_FACEUP,REASON_RULE)
--	sc:SetCardData(CARDDATA_TYPE, sc:GetType()+TYPE_SPELL)
--	Duel.MoveToField(sc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
