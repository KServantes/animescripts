--Ｓｐ－浅すぎた墓穴
function c100100027.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(c100100027.cost)
	e1:SetTarget(c100100027.target)
	e1:SetOperation(c100100027.operation)
	c:RegisterEffect(e1)
end
function c100100027.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	if chk==0 then return tc and tc:IsCanRemoveCounter(tp,0x91,3,REASON_COST) end
	tc:RemoveCounter(tp,0x91,3,REASON_COST)
end
function c100100027.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENCE)
end
function c100100027.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then
		return Duel.IsExistingTarget(c100100027.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingTarget(c100100027.filter,1-tp,LOCATION_GRAVE,0,1,nil,e,1-tp)
			and Duel.GetLocationCount(1-tp,LOCATION_MZONE,1-tp)>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectTarget(tp,c100100027.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
	local og=Duel.SelectTarget(1-tp,c100100027.filter,1-tp,LOCATION_GRAVE,0,1,1,nil,e,1-tp)
	local sc=sg:GetFirst()
	local oc=og:GetFirst()
	local g=Group.FromCards(sc,oc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,2,0,0)
	e:SetLabelObject(sc)
end
function c100100027.operation(e,tp,eg,ep,ev,re,r,rp)
	local sc=e:GetLabelObject()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local oc=g:GetFirst()
	if oc==sc then oc=g:GetNext() end
	if sc:IsRelateToEffect(e) then
		Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEDOWN_DEFENCE)
	end
	if oc:IsRelateToEffect(e) then
		Duel.SpecialSummonStep(oc,0,1-tp,1-tp,false,false,POS_FACEDOWN_DEFENCE)
	end
	Duel.SpecialSummonComplete()
end
