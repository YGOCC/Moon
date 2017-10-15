--created & coded by Lyris
--サイバー・ドラゴン・ティマイオス
function c240100059.initial_effect(c)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ADD_FUSION_CODE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(70095154)
	c:RegisterEffect(e2)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,240100059+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c240100059.target)
	e1:SetOperation(c240100059.activate)
	c:RegisterEffect(e1)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_ADD_TYPE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetValue(TYPE_MONSTER+TYPE_EFFECT)
	c:RegisterEffect(e0)
end
function c240100059.tgfilter0(c,e,tp)
	return c:IsFaceup() and c:IsCode(70095154)
		and c:IsCanBeFusionMaterial()
end
function c240100059.tgfilter(c,e,tp)
	return c:IsFaceup() and c:IsCode(70095154)
		and c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end
function c240100059.spfilter(c,e,tp,g)
	return aux.IsMaterialListCode(c,70095154) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(g,nil,tp)
end
function c240100059.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc==0 then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c240100059.tgfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingTarget(c240100059.tgfilter0,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	e:SetLabel(Duel.AnnounceNumber(tp,2,3,4,5,6))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c240100059.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c240100059.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsCanBeFusionMaterial() and not tc:IsImmuneToEffect(e) then
		local mg=Group.FromCards(tc)
		for i=1,e:GetLabel()-1 do
			local ck=Duel.CreateToken(tp,70095154)
			mg:AddCard(ck)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c240100059.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,mg)
		local sc=sg:GetFirst()
		if sc then
			sc:SetMaterial(mg)
			Duel.SendtoGrave(tc,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			if Duel.SpecialSummon(sc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)~=0 then
				sc:CompleteProcedure()
				if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
					local e2=Effect.CreateEffect(e:GetHandler())
					e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					e2:SetCode(EVENT_PHASE+PHASE_END)
					e2:SetCountLimit(1)
					e2:SetLabel(sc:GetBaseAttack())
					e2:SetLabelObject(sc)
					e2:SetReset(RESET_PHASE+PHASE_END)
					e2:SetOperation(c240100059.damop)
					Duel.RegisterEffect(e2,tp)
				end
				if e:GetLabel()>3 or not Duel.SelectYesNo(tp,aux.Stringid(240100059,0)) then return end
				local e0=Effect.CreateEffect(e:GetHandler())
				e0:SetType(EFFECT_TYPE_FIELD)
				e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
				e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
				e0:SetReset(RESET_PHASE+PHASE_END)
				e0:SetTargetRange(1,0)
				e0:SetTarget(c240100059.splimit)
				Duel.RegisterEffect(e0,tp)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_SET_ATTACK_FINAL)
				e1:SetValue(sc:GetAttack()*2)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				sc:RegisterEffect(e1)
			end
		end
	end
end
function c240100059.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:GetRace()~=RACE_MACHINE
end
function c240100059.damop(e,tp,eg,ep,ev,re,r,rp)
	local dam=e:GetLabel()
	if e:GetLabelObject():GetAttack()>dam then
		Duel.Damage(tp,dam,REASON_EFFECT)
	end
end
