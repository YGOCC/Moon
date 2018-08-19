--Roots Trap Hole
--Keddy was here~
local function ID()
    local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
    str=string.sub(str,1,string.len(str)-4)
    local cod=_G[str]
    local id=tonumber(string.sub(str,2))
    return id,cod
end

local id,cod=ID()
function cod.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(cod.activate)
	c:RegisterEffect(e1)
	--SP Restrict
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMING_SPSUMMON)
	e2:SetCost(cod.rscost)
	e2:SetCondition(cod.rscon)
	e2:SetOperation(cod.rsop)
	c:RegisterEffect(e2)
	if not cod.global_check then
		cod.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetLabelObject(e2)
		ge1:SetOperation(cod.regop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetLabelObject(e2)
		ge2:SetOperation(function (e,tp,eg,ep,ev,re,r,rp) return e:GetLabelObject():SetLabel(0) end)
		Duel.RegisterEffect(ge2,0)
	end
end

--Activate
function cod.cfilter(c)
	return (c:IsCode(52894709) or c:IsCode(52894703)) and c:IsAbleToHand()
end
function cod.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cod.cfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if #g<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:Select(tp,1,1,nil)
	if #sg>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
end

--Restrict
function cod.sfilter(c,tp)
	return c:IsType(TYPE_LINK) and c:GetSummonType(SUMMON_TYPE_LINK) and c:IsControler(1-tp)
end
function cod.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if eg:IsExists(cod.sfilter,1,nil,tp) then
		e:GetLabelObject():SetLabel(1)
	end
end
function cod.mfilter(c)
	return c:IsSetCard(0xf07a) and c:IsAbleToGrave()
end
function cod.rscost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemove()
		and Duel.IsExistingMatchingCard(cod.mfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cod.mfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.Remove(c,POS_FACEUP,REASON_COST)
	Duel.SendtoGrave(g,REASON_COST)
end
function cod.rscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabel()==1
end
function cod.rsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(0,1)
    e1:SetTarget(cod.splimit)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
	Duel.ResetFlagEffect(tp,id)
end
function cod.splimit(e,c,sump,sumtype,sumpos,targetp,se)
    return c:IsLocation(LOCATION_EXTRA)
end