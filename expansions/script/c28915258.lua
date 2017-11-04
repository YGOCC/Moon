--Shadowflame Calamity
--Design and code by Kindrindra
local ref=_G['c'..28915258]
function ref.initial_effect(c)
	if not ref.global_check then
		ref.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetCountLimit(1)
		ge1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge1:SetOperation(ref.chk)
		Duel.RegisterEffect(ge1,0)
	end
	
	--Alternative Procedure
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e0:SetCountLimit(1,555)
	e0:SetCost(ref.altcost)
	e0:SetOperation(ref.nullop)
	c:RegisterEffect(e0)
	
	--Negate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(ref.negcon)
	e1:SetTarget(ref.negtg)
	e1:SetOperation(ref.negop)
	c:RegisterEffect(e1)
end
ref.blink=true
function ref.material1(c)
	return c:IsSetCard(0x729) and c:IsType(TYPE_TRAP)
end
function ref.material2(c)
	return c:IsType(TYPE_MONSTER)
end
function ref.chk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,555)
	Duel.CreateToken(1-tp,555)
end

function ref.altmatfilter1(c)
	return c:IsSetCard(0x729) and c:IsType(TYPE_SPELL)
		and Duel.IsExistingMatchingCard(ref.matfilter2,tp,LOCATION_HAND,0,1,c)
end
function ref.matfilter2(c)
	return c:IsType(TYPE_MONSTER)
end
function ref.altcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(ref.altmatfilter1,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local mc1=Duel.SelectMatchingCard(tp,ref.altmatfilter1,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local mc2=Duel.SelectMatchingCard(tp,ref.matfilter2,tp,LOCATION_HAND,0,1,1,mc1):GetFirst()
	local mg=Group.FromCards(mc1,mc2)
	c:SetMaterial(mg)
	Duel.SendtoGrave(mg,REASON_DISCARD+REASON_MATERIAL)
	local mc=mg:GetFirst()
	while mc do
		Duel.RaiseSingleEvent(mc,EVENT_CUSTOM+555,e,REASON_DISCARD+REASON_MATERIAL,tp,0,0)
		mc=mg:GetNext()
	end
	Duel.SSet(tp,c)
	Duel.ConfirmCards(1-tp,c)
end
function ref.nullop(e,tp,eg,ep,ev,re,r,rp)
	return
end

function ref.negcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and rp~=tp and g:IsExists(Card.IsControler,1,nil,tp)
		and Duel.IsChainNegatable(ev)
end
function ref.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function ref.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if Duel.IsExistingMatchingCard(ref.ssfilter,tp,LOCATION_DECK,0,1,nil,tp) and Duel.SelectYesNo(tp,aux.Stringid(28915258,0)) then
		local tc=Duel.SelectMatchingCard(tp,ref.ssfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
		if tc then
			tc:SetStatus(STATUS_NO_LEVEL,false)
			local e1=Effect.CreateEffect(tc)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(TYPE_NORMAL+TYPE_MONSTER)
			e1:SetReset(RESET_EVENT+0x47c0000)
			tc:RegisterEffect(e1,true)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_CHANGE_RACE)
			e2:SetValue(RACE_PYRO)
			tc:RegisterEffect(e2,true)
			local e3=e1:Clone()
			e3:SetCode(EFFECT_CHANGE_ATTRIBUTE)
			e3:SetValue(ATTRIBUTE_DARK)
			tc:RegisterEffect(e3,true)
			local e4=e1:Clone()
			e4:SetCode(EFFECT_SET_BASE_ATTACK)
			e4:SetValue(2100)
			tc:RegisterEffect(e4,true)
			local e5=e1:Clone()
			e5:SetCode(EFFECT_SET_BASE_DEFENSE)
			e5:SetValue(500)
			tc:RegisterEffect(e5,true)
			local e6=e1:Clone()
			e6:SetCode(EFFECT_CHANGE_LEVEL)
			e6:SetValue(5)
			tc:RegisterEffect(e6,true)
			Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
		end
	end
end

function ref.contg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and chkc:GetControler()~=tp and chkc:IsControlerCanBeChanged() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function ref.conop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.GetControl(tc,tp,PHASE_END,1)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fc0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end

ref.ODDcount=6
ref.ODDcategory=CATEGORY_SPECIAL_SUMMON
function ref.ODDcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end
function ref.ssfilter(c,tp)
	return c:IsSetCard(0x729) and c:IsType(TYPE_SPELL+TYPE_TRAP)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),nil,0x4107,2400,1000,7,RACE_PYRO,ATTRIBUTE_DARK)
end
function ref.ODDtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(ref.ssfilter,tp,LOCATION_GRAVE,0,1,c,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectTarget(tp,ref.ssfilter,tp,LOCATION_GRAVE,0,1,2,c,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tc,1,tp,LOCATION_GRAVE)
end
function ref.ODDop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=tg:GetFirst()
	while tc do
		tc:SetStatus(STATUS_NO_LEVEL,false)
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(TYPE_NORMAL+TYPE_MONSTER)
		e1:SetReset(RESET_EVENT+0x47c0000)
		tc:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CHANGE_RACE)
		e2:SetValue(RACE_PYRO)
		tc:RegisterEffect(e2,true)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e3:SetValue(ATTRIBUTE_DARK)
		tc:RegisterEffect(e3,true)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_SET_BASE_ATTACK)
		e4:SetValue(2400)
		tc:RegisterEffect(e4,true)
		local e5=e1:Clone()
		e5:SetCode(EFFECT_SET_BASE_DEFENSE)
		e5:SetValue(1000)
		tc:RegisterEffect(e5,true)
		local e6=e1:Clone()
		e6:SetCode(EFFECT_CHANGE_LEVEL)
		e6:SetValue(7)
		tc:RegisterEffect(e6,true)
		Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP)
		tc=tg:GetNext()
	end
	Duel.SpecialSummonComplete()
end