-- campaigns per user:
SELECT c.owner, COUNT(*) campaigns
	, SUM(CASE WHEN lfp.uid IS NULL THEN 0 ELSE 1 END) AS lfp_campaigns
FROM campaigns c
LEFT JOIN lfp lfp ON lfp.campaign = c.uid
WHERE c.messagesCount > 0
GROUP BY c.owner

