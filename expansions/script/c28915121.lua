--Princess of the Swamp
local ref=_G['c'..28915121]
local id=28915121
function ref.initial_effect(c)
	--Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(ref.spcon)
	e1:SetCost(ref.spcost)
	e1:SetTarget(ref.sptg)
	e1:SetOperation(ref.spop)
	c:RegisterEffect(e1)
	--Fusion
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,id)
	e2:SetCondition(ref.fuscon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(ref.fustg)
	e2:SetOperation(ref.fusop)
	c:RegisterEffect(e2)
end

--Summon
function ref.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function ref.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:RegisterFlagEffect(id,RESET_CHAIN,0,1) and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,c) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,c)
	c:RegisterFlagEffect(id,RESET_CHAIN,0,1)
end
function ref.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsPlayerCanDraw(tp,1)
	end
	Duel.SetTargetParam(1)
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function ref.spop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) then
		Duel.BreakEffect()
		Duel.Draw(p,d,REASON_EFFECT)
	end
end

--Fusion
function ref.fuscon(e,tp,eg,ep,ev,re,r,rp)
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) and aux.cdrewcon(e,tp)
end
function ref.fusfilter(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function ref.fustg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetFusionMaterial(tp)
	if chk==0 then return aux.IsCanFusionSummon(ref.fusfilter,e,tp,mg) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function ref.fusop(e,tp,eg,ep,ev,re,r,rp)
	aux.PerformFusionSummon(ref.fusfilter,e,tp,mg)
end
