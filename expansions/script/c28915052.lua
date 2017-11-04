--Feather Bearer
--Design and Code by Kindrindra
local ref=_G['c'..28915052]
function ref.initial_effect(c)
	--Search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(28915052,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,28915052)
	e2:SetTarget(ref.thtg)
	e2:SetOperation(ref.thop)
	c:RegisterEffect(e2)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=e2:Clone()
	e5:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e5)
	--Reorder
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(28915052,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_REMOVE)
	e3:SetTarget(ref.sttg)
	e3:SetOperation(ref.stop)
	c:RegisterEffect(e3)
end

function ref.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(ref.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function ref.thfilter(c)
	return c:IsRace(RACE_DRAGON) and c:IsAbleToHand()
end
function ref.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(ref.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetCode)>=3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local sg1=g:Select(tp,1,1,nil)
		g:Remove(Card.IsCode,nil,sg1:GetFirst():GetCode())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local sg2=g:Select(tp,1,1,nil)
		g:Remove(Card.IsCode,nil,sg2:GetFirst():GetCode())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local sg3=g:Select(tp,1,1,nil)
		sg1:Merge(sg2)
		sg1:Merge(sg3)
		Duel.ConfirmCards(1-tp,sg1)
		local sc=sg1:Select(1-tp,1,1,nil)
		if sc then
			Duel.SendtoHand(sc,nil,REASON_EFFECT)
		end
	end
end

function ref.lvfilter(c,lv)
	return c:GetLevel()==lv
end
function ref.stfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsLevelAbove(0) and c:IsAbleToDeck()
end
function ref.sttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and ref.stfilter(chkc) end
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(ref.stfilter,tp,LOCATION_GRAVE,0,1,c) end
	local g=Duel.GetMatchingGroup(ref.stfilter,tp,LOCATION_GRAVE,0,c):Filter(Card.IsCanBeEffectTarget,nil,e)
	local tg=Group.CreateGroup()
	repeat
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local sg=g:Select(tp,1,1,nil)
		tg:Merge(sg)
		g:Remove(ref.lvfilter,nil,sg:GetFirst():GetLevel())
	until tg:GetCount()==3 or g:GetCount()==0 or not Duel.SelectYesNo(tp,aux.Stringid(28915052,2))
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,tg,tg:GetCount(),0,0)
end
function ref.stop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if Duel.SendtoDeck(g,nil,0,REASON_EFFECT) then
		local ct=g:Filter(Card.IsLocation,nil,LOCATION_DECK):GetCount()
		Duel.SortDecktop(tp,tp,ct)
	end
end