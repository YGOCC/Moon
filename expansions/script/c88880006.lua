--Earth Core of the Mecha Blades
local m=88880006
local cm=_G["c"..m]
function cm.initial_effect(c)
--xyz summon
    aux.AddXyzProcedure(c,cm.mfilter,4,2,cm.ovfilter,aux.Stringid(88880006,0),2,cm.xyzop)
    c:EnableReviveLimit()
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(88880006,2))
    e1:SetCategory(CATEGORY_RECOVER)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_GRAVE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,88880006)
    e1:SetCost(aux.bfgcost)
    e1:SetTarget(cm.target2)
    e1:SetOperation(cm.activate2)
    c:RegisterEffect(e1)
    --Activate
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetHintTiming(0,TIMING_END_PHASE)
    e2:SetCountLimit(1,8888006)
	e2:SetCondition(cm.tgcon)
    e2:SetCost(cm.spcost)
    e2:SetTarget(cm.target)
    e2:SetOperation(cm.activate)
    c:RegisterEffect(e2)
end
--Filters
function cm.filter1(c,e,tp)
    return c:IsCanBeEffectTarget(e) and c:IsSetCard(0xffd) and c:GetLevel(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.xyzfilter(c,mg,tp,e)
	return (c:IsSetCard(0xffd) and Duel.GetLocationCountFromEx(tp)<=0 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,true,true)) or (c:IsSetCard(0xffd) and c:IsXyzSummonable(mg,2,2))
end
function cm.mfilter1(c,mg,exg)
    return mg:IsExists(cm.mfilter2,1,c,c,exg)
end
function cm.mfilter2(c,mc,exg)
    return exg:IsExists(Card.IsXyzSummonable,1,nil,Group.FromCards(c,mc))
end
function cm.filter2(c,e,tp)
    return c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.mfilter(c)
    return c:IsSetCard(0xffd)
end
function cm.cfilter(c)
    return c:IsSetCard(0xffd)
end
function cm.ovfilter(c)
    return c:IsFaceup() and c:IsSetCard(0xffd) and not c:IsType(TYPE_XYZ)
end
function cm.filter(c)
    return c:IsSetCard(0xffd) and c:IsAbleToHand()
end
--Xyz Summon
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:GetOverlayCount()>0 and Duel.GetTurnPlayer()==1-tp
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsReleasable() end
    Duel.Release(e:GetHandler(),REASON_COST)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return false end
    local mg=Duel.GetMatchingGroup(cm.filter1,tp,LOCATION_GRAVE,0,nil,e,tp)
    local exg=Duel.GetMatchingGroup(cm.xyzfilter,tp,LOCATION_EXTRA,0,nil,mg,tp,e)
    if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
        and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and exg:GetCount()>0
	end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local sg1=mg:FilterSelect(tp,cm.mfilter1,1,1,nil,mg,exg)
    local tc1=sg1:GetFirst()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local sg2=mg:FilterSelect(tp,cm.mfilter2,1,1,tc1,tc1,exg)
    sg1:Merge(sg2)
    Duel.SetTargetCard(sg1)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg1,2,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 or Duel.GetLocationCountFromEx(tp)<=0 then return end
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(cm.filter2,nil,e,tp)
    if g:GetCount()<2 then return end
    local tc=g:GetFirst()
    while tc do
        Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e1)
        local e2=e1:Clone()
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        tc:RegisterEffect(e2)
        tc=g:GetNext()
    end
    Duel.SpecialSummonComplete()
    local xyzg=Duel.GetMatchingGroup(cm.xyzfilter,tp,LOCATION_EXTRA,0,nil,g)
    if xyzg:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
        Duel.XyzSummon(tp,xyz,g)
    end
end
function cm.xyzop(e,tp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND,0,1,nil)
    and Duel.GetFlagEffect(tp,88880006)==0 end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
    local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_HAND,0,1,1,nil)
    if g:GetCount()>=0 then
        Duel.Overlay(e:GetHandler(),g)
    end
end
-----
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function cm.activate2(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end