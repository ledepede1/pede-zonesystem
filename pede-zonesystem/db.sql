CREATE TABLE `zone-system` (
  `name` varchar(55) NOT NULL,
  `owner` varchar(46) DEFAULT NULL,
  `points` bigint(20) NOT NULL,
  `label` varchar(255) NOT NULL,
  `coords` varchar(2555) NOT NULL,
  `alliances` mediumtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `zone-settings` (
  `fivem-license` varchar(255) DEFAULT NULL,
  `zone-blips` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
