--Hydraling Alpha
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cod=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cod
end
local id,cid=getID()
function cid.initial_effect(c)
    --My Custom Effect
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_DISABLE)
    e3:SetCode(EVENT_CUSTOM+id)
    e3:SetRange(LOCATION_MZONE)
	e3:SetCost(cid.thcost)
    e3:SetCountLimit(1,id)
    e3:SetCondition(cid.rmcon)
    e3:SetTarget(cid.thtg)
    e3:SetOperation(cid.thop)
    c:RegisterEffect(e3)
    --check disabled status
    if not cid.global_check then
        cid.global_check=true
        local ge1=Effect.CreateEffect(c)
        ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        ge1:SetCode(EVENT_ADJUST)
        ge1:SetOperation(cid.registerop)
        Duel.RegisterEffect(ge1,0)
    end
end
--check disabled status
function cid.registerop(e)
    local c=e:GetHandler()
    local tp=e:GetHandlerPlayer()
    if not c:IsDisabled() then
		if c:GetFlagEffect(id)<=0 then
			c:RegisterFlagEffect(id,RESET_EVENT+EVENT_CUSTOM+222,EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE,1)
			Debug.Message("a")
		end
		if c:GetFlagEffectLabel(id)~=100 then
			c:SetFlagEffectLabel(id,100)
			Debug.Message("b")
		end
    else
		Debug.Message("c")
        local reg=Group.CreateGroup()
		if c:GetFlagEffect(id)<=0 then
			c:RegisterFlagEffect(id,RESET_EVENT+EVENT_CUSTOM+222,EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE,1)
			Debug.Message("d")
		end
		if c:GetFlagEffectLabel(id)~=200 then
			reg:AddCard(c)
			c:SetFlagEffectLabel(id,200)
			Debug.Message("e")
		end
        if reg:GetCount()>0 then
			Debug.Message("f")
            Duel.RaiseEvent(reg,EVENT_CUSTOM+id,e,0,0,0,0)
        end
    end
end
function cid.rmcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsContains(e:GetHandler())
end
function cid.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cid.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function cid.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.IsExistingMatchingCard(cid.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cid.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cid.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end
end