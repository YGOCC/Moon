--created by ZEN, coded by TaxingCorn117
--Blood Arts - Erin
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cod=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cod
end
local id,cid=getID()
function cid.initial_effect(c)
	c:SetSPSummonOnce(id)
	--link summon
	aux.AddLinkProcedure(c,cid.mfilter,1,1)
	c:EnableReviveLimit()
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(2318620,1))
	e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_DICE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(cid.sptg)
	e1:SetOperation(cid.spop)
	c:RegisterEffect(e1)
end
function cid.mfilter(c)
	return c:IsLinkSetCard(0x52f)
end
function cid.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK)
end
function cid.checkzone(tp)
	local zone=0
	local g=Duel.GetMatchingGroup(cid.cfilter,tp,LOCATION_MZONE,0,nil)
	for tc in aux.Next(g) do
		zone=bit.bor(zone,tc:GetLinkedZone(tp))
	end
	return bit.band(zone,0x1f)
end
function cid.spfilter(c,e,tp,lv,zone)
	return c:IsLevel(lv) and not c:IsType(TYPE_LINK) and c:IsLocation(LOCATION_GRAVE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function cid.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_GRAVE)
end
function cid.spop(e,tp,eg,ep,ev,re,r,rp)
	local zone=cid.checkzone(tp)
	local dc=Duel.TossDice(tp,1)
	if zone==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.GetMatchingGroup(cid.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,e,tp,dc,zone)
	if Duel.Damage(tp,dc*100,REASON_EFFECT)~=0 and Duel.GetLP(tp)>0 and #g>0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		local sc=sg:GetFirst()
		local p=sc:GetControler()
		if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP,zone)==0 or p==tp then return end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(id)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		sc:RegisterEffect(e1)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CHANGE_RACE)
		e3:SetValue(RACE_FIEND)
		sc:RegisterEffect(e3)
		local e2=e3:Clone()
		e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e2:SetValue(ATTRIBUTE_DARK)
		sc:RegisterEffect(e2)
   end
end
