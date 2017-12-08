--Curse of the Forgotten Scriptures
--Script by XGlitchy30
function c36541450.initial_effect(c)
	--trigger
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(c36541450.tgcon)
	e1:SetTarget(c36541450.tgtg)
	e1:SetOperation(c36541450.tgop)
	c:RegisterEffect(e1)
end
--filters
function c36541450.spfilter(c,e,tp,att,lv)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:GetAttribute()==att and c:GetLevel()==lv
end
--trigger
function c36541450.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetPreviousLocation()==LOCATION_HAND and bit.band(r,REASON_EFFECT)~=0
		and re:IsActiveType(TYPE_MONSTER)
end
function c36541450.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c36541450.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local att=re:GetHandler():GetAttribute()
	local lv=re:GetHandler():GetLevel()
	if c:IsRelateToEffect(e) then
		Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
		if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 and Duel.IsExistingMatchingCard(c36541450.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp,att,lv) then 
			if Duel.SelectYesNo(tp,aux.Stringid(36541450,0)) then
				local g=Duel.SelectMatchingCard(tp,c36541450.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp,att,lv)
				local sp=g:GetFirst()
				if sp then
					local fid=e:GetHandler():GetFieldID()
					Duel.SpecialSummon(sp,0,tp,tp,false,false,POS_FACEUP)
					while sp do
						--cannot disable
						local e1=Effect.CreateEffect(c)
						e1:SetType(EFFECT_TYPE_FIELD)
						e1:SetCode(EFFECT_CANNOT_DISEFFECT)
						e1:SetLabelObject(sp)
						e1:SetValue(c36541450.cntdisable)
						e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
						Duel.RegisterEffect(e1,tp)
						local e2=Effect.CreateEffect(c)
						e2:SetType(EFFECT_TYPE_FIELD)
						e2:SetCode(EFFECT_CANNOT_DISABLE)
						e2:SetLabelObject(sp)
						e2:SetTargetRange(LOCATION_ONFIELD,0)
						e2:SetTarget(c36541450.indtg)
						e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
						Duel.RegisterEffect(e2,tp)
						sp:RegisterFlagEffect(36541450,RESET_EVENT+0x1fe0000,0,1,fid)
						sp=g:GetNext()
					end
					g:KeepAlive()
					local e3=Effect.CreateEffect(c)
					e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					e3:SetCode(EVENT_PHASE+PHASE_END)
					e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
					e3:SetCountLimit(1)
					e3:SetLabel(fid)
					e3:SetLabelObject(g)
					e3:SetCondition(c36541450.epcon)
					e3:SetOperation(c36541450.epop)
					Duel.RegisterEffect(e3,tp)
				end
			end
		end
	end
end
--"cannot disable" values
function c36541450.cntdisable(e,ct)
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	local tc=te:GetHandler()
	local sp=e:GetLabelObject()
	return tc==sp
end
function c36541450.indtg(e,c)
	local sp=e:GetLabelObject()
	return c==sp
end
--end phase event
function c36541450.epfilter(c,fid)
	return c:GetFlagEffectLabel(36541450)==fid
end
function c36541450.destroy(c,att)
	return c:IsFaceup() and c:GetAttribute()==att
end
function c36541450.epcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c36541450.epfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c36541450.epop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(c36541450.epfilter,nil,e:GetLabel())
	local tspec=tg:GetFirst()
	local effect=Duel.GetMatchingGroup(c36541450.destroy,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tspec:GetAttribute())
	if effect:GetCount()>0 then
		Duel.Destroy(effect,REASON_EFFECT)
	end
end