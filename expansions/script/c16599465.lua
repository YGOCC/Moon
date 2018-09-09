--Tertius dell'Organizzazione Angeli, Brinace
--Script by XGlitchy30
function c16599465.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_FAIRY),aux.NonTuner(Card.IsRace,RACE_FAIRY),1)
	c:EnableReviveLimit()
	--target protection
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetValue(c16599465.efilter)
	c:RegisterEffect(e0)
	--bounce set cards
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCondition(c16599465.thcon)
	e1:SetCost(c16599465.thcost)
	e1:SetTarget(c16599465.thtg)
	e1:SetOperation(c16599465.thop)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c16599465.damcon)
	e2:SetTarget(c16599465.damtg)
	e2:SetOperation(c16599465.damop)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_REMOVE)
	e3:SetCountLimit(1,16599465)
	e3:SetCondition(c16599465.sccon)
	e3:SetCost(c16599465.sccost)
	e3:SetTarget(c16599465.sctg)
	e3:SetOperation(c16599465.scop)
	c:RegisterEffect(e3)
end
--filters
function c16599465.mfilter(c,tp,sync)
	return c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE)
		and bit.band(c:GetReason(),0x80008)==0x80008 and c:GetReasonCard()==sync
		and c:IsAbleToRemoveAsCost()
end
function c16599465.thfilter(c)
	return c:IsFacedown() and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c16599465.costfilter(c)
	return c:IsRace(RACE_FAIRY) and c:IsAbleToRemoveAsCost()
end
function c16599465.tgfilter(c)
	return c:IsSetCard(0x1559) and c:IsAbleToGrave()
end
function c16599465.scfilter(c)
	return c:IsSetCard(0x1559) and c:IsAbleToHand()
end
function c16599465.exclude(c,card)
	return c==card
end
--target protection
function c16599465.efilter(e,re,rp)
	return ((re:GetHandler():GetLevel()>0 and re:GetHandler():IsLevelBelow(7)) or (re:GetHandler():GetRank()>0 and re:GetHandler():GetRank()<=7)) and rp==1-e:GetHandlerPlayer()
end
--bounce set cards
function c16599465.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c16599465.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local mat=c:GetMaterial()
	local matc=mat:GetCount()
	if chk==0 then return matc>0 and mat:FilterCount(c16599465.mfilter,nil,tp,c)==matc end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=mat:Select(tp,matc,matc,nil)
	if g:GetCount()==matc then
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
end
function c16599465.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c16599465.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local sg=Duel.GetMatchingGroup(c16599465.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,sg:GetCount(),0,0)
end
function c16599465.thop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c16599465.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
end
--draw
function c16599465.damcon(e,tp,eg,ep,ev,re,r,rp)
	local att=Duel.GetAttacker()
	local def=Duel.GetAttackTarget()
	return ep==tp and att and def
		and ((att:GetControler()==tp and att:IsRace(RACE_FAIRY) and att:IsRelateToBattle())
		or (def:GetControler()==tp and def:IsRace(RACE_FAIRY) and def:IsRelateToBattle()))
end
function c16599465.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c16599465.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
--search
function c16599465.sccon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_MONSTER)
		and re:GetHandler():IsRace(RACE_FAIRY) and re:GetHandler():IsType(TYPE_SYNCHRO)
end
function c16599465.sccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c16599465.costfilter,tp,LOCATION_DECK,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c16599465.costfilter,tp,LOCATION_DECK,0,1,1,e:GetHandler())
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
end
function c16599465.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c16599465.tgfilter,tp,LOCATION_HAND,0,1,e:GetHandler())
		and Duel.IsExistingMatchingCard(c16599465.scfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_REMOVED)
end
function c16599465.scop(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetMatchingGroup(c16599465.scfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,nil)
	if dg:GetCount()<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c16599465.tgfilter,tp,LOCATION_HAND,0,1,dg:GetCount(),e:GetHandler())
	if g:GetCount()>0 then
		if Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
			local sc=Group.CreateGroup()
			local op=Duel.GetOperatedGroup()
			local check=op:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)
			if check>0 then
				for i=1,check do
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
					local tc=dg:Select(tp,1,1,nil):GetFirst()
					sc:AddCard(tc)
					dg:Remove(c16599465.exclude,nil,tc)
				end
			end
			if sc:GetCount()==check then
				Duel.SendtoHand(sc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sc)
			end
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c16599465.sumlimit)
	Duel.RegisterEffect(e1,tp)
end
function c16599465.sumlimit(e,c)
	return c:GetRace()~=RACE_FAIRY
end