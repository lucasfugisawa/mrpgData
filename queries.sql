SELECT c.owner, COUNT(*) campaigns
	, SUM(CASE WHEN lfp.uid IS NULL THEN 0 ELSE 1 END) AS lfp_campaigns
FROM campaigns c
LEFT JOIN lfp lfp ON lfp.campaign = c.uid
WHERE c.messagesCount > 0
GROUP BY c.owner

--

SELECT c.owner, COUNT(*) campaigns
	, SUM(CASE WHEN lfp.uid IS NULL THEN 0 ELSE 1 END) AS lfp_campaigns
FROM campaigns c
LEFT JOIN lfp lfp ON lfp.campaign = c.uid
WHERE c.messagesCount > 0
	AND c.contact = 0
GROUP BY c.owner
ORDER BY count(*) DESC

SELECT *
FROM (
	SELECT c.lastActiveAt
		, date('now') - datetime(c.lastActiveAt, 'unixepoch') elapsed
	FROM campaigns c
)
ORDER BY elapsed DESC

--

SELECT users.uid
	, SUM(CASE WHEN camps.uid IS NULL THEN 0 ELSE 1 END) AS campaignsTotal
	, SUM(CASE WHEN campsOwn.owner IS NULL THEN 0 ELSE 1 END) AS campaignsOwned
	, SUM(CASE WHEN ((strftime('%s', 'now') - camps.lastActiveAt / 1000) / (60*60*24) <= 7) THEN 1 ELSE 0 END) AS campaignsActiveLast7days
	, SUM(CASE WHEN ((strftime('%s', 'now') - camps.lastActiveAt / 1000) / (60*60*24) <= 14) THEN 1 ELSE 0 END) AS campaignsActiveLast14days
	, SUM(CASE WHEN ((strftime('%s', 'now') - camps.lastActiveAt / 1000) / (60*60*24) <= 21) THEN 1 ELSE 0 END) AS campaignsActiveLast21days
	, SUM(CASE WHEN ((strftime('%s', 'now') - camps.lastActiveAt / 1000) / (60*60*24) <= 28) THEN 1 ELSE 0 END) AS campaignsActiveLast28days
	, SUM(CASE WHEN ((strftime('%s', 'now') - camps.lastActiveAt / 1000) / (60*60*24) <= 56) THEN 1 ELSE 0 END) AS campaignsActiveLast56days
	, SUM(CASE WHEN ((strftime('%s', 'now') - camps.lastActiveAt / 1000) / (60*60*24) <= 84) THEN 1 ELSE 0 END) AS campaignsActiveLast84days
	, SUM(CASE WHEN ((strftime('%s', 'now') - camps.lastActiveAt / 1000) / (60*60*24) <= 168) THEN 1 ELSE 0 END) AS campaignsActiveLast168days
	, SUM(CASE WHEN ((strftime('%s', 'now') - camps.lastActiveAt / 1000) / (60*60*24) <= 336) THEN 1 ELSE 0 END) AS campaignsActiveLast336days
	, SUM(CASE WHEN lfp.uid IS NULL THEN 0 ELSE 1 END) AS lfp
FROM users users
LEFT JOIN campaigns_members campMembers ON campMembers.user = users.uid
LEFT JOIN campaigns camps ON camps.uid = campMembers.campaign
LEFT JOIN campaigns campsOwn ON campsOwn.owner = users.uid AND campsOwn.contact = 0
LEFT JOIN lfp lfp ON lfp.campaign = camps.uid
LEFT JOIN lfp_asking_to_join askJoin ON askJoin.user = camps.owner
GROUP BY users.uid