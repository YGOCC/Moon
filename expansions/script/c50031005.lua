--Sweethard-Powered: Mika Mouse
function c50031005.initial_effect(c)
 aux.AddOrigEvoluteType(c)
	c:EnableReviveLimit()
 aux.AddEvoluteProc(c,nil,5,c50031005.filter1,c50031005.filter2,2,99)  

--spsummon proc
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(50031005,0))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCountLimit(1,50031005)
	e0:SetCondition(c50031005.hspcon)
	e0:SetOperation(c50031005.hspop)
	e0:SetValue(SUMMON_TYPE_SPECIAL+388)
	c:RegisterEffect(e0)
		--deck check
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(50031005,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,0x11e0)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	e1:SetCost(c50031005.cost)
	e1:SetTarget(c50031005.target)
	e1:SetOperation(c50031005.operation)
	c:RegisterEffect(e1)
	 
end
function c50031005.filter1(c,ec,tp)
	return c:IsAttribute(ATTRIBUTE_DARK)
end
function c50031005.filter2(c,ec,tp)
	return c:IsRace(RACE_BEASTWARRIOR)
end
function c50031005.spfilter(c)
	return c:IsFaceup() and c:IsCode(500310050) and Duel.GetLocationCountFromEx(tp,tp,c)>0
end
function c50031005.hspcon(e,c)
  if c==nil then return true end
	if chk==0 then return Duel.GetFlagEffect(tp,50031005)==0 end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c50031005.spfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c50031005.hspop(e,tp,eg,ep,ev,re,r,rp)
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_MATERIAL)
	local g=Duel.SelectMatchingCard(tp,c50031005.spfilter,tp,LOCATION_MZONE,0,1,1,nil)
   Duel.SendtoGrave(g,REASON_MATERIAL+0x10000000)
	Duel.RegisterFlagEffect(tp,50031005,RESET_PHASE+PHASE_END,0,1)
end
function c50031005.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveEC(tp,3,REASON_COST) end
	e:GetHandler():RemoveEC(tp,3,REASON_COST)
end
function c50031005.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsPlayerCanDraw(tp,1)
	if chk==0 then return Duel.GetDecktopGroup(tp,3):GetCount()==3 end
end
function c50031005.operation(e,tp,eg,ep,ev,re,r,rp)
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
		Duel.SelectOption(tp,aux.Stringid(50031005,1))
		opt=0
	elseif sel==2 then
		Duel.SelectOption(tp,aux.Stringid(50031005,2))
		opt=1
	elseif sel==3 then
		opt=Duel.SelectOption(tp,aux.Stringid(50031005,1),aux.Stringid(50031005,2))
	elseif sel==4 then
		Duel.SelectOption(tp,aux.Stringid(50031005,3))
		opt=2
	elseif sel==5 then
		opt=Duel.SelectOption(tp,aux.Stringid(50031005,1),aux.Stringid(50031005,3))
		if opt==1 then opt=2 end
	elseif sel==6 then
		opt=Duel.SelectOption(tp,aux.Stringid(50031005,2),aux.Stringid(50031005,3))+1
	elseif sel==7 then
		opt=Duel.SelectOption(tp,aux.Stringid(50031005,1),aux.Stringid(50031005,2),aux.Stringid(50031005,3))
	end
	--getting the option and executing
	if opt==0 then
  Duel.Recover(tp,500,REASON_EFFECT)
	end
	if opt==1 then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,c50031005.xfffilter,tp,0,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end

end
	if opt==2 then
	  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,c50031005.xfffilter2,tp,0,LOCATION_SZONE,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end

end
 for i=1,3 do
			local g=Duel.GetDecktopGroup(tp,1)
			Duel.MoveSequence(g:GetFirst(),1)

end
end

function c50031005.xfffilter(c)
	return c:IsFaceup() and not c:IsDisabled() and c:IsType(TYPE_EFFECT)
end
function c50031005.xfffilter2(c)
	return c:IsFaceup() and not c:IsDisabled() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end

function c50031005.rmfilter(c)
	return  c:IsFaceup() and c:IsType(TYPE_SPELL) and c:IsAbleToRemove()
end
function c50031005.rmfilter2(c)
	return  c:IsFaceup() and c:IsType(TYPE_TRAP) and c:IsAbleToDeck()
end

function c50031005.retcon(e,tp,eg,ep,ev,re,r,rp)
	return  e:GetHandler():GetReasonPlayer()==1-tp
		and e:GetHandler():GetPreviousControler()==tp
end
function c50031005.thfilter(c)
   return c:IsSetCard(0xa34) and not c:IsCode(50031005) and c:IsType(TYPE_MONSTER) --and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c50031005.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c50031005.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c50031005.retop(e,tp,eg,ep,ev,re,r,rp)
	  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c50031005.thfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

