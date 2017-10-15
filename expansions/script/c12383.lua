--剣闘獣ヘラクレイノス
function c12383.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c12383.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12383,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c12383.sprcon)
	e2:SetOperation(c12383.sprop)
	c:RegisterEffect(e2)
	--deckdes
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12383,1))
	e3:SetCategory(CATEGORY_DECKDES)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c12383.ddtg)
	e3:SetOperation(c12383.ddop)
	c:RegisterEffect(e3)
end
function c12383.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c12383.spfilter1(c,tp)
	return c:IsFusionSetCard(0x3052) and c:IsType(TYPE_SYNCHRO) and c:IsAbleToDeckOrExtraAsCost() and c:IsFaceup() and c:IsCanBeFusionMaterial()
		and Duel.IsExistingMatchingCard(c12383.spfilter2,tp,LOCATION_REMOVED,0,2,c)
end
function c12383.spfilter2(c)
	return c:IsFusionSetCard(0x3052) and c:IsFaceup() and c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_SYNCHRO) and c:IsCanBeFusionMaterial() and c:IsAbleToDeckOrExtraAsCost()
end
function c12383.sprcon(e,c)
	if c==nil then return true end 
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c12383.spfilter1,tp,LOCATION_REMOVED,0,1,nil,tp)
end
function c12383.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(12383,2))
	local g1=Duel.SelectMatchingCard(tp,c12383.spfilter1,tp,LOCATION_REMOVED,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(12383,3))
	local g2=Duel.GetMatchingGroup(c12383.spfilter2,tp,LOCATION_REMOVED,0,nil,g1:GetFirst())
	local rg=Group.CreateGroup()
	for i=1,2 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local tc=g2:Select(tp,1,1,nil):GetFirst()
		if tc then
			rg:AddCard(tc)
			g2:Remove(Card.IsCode,nil,tc:GetCode())
		end
	end
	g1:Merge(rg)
	local sg=g1:GetFirst()
	while sg do
		if not sg:IsFaceup() then Duel.ConfirmCards(1-tp,sg) end
		sg=g1:GetNext()
	end
	Duel.SendtoDeck(g1,nil,2,REASON_COST)
	local sum=0
	local sg=g1:GetFirst()
	while sg do
		local atk=sg:GetAttack()
		sum=sum+atk
		sg=g1:GetNext()
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetValue(sum)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
end
function c12383.dfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c12383.ddtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,1)
end
function c12383.ddop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	Duel.DiscardDeck(tp,1,REASON_EFFECT)
	local c=e:GetHandler()
	local tc=Duel.GetOperatedGroup():GetFirst()
	if tc and c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsType(TYPE_MONSTER) and tc:IsLocation(LOCATION_GRAVE) then
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(12383,4)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local dg=g:Select(tp,1,1,nil)
			Duel.HintSelection(dg)
			bc=dg:GetFirst()
			while bc do
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetValue(-(tc:GetAttack()))
				e1:SetReset(RESET_EVENT+0x1ff0000)
				bc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE)
				e2:SetReset(RESET_EVENT+0x1fe0000)
				bc:RegisterEffect(e2)
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_DISABLE_EFFECT)
				e3:SetValue(RESET_TURN_SET)
				e3:SetReset(RESET_EVENT+0x1fe0000)
				bc:RegisterEffect(e3)
				bc=dg:GetNext()
			end
		end
	else
	local c=e:GetHandler()
	local tc=Duel.GetOperatedGroup():GetFirst()
	if tc and c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsType(TYPE_SPELL+TYPE_TRAP) and tc:IsLocation(LOCATION_GRAVE) then
		local g1=Duel.GetMatchingGroup(c12383.dfilter,tp,0,LOCATION_ONFIELD,nil)
		if g1:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(12383,5)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local dg1=g1:Select(tp,1,1,nil)
			Duel.HintSelection(dg1)
			Duel.Destroy(dg1,REASON_EFFECT)
		end
	end
end
end