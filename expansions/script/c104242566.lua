--Moon's Dream, Wish Maker
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cod=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cod
end
local id,cid=getID()
function cid.initial_effect(c)
	--Back Row effect
	local exxx=Effect.CreateEffect(c)
	exxx:SetDescription(aux.Stringid(33731070,0))
	exxx:SetCategory(CATEGORY_SPECIAL_SUMMON)
	exxx:SetType(EFFECT_TYPE_IGNITION)
	exxx:SetRange(LOCATION_SZONE)
	exxx:SetCountLimit(1,id+2000)
	exxx:SetCondition(cid.exxxcon)
	exxx:SetCondition(aux.exccon)
	exxx:SetTarget(cid.exxxtg)
	exxx:SetOperation(cid.exxxop)
	c:RegisterEffect(exxx)
		--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCondition(cid.sprcon)
	c:RegisterEffect(e1)
		--bounce and sp summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCountLimit(1,id+1000)
	e2:SetCost(cid.backcost)
	e2:SetTarget(cid.sptg)
	e2:SetOperation(cid.spop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(id,ACTIVITY_SPSUMMON,cid.counterfilter)
end
--Filters
function cid.exxxfilter(c)
	return c:IsSetCard(0x666) and c:IsDiscardable()
end
function cid.searchfilter(c)
	return c:IsSetCard(0x666)
end
function cid.tokenfilter(c)
	return c:IsFaceup() and c:IsCode(104242592)
end
function cid.sprcon(e)
    return Duel.GetLocationCount(e:GetHandlerPlayer(),LOCATION_MZONE)>=5
end
function cid.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x666)
end
function cid.counterfilter(c)
	return c:IsSetCard(0x666)
end
--Back Row Summon
function cid.exxxcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(e:GetHandler():IsSetCard(0x666))>0
end
function cid.exxxtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cid.exxxop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
		local sc=Duel.CreateToken(tp,104242585)
		sc:SetCardData(CARDDATA_TYPE,sc:GetType()-TYPE_TOKEN)
		Duel.Remove(sc,POS_FACEUP,REASON_RULE)
--		sc:SetCardData(CARDDATA_TYPE, sc:GetType()+TYPE_SPELL)
--		Duel.MoveToField(sc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)	
end
--Back Row Cost
function cid.backcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0  and Duel.GetCustomActivityCount(id,tp,ACTIVITY_SPSUMMON)==0 end
		c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fc0000)
	e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	c:RegisterEffect(e1)
	c:RegisterFlagEffect(c:IsSetCard(0x666),RESET_EVENT+RESETS_STANDARD,0,1)
	local ex=Effect.CreateEffect(e:GetHandler())
	ex:SetType(EFFECT_TYPE_FIELD)
	ex:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	ex:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	ex:SetReset(RESET_PHASE+PHASE_END)
	ex:SetTargetRange(1,0)
	ex:SetLabelObject(e)
	ex:SetTarget(cid.splimit)
	Duel.RegisterEffect(ex,tp)
end
end
function cid.filter(c,e,tp)
	return c:IsSetCard(0x666) and not c:IsCode(id) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cid.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cid.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cid.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cid.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		end
		Duel.SpecialSummonComplete()
		end
		local sc=Duel.CreateToken(tp,104242585)
		sc:SetCardData(CARDDATA_TYPE,sc:GetType()-TYPE_TOKEN)
		Duel.Remove(sc,POS_FACEUP,REASON_RULE)
--		sc:SetCardData(CARDDATA_TYPE, sc:GetType()+TYPE_SPELL)
--		Duel.MoveToField(sc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)

end