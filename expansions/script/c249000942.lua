--Starnight the Hedgehog
function c249000942.initial_effect(c)
	if not c249000942.global_check then
		c249000942.global_check=true
		--c249000942.hopt_id_multiplier = 0
		Card.RegisterEffect_249000942 = Card.RegisterEffect
		function Card:RegisterEffect(e)
			local code=self:GetOriginalCode()
			local cardstruct=_G["c" .. code]
			if not cardstruct.c249000942Effect_Table_Exists then
				cardstruct.c249000942Effect_Table_Exists=true
				cardstruct.c249000942Effect_Table_Card=self
				cardstruct.c249000942Effect_Table = {}
				cardstruct.c249000942Effect_Table2 = {}
				cardstruct.c249000942Effect_Count = 1
			end
			if cardstruct.c249000942Effect_Table_Card==self then
				cardstruct.c249000942Effect_Table[cardstruct.c249000942Effect_Count] = e
				cardstruct.c249000942Effect_Table2[cardstruct.c249000942Effect_Count] = e:Clone()
				cardstruct.c249000942Effect_Count=cardstruct.c249000942Effect_Count + 1
			end
			self.RegisterEffect_249000942(self,e)
		end
	end
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c249000942.spcon)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetLabel(2490009421)
	e2:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e2:SetOperation(c249000942.spop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetLabel(2490009422)
	e3:SetOperation(c249000942.spop)
	c:RegisterEffect(e3)
	--lvchange
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(3606728,0))
	e4:SetCategory(CATEGORY_LVCHANGE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetTarget(c249000942.lvtg)
	e4:SetOperation(c249000942.lvop)
	c:RegisterEffect(e4)
	--init
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_ADJUST)
	e5:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e5:SetRange(0xFF)	
	e5:SetOperation(c249000942.tokenop)
	c:RegisterEffect(e5)
end
function c249000942.filter(c)
	return c:IsFaceup() and (c:IsSetCard(0x53) or c:IsSetCard(0x55) or c:IsSetCard(0x7B) or c:IsSetCard(0x9C))
end
function c249000942.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c249000942.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c249000942.lvfilter(c,lv)
	return c:IsFaceup() and (c:IsSetCard(0x53) or c:IsSetCard(0x55) or c:IsSetCard(0x7B) or c:IsSetCard(0x9C)) and not c:IsLevel(lv) and c:IsLevelAbove(1)
end
function c249000942.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c249000942.lvfilter(chkc,e:GetHandler():GetLevel()) end
	if chk==0 then return Duel.IsExistingTarget(c249000942.lvfilter,tp,LOCATION_MZONE,0,1,nil,e:GetHandler():GetLevel()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c249000942.lvfilter,tp,LOCATION_MZONE,0,1,1,nil,e:GetHandler():GetLevel())
end
function c249000942.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(tc:GetLevel())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
end
function c249000942.tgfilter(c,e,tp,eg,ep,ev,re,r,rp)
	if not c:IsSummonableCard() then return false end
	if (not c:IsType(TYPE_EFFECT))	or (c:GetLevel() < 1) or (c:GetLevel() > 10) or c:IsType(TYPE_FUSION) then return false end
	if (not c:IsType(TYPE_SYNCHRO) and (not c:IsSummonableCard())) then return false end
	if (c:IsLocation(LOCATION_GRAVE) and (not c:IsAbleToRemove())) then return false end
	if (not c:IsLocation(LOCATION_GRAVE) and (not c:IsAbleToGrave())) then return false end
	local code=c:GetOriginalCode()
	local cardstruct=_G["c" .. code]
	local t={}
	local desc_t = {}
	local i=1
	local p=1
	if not cardstruct.c249000942Effect_Count then return false end
	for i=1,cardstruct.c249000942Effect_Count do
		if cardstruct.c249000942Effect_Table2[i]==nil and cardstruct.c249000942Effect_Table[i]~=nil then
			local etoclone=cardstruct.c249000942Effect_Table[i]
			cardstruct.c249000942Effect_Table2[i]=etoclone:Clone()
		end
		local etemp=cardstruct.c249000942Effect_Table2[i]
		if etemp and (etemp:IsHasType(EFFECT_TYPE_IGNITION) 
		--or etemp:IsHasType(EFFECT_TYPE_TRIGGER_O) or etemp:IsHasType(EFFECT_TYPE_TRIGGER_F)
		or etemp:IsHasType(EFFECT_TYPE_QUICK_O)) and e:GetHandler():IsLocation(etemp:GetRange()) then
			--local etemp2=e:GetLabelObject()
			--local valideffect=true
			--while etemp2 do	
			--	if etemp==etemp2 then
			--		valideffect=false
			--	end
			--	etemp2=etemp2:GetLabelObject()
			--end
			local con=etemp:GetCondition()
			if (not con) or con(e,tp,eg,ep,ev,re,r,rp) then
				local tf=etemp:GetTarget()
				if (not tf) or tf(e,tp,eg,ep,ev,re,r,rp,0) then
					t[p]=etemp
					desc_t[p]=etemp:GetDescription()
					p=p+1
				end
			end
		end
	end
	return p >=2
end
function c249000942.costfilter(c)
	return (c:IsSetCard(0x53) or c:IsSetCard(0x55) or c:IsSetCard(0x7B) or c:IsSetCard(0x9C)) and c:IsAbleToRemove()
end
function c249000942.costfilter2(c)
	return (c:IsSetCard(0x53) or c:IsSetCard(0x55) or c:IsSetCard(0x7B) or c:IsSetCard(0x9C)) and not c:IsPublic()
end
function c249000942.spop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c249000942.tgfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,eg,ep,ev,re,r,rp) then return end
	if not (Duel.IsExistingMatchingCard(c249000942.costfilter,tp,LOCATION_GRAVE,0,1,nil)
		or Duel.IsExistingMatchingCard(c249000942.costfilter2,tp,LOCATION_HAND,0,1,nil)) then return end
	if Duel.GetFlagEffect(tp,e:GetLabel())>0  or not Duel.SelectYesNo(tp,aux.Stringid(85602018,0)) then return end
	local option
	if Duel.IsExistingMatchingCard(c249000942.costfilter2,tp,LOCATION_HAND,0,1,nil)  then option=0 end
	if Duel.IsExistingMatchingCard(c249000942.costfilter,tp,LOCATION_GRAVE,0,1,nil) then option=1 end
	if Duel.IsExistingMatchingCard(c249000942.costfilter,tp,LOCATION_GRAVE,0,1,nil)
	and Duel.IsExistingMatchingCard(c249000942.costfilter2,tp,LOCATION_HAND,0,1,nil) then
		option=Duel.SelectOption(tp,526,1102)
	end
	if option==0 then
		g=Duel.SelectMatchingCard(tp,c249000942.costfilter2,tp,LOCATION_HAND,0,1,1,nil)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
	end
	if option==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c249000942.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
	Duel.SelectTarget(tp,c249000942.tgfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	--local g2=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_DECK+LOCATION_GRAVE,LOCATION_DECK+LOCATION_GRAVE,1,1,nil)
	local tc=g:GetFirst()
	if not tc then return end
	--or not tc:IsRelateToEffect(e) then return end
	--local tpe=tc:GetType()
	--local te=tc:GetActivateEffect()
	if tc:IsLocation(LOCATION_GRAVE) then Duel.Remove(tc,POS_FACEUP,REASON_EFFECT) else Duel.SendtoGrave(tc,REASON_EFFECT) end
	local code=tc:GetOriginalCode()
	local cardstruct=_G["c" .. code]
	local t={}
	local desc_t = {}
	local i=1
	local p=1
	for i=1,cardstruct.c249000942Effect_Count do
		if cardstruct.c249000942Effect_Table2[i]==nil and cardstruct.c249000942Effect_Table[i]~=nil then
			local etoclone=cardstruct.c249000942Effect_Table[i]
			cardstruct.c249000942Effect_Table2[i]=etoclone:Clone()
		end
		local etemp=cardstruct.c249000942Effect_Table2[i]
		if etemp and (etemp:IsHasType(EFFECT_TYPE_IGNITION)
		-- or etemp:IsHasType(EFFECT_TYPE_TRIGGER_O) or etemp:IsHasType(EFFECT_TYPE_TRIGGER_F)
		or etemp:IsHasType(EFFECT_TYPE_QUICK_O)) and e:GetHandler():IsLocation(etemp:GetRange()) then
			--local etemp2=e:GetLabelObject()
			--while etemp2 do	
			--	if etemp==etemp2 then
			--		valideffect=false
			--	end
			--	etemp2=etemp2:GetLabelObject()
			--end
			local con=etemp:GetCondition()
			if (not con) or con(e,tp,eg,ep,ev,re,r,rp) then
				local tf=etemp:GetTarget()
				if (not tf) or tf(e,tp,eg,ep,ev,re,r,rp,0) then
					t[p]=etemp
					desc_t[p]=etemp:GetDescription()
					p=p+1
				end
			end
		end
	end
	local index=1
	if p < 2 then return end
	if p > 2 then 
		index=Duel.SelectOption(tp,table.unpack(desc_t)) + 1
	end
	local te=t[index]
	te:SetReset(RESET_EVENT+RESET_CHAIN)
	e:GetHandler():RegisterEffect(te)
	e:GetHandler():CreateEffectRelation(te)
	local tg=te:GetTarget()
	local co=te:GetCost()
	local op=te:GetOperation()
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	Duel.ClearTargetCard()
	tc:CreateEffectRelation(te)
	--if co then co(te,tp,eg,ep,ev,re,r,rp,1) end
	if co then co(e,tp,eg,ep,ev,re,r,rp,1) end
	if tg then
	--	if tc:IsSetCard(0x95) then
		tg(e,tp,eg,ep,ev,re,r,rp,1)
	--	else
	--		tg(te,tp,eg,ep,ev,re,r,rp,1)
	--	end
	end
	Duel.BreakEffect()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local etc=g:GetFirst()
	while etc do
		etc:CreateEffectRelation(te)
		etc=g:GetNext()
	end
	if op then 
		--if tc:IsSetCard(0x95) then
		--	op(e,tp,eg,ep,ev,re,r,rp)
		--else
			op(te,tp,eg,ep,ev,re,r,rp)
		--end
	end
	tc:ReleaseEffectRelation(te)
	etc=g:GetFirst()
	while etc do
		etc:ReleaseEffectRelation(te)
		etc=g:GetNext()
	end
	te:Reset()
	Duel.RegisterFlagEffect(tp,e:GetLabel(),RESET_PHASE+PHASE_END,0,1)
end
function c249000942.tokenop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0xFF,0xFF,nil)
	local tc=g:GetFirst()
	while tc do
		local temp=Duel.CreateToken(tp,tc:GetOriginalCode())
		local code=temp:GetOriginalCode()
		local cardstruct=_G["c" .. code]
		if cardstruct.initial_effect then cardstruct.initial_effect(temp) end
		tc=g:GetNext()
	end
end
