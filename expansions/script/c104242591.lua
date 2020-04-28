--Moon's Dream: Child of Light
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cod=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cod
end
local id,cid=getID()
function cid.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local ponysummon=Effect.CreateEffect(c)
	ponysummon:SetType(EFFECT_TYPE_FIELD)
	ponysummon:SetCode(EFFECT_SPSUMMON_PROC)
	ponysummon:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	ponysummon:SetRange(LOCATION_EXTRA)
	ponysummon:SetCondition(cid.sstg)
	ponysummon:SetOperation(cid.ssop)
	c:RegisterEffect(ponysummon)
	--banish as punishment
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(39823987,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,id+1000)
	e2:SetTarget(cid.destg)
	e2:SetOperation(cid.desop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetOperation(function(e) e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,0,1,Duel.GetTurnCount()) end)
	c:RegisterEffect(e3)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCountLimit(1,id)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCondition(cid.spcon)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk) if chk==0 then return true end Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE) end)
	e1:SetOperation(cid.spop)
	c:RegisterEffect(e1)
end
function cid.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
--	if c==nil then return true end
	local c=e:GetHandler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cid.ponyfilter,tp,LOCATION_MZONE+LOCATION_EXTRA,0,2,c)
end
function cid.ssop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g=Duel.SelectMatchingCard(tp,cid.ponyfilter,tp,LOCATION_MZONE+LOCATION_EXTRA,0,2,2,nil)
	Duel.SendtoGrave(g,REASON_COST+REASON_MATERIAL)
end
--Filters
function cid.ponyfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x666) and c:IsCanBeFusionMaterial()
end
function cid.spfilter(c,e,tp)
	return c:IsCode(id-1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
--banish as punishment
function cid.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
	if not e:GetHandler():IsReason(REASON_BATTLE) then Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler():GetReasonCard(),1,0,0) end
end
function cid.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Recover(tp,1000,REASON_EFFECT)
	local sc=Duel.CreateToken(tp,104242585)
	sc:SetCardData(CARDDATA_TYPE,sc:GetType()-TYPE_TOKEN)
	Duel.Remove(sc,POS_FACEUP,REASON_EFFECT)
	if c:IsReason(REASON_BATTLE) then return end
	Duel.BreakEffect()
	Duel.Destroy(c:GetReasonCard() or (c:GetReasonEffect() and c:GetReasonEffect():GetHandler()),REASON_EFFECT)
end
function cid.spcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler()
	return tc:GetFlagEffect(id)~=0 and Duel.GetTurnCount()~=tc:GetFlagEffectLabel(id)
end
function cid.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return true end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cid.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		local g=Duel.GetFirstMatchingCard(cid.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
			if g then
				Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

