--Digimon Xros Dorulu Cannon
function c47000127.initial_effect(c)
c:SetUniqueOnField(1,0,47000127)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,47000118,47000120,false,false)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c47000127.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c47000127.spcon)
	e2:SetOperation(c47000127.spop)
	c:RegisterEffect(e2)
	--equip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(47000127,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c47000127.eqtg)
	e3:SetOperation(c47000127.eqop)
	c:RegisterEffect(e3)
	--xyz limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--synchrolimit
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e5:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	--To Grave
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(47000127,1))
	e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetCountLimit(1,47000127+EFFECT_COUNT_CODE_OATH)
	e6:SetCode(EVENT_TO_GRAVE)
	e6:SetTarget(c47000127.thtg)
	e6:SetOperation(c47000127.thop)
	c:RegisterEffect(e6)
--destroy
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(47000127,2))
	e7:SetCategory(CATEGORY_DESTROY)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1,74122413)
	e7:SetCost(c47000127.descost)
	e7:SetTarget(c47000127.destg)
	e7:SetOperation(c47000127.desop)
	c:RegisterEffect(e7)
end
function c47000127.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function c47000127.spfilter(c,code)
	return c:IsAbleToDeckOrExtraAsCost() and c:IsFusionCode(code)
end
function c47000127.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<-1 then return false end
	local g1=Duel.GetMatchingGroup(c47000127.spfilter,tp,LOCATION_MZONE,0,nil,47000118)
	local g2=Duel.GetMatchingGroup(c47000127.spfilter,tp,LOCATION_MZONE,0,nil,47000120)
	if g1:GetCount()==0 or g2:GetCount()==0 then return false end
	if g1:GetCount()==1 and g2:GetCount()==1 and g1:GetFirst()==g2:GetFirst() then return false end
	if ft>0 then return true end
	local f1=g1:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)
	local f2=g2:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)
	if ft==-1 then return f1>0 and f2>0
	else return f1>0 or f2>0 end
end
function c47000127.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g1=Duel.GetMatchingGroup(c47000127.spfilter,tp,LOCATION_MZONE,0,nil,47000118)
	local g2=Duel.GetMatchingGroup(c47000127.spfilter,tp,LOCATION_MZONE,0,nil,47000120)
	g1:Merge(g2)
	local g=Group.CreateGroup()
	local tc=nil
	for i=1,2 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		if ft<=0 then
			tc=g1:FilterSelect(tp,Card.IsLocation,1,1,nil,LOCATION_MZONE):GetFirst()
			ft=ft+1
		else
			tc=g1:Select(tp,1,1,nil):GetFirst()
		end
		g:AddCard(tc)
		if i==1 then
			g1:Clear()
			if tc:IsFusionCode(47000118) then
				local sg=Duel.GetMatchingGroup(c47000127.spfilter,tp,LOCATION_MZONE,0,tc,47000120)
				g1:Merge(sg)
			end
			if tc:IsFusionCode(47000120) then
				local sg=Duel.GetMatchingGroup(c47000127.spfilter,tp,LOCATION_MZONE,0,tc,47000118)
				g1:Merge(sg)
			end
		end
	end
	local cg=g:Filter(Card.IsFacedown,nil)
	if cg:GetCount()>0 then
		Duel.ConfirmCards(1-tp,cg)
	end
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c47000127.filter(c)
	return c:IsSetCard(0x2EEF) and c:IsType(TYPE_MONSTER) and c:IsLevelBelow(4) and not (c:IsCode(47000124) or c:IsCode(47000118))  
end
function c47000127.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c47000127.filter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function c47000127.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c47000127.filter),tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		if not Duel.Equip(tp,tc,c,true) then return end
		local e3=Effect.CreateEffect(c)
		e3:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_EQUIP_LIMIT)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		e3:SetValue(c47000127.eqlimit)
		tc:RegisterEffect(e3)
	end
end
function c47000127.eqlimit(e,c)
	return e:GetOwner()==c
end
function c47000127.afilter(c)
	return c:IsCode(47000118) and c:IsAbleToHand() 
end
function c47000127.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c47000127.afilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c47000127.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c47000127.afilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c47000127.cfilter(c)
	return c:IsSetCard(0x2EEF) and c:IsDiscardable()
end
function c47000127.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c47000127.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c47000127.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c47000127.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c47000127.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
