--La Grande Strega degli AoJ - Flaric Ebona
--Script by XGlitchy30
function c19772604.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedureLevelFree(c,c19772604.matfilter,c19772604.xyzcheck,2,2)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c,false)
	--PENDULUM EFFECTS
	--scale
	local e1p=Effect.CreateEffect(c)
	e1p:SetType(EFFECT_TYPE_SINGLE)
	e1p:SetCode(EFFECT_CHANGE_LSCALE)
	e1p:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1p:SetRange(LOCATION_PZONE)
	e1p:SetCondition(c19772604.slcon)
	e1p:SetValue(3)
	c:RegisterEffect(e1p)
	local e2p=e1p:Clone()
	e2p:SetCode(EFFECT_CHANGE_RSCALE)
	c:RegisterEffect(e2p)
	--damage
	local e3p=Effect.CreateEffect(c)
	e3p:SetDescription(aux.Stringid(19772604,0))
	e3p:SetCategory(CATEGORY_DAMAGE)
	e3p:SetType(EFFECT_TYPE_QUICK_O)
	e3p:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3p:SetCode(EVENT_FREE_CHAIN)
	e3p:SetRange(LOCATION_PZONE)
	e3p:SetCountLimit(1,19772604)
	e3p:SetCondition(c19772604.dmgcon)
	e3p:SetCost(c19772604.dmgcost)
	e3p:SetTarget(c19772604.dmgtg)
	e3p:SetOperation(c19772604.dmgop)
	c:RegisterEffect(e3p)
	--MONSTER EFFECTS
	--spsummon damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(19772604,1))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c19772604.thcon)
	e1:SetCost(c19772604.thcost)
	e1:SetTarget(c19772604.thtg)
	e1:SetOperation(c19772604.thop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(19772604,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c19772604.spsumcost)
	e2:SetTarget(c19772604.spsumtg)
	e2:SetOperation(c19772604.spsumop)
	c:RegisterEffect(e2)
	--pendulum zone
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(19772604,3))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(2,11772604+EFFECT_COUNT_CODE_DUEL)
	e3:SetCondition(c19772604.pendlcon)
	e3:SetCost(c19772604.pendlcost)
	e3:SetTarget(c19772604.pendltg)
	e3:SetOperation(c19772604.pendlop)
	c:RegisterEffect(e3)
end
c19772604.pendulum_level=4
--xyz procedure
function c19772604.matfilter(c,xyzc)
	return c:IsType(TYPE_XYZ) and c:IsRace(RACE_WARRIOR) and c:GetRank()==4
end
function c19772604.xyzcheck(g)
	return g:GetClassCount(Card.GetRank)==1
end
--filters
function c19772604.slfilter(c)
	return c:IsCode(19772602)
end
function c19772604.spsumfilter(c,e,tp)
	return c:GetLevel()==4 and c:IsSetCard(0x197) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
--scale
function c19772604.slcon(e)
	return Duel.IsExistingMatchingCard(c19772604.slfilter,e:GetHandlerPlayer(),LOCATION_PZONE,0,1,e:GetHandler())
end
--damage
function c19772604.dmgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function c19772604.dmgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsAbleToGraveAsCost,1,1,REASON_COST)
end
function c19772604.dmgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function c19772604.dmgop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
--spsummon damage
function c19772604.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c19772604.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,nil,1,nil) end
	local sg=Duel.SelectReleaseGroup(tp,nil,1,1,nil)
	e:SetLabel(sg:GetFirst():GetTextDefense()/2)
	Duel.Release(sg,REASON_COST)
end
function c19772604.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(e:GetLabel())
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,e:GetLabel())
end
function c19772604.thop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
--spsummon
function c19772604.spsumcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c19772604.spsumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c19772604.spsumfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c19772604.spsumop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c19772604.spsumfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		local lv=Duel.GetOperatedGroup():GetFirst():GetLevel()
		Duel.BreakEffect()
		Duel.Damage(1-tp,lv*200,REASON_EFFECT)
	end
end
--pendulum zone
function c19772604.pendlcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c19772604.pendlcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,LOCATION_PZONE)
	if chk==0 then return g:GetCount()>0 end
	Duel.SendtoGrave(g,REASON_COST)
end
function c19772604.pendltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c19772604.pendlop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end