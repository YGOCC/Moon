--Transcended Mage Knight
function c249000559.initial_effect(c)
	if not c249000559.global_check then
		c249000559.global_check=true
		c249000559.hopt_id_multiplier = 0
		Card.RegisterEffect_249000559 = Card.RegisterEffect
		function Card:RegisterEffect(e)
			local code=self:GetOriginalCode()
			local cardstruct=_G["c" .. code]
			if not cardstruct.c249000559Effect_Table_Exists then
				cardstruct.c249000559Effect_Table_Exists=true
				cardstruct.c249000559Effect_Table_Card=self
				cardstruct.c249000559Effect_Table = {}
				cardstruct.c249000559Effect_Table2 = {}
				cardstruct.c249000559Effect_Count = 1
			end
			if cardstruct.c249000559Effect_Table_Card==self then
				cardstruct.c249000559Effect_Table[cardstruct.c249000559Effect_Count] = e
				cardstruct.c249000559Effect_Table2[cardstruct.c249000559Effect_Count] = e:Clone()
				cardstruct.c249000559Effect_Count=cardstruct.c249000559Effect_Count + 1
			end
			self.RegisterEffect_249000559(self,e)
		end
	end
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunFunRep(c,aux.TRUE,aux.FilterBoolFunction(Card.IsFusionSetCard,0x1CD),2,2,true)
	aux.AddContactFusionProcedure(c,Card.IsReleasable,LOCATION_MZONE,0,Duel.Release,REASON_COST+REASON_MATERIAL)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12298909,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,2490005591)
	e1:SetCondition(c249000559.discon)
	e1:SetCost(c249000559.discost)
	e1:SetTarget(c249000559.distg)
	e1:SetOperation(c249000559.disop)
	c:RegisterEffect(e1)	
	--spsummon condition
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(c249000559.splimit)
	c:RegisterEffect(e2)
	--copy
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,2490005592)
	e3:SetDescription(aux.Stringid(25793414,0))
	e3:SetTarget(c249000559.target)
	e3:SetOperation(c249000559.operation)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(11224103,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,2490005593)
	e4:SetCondition(c249000559.spcon)
	e4:SetTarget(c249000559.sptg)
	e4:SetOperation(c249000559.spop)
	c:RegisterEffect(e4)
	--init
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_ADJUST)
	e5:SetRange(LOCATION_MZONE)	
	e5:SetOperation(c249000559.tokenop)
	c:RegisterEffect(e5)
end
function c249000559.discon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsExists(Card.IsOnField,1,nil) and Duel.IsChainNegatable(ev)
end
function c249000559.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c249000559.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c249000559.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c249000559.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c249000559.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c249000559.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c249000559.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c249000559.tgfilter(c,e)
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
	if not cardstruct.c249000559Effect_Count then return false end
	for i=1,cardstruct.c249000559Effect_Count do
		if cardstruct.c249000559Effect_Table2[i]==nil and cardstruct.c249000559Effect_Table[i]~=nil then
			local etoclone=cardstruct.c249000559Effect_Table[i]
			cardstruct.c249000559Effect_Table2[i]=etoclone:Clone()
		end
		local etemp=cardstruct.c249000559Effect_Table2[i]
		if etemp and (etemp:IsHasType(EFFECT_TYPE_IGNITION) or etemp:IsHasType(EFFECT_TYPE_TRIGGER_O) or etemp:IsHasType(EFFECT_TYPE_TRIGGER_F) or etemp:IsHasType(EFFECT_TYPE_QUICK_O)) then
			local etemp2=e:GetLabelObject()
			local valideffect=true
			while etemp2 do	
				if etemp==etemp2 then
					valideffect=false
				end
				etemp2=etemp2:GetLabelObject()
			end
			if valideffect then
				t[p]=etemp
				desc_t[p]=etemp:GetDescription()
				p=p+1
			end
		end
	end
	return p >=2
end
function c249000559.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000559.tgfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_DECK+LOCATION_HAND,0,1,nil,e) end
end
function c249000559.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.SelectMatchingCard(tp,c249000559.tgfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e):GetFirst()
	if not tc then return end
	if tc:IsLocation(LOCATION_GRAVE) then Duel.Remove(tc,POS_FACEUP,REASON_EFFECT) else Duel.SendtoGrave(tc,REASON_EFFECT) end
	local code=tc:GetOriginalCode()
	local cardstruct=_G["c" .. code]
	local t={}
	local desc_t = {}
	local i=1
	local p=1
	for i=1,cardstruct.c249000559Effect_Count do
		if cardstruct.c249000559Effect_Table2[i]==nil and cardstruct.c249000559Effect_Table[i]~=nil then
			local etoclone=cardstruct.c249000559Effect_Table[i]
			cardstruct.c249000559Effect_Table2[i]=etoclone:Clone()
		end
		local etemp=cardstruct.c249000559Effect_Table2[i]
		if etemp and (etemp:IsHasType(EFFECT_TYPE_IGNITION) or etemp:IsHasType(EFFECT_TYPE_TRIGGER_O) or etemp:IsHasType(EFFECT_TYPE_TRIGGER_F) or etemp:IsHasType(EFFECT_TYPE_QUICK_O)) then
			local etemp2=e:GetLabelObject()
			local valideffect=true
			while etemp2 do	
				if etemp==etemp2 then
					valideffect=false
				end
				etemp2=etemp2:GetLabelObject()
			end
			if valideffect then
				t[p]=etemp
				desc_t[p]=etemp:GetDescription()
				p=p+1
			end
		end
	end
	local index=1
	if p < 2 then return end
	if p > 2 then 
		index=Duel.SelectOption(tp,table.unpack(desc_t)) + 1
	end
	local te=t[index]
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	te:SetCountLimit(1,249000559+ 10000 * c249000559.hopt_id_multiplier)
	te:SetReset(RESET_EVENT+0x1fe0000)
	c249000559.hopt_id_multiplier = c249000559.hopt_id_multiplier + 1
	c:RegisterEffect(te)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetLabelObject(te)
	e2:SetOperation(c249000559.resetop)
	c:RegisterEffect(e2,true)
	local e3=e2:Clone()
	e3:SetLabelObject(e)
	c:RegisterEffect(e3,true)
end
function c249000559.resetop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsLocation(LOCATION_EXTRA) then return end
	e:GetLabelObject():SetLabelObject(nil)
	e:Reset()
end
function c249000559.tokenop(e,tp,eg,ep,ev,re,r,rp)
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