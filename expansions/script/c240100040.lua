--created & coded by Lyris
--集いし襲雷
function c240100040.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCountLimit(1,240100308+EFFECT_COUNT_CODE_OATH)
	e0:SetTarget(c240100040.target)
	e0:SetOperation(c240100040.activate)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DESTROY+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,240100308+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c240100040.con)
	e1:SetTarget(c240100040.tg)
	e1:SetOperation(c240100040.operation)
	c:RegisterEffect(e1)
end
function c240100040.filter0(c)
	return c:IsType(TYPE_EFFECT) and c:IsCanBeFusionMaterial() and c:IsDestructable()
end
function c240100040.filter1(c,e)
	return c:IsType(TYPE_EFFECT) and c:IsCanBeFusionMaterial() and c:IsDestructable() and not c:IsImmuneToEffect(e)
end
function c240100040.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c)) and c:IsRace(RACE_DRAGON)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c240100040.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
		local mg=Group.CreateGroup()
		local mg1=Duel.GetMatchingGroup(c240100040.filter0,tp,LOCATION_DECK,0,nil)
		local tc=mg1:GetFirst()
		while tc do
			mg:AddCard(tc)
			mg1:Remove(Card.IsCode,tc,tc:GetCode())
			tc=mg1:GetNext()
		end
		return Duel.IsExistingMatchingCard(c240100040.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg,nil,chkf)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c240100040.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
	local mg=Duel.GetMatchingGroup(c240100040.filter1,tp,LOCATION_DECK,0,nil,e)
	local mg1=Group.CreateGroup()
	local tc=mg:GetFirst()
	while tc do
		mg1:AddCard(tc)
		mg:Remove(Card.IsCode,tc,tc:GetCode())
		tc=mg:GetNext()
	end
	local sg1=Duel.GetMatchingGroup(c240100040.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	if sg1:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg1:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
		tc:SetMaterial(mat1)
		Duel.Destroy(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function c240100040.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetTurnID()~=Duel.GetTurnCount() and Duel.GetTurnPlayer()==tp
end
function c240100040.filter(c)
	return c:IsSetCard(0x7c4) and c:IsAbleToDeck() and c:IsType(TYPE_MONSTER)
end
function c240100040.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c240100040.filter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingTarget(c240100040.filter,tp,LOCATION_GRAVE,0,3,nil) and e:GetHandler():IsAbleToDeck() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c240100040.filter,tp,LOCATION_GRAVE,0,3,3,nil)
	local g0=g:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g0,4,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c240100040.operation(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if Duel.SendtoDeck(tg,nil,1,REASON_EFFECT)~=0 then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
