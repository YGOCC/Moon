local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cod=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cod
end
local id,cid=getID()
function cid.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	c:EnableCounterPermit(0x666)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
	--add card to hand
	local e2=Effect.CreateEffect(c)
    e2:SetCategory(EFFECT_TYPE_FIELD+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_CHAIN_SOLVED)
    e2:SetTarget(cid.searchtg)
    e2:SetOperation(cid.searchop)
    c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(88301833,0))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(cid.drawcon)
	e3:SetTarget(cid.drawtarget)
	e3:SetOperation(cid.drawop)
	--Add counter
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_FZONE)
	e4:SetOperation(cid.addcounter)
	c:RegisterEffect(e4)
	--Destroy replace
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_FZONE)
	e5:SetTarget(cid.desreptg)
	e5:SetOperation(cid.desrepop)
	c:RegisterEffect(e5)
	--fragment
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(45985838,0))
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetCode(EVENT_PHASE+PHASE_END)
	e6:SetRange(LOCATION_FZONE)
	e6:SetCountLimit(1)
	e6:SetCondition(cid.condition)
	e6:SetOperation(cid.fragment)
	c:RegisterEffect(e6)
	 local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e7:SetCode(EVENT_CHAIN_SOLVED)
    e7:SetRange(LOCATION_FZONE)
    e7:SetOperation(cid.acop)
    c:RegisterEffect(e7)
end
function cid.acop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:GetFlagEffect(1)>0 then
            Duel.RaiseSingleEvent(c,EVENT_CUSTOM+id,re,0,0,p,0)
        end
    end
function cid.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function cid.fragment(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,104242585)
	local sc=Duel.CreateToken(tp,104242585)
	sc:SetCardData(CARDDATA_TYPE, sc:GetType()-TYPE_TOKEN)
	Duel.Remove(sc,POS_FACEUP,REASON_RULE)
end
--filters
function cid.ritualfilter(c,tp)
    return  (c:IsSummonType(SUMMON_TYPE_RITUAL) and c:IsControler(tp) and c:IsSetCard(0x666))
	or
	(c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE)
		and c:IsPreviousSetCard(0x666) and c:IsPreviousPosition(POS_FACEUP))
end
function cid.ritualsearchfilter(c)
    return bit.band(c:GetType(),0x82)==0x82 and c:IsAbleToHand() and c:IsSetCard(0x666)
end
--remove counters, don't die
function cid.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsReason(REASON_RULE)
		and e:GetHandler():GetCounter(0x666)>=3 end
	return true
end
function cid.desrepop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveCounter(ep,0x666,3,REASON_EFFECT)
end
--addcounter
function cid.addcounter(e,tp,eg,ep,ev,re,r,rp)
	local c=re:GetHandler()
	local rc=re:GetHandler()
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) and rc:IsSetCard(0x666)  then
		e:GetHandler():AddCounter(0x666,1)
	end
end
--Draw 1 on ritual summon
function cid.drawcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cid.ritualfilter,1,nil)
end
function cid.drawtarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cid.drawop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
--add card to hand
function cid.searchtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cid.ritualsearchfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cid.searchop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOHAND)
    local g=Duel.SelectMatchingCard(tp,cid.ritualsearchfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,REASON_EFFECT,nil)
    end
end