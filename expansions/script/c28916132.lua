--This file was automatically coded by Kinny's Numeron Code~!
--You only did half, Kinny did the other.
local ref=_G['c'..28916132]
local id=28916132
function ref.initial_effect(c)
	--Effect 0
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_TOHAND+CATEGORY_DRAW)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCountLimit(1,id)
	e0:SetCost(ref.cost0)
	e0:SetTarget(ref.target0)
	e0:SetOperation(ref.operation0)
	c:RegisterEffect(e0)
	--Fusion
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+EFFECT_COUNT_SECOND_HOPT)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(ref.fustg)
	e2:SetOperation(ref.fusop)
	c:RegisterEffect(e2)
end
function ref.filterE0P0(c)
	return c:IsSetCard(1854) and c:IsDiscardable()
end
function ref.cost0(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.IsPlayerAffectedByEffect(tp,EFFECT_DISCARD_COST_CHANGE) then return true end
	if chk==0 then return Duel.IsExistingMatchingCard(ref.filterE0P0,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,ref.filterE0P0,tp,1,1,nil)
end
function ref.target0(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,2,tp,0)
	if not aux.cdrewcon(e,tp) then
		Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	end
end
function ref.operation0(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Draw(tp,2,REASON_EFFECT)
	if not aux.cdrewcon(e,tp) then
		Duel.DiscardHand(tp,nil,tp,1,1,nil)
	end
end

--Fusion Summon
function ref.fusfilter(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(1854) and (not f or f(c))
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
