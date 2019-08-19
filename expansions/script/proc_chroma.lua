EFFECT_CANNOT_BE_CHROMA_MATERIAL	=779
EFFECT_MUST_BE_CHROMA_MATERIAL		=780
TYPE_CHROMA							=0x1000000000000
TYPE_CUSTOM							=TYPE_CUSTOM|TYPE_CHROMA
CTYPE_CHROMA						=0x10000
CTYPE_CUSTOM						=CTYPE_CUSTOM|CTYPE_CHROMA

REASON_CHROMA						=0x1000000000

--Custom Type Table
Auxiliary.Chromas={} --number as index = card, card as index = function() is_ritual

--overwrite functions
local get_type, get_orig_type, get_prev_type_field, get_reason = 
	Card.GetType, Card.GetOriginalType, Card.GetPreviousTypeOnField, Card.GetReason

Card.GetType=function(c,scard,sumtype,p)
	local tpe=scard and get_type(c,scard,sumtype,p) or get_type(c)
	if Auxiliary.Chromas[c] then
		tpe=tpe|TYPE_CHROMA
		if not Auxiliary.Chromas[c]() then
			tpe=tpe&~TYPE_RITUAL
		end
	end
	return tpe
end
Card.GetOriginalType=function(c)
	local tpe=get_orig_type(c)
	if Auxiliary.Chromas[c] then
		tpe=tpe|TYPE_CHROMA
		if not Auxiliary.Chromas[c]() then
			tpe=tpe&~TYPE_RITUAL
		end
	end
	return tpe
end
Card.GetPreviousTypeOnField=function(c)
	local tpe=get_prev_type_field(c)
	if Auxiliary.Chromas[c] then
		tpe=tpe|TYPE_CHROMA
		if not Auxiliary.Chromas[c]() then
			tpe=tpe&~TYPE_RITUAL
		end
	end
	return tpe
end
Card.GetReason=function(c)
	local rs=get_reason(c)
	local rc=c:GetReasonCard()
	if rc and Auxiliary.Chromas[rc] then
		rs=rs|REASON_CHROMA
	end
	return rs
end

--Custom Functions
function Card.IsCanBeChromaMaterial(c,cc)
	if c:IsStatus(STATUS_NO_LEVEL) or c:IsFacedown() then return false end
	local tef2={c:IsHasEffect(EFFECT_CANNOT_BE_CHROMA_MATERIAL)}
	for _,te2 in ipairs(tef2) do
		if te2:GetValue()(te2,cc) then return false end
	end
	return true
end
function Auxiliary.AddOrigChromaType(c,isritual)
	table.insert(Auxiliary.Chromas,c)
	Auxiliary.Customs[c]=true
	local isritual=isritual==nil and false or isritual
	Auxiliary.Chromas[c]=function() return isritual end
end
function Auxiliary.AddChromaProc(c,f)
	if not CHROMA_CHECKLIST then
		CHROMA_CHECKLIST=0
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge1:SetOperation(Auxiliary.ChromaReset)
		Duel.RegisterEffect(ge1,0)
	end
	local ge2=Effect.CreateEffect(c)
	ge2:SetType(EFFECT_TYPE_FIELD)
	ge2:SetCode(EFFECT_SPSUMMON_PROC_G)
	ge2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	ge2:SetRange(LOCATION_HAND)
	ge2:SetCondition(Auxiliary.ChromaCondition(f))
	ge2:SetOperation(Auxiliary.ChromaOperation(f))
	ge2:SetValue(14)
	c:RegisterEffect(ge2)
end
function Auxiliary.ChromaReset(e,tp,eg,ep,ev,re,r,rp)
	CHROMA_CHECKLIST=0
end
function Auxiliary.CMaterialFilter(c,e,tp,g,cc,f)
	local sg,mg=Group.FromCards(cc),Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	return c:IsLevelAbove(1) and not c:IsType(TYPE_CHROMA) and (not f or f(c))
		and mg:IsExists(Auxiliary.CConditionFilter,1,sg,e,tp,sg,mg,c)
end
function Auxiliary.CConditionFilter(c,e,tp,sg,mg,mat)
	if not (c:IsType(TYPE_CHROMA) and (c:IsAttribute(mat:GetAttribute()) or c:IsRace(mat:GetRace()))
		and c:IsCanBeSpecialSummoned(e,14,tp,true,true) and not c:IsForbidden()) then return false end
	sg:AddCard(c)
	local res=Auxiliary.ChromaGoal(sg,e,tp,mat)
		or mg:IsExists(Auxiliary.CConditionFilter,1,sg,e,tp,sg,mg,mat)
	sg:RemoveCard(c)
	return res
end
function Auxiliary.ChromaGoal(sg,e,tp,mat)
	local ct=#sg
	return ct>1 and Duel.GetMZoneCount(tp,mat)>=ct
		and mat:GetLevel()==sg:GetSum(Card.GetLevel)
	and sg:IsExists(Card.IsCanBeChromaMaterial,ct,nil,mat)
end
function Auxiliary.ChromaCondition(f)
	return	function(e,c,og)
				if c==nil then return true end
				local tp=c:GetControler()
				local g=nil
				if og then
					g=og:Filter(Card.IsLocation,nil,LOCATION_MZONE)
				else
					g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
				end
				return g:IsExists(Auxiliary.CMaterialFilter,1,nil,e,tp,g,c,f)
			end
end
function Auxiliary.ChromaOperationCheck(ft)
	return	function(g)
				return #g<=ft
			end
end
function Auxiliary.ChromaOperation(f)
	return	function(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
				local tg=nil
				if og then
					tg=og:Filter(Card.IsLocation,nil,LOCATION_MZONE)
				else
					tg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
				end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local tc=tg:Select(tp,Auxiliary.CMaterialFilter,1,1,nil,e,tp,tg,c,f):GetFirst()
				local ft=Duel.GetMZoneCount(tp,tc)
				if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
				local sg=Group.FromCards(c)
				local mg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
				mg=mg:Filter(Auxiliary.CConditionFilter,sg,e,tp,sg,mg,tc)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				Auxiliary.GCheckAdditional=Auxiliary.ChromaOperationCheck(ft)
				local g=mg:SelectSubGroup(tp,Auxiliary.ChromaGoal,true,2,math.min(#mg,ft),e,tp,tc)
				Auxiliary.GCheckAdditional=nil
				if not g then return end
				CHROMA_CHECKLIST=CHROMA_CHECKLIST|(0x1<<tp)
				Duel.HintSelection(Group.FromCards(tc))
				Duel.SendtoGrave(tc,REASON_MATERIAL+REASON_CHROMA)
				tc:SetMaterial(g)
				sg:Merge(g)
			end
end
