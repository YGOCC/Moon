--Penguin Queen
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cid=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cid
end
local id,cid=getID()
function cid.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(1164)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
    e1:SetRange(LOCATION_EXTRA)
    e1:SetCondition(Auxiliary.SynCondition(aux.FilterBoolFunction(Card.IsRace,RACE_AQUA),aux.NonTuner(Card.IsRace,RACE_AQUA),1,99))
    e1:SetTarget(Auxiliary.SynTarget(aux.FilterBoolFunction(Card.IsRace,RACE_AQUA),aux.NonTuner(Card.IsRace,RACE_AQUA),1,99))
    e1:SetOperation(cid.synop(aux.FilterBoolFunction(Card.IsRace,RACE_AQUA),aux.NonTuner(Card.IsRace,RACE_AQUA),1,99))
    e1:SetValue(SUMMON_TYPE_SYNCHRO)
    e1:SetTargetRange(POS_FACEDOWN_DEFENSE,1)
    c:RegisterEffect(e1)
	--Bounce
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SSET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id)
	e3:SetTarget(cid.thtg)
	e3:SetOperation(cid.thop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_MSET)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
                e5:SetCondition(cid.condition)
	c:RegisterEffect(e5)
	local e6=e3:Clone()
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_FLIP)
                e6:SetCountLimit(1,id+10000)
	c:RegisterEffect(e6)
end
function cid.synop(f1,f2,minct,maxc)
	return	function(e,tp,eg,ep,ev,re,r,rp,c,smat,mg,min,max)
				local g=e:GetLabelObject()
				c:SetMaterial(g)
				Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
				g:DeleteGroup()
                                                                Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)
                                                                Duel.ConfirmCards(1-tp,e:GetHandler())
			end
end
function cid.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsFacedown,1,nil)
end
function cid.thfilter(c)
    return c:IsAbleToHand()
end
function cid.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_ONFIELD)
end
function cid.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
    local g=Duel.SelectMatchingCard(tp,cid.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
    end
end
