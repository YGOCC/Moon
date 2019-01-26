--Sweethard-Powered: Daffa Goose
function c50031004.initial_effect(c)
   aux.AddOrigEvoluteType(c)
	c:EnableReviveLimit()
 aux.AddEvoluteProc(c,nil,5,c50031004.filter1,c50031004.filter2,2,99)  

--spsummon proc
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(50031004,0))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCountLimit(1,50031004)
	e0:SetCondition(c50031004.hspcon)
	e0:SetOperation(c50031004.hspop)
	e0:SetValue(SUMMON_TYPE_SPECIAL+388)
	c:RegisterEffect(e0)
		--deck check
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(50031004,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,0x11e0)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	e1:SetCost(c50031004.cost)
	e1:SetTarget(c50031004.target)
	e1:SetOperation(c50031004.operation)
	c:RegisterEffect(e1)
end

function c50031004.filter1(c,ec,tp)
	return c:IsAttribute(ATTRIBUTE_DARK)
end
function c50031004.filter2(c,ec,tp)
	return c:IsRace(RACE_BEASTWARRIOR)
end
function c50031004.spfilter(c)
	return c:IsFaceup() and c:IsCode(500310040) and Duel.GetLocationCountFromEx(tp,tp,c)>0
end
function c50031004.hspcon(e,c)
  if c==nil then return true end
	if chk==0 then return Duel.GetFlagEffect(tp,50031004)==0 end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c50031004.spfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c50031004.hspop(e,tp,eg,ep,ev,re,r,rp)
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_MATERIAL)
	local g=Duel.SelectMatchingCard(tp,c50031004.spfilter,tp,LOCATION_MZONE,0,1,1,nil)
   Duel.SendtoGrave(g,REASON_MATERIAL+0x10000000)
	Duel.RegisterFlagEffect(tp,50031004,RESET_PHASE+PHASE_END,0,1)
end
function c50031004.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveEC(tp,3,REASON_COST) end
	e:GetHandler():RemoveEC(tp,3,REASON_COST)
end
function c50031004.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsPlayerCanDraw(tp,1)
	if chk==0 then return Duel.GetDecktopGroup(tp,3):GetCount()==3 end
end
function c50031004.operation(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.GetDecktopGroup(tp,3):GetCount()==3) then return end
	Duel.ConfirmDecktop(tp,3)
	local g=Duel.GetDecktopGroup(tp,3)
	local sel=0
	if g:IsExists(function(tc) return tc:IsSetCard(0xa34) and tc:IsType(TYPE_MONSTER) end,1,nil) then sel=sel+1 end
	if g:IsExists(function(tc) return tc:IsSetCard(0xa34) and tc:IsType(TYPE_SPELL) end,1,nil) then sel=sel+2 end
	if g:IsExists(function(tc) return tc:IsSetCard(0xa34) and tc:IsType(TYPE_TRAP) end,1,nil) then sel=sel+4 end
	if sel==0 then return end
	--setting the option
	if sel==1 then
		Duel.SelectOption(tp,aux.Stringid(50031004,1))
		opt=0
	elseif sel==2 then
		Duel.SelectOption(tp,aux.Stringid(50031004,2))
		opt=1
	elseif sel==3 then
		opt=Duel.SelectOption(tp,aux.Stringid(50031004,1),aux.Stringid(50031004,2))
	elseif sel==4 then
		Duel.SelectOption(tp,aux.Stringid(50031004,3))
		opt=2
	elseif sel==5 then
		opt=Duel.SelectOption(tp,aux.Stringid(50031004,1),aux.Stringid(50031004,3))
		if opt==1 then opt=2 end
	elseif sel==6 then
		opt=Duel.SelectOption(tp,aux.Stringid(50031004,2),aux.Stringid(50031004,3))+1
	elseif sel==7 then
		opt=Duel.SelectOption(tp,aux.Stringid(50031004,1),aux.Stringid(50031004,2),aux.Stringid(50031004,3))
	end
	--getting the option and executing
	if opt==0 then
  g=Duel.GetFieldGroup(tp,0,LOCATION_HAND):RandomSelect(tp,1)
	Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
	end
	if opt==1 then
		local c=e:GetHandler()
		 local e1=Effect.CreateEffect(c)
		 e1:SetType(EFFECT_TYPE_SINGLE)
		 e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetReset(RESET_PHASE+PHASE_END)
	   c:RegisterEffect(e1)
	end
	if opt==2 then
		Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
		 Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		 Duel.Draw(tp,1,REASON_EFFECT)
	end
 for i=1,3 do
			local g=Duel.GetDecktopGroup(tp,1)
			Duel.MoveSequence(g:GetFirst(),1)

end
end