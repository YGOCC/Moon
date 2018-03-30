--Eternal Bond Fusion
--Script by XGlitchy30
function c37200257.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(37200257,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,37200257+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c37200257.cost)
	e1:SetTarget(c37200257.target)
	e1:SetOperation(c37200257.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(37200257,ACTIVITY_SPSUMMON,c37200257.counterfilter)
end
--filters
function c37200257.counterfilter(c)
	return c:GetSummonLocation()~=LOCATION_EXTRA or c:IsType(TYPE_FUSION)
end
function c37200257.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsType(TYPE_FUSION) and c:IsLocation(LOCATION_EXTRA)
end
function c37200257.base(c,e,tp)
	local lv=c:GetLevel()
	local race=c:GetRace()
	local att=c:GetAttribute()
	local name=c:GetCode()
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c37200257.alias,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp,lv,race,att,name)
			and Duel.IsExistingMatchingCard(c37200257.fusion,tp,LOCATION_EXTRA,0,1,nil,e,tp,lv,race,att)
end
function c37200257.alias(c,e,tp,lv,race,att,name)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:GetLevel()==lv and c:GetRace()==race and c:GetAttribute()==att and c:GetCode()~=name
end
function c37200257.fusion(c,e,tp,lv,race,att)
	return c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial()
		and c:GetLevel()==lv and c:GetRace()==race and c:GetAttribute()==att
end
--Activate
function c37200257.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(37200257,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c37200257.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c37200257.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c37200257.base(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and Duel.GetLocationCountFromEx(tp)>0
		and Duel.IsExistingTarget(c37200257.base,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c37200257.base,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c37200257.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.GetLocationCountFromEx(tp)<=0 then return end
	local tc=Duel.GetFirstTarget()
	local fid=e:GetHandler():GetFieldID()
	--groups
	local prep=Group.CreateGroup()
	local pm=prep:GetFirst()
	--
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		tc:RegisterFlagEffect(37200257,RESET_EVENT+0x5020000,0,1,fid)
		tc:RegisterFlagEffect(31200257,RESET_EVENT+0x5020000,0,1,fid)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sp2=Duel.SelectMatchingCard(tp,c37200257.alias,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp,tc:GetLevel(),tc:GetRace(),tc:GetAttribute(),tc:GetCode())
		if sp2:GetCount()>0 then
			if Duel.SpecialSummon(sp2:GetFirst(),0,tp,tp,false,false,POS_FACEUP)~=0 then
				sp2:GetFirst():RegisterFlagEffect(37200257,RESET_EVENT+0x5020000,0,1,fid)
				sp2:GetFirst():RegisterFlagEffect(31200257,RESET_EVENT+0x5020000,0,1,fid)
				--negate effects and ATK
				local c=e:GetHandler()
				prep:AddCard(tc)
				prep:AddCard(sp2:GetFirst())
				local loc_pm=prep:GetFirst()
				while loc_pm do
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_UNCOPYABLE)
					e1:SetCode(EFFECT_DISABLE)
					e1:SetReset(RESET_EVENT+0x1fe0000)
					loc_pm:RegisterEffect(e1)
					local e2=Effect.CreateEffect(c)
					e2:SetType(EFFECT_TYPE_SINGLE)
					e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_UNCOPYABLE)
					e2:SetCode(EFFECT_DISABLE_EFFECT)
					e2:SetReset(RESET_EVENT+0x1fe0000)
					loc_pm:RegisterEffect(e2)
					local e3=Effect.CreateEffect(c)
					e3:SetType(EFFECT_TYPE_SINGLE)
					e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_UNCOPYABLE)
					e3:SetCode(EFFECT_SET_ATTACK)
					e3:SetValue(0)
					e3:SetReset(RESET_EVENT+0x1fe0000)
					loc_pm:RegisterEffect(e3)
					loc_pm=prep:GetNext()
				end
			end
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local fus=Duel.SelectMatchingCard(tp,c37200257.fusion,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc:GetLevel(),tc:GetRace(),tc:GetAttribute())
			local ff=fus:GetFirst()
			if not ff then return end
			ff:SetMaterial(nil)
			if Duel.SpecialSummon(ff,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)~=0 then
				ff:RegisterFlagEffect(37200257,RESET_EVENT+0x5020000,0,1,fid)
				--groups #2
				local akg=Group.CreateGroup()
				akg:AddCard(tc)
				akg:AddCard(sp2:GetFirst())
				local hatk=akg:GetMaxGroup(Card.GetBaseAttack)
				local atk=0
				if hatk:GetCount()==1 then
					atk=hatk:GetFirst():GetBaseAttack()
				elseif hatk:GetCount()>1 then
					atk=hatk:GetFirst():GetBaseAttack()
				end
				--atk boost
				local FUSe1=Effect.CreateEffect(e:GetHandler())
				FUSe1:SetType(EFFECT_TYPE_SINGLE)
				FUSe1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_UNCOPYABLE)
				FUSe1:SetCode(EFFECT_UPDATE_ATTACK)
				FUSe1:SetValue(atk)
				FUSe1:SetReset(RESET_EVENT+0x1fe0000)
				ff:RegisterEffect(FUSe1)
				--removal event effects
				local lfield=Group.CreateGroup()
				lfield:AddCard(ff)
				lfield:AddCard(tc)
				lfield:AddCard(sp2:GetFirst())
				local dam=tc:GetBaseAttack()+sp2:GetFirst():GetBaseAttack()
				lfield:KeepAlive()
				local LFDe=Effect.CreateEffect(e:GetHandler())
				LFDe:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				LFDe:SetCode(EVENT_LEAVE_FIELD)
				LFDe:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
				LFDe:SetLabel(fid)
				LFDe:SetLabelObject(lfield)
				LFDe:SetCondition(c37200257.atdcon)
				LFDe:SetOperation(c37200257.autodestroy)
				Duel.RegisterEffect(LFDe,tp)	
			end
		end
	end		
end
--autodestruction effect
function c37200257.atdcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(aux.FilterEqualFunction(Card.GetFlagEffectLabel,e:GetLabel(),37200257),1,nil) then
		g:DeleteGroup()
		e:Reset()
		return false
	end
	return eg:IsExists(aux.FilterEqualFunction(Card.GetFlagEffectLabel,e:GetLabel(),37200257),1,nil)
end
function c37200257.autodestroy(e,tp,eg,ep,ev,re,r,rp)
	local resetg=eg:Filter(aux.FilterEqualFunction(Card.GetFlagEffectLabel,e:GetLabel(),37200257),nil,e:GetLabel())
	local rc=resetg:GetFirst()
	while rc do
		rc:ResetFlagEffect(37200257)
		rc=resetg:GetNext()
	end
	local dmgroup=e:GetLabelObject():Filter(aux.FilterEqualFunction(Card.GetFlagEffectLabel,e:GetLabel(),31200257),nil,e:GetLabel())
	local dm1=dmgroup:GetFirst():GetBaseAttack()
	dmgroup:GetFirst():ResetFlagEffect(31200257)
	dmgroup:RemoveCard(dmgroup:GetFirst())
	local dm2=dmgroup:GetFirst():GetBaseAttack()
	dmgroup:GetFirst():ResetFlagEffect(31200257)
	local damage=dm1+dm2
	Duel.Remove(e:GetLabelObject(),POS_FACEUP,REASON_EFFECT)
	local fix=Duel.GetOperatedGroup()
	local rfx=fix:GetFirst()
	while rfx do
		rfx:ResetFlagEffect(37200257)
		rfx=fix:GetNext()
	end
	Duel.Damage(tp,damage,REASON_EFFECT)
end