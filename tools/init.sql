#!/bin/sh

sqlite3 /tmp/lgwdb.sqlite  "CREATE TABLE IF NOT EXISTS `livepkts` (\
  `id`  INTEGER PRIMARY KEY AUTOINCREMENT,\
  `time`  TEXT NOT NULL DEFAULT (strftime('%m/%d-%H:%M:%S',datetime('now', 'localtime'))),\
  `servname`  TEXT,\
  `servtype`  TEXT,\
  `pdtype`  TEXT,\
  `mod`  TEXT DEFAULT 'LoRa',\
  `freq`  TEXT,\
  `dr`  TEXT,\
  `cnt`  TEXT,\
  `devaddr` TEXT,\
  `content` TEXT,\
  `payload` TEXT)"

sqlite3 /tmp/lgwdb.sqlite "CREATE TABLE IF NOT EXISTS gwdb(key VARCHAR(256), value VARCHAR(512), PRIMARY KEY(key))"

sqlite3 /tmp/lgwdb.sqlite "CREATE TRIGGER IF NOT EXISTS `trg_clean_pkt` AFTER INSERT ON livepkts BEGIN \
    INSERT OR REPLACE INTO gwdb VALUES('/fwd/pkts/total', (SELECT ifnull(1+(SELECT value FROM gwdb WHERE key LIKE '/fwd/pkts/total'), 1)));\
    DELETE FROM livepkts WHERE id < ((SELECT id FROM livepkts ORDER BY id DESC LIMIT 1) - 128);\
    END;"

sqlite3 /tmp/lgwdb.sqlite "CREATE TRIGGER IF NOT EXISTS `trg_up_hours` AFTER INSERT ON LIVEPKTS WHEN new.pdtype LIKE '%'||'UP' BEGIN \
    INSERT OR REPLACE INTO gwdb VALUES('/fwd/pkts/up/total', (SELECT ifnull(1+(SELECT value FROM gwdb WHERE key LIKE '/fwd/pkts/up/total'), 1)));\
    INSERT OR REPLACE INTO gwdb SELECT '/fwd/pkts/hours/up/'||strftime('%m/%d-%H',datetime('now', 'localtime')), (SELECT ifnull(1+(SELECT value FROM gwdb WHERE key LIKE '/fwd/pkts/hours/up/'|| strftime('%m/%d-%H',datetime('now', 'localtime'))), 1));\
    INSERT OR REPLACE INTO gwdb SELECT '/fwd/pkts/hours/down/'||strftime('%m/%d-%H',datetime('now', 'localtime')), (SELECT ifnull(0+(SELECT value FROM gwdb WHERE key LIKE '/fwd/pkts/hours/down/'|| strftime('%m/%d-%H',datetime('now', 'localtime'))), 0));\
    END;"

sqlite3 /tmp/lgwdb.sqlite "CREATE TRIGGER IF NOT EXISTS `trg_down_hours` AFTER INSERT ON LIVEPKTS WHEN new.pdtype LIKE '%'||'DOWN' BEGIN \
    INSERT OR REPLACE INTO gwdb values('/fwd/pkts/down/total', (SELECT ifnull(1+(SELECT value FROM gwdb WHERE key LIKE '/fwd/pkts/down/total'), 1)));\
    INSERT OR REPLACE INTO gwdb SELECT '/fwd/pkts/hours/up/'||strftime('%m/%d-%H',datetime('now', 'localtime')), (SELECT ifnull(0+(SELECT value FROM gwdb WHERE key LIKE '/fwd/pkts/hours/up/'|| strftime('%m/%d-%H',datetime('now', 'localtime'))), 0));\
    INSERT OR REPLACE INTO gwdb SELECT '/fwd/pkts/hours/down/'||strftime('%m/%d-%H',datetime('now', 'localtime')), (SELECT ifnull(1+(SELECT value FROM gwdb WHERE key LIKE '/fwd/pkts/hours/down/'|| strftime('%m/%d-%H',datetime('now', 'localtime'))), 1));\
    END;"
