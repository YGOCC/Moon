--Peach Beach Splash Party
function c69013.initial_effect(c)
local  e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c69013.sptg)
	e1:SetOperation(c69013.spop)
	e1:SetCountLimit(1,69013)
	c:RegisterEffect(e1)
end
function c69013.spfilter(c,e,tp)
return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x6969) and c:IsPublic() and Card.IsCanBeSpecialSummoned(c,e,0,tp,false,false)
end
function c69013.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local rev=Duel.GetMatchingGroupCount(c69013.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
    if chk==0 then return rev>0 end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(rev*500)
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rev*500)
end
function c69013.spop(e,tp,eg,ep,ev,re,r,rp)
    local rev=Duel.GetMatchingGroup(c69013.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
    local ct=rev:GetCount()
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    if d<(ct*500) then ct=d end
    if Duel.Recover(p,ct*500,REASON_EFFECT)<=0 then return end
    if ct>=3 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,c69013.spfilter,tp,LOCATION_HAND,0,1,70,nil,e,tp)
        if g:GetCount()>0 then
            Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
        end
    end
end