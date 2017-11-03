--Psychether Dream Overseer, Helmretta
function c17029612.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_FAIRY),4,3)
	c:EnableReviveLimit()
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
	--disable spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_MSET)
	c:RegisterEffect(e4)
	--confirm
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(17029612,0))
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetCountLimit(1,17029612)
	e5:SetCost(c17029612.cfcost)
	e5:SetTarget(c17029612.cftg)
	e5:SetOperation(c17029612.cfop)
	c:RegisterEffect(e5)
	--Declare and to top
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(17029612,1))
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCode(EVENT_TO_GRAVE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCategory(CATEGORY_TODECK)
	e6:SetCountLimit(1,17029622)
	e6:SetCondition(c17029612.tdcon)
	e6:SetTarget(c17029612.tdtg)
	e6:SetOperation(c17029612.tdop)
	c:RegisterEffect(e6)
end
function c17029612.cfcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c17029612.revfilter(c)
	return not c:IsPublic()
end
function c17029612.cftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFacedown,tp,0,LOCATION_ONFIELD,1,nil)
		and Duel.IsExistingMatchingCard(c17029612.revfilter,tp,0,LOCATION_HAND,1,nil) end
	Duel.SetChainLimit(c17029612.chlimit)
end
function c17029612.chlimit(e,ep,tp)
	return tp==ep
end
function c17029612.cfop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.ConfirmCards(tp,g)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetRange(LOCATION_MZONE)
		e1:SetTargetRange(0,LOCATION_HAND)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1)
	end
end
function c17029612.afilter(c,tp)
	return c:IsType(TYPE_SPELL) and c:GetPreviousControler()==tp 
		and c:IsSetCard(0x720)
end
function c17029612.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c17029611.afilter,nil,tp)
	local c=e:GetHandler()
	return c:GetOverlayGroup():IsExists(Card.IsType,1,nil,TYPE_SPELL)
		and g:GetCount()>0
end
function c17029612.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	c17029612.announce_filter={TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT}
	local ac=Duel.AnnounceCardFilter(tp,table.unpack(c17029612.announce_filter))
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,ANNOUNCE_CARD_FILTER)
end
function c17029612.tdop(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local g=Duel.GetMatchingGroup(Card.IsCode,tp,0,LOCATION_HAND,nil,ac)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
	end
end
