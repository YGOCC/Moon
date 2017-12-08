--Ancient Engraved Array - Dendera
--Script by XGlitchy30
function c36541451.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--equip
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(c36541451.valcheck)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(36541451,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetLabelObject(e0)
	e1:SetCondition(c36541451.eqcon)
	e1:SetTarget(c36541451.eqtg)
	e1:SetOperation(c36541451.eqop)
	c:RegisterEffect(e1)
	--attribute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_ADD_ATTRIBUTE)
	e2:SetCondition(c36541451.attgain1)
	e2:SetValue(ATTRIBUTE_LIGHT)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCondition(c36541451.attgain2)
	e3:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCondition(c36541451.attgain3)
	e4:SetValue(ATTRIBUTE_WATER)
	c:RegisterEffect(e4)
	local e5=e2:Clone()
	e5:SetCondition(c36541451.attgain4)
	e5:SetValue(ATTRIBUTE_FIRE)
	c:RegisterEffect(e5)
	local e6=e2:Clone()
	e6:SetCondition(c36541451.attgain5)
	e6:SetValue(ATTRIBUTE_EARTH)
	c:RegisterEffect(e6)
	local e7=e2:Clone()
	e7:SetCondition(c36541451.attgain6)
	e7:SetValue(ATTRIBUTE_WIND)
	c:RegisterEffect(e7)
	local e8=e2:Clone()
	e8:SetCondition(c36541451.attgain7)
	e8:SetValue(ATTRIBUTE_DIVINE)
	c:RegisterEffect(e8)
	--immunity
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e9:SetCode(EFFECT_IMMUNE_EFFECT)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCondition(c36541451.attcon1)
	e9:SetValue(c36541451.efilter1)
	c:RegisterEffect(e9)
	local e11=e9:Clone()
	e11:SetCondition(c36541451.attcon2)
	e11:SetValue(c36541451.efilter2)
	c:RegisterEffect(e11)
	local e12=e9:Clone()
	e12:SetCondition(c36541451.attcon3)
	e12:SetValue(c36541451.efilter3)
	c:RegisterEffect(e12)
	local e13=e9:Clone()
	e13:SetCondition(c36541451.attcon4)
	e13:SetValue(c36541451.efilter4)
	c:RegisterEffect(e13)
	local e14=e9:Clone()
	e14:SetCondition(c36541451.attcon5)
	e14:SetValue(c36541451.efilter5)
	c:RegisterEffect(e14)
	local e15=e9:Clone()
	e15:SetCondition(c36541451.attcon6)
	e15:SetValue(c36541451.efilter6)
	c:RegisterEffect(e15)
	local e16=e9:Clone()
	e16:SetCondition(c36541451.attcon7)
	e16:SetValue(c36541451.efilter7)
	c:RegisterEffect(e16)
	local e17=Effect.CreateEffect(c)
	e17:SetType(EFFECT_TYPE_SINGLE)
	e17:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e17:SetCode(EFFECT_IMMUNE_EFFECT)
	e17:SetRange(LOCATION_MZONE)
	e17:SetValue(c36541451.spell_immunity)
	c:RegisterEffect(e17)
	--spsummon (SYNCHRO)
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(36541451,1))
	e10:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e10:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e10:SetProperty(EFFECT_FLAG_DELAY)
	e10:SetCode(EVENT_TO_DECK)
	e10:SetTarget(c36541451.sptg)
	e10:SetOperation(c36541451.spop)
	c:RegisterEffect(e10)
end
--filters
function c36541451.spfilter(c,e,tp)
	return c:IsCode(36541452) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
--attribute condition
function c36541451.attcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsAttribute(ATTRIBUTE_LIGHT)
end
function c36541451.attcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsAttribute(ATTRIBUTE_DARK)
end
function c36541451.attcon3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsAttribute(ATTRIBUTE_WATER)
end
function c36541451.attcon4(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsAttribute(ATTRIBUTE_FIRE)
end
function c36541451.attcon5(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsAttribute(ATTRIBUTE_EARTH)
end
function c36541451.attcon6(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsAttribute(ATTRIBUTE_WIND)
end
function c36541451.attcon7(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsAttribute(ATTRIBUTE_DIVINE)
end
--material check
function c36541451.valcheck(e,c)
	local g=c:GetMaterial()
	local tc1=g:GetFirst()
	local eq1=nil
	local eq2=nil
	local eq3=nil
	local eq4=nil
	local eq5=nil
	local eq6=nil
	local eq7=nil
	local eq8=nil
	if tc1 then
		eq1=tc1:GetEquipGroup()
		g:RemoveCard(tc1)
		local tc2=g:GetFirst()
		if tc2 then
			eq2=tc2:GetEquipGroup()
			g:RemoveCard(tc2)
			eq1:Merge(eq2)
			local tc3=g:GetFirst()
			if tc3 then
				eq3=tc3:GetEquipGroup()
				g:RemoveCard(tc3)
				eq1:Merge(eq3)
				local tc4=g:GetFirst()
				if tc4 then
					eq4=tc4:GetEquipGroup()
					g:RemoveCard(tc4)
					eq1:Merge(eq4)
					local tc5=g:GetFirst()
					if tc5 then
						eq5=tc5:GetEquipGroup()
						g:RemoveCard(tc5)
						eq1:Merge(eq5)
						local tc6=g:GetFirst()
						if tc6 then
							eq6=tc6:GetEquipGroup()
							g:RemoveCard(tc6)
							eq1:Merge(eq6)
							local tc7=g:GetFirst()
							if tc7 then
								eq7=tc7:GetEquipGroup()
								g:RemoveCard(tc7)
								eq1:Merge(eq7)
								local tc8=g:GetFirst()
								if tc8 then
									eq8=tc8:GetEquipGroup()
									eq1:Merge(eq8)
								end
							end
						end
					end
				end
			end
		end
	end
	eq1:KeepAlive()
	e:SetLabelObject(eq1)
end
--equip
function c36541451.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c36541451.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local equip=e:GetLabelObject():GetLabelObject()
	if not equip then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>equip:GetCount()
		and Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_GRAVE,0,1,nil,TYPE_MONSTER) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,equip:GetCount()+1,tp,LOCATION_GRAVE)
end
function c36541451.eqop(e,tp,eg,ep,ev,re,r,rp)
	local equip=e:GetLabelObject():GetLabelObject()
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft<equip:GetCount() then return end
	if ft>equip:GetCount() then ft=equip:GetCount() end
	if ft==0 then return end
	for i=1,ft do
		local ec=equip:Select(tp,1,1,nil):GetFirst()
		equip:RemoveCard(ec)
		if Duel.Equip(tp,ec,c,true,true)~=0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(c36541451.eqlimit)
			ec:RegisterEffect(e1)
		end
	end
	local eq=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_GRAVE,0,1,1,nil,TYPE_MONSTER)
	local exeq=eq:GetFirst()
	if not Duel.Equip(tp,exeq,c,false) then return end
	--equip limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(c36541451.eqlimit)
	exeq:RegisterEffect(e1)
	Duel.EquipComplete()
end
function c36541451.eqlimit(e,c)
	return e:GetOwner()==c
end
--attribute gain	
function c36541451.attgain1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local eq=c:GetEquipGroup()
	return eq:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_LIGHT)
end
function c36541451.attgain2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local eq=c:GetEquipGroup()
	return eq:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_DARK)
end
function c36541451.attgain3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local eq=c:GetEquipGroup()
	return eq:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_WATER)
end
function c36541451.attgain4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local eq=c:GetEquipGroup()
	return eq:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_FIRE)
end
function c36541451.attgain5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local eq=c:GetEquipGroup()
	return eq:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_EARTH)
end
function c36541451.attgain6(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local eq=c:GetEquipGroup()
	return eq:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_WIND)
end
function c36541451.attgain7(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local eq=c:GetEquipGroup()
	return eq:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_DIVINE)
end
--immunity value	
function c36541451.spell_immunity(e,te)
	return te:IsActiveType(TYPE_SPELL) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end	
function c36541451.efilter1(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:GetHandler():GetAttribute()==ATTRIBUTE_LIGHT
end
function c36541451.efilter2(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:GetHandler():GetAttribute()==ATTRIBUTE_DARK
end	
function c36541451.efilter3(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:GetHandler():GetAttribute()==ATTRIBUTE_WATER
end	
function c36541451.efilter4(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:GetHandler():GetAttribute()==ATTRIBUTE_FIRE
end	
function c36541451.efilter5(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:GetHandler():GetAttribute()==ATTRIBUTE_EARTH
end	
function c36541451.efilter6(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:GetHandler():GetAttribute()==ATTRIBUTE_WIND
end	
function c36541451.efilter7(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:GetHandler():GetAttribute()==ATTRIBUTE_DIVINE
end			
--spsummon
function c36541451.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c36541451.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c36541451.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c36541451.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
	end
end