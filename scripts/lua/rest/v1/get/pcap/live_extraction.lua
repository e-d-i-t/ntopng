--
-- (C) 2013-20 - ntop.org
--

local dirs = ntop.getDirs()
package.path = dirs.installdir .. "/scripts/lua/modules/?.lua;" .. package.path
require "lua_utils"
local json = require("dkjson")
local recording_utils = require "recording_utils"
local rest_utils = require("rest_utils")

--
-- Run a traffic extraction
-- Example: curl -u admin:admin -d '{"ifid": "1", "epoch_begin": 1589822000, "epoch_end": 15898221000 }' http://localhost:3000/lua/rest/v1/get/pcap/live_extraction.lua
--
-- NOTE: in case of invalid login, no error is returned but redirected to login
--

local ifid = tonumber(_GET["ifid"])
local filter = _GET["bpf_filter"]
local time_from = tonumber(_GET["epoch_begin"])
local time_to = tonumber(_GET["epoch_end"])

local rc = rest_utils.consts_ok

if not recording_utils.isExtractionAvailable() then
   sendHTTPHeader('application/json')
   rc = rest_utils.consts_not_granted
   print(rest_utils.rc(rc))
   return
end

if isEmptyString(ifid) then
   sendHTTPHeader('application/json')
   rc = rest_utils.consts_invalid_interface
   print(rest_utils.rc(rc))
   return
end

if _GET["epoch_begin"] == nil or _GET["epoch_end"] == nil then
   sendHTTPHeader('application/json')
   rc = rest_utils.consts_invalid_arguments
   print(rest_utils.rc(rc))
   return
end

interface.select(ifid)

if filter == nil then
   filter = ""
end

local timeline_path
if recording_utils.getCurrentTrafficRecordingProvider(ifid) ~= "ntopng" then
   timeline_path = recording_utils.getCurrentTrafficRecordingProviderTimelinePath(ifid)
end

local fname = time_from.."-"..time_to..".pcap"
sendHTTPContentTypeHeader('application/vnd.tcpdump.pcap', 'attachment; filename="'..fname..'"')

ntop.runLiveExtraction(ifid, time_from, time_to, filter, timeline_path)

