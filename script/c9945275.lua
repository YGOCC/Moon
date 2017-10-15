--Afriel, of Virtue
function c9945275.initial_effect(c)
	--SPSummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9945275,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(c9945275.spcon)
	e1:SetTarget(c9945275.sptg)
	e1:SetOperation(c9945275.spop)
	c:RegisterEffect(e1)
	--DeckDes
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9945275,1))
	e2:SetCategory(CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c9945275.ddtg)
	e2:SetOperation(c9945275.ddop)
	c:RegisterEffect(e2)
end
function c9945275.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ec=eg:GetFirst()
	return ec:IsControler(tp) and ec:IsSetCard(0x204F)
end
function c9945275.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9945275.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
		c:CompleteProcedure()
	end
end
function c9945275.ddtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,1)
end
function c9945275.ddop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.DiscardDeck(tp,1,REASON_EFFECT)==1 then
		local g=Duel.GetOperatedGroup()
		if g:GetFirst():IsSetCard(0x204F) and g:GetFirst():IsType(TYPE_MONSTER) then
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(9945275,2))
			e1:SetCategory(CATEGORY_DRAW)
			e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
			e1:SetProperty(EFFECT_FLAG_DELAY)
			e1:SetCode(EVENT_BE_MATERIAL)
			e1:SetReset(RESET_EVENT+0x57a0000+RESET_PHASE+PHASE_END)
			e1:SetCondition(c9945275.drcon)
			e1:SetTarget(c9945275.drtg)
			e1:SetOperation(c9945275.drop)
			c:RegisterEffect(e1)
		end
	end
end
function c9945275.drcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_SYNCHRO and e:GetHandler():GetReasonCard():IsSetCard(0x204F)
end
function c9945275.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c9945275.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
