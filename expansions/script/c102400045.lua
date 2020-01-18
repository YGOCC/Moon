--created & coded by Lyris, art from Shadowverse's "Mechagun Wielder"
--滅却砲兵ブラスター
local cid,id=GetID()
function cid.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetTarget(cid.destg)
	e1:SetOperation(cid.desop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetTarget(cid.sptg)
	e4:SetOperation(cid.spop)
	c:RegisterEffect(e4)
end
function cid.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_REMOVED,0)>0 end
	local ct={}
	for i=3,1,-1 do
		if Duel.GetFieldCard(tp,LOCATION_REMOVED,i) then
			table.insert(ct,i)
		end
	end
	if #ct==1 then
		Duel.AnnounceNumber(tp,1)
		e:SetLabel(1)
	else
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,0))
		e:SetLabel(Duel.AnnounceNumber(tp,table.unpack(ct)))
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,e:GetLabel(),tp,LOCATION_REMOVED)
end
function cid.desop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local g=Duel.GetFieldGroup(tp,LOCATION_REMOVED,0):Filter(aux.NOT(Card.IsImmuneToEffect),nil,e)
	if #g<ct then return end
	Duel.SendtoGrave(g:RandomSelect(tp,ct),REASON_EFFECT+REASON_RETURN)
	local sg=Duel.GetOperatedGroup()
	if #sg~=ct then return end
	local dt=sg:FilterCount(Card.IsSetCard,nil,0x5cd)
	local dg=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
	if #dg>0 and Duel.SelectYesNo(tp,1124) then
		local rg=dg:Select(tp,1,dt,nil)
		Duel.HintSelection(rg)
		Duel.Destroy(rg,REASON_EFFECT)
	end
end
function cid.filter(c,e,tp)
	return c:IsSetCard(0x5cd) and not c:IsCode(id) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cid.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cid.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cid.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cid.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		e1:SetValue(LOCATION_REMOVED)
		g:GetFirst():RegisterEffect(e1)
	end
end
