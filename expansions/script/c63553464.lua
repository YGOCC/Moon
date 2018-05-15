--Inferioringranaggio - BLaDe
--Script by XGlitchy30
function c63553464.initial_effect(c)
	--Set as Continuous Trap
	local set=Effect.CreateEffect(c)
	set:SetDescription(aux.Stringid(63553464,0))
	set:SetType(EFFECT_TYPE_FIELD)
	set:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	set:SetCode(EFFECT_SPSUMMON_PROC_G)
	set:SetRange(LOCATION_HAND)
	set:SetCondition(c63553464.setcon)
	set:SetOperation(c63553464.setop)
	c:RegisterEffect(set)
	--Keeps the Trap on the field after being activated
	local kp=Effect.CreateEffect(c)
	kp:SetType(EFFECT_TYPE_SINGLE)
	kp:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(kp)
	--Spsummon Mechanic
	local ge6=Effect.CreateEffect(c)
	ge6:SetType(EFFECT_TYPE_FIELD)
	ge6:SetCode(EFFECT_SPSUMMON_PROC_G)
	ge6:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	ge6:SetRange(LOCATION_SZONE)
	ge6:SetCountLimit(1,10000000)
	ge6:SetCondition(c63553464.p_cond)
	ge6:SetCost(c63553464.p_cost)
	ge6:SetOperation(c63553464.p_op)
	ge6:SetValue(916332)
	c:RegisterEffect(ge6)
	--Redirect to Extra Deck after being destroyed
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
	e0:SetCode(EVENT_LEAVE_FIELD_P)
	e0:SetOperation(c63553464.toextra)
	c:RegisterEffect(e0)
	--Cancel PENDULUM Form after leaving ED
	local sp=Effect.CreateEffect(c)
	sp:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	sp:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
	sp:SetCode(EVENT_SPSUMMON_SUCCESS)
	sp:SetCondition(c63553464.presetcon)
	sp:SetOperation(c63553464.preset)
	c:RegisterEffect(sp)
	local th=Effect.CreateEffect(c)
	th:SetDescription(aux.Stringid(87774234,0))
	th:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	th:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
	th:SetCode(EVENT_TO_HAND)
	th:SetCondition(c63553464.presetcon)
	th:SetOperation(c63553464.preset)
	c:RegisterEffect(th)
	local td=th:Clone()
	td:SetCode(EVENT_TO_DECK)
	c:RegisterEffect(td)
	local rem=th:Clone()
	rem:SetCode(EVENT_REMOVE)
	c:RegisterEffect(rem)
	--Activate as Trap Card
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c63553464.p_act_cond)
	e1:SetTarget(c63553464.p_act_tg)
	e1:SetOperation(c63553464.operation)
	c:RegisterEffect(e1)
	--TRAP EFFECT
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(63553464,1))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCost(c63553464.tpcost)
	e2:SetTarget(c63553464.tptarget)
	e2:SetOperation(c63553464.operation)
	c:RegisterEffect(e2)
	--MONSTER EFFECTS
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_BATTLE_DESTROYED)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,63553464)
	e3:SetCondition(c63553464.con)
	e3:SetTarget(c63553464.tg)
	e3:SetOperation(c63553464.op)
	c:RegisterEffect(e3)
	--pierce
	local prc=Effect.CreateEffect(c)
	prc:SetType(EFFECT_TYPE_SINGLE)
	prc:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(prc)
	--place counter
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_BATTLE_DAMAGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c63553464.ctrcon)
	e4:SetOperation(c63553464.ctrop)
	c:RegisterEffect(e4)
	--search
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetTarget(c63553464.sctg)
	e5:SetOperation(c63553464.scop)
	c:RegisterEffect(e5)
	Duel.AddCustomActivityCounter(63553464,ACTIVITY_SPSUMMON,c63553464.counterfilter)
end
--custom parameters
c63553464.pendulum_level=0   
c63553464.pcheck=true   --if "true" the monster will be treated as a Pandemonium card
c63553464.pscale1=4   --Left Pandemonium Scale
c63553464.pscale2=9   --Right Pandemonium Scale
--filters
function c63553464.tpcostfilter(c)
	return c:GetCounter(0x4554)>0
end
function c63553464.posfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c63553464.scfilter(c)
	return c:IsSetCard(0x4554) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c63553464.scfilter2(c)
	return c:IsSetCard(0x4554) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
--Activate as Trap Card
function c63553464.p_act_cond(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c63553464.p_act_check,tp,LOCATION_SZONE,0,1,e:GetHandler())
end
function c63553464.p_act_check(c)
	return c:IsFaceup() and c.pcheck==true
end
--Set as Trap
function c63553464.setcon(c,e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
end
function c63553464.setop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.MoveToField(c,c:GetControler(),c:GetControler(),LOCATION_SZONE,POS_FACEDOWN_ATTACK,nil)
	Card.SetCardData(c,CARDDATA_TYPE,TYPE_TRAP+TYPE_CONTINUOUS)
	Duel.RaiseEvent(c,EVENT_SSET,e,REASON_RULE,c:GetControler(),c:GetControler(),0)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_TRIGGER)
	e1:SetReset(RESET_EVENT+0x17a0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
--Spsummon Mechanic (ALMOST COMPLETED)
function c63553464.counterfilter(c)
	return not c:IsSummonType(SUMMON_TYPE_PENDULUM)
end
function c63553464.p_cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(63553464,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c63553464.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c63553464.p_filter(c,e,tp,lscale,rscale)
	local lv=0
	if c63553464.pendulum_level>0 then
		lv=c63553464.pendulum_level
	else
		lv=c:GetLevel()
	end
	return (c:IsLocation(LOCATION_HAND) or (c:IsFaceup() and c63553464.pcheck==true))
		and lv>lscale and lv<rscale and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SPECIAL+916332,tp,false,false)
		and not c:IsForbidden()
end
function c63553464.p_cond(e,c,og)
	if c==nil then return true end
	local tp=c:GetControler()
	local lscale=c63553464.pscale1
	local rscale=c63553464.pscale2
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local loc=0
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_HAND end
	if Duel.GetLocationCountFromEx(tp)>0 then loc=loc+LOCATION_EXTRA end
	if loc==0 then return false end
	local g=nil
	if og then
		g=og:Filter(Card.IsLocation,nil,loc)
	else
		g=Duel.GetFieldGroup(tp,loc,0)
	end
	return g:IsExists(c63553464.p_filter,1,nil,e,tp,lscale,rscale)
end
function c63553464.p_op(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
	local lscale=c63553464.pscale1
	local rscale=c63553464.pscale2
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCountFromEx(tp)
	local ft=Duel.GetUsableMZoneCount(tp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then
		if ft1>0 then ft1=1 end
		if ft2>0 then ft2=1 end
		ft=1
	end
	local loc=0
	if ft1>0 then loc=loc+LOCATION_HAND end
	if ft2>0 then loc=loc+LOCATION_EXTRA end
	local tg=nil
	if og then
		tg=og:Filter(Card.IsLocation,nil,loc):Filter(c63553464.p_filter,nil,e,tp,lscale,rscale)
	else
		tg=Duel.GetMatchingGroup(c63553464.p_filter,tp,loc,0,nil,e,tp,lscale,rscale)
	end
	ft1=math.min(ft1,tg:FilterCount(Card.IsLocation,nil,LOCATION_HAND))
	ft2=math.min(ft2,tg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA))
	local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
	if ect and ect<ft2 then ft2=ect end
	while true do
		local ct1=tg:FilterCount(Card.IsLocation,nil,LOCATION_HAND)
		local ct2=tg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)
		local ct=ft
		if ct1>ft1 then ct=math.min(ct,ft1) end
		if ct2>ft2 then ct=math.min(ct,ft2) end
		if ct<=0 then break end
		if sg:GetCount()>0 and not Duel.SelectYesNo(tp,210) then ft=0 break end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=tg:Select(tp,1,ct,nil)
		tg:Sub(g)
		sg:Merge(g)
		if g:GetCount()<ct then ft=0 break end
		ft=ft-g:GetCount()
		ft1=ft1-g:FilterCount(Card.IsLocation,nil,LOCATION_HAND)
		ft2=ft2-g:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)
	end
	if ft>0 then
		local tg1=tg:Filter(Card.IsLocation,nil,LOCATION_HAND)
		local tg2=tg:Filter(Card.IsLocation,nil,LOCATION_EXTRA)
		if ft1>0 and ft2==0 and tg1:GetCount()>0 and (sg:GetCount()==0 or Duel.SelectYesNo(tp,210)) then
			local ct=math.min(ft1,ft)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=tg1:Select(tp,1,ct,nil)
			sg:Merge(g)
		end
		if ft1==0 and ft2>0 and tg2:GetCount()>0 and (sg:GetCount()==0 or Duel.SelectYesNo(tp,210)) then
			local ct=math.min(ft2,ft)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=tg2:Select(tp,1,ct,nil)
			sg:Merge(g)
		end
	end
	Duel.HintSelection(Group.FromCards(c))
	Duel.Destroy(e:GetHandler(),REASON_RULE)
end
---
function c63553464.descon(e)
	return e:GetHandler():GetFlagEffect(327)>0
end
--Prevent PENDULUM Summoning
function c63553464.splimit(e,c,tp,sumtp,sumpos)
	return bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
--Redirect to Extra Deck (STILL NOT COMPLETE)
function c63553464.toextra(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsReason(REASON_DESTROY) then
		Card.SetCardData(e:GetHandler(),CARDDATA_TYPE,TYPE_MONSTER+TYPE_EFFECT+TYPE_PENDULUM)
	end
end
--Cancel PENDULUM Form
function c63553464.presetcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_EXTRA)
end
function c63553464.preset(e,tp,eg,ep,ev,re,r,rp)
	Card.SetCardData(e:GetHandler(),CARDDATA_TYPE,TYPE_MONSTER+TYPE_EFFECT)
end
-----
function c63553464.p_act_tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	if c63553464.tpcost(e,tp,eg,ep,ev,re,r,rp,0)
		and Duel.IsExistingMatchingCard(c63553464.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		and Duel.SelectYesNo(tp,94) then
		c63553464.tpcost(e,tp,eg,ep,ev,re,r,rp,1)
		e:SetCategory(CATEGORY_POSITION)
		c:RegisterFlagEffect(63553464,RESET_PHASE+PHASE_END,0,1)
		c:RegisterFlagEffect(0,RESET_CHAIN,EFFECT_FLAG_CLIENT_HINT,1,0,65)
	else
		e:SetCategory(0)
	end
end
function c63553464.tpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c63553464.tpcostfilter,1,nil) end
	local cg=Duel.SelectReleaseGroup(tp,c63553464.tpcostfilter,1,1,nil)
	e:SetLabel(cg:GetFirst():GetCounter(0x4554))
	Duel.Release(cg,REASON_COST)
end
function c63553464.tptarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetFieldGroupCount(1-tp,LOCATION_MZONE,0)
	local sum=e:GetLabel()
	if sum>ft then
		sum=ft
	end
	if chk==0 then return Duel.IsExistingMatchingCard(c63553464.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,tp,LOCATION_MZONE)
	e:GetHandler():RegisterFlagEffect(63553464,RESET_PHASE+PHASE_END,0,1)
end
function c63553464.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(63553464)~=0 or not e:GetHandler():IsRelateToEffect(e) then return end
	local ft=Duel.GetFieldGroupCount(1-tp,LOCATION_MZONE,0)
	local sum=e:GetLabel()
	if sum<=0 then return end
	if sum>ft then
		sum=ft
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c63553464.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,sum,nil)
	if g:GetCount()>0 then
		Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
	end
end
--set on field (effect)
function c63553464.cfilter(c,tp)
	return c:IsRace(RACE_MACHINE) and c:GetPreviousControler()==tp
end
function c63553464.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c63553464.cfilter,1,nil,tp)
end
function c63553464.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c63553464.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.MoveToField(c,c:GetControler(),c:GetControler(),LOCATION_SZONE,POS_FACEDOWN_ATTACK,nil)
	Card.SetCardData(c,CARDDATA_TYPE,TYPE_TRAP+TYPE_CONTINUOUS)
end
--place counter
function c63553464.ctrcon(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp then return false end
	local rc=eg:GetFirst()
	return rc==e:GetHandler()
end
function c63553464.ctrop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c63553464.scfilter2,tp,LOCATION_DECK,0,1,nil) then return end
	e:GetHandler():AddCounter(0x4554,1)
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c63553464.scfilter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--search
function c63553464.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c63553464.scfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c63553464.scop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c63553464.scfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end