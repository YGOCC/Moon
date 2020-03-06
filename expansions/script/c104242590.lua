--Moon's Dream: Child of Night
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
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,cid.ponyfilter,2,true)
	aux.AddContactFusionProcedure(c,cid.ponyfilter,LOCATION_REMOVED,0,Duel.SendtoGrave,REASON_MATERIAL)
	--banish as punishment
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(39823987,0))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,id+1000)
	e2:SetTarget(cid.destg)
	e2:SetOperation(cid.desop)
	c:RegisterEffect(e2)
end
function cid.ponyfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x666) and c:IsCanBeFusionMaterial()
end
function cid.spfilter(c,e,tp)
	return c:IsCode(id+1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
--banish as punishment
function cid.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local tc=e:GetHandler():GetReasonCard()
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,tc,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cid.desop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		local g=Duel.GetFirstMatchingCard(cid.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
			if g then
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end
	local c=e:GetHandler()
		local tc=e:GetHandler():GetReasonCard() or (e:GetHandler():GetReasonEffect() and e:GetHandler():GetReasonEffect():GetHandler())
			if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 then
				Duel.Damage(1-tp,1000,REASON_EFFECT)
					local sc=Duel.CreateToken(tp,104242585)
						sc:SetCardData(CARDDATA_TYPE,sc:GetType()-TYPE_TOKEN)
							Duel.Remove(sc,POS_FACEUP,REASON_EFFECT)
end
end