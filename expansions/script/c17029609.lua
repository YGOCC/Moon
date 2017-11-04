--Lucidity of the Psychether
function c17029609.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17029609,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,17029609+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c17029609.revtg)
	e1:SetOperation(c17029609.revop)
	c:RegisterEffect(e1)
--	--Banish replace
--	local e2=Effect.CreateEffect(c)
--	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
--	e2:SetCode(EFFECT_DESTROY_REPLACE)
--	e2:SetRange(LOCATION_GRAVE)
--	e2:SetTarget(c17029608.reptg)
--	e2:SetValue(c17029608.repval)
--	e2:SetOperation(c17029608.repop)
--	c:RegisterEffect(e2)
end
function c17029609.revfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_FAIRY)
end
function c17029609.revtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0
		and Duel.IsExistingMatchingCard(c17029609.revfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	c17029609.announce_filter={TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT}
	local ac=Duel.AnnounceCardFilter(tp,table.unpack(c17029609.announce_filter))
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,ANNOUNCE_CARD_FILTER)
end
function c17029609.revop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local g=Duel.GetMatchingGroup(Card.IsCode,tp,0,LOCATION_HAND,nil,ac)
	if g:GetCount()>0 then
		local g1=Duel.GetMatchingGroup(c17029609.revfilter,tp,LOCATION_MZONE,0,nil)
		local tc=g1:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			tc=g1:GetNext()
		end
	end
end

--function c17029609.bancon(e,tp,eg,ep,ev,re,r,rp)
--	if  re:IsHasCategory(CATEGORY_NEGATE)
--		and Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT):IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
--	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_REMOVE)
--	return ex and tg~=nil
--end
